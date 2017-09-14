&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Договор) Тогда
		Корреспондент = Объект.Договор.Корреспондент;
		УстановитьСвязьПараметровВыбораОбъектаРабот(Элементы)
	КонецЕсли; 
	
	ВидАкта = Справочники.ВидыВнутреннихДокументов.АктВыполненныхРабот;
	
	Если ЗначениеЗаполнено(Объект.Смета) Тогда
		Если ЗначениеЗаполнено(Объект.Смета.ЭтапДоговора) Тогда
			ЭтапДоговора = Объект.Смета.ЭтапДоговора; 
			УстановитьСвязьПараметровВыбораАкта(ЭтаФорма);
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьИтогов();
КонецПроцедуры
 
&НаКлиенте
Процедура ОбъемРаботПередУдалением(Элемент, Отказ)
	РассчитатьИтогиСметы();
	УстановитьДоступностьИтогов();
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьИтогиСметы()
	Объект.Сумма = 0;
	Объект.НДС = 0;
	Для каждого СтрСметы Из Объект.ОбъемРабот Цикл
		Объект.Сумма = Объект.Сумма + СтрСметы.Сумма;
		Объект.НДС = Объект.НДС + СтрСметы.НДС;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьИтогов()
	НетРасчета = Объект.ОбъемРабот.Количество() = 0;
	Элементы.ГруппаИтоги.Доступность = НетРасчета;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКорреспондентаДоговора(Договор)
	Возврат Договор.Корреспондент;	
КонецФункции


&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	Корреспондент = ПолучитьКорреспондентаДоговора(Объект.Договор);	
	УстановитьСвязьПараметровВыбораОбъектаРабот(Элементы);
КонецПроцедуры
 
&НаСервереБезКонтекста
Процедура УстановитьСвязьПараметровВыбораОбъектаРабот(Элементы)
	НоваяСвязь = Новый СвязьПараметраВыбора("Отбор.Владелец", "Корреспондент");
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(НоваяСвязь);
	НовыеСвязи = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.ОбъектРабот.СвязиПараметровВыбора = НовыеСвязи;
КонецПроцедуры 

&НаКлиенте
Процедура СметаПриИзменении(Элемент)
	ЗаполнитьОбъемРабот();
	Если ЗначениеЗаполнено(ЭтапДоговора) Тогда
		УстановитьСвязьПараметровВыбораАкта(ЭтаФорма);
	КонецЕсли; 
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьСвязьПараметровВыбораАкта(ЭтаФорма)
	//НоваяСвязь = Новый СвязьПараметраВыбора("Отбор.ЭтапДоговора", "ЭтапДоговора");
	//НоваяСвязь2 = Новый СвязьПараметраВыбора("Отбор.ВидДокумента", "ВидАкта");
	//НовыйМассив = Новый Массив();
	//НовыйМассив.Добавить(НоваяСвязь);
	//НовыйМассив.Добавить(НоваяСвязь2);
	//НовыеСвязи = Новый ФиксированныйМассив(НовыйМассив);
	//ЭтаФорма.Элементы.Акт.СвязиПараметровВыбора = НовыеСвязи;
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьОбъемРабот()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мСметыОбъемРабот.СтадияРабот КАК СтадияРабот,
		|	СУММА(мСметыОбъемРабот.Стоимость) КАК Сумма,
		|	МАКСИМУМ(мСметыОбъемРабот.Ссылка.СтавкаНДС.Ставка) КАК СтавкаНДСЗначение,
		|	МАКСИМУМ(мСметыОбъемРабот.Ссылка.КОплате) КАК Всего,
		|	МАКСИМУМ(мСметыОбъемРабот.Ссылка.НДС) КАК НДС,
		|	МАКСИМУМ(мСметыОбъемРабот.Ссылка.ЭтапДоговора) КАК ЭтапДоговора
		|ИЗ
		|	Справочник.мСметы.ОбъемРабот КАК мСметыОбъемРабот
		|ГДЕ
		|	мСметыОбъемРабот.Ссылка = &Смета
		|
		|СГРУППИРОВАТЬ ПО
		|	мСметыОбъемРабот.СтадияРабот,
		|	мСметыОбъемРабот.Ссылка.ЭтапДоговора";
	
	Запрос.УстановитьПараметр("Смета", Объект.Смета);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Объект.ОбъемРабот.Очистить();
	
	ЭтоПерваяСтрока = Истина;
	ЭтапДоговора = Неопределено;
	
	Пока Выборка.Следующий() Цикл
		Стр = Объект.ОбъемРабот.Добавить();
		ЗаполнитьЗначенияСвойств(Стр, Выборка);
		
		Объект.Сумма = Объект.Сумма + Стр.Сумма;
		
		Если ЭтоПерваяСтрока Тогда
			ЭтоПерваяСтрока = Ложь;
			ЗаполнитьЗначенияСвойств(Объект, Выборка, ,"Сумма");
			ЭтапДоговора = Выборка.ЭтапДоговора;
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры 

&НаКлиенте
Процедура АктНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ВидДокумента", ПредопределенноеЗначение("Справочник.ВидыВнутреннихДокументов.АктВыполненныхРабот"));
	ПараметрыОтбора.Вставить("ЭтапДоговора", ЭтапДоговора);
	ПараметрыФормы = Новый Структура("Отбор", ПараметрыОтбора);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ОткрытьФорму("Справочник.ВнутренниеДокументы.ФормаВыбора", ПараметрыФормы, Элемент);
КонецПроцедуры
