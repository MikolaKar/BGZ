
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЧислоВерсийВБазе = ПолучитьЧислоВерсийВБазе();
	ТипХраненияВТомах = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске;
	
	РазмерВерсийВБазеВБайтах = ПолучитьРазмерВерсийВБазе();
	РазмерВерсийВБазе = РазмерВерсийВБазеВБайтах / 1048576;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРазмерВерсийВБазе()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ВерсииФайлов.Размер), 0) КАК Размер
	|ИЗ
	|	Справочник.ВерсииФайлов КАК ВерсииФайлов
	|ГДЕ
	|	ВерсииФайлов.ТипХраненияФайла = &ТипХраненияФайла
	|	И ВерсииФайлов.ФайлУдален = ЛОЖЬ";
	Запрос.УстановитьПараметр("ТипХраненияФайла", Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Размер;
	
КонецФункции

&НаСервере
Функция ПолучитьЧислоВерсийВБазе()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ 
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник.ВерсииФайлов КАК ВерсииФайлов
	|ГДЕ
	|	ВерсииФайлов.ТипХраненияФайла = &ТипХраненияФайла
	|	И ВерсииФайлов.ФайлУдален = ЛОЖЬ";
	Запрос.УстановитьПараметр("ТипХраненияФайла", Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Количество;
	
КонецФункции

&НаСервере
Функция ПолучитьМассивВерсийВБазе()
	
	МассивВерсий = Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВерсииФайлов.Ссылка КАК Ссылка,
	|	ВерсииФайлов.ПолноеНаименование КАК ПолноеНаименование,
	|	ВерсииФайлов.Размер КАК Размер
	|ИЗ
	|	Справочник.ВерсииФайлов КАК ВерсииФайлов
	|ГДЕ
	|	ВерсииФайлов.ТипХраненияФайла = &ТипХраненияФайла
	|	И ВерсииФайлов.ФайлУдален = ЛОЖЬ";
	Запрос.УстановитьПараметр("ТипХраненияФайла", Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе);
	
	Результат = Запрос.Выполнить();
	ТаблицаВыгрузки = Результат.Выгрузить();
	
	Для Каждого Строка Из ТаблицаВыгрузки Цикл
		ВерсияСтруктура = Новый Структура("Ссылка, Текст, Размер", 
			Строка.Ссылка, Строка.ПолноеНаименование, Строка.Размер);
		МассивВерсий.Добавить(ВерсияСтруктура);
	КонецЦикла;
	
	Возврат МассивВерсий;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПереносФайловВТома(Команда)
	
	Если ФайловыеФункции.ПолучитьТипХраненияФайлов() <> ТипХраненияВТомах Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не установлен тип хранения файлов ""В томах на диске""'"));
		Возврат;
	КонецЕсли;	
	
	Если Не ФайловыеФункции.ЕстьТомаХраненияФайлов() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нет ни одного тома для размещения файлов'"));
		Возврат;
	КонецЕсли;	
	
	Если ЧислоВерсийВБазе = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нет ни одного файла в информационной базе'"));
		Возврат;
	КонецЕсли;	
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПереносФайловВТомаПродолжение", ЭтотОбъект);
	
	ПоказатьВопрос(
		ОписаниеОповещения,
		НСтр("ru = 'Выполнить перенос файлов в информационной базе в тома хранения файлов?
			| Эта операция может занять продолжительное время.'"),
		РежимДиалогаВопрос.ДаНет,,
		КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПереносФайловВТомаПродолжение(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;	
	
	Состояние(НСтр("ru = 'Выполняется получение списка файлов...'"));
	
	МассивВерсий = ПолучитьМассивВерсийВБазе();
	НомерЦикла = 0;
	ЧислоПеренесенных = 0;
	
	ЧислоВерсийВПакете = 10;
	ПакетВерсий = Новый Массив;
	
	МассивФайловСОшибками = Новый Массив;
	ОбработкаПрервана = Ложь;
	
	Для Каждого ВерсияСтруктура Из МассивВерсий Цикл
		
		Прогресс = 0;
		Если ЧислоВерсийВБазе <> 0 Тогда
			Прогресс = НомерЦикла * 100 / ЧислоВерсийВБазе;
		КонецЕсли;	
		
		Состояние(НСтр("ru = 'Выполняется перенос файла в том...'"), Прогресс, ВерсияСтруктура.Текст, БиблиотекаКартинок.УстановитьВремя);
		
		ПакетВерсий.Добавить(ВерсияСтруктура);
		
		Если ПакетВерсий.Количество() >= ЧислоВерсийВПакете Тогда
			ЧислоПеренесенныхВПакете = ПеренестиМассивВерсийВТом(ПакетВерсий, МассивФайловСОшибками);
			
			Если ЧислоПеренесенныхВПакете = 0 И ПакетВерсий.Количество() = ЧислоВерсийВПакете Тогда
				ОбработкаПрервана = Истина; // весь пакет не смогли перенести - прекращаем операцию
				Прервать;
			КонецЕсли;	
			
			ЧислоПеренесенных = ЧислоПеренесенных + ЧислоПеренесенныхВПакете;
			ПакетВерсий.Очистить();
			
		КонецЕсли;	
		
		НомерЦикла = НомерЦикла + 1;
	КонецЦикла;	
	
	Если ПакетВерсий.Количество() <> 0 Тогда
		ЧислоПеренесенныхВПакете = ПеренестиМассивВерсийВТом(ПакетВерсий, МассивФайловСОшибками);
		
		Если ЧислоПеренесенныхВПакете = 0 Тогда
			ОбработкаПрервана = Истина; // весь пакет не смогли перенести - прекращаем операцию
		КонецЕсли;	
		
		ЧислоПеренесенных = ЧислоПеренесенных + ЧислоПеренесенныхВПакете;
		ПакетВерсий.Очистить();
	КонецЕсли;	
	
	ЧислоВерсийВБазе = ПолучитьЧислоВерсийВБазе();
	РазмерВерсийВБазеВБайтах = ПолучитьРазмерВерсийВБазе();
	РазмерВерсийВБазе = РазмерВерсийВБазеВБайтах / 1048576;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ОбработкаПрервана", ОбработкаПрервана);
	ПараметрыОповещения.Вставить("МассивФайловСОшибками", МассивФайловСОшибками);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыполнитьПереносФайловВТомаЗавершение",
		ЭтотОбъект,
		ПараметрыОповещения);
	
	Если ЧислоПеренесенных <> 0 Тогда
		СтрокаСообщения
			= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Завершен перенос файлов в тома. Перенесено файлов: %1'"),
			ЧислоПеренесенных);
		ПоказатьПредупреждение(ОписаниеОповещения ,СтрокаСообщения);
		Возврат;
	КонецЕсли;
	
	ВыполнитьПереносФайловВТомаЗавершение(ПараметрыОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПереносФайловВТомаЗавершение(ПараметрыОповещения) Экспорт
	
	ОбработкаПрервана = ПараметрыОповещения.ОбработкаПрервана;
	МассивФайловСОшибками = ПараметрыОповещения.МассивФайловСОшибками;
	
	Если МассивФайловСОшибками.Количество() <> 0 Тогда
		
		Пояснение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Количество ошибок при переносе: %1'"),
			МассивФайловСОшибками.Количество());
			
		Если ОбработкаПрервана Тогда
			Пояснение = НСтр("ru = 'Не удалось перенести ни одного файла из пакета. Перенос прерван.'");
		КонецЕсли;	
		
		ПараметрыФормы = Новый Структура("МассивФайловСОшибками, Пояснение", МассивФайловСОшибками, Пояснение);
		ОткрытьФорму("Обработка.ПереносФайловВТома.Форма.ФормаОтчета", ПараметрыФормы);
		
	КонецЕсли;	
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция ПеренестиМассивВерсийВТом(ПакетВерсий, МассивФайловСОшибками)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЧислоОбработанных = 0;
	МаксимальныйРазмерФайла = ФайловыеФункции.ПолучитьМаксимальныйРазмерФайла();
	
	Для Каждого ВерсияСтруктура Из ПакетВерсий Цикл
		
		Если ПеренестиВерсиюВТом(ВерсияСтруктура, МаксимальныйРазмерФайла, МассивФайловСОшибками) Тогда
			ЧислоОбработанных = ЧислоОбработанных + 1;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат ЧислоОбработанных;
	
КонецФункции

&НаСервере
// переносит одну версию в том
Функция ПеренестиВерсиюВТом(ВерсияСтруктура, МаксимальныйРазмерФайла, МассивФайловСОшибками)
	
	Перем СсылкаНаТом;
	
	КодВозврата = Истина;
	
	ВерсияСсылка = ВерсияСтруктура.Ссылка;
	ФайлСсылка = ВерсияСсылка.Владелец;
	Размер = ВерсияСтруктура.Размер;
	ИмяДляЖурнала = "";
	
	Если Размер > МаксимальныйРазмерФайла Тогда
		
		ИмяДляЖурнала = ВерсияСтруктура.Текст;
		ЗаписьЖурналаРегистрации(
								НСтр("ru = 'Перенос не выполнен. Размер файла превышает максимальный.'", 
								ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
		                         УровеньЖурналаРегистрации.Информация, , 
								 ФайлСсылка,
		                         ИмяДляЖурнала);
		
		Возврат Ложь; // ничего не сообщаем 
	КонецЕсли;	
	
	ИмяДляЖурнала = ВерсияСтруктура.Текст;
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Начат перенос файла в том'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
	                         УровеньЖурналаРегистрации.Информация, , 
							 ФайлСсылка,
	                         ИмяДляЖурнала);
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ФайлСсылка);
	Исключение
		Возврат Ложь; // ничего не сообщаем 
	КонецПопытки;
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ВерсияСсылка);
	Исключение
		РазблокироватьДанныеДляРедактирования(ФайлСсылка);
		Возврат Ложь; // ничего не сообщаем 
	КонецПопытки;
	
	Попытка
		
		ТипХраненияФайла = ВерсияСсылка.ТипХраненияФайла;
		
		Если ТипХраненияФайла <> Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
		 	// тут файл на диске - так не должно быть
			РазблокироватьДанныеДляРедактирования(ФайлСсылка);
			РазблокироватьДанныеДляРедактирования(ВерсияСсылка);
			Возврат Ложь;
		КонецЕсли;	
		
		НачатьТранзакцию();
		
		ВерсияОбъект = ВерсияСсылка.ПолучитьОбъект();
			
		ХранилищеФайла = РаботаСФайламиВызовСервера.ПолучитьХранилищеФайлаИзИнформационнойБазы(ВерсияСсылка);
		ДвоичныеДанныеФайла = ХранилищеФайла.Получить();
		
		ПутьКФайлуНаТоме = "";
		ФайловыеФункции.ДобавитьНаДиск(ДвоичныеДанныеФайла, ПутьКФайлуНаТоме, СсылкаНаТом, 
			ВерсияСсылка.ДатаМодификацииУниверсальная, 
			ВерсияСсылка.НомерВерсии, ВерсияСсылка.ПолноеНаименование, 
			ВерсияСсылка.Расширение, ВерсияСсылка.Размер,
			ФайлСсылка.Зашифрован,
			ВерсияСсылка.ДатаМодификацииУниверсальная, // чтобы все файлы не попали в одну папку - за сегодняшний день - подставляем дату создания файла
			ВерсияСсылка
		);
		
		ВерсияОбъект.ПутьКФайлу = ПутьКФайлуНаТоме;
		ВерсияОбъект.Том = СсылкаНаТом.Ссылка;
		ВерсияОбъект.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске;
		ВерсияОбъект.ФайлХранилище = Новый ХранилищеЗначения("");
		ВерсияОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина); // чтобы прошла запись ранее подписанного объекта
		ВерсияОбъект.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		ВерсияОбъект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
		ВерсияОбъект.Записать();
		
		ФайлОбъект = ФайлСсылка.ПолучитьОбъект();
		ФайлОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина); // чтобы прошла запись ранее подписанного объекта
		ФайлОбъект.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		ФайлОбъект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
		ФайлОбъект.Записать(); // для переноса полей версии в файл
		
		РаботаСФайламиВызовСервера.УдалитьЗаписьИзРегистраХранимыеФайлыВерсий(ВерсияСсылка);
		
		ЗафиксироватьТранзакцию();
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Успешно завершен перенос версии файла в том'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
		                         УровеньЖурналаРегистрации.Информация, , 
								 ФайлСсылка,
		                         ИмяДляЖурнала);
		
	Исключение	
		ОтменитьТранзакцию();
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		СтруктураОшибки = Новый Структура("ИмяФайла, Ошибка, Версия",
			ИмяДляЖурнала, КраткоеПредставлениеОшибки(ИнформацияОбОшибке), ВерсияСсылка);
		МассивФайловСОшибками.Добавить(СтруктураОшибки);
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка переноса версии файла в том:'") + " " + ИмяДляЖурнала, 
		                         УровеньЖурналаРегистрации.Информация, , 
								 ФайлСсылка,
		                         КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
								 
		КодВозврата = Ложь;
		
	КонецПопытки;
	
	РазблокироватьДанныеДляРедактирования(ФайлСсылка);
	РазблокироватьДанныеДляРедактирования(ВерсияСсылка);
	
	Возврат КодВозврата;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ФайловыеФункции.ПолучитьКонстантуХранитьФайлыВТомахНаДиске() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не установлен тип хранения файлов ""В томах на диске""'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	Если Не ФайловыеФункции.ЕстьТомаХраненияФайлов() Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Нет ни одного тома для размещения файлов'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры
