
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    Если Параметры.Свойство("АктПроверки") Тогда
        Если ЗначениеЗаполнено(Параметры.АктПроверки) Тогда
            Табдок = Справочники.мАктыПроверки.ПечатьАктПроверки(Параметры.АктПроверки, Новый СписокЗначений); 
        КонецЕсли; 
    КонецЕсли; 
КонецПроцедуры
