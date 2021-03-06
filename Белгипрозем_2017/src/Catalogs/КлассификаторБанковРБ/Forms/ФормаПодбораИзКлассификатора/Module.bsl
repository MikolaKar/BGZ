&НаСервере
Процедура ВывестиТабДок();
	Макет = Справочники.КлассификаторБанковРБ.ПолучитьМакет("КлассификаторБанковРБ");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьБанки = Макет.ПолучитьОбласть("Банки");
	ТабДок.Вывести(ОбластьШапка);
	ТабДок.Вывести(ОбластьБанки);
	ТабДок.ПоказатьУровеньГруппировокСтрок(1);
	ТабДок.ОтображатьГруппировки = Истина;
	ТабДок.ПовторятьПриПечатиСтроки = Макет.ПовторятьПриПечатиСтроки;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВывестиТабДок();
КонецПроцедуры

Функция ПолучитьИмяОбласти(НомерСтроки, НомерКолонки)      
	Возврат "R"+НомерСтроки+"C"+НомерКолонки;
КонецФункции

&НаСервере
Процедура ПодобратьБанк(Банк)
	НайденБанк = Справочники.КлассификаторБанковРБ.НайтиПоКоду(Банк.МФО);
	
	НовыйБанк = ?(ЗначениеЗаполнено(НайденБанк), НайденБанк.ПолучитьОбъект(), Справочники.КлассификаторБанковРБ.СоздатьЭлемент());
	
	НовыйБанк.Адрес = Банк.Адрес;
	НовыйБанк.Код = Банк.МФО;
	НовыйБанк.Наименование = Банк.Наименование;
	НовыйБанк.Телефоны = Банк.Телефоны;
	
	НовыйБанк.Записать();	
	
КонецПроцедуры

&НаКлиенте
Процедура ТабДокВыбор(Элемент, Область, СтандартнаяОбработка)
	НомерСтроки = Число(Сред(Область.Имя, 2, Найти(Область.Имя, "C")-2));
	  
	Если НомерСтроки>5 Тогда
		Банк = Новый Структура;
		Банк.Вставить("МФО", СокрЛП(ТабДок.Область(ПолучитьИмяОбласти(НомерСтроки,3)).Текст));
		Банк.Вставить("Наименование", СокрЛП(ТабДок.Область(ПолучитьИмяОбласти(НомерСтроки,5)).Текст));
		Банк.Вставить("Адрес", СокрЛП(ТабДок.Область(ПолучитьИмяОбласти(НомерСтроки,6)).Текст));
		Банк.Вставить("Телефоны", СокрЛП(ТабДок.Область(ПолучитьИмяОбласти(НомерСтроки,7)).Текст));
		
		ПодобратьБанк(Банк);
		ВладелецФормы.Элементы.Список.Обновить();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры
