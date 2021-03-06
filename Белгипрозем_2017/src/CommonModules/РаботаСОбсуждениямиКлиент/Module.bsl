////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с форумом.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует список раскрытых элементов дерева сообщений
// Параметры:
//			ДеревоЭлемент - элемент формы, отображающий дерево сообщений
//			МассивСтрокОдногоУровня - массив сообщений одного уровня
//			СписокРаскрытыхСообщений - список, который содержит раскрытые элементы дерева сообщений
Процедура ПолучитьМассивРаскрытыхСообщений(ДеревоЭлемент, МассивСтрокОдногоУровня, СписокРаскрытыхСообщений) Экспорт
	
	Для Каждого СтрокаОдногоУровня Из МассивСтрокОдногоУровня Цикл
		ИдСообщения = СтрокаОдногоУровня.ПолучитьИдентификатор();
		Если ДеревоЭлемент.Развернут(ИдСообщения) <> Неопределено 
			И ДеревоЭлемент.Развернут(ИдСообщения) Тогда
			СписокРаскрытыхСообщений.Добавить(СтрокаОдногоУровня.Ссылка);
		КонецЕсли;
		ПолучитьМассивРаскрытыхСообщений(ДеревоЭлемент, СтрокаОдногоУровня.ПолучитьЭлементы(), СписокРаскрытыхСообщений);
	КонецЦикла;
	
КонецПроцедуры

// Раскрывает указанные элементы дерева сообщений
// Параметры:
//			ДеревоЭлемент - элемент формы, отображающий дерево сообщений
//			ДеревоРеквизит - реквизит формы типа ДеревоЗначений, содержащий дерево сообщений
//			СписокСообщенийДляРазвертывания - список сообщений, которые необходимо развернуть в дереве сообщений
Процедура УстановитьРазвернутостьЭлементовДерева(ДеревоЭлемент, ДеревоРеквизит, СписокСообщенийДляРазвертывания) Экспорт
	
	Если СписокСообщенийДляРазвертывания <> Неопределено Тогда
		Для Каждого ЭлементСписка Из СписокСообщенийДляРазвертывания Цикл
			Индекс = -1;
			РаботаСОбсуждениямиКлиентСервер.НайтиСообщениеВДеревеПоСсылке(ДеревоРеквизит.ПолучитьЭлементы(), ЭлементСписка.Значение, Индекс);
			Если Индекс > -1 Тогда
				Если ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьЭлементы().Количество() > 0 Тогда
					ДеревоЭлемент.Развернуть(ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьИдентификатор(), Ложь);
				Иначе
					Если ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьРодителя() <> Неопределено Тогда
						ДеревоЭлемент.Развернуть(ДеревоРеквизит.НайтиПоИдентификатору(Индекс).ПолучитьРодителя().ПолучитьИдентификатор(), Ложь);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает в дереве сообщений текущую строку
// Параметры:
//			ДеревоЭлемент - элемент формы, отображающий дерево сообщений
//			ДеревоРеквизит - реквизит формы типа ДеревоЗначений, содержащий дерево сообщений
//			ТекущееСообщение - задача, которую необходимо выделить в дереве сообщений 
Процедура УстановитьТекущееСообщениеВДеревеПоСсылке(ДеревоЭлемент, ДеревоРеквизит, ТекущееСообщение) Экспорт
	
	Если ТекущееСообщение <> Неопределено И
		НЕ ТекущееСообщение.Пустая() Тогда
		Индекс = -1;
		РаботаСОбсуждениямиКлиентСервер.НайтиСообщениеВДеревеПоСсылке(ДеревоРеквизит.ПолучитьЭлементы(), ТекущееСообщение, Индекс);
		Если Индекс > -1 Тогда
			ДеревоЭлемент.ТекущаяСтрока = Индекс;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Функция выполняет изменение пометки прочтения элементов дерева на клиенте, без обновления всего дерева.
//
// Параметры:
//  ДеревоЭлемент - ТаблицаФормы - Таблица формы, содержащая дерево сообщений форума.
//  ДеревоРеквизит - ДанныеФормыДерево - Реквизит формы, содержащий дерево сообщений форума.
//  РежимОтображенияДеревом - Булево - Признак отображения сообщений формы в режиме дерева.
//  ПрочтенныеОбъекты - Массив, СправочникСсылка.СообщенияОбсуждений - Прочтенное сообщений или массив сообщений.
//                      Если был прочтен объект, отличный от сообщений обсуждений - функция вернет Ложь.
//
// Возвращаемое значение:
//  Булево - Признак того, было ли обновлено прочтение элементов.
//
Функция ОбновитьПрочтенностьЭлементовДерева(ДеревоЭлемент, ДеревоРеквизит, РежимОтображенияДеревом, ПрочтенныеОбъекты) Экспорт
	
	Если Не РежимОтображенияДеревом Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(ПрочтенныеОбъекты) = Тип("Массив") Тогда
		МассивПрочтенныеОбъекты = ПрочтенныеОбъекты;
	ИначеЕсли ТипЗнч(ПрочтенныеОбъекты) = Тип("СправочникСсылка.СообщенияОбсуждений") Тогда
		МассивПрочтенныеОбъекты = Новый Массив;
		МассивПрочтенныеОбъекты.Добавить(ПрочтенныеОбъекты);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	ЗначениеПометкиПрочтения = Ложь;
	СтрокиОбъектов = Новый Массив;
	ПолучитьМассивСообщенийВДереве(ДеревоРеквизит.ПолучитьЭлементы(),
		МассивПрочтенныеОбъекты, СтрокиОбъектов, ЗначениеПометкиПрочтения);
	
	Если СтрокиОбъектов.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для каждого СтрокаОбъекта Из СтрокиОбъектов Цикл
		СтрокаОбъекта.Прочтен = ЗначениеПометкиПрочтения;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Копирует переданную тему.
//
// Параметры:
//  Тема - СправочникСсылка.ТемыОбсуждений - Тема, которую необходимо скопировать.
//
Процедура СкопироватьТему(Тема) Экспорт
	
	ПараметрыФормы = Новый Структура("Основание");
	ПараметрыФормы.Основание = Тема;
	
	ОткрытьФорму("Справочник.СообщенияОбсуждений.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПолучитьМассивСообщенийВДереве(МассивСтрокОдногоУровня,
	СписокОбъектов, СтрокиОбъектов, ЕстьНепрочтенные)
	
	Для Каждого СтрокаОдногоУровня Из МассивСтрокОдногоУровня Цикл
		Если СписокОбъектов.Найти(СтрокаОдногоУровня.Ссылка) <> Неопределено Тогда
			СтрокиОбъектов.Добавить(СтрокаОдногоУровня);
			ЕстьНепрочтенные = ЕстьНепрочтенные Или Не СтрокаОдногоУровня.Прочтен;
		КонецЕсли;
		ПолучитьМассивСообщенийВДереве(СтрокаОдногоУровня.ПолучитьЭлементы(),
			СписокОбъектов, СтрокиОбъектов, ЕстьНепрочтенные);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти