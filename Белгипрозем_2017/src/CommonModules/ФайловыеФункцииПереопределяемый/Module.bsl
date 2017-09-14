// Возвращает структуру, содержащую различные персональные настройки
// по работе с файлами
Процедура ПолучитьПерсональныеНастройкиРаботыСФайлами(Настройки) Экспорт
	
	// Работа с файлами
	РаботаСФайламиВызовСервера.УстановитьПерсональныеНастройкиРаботыСФайлами(Настройки);
	// Конец Работа с файлами
	
КонецПроцедуры

// При переименовании пользователя переносит его настройки - РабочийКаталог, ДействиеПоДвойномуЩелчкуМыши и пр
//
Процедура ПеренестиНастройкиПриСменеИмениПользователя(знач ИмяТекущее, знач ИмяУстанавливаемое) Экспорт
	
	// Работа с файлами
	РаботаСФайламиВызовСервера.ПеренестиНастройкиПриСменеИмениПользователя(ИмяТекущее, ИмяУстанавливаемое);
	// Конец Работа с файлами
	
КонецПроцедуры

// Устанавливает имя файла при обмене
Функция УстановитьИмяФайлаПриОтправкеДанныхФайла(ЭлементДанных, ИмяКаталогаФайлов, УникальныйИдентификатор) Экспорт
	
	// РаботаСФайлами
	НовыйПутьФайла = РаботаСФайламиСобытия.УстановитьИмяФайлаПриОтправкеДанныхФайла(ЭлементДанных, ИмяКаталогаФайлов, УникальныйИдентификатор);
	// Конец РаботаСФайлами
	
	Возврат НовыйПутьФайла;
	
КонецФункции

// Удаляет файл при обмене
Процедура УдалитьФайлыПриПолученииДанныхФайла(ЭлементДанных, ПутьСПодкаталогом) Экспорт
	
	// РаботаСФайлами
	РаботаСФайламиВызовСервера.УдалитьФайлыПриПолученииДанныхФайла(ЭлементДанных, ПутьСПодкаталогом);
	// Конец РаботаСФайлами
	
КонецПроцедуры

// Добавляет файл на том при обмене
Процедура ДобавитьНаДискПриПолученииДанныхФайла(ЭлементДанных, ДвоичныеДанные, ПутьКФайлуНаТоме, 
	СсылкаНаТом, ВремяИзменения, ИмяБезРасширения, Расширение, РазмерФайла, Зашифрован = Ложь) Экспорт
	
	// РаботаСФайлами
	РаботаСФайламиВызовСервера.ДобавитьНаДискПриПолученииДанныхФайла(ЭлементДанных, ДвоичныеДанные, 
		ПутьКФайлуНаТоме, СсылкаНаТом, ВремяИзменения, ИмяБезРасширения, Расширение, 
		РазмерФайла, Зашифрован);
	// Конец РаботаСФайлами
	
КонецПроцедуры

// Добавляет файл на том при "Разместить файлы начального образа"
Процедура ДобавитьФайлыВТомаПриРазмещении(СоответствиеПутейФайлов, ТипХраненияФайлов, ПрисоединяемыеФайлы) Экспорт
	
	НачатьТранзакцию();
	Попытка
		// РаботаСФайлами
		РаботаСФайламиВызовСервера.ДобавитьФайлыВТомаПриРазмещении(СоответствиеПутейФайлов, ТипХраненияФайлов);
		// Конец РаботаСФайлами
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Удаляет регистрацию изменений после "Разместить файлы начального образа"
Процедура УдалитьРегистрациюИзменений(ПланОбменаСсылка, ПрисоединяемыеФайлы) Экспорт
	
	// РаботаСФайлами
	РаботаСФайламиВызовСервера.УдалитьРегистрациюИзменений(ПланОбменаСсылка);
	// Конец РаботаСФайлами
	
КонецПроцедуры

// Возвращает Истина, если это элемент данных - Файл или Присоединенный файл.
Функция ЭтоЭлементФайл(ЭлементДанных) Экспорт
	
	Если 
		// РаботаСФайлами
		РаботаСФайламиСобытия.ЭтоЭлементРаботаСФайлами(ЭлементДанных)
		// Конец РаботаСФайлами
	Тогда
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает Истина в параметре Значение, если элемент данных (справочник Файл) запрещен к загрузке
//
Процедура ЭлементЗапрещенКЗагрузке(ЭлементДанных, ПолучениеЭлемента, Значение) Экспорт
	
	// РаботаСФайлами
	РаботаСФайламиСобытия.ЭлементЗапрещенКЗагрузке(ЭлементДанных, ПолучениеЭлемента, Значение);
	// Конец РаботаСФайлами
	
КонецПроцедуры

// Возвращает структуру с двоичными данными файла и подписи
Функция ПолучитьДвоичныеДанныеФайлаИПодписи(ДанныеСтроки) Экспорт
	
	// РаботаСФайлами
	Если РаботаСФайламиСобытия.ЭтоЭлементРаботаСФайлами(ДанныеСтроки.Объект) Тогда
		Возврат РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИДвоичныеДанные(, ДанныеСтроки.Объект, ДанныеСтроки.АдресПодписи);
	КонецЕсли;
	// Конец РаботаСФайлами
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает текст запроса для извлечения текста
Функция ПолучитьТекстЗапроса() Экспорт
	
	ТекстЗапроса = "";
	
	// РаботаСФайлами
	РаботаСФайламиВызовСервера.ПолучитьТекстЗапроса(ТекстЗапроса);
	// Конец РаботаСФайлами
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Получает полный путь к файлу на диске
Функция ПолучитьИмяФайлаСПутемКДвоичнымДанным(ФайлСсылка) Экспорт
	
	// РаботаСФайлами
	Если РаботаСФайламиСобытия.ЭтоЭлементРаботаСФайлами(ФайлСсылка) Тогда
		Возврат РаботаСФайламиВызовСервера.ПолучитьИмяФайлаСПутемКДвоичнымДанным(ФайлСсылка);
	КонецЕсли;
	// Конец РаботаСФайлами
	
КонецФункции

// Записывает извлеченный текст
Процедура ЗаписатьИзвлеченныйТекст(ФайлОбъект) Экспорт
	
	// РаботаСФайлами
	Если РаботаСФайламиСобытия.ЭтоЭлементРаботаСФайлами(ФайлОбъект) Тогда
		РаботаСФайламиВызовСервера.ЗаписатьИзвлеченныйТекст(ФайлОбъект);
	КонецЕсли;
	// Конец РаботаСФайлами
	
КонецПроцедуры

// Возвращает навигационную ссылку на файл (на реквизит или во временное хранилище)
Функция ПолучитьНавигационнуюСсылкуФайла(ФайлСсылка, УникальныйИдентификатор) Экспорт
	
	// РаботаСФайлами
	Если РаботаСФайламиСобытия.ЭтоЭлементРаботаСФайлами(ФайлСсылка) Тогда
		Возврат РаботаСФайламиВызовСервера.ПолучитьНавигационнуюСсылкуДляОткрытия(ФайлСсылка, УникальныйИдентификатор);
	КонецЕсли;
	// Конец РаботаСФайлами
	
КонецФункции

// Возвращает количество файлов в томах
Функция ПолучитьКоличествоФайловВТомах() Экспорт
	
	КоличествоФайловВТомах = 0;
	
	// РаботаСФайлами
	КоличествоФайловВТомах = КоличествоФайловВТомах + РаботаСФайламиВызовСервера.ПодсчитатьКоличествоФайловВТомах();
	// Конец РаботаСФайлами
	
	Возврат КоличествоФайловВТомах;
	
КонецФункции

