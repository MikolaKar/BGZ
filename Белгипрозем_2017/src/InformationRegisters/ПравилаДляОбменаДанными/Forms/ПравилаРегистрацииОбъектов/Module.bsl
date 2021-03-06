&НаКлиенте
Перем ВнешниеРесурсыРазрешены;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновитьСписокВыбораПлановОбмена();
	
	ОбновитьСписокВыбораМакетаПравил();
	
	ОбновитьИнформациюОПравилах();
	
	ОбновитьИсточникПравил();
	
	СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными = ОбменДаннымиСервер.СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными();
	
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ВнешниеРесурсыРазрешены <> Истина Тогда
		
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("РазрешитьВнешнийРесурсЗавершение", ЭтотОбъект, ПараметрыЗаписи);
		Запросы = СоздатьЗапросНаИспользованиеВнешнихРесурсов(Запись);
		РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, ЭтотОбъект, ОповещениеОЗакрытии);
		
		Отказ = Истина;
		
	КонецЕсли;
	ВнешниеРесурсыРазрешены = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ЗаписатьИЗакрыть") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяПланаОбменаПриИзменении(Элемент)
	
	Запись.ИмяМакетаПравил = "";
	
	// вызов сервера
	ОбновитьСписокВыбораМакетаПравил();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникПравилПриИзменении(Элемент)
	
	// вызов сервера
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьПравила(Команда)
	
	Если ИсточникПравил = 0 Тогда 
		// Из конфигурации
		ВыполнитьЗагрузкуПравил(Неопределено, "", Ложь);
		Возврат;
	КонецЕсли;
	
	// Из файла с клиента
	ЧастиИмени = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Запись.ИмяФайлаПравил);
	
	ПараметрыДиалога = Новый Структура;
	ПараметрыДиалога.Вставить("Заголовок", НСтр("ru = 'Укажите из какого файла загрузить правила'"));
	ПараметрыДиалога.Вставить("Фильтр",
		  НСтр("ru = 'Файлы правил (*.xml)'") + "|*.xml|"
		+ НСтр("ru = 'Архивы ZIP (*.zip)'")   + "|*.zip"
	);
	
	ПараметрыДиалога.Вставить("ПолноеИмяФайла", ЧастиИмени.ПолноеИмя);
	ПараметрыДиалога.Вставить("ИндексФильтра", ?( НРег(ЧастиИмени.Расширение) = ".zip", 1, 0) ); 
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьПравилаЗавершение", ЭтотОбъект);
	ОбменДаннымиКлиент.ВыбратьИПередатьФайлНаСервер(Оповещение, ПараметрыДиалога, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПравила(Команда)
	
	ВариантыВыгрузки = Новый СписокЗначений;
	ВариантыВыгрузки.Добавить(Ложь,   НСтр("ru = 'Обычным файлом'") );
	ВариантыВыгрузки.Добавить(Истина, НСтр("ru = 'В архиве zip'")   );
	
	Оповещение = Новый ОписаниеОповещения("ВыгрузитьПравилаЗавершение", ЭтотОбъект);
	ПоказатьВыборИзМеню(Оповещение, ВариантыВыгрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ЗаписатьИЗакрыть");
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПоказатьЖурналРегистрацииПриОшибке(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("СобытиеЖурналаРегистрации", СобытиеЖурналаРегистрацииЗагрузкаПравилДляОбменаДанными);
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Отбор, ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВыбораПлановОбмена()
	
	СписокПлановОбмена = ОбменДаннымиПовтИсп.СписокПлановОбменаБСП();
	
	ЗаполнитьСписок(СписокПлановОбмена, Элементы.ИмяПланаОбмена.СписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВыбораМакетаПравил()
	
	Если Запись.ВидПравил = Перечисления.ВидыПравилДляОбменаДанными.ПравилаКонвертацииОбъектов Тогда
		
		СписокМакетов = ОбменДаннымиПовтИсп.ПолучитьСписокТиповыхПравилОбмена(Запись.ИмяПланаОбмена);
		
	Иначе // ПравилаРегистрацииОбъектов
		
		СписокМакетов = ОбменДаннымиПовтИсп.ПолучитьСписокТиповыхПравилРегистрации(Запись.ИмяПланаОбмена);
		
	КонецЕсли;
	
	СписокВыбора = Элементы.ИмяМакетаПравил.СписокВыбора;
	СписокВыбора.Очистить();
	
	ЗаполнитьСписок(СписокМакетов, СписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписок(СписокИсточник, СписокПриемник)
	
	Для Каждого Элемент ИЗ СписокИсточник Цикл
		
		ЗаполнитьЗначенияСвойств(СписокПриемник.Добавить(), Элемент);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	// если план обмена был ранее задан, то изменять его не даем
	Элементы.ГруппаПланаОбмена.Видимость = ПустаяСтрока(Запись.ИмяПланаОбмена);
	
	ГруппаИсточникиПравил = Элементы.ГруппаИсточникиПравил;
	
	ГруппаИсточникиПравил.ТекущаяСтраница = ?(ИсточникПравил = 0,
											ГруппаИсточникиПравил.ПодчиненныеЭлементы.ИсточникМакетКонфигурации,
											ГруппаИсточникиПравил.ПодчиненныеЭлементы.ИсточникФайл);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПравилаНаСервере(Отказ, АдресВременногоХранилища, ИмяФайлаПравил, ЭтоАрхив)
	
	Запись.ИсточникПравил = ?(ИсточникПравил = 0, Перечисления.ИсточникиПравилДляОбменаДанными.МакетКонфигурации, Перечисления.ИсточникиПравилДляОбменаДанными.Файл);
	
	Объект = РеквизитФормыВЗначение("Запись");
	
	РегистрыСведений.ПравилаДляОбменаДанными.ЗагрузитьПравила(Отказ, Объект, АдресВременногоХранилища, ИмяФайлаПравил, ЭтоАрхив);
	
	Если Не Отказ Тогда
		
		Объект.Записать();
		
		Модифицированность = Ложь;
		
		// кеш открытых сеансов для механизма регистрации стал неактуальным
		ОбменДаннымиВызовСервера.СброситьКэшМеханизмаРегистрацииОбъектов();
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Объект, "Запись");
	
	ОбновитьИнформациюОПравилах();
	УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНавигационнуюСсылкуНаСервере()
	
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяПланаОбмена", Запись.ИмяПланаОбмена);
	Отбор.Вставить("ВидПравил",      Запись.ВидПравил);
	
	КлючЗаписи = РегистрыСведений.ПравилаДляОбменаДанными.СоздатьКлючЗаписи(Отбор);
	
	Возврат ПолучитьНавигационнуюСсылку(КлючЗаписи, "ПравилаXML");
	
КонецФункции

&НаСервере
Функция ПолучитьАдресВременногоХранилищаАрхиваПравилНаСервере(ИмяФайла)
	
	// Создаем временный каталог на сервере и формируем пути к файлам и папкам
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла("");
	СоздатьКаталог(ИмяВременнойПапки);
	ПутьКФайлу = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + ИмяФайла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПравилаДляОбменаДанными.ПравилаXML
	|ИЗ
	|	РегистрСведений.ПравилаДляОбменаДанными КАК ПравилаДляОбменаДанными
	|ГДЕ
	|	ПравилаДляОбменаДанными.ИмяПланаОбмена = &ИмяПланаОбмена
	|	И ПравилаДляОбменаДанными.ВидПравил = &ВидПравил";
	Запрос.УстановитьПараметр("ИмяПланаОбмена", Запись.ИмяПланаОбмена); 
	Запрос.УстановитьПараметр("ВидПравил", Запись.ВидПравил);	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		
		НСтрока = НСтр("ru = 'Не удалось получить правила обмена.'");
		ОбменДаннымиСервер.СообщитьОбОшибке(НСтрока);
		Возврат "";
		
	Иначе
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		// Получаем, сохраняем и архивируем файл правил во временном каталоге
		ДвоичныеДанныеПравил = Выборка.ПравилаXML.Получить();
		ДвоичныеДанныеПравил.Записать(ПутьКФайлу + ".xml");
		ОбменДаннымиСервер.ЗапаковатьВZipФайл(ПутьКФайлу + ".zip", ПутьКФайлу + ".xml");
		
		// Помещаем архив правил в хранилище
		ДвоичныеДанныеАрхиваПравил = Новый ДвоичныеДанные(ПутьКФайлу + ".zip");
		АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанныеАрхиваПравил);
		Возврат АдресВременногоХранилища;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОбновитьИнформациюОПравилах()
	
	Если Запись.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.Файл Тогда
		
		ИнформацияОПравилах = НСтр("ru = 'Использование правил, загруженных из файла,
									|может привести к ошибкам при переходе на новую версию программы.
									|
									|[ИнформацияОПравилах]'");
		
		ИнформацияОПравилах = СтрЗаменить(ИнформацияОПравилах, "[ИнформацияОПравилах]", Запись.ИнформацияОПравилах);
		
	Иначе
		
		ИнформацияОПравилах = Запись.ИнформацияОПравилах;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИсточникПравил()
	
	ИсточникПравил = ?(Запись.ИсточникПравил = Перечисления.ИсточникиПравилДляОбменаДанными.МакетКонфигурации, 0, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуПравил(Знач АдресПомещенногоФайла, Знач ИмяФайла, Знач ЭтоАрхив)
	Отказ = Ложь;
	
	Состояние(НСтр("ru = 'Выполняется загрузка правил в информационную базу...'"));
	ЗагрузитьПравилаНаСервере(Отказ, АдресПомещенногоФайла, ИмяФайла, ЭтоАрхив);
	Состояние();
	
	Если Не Отказ Тогда
		ПоказатьОповещениеПользователя(,, НСтр("ru = 'Правила успешно загружены в информационную базу.'"));
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = НСтр("ru = 'В процессе загрузки правил были обнаружены ошибки.
	                         |Перейти в журнал регистрации?'");
	
	Оповещение = Новый ОписаниеОповещения("ПоказатьЖурналРегистрацииПриОшибке", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстОшибки, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет);
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПравилаЗавершение(Знач ВыбранныйЭлемент, Знач ДополнительныеПараметры) Экспорт
	Если ВыбранныйЭлемент = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЧастиИмени = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(Запись.ИмяФайлаПравил);
	
	Если ВыбранныйЭлемент.Значение Тогда
		// Выгружаем как архив
		АдресХранения = ПолучитьАдресВременногоХранилищаАрхиваПравилНаСервере(ЧастиИмени.ИмяБезРасширения);
		ФильтрИмени   = НСтр("ru = 'Архивы ZIP (*.zip)'") + "|*.zip";
	Иначе
		АдресХранения = ПолучитьНавигационнуюСсылкуНаСервере();
		ФильтрИмени = НСтр("ru = 'Файлы правил (*.xml)'") + "|*.xml";
	КонецЕсли;
	
	Если ПустаяСтрока(АдресХранения) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ЧастиИмени.ИмяБезРасширения) Тогда
		ПолноеИмяФайла = НСтр("ru = 'Правила для обмена данными'");
	Иначе
		ПолноеИмяФайла = ЧастиИмени.ИмяБезРасширения;
	КонецЕсли;
	
	ПараметрыДиалога = Новый Структура;
	ПараметрыДиалога.Вставить("Режим", РежимДиалогаВыбораФайла.Сохранение);
	ПараметрыДиалога.Вставить("Заголовок", НСтр("ru = 'Укажите в какой файл выгрузить правила'") );
	ПараметрыДиалога.Вставить("ПолноеИмяФайла", ПолноеИмяФайла);
	ПараметрыДиалога.Вставить("Фильтр", ФильтрИмени);
	
	ПолучаемыйФайл = Новый Структура("Имя, Хранение", ПолноеИмяФайла, АдресХранения);
	
	ОбменДаннымиКлиент.ВыбратьИСохранитьФайлНаКлиенте(ПолучаемыйФайл, ПараметрыДиалога);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПравилаЗавершение(Знач РезультатПомещенияФайлов, Знач ДополнительныеПараметры) Экспорт
	
	АдресПомещенногоФайла = РезультатПомещенияФайлов.Хранение;
	ТекстОшибки           = РезультатПомещенияФайлов.ОписаниеОшибки;
	
	Если ПустаяСтрока(ТекстОшибки) И ПустаяСтрока(АдресПомещенногоФайла) Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка передачи файла настроек синхронизации данных на сервер'");
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
		
	// Успешно передали файл, загружаем на сервере
	ЧастиИмени = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(РезультатПомещенияФайлов.Имя);
	
	ВыполнитьЗагрузкуПравил(АдресПомещенногоФайла, ЧастиИмени.Имя, НРег(ЧастиИмени.Расширение) = ".zip");
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВнешнийРесурсЗавершение(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ВнешниеРесурсыРазрешены = Истина;
		Записать(ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьЗапросНаИспользованиеВнешнихРесурсов(Знач Запись)
	
	ЗапросыРазрешений = Новый Массив;
	РегистрыСведений.ПравилаДляОбменаДанными.ЗапросНаИспользованиеВнешнихРесурсов(ЗапросыРазрешений, Запись);
	Возврат ЗапросыРазрешений;
	
КонецФункции

#КонецОбласти
