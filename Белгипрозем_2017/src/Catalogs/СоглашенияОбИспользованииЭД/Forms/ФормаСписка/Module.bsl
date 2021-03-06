

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ТАБЛИЦЫ СписокСоглашенийЧерезОЭДО

&НаКлиенте
Процедура СписокСоглашенийЧерезОЭДОПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Копирование Тогда
		СтруктураПараметров = Новый Структура("ЗначениеКопирования", Элементы.СписокСоглашенийЧерезОЭДО.ТекущаяСтрока);
		ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.Форма.ФормаЭлементаЧерезОЭДО",
					 СтруктураПараметров,
					 Элементы.СписокСоглашенийЧерезОЭДО);
	Иначе
		ОтборДинамическогоСписка = ЭлектронныеДокументыКлиентСервер.ОтборДинамическогоСписка(СписокСоглашенийЧерезОЭДО);
		МассивЭлементовОрганизация = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(
																				ОтборДинамическогоСписка,
																				"Организация");
		ПараметрыФормы = Новый Структура;
		
		Если СписокСоглашенийЧерезОЭДО.Параметры.Элементы.Найти("Организация") <> Неопределено
			И СписокСоглашенийЧерезОЭДО.Параметры.Элементы.Найти("Организация").Использование
			И ЗначениеЗаполнено(СписокСоглашенийЧерезОЭДО.Параметры.Элементы.Найти("Организация").Значение) Тогда
				ПараметрыФормы.Вставить("Организация", СписокСоглашенийЧерезОЭДО.Параметры.Элементы.Найти("Организация").Значение);
		ИначеЕсли МассивЭлементовОрганизация.Количество() = 1
			И МассивЭлементовОрганизация[0].ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
			И МассивЭлементовОрганизация[0].Использование Тогда
				ПараметрыФормы.Вставить("Организация", МассивЭлементовОрганизация[0].ПравоеЗначение);
		КонецЕсли;

		ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.Форма.ПомощникНового", ПараметрыФормы, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьЗначениеФункциональнойОпции("ИспользоватьОбменЭД") Тогда
		ТекстСообщения = ЭлектронныеДокументыСлужебныйВызовСервера.ТекстСообщенияОНеобходимостиНастройкиСистемы("РаботаСЭД");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("РежимОткрытияОкна") Тогда
		ЭтаФорма.РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
	КонецЕсли;
	
	СпособыОЭДНапрямую = ЭлектронныеДокументыСлужебный.МассивСпособовОбменаЭД(Истина);
	ДатаАктуальности = НачалоДня(ТекущаяДатаСеанса());
	
	ИмяСправочникаБанки = ЭлектронныеДокументыПовтИсп.ПолучитьИмяПрикладногоСправочника("Банки");
	Если ЗначениеЗаполнено(ИмяСправочникаБанки) Тогда
		СписокСоглашенийСБанками.ТекстЗапроса = СтрЗаменить(СписокСоглашенийСБанками.ТекстЗапроса,
															"КлассификаторБанковРФ",
															ИмяСправочникаБанки);
	КонецЕсли;
	
	ТекстЗапросаПартнеры = "ИСТИНА";
	Если ЭлектронныеДокументыПовтИсп.ИспользуетсяДополнительнаяАналитикаКонтрагентовСправочникПартнеры()
		И Параметры.Свойство("Партнер") Тогда
		
		ТекстЗапросаПартнеры = "ВЫБОР
		|	КОГДА Соглашение.Контрагент.Партнер В ИЕРАРХИИ (&Партнер)
		|		ТОГДА ИСТИНА
		|	ИНАЧЕ ЛОЖЬ
		|КОНЕЦ";
		
		СписокСоглашенийСКонтрагентами.Параметры.УстановитьЗначениеПараметра("Партнер",            Параметры.Партнер);
		СписокСоглашенийМеждуОрганизациями.Параметры.УстановитьЗначениеПараметра("Партнер",        Параметры.Партнер);
		СписокСоглашенийЧерезОЭДО.Параметры.УстановитьЗначениеПараметра("Партнер",                 Параметры.Партнер);
	КонецЕсли;
	СписокСоглашенийСКонтрагентами.ТекстЗапроса = СтрЗаменить(СписокСоглашенийСКонтрагентами.ТекстЗапроса,
		"&Партнер", ТекстЗапросаПартнеры);
	СписокСоглашенийМеждуОрганизациями.ТекстЗапроса = СтрЗаменить(СписокСоглашенийМеждуОрганизациями.ТекстЗапроса,
		"&Партнер", ТекстЗапросаПартнеры);
	СписокСоглашенийЧерезОЭДО.ТекстЗапроса = СтрЗаменить(СписокСоглашенийЧерезОЭДО.ТекстЗапроса,
		"&Партнер", ТекстЗапросаПартнеры);
	
	СписокСоглашенийСКонтрагентами.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности",        ДатаАктуальности);
	СписокСоглашенийСКонтрагентами.Параметры.УстановитьЗначениеПараметра("Контрагент",              Параметры.Контрагент);
	СписокСоглашенийСКонтрагентами.Параметры.УстановитьЗначениеПараметра("Организация",             Параметры.Организация);
	СписокСоглашенийСКонтрагентами.Параметры.УстановитьЗначениеПараметра("СпособыОбменаЭДНапрямую", СпособыОЭДНапрямую);
	
	СписокСоглашенийМеждуОрганизациями.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности",     ДатаАктуальности);
	СписокСоглашенийМеждуОрганизациями.Параметры.УстановитьЗначениеПараметра("Контрагент",           Параметры.Контрагент);
	СписокСоглашенийМеждуОрганизациями.Параметры.УстановитьЗначениеПараметра("Организация",          Параметры.Организация);
	
	СписокСоглашенийЧерезОЭДО.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности",        ДатаАктуальности);
	СписокСоглашенийЧерезОЭДО.Параметры.УстановитьЗначениеПараметра("Контрагент",              Параметры.Контрагент);
	СписокСоглашенийЧерезОЭДО.Параметры.УстановитьЗначениеПараметра("Организация",             Параметры.Организация);
	
	СписокСоглашенийСБанками.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", ДатаАктуальности);
	СписокСоглашенийСБанками.Параметры.УстановитьЗначениеПараметра("Банк",             Параметры.Банк);
	СписокСоглашенийСБанками.Параметры.УстановитьЗначениеПараметра("Организация",      Параметры.Организация);
	
	СписокСоглашений.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", ДатаАктуальности);
	
	// Скроем группу "Всех соглашений" от пользователей с ограниченными правами или принудительно.
	СкрытьЗакладкуВсехСоглашений = НЕ Пользователи.ЭтоПолноправныйПользователь()
									ИЛИ (Параметры.Свойство("Партнер") И ЗначениеЗаполнено(Параметры.Партнер))
									ИЛИ ЗначениеЗаполнено(Параметры.Контрагент)
									ИЛИ ЗначениеЗаполнено(Параметры.Организация)
									ИЛИ ЗначениеЗаполнено(Параметры.Банк);
	
	Элементы.ГруппаВсеСоглашения.Видимость = НЕ СкрытьЗакладкуВсехСоглашений;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовое(Команда)
	
	ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.Форма.ФормаЭлементаЧерезОЭДО", , ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.СписокСоглашенийЧерезОЭДО.Обновить();
	КонецЕсли;
	
КонецПроцедуры
