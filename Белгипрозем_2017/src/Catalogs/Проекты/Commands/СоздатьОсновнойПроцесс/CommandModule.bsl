
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
			
	ПараметрыФормы = Новый Структура("Проект", ПараметрКоманды);
	ОткрытьФорму("ОбщаяФорма.СозданиеБизнесПроцесса", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
