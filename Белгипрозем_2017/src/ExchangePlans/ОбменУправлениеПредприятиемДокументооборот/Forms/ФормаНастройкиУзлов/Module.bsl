#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ПолучитьЗначенияПоУмолчанию") Тогда
		// Задание значений по умолчанию...
	КонецЕсли;
	ОбменДаннымиСервер.ФормаНастройкиУзловПриСозданииНаСервере(ЭтаФорма, Отказ);
	
КонецПроцедуры

#КонецОбласти