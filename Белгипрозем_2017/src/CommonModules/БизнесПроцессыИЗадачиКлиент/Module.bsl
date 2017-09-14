////////////////////////////////////////////////////////////////////////////////
// Клиентские процедуры подсистемы 

// Стандартный обработчик оповещения для форм выполнения задач.
// Для вызова из обработчика события формы ОбработкаОповещения.
//
// Параметры
//  Форма       - УправляемаяФорма  - форма выполнения задачи.
//  ИмяСобытия  - Строка            - имя события.
//  Параметр    - произвольный тип  - параметр события
//  Источник    - произвольный тип  - источник события.
//
Процедура ФормаЗадачиОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" 
		И НЕ Форма.Модифицированность 
		И (Источник = Форма.Объект.Ссылка ИЛИ (ТипЗнч(Источник) = Тип("Массив") 
		И Источник.Найти(Форма.Объект.Ссылка) <> Неопределено)) Тогда
		Если Параметр.Свойство("Перенаправлена") Тогда
			Форма.Закрыть();
		Иначе
			Форма.Прочитать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Стандартный обработчик ПередНачаломДобавления для списков задач.
// Для вызова из обработчика события таблицы формы ПередНачаломДобавления.
//
// Параметры
//   аналогичны параметрам обработчика таблицы формы ПередНачаломДобавления
//
Процедура СписокЗадачПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	Если Копирование Тогда
		Задача = Элемент.ТекущаяСтрока;
		Если НЕ ЗначениеЗаполнено(Задача) Тогда
			Возврат;
		КонецЕсли;
		ПараметрыФормы = Новый Структура("Основание", Задача);
	КонецЕсли;
	СоздатьЗадание(Форма, ПараметрыФормы);
	Отказ = Истина;
	
КонецПроцедуры

// Стандартный обработчик Выбор для списков задач.
// Для вызова из обработчика события таблицы формы Выбор.
//
// Параметры
//   аналогичны параметрам обработчика таблицы формы Выбор
//
Процедура СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(ВыбраннаяСтрока) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		Возврат;	
	КонецЕсли;
	СтандартнаяОбработка = НЕ ОткрытьФормуВыполненияЗадачи(ВыбраннаяСтрока);
	
КонецПроцедуры

// Стандартный обработчик ПередНачаломИзменения для списков задач.
// Для вызова из обработчика события таблицы формы ПередНачаломИзменения.
//
// Параметры
//   аналогичны параметрам обработчика таблицы формы ПередНачаломИзменения
//
Процедура СписокЗадачПередНачаломИзменения(Элемент, Отказ) Экспорт
	
	Если ТипЗнч(Элемент.ТекущаяСтрока) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		Возврат;	
	КонецЕсли;
	Отказ = ОткрытьФормуВыполненияЗадачи(Элемент.ТекущаяСтрока);
	
КонецПроцедуры

// Открыть форму выполнения задачи, которую предоставляет бизнес-процесс.  
//
// Параметры
//  ЗадачаСсылка       - ЗадачаИсполнителяСсылка  - задача.
//
Функция ОткрытьФормуВыполненияЗадачи(Знач ЗадачаСсылка) Экспорт
	
	ПараметрыФормы = БизнесПроцессыИЗадачиВызовСервера.ПолучитьФормуВыполненияЗадачи(ЗадачаСсылка);
	ИмяФормыВыполненияЗадачи = "";
	Результат = ПараметрыФормы.Свойство("ИмяФормы", ИмяФормыВыполненияЗадачи);
	Если Результат Тогда
		ОткрытьФорму(ИмяФормыВыполненияЗадачи, ПараметрыФормы.ПараметрыФормы);
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

// Записать и закрыть форму выполнения задачи.
//
// Параметры
//  Форма  - УправляемаяФорма - форма выполнения задачи.
//  ВыполнитьЗадачу  - Булево - задача записывается в режиме выполнения.
//  ПараметрыОповещения - Структура - дополнительные параметры оповещения.
//
// Возвращаемое значение:
//   Булево   - Истина, если запись прошла успешно.
//
Функция ЗаписатьИЗакрытьВыполнить(Форма, ВыполнитьЗадачу = Ложь, ПараметрыОповещения = Неопределено) Экспорт
	
	ОчиститьСообщения();
	
	НовыйОбъект = Форма.Объект.Ссылка.Пустая();
	ТекстОповещения = "";
	Если ПараметрыОповещения = Неопределено Тогда
		ПараметрыОповещения = Новый Структура;
	КонецЕсли;
	Если НЕ Форма.НачальныйПризнакВыполнения И ВыполнитьЗадачу Тогда
		Если НЕ Форма.Записать(Новый Структура("ВыполнитьЗадачу", Истина)) Тогда
			Возврат Ложь;
		КонецЕсли;
		ТекстОповещения = НСтр("ru = 'Задача выполнена'");
	Иначе
		Если НЕ Форма.Записать() Тогда
			Возврат Ложь;
		КонецЕсли;
		ТекстОповещения = ?(НовыйОбъект, НСтр("ru = 'Задача создана'"), НСтр("ru = 'Задача изменена'"));
	КонецЕсли;
	
	Оповестить("Запись_ЗадачаИсполнителя", ПараметрыОповещения, Форма.Объект.Ссылка);
	ПоказатьОповещениеПользователя(ТекстОповещения,
		ПолучитьНавигационнуюСсылку(Форма.Объект.Ссылка),
		Строка(Форма.Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	Форма.Закрыть();
	Возврат Истина;
	
КонецФункции

// Открыть форму для ввода нового задания.
//
// Параметры
//  ФормаВладелец  - УправляемаяФорма - форма, которая должна быть владельцем для открываемой.
//  ПараметрыФормы - Структура - параметры открываемой формы.
//
Процедура СоздатьЗадание(Знач ФормаВладелец = Неопределено, Знач ПараметрыФормы = Неопределено) Экспорт
	ОткрытьФорму("БизнесПроцесс.Поручение.ФормаОбъекта", ПараметрыФормы, ФормаВладелец);
КонецПроцедуры	

// Выполнить перенаправление задачи другому исполнителю.
//
// Параметры
//  Задача  - ЗадачаИсполнителяСсылка - перенаправляемая задача.
//  ВладелецФорма  - УправляемаяФорма - форма, из которой выполняется перенаправление.
//
// Возвращаемое значение:
//   Булево   - Истина, если перенаправление прошло успешно.
//
Функция ПеренаправитьЗадачу(Задача, ВладелецФорма = Неопределено) Экспорт

	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Задача", Задача);
	
	УникальныйИдентификаторФормыВладельца = Неопределено;
	Если ВладелецФорма <> Неопределено Тогда
		УникальныйИдентификаторФормыВладельца = ВладелецФорма.УникальныйИдентификатор;
	КонецЕсли;
	
	ПараметрыОповещения.Вставить("УникальныйИдентификаторФормыВладельца", УникальныйИдентификаторФормыВладельца);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершениеПеренаправленияЗадачи", ЭтотОбъект, ПараметрыОповещения);
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Задача", Задача);
	ПараметрыФормы.Вставить("КоличествоЗадач", 1);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Перенаправить задачу'"));
	ОткрытьФорму("Задача.ЗадачаИсполнителя.Форма.ПеренаправлениеЗадачи",
		ПараметрыФормы, 
		ВладелецФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Возврат Ложь;
	
КонецФункции

Процедура ЗавершениеПеренаправленияЗадачи(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ЗадачаПеренаправлена = БизнесПроцессыИЗадачиСервер.ПеренаправитьЗадачу(
		Параметры.Задача, Результат, Параметры.УникальныйИдентификаторФормыВладельца);
		
	Если ЗадачаПеренаправлена Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Задача перенаправлена'"),
			ПолучитьНавигационнуюСсылку(Параметры.Задача),
			Строка(Параметры.Задача));
			
		Оповестить("Запись_ЗадачаИсполнителя", , Параметры.Задача);
		Оповестить("Перенаправление_ЗадачаИсполнителя", , Параметры.Задача);
	КонецЕсли;

	
КонецПроцедуры

// Открыть форму с дополнительной информацией о задаче.  
//
// Параметры
//  ЗадачаСсылка       - ЗадачаИсполнителяСсылка  - задача.
//
Функция ОткрытьДопИнформациюОЗадаче(Знач ЗадачаСсылка) Экспорт
	
	ОткрытьФорму("Задача.ЗадачаИсполнителя.Форма.Дополнительно", 
		Новый Структура("Ключ", ЗадачаСсылка));
	
	КонецФункции
	
////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

///////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в эту подсистему

// Вызывается при открытии объекта из полнотекстового поиска
// Функция ПриОткрытииОбъекта позволяет настроить
// поведение при открытии результата из списка найденного в полнотекстовом поиске
// Например, это необходимо при использовании подсистемы "Бизнес-процессы и задачи".
//
// Параметры
//  Значение - объект, найденный в полнотекстовом поиске, например СправочникСсылка
//  СтандартнаяОбработка - Булево - по умолчанию Истина. 
//   Если поведение изменено (по собственной механике делается открытие формы для Значение),
//   то СтандартнаяОбработка надо установить в Ложь
// 
// При использовании подсистемы "Бизнес-процессы и задачи" нужно
// вписать следующий код:
//
//Если ТипЗнч(Значение) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
//	Если БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Значение) Тогда
//		СтандартнаяОбработка = Ложь;
//	КонецЕсли;
//КонецЕсли;
//
Процедура ПолнотекстовыйПоискПриОткрытииОбъекта(Значение, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(Значение) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		Если ОткрытьФормуВыполненияЗадачи(Значение) Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

// Стандартный обработчик ПометкаУдаления для списков бизнес-процессов.
// Для вызова из обработчика события списка ПометкаУдаления.
//
// Параметры
//   Список  - ТаблицаФормы - элемент управления (таблица формы) со списком бизнес-процессов.
//
Процедура СписокБизнесПроцессовПометкаУдаления(Список) Экспорт
	ВыделенныеСтроки = Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки = Неопределено ИЛИ ВыделенныеСтроки.Количество() <= 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("СписокБизнесПроцессовПометкаУдаленияЗавершение", ЭтотОбъект, Список);
		
	ПоказатьВопрос(
		ОписаниеОповещения,
		НСтр("ru = 'Изменить пометку удаления?'"),
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

Процедура СписокБизнесПроцессовПометкаУдаленияЗавершение(Результат, Список) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ВыделенныеСтроки = Список.ВыделенныеСтроки;
	
	БизнесПроцессСсылка = БизнесПроцессыИЗадачиВызовСервера.ПометитьНаУдалениеБизнесПроцессы(ВыделенныеСтроки);
	Список.Обновить();
	ПоказатьОповещениеПользователя(НСтр("ru = 'Пометка удаления изменена.'"), 
		?(БизнесПроцессСсылка <> Неопределено, ПолучитьНавигационнуюСсылку(БизнесПроцессСсылка), ""),
		?(БизнесПроцессСсылка <> Неопределено, Строка(БизнесПроцессСсылка), ""));
	
КонецПроцедуры