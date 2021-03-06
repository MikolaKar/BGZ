&НаКлиенте
Перем ИтерацияПроверки;
&НаКлиенте
Перем АдресХранилища;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ХранилищеРезультатаОбработкиЗапросов = Параметры.ХранилищеРезультатаОбработкиЗапросов;
	РезультатОбработкиЗапросов = ПолучитьИзВременногоХранилища(ХранилищеРезультатаОбработкиЗапросов);
	АдресХранилищаНаСервере = ПоместитьВоВременноеХранилище(РезультатОбработкиЗапросов, ЭтаФорма.УникальныйИдентификатор);
	
	РежимВосстановления = Параметры.РежимВосстановления ИЛИ Параметры.РежимВосстановленияПослеПредоставленияРазрешений;
	
	Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") И Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Получить() Тогда
		Если Параметры.РежимВосстановленияПослеПредоставленияРазрешений Тогда
			Элементы.ГруппаШапка.Видимость = Ложь;
			Элементы.ГруппаШапкаРежимВосстановления.Видимость = Ложь;
			Элементы.ГруппаШапкаРежимВосстановленияПослеПредоставленияРазрешений.Видимость = Истина;
		ИначеЕсли Параметры.РежимВосстановления Тогда
			Элементы.ГруппаШапка.Видимость = Ложь;
			Элементы.ГруппаШапкаРежимВосстановления.Видимость = Истина;
			Элементы.ГруппаШапкаРежимВосстановленияПослеПредоставленияРазрешений.Видимость = Ложь;
		Иначе
			Элементы.ГруппаШапка.Видимость = Истина;
			Элементы.ГруппаШапкаРежимВосстановления.Видимость = Ложь;
			Элементы.ГруппаШапкаРежимВосстановленияПослеПредоставленияРазрешений.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ГруппаШапка.Видимость = Ложь;
		Элементы.ГруппаШапкаРежимВосстановления.Видимость = Ложь;
		Элементы.ГруппаШапкаРежимВосстановленияПослеПредоставленияРазрешений.Видимость = Ложь;
	КонецЕсли;
	
	СценарийПримененияЗапросов = РезультатОбработкиЗапросов.Сценарий;
	
	Если СценарийПримененияЗапросов.Количество() = 0 Тогда
		ТребуетсяВнесениеИзмененийВПрофиляхБезопасности = Ложь;
		Возврат;
	КонецЕсли;
	
	ПредставлениеРазрешений = РезультатОбработкиЗапросов.Представление;
	
	ТребуетсяВнесениеИзмененийВПрофиляхБезопасности = Истина;
	ТребуютсяПараметрыАдминистрированияИнформационнойБазы = Ложь;
	Для Каждого ШагСценария Из СценарийПримененияЗапросов Цикл
		Если ШагСценария.Операция = Перечисления.ОперацииСНаборамиРазрешений.Назначение
				Или ШагСценария.Операция = Перечисления.ОперацииСНаборамиРазрешений.УдалениеНазначения Тогда
			ТребуютсяПараметрыАдминистрированияИнформационнойБазы = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыАдминистрирования = СтандартныеПодсистемыСервер.ПараметрыАдминистрирования();
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы);
		Если ПользовательИБ <> Неопределено Тогда
			ИдентификаторАдминистратораИБ = ПользовательИБ.УникальныйИдентификатор;
		КонецЕсли;
		
	КонецЕсли;
	
	ТипПодключения = ПараметрыАдминистрирования.ТипПодключения;
	ПортКластераСерверов = ПараметрыАдминистрирования.ПортКластера;
	
	АдресАгентаСервера = ПараметрыАдминистрирования.АдресАгентаСервера;
	ПортАгентаСервера = ПараметрыАдминистрирования.ПортАгентаСервера;
	
	АдресСервераАдминистрирования = ПараметрыАдминистрирования.АдресСервераАдминистрирования;
	ПортСервераАдминистрирования = ПараметрыАдминистрирования.ПортСервераАдминистрирования;
	
	ИмяВКластере = ПараметрыАдминистрирования.ИмяВКластере;
	ИмяАдминистратораКластера = ПараметрыАдминистрирования.ИмяАдминистратораКластера;
	
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы);
	Если ПользовательИБ <> Неопределено Тогда
		ИдентификаторАдминистратораИБ = ПользовательИБ.УникальныйИдентификатор;
	КонецЕсли;
	
	Пользователи.НайтиНеоднозначныхПользователейИБ(, ИдентификаторАдминистратораИБ);
	АдминистраторИБ = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ИдентификаторАдминистратораИБ);
	
	Если Не ТребуютсяПараметрыАдминистрированияИнформационнойБазы Тогда
		
		Элементы.ГруппаАдминистрирование.Видимость = Ложь;
		Элементы.ГруппаПредупреждениеОНеобходимостиПерезапуска.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.ФормаРазрешить.Заголовок = НСтр("ru = 'Далее >'");
	Элементы.ФормаНазад.Видимость = Ложь;
	
	УправлениеВидимостью();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТребуетсяВнесениеИзмененийВПрофиляхБезопасности Тогда
		
		#Если ВебКлиент Тогда
			ВебКлиент = Истина;
			УправлениеВидимостью();
		#Иначе
			ВебКлиент = Ложь;
		#КонецЕсли
		
		АдресХранилища = АдресХранилищаНаСервере;
		
	Иначе
		
		Если Открыта() Тогда
			
			Закрыть(КодВозвратаДиалога.ОК);
			
		Иначе
			
			Если ОписаниеОповещенияОЗакрытии <> Неопределено Тогда
				
				ВыполнитьОбработкуОповещения(ОписаниеОповещенияОЗакрытии, КодВозвратаДиалога.ОК);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ТребуютсяПараметрыАдминистрированияИнформационнойБазы Тогда
		
		Если Не ЗначениеЗаполнено(АдминистраторИБ) Тогда
			Возврат;
		КонецЕсли;
		
		ИмяПоля = "АдминистраторИБ";
		ПользовательИБ = ПолучитьАдминистратораИБ();
		Если ПользовательИБ = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Указанный пользователь не имеет доступа к информационной базе.'"),,
				ИмяПоля,,Отказ);
			Возврат;
		КонецЕсли;
		
		Если Не Пользователи.ЭтоПолноправныйПользователь(ПользовательИБ, Истина) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'У пользователя нет административных прав.'"),,
				ИмяПоля,,Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПодключенияПриИзменении(Элемент)
	
	УправлениеВидимостью();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРазрешения Тогда
		
		ТекстОшибки = "";
		Элементы.ГруппаОшибка.Видимость = Ложь;
		Элементы.ФормаРазрешить.Заголовок = НСтр("ru = 'Настроить разрешения в кластере серверов'");
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПодключение;
		Элементы.ФормаНазад.Видимость = Истина;
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПодключение Тогда
		
		ТекстОшибки = "";
		Попытка
			
			ЗапланироватьПроверкуПримененияРазрешений();
			ПрименитьРазрешения();
			ЗавершитьПрименениеЗапросов(АдресХранилища);
			ОжидатьПримененияНастроекВКластере();
			
		Исключение
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке()); 
			Элементы.ГруппаОшибка.Видимость = Истина;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПодключение Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРазрешения;
		Элементы.ФормаНазад.Видимость = Ложь;
		Элементы.ФормаРазрешить.Заголовок = НСтр("ru = 'Далее >'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеререгистрироватьCOMСоединитель(Команда)
	
	ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеВидимостью()
	
	Если ТипПодключения = "COM" Тогда
		Элементы.СтраницыПараметрыПодключенияККластеруПоПротоколам.ТекущаяСтраница = Элементы.СтраницаПараметрыПодключенияККластеруCOM;
		ВидимостьГруппыОшибкиВерсииCOMСоединителя = Истина;
	Иначе
		Элементы.СтраницыПараметрыПодключенияККластеруПоПротоколам.ТекущаяСтраница = Элементы.СтраницаПараметрыПодключенияККластеруRAS;
		ВидимостьГруппыОшибкиВерсииCOMСоединителя = Ложь;
	КонецЕсли;
	
	Если ВебКлиент Тогда
		Элементы.ГруппаОшибкаВерсииCOMСоединителя.Видимость = Ложь;
	Иначе
		Элементы.ГруппаОшибкаВерсииCOMСоединителя.Видимость = ВидимостьГруппыОшибкиВерсииCOMСоединителя;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдминистратораИБ()
	
	Если Не ЗначениеЗаполнено(АдминистраторИБ) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
		АдминистраторИБ.ИдентификаторПользователяИБ);
	
