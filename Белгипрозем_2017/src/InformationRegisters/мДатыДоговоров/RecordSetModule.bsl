
Процедура ПередЗаписью(Отказ, Замещение)
     Если Количество() = 0 Тогда
        // Удаление
        Если ЭтотОбъект.Отбор.ВидДатыДоговора.Значение = Справочники.мВидыДатДоговоров.ДатаПодписанияЗаказчиком Тогда
            НаборЗаписей = РегистрыСведений.мДатыДоговоров.СоздатьНаборЗаписей();
            
            ВидДатыДоговораПлановыйСрок = Справочники.мВидыДатДоговоров.ПлановыйСрок;
            
            НаборЗаписей.Отбор.Период.Установить(ЭтотОбъект.Отбор.Период.Значение);
            НаборЗаписей.Отбор.ВидДатыДоговора.Установить(ВидДатыДоговораПлановыйСрок);
            НаборЗаписей.Отбор.Основание.Установить(ЭтотОбъект.Отбор.Основание);
            НаборЗаписей.Отбор.ЭтапДоговора.Установить(ЭтотОбъект.Отбор.ЭтапДоговора);
            
            НаборЗаписей.Записать(Истина);
            
        ИначеЕсли ЭтотОбъект.Отбор.ВидДатыДоговора.Значение = Справочники.мВидыДатДоговоров.ДатаПродления Тогда
            НаборЗаписей = РегистрыСведений.мДатыДоговоров.СоздатьНаборЗаписей();
            
            ВидДатыДоговораПлановыйСрок = Справочники.мВидыДатДоговоров.ПлановыйСрок;
            
            НаборЗаписей.Отбор.Период.Установить(ЭтотОбъект.Отбор.Период.Значение);
            НаборЗаписей.Отбор.ВидДатыДоговора.Установить(ВидДатыДоговораПлановыйСрок);
            НаборЗаписей.Отбор.Основание.Установить(ЭтотОбъект.Отбор.Основание);
            НаборЗаписей.Отбор.ЭтапДоговора.Установить(ЭтотОбъект.Отбор.ЭтапДоговора);
            
            НаборЗаписей.Записать(Истина);    
        КонецЕсли;
    КонецЕсли; 
    
КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект[0], ДанныеЗаполнения);
	КонецЕсли;
КонецПроцедуры

