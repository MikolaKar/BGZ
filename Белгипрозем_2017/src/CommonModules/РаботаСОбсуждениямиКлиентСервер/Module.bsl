////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с форумом.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Осуществляет поиск сообщения в дереве сообщений
// Параметры:КоллекцияСообщенийОдногоУровня - список сообщений одного уровня дерева
//			ИскомоеСообщение - сообщение, которое необходимо найти
//			Индекс = значение индекса найденной задачи в дереве. Если сообщение не найдено, 
//						значение параметра не изменяется.
Процедура НайтиСообщениеВДеревеПоСсылке(КоллекцияСообщенийОдногоУровня, ИскомоеСообщение, Индекс) Экспорт
	
	Если ТипЗнч(Индекс) = Тип("Число") И Индекс > -1 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Сообщение Из КоллекцияСообщенийОдногоУровня Цикл
		Если Сообщение.Ссылка = ИскомоеСообщение Тогда
			Индекс = Сообщение.ПолучитьИдентификатор();
		Иначе
			НайтиСообщениеВДеревеПоСсылке(Сообщение.ПолучитьЭлементы(), ИскомоеСообщение, Индекс);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Формирует текстовое представление сообщения
Функция СформироватьТекстовоеПредставлениеСообщения(ТекстСообщения, АвторСообщения, ДатаСообщения) Экспорт
	
	ТестовоеПредставлениеСообщения =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Автор: %1
				|Дата сообщения: %2
				|
				|%3'"),
			АвторСообщения,
			ДатаСообщения,
			ТекстСообщения);
	
	Возврат ТестовоеПредставлениеСообщения;
	
КонецФункции

#КонецОбласти