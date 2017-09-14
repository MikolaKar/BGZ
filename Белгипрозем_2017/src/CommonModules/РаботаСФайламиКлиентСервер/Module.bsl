////////////////////////////////////////////////////////////////////////////////
// Модуль процедур, исполняемых на сервере и на клиенте

// Определяет, можно ли занять файл и, если нет, то формирует строку ошибки
Функция МожноЛиЗанятьФайл(ДанныеФайла, СтрокаОшибки = "") Экспорт
	
	Если ДанныеФайла.ПометкаУдаления = Истина Тогда
		СтрокаОшибки =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		  НСтр("ru = 'Нельзя занять файл ""%1"", т.к. он помечен на удаление.'"),
		  Строка(ДанныеФайла.Ссылка));
		Возврат Ложь;
	КонецЕсли;
	
	
	Если ДанныеФайла.Редактирует.Пустая()
		Или ДанныеФайла.РедактируетТекущийПользователь Тогда 
		
		Возврат Истина;
		
	Иначе
		
		СтрокаОшибки =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		  НСтр("ru = 'Файл ""%1"" уже занят для редактирования пользователем ""%2"" с %3.'"),
		  Строка(ДанныеФайла.Ссылка), Строка(ДанныеФайла.Редактирует),
		  Формат(ДанныеФайла.ДатаЗаема, "ДЛФ=ДВ"));
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// Возвращает Истина, если файл с таким расширением является картинкой
Функция ЭтоРасширениеКартинки(Расширение) Экспорт
	
	РасширениеКартинки = (Расширение = "bmp" ИЛИ Расширение = "tif" ИЛИ Расширение = "tiff" 
		ИЛИ Расширение = "jpg" ИЛИ Расширение = "jpeg" ИЛИ Расширение = "png" ИЛИ Расширение = "gif");
		
	Возврат РасширениеКартинки;
	
КонецФункции // РасширениеФайлаРазрешеноДляЗагрузки()

// Возвращает Истина, если файл с таким расширением можно распознать - т.е. это картинка или PDF
Функция ЭтотФайлМожноРаспознать(Расширение, ИспользоватьImageMagickДляПреобразованияPDF) Экспорт
	
	Если ЭтоРасширениеКартинки(НРег(Расширение)) Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Если ИспользоватьImageMagickДляПреобразованияPDF И (НРег(Расширение) = "pdf") Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Возврат Ложь;
	
КонецФункции // РасширениеФайлаРазрешеноДляЗагрузки()

