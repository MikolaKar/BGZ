// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
    УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    // СтандартныеПодсистемы.Печать
    УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
    // Конец СтандартныеПодсистемы.Печать

	Если ЗначениеЗаполнено(Параметры.Поручение) Тогда
		Заказчик = Параметры.Поручение.Отправитель;
		Поручение = Параметры.Поручение;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыСписка()
	УстановитьПараметрСписка("Заказчик", Заказчик);
	УстановитьПараметрСписка("ОбъектРабот", ОбъектРабот);
	УстановитьПараметрСписка("Поручение", Поручение);
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьПараметрСписка(Имя, Значение)
	Список.Параметры.УстановитьЗначениеПараметра(Имя, Значение);
	Если ЗначениеЗаполнено(Значение) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ОтборПо"+Имя, Истина);
	Иначе	
		Список.Параметры.УстановитьЗначениеПараметра("ОтборПо"+Имя, Ложь);
	КонецЕсли; 	
КонецПроцедуры // УстановитьПараметрСписка()

&НаКлиенте
Процедура ЗаказчикОтборПриИзменении(Элемент)
	УстановитьПараметрыСписка();
КонецПроцедуры

&НаКлиенте
Процедура ОбъектРаботОтборПриИзменении(Элемент)
	УстановитьПараметрыСписка();
КонецПроцедуры

&НаКлиенте
Процедура ПоручениеОтборПриИзменении(Элемент)
	УстановитьПараметрыСписка();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьПараметрыСписка();
КонецПроцедуры

