#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриЗаписи(Отказ)
	
	Если Не Значение Тогда
		
		Менеджеры = РаботаВБезопасномРежимеСлужебный.МенеджерыКэшаПредоставленныхРазрешений();
		
		Для Каждого Менеджер Из Менеджеры Цикл
			
			Набор = Менеджер.СоздатьНаборЗаписей();
			Набор.Записать(Истина);
			
		КонецЦикла;
		
		Набор = РегистрыСведений.РежимыПодключенияВнешнихМодулей.СоздатьНаборЗаписей();
		Набор.Записать(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли