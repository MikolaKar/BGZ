
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыОтбора = Новый Структура("ЭтапДоговора", ПараметрКоманды);
	ПараметрыОтбора.Вставить("Договор", мРаботаСДоговорами.ПолучитьДоговорЭтапа(ПараметрКоманды));
	ПараметрыФормы = Новый Структура("Отбор", ПараметрыОтбора);
	ОткрытьФорму("РегистрНакопления.РасчетыСПокупателями.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

 