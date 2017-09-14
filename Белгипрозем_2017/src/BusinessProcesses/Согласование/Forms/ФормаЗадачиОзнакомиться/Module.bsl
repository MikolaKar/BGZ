
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессами.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
		Элементы.СрокИсполнения, Элементы.ДатаИсполнения);
	
	РаботаСБизнесПроцессами.УстановитьФорматДаты(Элементы.ХодИсполненияДатаИсполнения);
	
	// номер итерации
	НайденнаяСтрока = Объект.БизнесПроцесс.РезультатыОзнакомлений.Найти(Объект.Ссылка, "ЗадачаИсполнителя");
	Если НайденнаяСтрока <> Неопределено Тогда 
		НомерИтерации = НайденнаяСтрока.НомерИтерации;
	КонецЕсли;	
	
	// результат согласования
	РезультатСогласования = Перечисления.РезультатыСогласования.Согласовано;
	СтрокиИтерации = Объект.БизнесПроцесс.РезультатыСогласования.НайтиСтроки(Новый Структура("НомерИтерации", НомерИтерации));
	Для Каждого Строка Из СтрокиИтерации Цикл
		Если Строка.РезультатСогласования = Перечисления.РезультатыСогласования.НеСогласовано Тогда 
			РезультатСогласования = Перечисления.РезультатыСогласования.НеСогласовано;
			Прервать;
		КонецЕсли;	
		
		Если Строка.РезультатСогласования = Перечисления.РезультатыСогласования.СогласованоСЗамечаниями Тогда 
			РезультатСогласования = Перечисления.РезультатыСогласования.СогласованоСЗамечаниями;
		КонецЕсли;	
	КонецЦикла;	
	
	// цвет результата
	Если (РезультатСогласования = Перечисления.РезультатыСогласования.Согласовано) 
	 Или (РезультатСогласования = Перечисления.РезультатыСогласования.СогласованоСЗамечаниями) Тогда 
		Элементы.РезультатСогласования.ЦветТекста = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
		
	ИначеЕсли РезультатСогласования = Перечисления.РезультатыСогласования.НеСогласовано Тогда 
		Элементы.РезультатСогласования.ЦветТекста = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
		
	КонецЕсли;
	
	// динамический список
	ТочкиМаршрута = Новый Массив;
	ТочкиМаршрута.Добавить(БизнесПроцессы.Согласование.ТочкиМаршрута.Согласовать);
	
	ХодИсполнения.Параметры.УстановитьЗначениеПараметра("ТочкиМаршрута", ТочкиМаршрута);
	ХодИсполнения.Параметры.УстановитьЗначениеПараметра("БизнесПроцесс", Объект.БизнесПроцесс);
	ХодИсполнения.Параметры.УстановитьЗначениеПараметра("НомерИтерации", НомерИтерации);
	
	// заголовки кнопок
	Если РезультатСогласования = Перечисления.РезультатыСогласования.НеСогласовано Тогда 
		Элементы.Ознакомился.Заголовок = НСтр("ru = 'Завершить согласование'");
	Иначе	
		Элементы.Повторить.Видимость = Ложь;
	КонецЕсли;
	
	// Заполнение текста результата выполнения для выполненной задачи
	НайденнаяСтрока = Объект.БизнесПроцесс.РезультатыОзнакомлений.Найти(Объект.Ссылка, "ЗадачаИсполнителя");
	Если НайденнаяСтрока <> Неопределено Тогда 
		Если НайденнаяСтрока.ОтправленоНаПовторноеСогласование Тогда
			Элементы.ТекстРезультатаВыполнения.Заголовок = НСТР("ru = 'Отправлено на повторное согласование.'");
			Элементы.ТекстРезультатаВыполнения.ЦветТекста = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
		Иначе	
			Элементы.ТекстРезультатаВыполнения.Заголовок = НСТР("ru = 'Ознакомился.'");
			Элементы.ТекстРезультатаВыполнения.ЦветТекста = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
		КонецЕсли;
	КонецЕсли;	
	
	Если НомерИтерации <= 1 Тогда 
		Элементы.НомерИтерации.Видимость = Ложь;
		Элементы.История.Видимость = Ложь;
	КонецЕсли;	
	
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		Объект.Ссылка,
		ВидыРабот,
		СпособУказанияВремени,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		ЭтаФорма.Элементы.УказатьТрудозатраты);
	
	РаботаСПроектами.ЗаполнитьТрудозатратыПланСтрокой(
		ЭтаФорма,
		Объект.БизнесПроцесс.ТрудозатратыПланАвтора);
	
	БизнесПроцессыИЗадачиВызовСервера.ЗаписатьСобытиеОткрытаКарточкаИОбращениеКОбъекту(Объект.Ссылка);
	
	ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка);
	Если Не ПраваПоОбъекту.Изменение Тогда
		ТолькоПросмотр = Истина;
		Элементы.Ознакомился.Доступность = Ложь;
		Элементы.Повторить.Доступность = Ложь;
		Элементы.ДобавитьПредмет.Доступность = Ложь;
		Элементы.ДеревоПриложений.ТолькоПросмотр = Истина;
		Элементы.Перенаправить.Доступность = Ложь;
		Элементы.ФормаПринятьКИсполнению.Доступность = Ложь;
		Элементы.ФормаОтменитьПринятиеКИсполнению.Доступность = Ложь;
	КонецЕсли;
	
	Если Объект.СостояниеБизнесПроцесса <> Перечисления.СостоянияБизнесПроцессов.Активен
		Или Объект.Выполнена Тогда
		Элементы.ДобавитьПредмет.Доступность = Ложь;
		Элементы.ДеревоПриложений.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	// Инструкции
	ПоказыватьИнструкции = ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции");
	ПолучитьИнструкции();
	
	УникальныйИдентификаторФормыИзмененияПараметров = УникальныйИдентификатор;
	
	//1С-Минск +
	// прячем кнопку Ознакомился если не согласовано Дело
	Если мПроверкаДела.ПолучитьУровеньШаблонаПроверкиДела(Объект.БизнесПроцесс) > 0 Тогда
		Если РезультатСогласования = Перечисления.РезультатыСогласования.НеСогласовано Тогда
			Элементы.Ознакомился.Доступность = Ложь;
			Элементы.Повторить.Доступность = Истина;
		КонецЕсли; 
	КонецЕсли; 
	//1С-Минск -
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	
	Если ТекущийОбъект.БизнесПроцесс.Завершен Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗаписи.Свойство("ВыполнитьЗадачу") И ПараметрыЗаписи.ВыполнитьЗадачу Тогда 
		
		УстановитьПривилегированныйРежим(Истина);
		СогласованиеОбъект = ТекущийОбъект.БизнесПроцесс.ПолучитьОбъект();
		
		ЗаблокироватьДанныеДляРедактирования(СогласованиеОбъект.Ссылка,, УникальныйИдентификаторФормыИзмененияПараметров);
		СогласованиеОбъект.ПовторитьСогласование = ПараметрыЗаписи.ПовторитьСогласование;
		НайденнаяСтрока = СогласованиеОбъект.РезультатыОзнакомлений.Найти(ТекущийОбъект.Ссылка, "ЗадачаИсполнителя");
		НайденнаяСтрока.ОтправленоНаПовторноеСогласование = ПараметрыЗаписи.ПовторитьСогласование;
		
		СогласованиеОбъект.Записать();
		
	КонецЕсли;	
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыРеквизитыНевыполненныхЗадач" И Параметр = Объект.БизнесПроцесс И Не Объект.Выполнена Тогда 
		
		ДатаИсполнения = Объект.ДатаИсполнения;
		Прочитать();
		Объект.ДатаИсполнения = ДатаИсполнения;
		
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		
		ОбновитьДеревоПриложений();
		
	ИначеЕсли ИмяСобытия = "Изменение_ФактическиеТрудозатратыЗадачи" И Параметр = Объект.Ссылка Тогда
		
		ТрудозатратыФакт = РаботаСБизнесПроцессами.ПолучитьФактическиеТрудозатратыПоЗадаче(Объект.Ссылка);	
		
	ИначеЕсли ИмяСобытия = "ФайлЗанятДляРедактирования" Тогда
		
		ОбновитьДеревоПриложений();
		
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" И Параметр.ИдентификаторРодительскойФормы = УникальныйИдентификатор Тогда
		
		МультипредметностьВызовСервера.ОбработатьДобавлениеПредметаЗадачи(
			Объект.Ссылка, Объект.БизнесПроцесс, Параметр.Файл, УникальныйИдентификатор);
			
		Прочитать();
		ОбновитьДеревоПриложений();
		
	ИначеЕсли ИмяСобытия = "ИзменилсяФлаг"
		И Источник <> ЭтаФорма
		И Параметр.Найти(Объект.Ссылка) <> Неопределено Тогда
		
		РаботаСФлагамиОбъектовКлиентСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "СозданНовыйВопросВыполненияЗадачи" И Параметр = Объект.Ссылка Тогда
		
		БизнесПроцессыИЗадачиКлиентСервер.ЗаполнитьЗаголовокДекорацииЗадатьВопросАвтору(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "ЗадачаИзменена" И Источник <> ЭтаФорма Тогда
		
		ПрочитатьДанныеЗадачиВФорму = Ложь;
		
		Если ТипЗнч(Параметр) = Тип("Массив") Тогда
			ПрочитатьДанныеЗадачиВФорму = Параметр.Найти(Объект.Ссылка) <> Неопределено;
		Иначе
			ПрочитатьДанныеЗадачиВФорму = (Параметр = Объект.Ссылка);
		КонецЕсли;
		
		Если ПрочитатьДанныеЗадачиВФорму Тогда
			Прочитать();
		КонецЕсли;
		
		КомандыРаботыСБизнесПроцессамиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "Перенаправление_ЗадачаИсполнителя" И Источник = Объект.Ссылка Тогда
		Закрыть();
		
	КонецЕсли;
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоПриложений(ТекущееИмяПредметаВДереве = Неопределено)
	
	ТекущаяСсылкаВДереве = Неопределено;
	
	Если Элементы.ДеревоПриложений.ТекущиеДанные <> Неопределено И ТекущееИмяПредметаВДереве = Неопределено Тогда
		ТекущаяСсылкаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.Ссылка;
		ТекущееИмяПредметаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.ИмяПредмета;
	КонецЕсли;
	
	Если Элементы.Найти("ДеревоПриложений") <> Неопределено  Тогда
		ОбновитьДеревоПриложенийСервер();
	КонецЕсли;
	
	Если ТекущаяСсылкаВДереве <> Неопределено ИЛИ ТекущееИмяПредметаВДереве <> Неопределено Тогда
		РаботаСБизнесПроцессамиКлиент.УстановитьТекущуюСтрокуВДеревеПриложений(
			ЭтаФорма, 
			ДеревоПриложений.ПолучитьЭлементы(), 
			ТекущаяСсылкаВДереве, ТекущееИмяПредметаВДереве);
	КонецЕсли;
		
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(
		ЭтаФорма, 
		Элементы.ДеревоПриложений);
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоПриложенийСервер()
	
	РаботаСБизнесПроцессами.ЗаполнитьДеревоПриложений(ЭтаФорма);
	
КонецПроцедуры	

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСБизнесПроцессами.ФормаЗадачиИсполнителяУстановитьВидимостьПредмета(ЭтаФорма);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСФлагамиОбъектовСервер.СохранитьФлагОбъектаИзФормы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Мультипредметность.ИзмененыПредметыЗадачи(Объект.Ссылка) Тогда
			ОбновитьДеревоПриложенийСервер();
		КонецЕсли;
	КонецЕсли;
	
	РаботаСБизнесПроцессами.ФормаЗадачиИсполнителяУстановитьВидимостьПредмета(ЭтаФорма);
	
	Если Не Объект.Выполнена Тогда
		Объект.ДатаИсполнения = ТекущаяДатаСеанса();
	КонецЕсли;
	
	РаботаСФлагамиОбъектовСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)

	Если Настройки["ПоказыватьИнструкции"] <> Неопределено
		И ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции") Тогда
		ПолучитьИнструкции();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗадачаИзменена", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ДекорацияЗадатьВопросАвторуНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Задача", Объект.Ссылка);
	
	Если Элементы.ДекорацияЗадатьВопросАвтору.Заголовок = НСтр("ru = 'Задать вопрос...'") Тогда
		
		ОткрытьФорму("БизнесПроцесс.РешениеВопросовВыполненияЗадач.ФормаОбъекта",
			ПараметрыФормы);
		
	Иначе
		
		ОткрытьФорму("БизнесПроцесс.РешениеВопросовВыполненияЗадач.Форма.ВопросыВыполненияЗадачи",
			ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Задача", Объект.Ссылка);
	ПараметрыФормы.Вставить("ВидВопроса", ПредопределенноеЗначение("Перечисление.ВидыВопросовВыполненияЗадач.ПереносСрока"));

	ОткрытьФорму("БизнесПроцесс.РешениеВопросовВыполненияЗадач.ФормаОбъекта",
		ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПричинаПрерыванияНажатие(Элемент)
		
	КомандыРаботыСБизнесПроцессамиКлиент.ПоказатьПричинуПрерывания(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПринятьЗадачуКИсполнению(ЭтаФорма, ТекущийПользователь);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОтменитьПринятиеЗадачиКИсполнению(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ОчиститьСообщения();
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		Закрыть();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить(Команда)
	
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Ознакомился(Команда)
	
	Если МультипредметностьКлиент.ПроверитьЗаполнениеПредметовЗадачи(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОбработчикаОповещения = Новый Структура;
	ПараметрыОбработчикаОповещения.Вставить("ПовторитьСогласование", Ложь);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеПроверкиНаЗанятыеФайлы",
		ЭтотОбъект,
		ПараметрыОбработчикаОповещения);
	
	РаботаСБизнесПроцессамиКлиент.ПроверитьНаличиеЗанятыхФайлов(Объект, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеПроверкиНаЗанятыеФайлы(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ВыполнитьЗадачу", Истина);
	ПараметрыЗаписи.Вставить("ПовторитьСогласование", Параметры.ПовторитьСогласование);
	
	Если Не Записать(ПараметрыЗаписи) Тогда 
		Возврат;
	КонецЕсли;	
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеВводаВремени",
		ЭтотОбъект,
		Параметры);
		
	УчетВремениКлиент.ДобавитьВОтчетПослеВыполненияЗадачи(ОпцияИспользоватьУчетВремени,
		Объект.ДатаИсполнения, Объект.Ссылка, ВключенХронометраж, 
		ДатаНачалаХронометража, ДатаКонцаХронометража,
		ВидыРабот, СпособУказанияВремени, ОписаниеОповещения);
		
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеВводаВремени(Результат, Параметры) Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Выполнение:'"),
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		Строка(Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("ЗадачаВыполнена", Объект.Ссылка);
	ОповеститьОбИзменении(Объект.Ссылка);
	
	Если Параметры.ПовторитьСогласование = Ложь Тогда
		ОсновныеПредметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(Объект,, Истина);	
		Для каждого Предмет Из ОсновныеПредметы Цикл
			ИнформацияОЗадаче = Новый Структура;
			ИнформацияОЗадаче.Вставить("Ссылка", Объект.Ссылка);
			ИнформацияОЗадаче.Вставить("Предмет", Предмет);
			ИнформацияОЗадаче.Вставить("БизнесПроцесс", Объект.БизнесПроцесс);
			Оповестить("ЗадачаСогласованияВыполнена", ИнформацияОЗадаче);
		КонецЦикла;
	КонецЕсли;

	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Повторить(Команда)
	//1С-Минск +
	ЭтоПроверкаДела = мПроверкаДела.ПолучитьУровеньШаблонаПроверкиДела(Объект.БизнесПроцесс) > 0;
	//1С-Минск -
	
	Если МультипредметностьКлиент.ПроверитьЗаполнениеПредметовЗадачи(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("УникальныйИдентификаторФормыИзмененияПараметров", УникальныйИдентификатор);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеИзмененияПараметров",
		ЭтотОбъект,
		ПараметрыОбработчика);
		
		ПараметрыФормы = Новый Структура("Ключ", Объект.БизнесПроцесс);
		
		//Если ЭтоПроверкаДела Тогда
		//	ПараметрыФормы.Вставить("НеОткрыватьФорму", Истина);
		//КонецЕсли; 
		
		ОткрытьФорму(
		"БизнесПроцесс.Согласование.Форма.ФормаИзменениеПараметров",
		ПараметрыФормы,
		ЭтаФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	//1С-Минск +
	// изменение состояния дела
	Если ЭтоПроверкаДела Тогда
		Для каждого Стр Из Объект.Предметы Цикл
			Если ЗначениеЗаполнено(Стр.Предмет) Тогда
				Если ТипЗнч(Стр.Предмет) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
					Если ЭтоДело(Стр.Предмет) Тогда
						Дело = Стр.Предмет;
                        ТекИсполнитель = ПользователиКлиентСервер.ТекущийПользователь();
                        ИсполнительДела = мПроверкаДела.ПолучитьИсполнителяДела(Дело);
                        
                        Если ТекИсполнитель = ИсполнительДела Тогда
                            //Если мПроверкаДела.ПолучитьУровеньШаблонаПроверкиДела(ЗадачиМнеТекущийБизнесПроцесс) = 1 Тогда
                            // Запись состояния дела
                            ТекУровеньПроверки = ПредопределенноеЗначение("Перечисление.мУровниПроверки.Исполнитель");
                        Иначе
                            ТекУровеньПроверки = мПроверкаДела.ПолучитьУровеньПроверкиДелаПоПроцессу(Объект.БизнесПроцесс);
                        КонецЕсли; 
                        
                        Подразделение = РаботаСПользователями.ПолучитьПодразделение(ТекИсполнитель);
                        Состояние = ПредопределенноеЗначение("Перечисление.мСостоянияДела.НаправленоНаПроверку");
                        мПроверкаДела.ЗаписатьСостояниеДела(Дело, Состояние, ТекущаяДата(), Подразделение, ТекИсполнитель, ТекУровеньПроверки);  
                        
                        ПоказатьОповещениеПользователя("Дело "+Дело+" отправлено на проверку!");
                        //СтруктураУровняПроверки = мПроверкаДела.ПолучитьРеквизитыУровняПроверкиДела(Дело);
                        //ТекУровеньПроверки = СтруктураУровняПроверки.УровеньПроверки;
                        //
                        //Если ТекУровеньПроверки = ПредопределенноеЗначение("Перечисление.мУровниПроверки.Исполнитель") Тогда
                        //	// важно Подразделение исполнителя работ
                        //	Исполнитель = мПроверкаДела.ПолучитьИсполнителяДела(Дело);
                        //	Подразделение = РаботаСПользователями.ПолучитьПодразделение(Исполнитель);
                        //Иначе
                        //	Исполнитель = ПользователиКлиентСервер.ТекущийПользователь();
                        //	Подразделение = РаботаСПользователями.ПолучитьПодразделение(Исполнитель);
                        //КонецЕсли; 
                        //Состояние = ПредопределенноеЗначение("Перечисление.мСостоянияДела.НаправленоНаПроверку");
                        //мПроверкаДела.ЗаписатьСостояниеДела(Дело, Состояние, ТекущаяДата(), Подразделение, Исполнитель, ТекУровеньПроверки);  
                        //
                        //ПоказатьОповещениеПользователя("Дело "+ПолучитьНомерДела(Дело)+" направлено на проверку!");
						
					КонецЕсли; 
				КонецЕсли; 
			КонецЕсли; 	
		КонецЦикла; 
	КонецЕсли; 
	//1С-Минск -
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоДело(ВнДок)
	Возврат ВнДок.ВидДокумента = Справочники.ВидыВнутреннихДокументов.Дело;	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНомерДела(ВнДок)
	Возврат ВнДок.РегистрационныйНомер;	
КонецФункции
 
&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеИзмененияПараметров(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	УникальныйИдентификаторФормыИзмененияПараметров = Параметры.УникальныйИдентификаторФормыИзмененияПараметров;
	
	ПараметрыОбработчикаОповещения = Новый Структура;
	ПараметрыОбработчикаОповещения.Вставить("ПовторитьСогласование", Истина);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеПроверкиНаЗанятыеФайлы",
		ЭтотОбъект,
		ПараметрыОбработчикаОповещения);
	
	РаботаСБизнесПроцессамиКлиент.ПроверитьНаличиеЗанятыхФайлов(Объект, ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура История(Команда)
	
	ПараметрыФормы = Новый Структура("ЗадачаСсылка", Объект.Ссылка);
	ОткрытьФорму("БизнесПроцесс.Согласование.Форма.ФормаИсторияСогласования", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительСтрокойОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСБизнесПроцессамиКлиент.ОткрытьИсполнителя(Объект.Исполнитель);
	
КонецПроцедуры


&НаКлиенте
Процедура Дополнительно(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Перенаправить(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.Перенаправить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛистСогласования(Команда)
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Объект.БизнесПроцесс);
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("БизнесПроцесс.Согласование", "ЛистСогласования", МассивОбъектов, ЭтаФорма, );
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	
	ПоказатьЗначение(,Объект.БизнесПроцесс);
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьХронометражСервер(ПараметрыОповещения) Экспорт
	
	УчетВремени.ПереключитьХронометражСервер(
	ПараметрыОповещения,
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	Объект.Ссылка,
	ВидыРабот,
	ЭтаФорма.Команды.ПереключитьХронометраж,
	ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтчетИОбновитьФорму(ПараметрыОтчета, ПараметрыОповещения) Экспорт
	
	УчетВремени.ДобавитьВОтчетИОбновитьФорму(
	    ПараметрыОтчета, 
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьХронометражСервер() Экспорт
	
	УчетВремени.ОтключитьХронометражСервер(
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	Объект.Ссылка,
	ЭтаФорма.Команды.ПереключитьХронометраж,
	ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьХронометраж(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПереключитьХронометраж(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьТрудозатраты(Команда)
	
	ДатаОтчета = ТекущаяДата();
	Если Объект.Выполнена Тогда
		ДатаОтчета = Объект.ДатаИсполнения;
	КонецЕсли;	
	
	УчетВремениКлиент.ДобавитьВОтчетКлиент(
		ДатаОтчета,
		ВключенХронометраж, 
		ДатаНачалаХронометража, 
		ДатаКонцаХронометража, 
		ВидыРабот, 
		Объект.Ссылка,
		СпособУказанияВремени,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		Объект.Выполнена,
		ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура Подписаться(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("ОбъектПодписки", Объект.Ссылка);
		ОткрытьФорму("ОбщаяФорма.ПодпискаНаУведомленияПоОбъекту", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Команда)
	
	ВыполнениеЗадачПоПочтеКлиент.СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ФЛАГОМ

&НаКлиенте
Процедура КрасныйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Красный"),
		БиблиотекаКартинок.КрасныйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура СинийФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Синий"),
		БиблиотекаКартинок.СинийФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЖелтыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Желтый"),
		БиблиотекаКартинок.ЖелтыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗеленыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Зеленый"),
		БиблиотекаКартинок.ЗеленыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОранжевыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Оранжевый"),
		БиблиотекаКартинок.ОранжевыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиловыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Лиловый"),
		БиблиотекаКартинок.ЛиловыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.ПустаяСсылка"),
		БиблиотекаКартинок.ПустойФлаг);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ СВОЙСТВ

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма,
		РеквизитФормыВЗначение("Объект"));

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ДЛЯ РАБОТЫ С ПРИЛОЖЕНИЯМИ 

&НаКлиенте
Процедура ДеревоПриложенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = ДеревоПриложений.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ЗначениеЗаполнено(ТекущиеДанные.ИмяПредмета) И НЕ ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ОчиститьСообщения();
		СообщениеОбОшибке = "";
		
		ПараметрыОбработчикаОповещения = Новый Структура();
		ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ДеревоПриложенийВыборПродолжение",
			ЭтотОбъект,
			ПараметрыОбработчикаОповещения);         
			
		Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(ЭтаФорма, СообщениеОбОшибке, 
			ТекущиеДанные.ИмяПредмета, ТекущиеДанные.Ссылка, СтандартнаяОбработка, ОписаниеОповещения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СообщениеОбОшибке,, "ДеревоПриложений");
			Возврат;
		КонецЕсли;
	Иначе
		РаботаСБизнесПроцессамиКлиент.ДеревоПриложенийВыбор(
			ЭтаФорма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийВыборПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();	
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПриАктивизацииСтроки(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ОткрытьКарточкуНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЭтаФорма.ТолькоПросмотр Или Элементы.ДеревоПриложений.ТолькоПросмотр Или Объект.Выполнена Тогда 
		Возврат;
	КонецЕсли;
	
	ВладелецФайлаСписка = Объект.БизнесПроцесс;
	НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;
	РаботаСФайламиКлиент.ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыПеретаскивания, ВладелецФайлаСписка, ЭтаФорма, НеОткрыватьКарточкуПослеСозданияИзФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ДеревоПриложенийДобавлениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ДеревоПриложенийУдалениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийДобавлениеНаКлиенте()

	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	НовыйИмяПредмета = Неопределено;
	
	ПараметрыОбработчикаОповещения = Новый Структура();
	ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДеревоПриложенийВыборПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчикаОповещения);
	
	Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(ЭтаФорма, СообщениеОбОшибке, НовыйИмяПредмета,,,ОписаниеОповещения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийДобавлениеНаКлиентеПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();	
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийУдалениеНаКлиенте()
	
	ВыделенныеСтрокиПредметов = Новый Массив;
	Для Каждого ВыделеннаяСтр Из Элементы.ДеревоПриложений.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.ДеревоПриложений.ДанныеСтроки(ВыделеннаяСтр);
		ВыделенныеСтрокиПредметов.Добавить(ДанныеСтроки);
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДеревоПриложенийУдалениеНаКлиентеПродолжение",
		ЭтотОбъект,
		ВыделенныеСтрокиПредметов);
		
	МультипредметностьКлиент.ПолученоПодтверждениеОбУдаленииПредмета(Объект, ВыделенныеСтрокиПредметов, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийУдалениеНаКлиентеПродолжение(Результат, ВыделенныеСтрокиПредметов) Экспорт
	
	Если Результат = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	
	ИменаУдаляемыхПредметов = Новый Массив;
	Для Каждого ВыделеннаяСтр Из ВыделенныеСтрокиПредметов Цикл
		Если ВыделеннаяСтр.ДоступноУдаление Тогда
			ИменаУдаляемыхПредметов.Добавить(ВыделеннаяСтр.ИмяПредмета);
		КонецЕсли;
	КонецЦикла;
	
	Если ИменаУдаляемыхПредметов.Количество() = 0 Тогда
		
		КоличествоВыделенныхСтрок = ВыделенныеСтрокиПредметов.Количество();
		Если КоличествоВыделенныхСтрок = 1 Тогда
			ТекстСообщения = НСтр("ru = 'Удалить текущий предмет можно только в карточке процесса.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Удалить выделенные предметы можно только в карточке процесса.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
	
	Если Не МультипредметностьКлиент.УдалитьПредметыЗадачи(ЭтаФорма, СообщениеОбОшибке, ИменаУдаляемыхПредметов) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
	
	ОбновитьДеревоПриложений();
	УстановитьПредметСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДляПросмотра(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьТекущийФайлДляПросмотра(ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры	

&НаКлиенте
Процедура Редактировать(Команда)
	
	РаботаСБизнесПроцессамиКлиент.РедактироватьТекущийФайл(
		ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ЗакончитьРедактированиеТекущегоФайла(
		ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредмет(Команда)
	
	ДеревоПриложенийДобавлениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПредмет(Команда)
	
	ДеревоПриложенийУдалениеНаКлиенте();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредметСервер()
	
	Мультипредметность.УстановитьЗначенияДопРеквизитовИДоступностьЭлементовФормыПроцесса(ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновитьДеревоПриложений(Команда)
	
	ОбновитьДеревоПриложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ОткрытьКарточкуНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНаКлиенте()
	
	ТекущиеДанные = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение(,ТекущиеДанные.Ссылка);
	Иначе
		ОчиститьСообщения();
		СообщениеОбОшибке = "";
		
		ПараметрыОбработчикаОповещения = Новый Структура;
		ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОткрытьКарточкуНаКлиентеПродолжение",
			ЭтотОбъект,
			ПараметрыОбработчикаОповещения);
			
		Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(
			ЭтаФорма,
			СообщениеОбОшибке, 
			ТекущиеДанные.ИмяПредмета,
			ТекущиеДанные.Ссылка,,
			ОписаниеОповещения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СообщениеОбОшибке,, "ДеревоПриложений");
			Возврат;
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНаКлиентеПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	РаботаСБизнесПроцессамиКлиент.СохранитьТекущийФайл(ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры	


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Оповестить("ОбновитьСписокПоследних");
КонецПроцедуры

&НаКлиенте
Процедура ХодИсполненияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленныеПриложения(Команда)
	
	ОтображатьУдаленныеПриложения = Не ОтображатьУдаленныеПриложения;
	Элементы.ДеревоПриложенийКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленныеПриложения;
	
	ТекущаяСсылкаВДереве = Неопределено;
	Если Элементы.ДеревоПриложений.ТекущиеДанные <> Неопределено Тогда
		ТекущаяСсылкаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.Ссылка;
	КонецЕсли;	
	
	ОтображатьУдаленныеПриложенияСервер();
	
	Если ТекущаяСсылкаВДереве <> Неопределено Тогда
		РаботаСБизнесПроцессамиКлиент.УстановитьТекущуюСтрокуВДеревеПриложений(
			ЭтаФорма, 
			ДеревоПриложений.ПолучитьЭлементы(), 
			ТекущаяСсылкаВДереве);
	КонецЕсли;	
		
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(
		ЭтаФорма, 
		Элементы.ДеревоПриложений);
		
КонецПроцедуры

&НаСервере
Процедура ОтображатьУдаленныеПриложенияСервер()
	
	РаботаСБизнесПроцессами.ЗаполнитьДеревоПриложений(ЭтаФорма);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		ИмяФормы,
		"ОтображатьУдаленныеПриложения",
		ОтображатьУдаленныеПриложения);
	
КонецПроцедуры
	
	
////////////////////////////////////////////////////////////////////////////////
// ИНСТРУКЦИИ

&НаСервере
Процедура ПолучитьИнструкции()
	
	РаботаСИнструкциями.ПолучитьИнструкции(ЭтаФорма, 90, 120);
	
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
