#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции

// Выполняет загрузку данных из файла сообщения обмена
//
// Параметры:
//  Отказ - Булево - флаг отказа; поднимается в случае возникновения ошибок при обработке сообщения обмена
// 
Процедура ВыполнитьЗагрузкуДанных(Отказ, Знач ЗагрузитьТолькоПараметры) Экспорт
	
	Если Не ЭтоУзелРаспределеннойИнформационнойБазы() Тогда
		
		// обмен не по правилам конвертации не поддерживается
		ЗафиксироватьЗавершениеОбмена(Отказ,, ОшибкаВидаОбменаДанными());
		Возврат;
	КонецЕсли;
	
	ЗагрузитьМетаданные = ЗагрузитьТолькоПараметры
		И ОбменДаннымиСервер.ЭтоПодчиненныйУзелРИБ()
		И (ОбменДаннымиВызовСервера.ПовторитьЗагрузкуСообщенияОбменаДаннымиПередЗапуском()
			ИЛИ НЕ ОбменДаннымиВызовСервера.РежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
					"СообщениеПолученоИзКэша"));
	
	ЧтениеXML = Новый ЧтениеXML;
	
	Попытка
		ЧтениеXML.ОткрытьФайл(ИмяФайлаСообщенияОбмена());
	Исключение
		
		// ошибка открытия файла сообщения обмена
		ЗафиксироватьЗавершениеОбмена(Отказ, ОписаниеОшибки(), ОшибкаОткрытияФайлаСообщенияОбмена());
		Возврат;
	КонецПопытки;
	
	ПрочитатьФайлСообщенияОбмена(Отказ, ЧтениеXML, ЗагрузитьТолькоПараметры, ЗагрузитьМетаданные);
	
	ЧтениеXML.Закрыть();
КонецПроцедуры

// Выполняет выгрузку данных в файл сообщения обмена
//
// Параметры:
//  Отказ - Булево - флаг отказа; поднимается в случае возникновения ошибок при обработке сообщения обмена
// 
Процедура ВыполнитьВыгрузкуДанных(Отказ) Экспорт
	
	Если Не ЭтоУзелРаспределеннойИнформационнойБазы() Тогда
		
		// обмен не по правилам конвертации не поддерживается
		ЗафиксироватьЗавершениеОбмена(Отказ,, ОшибкаВидаОбменаДанными());
		Возврат;
	КонецЕсли;
	
	ЗаписьXML = Новый ЗаписьXML;
	
	Попытка
		ЗаписьXML.ОткрытьФайл(ИмяФайлаСообщенияОбмена());
	Исключение
		
		// ошибка открытия файла сообщения обмена
		ЗафиксироватьЗавершениеОбмена(Отказ, ОписаниеОшибки(), ОшибкаОткрытияФайлаСообщенияОбмена());
		Возврат;
	КонецПопытки;
	
	ЗаписатьИзмененияВФайлСообщенияОбмена(Отказ, ЗаписьXML);
	
	ЗаписьXML.Закрыть();
	
КонецПроцедуры

// Устанавливает локальной переменной ПолеИмяФайлаСообщенияОбмена
// строку с полным именем файла сообщения обмена для загрузки или выгрузки данных.
// Как правило, файл сообщения обмена располагается 
// во временном каталоге пользователя операционной системы.
//
// Параметры:
//  ИмяФайла - Строка - полное имя файла сообщения обмена для выгрузки или загрузки данных
// 
Процедура УстановитьИмяФайлаСообщенияОбмена(Знач ИмяФайла) Экспорт
	
	ПолеИмяФайлаСообщенияОбмена = ИмяФайла;
	
КонецПроцедуры

//

Процедура ПрочитатьФайлСообщенияОбмена(Отказ, ЧтениеXML, Знач ЗагрузитьТолькоПараметры, Знач ЗагрузитьМетаданные)
	
	ЧтениеСообщения = ПланыОбмена.СоздатьЧтениеСообщения();
	
	Попытка
		ЧтениеСообщения.НачатьЧтение(ЧтениеXML, ДопустимыйНомерСообщения.Больший);
	Исключение
		// задан неизвестный план обмена;
		// указан узел, не входящий в план обмена;
		// номер сообщения не соответствует ожидаемому
		ЗафиксироватьЗавершениеОбмена(Отказ, ОписаниеОшибки(), ОшибкаНачалаЧтенияФайлаСообщенияОбмена());
		Возврат;
	КонецПопытки;
	
	Если ЗагрузитьТолькоПараметры Тогда
		
		Если ЗагрузитьМетаданные Тогда
			
			Попытка
				
				УстановитьПривилегированныйРежим(Истина);
				ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
					"ЗагрузкаПараметровРаботыПрограммы", Истина);
				УстановитьПривилегированныйРежим(Ложь);
				
				// Получаем изменения конфигурации, изменения данных игнорируем.
				ПланыОбмена.ПрочитатьИзменения(ЧтениеСообщения, КоличествоЭлементовВТранзакции);
				
				// Читаем приоритетные данные (идентификаторы объектов метаданных)
				ПрочитатьПриоритетныеИзмененияИзСообщенияОбмена(ЧтениеСообщения);
				
				// Сообщение считаем не принятым, для этого прерываем чтение.
				ЧтениеСообщения.ПрерватьЧтение();
				
				УстановитьПривилегированныйРежим(Истина);
				ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
					"ЗагрузкаПараметровРаботыПрограммы", Ложь);
				УстановитьПривилегированныйРежим(Ложь);
			Исключение
				УстановитьПривилегированныйРежим(Истина);
				ОбменДаннымиСервер.УстановитьРежимЗагрузкиСообщенияОбменаДаннымиПередЗапуском(
					"ЗагрузкаПараметровРаботыПрограммы", Ложь);
				УстановитьПривилегированныйРежим(Ложь);
				
				ЧтениеСообщения.ПрерватьЧтение();
				ЗафиксироватьЗавершениеОбмена(Отказ, ОписаниеОшибки(), ОшибкаЧтенияФайлаСообщенияОбмена());
				Возврат;
			КонецПопытки;
			
		Иначе
			
			Попытка
				
				// Пропускаем изменения конфигурации и изменения данных в сообщении обмена
				ЧтениеСообщения.ЧтениеXML.Пропустить(); // <Changes>...</Changes>
				
				ЧтениеСообщения.ЧтениеXML.Прочитать(); // </Changes>
				
				// Читаем приоритетные данные (идентификаторы объектов метаданных)
				ПрочитатьПриоритетныеИзмененияИзСообщенияОбмена(ЧтениеСообщения);
				
				// Сообщение считаем не принятым, для этого прерываем чтение.
				ЧтениеСообщения.ПрерватьЧтение();
			Исключение
				ЧтениеСообщения.ПрерватьЧтение();
				ЗафиксироватьЗавершениеОбмена(Отказ, ОписаниеОшибки(), ОшибкаЧтенияФайлаСообщенияОбмена());
				Возврат
			КонецПопытки;
			
		КонецЕсли;
		
	Иначе
		
		Попытка
			
			// Получаем изменения конфигурации и изменения данных из сообщения обмена
			ПланыОбмена.ПрочитатьИзменения(ЧтениеСообщения, КоличествоЭлементовВТранзакции);
			
			// Читаем приоритетные данные (идентификаторы объектов метаданных)
			ПрочитатьПриоритетныеИзмененияИзСообщенияОбмена(ЧтениеСообщения);
			
			// Сообщение считаем принятым
			ЧтениеСообщения.ЗакончитьЧтение();
		Исключение
			ЧтениеСообщения.ПрерватьЧтение();
			ЗафиксироватьЗавершениеОбмена(Отказ, ОписаниеОшибки(), ОшибкаЧтенияФайлаСообщенияОбмена());
			Возврат
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьИзмененияВФайлСообщенияОбмена(Отказ, ЗаписьXML)
	
	ЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	
	Попытка
		ЗаписьСообщения.НачатьЗапись(ЗаписьXML, УзелИнформационнойБазы);
	Исключение
		ЗафиксироватьЗавершениеОбмена(Отказ, ОписаниеОшибки(), ОшибкаНачалаЗаписиФайлаСообщенияОбмена());
		Возврат;
	КонецПопытки;
	
	Попытка
		
		ОбменДаннымиВызовСервера.ОчиститьПриоритетныеДанныеОбмена();
		
		// Записываем изменения конфигурации и изменения данных в сообщение обмена
		ПланыОбмена.ЗаписатьИзменения(ЗаписьСообщения, КоличествоЭлементовВТранзакции);
		
		// Записываем приоритетные данные в конец сообщения обмена
		ЗаписатьПриоритетныеИзмененияВСообщениеОбмена(ЗаписьСообщения);
		
		ЗаписьСообщения.ЗакончитьЗапись();
	Исключение
		ЗаписьСообщения.ПрерватьЗапись();
		ЗафиксироватьЗавершениеОбмена(Отказ, ОписаниеОшибки(), ОшибкаЗаписиФайлаСообщенияОбмена());
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

// Запись приоритетных данных в сообщение обмена.
// Например, идентификаторов объектов метаданных.
//
Процедура ЗаписатьПриоритетныеИзмененияВСообщениеОбмена(Знач ЗаписьСообщения)
	
	// Записываем элемент <Parameters>
	ЗаписьСообщения.ЗаписьXML.ЗаписатьНачалоЭлемента("Parameters");
	
	Если ЗаписьСообщения.Получатель <> ПланыОбмена.ГлавныйУзел() Тогда
		
		// Выгружаем приоритетные данные обмена (предопределенные элементы)
		ПриоритетныеДанныеОбмена = ОбменДаннымиВызовСервера.ПриоритетныеДанныеОбмена();
		
		Если ПриоритетныеДанныеОбмена.Количество() > 0 Тогда
			
			ВыборкаИзменений = ОбменДаннымиСервер.ВыбратьИзменения(
				ЗаписьСообщения.Получатель,
				ЗаписьСообщения.НомерСообщения,
				ПриоритетныеДанныеОбмена);
			
			НачатьТранзакцию();
			Попытка
				
				Пока ВыборкаИзменений.Следующий() Цикл
					
					ЗаписатьXML(ЗаписьСообщения.ЗаписьXML, ВыборкаИзменений.Получить());
					
				КонецЦикла;
				
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
				ВызватьИсключение;
			КонецПопытки;
			
		КонецЕсли;
		
		Если Не СтандартныеПодсистемыПовтИсп.ОтключитьСправочникИдентификаторыОбъектовМетаданных() Тогда
			
			// Выгружаем справочник идентификаторов объектов метаданных
			ВыборкаИзменений = ОбменДаннымиСервер.ВыбратьИзменения(
				ЗаписьСообщения.Получатель,
				ЗаписьСообщения.НомерСообщения,
				Метаданные.Справочники["ИдентификаторыОбъектовМетаданных"]);
			
			НачатьТранзакцию();
			Попытка
				
				Пока ВыборкаИзменений.Следующий() Цикл
					
					ЗаписатьXML(ЗаписьСообщения.ЗаписьXML, ВыборкаИзменений.Получить());
					
				КонецЦикла;
				
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
				ВызватьИсключение;
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаписьСообщения.ЗаписьXML.ЗаписатьКонецЭлемента(); // Parameters
	
КонецПроцедуры

// Чтение приоритетных данных из сообщения обмена.
// Например, идентификаторов объектов метаданных.
//
Процедура ПрочитатьПриоритетныеИзмененияИзСообщенияОбмена(Знач ЧтениеСообщения)
	
	Если ЧтениеСообщения.Отправитель = ПланыОбмена.ГлавныйУзел() Тогда
		
		ЧтениеСообщения.ЧтениеXML.Прочитать(); // <Parameters>
		
		НачатьТранзакцию();
		Попытка
			
			ОбъектыИдентификаторов = Новый Массив;
			
			Пока ВозможностьЧтенияXML(ЧтениеСообщения.ЧтениеXML) Цикл
				
				Данные = ПрочитатьXML(ЧтениеСообщения.ЧтениеXML);
				Данные.ОбменДанными.Загрузка = Истина;
				Данные.ОбменДанными.Отправитель = ЧтениеСообщения.Отправитель;
				Данные.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
				
				Если ТипЗнч(Данные) = Тип("СправочникОбъект.ИдентификаторыОбъектовМетаданных") Тогда
					ОбъектыИдентификаторов.Добавить(Данные);
					Продолжить;
				ИначеЕсли ТипЗнч(Данные) <> Тип("УдалениеОбъекта") Тогда
					Если ТипЗнч(Данные.Ссылка) = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
						// Ссылки идентификаторов удаляются независимо во всех узлах
						// через механизм пометки удаления и удаления помеченных объектов.
						Продолжить;
					КонецЕсли;
					Данные.ДополнительныеСвойства.Вставить("ЗагрузкаПараметровРаботыПрограммы");
					Данные.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
				КонецЕсли;
				
				Данные.Записать();
				
			КонецЦикла;
			
			ОбновитьУдалениеПредопределенных();
			
			Справочники.ИдентификаторыОбъектовМетаданных.ЗагрузитьДанныеВПодчиненныйУзел(ОбъектыИдентификаторов);
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
		ЧтениеСообщения.ЧтениеXML.Прочитать(); // </Parameters>
		
	Иначе
		
		// Пропускаем параметры работы программы
		ЧтениеСообщения.ЧтениеXML.Пропустить(); // <Parameters>...</Parameters>
		
		ЧтениеСообщения.ЧтениеXML.Прочитать(); // </Parameters>
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗафиксироватьЗавершениеОбмена(Отказ, ОписаниеОшибки = "", ОписаниеОшибкиКонтекста = "")
	
	Отказ = Истина;
	
	Комментарий = "[ОписаниеОшибкиКонтекста]: [ОписаниеОшибки]";
	
	Комментарий = СтрЗаменить(Комментарий, "[ОписаниеОшибкиКонтекста]", ОписаниеОшибкиКонтекста);
	Комментарий = СтрЗаменить(Комментарий, "[ОписаниеОшибки]", ОписаниеОшибки);
	
	ЗаписьЖурналаРегистрации(КлючСообщенияЖурналаРегистрации, УровеньЖурналаРегистрации.Ошибка,
		УзелИнформационнойБазы.Метаданные(), УзелИнформационнойБазы, Комментарий);
	
КонецПроцедуры

Функция ЭтоУзелРаспределеннойИнформационнойБазы()
	
	Возврат ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(УзелИнформационнойБазы);
	
КонецФункции

Процедура ОбновитьУдалениеПредопределенных()
	
	УстановитьПривилегированныйРежим(Истина);
	
	КоллекцииМетаданных = Новый Массив;
	КоллекцииМетаданных.Добавить(Метаданные.Справочники);
	КоллекцииМетаданных.Добавить(Метаданные.ПланыВидовХарактеристик);
	КоллекцииМетаданных.Добавить(Метаданные.ПланыСчетов);
	КоллекцииМетаданных.Добавить(Метаданные.ПланыВидовРасчета);
	
	Для каждого Коллекция Из КоллекцииМетаданных Цикл
		Для Каждого ОбъектМетаданных Из Коллекция Цикл
			ОбновитьУдалениеПредопределенного(ОбъектМетаданных.ПолноеИмя());
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьУдалениеПредопределенного(Таблица)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТекущаяТаблица.Ссылка,
	|	ТекущаяТаблица.ИмяПредопределенныхДанных
	|ИЗ
	|	&ТекущаяТаблица КАК ТекущаяТаблица
	|ГДЕ
	|	ТекущаяТаблица.Предопределенный = ИСТИНА";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекущаяТаблица", Таблица);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Лев(Выборка.ИмяПредопределенныхДанных, 1) = "#" Тогда
			
			ТекущийОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ТекущийОбъект.ИмяПредопределенныхДанных = "";
			ТекущийОбъект.ПометкаУдаления = Истина;
			
			ТекущийОбъект.ОбменДанными.Загрузка = Истина;
			ТекущийОбъект.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
			ТекущийОбъект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
			
			ТекущийОбъект.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные функции-свойства

Функция ИмяФайлаСообщенияОбмена()
	
	Если Не ЗначениеЗаполнено(ПолеИмяФайлаСообщенияОбмена) Тогда
		
		ПолеИмяФайлаСообщенияОбмена = "";
		
	КонецЕсли;
	
	Возврат ПолеИмяФайлаСообщенияОбмена;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Описания ошибок контекста выполнения

Функция ОшибкаОткрытияФайлаСообщенияОбмена()
	
	Возврат НСтр("ru = 'Ошибка открытия файла сообщения обмена'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

Функция ОшибкаНачалаЧтенияФайлаСообщенияОбмена()
	
	Возврат НСтр("ru = 'Ошибка при начале чтения файла сообщения обмена'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

Функция ОшибкаНачалаЗаписиФайлаСообщенияОбмена()
	
	Возврат НСтр("ru = 'Ошибка при начале записи файла сообщения обмена'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

Функция ОшибкаЧтенияФайлаСообщенияОбмена()
	
	Возврат НСтр("ru = 'Ошибка чтения файла сообщения обмена'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

Функция ОшибкаЗаписиФайлаСообщенияОбмена()
	
	Возврат НСтр("ru = 'Ошибка записи данных в файл сообщения обмена'");
	
КонецФункции

Функция ОшибкаВидаОбменаДанными()
	
	Возврат НСтр("ru = 'Обмен не по правилам конвертации не поддерживается'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти

#КонецЕсли
