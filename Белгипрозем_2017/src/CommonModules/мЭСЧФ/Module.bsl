
&НаСервере
Функция ПолучитьТипЭСЧФ(ТипЭСЧФ) Экспорт
	СтрокаВозврата = "";
	Если ТипЭСЧФ = Перечисления.мТипСЧ.Исходный Тогда
		СтрокаВозврата = "ORIGINAL";
	ИначеЕсли ТипЭСЧФ = Перечисления.мТипСЧ.Исправленный Тогда
		СтрокаВозврата = "FIXED";
	ИначеЕсли ТипЭСЧФ = Перечисления.мТипСЧ.Дополнительный Тогда
		СтрокаВозврата = "ADDITIONAL";
	ИначеЕсли ТипЭСЧФ = Перечисления.мТипСЧ.ДополнительныйБезСсылкиНаИсходный Тогда
		СтрокаВозврата = "ADD_NO_REFERENCE";
	КонецЕсли; 
	Возврат СтрокаВозврата;
КонецФункции

&НаСервере
Функция ПолучитьСтатусПоставщика(СтатусПоставщика) Экспорт
	СтрокаВозврата = "";
	Если СтатусПоставщика = Перечисления.мСтатусыПоставщика.Продавец Тогда
		СтрокаВозврата = "SELLER";
	ИначеЕсли СтатусПоставщика = Перечисления.мСтатусыПоставщика.Комитент Тогда
		СтрокаВозврата = "CONSIGNOR";
	ИначеЕсли СтатусПоставщика = Перечисления.мСтатусыПоставщика.Комиссионер Тогда
		СтрокаВозврата = "COMMISSIONAIRE";
	ИначеЕсли СтатусПоставщика = Перечисления.мСтатусыПоставщика.ПлательщикПередающийНалоговыеВычеты Тогда
		СтрокаВозврата = "TAX_DEDUCTION_PAYER";
	ИначеЕсли СтатусПоставщика = Перечисления.мСтатусыПоставщика.ДоверительныйУправляющий Тогда
		СтрокаВозврата = "TRUSTEE";
	ИначеЕсли СтатусПоставщика = Перечисления.мСтатусыПоставщика.ИностраннаяОрганизация Тогда
		СтрокаВозврата = "FOREIGN_ORGANIZATION";
	ИначеЕсли СтатусПоставщика = Перечисления.мСтатусыПоставщика.Посредник Тогда
		СтрокаВозврата = "AGENT";
	ИначеЕсли СтатусПоставщика = Перечисления.мСтатусыПоставщика.ЗаказчикЗастройщик Тогда
		СтрокаВозврата = "DEVELOPER";
	КонецЕсли; 
	Возврат СтрокаВозврата;
КонецФункции

&НаСервере
Функция ПолучитьСтатусПолучателя(СтатусПолучателя) Экспорт
	СтрокаВозврата = "";
	Если СтатусПолучателя = Перечисления.мСтатусыПолучателя.Покупатель Тогда
		СтрокаВозврата = "CUSTOMER";
	ИначеЕсли СтатусПолучателя = Перечисления.мСтатусыПолучателя.Потребитель Тогда
		СтрокаВозврата = "CONSUMER";
	ИначеЕсли СтатусПолучателя = Перечисления.мСтатусыПолучателя.Комитент Тогда
		СтрокаВозврата = "CONSIGNOR";
	ИначеЕсли СтатусПолучателя = Перечисления.мСтатусыПолучателя.Комиссионер Тогда
		СтрокаВозврата = "COMMISSIONAIRE";
	ИначеЕсли СтатусПолучателя = Перечисления.мСтатусыПолучателя.ПлательщикПолучающийНалоговыеВычеты Тогда
		СтрокаВозврата = "TAX_DEDUCTION_RECIPIENT";
	ИначеЕсли СтатусПолучателя = Перечисления.мСтатусыПолучателя.ПокупательОбъектовУИностраннойОрганизации Тогда
		СтрокаВозврата = "FOREIGN_ORGANIZATION_BUYER";
	КонецЕсли; 
	Возврат СтрокаВозврата;
КонецФункции

&НаСервере
Функция ПолучитьКодВидаДокументаЭСЧФ(ВидДок) Экспорт
	Если Не ЗначениеЗаполнено(ВидДок) Тогда
		Возврат 0;
	КонецЕсли; 
	Если ВидДок = Перечисления.мВидыДокументовЭСЧФ.АктВыполненныхРабот Тогда
		Возврат 612;
	ИначеЕсли ВидДок = Перечисления.мВидыДокументовЭСЧФ.БухгалтерскаяСправка Тогда
		Возврат 611;	
	ИначеЕсли ВидДок = Перечисления.мВидыДокументовЭСЧФ.Другое Тогда
		Возврат 601;	
	ИначеЕсли ВидДок = Перечисления.мВидыДокументовЭСЧФ.ТН2 Тогда
		Возврат 602;	
	ИначеЕсли ВидДок = Перечисления.мВидыДокументовЭСЧФ.ТТН1 Тогда
		Возврат 603;	
	ИначеЕсли ВидДок = Перечисления.мВидыДокументовЭСЧФ.Договор Тогда
		Возврат 604;	
	ИначеЕсли ВидДок = Перечисления.мВидыДокументовЭСЧФ.Контракт Тогда
		Возврат 605;	
	ИначеЕсли ВидДок = Перечисления.мВидыДокументовЭСЧФ.Акт Тогда
		Возврат 606;	
	ИначеЕсли ВидДок = Перечисления.мВидыДокументовЭСЧФ.CMRНакладная Тогда
		Возврат 607;	
	ИначеЕсли ВидДок = Перечисления.мВидыДокументовЭСЧФ.СчетФактура Тогда
		Возврат 608;	
	ИначеЕсли ВидДок = Перечисления.мВидыДокументовЭСЧФ.InvoiceСчет Тогда
		Возврат 609;	
	ИначеЕсли ВидДок = Перечисления.мВидыДокументовЭСЧФ.Авизо Тогда
		Возврат 610;	
	ИначеЕсли ВидДок = Перечисления.мВидыДокументовЭСЧФ.Коносамент Тогда
		Возврат 613;	
	КонецЕсли; 	
КонецФункции

&НаСервере
Функция ПолучитьДопДанныеЭСЧФ(ДопДанныеЭСЧФ) Экспорт
	СтрокаВозврата = "";
	Если ДопДанныеЭСЧФ = Перечисления.мДополнительныеДанныеЭСЧФ.ВычетВПолномОбъеме Тогда
		СтрокаВозврата = "DEDUCTION_IN_FULL";
	ИначеЕсли ДопДанныеЭСЧФ = Перечисления.мДополнительныеДанныеЭСЧФ.ОсвобождениеОтНДС Тогда
		СтрокаВозврата = "VAT_EXEMPTION";
	ИначеЕсли ДопДанныеЭСЧФ = Перечисления.мДополнительныеДанныеЭСЧФ.РеализацияЗаПределамиРБ Тогда
		СтрокаВозврата = "OUTSIDE_RB";
	ИначеЕсли ДопДанныеЭСЧФ = Перечисления.мДополнительныеДанныеЭСЧФ.ВвознойНДС Тогда
		СтрокаВозврата = "IMPORT_VAT";
	КонецЕсли; 
	Возврат СтрокаВозврата;
КонецФункции

&НаСервере
Функция ПолучитьТипСтавкиНДС(СтавкаНДС) Экспорт
	СтрокаВозврата = "";
	Если Не ЗначениеЗаполнено(СтавкаНДС) Тогда
		Возврат СтрокаВозврата;
	КонецЕсли; 
	Если СтавкаНДС.НеОблагается Тогда
		СтрокаВозврата = "NO_VAT";
	ИначеЕсли СтавкаНДС.Расчетная Тогда
		СтрокаВозврата = "CALCULATED";
	ИначеЕсли СтавкаНДС.Ставка = 0 Тогда
		СтрокаВозврата = "ZERO";
	ИначеЕсли СтавкаНДС.Ставка > 0 Тогда
		СтрокаВозврата = "DECIMAL";
	КонецЕсли; 
	Возврат СтрокаВозврата;
КонецФункции

&НаСервере
Функция АктВыполненныхРаботНельзяИзменять(Акт) Экспорт
	Если Не ЗначениеЗаполнено(Акт) Тогда
		Возврат Ложь;
	КонецЕсли; 	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мСвязиЭСЧФ.ЭСЧФ.СтатусСФ КАК Статус,
		|	мСвязиЭСЧФ.ЭСЧФ.РазрешитьИзменениеАкта КАК РазрешитьИзменениеАкта
		|ИЗ
		|	РегистрСведений.мСвязиЭСЧФ КАК мСвязиЭСЧФ
		|ГДЕ
		|	мСвязиЭСЧФ.ДокументРеализации = &ДокументРеализации
		|	И мСвязиЭСЧФ.ЭСЧФ.СтатусСФ В(&МассивСтатусов)";
	
	Запрос.УстановитьПараметр("ДокументРеализации", Акт);
	
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(Перечисления.мСтатусыСФ.Выставлен);
	МассивСтатусов.Добавить(Перечисления.мСтатусыСФ.ВыставленПодписанПолучателем);
	МассивСтатусов.Добавить(Перечисления.мСтатусыСФ.НаСогласовании);
	Запрос.УстановитьПараметр("МассивСтатусов", МассивСтатусов);
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат НЕ Выборка.РазрешитьИзменениеАкта;
	КонецЕсли;
	
	Возврат Ложь;	
КонецФункции

&НаСервере
Функция СтатусЭСЧФДляАктаВыполненныхРабот(Акт) Экспорт
	Если Не ЗначениеЗаполнено(Акт) Тогда
		Возврат Неопределено;
	КонецЕсли; 	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	мСвязиЭСЧФ.ЭСЧФ.СтатусСФ КАК Статус
		|ИЗ
		|	РегистрСведений.мСвязиЭСЧФ КАК мСвязиЭСЧФ
		|ГДЕ
		|	мСвязиЭСЧФ.ДокументРеализации = &ДокументРеализации
		|	И мСвязиЭСЧФ.ЭСЧФ.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	мСвязиЭСЧФ.ЭСЧФ.Дата УБЫВ,
		|	мСвязиЭСЧФ.ЭСЧФ.Номер УБЫВ";
	
	Запрос.УстановитьПараметр("ДокументРеализации", Акт);
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Статус;
	КонецЕсли; 
	
	Возврат Неопределено;	
КонецФункции
 
 