КонецФункции

&НаСервереБезКонтекста
Функция ИмяПользователяИнформационнойБазы(Знач Пользователь)
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		
		ИдентификаторПользователяИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ИдентификаторПользователяИБ");
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);
		Возврат ПользовательИБ.Имя;
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ЗапланироватьПроверкуПримененияРазрешений()
	
	ДополнительныеПараметры = Новый Структура();
	Если ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма") Тогда
		ДополнительныеПараметры.Вставить("ОригинальноеОписаниеОповещенияОЗакрытии", ВладелецФормы.ОписаниеОповещенияОЗакрытии);
	Иначе
		ДополнительныеПараметры.Вставить("ОригинальноеОписаниеОповещенияОЗакрытии", Неопределено);
	КонецЕсли;
	ДополнительныеПараметры.Вставить("ИдентификаторыЗапросов", ИдентификаторыЗапросов(АдресХранилища));
	
	ОписаниеОповещенияПроверкиПримененияРазрешений = Новый ОписаниеОповещения(
		"ПроверкаПримененияЗапросовНаИспользованиеВнешнихРесурсов",
		РаботаВБезопасномРежимеКлиент,
		ДополнительныеПараметры);
	
	Если ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма") Тогда
		ВладелецФормы.ОписаниеОповещенияОЗакрытии = ОписаниеОповещенияПроверкиПримененияРазрешений;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьРазрешения()
	
	ПараметрыПрименения = НачатьПрименениеЗапросов(АдресХранилища);
	
	ВидыОпераций = ПараметрыПрименения.ВидыОпераций;
	Сценарий = ПараметрыПрименения.СценарийПримененияЗапросов;
	ТребуютсяПараметрыАдминистрированияИБ = ПараметрыПрименения.ТребуютсяПараметрыАдминистрированияИнформационнойБазы;
	
	ПараметрыАдминистрированияКластера = АдминистрированиеКластераКлиентСервер.ПараметрыАдминистрированияКластера();
	ПараметрыАдминистрированияКластера.ТипПодключения = ТипПодключения;
	ПараметрыАдминистрированияКластера.АдресАгентаСервера = АдресАгентаСервера;
	ПараметрыАдминистрированияКластера.ПортАгентаСервера = ПортАгентаСервера;
	ПараметрыАдминистрированияКластера.АдресСервераАдминистрирования = АдресСервераАдминистрирования;
	ПараметрыАдминистрированияКластера.ПортСервераАдминистрирования = ПортСервераАдминистрирования;
	ПараметрыАдминистрированияКластера.ПортКластера = ПортКластераСерверов;
	ПараметрыАдминистрированияКластера.ИмяАдминистратораКластера = ИмяАдминистратораКластера;
	ПараметрыАдминистрированияКластера.ПарольАдминистратораКластера = ПарольАдминистратораКластера;
	
	Если ТребуютсяПараметрыАдминистрированияИБ Тогда
		ПараметрыАдминистрированияИБ = АдминистрированиеКластераКлиентСервер.ПараметрыАдминистрированияИнформационнойБазыКластера();
		ПараметрыАдминистрированияИБ.ИмяВКластере = ИмяВКластере;
		ПараметрыАдминистрированияИБ.ИмяАдминистратораИнформационнойБазы = ИмяПользователяИнформационнойБазы(АдминистраторИБ);
		ПараметрыАдминистрированияИБ.ПарольАдминистратораИнформационнойБазы = ПарольАдминистратораИБ;
	Иначе
		ПараметрыАдминистрированияИБ = Неопределено;
	КонецЕсли;
	
	Если ТипПодключения = "COM" Тогда
		ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель(Ложь);
	КонецЕсли;
	
	АдминистрированиеКластераКлиентСервер.ПроверитьПараметрыАдминистрирования(
		ПараметрыАдминистрированияКластера,
		ПараметрыАдминистрированияИБ,
		Истина,
		ТребуютсяПараметрыАдминистрированияИБ);
	
	Для Каждого ЭлементСценария Из Сценарий Цикл
		
		Если ЭлементСценария.Операция = ВидыОпераций.Создание Тогда
			АдминистрированиеКластераКлиентСервер.СоздатьПрофильБезопасности(ПараметрыАдминистрированияКластера, ЭлементСценария.Разрешения);
		ИначеЕсли ЭлементСценария.Операция = ВидыОпераций.Назначение Тогда
			АдминистрированиеКластераКлиентСервер.УстановитьПрофильБезопасностиИнформационнойБазы(ПараметрыАдминистрированияКластера, ПараметрыАдминистрированияИБ, ЭлементСценария.Профиль);
		ИначеЕсли ЭлементСценария.Операция = ВидыОпераций.Обновление Тогда
			АдминистрированиеКластераКлиентСервер.УстановитьСвойстваПрофиляБезопасности(ПараметрыАдминистрированияКластера, ЭлементСценария.Разрешения);
		ИначеЕсли ЭлементСценария.Операция = ВидыОпераций.Удаление Тогда
			Если АдминистрированиеКластераКлиентСервер.ПрофильБезопасностиСуществует(ПараметрыАдминистрированияКластера, ЭлементСценария.Профиль) Тогда
				АдминистрированиеКластераКлиентСервер.УдалитьПрофильБезопасности(ПараметрыАдминистрированияКластера, ЭлементСценария.Профиль);
			КонецЕсли;
		ИначеЕсли ЭлементСценария.Операция = ВидыОпераций.УдалениеНазначения Тогда
			АдминистрированиеКластераКлиентСервер.УстановитьПрофильБезопасностиИнформационнойБазы(ПараметрыАдминистрированияКластера, ПараметрыАдминистрированияИБ, "");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИдентификаторыЗапросов(Знач АдресХранилища)
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Возврат Результат.ИдентификаторыЗапросов;
	
