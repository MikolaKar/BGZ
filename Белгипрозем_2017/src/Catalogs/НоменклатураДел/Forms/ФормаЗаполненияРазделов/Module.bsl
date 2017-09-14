#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Год) Тогда 
		РазделыНаГод = Параметры.Год;
	Иначе
		РазделыНаГод = Год(ТекущаяДата());
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда 
		Организация = Параметры.Организация;
	Иначе
		Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;	
	
	ЗаполнитьДерево();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПометкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ДеревоРазделов.ТекущаяСтрока;
	ЭлементДерева = ДеревоРазделов.НайтиПоИдентификатору(ТекущаяСтрока);
	ПометитьРодителейИПодчиненных(ЭлементДерева, ЭлементДерева.Пометка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отметить(Команда)
	
	ПометитьПодчиненные(Неопределено, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	
	ПометитьПодчиненные(Неопределено, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРазделы(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;
	
	СоздатьРазделыНаСервере();
	Оповестить("ОбновитьРазделыНоменклатурыДел", РазделыНаГод, ЭтаФорма);
	
	ПоказатьОповещениеПользователя(
			"Копирование:", ,
			"Созданы отмеченные разделы номенклатуры дел",
			БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПометитьПодчиненные(ЭлементДерева, Пометка)
	
	Если ЭлементДерева = Неопределено Тогда 
		Для Каждого ПодчиненныйЭлемент Из ДеревоРазделов.ПолучитьЭлементы() Цикл
			ПометитьПодчиненные(ПодчиненныйЭлемент, Пометка);
		КонецЦикла;	
	Иначе
		ЭлементДерева.Пометка = Пометка;
		Для Каждого ПодчиненныйЭлемент Из ЭлементДерева.ПолучитьЭлементы() Цикл
			ПометитьПодчиненные(ПодчиненныйЭлемент, Пометка);
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДерево()
	
	ДеревоЗнч = РеквизитФормыВЗначение("ДеревоРазделов");
	ДеревоЗнч.Строки.Очистить();
	
	Выборка = Справочники.СтруктураПредприятия.ВыбратьИерархически();
	Пока Выборка.Следующий() Цикл
		
		Родитель = Выборка.Родитель;
		Если Родитель.Пустая() Тогда
			СтрокаРодитель = ДеревоЗнч;
		Иначе
			СтрокаРодитель = ДеревоЗнч.Строки.Найти(Родитель, "Ссылка", Истина);
		КонецЕсли;	
		
		НоваяСтрока = СтрокаРодитель.Строки.Добавить();
		НоваяСтрока.Ссылка = Выборка.Ссылка;
		НоваяСтрока.Наименование = Выборка.Наименование;
		НоваяСтрока.Пометка = Истина;
		
	КонецЦикла;	
		
	ЗначениеВРеквизитФормы(ДеревоЗнч, "ДеревоРазделов");
	
КонецПроцедуры	

&НаСервере
Процедура СоздатьРазделыНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РазделыНоменклатурыДел.Ссылка,
		|	РазделыНоменклатурыДел.Наименование,
		|	РазделыНоменклатурыДел.Индекс
		|ИЗ
		|	Справочник.РазделыНоменклатурыДел КАК РазделыНоменклатурыДел
		|ГДЕ
		|	РазделыНоменклатурыДел.Год = &Год
		|	И (РазделыНоменклатурыДел.Организация = &Организация
		|			ИЛИ &ИспользоватьУчетПоОрганизациям = ЛОЖЬ)";
	Запрос.УстановитьПараметр("Год", РазделыНаГод);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ИспользоватьУчетПоОрганизациям", 
		ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям"));
	
	ТаблРазделы = Запрос.Выполнить().Выгрузить();
	
	ДеревоЗнч = РеквизитФормыВЗначение("ДеревоРазделов");
	ДеревоЗнч.Колонки.Добавить("НоваяСсылка");
	
	ТипИндекса = Метаданные.Справочники.РазделыНоменклатурыДел.Реквизиты.Индекс.Тип;
	Для Каждого ПодчиненнаяСтрока Из ДеревоЗнч.Строки Цикл
		КопироватьПодчиненные(ПодчиненнаяСтрока, ТаблРазделы, ТипИндекса);
	КонецЦикла;	
	
КонецПроцедуры	

&НаСервере
Процедура КопироватьПодчиненные(СтрокаДерева, ТаблРазделы, ТипИндекса)
	
	Если Не СтрокаДерева.Пометка Тогда
		Возврат;
	КонецЕсли;	
	
	Если СтрокаДерева.Родитель = Неопределено Тогда 
		НовыйРаздел = Справочники.РазделыНоменклатурыДел.ПустаяСсылка();
	Иначе	
		НовыйРаздел = СтрокаДерева.Родитель.НоваяСсылка;
	КонецЕсли;	
	
	ИсходныйЭлемент = СтрокаДерева.Ссылка.ПолучитьОбъект();
	
	НайденнаяСтрока = ТаблРазделы.Найти(ИсходныйЭлемент.Наименование, "Наименование");
	Если НайденнаяСтрока = Неопределено Тогда 
		НовыйЭлемент = Справочники.РазделыНоменклатурыДел.СоздатьЭлемент();
	Иначе
		НовыйЭлемент = НайденнаяСтрока.Ссылка.ПолучитьОбъект();
	КонецЕсли;	
	
	
	ДлинаИндекса = ТипИндекса.КвалификаторыСтроки.Длина;
	
	НовыйЭлемент.Наименование = ИсходныйЭлемент.Наименование;
	НовыйЭлемент.Индекс = Прав(ИсходныйЭлемент.Код, ДлинаИндекса);
	НовыйЭлемент.Родитель = НовыйРаздел;
	НовыйЭлемент.Год = РазделыНаГод;
	НовыйЭлемент.Организация = Организация;
	НовыйЭлемент.Подразделение = ИсходныйЭлемент.Ссылка;
	НовыйЭлемент.Записать();
	
	СтрокаДерева.НоваяСсылка = НовыйЭлемент.Ссылка;
	
	Для Каждого ПодчиненнаяСтрока Из СтрокаДерева.Строки Цикл
		КопироватьПодчиненные(ПодчиненнаяСтрока, ТаблРазделы, ТипИндекса);
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПометитьРодителейИПодчиненных(ЭлементДерева, Пометка)
	
	Если Пометка Тогда
		
		СтрокаРодитель = ЭлементДерева.ПолучитьРодителя();
		Пока СтрокаРодитель <> Неопределено Цикл
			СтрокаРодитель.Пометка = Пометка;
			СтрокаРодитель = СтрокаРодитель.ПолучитьРодителя();
		КонецЦикла;	
		
	Иначе	
		
		ЭлементДерева.Пометка = Пометка;
		Для Каждого ПодчиненныйЭлемент Из ЭлементДерева.ПолучитьЭлементы() Цикл
			ПометитьПодчиненные(ПодчиненныйЭлемент, Пометка);
		КонецЦикла;	
		
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти

