
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("Папка", ПредопределенноеЗначение("Справочник.ПапкиВнутреннихДокументов.мДела"));
	ОткрытьФорму("Справочник.ВнутренниеДокументы.Форма.ФормаСпискаСПапками", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