КонецФункции

&НаСервере
Функция НачатьПрименениеЗапросов(Знач АдресХранилища)
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	СценарийПримененияЗапросов = Результат.Сценарий;
	
	ВидыОпераций = Новый Структура();
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.ОперацииСНаборамиРазрешений.ЗначенияПеречисления Цикл
		ВидыОпераций.Вставить(ЗначениеПеречисления.Имя, Перечисления.ОперацииСНаборамиРазрешений[ЗначениеПеречисления.Имя]);
	КонецЦикла;
	
	Возврат Новый Структура("ВидыОпераций, СценарийПримененияЗапросов, ТребуютсяПараметрыАдминистрированияИнформационнойБазы",
		ВидыОпераций, СценарийПримененияЗапросов, ТребуютсяПараметрыАдминистрированияИнформационнойБазы);
	
КонецФункции

&НаСервере
Процедура ЗавершитьПрименениеЗапросов(Знач АдресХранилища)
	
	СохранитьПараметрыАдминистрирования();
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	РаботаВБезопасномРежимеСлужебный.ПослеОбработкиЗапросов(Результат.ИдентификаторыЗапросов, РежимВосстановления);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьПараметрыАдминистрирования()
	
	СохраняемыеПараметрыАдминистрирования = Новый Структура();
	
	// Параметры администрирования кластера
	СохраняемыеПараметрыАдминистрирования.Вставить("ТипПодключения", ТипПодключения);
	СохраняемыеПараметрыАдминистрирования.Вставить("АдресАгентаСервера", АдресАгентаСервера);
	СохраняемыеПараметрыАдминистрирования.Вставить("ПортАгентаСервера", ПортАгентаСервера);
	СохраняемыеПараметрыАдминистрирования.Вставить("АдресСервераАдминистрирования", АдресСервераАдминистрирования);
	СохраняемыеПараметрыАдминистрирования.Вставить("ПортСервераАдминистрирования", ПортСервераАдминистрирования);
	СохраняемыеПараметрыАдминистрирования.Вставить("ПортКластера", ПортКластераСерверов);
	СохраняемыеПараметрыАдминистрирования.Вставить("ИмяАдминистратораКластера", ИмяАдминистратораКластера);
	СохраняемыеПараметрыАдминистрирования.Вставить("ПарольАдминистратораКластера", "");
	
	// Параметры администрирования информационной базы
	СохраняемыеПараметрыАдминистрирования.Вставить("ИмяВКластере", ИмяВКластере);
	СохраняемыеПараметрыАдминистрирования.Вставить("ИмяАдминистратораИнформационнойБазы", ИмяПользователяИнформационнойБазы(АдминистраторИБ));
	СохраняемыеПараметрыАдминистрирования.Вставить("ПарольАдминистратораИнформационнойБазы", "");
	
	СтандартныеПодсистемыСервер.УстановитьПараметрыАдминистрирования(СохраняемыеПараметрыАдминистрирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьПримененияНастроекВКластере()
	
	ОписаниеОповещения = ЭтотОбъект.ОписаниеОповещенияОЗакрытии;
	ЭтотОбъект.ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ПослеЗакрытия", ЭтотОбъект, ОписаниеОповещения);
	
	Если Открыта() Тогда
		
		Закрыть();
		
	Иначе
		
		ПослеЗакрытия(, ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытия(РезультатЗакрытия, ОписаниеОповещения) Экспорт
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Длительность", РаботаВБезопасномРежимеКлиент.ДлительностьОжиданияПримененияИзменений());
	
	ОткрытьФорму(
		"Обработка.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.Форма.ЗавершениеЗапросаРазрешений",
		ПараметрыФормы,
		ЭтотОбъект.ВладелецФормы,
		,
		,
		,
		ОписаниеОповещения,
		ЭтотОбъект.РежимОткрытияОкна
	);
	
КонецПроцедуры

#КонецОбласти