Процедура ОтправитьСообщение(ТранспортСсылка, Сообщение) Экспорт
	
	НастройкаТранспорта = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТранспортСсылка, "Настройка");
	МенеджерНастройки = ОбщегоНазначения.МенеджерОбъектаПоСсылке(НастройкаТранспорта);
	
	МенеджерНастройки.ОтправитьСообщение(НастройкаТранспорта, Сообщение);
	
КонецПроцедуры