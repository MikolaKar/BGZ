Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Количество() = 1 Тогда
		
		ЭП = Получить(0);
		
		Если ДелопроизводствоКлиентСервер.ЭтоДокумент(ЭП.Объект) Тогда
			
			// Добавление участников из самого документа
			Если РаботаСРабочимиГруппами.ПоОбъектуВедетсяАвтоматическоеЗаполнениеРабочейГруппы(ЭП.Объект) Тогда 
				
				ТаблицаУчастников = РаботаСРабочимиГруппами.ПолучитьРабочуюГруппуДокумента(ЭП.Объект);
				
				РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаУчастников, ЭП.УстановившийПодпись);	
					
				РаботаСРабочимиГруппами.ПерезаписатьРабочуюГруппуОбъекта(ЭП.Объект, ТаблицаУчастников, Истина);
					
			КонецЕсли;
			
		КонецЕсли;
			
	КонецЕсли;
	
	Если ТипЗнч(Отбор.Объект.Значение) = Тип("СправочникСсылка.ВерсииФайлов") Тогда
		
		ВерсияФайла = Отбор.Объект.Значение;
		РаботаСЭП.УстановитьСтатусПроверкиДляФайла(ВерсияФайла);
		
		ВладелецФайла = ВерсияФайла.Владелец.ВладелецФайла;
		Если ДелопроизводствоКлиентСервер.ЭтоДокумент(ВладелецФайла) Тогда
			РаботаСЭП.УстановитьСтатусПроверкиДляДокумента(ВладелецФайла);
		КонецЕсли;
		
	ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоДокумент(Отбор.Объект.Значение) Тогда
		РаботаСЭП.УстановитьСтатусПроверкиДляДокумента(Отбор.Объект.Значение);
	КонецЕсли;
	
КонецПроцедуры
