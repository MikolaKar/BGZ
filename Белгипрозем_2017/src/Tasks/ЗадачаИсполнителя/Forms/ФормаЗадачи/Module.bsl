////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПротоколированиеРаботыПользователей.ЗаписатьОткрытие(Объект.Ссылка);
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Если Объект.Ссылка.Пустая() Тогда
		ИнициализацияФормы();
	КонецЕсли;
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, Объект, "ГруппаДополнительныеРеквизиты");
	
	Для Каждого СтрокаПредмета Из Объект.Предметы Цикл
		СтрокаПредмета.Картинка = МультипредметностьКлиентСервер.ИндексКартинкиРолиПредмета(
			СтрокаПредмета.РольПредмета, ?(СтрокаПредмета.Предмет = Неопределено, Ложь, СтрокаПредмета.Предмет.ПометкаУдаления));
		СтрокаПредмета.Описание = ОбщегоНазначенияДокументооборот.ПредметСтрокой(СтрокаПредмета.Предмет,СтрокаПредмета.ИмяПредмета);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализацияФормы();
			
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", НЕ ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Оповестить("ОбновитьСписокПоследних");
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПротоколированиеРаботыПользователей.ЗаписатьСоздание(Объект.Ссылка, ПараметрыЗаписи.ЭтоНовыйОбъект);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполненаВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОткрытьФормуЗадачиНажатие(Элемент)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Объект.Ссылка);
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИсполненияПриИзменении(Элемент)
	
	Если Объект.ДатаИсполнения = НачалоДня(Объект.ДатаИсполнения) Тогда
		Объект.ДатаИсполнения = КонецДня(Объект.ДатаИсполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подписаться(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("ОбъектПодписки", Объект.Ссылка);
		ОткрытьФорму("ОбщаяФорма.ПодпискаНаУведомленияПоОбъекту", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ИнициализацияФормы()
	
	Если ЗначениеЗаполнено(Объект.БизнесПроцесс) Тогда
		ПараметрыФормы = БизнесПроцессыИЗадачиВызовСервера.ПолучитьФормуВыполненияЗадачи(Объект.Ссылка);
		ЕстьФормаЗадачи = ПараметрыФормы.Свойство("ИмяФормы");
		Элементы.ГруппаФормаВыполнения.Видимость = ЕстьФормаЗадачи;
		Элементы.Выполнена.Доступность = НЕ ЕстьФормаЗадачи;
	Иначе
		Элементы.ГруппаФормаВыполнения.Видимость = Ложь;
	КонецЕсли;
	НачальныйПризнакВыполнения = Объект.Выполнена;
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
		Объект.СрокИсполнения = ТекущаяДатаСеанса();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ПредметСтрокой = МультипредметностьКлиентСервер.ПредметыСтрокой(Объект.Предметы);
	УстановитьПривилегированныйРежим(Ложь);
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.СрокИсполнения);
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.Дата);
	
	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
		Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ СВОЙСТВ

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма,
		РеквизитФормыВЗначение("Объект"));

КонецПроцедуры

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	МультипредметностьКлиент.ПредметыВыбор(Объект.Предметы, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры
