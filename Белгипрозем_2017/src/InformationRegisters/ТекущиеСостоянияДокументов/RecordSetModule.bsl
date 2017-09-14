#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтегрированныеСистемы = ОбработкаЗапросовXDTOПовтИсп.ПолучитьУзлыОбменаИнтегрированныхСистем();
	
	СостоянияСогласования = Новый Массив;
	СостоянияСогласования.Добавить(Перечисления.СостоянияДокументов.НаСогласовании);
	СостоянияСогласования.Добавить(Перечисления.СостоянияДокументов.Согласован);
	СостоянияСогласования.Добавить(Перечисления.СостоянияДокументов.НеСогласован);
	
	Для каждого Запись Из ЭтотОбъект Цикл
		// При необходимости создадим наборы записей для регистрации по ведущим измерениям.
		Если СостоянияСогласования.Найти(Запись.Состояние) <> Неопределено Тогда
			НаборЗаписей = РегистрыСведений.ТекущиеСостоянияДокументов.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Документ.Установить(Запись.Документ);
			НаборЗаписей.Отбор.Состояние.Установить(Запись.Состояние);
		Иначе
			НаборЗаписей = Неопределено;
		КонецЕсли;
		Для каждого Узел Из ИнтегрированныеСистемы Цикл
			ПланыОбмена.ЗарегистрироватьИзменения(Узел, Запись.Документ);
			Если НаборЗаписей <> Неопределено Тогда
				ПланыОбмена.ЗарегистрироватьИзменения(Узел, НаборЗаписей);
			КонецЕсли;
		КонецЦикла; 
	КонецЦикла; 
	
КонецПроцедуры

#КонецЕсли