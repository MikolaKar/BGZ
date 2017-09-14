#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Предотвращает недопустимое изменение идентификаторов объектов метаданных.
// Выполняет обработку дублей подчиненного узла распределенной информационной базы.
//
Процедура ПередЗаписью(Отказ)
	
	Справочники.ИдентификаторыОбъектовМетаданных.ПроверкаИспользования();
	
	// Отключение механизма регистрации объектов.
	ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	
	// Регистрация объекта на всех узлах РИБ.
	Для Каждого ПланОбмена Из СтандартныеПодсистемыПовтИсп.ПланыОбменаРИБ() Цикл
		СтандартныеПодсистемыСервер.ЗарегистрироватьОбъектНаВсехУзлах(ЭтотОбъект, ПланОбмена);
	КонецЦикла;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("ВыполняетсяАвтоматическоеОбновлениеДанныхСправочника") Тогда
		
		Если ЭтоНовый() Тогда
		
			ВызватьИсключениеПоОшибке(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Создание нового идентификатора объекта метаданных
				           |возможно только автоматически при обновлении данных справочника.'"),
				ПолноеИмя));
				
		ИначеЕсли Справочники.ИдентификаторыОбъектовМетаданных.ЗапрещеноИзменятьПолноеИмя(ЭтотОбъект) Тогда
			
			ВызватьИсключениеПоОшибке(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При изменении идентификатора объекта метаданных указано
				           |полное имя ""%1"", которое может быть
				           |установлено только автоматически при обновлении данных справочника.'"),
				ПолноеИмя));
		
		ИначеЕсли Справочники.ИдентификаторыОбъектовМетаданных.ПолноеИмяИспользуется(ПолноеИмя, Ссылка) Тогда
			
			ВызватьИсключениеПоОшибке(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'При изменении идентификатора объекта метаданных указано
				           |полное имя ""%1"",
				           |которое уже используется в справочнике.'"),
				ПолноеИмя));
		
		КонецЕсли;
		
		Справочники.ИдентификаторыОбъектовМетаданных.ОбновитьСвойстваИдентификатора(ЭтотОбъект);
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		
		Если ЭтоНовый() Тогда
			ВызватьИсключениеПоОшибке(
				НСтр("ru = 'Добавление новых элементов может быть выполнено
				           |только в главном узле распределенной информационной базы.'"));
		КонецЕсли;
		
		Если НЕ ПометкаУдаления Тогда
			Если ВРег(ПолноеИмя) <> ВРег(ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ПолноеИмя")) Тогда
				ВызватьИсключениеПоОшибке(
					НСтр("ru = 'Изменение реквизита ""Полное имя"" может быть выполнено
					           |только в главном узле распределенной информационной базы.'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Предотвращает удаление идентификаторов объектов метаданных не помеченных на удаление.
Процедура ПередУдалением(Отказ)
	
	Справочники.ИдентификаторыОбъектовМетаданных.ПроверкаИспользования();
	
	// Отключение механизма регистрации объектов.
	// Ссылки идентификаторов удаляются независимо во всех узлах
	// через механизм пометки удаления и удаления помеченных объектов.
	ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПометкаУдаления Тогда
		ВызватьИсключениеПоОшибке(
			НСтр("ru = 'Удаление идентификаторов объектов метаданных, у которых значение
			           |реквизита ""Пометка удаления"" установлено Ложь недопустимо.'"));
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Процедура ВызватьИсключениеПоОшибке(ТекстОшибки);
	
	ВызватьИсключение
		НСтр("ru = 'Ошибка при работе со справочником ""Идентификаторы объектов метаданных"".'") + "
		           |
		           |" + ТекстОшибки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
