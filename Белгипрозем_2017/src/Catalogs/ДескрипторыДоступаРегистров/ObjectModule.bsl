
Процедура ПриЗаписи(Отказ)
	
	// Если это очистка устаревших дескрипторов, пересчет прав не нужен
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.ДескрипторыДоступаРегистров.ОбновитьПрава(
		ЭтотОбъект,
		Неопределено,  // Протокол
		Истина);       // Немедленно
	
КонецПроцедуры
