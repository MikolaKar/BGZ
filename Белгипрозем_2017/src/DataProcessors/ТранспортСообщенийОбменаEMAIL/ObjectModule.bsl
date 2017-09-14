#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем СтрокаСообщенияОбОшибке Экспорт;
Перем СтрокаСообщенияОбОшибкеЖР Экспорт;

Перем СообщенияОшибок; // соответствие с предопределенными сообщениями ошибок обработки
Перем ИмяОбъекта;		// имя объекта метаданных

Перем ВременныйФайлСообщенияОбмена; // временный файл сообщения обмена для выгрузки/загрузки данных
Перем ВременныйКаталогСообщенийОбмена; // временный каталог для сообщений обмена

Перем ТемаСообщения;		// шаблон темы сообщения
Перем ТелоСообщенияПростое;	// текст тела сообщения с вложением - файлом XML
Перем ТелоСообщенияСжатое;		// текст тела сообщения с вложением - сжатым файлом
Перем ТелоСообщенияПакетное;	// текст тела сообщения с вложением - сжатый файл, в котором с набор файлов

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции

// Создает временный каталог в каталоге временных файлов пользователя операционной системы.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - удалось выполнить функцию, Ложь - произошла ошибка
// 
Функция ВыполнитьДействияПередОбработкойСообщения() Экспорт
	
	ИнициализацияСообщений();
	
	Возврат СоздатьВременныйКаталогСообщенийОбмена();
	
КонецФункции

// Выполняет отправку сообщения обмена на заданный ресурс из временного каталога сообщения обмена
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - удалось выполнить функцию, Ложь - произошла ошибка
// 
Функция ОтправитьСообщение() Экспорт
	
	ИнициализацияСообщений();
	
	Попытка
		Результат = ОтправитьСообщениеОбмена();
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Получает сообщение обмена с заданного ресурса во временный каталог сообщения обмена
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - удалось выполнить функцию, Ложь - произошла ошибка
// 
Функция ПолучитьСообщение() Экспорт
	
	ИнициализацияСообщений();
	
	Попытка
		Результат = ПолучитьСообщениеОбмена();
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Удаляет временный каталог сообщений обмена после выполнения выгрузки или загрузки данных
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина
//
Функция ВыполнитьДействияПослеОбработкиСообщения() Экспорт
	
	ИнициализацияСообщений();
	
	УдалитьВременныйКаталогСообщенийОбмена();
	
	Возврат Истина;
	
КонецФункции

// Выполняет проверку наличия сообщения обмена на заданном ресурсе
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - сообщение обмена присутствует на заданном ресурсе; Лож - нет
//
Функция ФайлСообщенияОбменаСуществует() Экспорт
	
	ИнициализацияСообщений();
	
	МассивКолонок = Новый Массив;
	МассивКолонок.Добавить("Тема");
	
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("Колонки", МассивКолонок);
	ПараметрыЗагрузки.Вставить("ПолучениеЗаголовков", Истина);
	
	Попытка
		НаборСообщений = РаботаСПочтовымиСообщениямиСлужебный.ЗагрузитьПочтовыеСообщения(EMAILУчетнаяЗапись, ПараметрыЗагрузки);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(103);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Для Каждого ПочтовоеСообщение Из НаборСообщений Цикл
		
		Если ВРег(СокрЛП(ПочтовоеСообщение.Тема)) = ВРег(СокрЛП(ТемаСообщения)) Тогда
			
			Возврат Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

// Выполняет инициализацию свойств обработки начальными значениями и константами
//
// Параметры:
//  Нет.
// 
Процедура Инициализация() Экспорт
	
	ИнициализацияСообщений();
	
	ТемаСообщения = "Exchange message (%1)"; // строка не подлежит локализации
	ТемаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТемаСообщения, ШаблонИмениФайлаСообщения);
	
	ТелоСообщенияПростое	= НСтр("ru = 'Сообщение обмена данными'");
	ТелоСообщенияСжатое	= НСтр("ru = 'Сжатое сообщение обмена данными'");
	ТелоСообщенияПакетное	= НСтр("ru = 'Пакетное сообщение обмена данными'");
	
КонецПроцедуры

// Выполняет проверку возможности установки подключения к заданному ресурсу
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Булево - Истина - подключение может быть установлено; Ложь - нет
//
Функция ПодключениеУстановлено() Экспорт
	
	ИнициализацияСообщений();
	
	Если НЕ ЗначениеЗаполнено(EMAILУчетнаяЗапись) Тогда
		ПолучитьСообщениеОбОшибке(101);
		Возврат Ложь;
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	ДополнительноеСообщение = "";
	РаботаСПочтовымиСообщениямиСлужебный.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(EMAILУчетнаяЗапись, Неопределено, СообщениеОбОшибке, ДополнительноеСообщение);
	
	Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
		ПолучитьСообщениеОбОшибке(107);
		ДополнитьСообщениеОбОшибке(СообщениеОбОшибке);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Функции-свойства

// Время изменения файла сообщения обмена
//
// Возвращаемое значение:
//  Строка - время изменения файла сообщения обмена
//
Функция ДатаФайлаСообщенияОбмена() Экспорт
	
	Результат = Неопределено;
	
	Если ТипЗнч(ВременныйФайлСообщенияОбмена) = Тип("Файл") Тогда
		
		Если ВременныйФайлСообщенияОбмена.Существует() Тогда
			
			Результат = ВременныйФайлСообщенияОбмена.ПолучитьВремяИзменения();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Полное имя файла сообщения обмена
//
// Возвращаемое значение:
//  Строка - полное имя файла сообщения обмена
//
Функция ИмяФайлаСообщенияОбмена() Экспорт
	
	Имя = "";
	
	Если ТипЗнч(ВременныйФайлСообщенияОбмена) = Тип("Файл") Тогда
		
		Имя = ВременныйФайлСообщенияОбмена.ПолноеИмя;
		
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

// Полное имя каталога сообщения обмена
//
// Возвращаемое значение:
//  Строка - полное имя каталога сообщения обмена.
//
Функция ИмяКаталогаСообщенияОбмена() Экспорт
	
	Имя = "";
	
	Если ТипЗнч(ВременныйКаталогСообщенийОбмена) = Тип("Файл") Тогда
		
		Имя = ВременныйКаталогСообщенийОбмена.ПолноеИмя;
		
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции

Функция СоздатьВременныйКаталогСообщенийОбмена()
	
	// создаем временный каталог для сообщений обмена
	Попытка
		ИмяВременногоКаталога = ОбменДаннымиСервер.СоздатьВременныйКаталогСообщенийОбмена();
	Исключение
		ПолучитьСообщениеОбОшибке(4);
		ДополнитьСообщениеОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Ложь;
	КонецПопытки;
	
	ВременныйКаталогСообщенийОбмена = Новый Файл(ИмяВременногоКаталога);
	
	ИмяФайлаСообщения = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".xml");
	
	ВременныйФайлСообщенияОбмена = Новый Файл(ИмяФайлаСообщения);
	
	Возврат Истина;
КонецФункции

Функция УдалитьВременныйКаталогСообщенийОбмена()
	
	Попытка
		Если Не ПустаяСтрока(ИмяКаталогаСообщенияОбмена()) Тогда
			УдалитьФайлы(ИмяКаталогаСообщенияОбмена());
			ВременныйКаталогСообщенийОбмена = Неопределено;
		КонецЕсли;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ОтправитьСообщениеОбмена()
	
	Результат = Истина;
	
	Расширение = ?(СжиматьФайлИсходящегоСообщения(), ".zip", ".xml");
	
	ИмяФайлаИсходящегоСообщения = ШаблонИмениФайлаСообщения + Расширение;
	
	Если СжиматьФайлИсходящегоСообщения() Тогда
		
		// получаем имя для временного файла архива
		ИмяВременногоФайлаАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".zip");
		
		Попытка
			
			Архиватор = Новый ЗаписьZipФайла(ИмяВременногоФайлаАрхива, ПарольАрхиваСообщенияОбмена, НСтр("ru = 'Файл сообщения обмена'"));
			Архиватор.Добавить(ИмяФайлаСообщенияОбмена());
			Архиватор.Записать();
			
		Исключение
			
			Результат = Ложь;
			ПолучитьСообщениеОбОшибке(3);
			ДополнитьСообщениеОбОшибке(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		КонецПопытки;
		
		Архиватор = Неопределено;
		
		Если Результат Тогда
			
			// выполняем проверку на максимально допустимый размер сообщения обмена
			Если ОбменДаннымиСервер.РазмерСообщенияОбменаПревышаетДопустимый(ИмяВременногоФайлаАрхива, МаксимальныйДопустимыйРазмерСообщения()) Тогда
				ПолучитьСообщениеОбОшибке(108);
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Результат Тогда
			
			Результат = ОтправитьСообщениеПоЭлектроннойПочте(
									ТелоСообщенияСжатое,
									ИмяФайлаИсходящегоСообщения,
									ИмяВременногоФайлаАрхива);
			
		КонецЕсли;
		
	Иначе
		
		Если Результат Тогда
			
			// выполняем проверку на максимально допустимый размер сообщения обмена
			Если ОбменДаннымиСервер.РазмерСообщенияОбменаПревышаетДопустимый(ИмяФайлаСообщенияОбмена(), МаксимальныйДопустимыйРазмерСообщения()) Тогда
				ПолучитьСообщениеОбОшибке(108);
				Результат = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Результат Тогда
			
			Результат = ОтправитьСообщениеПоЭлектроннойПочте(
									ТелоСообщенияПростое,
									ИмяФайлаИсходящегоСообщения,
									ИмяФайлаСообщенияОбмена());
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСообщениеОбмена()
	
	ТаблицаСообщенийОбмена = Новый ТаблицаЗначений;
	ТаблицаСообщенийОбмена.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Массив"));
	ТаблицаСообщенийОбмена.Колонки.Добавить("ДатаОтправления", Новый ОписаниеТипов("Дата"));
	
	МассивКолонок = Новый Массив;
	
	МассивКолонок.Добавить("Идентификатор");
	МассивКолонок.Добавить("ДатаОтправления");
	МассивКолонок.Добавить("Тема");
	
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("Колонки", МассивКолонок);
	ПараметрыЗагрузки.Вставить("ПолучениеЗаголовков", Истина);
	
	Попытка
		НаборСообщений = РаботаСПочтовымиСообщениямиСлужебный.ЗагрузитьПочтовыеСообщения(EMAILУчетнаяЗапись, ПараметрыЗагрузки);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(103);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Для Каждого ПочтовоеСообщение Из НаборСообщений Цикл
		
		Если ВРег(СокрЛП(ПочтовоеСообщение.Тема)) <> ВРег(СокрЛП(ТемаСообщения)) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаСообщенийОбмена.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПочтовоеСообщение);
		
	КонецЦикла;
	
	Если ТаблицаСообщенийОбмена.Количество() = 0 Тогда
		
		ПолучитьСообщениеОбОшибке(104);
		
		СтрокаСообщения = НСтр("ru = 'Не обнаружены письма с заголовком: ""%1""'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ТемаСообщения);
		ДополнитьСообщениеОбОшибке(СтрокаСообщения);
		
		Возврат Ложь;
		
	Иначе
		
		ТаблицаСообщенийОбмена.Сортировать("ДатаОтправления Убыв");
		
		МассивКолонок = Новый Массив;
		МассивКолонок.Добавить("Вложения");
		
		ПараметрыЗагрузки = Новый Структура;
		ПараметрыЗагрузки.Вставить("Колонки", МассивКолонок);
		ПараметрыЗагрузки.Вставить("ЗаголовкиИдентификаторы", ТаблицаСообщенийОбмена[0].Идентификатор);
		
		Попытка
			НаборСообщений = РаботаСПочтовымиСообщениямиСлужебный.ЗагрузитьПочтовыеСообщения(EMAILУчетнаяЗапись, ПараметрыЗагрузки);
		Исключение
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ПолучитьСообщениеОбОшибке(105);
			ДополнитьСообщениеОбОшибке(ТекстОшибки);
			Возврат Ложь;
		КонецПопытки;
		
		ДвоичныеДанные = НаборСообщений[0].Вложения.Получить(ШаблонИмениФайлаСообщения+".zip");
		
		Если ДвоичныеДанные <> Неопределено Тогда
			ФайлЗапакован = Истина;
		Иначе
			ДвоичныеДанные = НаборСообщений[0].Вложения.Получить(ШаблонИмениФайлаСообщения+".xml");
			ФайлЗапакован = Ложь;
		КонецЕсли;
			
		Если ДвоичныеДанные = Неопределено Тогда
			ПолучитьСообщениеОбОшибке(109);
			Возврат Ложь;
		КонецЕсли;
		
		Если ФайлЗапакован Тогда
			
			// получаем имя для временного файла архива
			ИмяВременногоФайлаАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена(), ШаблонИмениФайлаСообщения + ".zip");
			
			Попытка
				ДвоичныеДанные.Записать(ИмяВременногоФайлаАрхива);
			Исключение
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ПолучитьСообщениеОбОшибке(106);
				ДополнитьСообщениеОбОшибке(ТекстОшибки);
				Возврат Ложь;
			КонецПопытки;
			
			// распаковываем временный файл архива
			УспешноРаспакованно = ОбменДаннымиСервер.РаспаковатьZipФайл(ИмяВременногоФайлаАрхива, ИмяКаталогаСообщенияОбмена(), ПарольАрхиваСообщенияОбмена);
			
			Если Не УспешноРаспакованно Тогда
				ПолучитьСообщениеОбОшибке(2);
				Возврат Ложь;
			КонецЕсли;
			
			// проверка на существование файла сообщения
			Файл = Новый Файл(ИмяФайлаСообщенияОбмена());
			
			Если Не Файл.Существует() Тогда
				
				ПолучитьСообщениеОбОшибке(5);
				Возврат Ложь;
				
			КонецЕсли;
			
		Иначе
			
			Попытка
				ДвоичныеДанные.Записать(ИмяФайлаСообщенияОбмена());
			Исключение
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ПолучитьСообщениеОбОшибке(106);
				ДополнитьСообщениеОбОшибке(ТекстОшибки);
				Возврат Ложь;
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПолучитьСообщениеОбОшибке(НомерСообщения)
	
	УстановитьСтрокуСообщенияОбОшибке(СообщенияОшибок[НомерСообщения]);
	
КонецПроцедуры

Процедура УстановитьСтрокуСообщенияОбОшибке(Знач Сообщение)
	
	Если Сообщение = Неопределено Тогда
		Сообщение = НСтр("ru = 'Внутренняя ошибка'");
	КонецЕсли;
	
	СтрокаСообщенияОбОшибке   = Сообщение;
	СтрокаСообщенияОбОшибкеЖР = ИмяОбъекта + ": " + Сообщение;
	
КонецПроцедуры

Процедура ДополнитьСообщениеОбОшибке(Сообщение)
	
	СтрокаСообщенияОбОшибкеЖР = СтрокаСообщенияОбОшибкеЖР + Символы.ПС + Сообщение;
	
КонецПроцедуры

// Переопределяемая функция, возвращает максимально допустимый размер
// сообщения, которое может быть отправлено.
// 
Функция МаксимальныйДопустимыйРазмерСообщения()
	
	Возврат EMAILМаксимальныйДопустимыйРазмерСообщения;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Функции-свойства

// Флаг сжатия файла исходящего сообщения
// 
Функция СжиматьФайлИсходящегоСообщения()
	
	Возврат EMAILСжиматьФайлИсходящегоСообщения;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Инициализация

Процедура ИнициализацияСообщений()
	
	СтрокаСообщенияОбОшибке   = "";
	СтрокаСообщенияОбОшибкеЖР = "";
	
КонецПроцедуры

Процедура ИнициализацияСообщенийОшибок()
	
	СообщенияОшибок = Новый Соответствие;
	
	// Общие коды ошибок
	СообщенияОшибок.Вставить(001, НСтр("ru = 'Не обнаружены сообщения обмена.'"));
	СообщенияОшибок.Вставить(002, НСтр("ru = 'Ошибка при распаковке сжатого файла сообщения.'"));
	СообщенияОшибок.Вставить(003, НСтр("ru = 'Ошибка при сжатии файла сообщения обмена.'"));
	СообщенияОшибок.Вставить(004, НСтр("ru = 'Ошибка при создании временного каталога'."));
	СообщенияОшибок.Вставить(005, НСтр("ru = 'Архив не содержит файл сообщения обмена.'"));
	СообщенияОшибок.Вставить(006, НСтр("ru = 'Сообщение обмена не отправлено: превышен допустимый размер сообщения.'"));
	
	// Коды ошибок, зависящие от вида транспорта
	СообщенияОшибок.Вставить(101, НСтр("ru = 'Ошибка инициализации: не указана учетная запись электронной почты транспорта сообщений обмена.'"));
	СообщенияОшибок.Вставить(102, НСтр("ru = 'Ошибка при отправке сообщения электронной почты.'"));
	СообщенияОшибок.Вставить(103, НСтр("ru = 'Ошибка при получении заголовков сообщений с сервера электронной почты.'"));
	СообщенияОшибок.Вставить(104, НСтр("ru = 'Не обнаружены сообщения обмена на почтовом сервере.'"));
	СообщенияОшибок.Вставить(105, НСтр("ru = 'Ошибка при получении сообщения с сервера электронной почты.'"));
	СообщенияОшибок.Вставить(106, НСтр("ru = 'Ошибка при записи файла сообщения обмена на диск.'"));
	СообщенияОшибок.Вставить(107, НСтр("ru = 'Проверка параметров учетной записи завершилась с ошибками.'"));
	СообщенияОшибок.Вставить(108, НСтр("ru = 'Превышен допустимый размер сообщения обмена.'"));
	СообщенияОшибок.Вставить(109, НСтр("ru = 'Ошибка: в почтовом сообщении не найден файл с сообщением.'"));
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Работа с E-MAIL

Функция ОтправитьСообщениеПоЭлектроннойПочте(Тело, ИмяФайлаИсходящегоСообщения, ПутьКФайлу)
	
	Вложения = Новый Соответствие;
	Вложения.Вставить(ИмяФайлаИсходящегоСообщения,
						Новый ДвоичныеДанные(ПутьКФайлу));
	
	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("Кому", EMAILУчетнаяЗапись.АдресЭлектроннойПочты);
	ПараметрыСообщения.Вставить("Тема", ТемаСообщения);
	ПараметрыСообщения.Вставить("Тело", Тело);
	ПараметрыСообщения.Вставить("Вложения", Вложения);
	
	Попытка
		РаботаСПочтовымиСообщениями.ОтправитьСообщение(EMAILУчетнаяЗапись, ПараметрыСообщения);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ПолучитьСообщениеОбОшибке(102);
		ДополнитьСообщениеОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Операторы основной программы

ИнициализацияСообщений();
ИнициализацияСообщенийОшибок();

ВременныйКаталогСообщенийОбмена = Неопределено;
ВременныйФайлСообщенияОбмена    = Неопределено;

ИмяОбъекта = НСтр("ru = 'Обработка: %1'");
ИмяОбъекта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ИмяОбъекта, Метаданные().Имя);

#КонецОбласти

#КонецЕсли