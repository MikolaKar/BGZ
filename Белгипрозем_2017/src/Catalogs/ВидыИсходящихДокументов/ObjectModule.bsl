#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	ВключенУчетПоНоменклатуреДел = ВестиУчетПоНоменклатуреДел И Константы.ИспользоватьНоменклатуруДел.Получить();
	
	// Подсистема Свойства
	УправлениеСвойствами.ПередЗаписьюВидаОбъекта(ЭтотОбъект, "Справочник_ИсходящиеДокументы");
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НаборСвойств = Неопределено;
	
КонецПроцедуры

#КонецЕсли