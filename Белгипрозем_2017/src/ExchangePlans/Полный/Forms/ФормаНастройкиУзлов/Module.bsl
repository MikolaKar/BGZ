
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПолучитьЗначенияПоУмолчанию") Тогда
		// Задание значений по умолчанию...
	КонецЕсли;
	ОбменДаннымиСервер.ФормаНастройкиУзловПриСозданииНаСервере(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОбменДаннымиКлиент.ФормаНастройкиУзловКомандаЗакрытьФорму(ЭтаФорма);
	
КонецПроцедуры