// создает элемент справочника Файлы
Функция СоздатьЭлементСправочникаФайлы(ВыбранныйФайл, МассивСтруктурВсехФайлов, Владелец, 
	ИдентификаторФормы, Комментарий, ХранитьВерсии, ДобавленныеФайлы,
	АдресВременногоХранилищаФайла, АдресВременногоХранилищаТекста,
	Пользователь, ПараметрыРаспознавания, Категории = Неопределено,
	Кодировка = Неопределено) Экспорт
	
	ИмяБезРасширения = ВыбранныйФайл.ИмяБезРасширения;
	Расширение = ВыбранныйФайл.Расширение;
	
	Расширение = ФайловыеФункцииКлиентСервер.РасширениеБезТочки(ВыбранныйФайл.Расширение);
	ВремяИзменения = ВыбранныйФайл.ПолучитьВремяИзменения();
	ВремяИзмененияУниверсальное = ВыбранныйФайл.ПолучитьУниверсальноеВремяИзменения();
	Размер = ВыбранныйФайл.Размер();
	
	// Создадим карточку Файла в БД
	ДокСсылка = РаботаСФайламиВызовСервера.СоздатьФайлСВерсией(
		Владелец,
		ИмяБезРасширения,
		Расширение,
		ВремяИзменения,
		ВремяИзмененияУниверсальное,
		Размер,
		АдресВременногоХранилищаФайла,
		АдресВременногоХранилищаТекста,
		Ложь,  // это не веб клиент
		Пользователь,
		Комментарий,
		ПараметрыРаспознавания,
		ХранитьВерсии,
		Ложь, //ЗаписатьВИсторию
		Неопределено,//СписокКатегорий
		Ложь,// НеобходимоВыполнитьВставкуШКНаКлиенте
		Неопределено,//ДополнительныеПараметры
		Кодировка);
		
	Если Категории <> Неопределено Тогда  
		Если ТипЗнч(Владелец) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
			Для Каждого Категория Из Категории Цикл
				РаботаСКатегориямиДанных.УстановитьКатегориюУОбъекта(ПользователиКлиентСервер.ТекущийПользователь(), Категория.Значение, ДокСсылка);	
			КонецЦикла;	
		Иначе
			Для Каждого Категория Из Категории Цикл
				РаботаСКатегориямиДанных.УстановитьКатегориюУОбъекта(ПользователиКлиентСервер.ТекущийПользователь(), Категория.Значение, Владелец);	
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
		
	Если ЭтоАдресВременногоХранилища(АдресВременногоХранилищаФайла) Тогда
		УдалитьИзВременногоХранилища(АдресВременногоХранилищаФайла);	
	КонецЕсли;	
	
	Если Не ПустаяСтрока(АдресВременногоХранилищаТекста) Тогда 
		Если ЭтоАдресВременногоХранилища(АдресВременногоХранилищаТекста) Тогда
			УдалитьИзВременногоХранилища(АдресВременногоХранилищаТекста);	
		КонецЕсли;	
	КонецЕсли;	

	ДобавленныйФайлИПуть = Новый Структура("ФайлСсылка, Путь, ПолноеИмя", ДокСсылка, ВыбранныйФайл.Путь, ВыбранныйФайл.ПолноеИмя);
	ДобавленныеФайлы.Добавить(ДобавленныйФайлИПуть);
	
	Запись = Новый Структура;
	Запись.Вставить("ИмяФайла", ВыбранныйФайл.ПолноеИмя);
	Запись.Вставить("Файл", ДокСсылка);
	МассивСтруктурВсехФайлов.Добавить(Запись);
	
	Если Пользователь = Неопределено Тогда // вызов из импорта файлов
		ПротоколированиеРаботыПользователей.ЗаписатьИмпортФайлов(ДокСсылка, ВыбранныйФайл.ПолноеИмя);		
	КонецЕсли;	

КонецФункции

// Получает имя сканированного файла, вида ДМ-00000012, где ДМ - префикс базы
Функция ПолучитьИмяСканированногоФайла(НомерФайла, ПрефиксБазы) Экспорт
	
	ИмяФайла = "";
	Если НЕ ПустаяСтрока(ПрефиксБазы) Тогда
		ИмяФайла = ПрефиксБазы + "-";
	КонецЕсли;
	
	ИмяФайла = ИмяФайла + Формат(НомерФайла, "ЧЦ=9; ЧВН=; ЧГ=0");
	
	Возврат ИмяФайла;
	
КонецФункции	

// Преобразует дату в универсальное время и возвращает его
Функция ПолучитьУниверсальноеВремя(Дата) Экспорт
	
	УниверсальноеВремя = Дата('00010101');
	
	#Если Сервер Тогда
		ЧасовойПояс = ЧасовойПояс();
		Если ПолучитьДопустимыеЧасовыеПояса().Найти(ЧасовойПояс) = Неопределено Тогда
			// Если на компьютере установлен некорректный часовой пояс, то считаем, что GMT 0:00.
			УниверсальноеВремя = Дата;
		Иначе
			УниверсальноеВремя = УниверсальноеВремя(Дата, ЧасовойПояс);
		КонецЕсли;
	#Иначе
		УниверсальноеВремя = УниверсальноеВремя(Дата);
	#КонецЕсли
	
	Возврат УниверсальноеВремя;
	
КонецФункции	

// Преобразует дату в местное время и возвращает его
Функция ПолучитьМестноеВремя(Дата) Экспорт
	
	МестноеВремя = Дата('00010101');
	
	#Если Сервер Тогда
		ЧасовойПояс = ЧасовойПояс();
		Если ПолучитьДопустимыеЧасовыеПояса().Найти(ЧасовойПояс) = Неопределено Тогда
			// Если на компьютере установлен некорректный часовой пояс, то считаем, что GMT 0:00.
			МестноеВремя = Дата;
		Иначе
			МестноеВремя = МестноеВремя(Дата, ЧасовойПояс);
		КонецЕсли;
	#Иначе
		МестноеВремя = МестноеВремя(Дата);
	#КонецЕсли
	
	Возврат МестноеВремя;
	
КонецФункции	