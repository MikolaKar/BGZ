
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураОтбор = Новый Структура;
	СтруктураОтбор.Вставить("Предмет", ПараметрКоманды);
	СтруктураОтбор.Вставить("ЭтоГруппа", Ложь);
	
	ПараметрыФормы = Новый Структура("Отбор", СтруктураОтбор);
	ОткрытьФорму("Справочник.Мероприятия.Форма.МероприятияПоПредмету", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
