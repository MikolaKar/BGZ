
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Основание", ПараметрКоманды);
	ПараметрыФормы.Вставить("ВидДокумента", ПредопределенноеЗначение("Справочник.ВидыВнутреннихДокументов.АктВыполненныхРабот"));

	Открытьформу("Справочник.ВнутренниеДокументы.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры
