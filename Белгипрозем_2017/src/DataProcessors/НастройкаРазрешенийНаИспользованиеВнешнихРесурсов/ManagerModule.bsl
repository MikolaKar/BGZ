#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПредставлениеРазрешенийНаИспользованиеВнешнихРесурсов(Знач ТаблицыРазрешений) Экспорт
	
	Макет = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ПолучитьМакет("ПредставленияРазрешений");
	ТабличныйДокумент = Новый ТабличныйДокумент();
	
	СформироватьПредставлениеРазрешений(ТабличныйДокумент, ТаблицыРазрешений, Макет);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПредставлениеРезультатаПримененияЗапросовНаИспользованиеВнешнихРесурсов(Знач ОперацииАдминистрирования, Знач ДельтаРазрешений) Экспорт
	
	Макет = Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ПолучитьМакет("ПредставленияРазрешений");
	ОбластьОтступа = Макет.ПолучитьОбласть("Отступ");
	
	ТабличныйДокумент = Новый ТабличныйДокумент();
	
	СформироватьПредставлениеОпераций(ТабличныйДокумент, Макет, ОперацииАдминистрирования);
	
	ВыводитьГруппировки = ДельтаРазрешений.Количество() > 1;
	
	Для Каждого ФрагментИзменений Из ДельтаРазрешений Цикл
		
		Модуль = ФрагментИзменений.ВнешнийМодуль;
		
		Если Модуль = РаботаВБезопасномРежимеСлужебныйПовтИсп.СлужебныйИОМ() Тогда
		
			Словарь = СловарьМодуляКонфигурации();
			НаименованиеМодуля = Метаданные.Синоним;
			
		Иначе
			
			Словарь = РаботаВБезопасномРежимеСлужебный.МенеджерВнешнегоМодуля(Модуль).СловарьКонтейнераВнешнегоМодуля();
			НаименованиеМодуля = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Модуль, "Наименование");
			
		КонецЕсли;
		
		Разница = ФрагментИзменений.Изменения;
		
		КоличествоДобавляемых = РаботаВБезопасномРежимеСлужебный.КоличествоРазрешенийВТаблицах(Разница.Добавляемые);
		КоличествоУдаляемых = РаботаВБезопасномРежимеСлужебный.КоличествоРазрешенийВТаблицах(Разница.Удаляемые);
		
		Если КоличествоДобавляемых > 0 Тогда
			
			ТабличныйДокумент.Вывести(ОбластьОтступа);
			
			ОбластьШапки = Макет.ПолучитьОбласть("ШапкаНовыеРазрешения");
			ОбластьШапки.Параметры.ВидВнешнегоМодуляВРодительномПадеже = НРег(Словарь.Родительный);
			ОбластьШапки.Параметры.Наименование = НаименованиеМодуля;
			Если Модуль <> РаботаВБезопасномРежимеСлужебныйПовтИсп.СлужебныйИОМ() Тогда
				ОбластьШапки.Параметры.Модуль = Модуль;
			КонецЕсли;
			ТабличныйДокумент.Вывести(ОбластьШапки);
			
			Если ВыводитьГруппировки Тогда
				ТабличныйДокумент.НачатьГруппуСтрок();
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьОтступа);
			
			СформироватьПредставлениеРазрешений(ТабличныйДокумент, Разница.Добавляемые, Макет);
			
			Если ВыводитьГруппировки Тогда
				ТабличныйДокумент.ЗакончитьГруппуСтрок();
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
		КонецЕсли;
		
		Если КоличествоУдаляемых > 0 Тогда
			
			Если ВыводитьГруппировки Тогда
				ТабличныйДокумент.НачатьГруппуСтрок();
			КонецЕсли;
			
			ОбластьШапки = Макет.ПолучитьОбласть("ШапкаУдаляемыеРазрешения");
			ОбластьШапки.Параметры.ВидВнешнегоМодуляВРодительномПадеже = НРег(Словарь.Родительный);
			ОбластьШапки.Параметры.Наименование = НаименованиеМодуля;
			ТабличныйДокумент.Вывести(ОбластьШапки);
			СформироватьПредставлениеРазрешений(ТабличныйДокумент, Разница.Удаляемые, Макет);
			
			Если ВыводитьГруппировки Тогда
				ТабличныйДокумент.ЗакончитьГруппуСтрок();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура СформироватьПредставлениеОпераций(ТабличныйДокумент, Знач Макет, Знач ОперацииАдминистрирования)
	
	Для Каждого Описание Из ОперацииАдминистрирования Цикл
		
		Если Описание.Операция = Перечисления.ОперацииСНаборамиРазрешений.Удаление Тогда
			
			ЭтоПрофильКонфигурации = (Описание.ВнешнийМодуль = РаботаВБезопасномРежимеСлужебныйПовтИсп.СлужебныйИОМ());
			
			Если ЭтоПрофильКонфигурации Тогда
				
				Словарь = СловарьМодуляКонфигурации();
				НаименованиеМодуля = Метаданные.Синоним;
				
			Иначе
				
				Словарь = РаботаВБезопасномРежимеСлужебный.МенеджерВнешнегоМодуля(Описание.ВнешнийМодуль).СловарьКонтейнераВнешнегоМодуля();
				НаименованиеМодуля = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Описание.ВнешнийМодуль, "Наименование");
				
			КонецЕсли;
			
			Область = Макет.ПолучитьОбласть("ШапкаУдалениеПрофиляБезопасности");
			Область.Параметры["ВидВнешнегоМодуляВРодительномПадеже"] = НРег(Словарь.Родительный);
			Область.Параметры["Наименование"] = НаименованиеМодуля;
			
			ТабличныйДокумент.Вывести(Область);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СформироватьПредставлениеРазрешений(ТабличныйДокумент, Знач НаборыРазрешений, Знач Макет)
	
	ОбластиМакета = ОбластиМакета();
	
	ОбластьОтступа = Макет.ПолучитьОбласть("Отступ");
	
	Для Каждого КлючИЗначение Из НаборыРазрешений Цикл
		
		ТипРазрешения = КлючИЗначение.Ключ;
		Разрешения = КлючИЗначение.Значение;
		
		Если Разрешения.Количество() > 0 Тогда
			
			ИмяОбластиШапки = ОбластиМакета.Найти(ТипРазрешения, "ТипРазрешения").ШапкаТаблицы + "_1";
			ОбластьШапки = Макет.ПолучитьОбласть(ИмяОбластиШапки);
			ЗаполнитьЗначенияСвойств(ОбластьШапки.Параметры, Новый Структура("Количество", Разрешения.Количество()));
			ТабличныйДокумент.Вывести(ОбластьШапки);
			ТабличныйДокумент.НачатьГруппуСтрок(ТипРазрешения, Истина);
			ИмяОбластиШапки = ОбластиМакета.Найти(ТипРазрешения, "ТипРазрешения").ШапкаТаблицы + "_2";
			ОбластьШапки = Макет.ПолучитьОбласть(ИмяОбластиШапки);
			ТабличныйДокумент.Вывести(ОбластьШапки);
			
			ИмяОбластиСтроки = ОбластиМакета.Найти(ТипРазрешения, "ТипРазрешения").СтрокаТаблицы;
			ОбластьСтроки = Макет.ПолучитьОбласть(ИмяОбластиСтроки);
			
			Для Каждого Разрешение Из Разрешения Цикл
				
				Если ТипРазрешения = "FileSystemAccess" Тогда
					
					Если Разрешение.Адрес = "/temp" Тогда
						Разрешение.Адрес = НСтр("ru = 'Каталог временных файлов'");
					КонецЕсли;
					
					Если Разрешение.Адрес = "/bin" Тогда
						Разрешение.Адрес = НСтр("ru = 'Каталог, в который установлен сервер 1С:Предприятия'");
					КонецЕсли;
					
				КонецЕсли;
				
				ЗаполнитьЗначенияСвойств(ОбластьСтроки.Параметры, Разрешение);
				ТабличныйДокумент.Вывести(ОбластьСтроки);
				
			КонецЦикла;
			
			ТабличныйДокумент.ЗакончитьГруппуСтрок();
			
			ТабличныйДокумент.Вывести(ОбластьОтступа);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция СловарьМодуляКонфигурации() Экспорт
	
	Результат = Новый Структура();
	
	Результат.Вставить("Именительный", НСтр("ru = 'Программа'"));
	Результат.Вставить("Родительный", НСтр("ru = 'Программы'"));
	
	Возврат Результат;
	
КонецФункции

Функция ОбластиМакета()
	
	Результат = Новый ТаблицаЗначений();
	Результат.Колонки.Добавить("ТипРазрешения", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ШапкаТаблицы", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("СтрокаТаблицы", Новый ОписаниеТипов("Строка"));
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.ТипРазрешения = "FileSystemAccess";
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыКаталогиФайловойСистемы";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыКаталогиФайловойСистемы";
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.ТипРазрешения = "CreateComObject";
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыCOMОбъекты";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыCOMОбъекты";
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.ТипРазрешения = "AttachAddin";
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыВнешниеКомпоненты";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыВнешниеКомпоненты";
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.ТипРазрешения = "RunApplication";
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыПриложенияОС";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыПриложенияОС";
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.ТипРазрешения = "InternetResourceAccess";
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыИнтернетРесурсы";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыИнтернетРесурсы";
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.ТипРазрешения = "InternetResourceAccess";
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыИнтернетРесурсы";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыИнтернетРесурсы";
	
	НоваяСтрока = Результат.Добавить();
	НоваяСтрока.ТипРазрешения = "ExternalModulePrivilegedModeAllowed";
	НоваяСтрока.ШапкаТаблицы = "ШапкаТаблицыПривилегированныйРежим";
	НоваяСтрока.СтрокаТаблицы = "СтрокаТаблицыПривилегированныйРежим";
	
	Возврат Результат;
	
КонецФункции

Функция СценарийОбработкиЗапросовНаИзменениеДоступаКВнешнимРесурсам(Знач ИдентификаторыЗапросов, Знач РежимВосстановления) Экспорт
	
	ИдентификаторыОбрабатываемыхЗапросов = РаботаВБезопасномРежимеСлужебный.ИдентификаторыОбрабатываемыхЗапросов(ИдентификаторыЗапросов);
	
	Результат = Новый Массив();
	
	ИменаПрофилей = Новый Соответствие();
	
	Если НЕ РежимВосстановления Тогда
		
		ОперацииАдминистрирования = ОперацииАдминистрированияВЗапросах(ИдентификаторыОбрабатываемыхЗапросов);
		
		Для Каждого Описание Из ОперацииАдминистрирования Цикл
			
			ЭтоПрофильКонфигурации = (Описание.ВнешнийМодуль = РаботаВБезопасномРежимеСлужебныйПовтИсп.СлужебныйИОМ());
			
			Если Описание.Операция = Перечисления.ОперацииСНаборамиРазрешений.Создание Тогда
				
				ИмяПрофиля = ШаблонИмениПрофиляБезопасности(Описание.ВнешнийМодуль);
				
			Иначе
				
				Если ЭтоПрофильКонфигурации Тогда
					ИмяПрофиля = Константы.ПрофильБезопасностиИнформационнойБазы.Получить();
				Иначе
					ИмяПрофиля = РаботаВБезопасномРежимеСлужебный.РежимПодключенияВнешнегоМодуля(Описание.ВнешнийМодуль);
				КонецЕсли;
				
			КонецЕсли;
			
			ИменаПрофилей.Вставить(Описание.ВнешнийМодуль, ИмяПрофиля);
			
			ЭлементРезультата = Новый Структура("Операция,Профиль,Разрешения");
			ЭлементРезультата.Операция = Описание.Операция;
			ЭлементРезультата.Профиль = ИмяПрофиля;
			
			ДополнительныйЭлементРезультата = Неопределено;
			ПриоритетДополнительногоЭлемента = Ложь;
			
			Если ЭтоПрофильКонфигурации И Описание.Операция = Перечисления.ОперацииСНаборамиРазрешений.Создание Тогда
				
				ДополнительныйЭлементРезультата = Новый Структура("Операция,Профиль,Разрешения");
				ДополнительныйЭлементРезультата.Операция = Перечисления.ОперацииСНаборамиРазрешений.Назначение;
				ДополнительныйЭлементРезультата.Профиль = ИмяПрофиля;
				
				ПриоритетДополнительногоЭлемента = Ложь;
				
			КонецЕсли;
			
			Если ЭтоПрофильКонфигурации И Описание.Операция = Перечисления.ОперацииСНаборамиРазрешений.Удаление Тогда
				
				ДополнительныйЭлементРезультата = Новый Структура("Операция,Профиль,Разрешения");
				ДополнительныйЭлементРезультата.Операция = Перечисления.ОперацииСНаборамиРазрешений.УдалениеНазначения;
				ДополнительныйЭлементРезультата.Профиль = ИмяПрофиля;
				
				ПриоритетДополнительногоЭлемента = Истина;
				
			КонецЕсли;
			
			Если ДополнительныйЭлементРезультата = Неопределено Тогда
				
				Результат.Добавить(ЭлементРезультата);
				
			Иначе
				
				Если ПриоритетДополнительногоЭлемента Тогда
					
					Результат.Добавить(ДополнительныйЭлементРезультата);
					Результат.Добавить(ЭлементРезультата);
					
				Иначе
					
					Результат.Добавить(ЭлементРезультата);
					Результат.Добавить(ДополнительныйЭлементРезультата);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Дельта = РаботаВБезопасномРежимеСлужебный.ДельтаИзмененийРазрешенийНаИспользованиеВнешнихРесурсов(ИдентификаторыОбрабатываемыхЗапросов, РежимВосстановления);
	РезультатПримененияЗапросов = РезультатПримененияЗапросов(ИдентификаторыОбрабатываемыхЗапросов, РежимВосстановления);
	
	Для Каждого ФрагментИзменений Из Дельта Цикл
		
		Модуль = ФрагментИзменений.ВнешнийМодуль;
		
		ИмяПрофиля = ИменаПрофилей.Получить(Модуль);
		Если ИмяПрофиля = Неопределено Тогда
			
			Если Модуль <> РаботаВБезопасномРежимеСлужебныйПовтИсп.СлужебныйИОМ() Тогда
				ИмяПрофиля = РаботаВБезопасномРежимеСлужебный.РежимПодключенияВнешнегоМодуля(Модуль);
			Иначе
				ИмяПрофиля = Константы.ПрофильБезопасностиИнформационнойБазы.Получить();
			КонецЕсли;
			
		КонецЕсли;
		
		Если Модуль = РаботаВБезопасномРежимеСлужебныйПовтИсп.СлужебныйИОМ() Тогда
			ОписаниеПрофиля = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Профиль безопасности для информационной базы %1'"),
					СтрокаСоединенияИнформационнойБазы()
				);
		КонецЕсли;
		
		Добавлять = Истина;
		ЭлементРезультата = Неопределено;
		Для Каждого Этап Из Результат Цикл
			Если Этап.Операция = Перечисления.ОперацииСНаборамиРазрешений.Создание И Этап.Профиль = ИмяПрофиля Тогда
				ЭлементРезультата = Этап;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЭлементРезультата = Неопределено Тогда
			
			ЭлементРезультата = Новый Структура("Операция,Профиль,Разрешения");
			
			ЭлементРезультата.Операция = Перечисления.ОперацииСНаборамиРазрешений.Обновление;
			ЭлементРезультата.Профиль = ИмяПрофиля;
			
		Иначе
			Добавлять = Ложь;
		КонецЕсли;
		
		Если Модуль <> РаботаВБезопасномРежимеСлужебныйПовтИсп.СлужебныйИОМ() И ЭлементРезультата.Операция = Перечисления.ОперацииСНаборамиРазрешений.Обновление Тогда
			
			Если Не ПрофильБезопасностиНазначенВнешнемуМодулю(ЭлементРезультата.Профиль) Тогда
				ЭлементРезультата.Операция = Перечисления.ОперацииСНаборамиРазрешений.Создание;
			КонецЕсли;
			
		КонецЕсли;
		
		ЭлементРезультата.Разрешения = ПрофильВНотацииКластера(ЭлементРезультата.Профиль, ОписаниеПрофиля, РезультатПримененияЗапросов.Получить(Модуль));
		
		Если Добавлять Тогда
			Результат.Добавить(ЭлементРезультата);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ШаблонИмениПрофиляБезопасности(Знач ВнешнийМодуль) Экспорт
	
	Если ВнешнийМодуль = РаботаВБезопасномРежимеСлужебныйПовтИсп.СлужебныйИОМ() Тогда
		
		Результат = РаботаВБезопасномРежимеСлужебный.ИмяПрофиляБезопасностиКонфигурации();
		
	Иначе
		
		МенеджерМодуля = РаботаВБезопасномРежимеСлужебный.МенеджерВнешнегоМодуля(ВнешнийМодуль);
		Результат = МенеджерМодуля.ИмяПрофиляБезопасности(ВнешнийМодуль);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПрименитьЗапросыАдминистрирования(Знач ИдентификаторыЗапросов) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		ИдентификаторыОбрабатываемыхЗапросов = РаботаВБезопасномРежимеСлужебный.ИдентификаторыОбрабатываемыхЗапросов(ИдентификаторыЗапросов);
		
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	ЗапросыАдминистрированияРазрешенийИспользованияВнешнихРесурсов.Идентификатор,
			|	ЗапросыАдминистрированияРазрешенийИспользованияВнешнихРесурсов.Владелец,
			|	ЗапросыАдминистрированияРазрешенийИспользованияВнешнихРесурсов.Операция
			|ИЗ
			|	РегистрСведений.ЗапросыАдминистрированияРазрешенийИспользованияВнешнихРесурсов КАК ЗапросыАдминистрированияРазрешенийИспользованияВнешнихРесурсов
			|ГДЕ
			|	ЗапросыАдминистрированияРазрешенийИспользованияВнешнихРесурсов.Идентификатор В(&Идентификаторы)";
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Идентификаторы", ИдентификаторыОбрабатываемыхЗапросов);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ЭтоПрофильКонфигурации = (Выборка.Владелец = РаботаВБезопасномРежимеСлужебныйПовтИсп.СлужебныйИОМ());
			
			Если Выборка.Операция = Перечисления.ОперацииСНаборамиРазрешений.Создание Тогда
				
				Если ЭтоПрофильКонфигурации Тогда
					
					Константы.ПрофильБезопасностиИнформационнойБазы.Установить(ШаблонИмениПрофиляБезопасности(Выборка.Владелец));
					
				Иначе
					
					Набор = РегистрыСведений.РежимыПодключенияВнешнихМодулей.СоздатьНаборЗаписей();
					Набор.Отбор.ВнешнийМодуль.Установить(Выборка.Владелец);
					Запись = Набор.Добавить();
					Запись.ВнешнийМодуль = Выборка.Владелец;
					Запись.БезопасныйРежим = ШаблонИмениПрофиляБезопасности(Выборка.Владелец);
					Набор.Записать();
					
				КонецЕсли;
				
			Иначе
				
				Если ЭтоПрофильКонфигурации Тогда
					
					Константы.ПрофильБезопасностиИнформационнойБазы.Установить("");
					
				Иначе
					
					Набор = РегистрыСведений.РежимыПодключенияВнешнихМодулей.СоздатьНаборЗаписей();
					Набор.Отбор.ВнешнийМодуль.Установить(Выборка.Владелец);
					Набор.Записать();
					
					МенеджерыПредоставленныхРазрешений = РаботаВБезопасномРежимеСлужебный.МенеджерыКэшаПредоставленныхРазрешений();
					Для Каждого МенеджерПредоставленныхРазрешений Из МенеджерыПредоставленныхРазрешений Цикл
						
						Набор = МенеджерПредоставленныхРазрешений.СоздатьНаборЗаписей();
						Набор.Отбор.ВнешнийМодуль.Установить(Выборка.Владелец);
						Набор.Записать();
						
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

Функция РезультатПримененияЗапросов(Знач ИдентификаторыЗапросов, Знач РежимВосстановления) Экспорт
	
	ИдентификаторыОбрабатываемыхЗапросов = РаботаВБезопасномРежимеСлужебный.ИдентификаторыОбрабатываемыхЗапросов(ИдентификаторыЗапросов);
	
	Менеджеры = РаботаВБезопасномРежимеСлужебный.МенеджерыКэшаПредоставленныхРазрешений();
	ВсеРазрешения = РаботаВБезопасномРежимеСлужебный.ТаблицыРазрешений();
	
	НачатьТранзакцию();
	
	Если РежимВосстановления Тогда
		Менеджеры = РаботаВБезопасномРежимеСлужебный.МенеджерыКэшаПредоставленныхРазрешений();
		Для Каждого Менеджер Из Менеджеры Цикл
			Набор = Менеджер.СоздатьНаборЗаписей();
			Набор.Записать(Истина);
		КонецЦикла;
	КонецЕсли;
	
	РаботаВБезопасномРежимеСлужебный.ПрименитьЗапросы(ИдентификаторыОбрабатываемыхЗапросов);
	
	Для Каждого Менеджер Из Менеджеры Цикл
		
		ИмяТаблицы = Менеджер.ТипXDTOПредставленияРазрешений().Имя;
		ТекстЗапроса = Менеджер.ЗапросТекущегоСреза();
		
		Запрос = Новый Запрос(ТекстЗапроса);
		
		Таблица = ВсеРазрешения[ИмяТаблицы];
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Запрос.Выполнить().Выгрузить(), Таблица);
		ВсеРазрешения.Вставить(ИмяТаблицы, Таблица);
		
	КонецЦикла;
	
	ОтменитьТранзакцию();
	
	Результат = Новый Соответствие();
	
	Для Каждого КлючИЗначение Из ВсеРазрешения Цикл
		
		ИмяТаблицы = КлючИЗначение.Ключ;
		Таблица = КлючИЗначение.Значение;
		
		Для Каждого Строка Из Таблица Цикл
			
			ВнешнийМодуль = Строка.ВнешнийМодуль;
			
			РезультатПоМодулю = Результат.Получить(ВнешнийМодуль);
			Если РезультатПоМодулю = Неопределено Тогда
				РезультатПоМодулю = РаботаВБезопасномРежимеСлужебный.ТаблицыРазрешений();
			КонецЕсли;
			
			ТаблицаРезультата = РезультатПоМодулю[ИмяТаблицы];
			СтрокаТаблицыРезультата = ТаблицаРезультата.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицыРезультата, Строка);
			
			РезультатПоМодулю.Вставить(ИмяТаблицы, ТаблицаРезультата);
			Результат.Вставить(ВнешнийМодуль, РезультатПоМодулю);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПрофильВНотацииКластера(Знач ИмяПрофиля, Знач ОписаниеПрофиля, Знач Разрешения)
	
	Профиль = АдминистрированиеКластераКлиентСервер.СвойстваПрофиляБезопасности();
	Профиль.Имя = ИмяПрофиля;
	Профиль.Описание = ОписаниеПрофиля;
	Профиль.ПрофильБезопасногоРежима = Истина;
	
	Профиль.ПолныйДоступКФайловойСистеме = Ложь;
	Профиль.ПолныйДоступКCOMОбъектам = Ложь;
	Профиль.ПолныйДоступКВнешнимКомпонентам = Ложь;
	Профиль.ПолныйДоступКВнешнимМодулям = Ложь;
	Профиль.ПолныйДоступКПриложениямОперационнойСистемы = Ложь;
	Профиль.ПолныйДоступКИнтернетРесурсам = Ложь;
	
	Профиль.ПолныйДоступКПривилегированномуРежиму = Ложь;
	
	Менеджеры = РаботаВБезопасномРежимеСлужебный.МенеджерыКэшаПредоставленныхРазрешений();
	
	Для Каждого КлючИЗначение Из Разрешения Цикл
		
		ТаблицаОбработана = Истина;
		
		Для Каждого Менеджер Из Менеджеры Цикл
			
			Если Менеджер.ТипXDTOПредставленияРазрешений() = ФабрикаXDTO.Тип(РаботаВБезопасномРежимеСлужебный.ПакетXDTOПредставленийРазрешений(), КлючИЗначение.Ключ) Тогда
				
				Таблица = КлючИЗначение.Значение;
				
				Для Каждого Строка Из Таблица Цикл
					
					Менеджер.ЗаполнитьСвойстваПрофиляБезопасностиВНотацииИнтерфейсаАдминистрирования(
						Строка, Профиль);
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если Не ТаблицаОбработана Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Неизвестное имя типа разрешений: %1!'"), КлючИЗначение.Ключ);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Профиль;
	
КонецФункции

Процедура ВыполнитьОбработкуЗапросов(Знач ИдентификаторыЗапросов, Знач РежимВосстановления, АдресВременногоХранилища) Экспорт
	
	ОперацииАдминистрирования = ОперацииАдминистрированияВЗапросах(ИдентификаторыЗапросов);
	Дельта = РаботаВБезопасномРежимеСлужебный.ДельтаИзмененийРазрешенийНаИспользованиеВнешнихРесурсов(ИдентификаторыЗапросов, РежимВосстановления);
	
	Результат = Новый Структура();
	
	Результат.Вставить("ИдентификаторыЗапросов", ИдентификаторыЗапросов);
	Результат.Вставить("Представление", ПредставлениеРезультатаПримененияЗапросовНаИспользованиеВнешнихРесурсов(ОперацииАдминистрирования, Дельта));
	Результат.Вставить("Сценарий", Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.СценарийОбработкиЗапросовНаИзменениеДоступаКВнешнимРесурсам(ИдентификаторыЗапросов, РежимВосстановления));
	
	ПоместитьВоВременноеХранилище(Результат, АдресВременногоХранилища);
	
КонецПроцедуры

Процедура ВыполнитьОбработкуЗапросовВосстановления(Знач ИдентификаторыЗапросов, АдресВременногоХранилища) Экспорт
	
	ИдентификаторыОбрабатываемыхЗапросов = РаботаВБезопасномРежимеСлужебный.ИдентификаторыОбрабатываемыхЗапросов(ИдентификаторыЗапросов);
	
	ЗапросыВосстановления = РаботаВБезопасномРежимеСлужебный.ЗапросыНаОбновлениеРазрешенийКонфигурации();
	Дельта = РаботаВБезопасномРежимеСлужебный.ДельтаИзмененийРазрешенийНаИспользованиеВнешнихРесурсов(ЗапросыВосстановления, Истина);
	
	Если Дельта.Количество() > 0 Тогда
		
		ВыполнитьОбработкуЗапросов(ЗапросыВосстановления, Истина, АдресВременногоХранилища);
		
	Иначе
		
		Результат = Новый Структура();
		Результат.Вставить("ИдентификаторыЗапросов", ИдентификаторыОбрабатываемыхЗапросов);
		Результат.Вставить("Представление", Неопределено);
		Результат.Вставить("Сценарий", Новый Массив());
		ПоместитьВоВременноеХранилище(Результат, АдресВременногоХранилища);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьОбработкуЗапросовОбновления(РежимВосстановления, АдресВременногоХранилища) Экспорт
	
	Запросы = РаботаВБезопасномРежимеСлужебный.ЗапросыНаОбновлениеРазрешенийКонфигурации();
	ВыполнитьОбработкуЗапросов(Запросы, РежимВосстановления, АдресВременногоХранилища);
	
КонецПроцедуры

Процедура ВыполнитьОбработкуЗапросовОтключения(РежимВосстановления, АдресВременногоХранилища) Экспорт
	
	Запросы = РаботаВБезопасномРежимеСлужебный.ЗапросыНаОтключениеПрофилейБезопасности();
	ВыполнитьОбработкуЗапросов(Запросы, РежимВосстановления, АдресВременногоХранилища);
	
КонецПроцедуры


Функция ОперацииАдминистрированияВЗапросах(Знач ИдентификаторыЗапросов) Экспорт
	
	ИдентификаторыОбрабатываемыхЗапросов = РаботаВБезопасномРежимеСлужебный.ИдентификаторыОбрабатываемыхЗапросов(ИдентификаторыЗапросов);
	
	Результат = Новый ТаблицаЗначений();
	Результат.Колонки.Добавить("ВнешнийМодуль");
	Результат.Колонки.Добавить("Операция", Новый ОписаниеТипов("ПеречислениеСсылка.ОперацииСНаборамиРазрешений"));
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Запросы.Идентификатор,
		|	Запросы.Владелец,
		|	Запросы.Операция
		|ИЗ
		|	РегистрСведений.ЗапросыАдминистрированияРазрешенийИспользованияВнешнихРесурсов КАК Запросы
		|ГДЕ
		|	Запросы.Идентификатор В(&Идентификаторы)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Идентификаторы", ИдентификаторыОбрабатываемыхЗапросов);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Строка = Результат.Добавить();
		Строка.ВнешнийМодуль = Выборка.Владелец;
		Строка.Операция = Выборка.Операция;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПрофильБезопасностиНазначенВнешнемуМодулю(Знач ИмяПрофиля)
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	РежимыПодключенияВнешнихМодулей.ВнешнийМодуль
		|ИЗ
		|	РегистрСведений.РежимыПодключенияВнешнихМодулей КАК РежимыПодключенияВнешнихМодулей
		|ГДЕ
		|	РежимыПодключенияВнешнихМодулей.БезопасныйРежим = &БезопасныйРежим";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("БезопасныйРежим", ИмяПрофиля);
	РезультатЗапроса = Запрос.Выполнить();
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

#КонецЕсли