// Выполняет дополнительную обработку при отправке данных обмена.
//
Процедура ВыполнитьДополнительнуюОбработкуПриОтправкеДанных(ЭлементДанных) Экспорт
	
	// РаботаСФайлами
	РаботаСФайламиСобытия.ВыполнитьДополнительнуюОбработкуПриОтправкеДанных(ЭлементДанных);
	// Конец РаботаСФайлами
	
КонецПроцедуры

// Выполняет дополнительную обработку при получении данных обмена.
//
Процедура ВыполнитьДополнительнуюОбработкуПриПолученииДанных(ЭлементДанных) Экспорт
	
	// РаботаСФайлами
	РаботаСФайламиСобытия.ВыполнитьДополнительнуюОбработкуПриПолученииДанных(ЭлементДанных);
	// Конец РаботаСФайлами
	
КонецПроцедуры

// Возвращает есть ли хранимые файлы к этому объекту
Функция ЕстьХранимыеФайлы(ВнешнийОбъект) Экспорт
	
	// РаботаСФайлами
	ТипыВладельцев = Метаданные.ОбщиеКоманды.ПрисоединенныеФайлы.ТипПараметраКоманды.Типы();
	Если ТипыВладельцев.Найти(ТипЗнч(ВнешнийОбъект)) <> Неопределено Тогда
		МассивФайлов = РаботаСФайламиВызовСервера.ПолучитьВсеПодчиненныеФайлы(ВнешнийОбъект);
		Возврат (МассивФайлов.Количество() <> 0);
	КонецЕсли;
	// Конец РаботаСФайлами
	
	Возврат Ложь;
	
КонецФункции

// Возвращает хранимые файлы к этому объекту
Функция ПолучитьХранимыеФайлы(ВнешнийОбъект) Экспорт
	
	МассивДанных = Новый Массив;
	
	// РаботаСФайлами
	ТипыВладельцев = Метаданные.ОбщиеКоманды.ПрисоединенныеФайлы.ТипПараметраКоманды.Типы();
	Если ТипыВладельцев.Найти(ТипЗнч(ВнешнийОбъект)) <> Неопределено Тогда
		
		МассивФайлов = РаботаСФайламиВызовСервера.ПолучитьВсеПодчиненныеФайлы(ВнешнийОбъект);
		
		Для Каждого Файл Из МассивФайлов Цикл
			ДанныеФайла = Новый Структура("ДатаМодификацииУниверсальная, Размер, Наименование, Расширение, ДвоичныеДанныеФайла, Текст");
			
			ДанныеФайла.ДатаМодификацииУниверсальная = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Файл.ТекущаяВерсия, "ДатаМодификацииУниверсальная");
			ДанныеФайла.Размер = Файл.ТекущаяВерсияРазмер;
			ДанныеФайла.Наименование = Файл.Наименование;
			ДанныеФайла.Расширение = Файл.ТекущаяВерсияРасширение;
			
			ДанныеДляОткрытия = РаботаСФайламиВызовСервера.ПолучитьНавигационнуюСсылкуВоВременномХранилище(Файл.ТекущаяВерсия);
			ДанныеФайла.ДвоичныеДанныеФайла = ДанныеДляОткрытия;
			
			ДанныеФайла.Текст = Файл.ТекстХранилище.Получить();
			
			МассивДанных.Добавить(ДанныеФайла);
		КонецЦикла;	
		
	КонецЕсли;
	// Конец РаботаСФайлами
	
	Возврат МассивДанных;
	
КонецФункции

// Возвращает Истина в параметре ЕстьХранимыеФайлы, если есть хранимые файлы к объекту ВнешнийОбъект.
//
Процедура ОпределитьНаличиеХранимыхФайлов(ВнешнийОбъект, ЕстьХранимыеФайлы) Экспорт
	
	// РаботаСФайлами
	РаботаСФайламиВызовСервера.ОпределитьНаличиеХранимыхФайлов(ВнешнийОбъект, ЕстьХранимыеФайлы);
	// Конец РаботаСФайлами
	
КонецПроцедуры
