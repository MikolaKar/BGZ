
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	КлючеваяОперация = "ВходящиеДокументыОткрытиеФормыОбращенияГраждан";
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	
	ОткрытьФорму("Справочник.ВходящиеДокументы.Форма.ОбращенияГраждан", , ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
