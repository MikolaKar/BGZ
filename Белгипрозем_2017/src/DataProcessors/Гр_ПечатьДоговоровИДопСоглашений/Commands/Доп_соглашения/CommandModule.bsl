
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("Обработка.Гр_ПечатьДоговоровИДопСоглашений.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Договор", ПараметрКоманды);
		
	ОткрытьФорму("Обработка.Гр_ПечатьДоговоровИДопСоглашений.Форма.ФормаДопСоглашения", ПараметрыФормы, ПараметрКоманды, Новый УникальныйИдентификатор);
	
КонецПроцедуры
