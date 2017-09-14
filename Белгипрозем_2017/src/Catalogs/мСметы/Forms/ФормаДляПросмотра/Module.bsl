
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    Если Параметры.Свойство("КодСметы") Тогда
        Если ЗначениеЗаполнено(Параметры.КодСметы) Тогда
            Смета = Справочники.мСметы.НайтиПоКоду(Параметры.КодСметы);
            СметаТабдок = Справочники.мСметы.ПечатьСметы(Смета, Новый СписокЗначений); 
        КонецЕсли; 
    КонецЕсли; 
КонецПроцедуры
