
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Заголовок") Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Представление ""%1"" в СВД'"), Запись.ВидДокумента);
	КонецЕсли;	
	
	Если Параметры.Свойство("ЭтоПредставлениеВСВД") Тогда
		Элементы.ВидДокумента.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры
