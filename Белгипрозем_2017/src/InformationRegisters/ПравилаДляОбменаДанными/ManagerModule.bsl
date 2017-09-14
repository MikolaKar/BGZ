#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Загружает правила в регистр
//
// Параметры:
//	Отказ - Булево - Отказ от записи в регистр
//	Запись - РегистрСведенийЗапись.ПравилаДляОбменаДанными - запись регистра, в которую будут помещены данные
//	АдресВременногоХранилища - Строка - Адрес временного хранилища, из которого будут загружены XML-правила 
//	ИмяФайлаПравил - Строка - Имя файла из которого были загружены файлы(оно также фиксируется в регистре)	
//	ДвоичныеДанные - ДвоичныеДанные - данные, в которые сохраняется XML-файл (в том числе и распакованный из ZIP-архива)
//	ЭтоАрхив - Булево - Признак того, что правила загружаются из ZIP-архива, а не из XML-файла
//
Процедура ЗагрузитьПравила(Отказ, Запись, АдресВременногоХранилища = "", ИмяФайлаПравил = "", ЭтоАрхив = Ложь) Экспорт
	
	// проверка заполнения обязательныех полей записи
	ВыполнитьПроверкуЗаполненияПолей(Отказ, Запись);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоПравилаКонвертации = (Запись.ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов);
	
	// Получаем двоичные данные правил из файла или макета конфигурации
	Если Запись.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.МакетКонфигурации Тогда
		
		ДвоичныеДанные = ПолучитьДвоичныеДанныеИзМакетаКонфигурации(Отказ, Запись.ИмяПланаОбмена, Запись.ИмяМакетаПравил);
		
		Если ЭтоПравилаКонвертации Тогда
			ДвоичныеДанныеКорреспондента = ПолучитьДвоичныеДанныеИзМакетаКонфигурации(Отказ, Запись.ИмяПланаОбмена, Запись.ИмяМакетаПравилКорреспондента);
		КонецЕсли;
		
	Иначе
		
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
		
	КонецЕсли;
	
	// Если это архив, тогда разархивируем его и заново заложим в двоичные данные для дальнейшей работы.
	Если ЭтоАрхив Тогда
		
		// Получаем файл архива из двоичных данных
		ИмяВременногоАрхива = ПолучитьИмяВременногоФайла("zip");
		ДвоичныеДанные.Записать(ИмяВременногоАрхива);
		
		// Распаковываем архив
		ИмяВременнойПапки = ПолучитьИмяВременногоФайла("");
		Если ОбменДаннымиСервер.РаспаковатьZipФайл(ИмяВременногоАрхива, ИмяВременнойПапки) Тогда
			
			СписокРаспакованныхФайлов = НайтиФайлы(ИмяВременнойПапки, "*.*", Истина);
			
			// В архиве не было ни одного файла - отказываемся от загрузки
			Если СписокРаспакованныхФайлов.Количество() = 0 Тогда
				НСтрока = НСтр("ru = 'При распаковке архива не найден файл с правилами.'");
				ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
			КонецЕсли;
			
			Если ЭтоПравилаКонвертации Тогда
				
				// Закладываем полученный файл правил обратно в двоичные данные
				Если СписокРаспакованныхФайлов.Количество() = 2 Тогда
					
					Если СписокРаспакованныхФайлов[0].Имя = "ExchangeRules.xml" 
						И СписокРаспакованныхФайлов[1].Имя ="CorrespondentExchangeRules.xml" Тогда
						
						ДвоичныеДанные = Новый ДвоичныеДанные(СписокРаспакованныхФайлов[0].ПолноеИмя);
						ДвоичныеДанныеКорреспондента = Новый ДвоичныеДанные(СписокРаспакованныхФайлов[1].ПолноеИмя);
						
					ИначеЕсли СписокРаспакованныхФайлов[1].Имя = "ExchangeRules.xml" 
						И СписокРаспакованныхФайлов[0].Имя ="CorrespondentExchangeRules.xml" Тогда
						
						ДвоичныеДанные = Новый ДвоичныеДанные(СписокРаспакованныхФайлов[1].ПолноеИмя);
						ДвоичныеДанныеКорреспондента = Новый ДвоичныеДанные(СписокРаспакованныхФайлов[0].ПолноеИмя);
						
					Иначе
						
						НСтрока = НСтр("ru = 'Имена файлов в архиве не соответствуют ожидаемым. Ожидаются файлы:
							|ExchangeRules.xml - правила конвертации для текущей программы;
							|CorrespondentExchangeRules.xml - правила конвертации для программы-корреспондента.'");
						ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
						
					КонецЕсли;
					
				// Старый формат
				ИначеЕсли СписокРаспакованныхФайлов.Количество() = 1 Тогда
					НСтрока = НСтр("ru = 'В архиве найден один файл правил конвертации. Ожидаемое количество файлов в архиве - два. Ожидаются файлы:
						|ExchangeRules.xml - правила конвертации для текущей программы;
						|CorrespondentExchangeRules.xml - правила конвертации для программы-корреспондента.'");
					ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
				// В архиве оказалось несколько файлов, хотя должен быть один - отказываеся от загрузки
				ИначеЕсли СписокРаспакованныхФайлов.Количество() > 1 Тогда
					НСтрока = НСтр("ru = 'При распаковке архива найдено несколько файлов. Ожидаемое количество файлов в архиве - два. Ожидаются файлы:
						|ExchangeRules.xml - правила конвертации для текущей программы;
						|CorrespondentExchangeRules.xml - правила конвертации для программы-корреспондента.'");
					ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
				КонецЕсли;
				
			Иначе
				
				// Закладываем полученный файл правил обратно в двоичные данные
				Если СписокРаспакованныхФайлов.Количество() = 1 Тогда
					ДвоичныеДанные = Новый ДвоичныеДанные(СписокРаспакованныхФайлов[0].ПолноеИмя);
					
				// В архиве оказалось несколько файлов, хотя должен быть один - отказываеся от загрузки
				ИначеЕсли СписокРаспакованныхФайлов.Количество() > 1 Тогда
					НСтрока = НСтр("ru = 'При распаковке архива найдено несколько файлов. Должен быть только один файл с правилами.'");
					ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе // Если не удалось распаковать файл - отказываемся от загрузки
			НСтрока = НСтр("ru = 'Не удалось распаковать архив с правилами.'");
			ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
		КонецЕсли;
		
		// Удаляем временный архив и временную папку, в которую был распакован архив
		УдалитьВременныйФайл(ИмяВременнойПапки);
		УдалитьВременныйФайл(ИмяВременногоАрхива);
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// получаем имя временного файла в локальной ФС на сервере
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	
	// получаем файл правил для зачитки
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	Если ЭтоПравилаКонвертации Тогда
		
		// зачитываем правила конвертации
		КонвертацияОбъектовИнформационныхБаз = Обработки.КонвертацияОбъектовИнформационныхБаз.Создать();
		
		// свойства обработки
		КонвертацияОбъектовИнформационныхБаз.РежимОбмена = "Выгрузка";
		КонвертацияОбъектовИнформационныхБаз.ИмяПланаОбменаВРО = Запись.ИмяПланаОбмена;
		КонвертацияОбъектовИнформационныхБаз.КлючСообщенияЖурналаРегистрации = ОбменДаннымиСервер.СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными();
		
		ОбменДаннымиСервер.УстановитьНастройкиОтладкиВыгрузкиДляПравилОбмена(КонвертацияОбъектовИнформационныхБаз, Запись.ИмяПланаОбмена, Запись.РежимОтладки);
		
		// методы обработки
		ПравилаЗачитанные = КонвертацияОбъектовИнформационныхБаз.ПолучитьСтруктуруПравилОбмена(ИмяВременногоФайла);
		
		РежимСовместимости = Ложь;
		ИнформацияОПравилах = КонвертацияОбъектовИнформационныхБаз.ПолучитьИнформациюОПравилах(Ложь, РежимСовместимости);
		
		Если КонвертацияОбъектовИнформационныхБаз.ФлагОшибки() Тогда
			Отказ = Истина;
		КонецЕсли;
		
		// получаем имя временного файла в локальной ФС на сервере
		ИмяВременногоФайлаКорреспондента = ПолучитьИмяВременногоФайла("xml");
		// получаем файл правил для зачитки
		ДвоичныеДанныеКорреспондента.Записать(ИмяВременногоФайлаКорреспондента);
		
		// зачитываем правила конвертации
		КонвертацияОбъектовИнформационныхБаз = Обработки.КонвертацияОбъектовИнформационныхБаз.Создать();
		
		// свойства обработки
		КонвертацияОбъектовИнформационныхБаз.РежимОбмена = "Загрузка";
		КонвертацияОбъектовИнформационныхБаз.ИмяПланаОбменаВРО = Запись.ИмяПланаОбмена;
		КонвертацияОбъектовИнформационныхБаз.КлючСообщенияЖурналаРегистрации = ОбменДаннымиСервер.СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными();
		
		// методы обработки
		ПравилаЗачитанныеКорреспондента = КонвертацияОбъектовИнформационныхБаз.ПолучитьСтруктуруПравилОбмена(ИмяВременногоФайлаКорреспондента);
		
		РежимСовместимостиКорреспондента = Ложь;
		ИнформацияОПравилахКорреспондента = КонвертацияОбъектовИнформационныхБаз.ПолучитьИнформациюОПравилах(
			Истина, РежимСовместимостиКорреспондента);
		
		Если КонвертацияОбъектовИнформационныхБаз.ФлагОшибки() Тогда
			Отказ = Истина;
		КонецЕсли;
		
 		ИнформацияОПравилах = ИнформацияОПравилах + Символы.ПС + Символы.ПС + ИнформацияОПравилахКорреспондента;
		
	Иначе // ПравилаРегистрацииОбъектов
		
		// зачитываем правила регистрации
		ЗагрузкаПравилРегистрации = Обработки.ЗагрузкаПравилРегистрацииОбъектов.Создать();
		
		// свойства обработки
		ЗагрузкаПравилРегистрации.ИмяПланаОбменаДляЗагрузки = Запись.ИмяПланаОбмена;
		
		// методы обработки
		ЗагрузкаПравилРегистрации.ЗагрузитьПравила(ИмяВременногоФайла);
		
		ПравилаЗачитанные = ЗагрузкаПравилРегистрации.ПравилаРегистрацииОбъектов;
		
		ИнформацияОПравилах = ЗагрузкаПравилРегистрации.ПолучитьИнформациюОПравилах();
		
		Если ЗагрузкаПравилРегистрации.ФлагОшибки Тогда
			Отказ = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	// удаляем временный файл правил
	УдалитьВременныйФайл(ИмяВременногоФайла);
	
	Если Не Отказ Тогда
		
		Запись.ПравилаXML          = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных());
		Запись.ПравилаЗачитанные   = Новый ХранилищеЗначения(ПравилаЗачитанные);
		
		Если ЭтоПравилаКонвертации Тогда
			
			Запись.ПравилаXMLКорреспондента = Новый ХранилищеЗначения(ДвоичныеДанныеКорреспондента, Новый СжатиеДанных());
			Запись.ПравилаЗачитанныеКорреспондента = Новый ХранилищеЗначения(ПравилаЗачитанныеКорреспондента);
			Если РежимСовместимости <> РежимСовместимостиКорреспондента Тогда
				ВызватьИсключение Нстр("ru = 'Резличаются режимы совместимости правил обмена текущей конфигурации и конфигурации-корреспондента.'");
			Иначе
				Запись.РежимСовместимости = РежимСовместимости;
			КонецЕсли;
			
		КонецЕсли;
		
		Запись.ИнформацияОПравилах = ИнформацияОПравилах;
		Запись.ИмяФайлаПравил = ИмяФайлаПравил;
		Запись.ПравилаЗагружены = Истина;
		Запись.ИмяПланаОбменаИзПравил = Запись.ИмяПланаОбмена;
		
	КонецЕсли;
	
КонецПроцедуры

// Получает зачитанные правила конвертации объектов из ИБ для плана обмена
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена как объекта метаданных
// 
// Возвращаемое значение:
//  ПравилаЗачитанные - ХранилищеЗначения - зачитанные правила конвертации объектов
//  Неопределено - Если правила конвертации не были загружены в базу для плана обмена
//
Функция ПолучитьЗачитанныеПравилаКонвертацииОбъектов(Знач ИмяПланаОбмена, ПолучатьПравилаКорреспондента = Ложь) Экспорт
	
	// возвращаемое значение функции
	ПравилаЗачитанные = Неопределено;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ПравилаДляОбменаДанными.%1 КАК ПравилаЗачитанные
	|ИЗ
	|	РегистрСведений.ПравилаДляОбменаДанными КАК ПравилаДляОбменаДанными
	|ГДЕ
	|	  ПравилаДляОбменаДанными.ИмяПланаОбмена = &ИмяПланаОбмена
	|	И ПравилаДляОбменаДанными.ВидПравил      = ЗНАЧЕНИЕ(Перечисление.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов)
	|	И ПравилаДляОбменаДанными.ПравилаЗагружены
	|";
	
	ТекстЗапроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗапроса,
		?(ПолучатьПравилаКорреспондента, "ПравилаЗачитанныеКорреспондента", "ПравилаЗачитанные"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ИмяПланаОбмена", ИмяПланаОбмена);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		ПравилаЗачитанные = Выборка.ПравилаЗачитанные;
		
	КонецЕсли;
	
	Возврат ПравилаЗачитанные;
	
КонецФункции

Процедура ЗагрузитьИнформациюОПравилах(Отказ, АдресВременногоХранилища, СтрокаИнформацииОПравилах) Экспорт
	
	Перем ВидПравил;
	
	СтрокаИнформацииОПравилах = "";
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	// получаем имя временного файла в локальной ФС на сервере
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	
	// получаем файл правил для зачитки
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	ОпределитьВидПравилДляОбменаДанными(ВидПравил, ИмяВременногоФайла, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов Тогда
		
		// зачитываем правила конвертации
		КонвертацияОбъектовИнформационныхБаз = Обработки.КонвертацияОбъектовИнформационныхБаз.Создать();
		
		КонвертацияОбъектовИнформационныхБаз.ЗагрузитьПравилаОбмена(ИмяВременногоФайла, "XMLФайл",, Истина);
		
		Если КонвертацияОбъектовИнформационныхБаз.ФлагОшибки() Тогда
			Отказ = Истина;
		КонецЕсли;
		
		Если Не Отказ Тогда
			СтрокаИнформацииОПравилах = КонвертацияОбъектовИнформационныхБаз.ПолучитьИнформациюОПравилах();
		КонецЕсли;
		
	Иначе // ПравилаРегистрацииОбъектов
		
		// зачитываем правила регистрации
		ЗагрузкаПравилРегистрации = Обработки.ЗагрузкаПравилРегистрацииОбъектов.Создать();
		
		ЗагрузкаПравилРегистрации.ЗагрузитьПравила(ИмяВременногоФайла, Истина);
		
		Если ЗагрузкаПравилРегистрации.ФлагОшибки Тогда
			Отказ = Истина;
		КонецЕсли;
		
		Если Не Отказ Тогда
			СтрокаИнформацииОПравилах = ЗагрузкаПравилРегистрации.ПолучитьИнформациюОПравилах();
		КонецЕсли;
		
	КонецЕсли;
	
	// удаляем временный файл правил
	УдалитьВременныйФайл(ИмяВременногоФайла);
	
КонецПроцедуры

Функция ПолучитьДвоичныеДанныеИзМакетаКонфигурации(Отказ, ИмяПланаОбмена, ИмяМакета)
	
	// получаем имя временного файла в локальной ФС на сервере
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	
	ПланОбменаМенеджер = ОбменДаннымиПовтИсп.ПолучитьМенеджерПланаОбменаПоИмени(ИмяПланаОбмена);
	
	// получаем макет типовых правил
	Попытка
		МакетПравил = ПланОбменаМенеджер.ПолучитьМакет(ИмяМакета);
	Исключение
		
		СтрокаСообщения = НСтр("ru = 'Ошибка получения макета конфигурации %1 для плана обмена %2'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ИмяМакета, ИмяПланаОбмена);
		ОбменДаннымиСервер.СообщитьОбОшибке(СтрокаСообщения, Отказ);
		Возврат Неопределено;
		
	КонецПопытки;
	
	МакетПравил.Записать(ИмяВременногоФайла);
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
	
	// удаляем временный файл правил
	УдалитьВременныйФайл(ИмяВременногоФайла);
	
	Возврат ДвоичныеДанные;
КонецФункции

Процедура УдалитьВременныйФайл(ИмяВременногоФайла)
	
	Попытка
		Если Не ПустаяСтрока(ИмяВременногоФайла) Тогда
			УдалитьФайлы(ИмяВременногоФайла);
		КонецЕсли;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура ВыполнитьПроверкуЗаполненияПолей(Отказ, Запись)
	
	Если ПустаяСтрока(Запись.ИмяПланаОбмена) Тогда
		
		НСтрока = НСтр("ru = 'Укажите план обмена.'");
		
		ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
		
	ИначеЕсли Запись.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.МакетКонфигурации
		    И ПустаяСтрока(Запись.ИмяМакетаПравил) Тогда
		
		НСтрока = НСтр("ru = 'Укажите типовые правила.'");
		
		ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределитьВидПравилДляОбменаДанными(ВидПравил, ИмяФайла, Отказ)
	
	// открываем файл для чтения
	Попытка
		Правила = Новый ЧтениеXML();
		Правила.ОткрытьФайл(ИмяФайла);
		Правила.Прочитать();
	Исключение
		Правила = Неопределено;
		
		НСтрока = НСтр("ru = 'Не удалось определить вид правил из-за ошибки в разбора XML-файла [ИмяФайла]. 
		|Возможно выбран не тот файл, либо XML-файл имеет некорректную структуру. Выберите корректный файл.'");
		НСтрока = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(НСтрока, Новый Структура("ИмяФайла", ИмяФайла));
		ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
		Возврат;
	КонецПопытки;
	
	Если Правила.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
		
		Если Правила.ЛокальноеИмя = "ПравилаОбмена" Тогда
			
			ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов;
			
		ИначеЕсли Правила.ЛокальноеИмя = "ПравилаРегистрации" Тогда
			
			ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаРегистрацииОбъектов;
			
		Иначе
			
			НСтрока = НСтр("ru = 'Не удалось определить вид правил из-за ошибки в формате правил XML-файла [ИмяФайла].
			|Возможно выбран не тот файл, либо XML-файл имеет некорректную структуру. Выберите корректный файл.'");
			НСтрока = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(НСтрока, Новый Структура("ИмяФайла", ИмяФайла));
			ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
			
		КонецЕсли;
		
	Иначе
		
		НСтрока = НСтр("ru = 'Не удалось определить вид правил из-за ошибки в формате правил XML-файла [ИмяФайла].
		|Возможно выбран не тот файл, либо XML-файл имеет некорректную структуру. Выберите корректный файл.'");
		НСтрока = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(НСтрока, Новый Структура("ИмяФайла", ИмяФайла));
		ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока, Отказ);
		
	КонецЕсли;
	
	Правила.Закрыть();
	Правила = Неопределено;
	
КонецПроцедуры

// Процедура добавляет запись в регистр по переданным значениям структуры
Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "ПравилаДляОбменаДанными");
	
КонецПроцедуры

Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	ЗагруженныеПравила = ЗагруженныеПравила();
	
	Пока ЗагруженныеПравила.Следующий() Цикл
		
		ЗапросНаИспользованиеВнешнихРесурсов(ЗапросыРазрешений, ЗагруженныеПравила);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЗагруженныеПравила()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПравилаДляОбменаДанными.ИмяПланаОбмена,
	|	ПравилаДляОбменаДанными.ИсточникПравил,
	|	ПравилаДляОбменаДанными.ВидПравил,
	|	ПравилаДляОбменаДанными.РежимСовместимости,
	|	ПравилаДляОбменаДанными.РежимОтладки,
	|	ПравилаДляОбменаДанными.РежимОтладкиВыгрузки,
	|	ПравилаДляОбменаДанными.ИмяФайлаОбработкиДляОтладкиВыгрузки,
	|	ПравилаДляОбменаДанными.РежимОтладкиЗагрузки,
	|	ПравилаДляОбменаДанными.ИмяФайлаОбработкиДляОтладкиЗагрузки,
	|	ПравилаДляОбменаДанными.РежимПротоколированияОбменаДанными,
	|	ПравилаДляОбменаДанными.ИмяФайлаПротоколаОбмена
	|ИЗ
	|	РегистрСведений.ПравилаДляОбменаДанными КАК ПравилаДляОбменаДанными
	|ГДЕ
	|	ПравилаДляОбменаДанными.ПравилаЗагружены = ИСТИНА";
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса.Выбрать();
	
КонецФункции

Функция ЗапросНаИспользованиеВнешнихРесурсов(ЗапросыРазрешений, Запись) Экспорт
	
	Разрешения = Новый Массив;
	
	Если Запись.ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов Тогда
		
		Если (Не Запись.РежимСовместимости Или ОбщегоНазначенияПовтИсп.РазделениеВключено()) И Не Запись.РежимОтладки Тогда
			// Запрос на персональный профиль не требуется
		Иначе
			
			Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеПривилегированногоРежима());
			
			Если Запись.РежимОтладки Тогда
				
				Если Запись.РежимОтладкиВыгрузки Тогда
					
					СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Запись.ИмяФайлаОбработкиДляОтладкиВыгрузки);
					Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(
						СтруктураИмениФайла.Путь, Истина, Ложь));
					
				КонецЕсли;
				
				Если Запись.РежимОтладкиЗагрузки Тогда
					
					СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Запись.ИмяФайлаОбработкиДляОтладкиВыгрузки);
					Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(
						СтруктураИмениФайла.Путь, Истина, Ложь));
					
				КонецЕсли;
				
				Если Запись.РежимПротоколированияОбменаДанными Тогда
					
					СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Запись.ИмяФайлаОбработкиДляОтладкиВыгрузки);
					Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(
						СтруктураИмениФайла.Путь, Истина, Истина));
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе // Правила регистрации
		
		Если Запись.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.Файл Тогда
			Разрешения.Добавить(РаботаВБезопасномРежиме.РазрешениеНаИспользованиеПривилегированногоРежима());
		Иначе
			// Правила будут выполняться под профилем конфигурации
		КонецЕсли;
		
	КонецЕсли;
	
	ИдентификаторПланаОбмена = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.ПланыОбмена[Запись.ИмяПланаОбмена]);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ЗапросыРазрешений,
		РаботаВБезопасномРежимеСлужебный.ЗапросыНаИспользованиеВнешнихРесурсовДляВнешнегоМодуля(ИдентификаторПланаОбмена, Разрешения));
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаЗаписи" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если Параметры.Ключ.ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов Тогда
			
			ВыбраннаяФорма = "РегистрСведений.ПравилаДляОбменаДанными.Форма.ПравилаКонвертацииОбъектов";
			
		ИначеЕсли Параметры.Ключ.ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаРегистрацииОбъектов Тогда
			
			ВыбраннаяФорма = "РегистрСведений.ПравилаДляОбменаДанными.Форма.ПравилаРегистрацииОбъектов";
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
