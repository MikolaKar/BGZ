
//////////////////////////////////////////////////////////////////////////////// 
// ПРОЦЕДУРЫ И ФУНКЦИИ 
// 

&НаСервере
Процедура ЗаполнитьРеквизиты()

	Объект.Организация = Объект.НоменклатураДел.Организация;
	Объект.Подразделение = 
		ОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.НоменклатураДел.Раздел, "Подразделение");

	Если Не ЗначениеЗаполнено(Объект.НоменклатураДел) Тогда 
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Дела.НомерТома КАК НомерТома,
	|	Дела.ДатаНачала,
	|	Дела.ДатаОкончания
	|ИЗ
	|	Справочник.ДелаХраненияДокументов КАК Дела
	|ГДЕ
	|	Дела.НоменклатураДел = &НоменклатураДел
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерТома УБЫВ";
	Запрос.УстановитьПараметр("НоменклатураДел", Объект.НоменклатураДел);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Объект.НомерТома = 1;
		Объект.ДатаНачала = Дата(Объект.НоменклатураДел.Год, 1, 1);
		Возврат;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
		
	Объект.НомерТома = Выборка.НомерТома + 1;
	Если ЗначениеЗаполнено(Выборка.ДатаОкончания) Тогда 
		Объект.ДатаНачала = Выборка.ДатаОкончания + 3600 * 24;
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ЗакрытьДело()
	
	Если Объект.Ссылка.Пустая() Тогда 
		Возврат;
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(МАКСИМУМ(ДокументыВДелеТоме.Ссылка.ДатаРегистрации), ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаОкончания,
	|	ЕСТЬNULL(СУММА(ДокументыВДелеТоме.Ссылка.КоличествоЛистов), 0) КАК КоличествоЛистов,
	|	ЕСТЬNULL(СУММА(ДокументыВДелеТоме.Ссылка.ЛистовВПриложениях), 0) КАК ЛистовВПриложениях
	|ИЗ
	|	КритерийОтбора.ДокументыВДелеТоме(&ЗначениеОтбора) КАК ДокументыВДелеТоме
	|ГДЕ
	|	(НЕ ДокументыВДелеТоме.Ссылка.ПометкаУдаления)";
	Запрос.УстановитьПараметр("ЗначениеОтбора", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат;
	КонецЕсли;	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Если Не ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда
		Объект.ДатаОкончания = Выборка.ДатаОкончания;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Объект.КоличествоЛистов) Тогда
		Объект.КоличествоЛистов = Выборка.КоличествоЛистов + Выборка.ЛистовВПриложениях;
	КонецЕсли;	
	
КонецПроцедуры	

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
// 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПротоколированиеРаботыПользователей.ЗаписатьОткрытие(Объект.Ссылка);
	
	Если Объект.Ссылка.Пустая() Тогда
		Если ЗначениеЗаполнено(Объект.НоменклатураДел) Тогда 
			ЗаполнитьРеквизиты();
		Иначе
			Объект.НомерТома = 1;
		КонецЕсли;	
	КонецЕсли;	
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СостоянияДелХраненияДокументов.Состояние КАК Состояние,
		|	СостоянияДелХраненияДокументов.Период КАК Период,
		|	СостоянияДелХраненияДокументов.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.СостоянияДелХраненияДокументов.СрезПоследних(, ДелоХраненияДокументов = &Дело) КАК СостоянияДелХраненияДокументов";
		Запрос.УстановитьПараметр("Дело", Объект.Ссылка);
		
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда 
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			Регистратор = Выборка.Регистратор;
			
			Если Выборка.Состояние = Перечисления.СостоянияДелХраненияДокументов.ПереданоВАрхив Тогда 
				Состояние = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело передано в архив %1'"), Формат(Выборка.Период,"ДФ=dd.MM.yyyy"));
				Элементы.ДелоЗакрыто.Доступность = Ложь;
			ИначеЕсли Выборка.Состояние = Перечисления.СостоянияДелХраненияДокументов.Уничтожено Тогда 
				Состояние = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело уничтожено %1'"), Формат(Выборка.Период,"ДФ=dd.MM.yyyy"));
				Элементы.ДелоЗакрыто.Доступность = Ложь;
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;	
	Элементы.Состояние.Видимость = ЗначениеЗаполнено(Состояние);
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	РаботаСПоследнимиОбъектами.ЗаписатьОбращениеКОбъекту(Объект.Ссылка);
	
	// Инструкции
	ПоказыватьИнструкции = ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции");
	ПолучитьИнструкции();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Оповестить("ОбновитьСписокПоследних");
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", НЕ ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
		
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПротоколированиеРаботыПользователей.ЗаписатьСоздание(Объект.Ссылка, ПараметрыЗаписи.ЭтоНовыйОбъект);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСПоследнимиОбъектами.ЗаписатьОбращениеКОбъекту(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененаНоменклатураДел" И Параметр = Объект.НоменклатураДел Тогда 
		Прочитать();
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки["ПоказыватьИнструкции"] <> Неопределено
		И ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции") Тогда
		ПолучитьИнструкции();
	КонецЕсли;
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
// 

&НаКлиенте
Процедура НоменклатураДелНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтрока", Объект.НоменклатураДел);
	
	Если ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		ПараметрыФормы.Вставить("Год", Год(Объект.ДатаНачала));
	Иначе
		ПараметрыФормы.Вставить("Год", Год(ТекущаяДата()));
	КонецЕсли;	
	ОткрытьФорму("Справочник.НоменклатураДел.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураДелПриИзменении(Элемент)
	
	ЗаполнитьРеквизиты();
	
КонецПроцедуры

&НаКлиенте
Процедура ДелоЗакрытоПриИзменении(Элемент)
	
	Если Объект.ДелоЗакрыто Тогда 
		ЗакрытьДело();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Регистратор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереносДокументовДела(Команда)
	
	ПараметрыФормы = Новый Структура("ПеренестиИзДела", Объект.Ссылка);
	Открытьформу("Справочник.ДелаХраненияДокументов.Форма.ФормаПереносаДокументовДела", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
  Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
    РезультатВыполнения = Неопределено;
    ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
    ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
  КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
  ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

////////////////////////////////////////////////////////////////////////////////
// ИНСТРУКЦИИ
//

&НаСервере
Процедура ПолучитьИнструкции()
	
	РаботаСИнструкциями.ПолучитьИнструкции(ЭтаФорма, 65, 95);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСИнструкциямиКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element, Элемент.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьИнструкции(Команда)
	
	ПоказыватьИнструкции = Не ПоказыватьИнструкции;
	ПолучитьИнструкции();
	
КонецПроцедуры

