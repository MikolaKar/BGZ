
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ЗначениеОтбора", Параметры.ЗначениеОтбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереносДокументовДела(Команда)
	
	ПараметрыФормы = Новый Структура("ПеренестиИзДела", Параметры.ЗначениеОтбора);
	Открытьформу("Справочник.ДелаХраненияДокументов.Форма.ФормаПереносаДокументовДела", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры