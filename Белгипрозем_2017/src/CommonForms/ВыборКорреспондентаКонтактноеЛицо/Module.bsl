//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Режим = "ТолькоКорреспонденты" Тогда 	
		ЭтаФорма.Заголовок = НСтр("ru = 'Выбор корреспондента'");
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
        Элементы.СписокКонтактныеЛица.Видимость = Ложь;
		ПоискТолькоКорреспондентов = Истина;
	ИначеЕсли Параметры.Режим = "КорреспондентыКонтактныеЛица" Тогда 	
		ЭтаФорма.Заголовок = НСтр("ru = 'Выбор корреспондента и контактного лица'");
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	Иначе
		ЭтаФорма.Заголовок = НСтр("ru = 'Выбор получателя'");
	КонецЕсли;	
	
	Если Параметры.Свойство("ЮрФизЛицо") И ЗначениеЗаполнено(Параметры.ЮрФизЛицо) Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокКорреспонденты.Отбор,
			"ЮрФизЛицо", Параметры.ЮрФизЛицо);
	КонецЕсли;	
	
	Получатель = Параметры.Получатель;
	
	Если ЗначениеЗаполнено(Получатель) Тогда
		Если ТипЗнч(Параметры.Получатель) = Тип("СправочникСсылка.КонтактныеЛица") Тогда 
			Элементы.СписокКорреспонденты.ТекущаяСтрока = Параметры.Получатель.Владелец;
			Элементы.СписокКонтактныеЛица.ТекущаяСтрока = Параметры.Получатель;
		ИначеЕсли ТипЗнч(Параметры.Получатель) = Тип("СправочникСсылка.Корреспонденты") Тогда 
			Элементы.СписокКорреспонденты.ТекущаяСтрока = Получатель;
      	ИначеЕсли ТипЗнч(Получатель) = Тип("СправочникСсылка.СпискиРассылкиПоКорреспондентам") Тогда
		    Элементы.Страницы.ТекущаяСтраница = Элементы.СпискиРассылки;
			Элементы.СписокСпискиРассылки.ТекущаяСтрока = Получатель;
		КонецЕсли;	
	КонецЕсли;	
	
	СписокКонтактныеЛица.Параметры.УстановитьЗначениеПараметра("Корреспондент", 
		Элементы.СписокКорреспонденты.ТекущаяСтрока);
	СохранениеВводимыхЗначений.ЗагрузитьСписокВыбора(ЭтаФорма, "СтрокаПоиска");
	
	Параметры.Свойство("СтрокаПоиска", СтрокаПоиска);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// Работа с поиском

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)

	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		
		СтрокаПоиска = СокрЛП(СтрокаПоиска);
	
		Если СтрДлина(СтрокаПоиска) < 3 И СтрокаПоиска <> "*" И СтрокаПоиска <> "**" Тогда			
			ЭтаФорма.ТекущийЭлемент = Элементы.СтрокаПоиска;
			ЭтаФорма.Активизировать();
			ПоказатьПредупреждение(, НСтр("ru = 'Необходимо ввести минимум 3 символа'"));
			Возврат;
		КонецЕсли;
	    	
		СохранениеВводимыхЗначенийКлиент.ОбновитьСписокВыбора(ЭтаФорма, "СтрокаПоиска", 10);

		ПустойРезультатПоиска = Ложь;
		НайтиКорреспондентовИКонтактныеЛица();
		ПустойРезультатПоиска = ДеревоКорреспондентов.ПолучитьЭлементы().Количество() = 0;
		
		Если ПустойРезультатПоиска Тогда
			ТекущийЭлемент = Элементы.СтрокаПоиска;
			УстановитьВидимостьРезультатаПоискаКорреспондентов(Ложь);
			ПоказатьПредупреждение(, НСтр("ru = 'По вашему запросу ничего не найдено'"));
		Иначе
			ТекущийЭлемент = Элементы.ДеревоКорреспондентов;
			УстановитьВидимостьРезультатаПоискаКорреспондентов(Истина);		
			РазвернутьДерево("ДеревоКорреспондентов");	
		КонецЕсли;
		
		ПоискВключен = Истина;
	Иначе
		Если ПоискВключен Тогда
			ОчиститьПоиск();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОчистка(Элемент, СтандартнаяОбработка)
	
	СтрокаПоиска = Неопределено;
	ОчиститьПоиск();
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ КОРРЕСПОНДЕНТЫ

&НаКлиенте
Процедура СписокКорреспондентыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОповеститьОВыборе(Новый Структура(
				"Корреспондент, КонтактноеЛицо", Элементы.СписокКорреспонденты.ТекущаяСтрока, Неопределено));

КонецПроцедуры

&НаКлиенте
Процедура СписокКорреспондентыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжиданияКонтактныеЛица", 0.2, Истина);

КонецПроцедуры

&НаКлиенте
Процедура СписокКорреспондентыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Новый Структура(
				"Корреспондент, КонтактноеЛицо", Элементы.СписокКорреспонденты.ТекущаяСтрока, Неопределено));
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДЕРЕВО КОРРЕСПОНДЕНТОВ

&НаКлиенте
Процедура ДеревоКорреспондентовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоКорреспондентов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	

	Если ТекущиеДанные.ЭтоКонтактноеЛицо Тогда
		Корреспондент = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекущиеДанные.Ссылка, "Владелец");
		ОповеститьОВыборе(Новый Структура(
						"Корреспондент, КонтактноеЛицо", Корреспондент, ТекущиеДанные.Ссылка));
	Иначе					
		ОповеститьОВыборе(Новый Структура(
					"Корреспондент, КонтактноеЛицо", ТекущиеДанные.Ссылка, Неопределено));
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ДеревоКорреспондентовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	Возврат;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоКорреспондентовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ТекущиеДанные = Элементы.ДеревоКорреспондентов.ТекущиеДанные;

	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.Ссылка);
		
		Если ТекущиеДанные.ЭтоКонтактноеЛицо Тогда					
			ОткрытьФорму("Справочник.КонтактныеЛица.Форма.ФормаЭлемента", ПараметрыФормы,,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);		
		Иначе			
			ОткрытьФорму("Справочник.Корреспонденты.Форма.ФормаЭлемента", ПараметрыФормы,,,,,,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;		
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ДеревоКорреспондентовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	Возврат;

КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ КОНТАКТНЫЕ ЛИЦА

&НаКлиенте
Процедура СписокКонтактныеЛицаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	//МиСофт+
	Корреспондент = ?(Элементы.СтраницыКорреспондентов.ТекущаяСтраница = Элементы.СтраницаСписки,
		Элементы.СписокКорреспонденты.ТекущаяСтрока,
		?(Элементы.ДеревоКорреспондентов.ТекущиеДанные = Неопределено, Неопределено, Элементы.ДеревоКорреспондентов.ТекущиеДанные.Ссылка));
	ОповеститьОВыборе(Новый Структура(
				"Корреспондент, КонтактноеЛицо", Корреспондент, Значение));
	//МиСофт-				
		
КонецПроцедуры

&НаКлиенте
Процедура СписокКонтактныеЛицаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда 
		Возврат;
	КонецЕсли;	
	
	Владелец = Элементы.СписокКорреспонденты.ТекущаяСтрока;
	
	Если Не ЗначениеЗаполнено(Владелец) Тогда 
		Возврат;
	КонецЕсли;	
	
	Отказ = Истина;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Владелец", Владелец);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
	ОткрытьФорму("Справочник.КонтактныеЛица.ФормаОбъекта", ПараметрыФормы, Элемент);	
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СПИСКИ РАССЫЛКИ

&НаКлиенте
Процедура СписокСпискиРассылкиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Корреспонденты Тогда
		
		Если ПоискВключен Тогда
			ТекущиеДанные = Элементы.ДеревоКорреспондентов.ТекущиеДанные;
		
			Если ТекущиеДанные = Неопределено Тогда 
				Возврат;
			КонецЕсли;	
			
			Если ТекущиеДанные.ЭтоКонтактноеЛицо Тогда
				Корреспондент = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекущиеДанные.Ссылка, "Владелец");
				ОповеститьОВыборе(Новый Структура(
								"Корреспондент, КонтактноеЛицо", Корреспондент, ТекущиеДанные.Ссылка));
			Иначе					
				ОповеститьОВыборе(Новый Структура(
							"Корреспондент, КонтактноеЛицо", ТекущиеДанные.Ссылка, Неопределено));
			КонецЕсли;			
		ИначеЕсли Элементы.СписокКонтактныеЛица.ТекущаяСтрока <> Неопределено Тогда 
			ОповеститьОВыборе(Новый Структура(
						"Корреспондент, КонтактноеЛицо", Элементы.СписокКорреспонденты.ТекущаяСтрока, Элементы.СписокКонтактныеЛица.ТекущаяСтрока));
		ИначеЕсли Элементы.СписокКорреспонденты.ТекущаяСтрока <> Неопределено Тогда 
			ОповеститьОВыборе(Новый Структура(
						"Корреспондент, КонтактноеЛицо", Элементы.СписокКорреспонденты.ТекущаяСтрока, Неопределено));				
        КонецЕсли;
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СпискиРассылки Тогда 
		Если Элементы.СписокСпискиРассылки.ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли;	
		
		ОповеститьОВыборе(Элементы.СписокСпискиРассылки.ТекущаяСтрока);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИсторию(Команда)
	
	СохранениеВводимыхЗначенийКлиент.ОчиститьСписокВыбора(ЭтаФорма, "СтрокаПоиска");

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработкаОжиданияКонтактныеЛица()
	
	//МиСофт+
	Корреспондент = ?(Элементы.СтраницыКорреспондентов.ТекущаяСтраница = Элементы.СтраницаСписки, 
		Элементы.СписокКорреспонденты.ТекущаяСтрока, 
		?(Элементы.ДеревоКорреспондентов.ТекущиеДанные = Неопределено, Неопределено, Элементы.ДеревоКорреспондентов.ТекущиеДанные.Ссылка)); 
	Если Корреспондент <> Неопределено Тогда 
		СписокКонтактныеЛица.Параметры.УстановитьЗначениеПараметра("Корреспондент", Корреспондент);
	КонецЕсли;	
	//МиСофт-
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево(ИмяРеквизитаДерева)
		
	Для каждого СтрокаДерева Из ЭтаФорма[ИмяРеквизитаДерева].ПолучитьЭлементы() Цикл
		Элементы[ИмяРеквизитаДерева].Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;                                                                               	
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с расширенным поиском корреспондентов и контактных лиц

&НаСервере
Функция ПолучитьТекстЗапросаДляПоискаКорреспондентовИКонтактныхЛиц() 
	
	Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КорреспондентыКонтактнаяИнформация.Ссылка КАК ВладелецОбъекта,
		|	КорреспондентыКонтактнаяИнформация.Ссылка КАК ОбъектПоиска,
		|	КорреспондентыКонтактнаяИнформация.Представление КАК ЗначениеПоиска,
		|	КорреспондентыКонтактнаяИнформация.Ссылка.Наименование КАК НаименованиеВладельца,
		|	КорреспондентыКонтактнаяИнформация.Ссылка.Наименование КАК НаименованиеОбъекта
		|ИЗ
		|	Справочник.Корреспонденты.КонтактнаяИнформация КАК КорреспондентыКонтактнаяИнформация
		|ГДЕ
		|	НЕ КорреспондентыКонтактнаяИнформация.Ссылка.ЭтоГруппа
		|	И НЕ КорреспондентыКонтактнаяИнформация.Ссылка.ПометкаУдаления
		|	И КорреспондентыКонтактнаяИнформация.Представление ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Корреспонденты.Ссылка,
		|	Корреспонденты.Ссылка,
		|	Корреспонденты.Наименование + ""~"" + Корреспонденты.ИНН + ""~"" + Корреспонденты.КПП + ""~"" + Корреспонденты.КодПоОКПО,
		|	Корреспонденты.Наименование,
		|	Корреспонденты.Наименование
		|ИЗ
		|	Справочник.Корреспонденты КАК Корреспонденты
		|ГДЕ
		|	НЕ Корреспонденты.ЭтоГруппа
		|	И НЕ Корреспонденты.ПометкаУдаления
		|	И Корреспонденты.Наименование + ""~"" + Корреспонденты.ИНН + ""~"" + Корреспонденты.КПП + ""~"" + Корреспонденты.КодПоОКПО ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Корреспонденты.Ссылка,
		|	Корреспонденты.Ссылка,
		|	ВЫРАЗИТЬ(Корреспонденты.ПолноеНаименование КАК СТРОКА(1000)),
		|	Корреспонденты.Наименование,
		|	Корреспонденты.Наименование
		|ИЗ
		|	Справочник.Корреспонденты КАК Корреспонденты
		|ГДЕ
		|	НЕ Корреспонденты.ЭтоГруппа
		|	И НЕ Корреспонденты.ПометкаУдаления
		|	И Корреспонденты.ПолноеНаименование ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Корреспонденты.Ссылка,
		|	КонтактныеЛицаКонтактнаяИнформация.Ссылка,
		|	КонтактныеЛицаКонтактнаяИнформация.Представление,
		|	Корреспонденты.Наименование,
		|	КонтактныеЛицаКонтактнаяИнформация.Ссылка.Наименование
		|ИЗ
		|	Справочник.КонтактныеЛица.КонтактнаяИнформация КАК КонтактныеЛицаКонтактнаяИнформация
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Корреспонденты КАК Корреспонденты
		|		ПО КонтактныеЛицаКонтактнаяИнформация.Ссылка.Владелец = Корреспонденты.Ссылка
		|ГДЕ
		|	НЕ Корреспонденты.ЭтоГруппа
		|	И НЕ Корреспонденты.ПометкаУдаления
		|	И КонтактныеЛицаКонтактнаяИнформация.Представление ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Корреспонденты.Ссылка,
		|	КонтактныеЛица.Ссылка,
		|	КонтактныеЛица.Наименование,
		|	Корреспонденты.Наименование,
		|	КонтактныеЛица.Наименование
		|ИЗ
		|	Справочник.КонтактныеЛица КАК КонтактныеЛица
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Корреспонденты КАК Корреспонденты
		|		ПО КонтактныеЛица.Владелец = Корреспонденты.Ссылка
		|ГДЕ
		|	КонтактныеЛица.ПометкаУдаления = ЛОЖЬ
		|	И Корреспонденты.ПометкаУдаления = ЛОЖЬ
		|	И КонтактныеЛица.Наименование ПОДОБНО &СтрокаПоиска
		|
		|УПОРЯДОЧИТЬ ПО
		|	НаименованиеВладельца,
		|	НаименованиеОбъекта
		|ИТОГИ ПО
		|	ВладелецОбъекта";

	Возврат Текст;

КонецФункции

&НаСервере
Функция ПолучитьТекстЗапросаДляПоискаКорреспондентов() 
	
	Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КорреспондентыКонтактнаяИнформация.Ссылка КАК ВладелецОбъекта,
		|	КорреспондентыКонтактнаяИнформация.Ссылка КАК ОбъектПоиска,
		|	КорреспондентыКонтактнаяИнформация.Представление КАК ЗначениеПоиска,
		|	КорреспондентыКонтактнаяИнформация.Ссылка.Наименование КАК НаименованиеВладельца,
		|	КорреспондентыКонтактнаяИнформация.Ссылка.Наименование КАК НаименованиеОбъекта
		|ИЗ
		|	Справочник.Корреспонденты.КонтактнаяИнформация КАК КорреспондентыКонтактнаяИнформация
		|ГДЕ
		|	НЕ КорреспондентыКонтактнаяИнформация.Ссылка.ЭтоГруппа
		|	И НЕ КорреспондентыКонтактнаяИнформация.Ссылка.ПометкаУдаления
		//|	И КорреспондентыКонтактнаяИнформация.Ссылка.ЮрФизЛицо = &ФизЛицо
		|	И КорреспондентыКонтактнаяИнформация.Представление ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Корреспонденты.Ссылка,
		|	Корреспонденты.Ссылка,
		|	ПОДСТРОКА(Корреспонденты.ПолноеНаименование, 0, 1000),
		|	Корреспонденты.Наименование,
		|	Корреспонденты.Наименование
		|ИЗ
		|	Справочник.Корреспонденты КАК Корреспонденты
		|ГДЕ
		|	НЕ Корреспонденты.ЭтоГруппа
		|	И НЕ Корреспонденты.ПометкаУдаления
		//|	И Корреспонденты.ЮрФизЛицо = &ФизЛицо
		|	И Корреспонденты.ПолноеНаименование ПОДОБНО &СтрокаПоиска
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Корреспонденты.Ссылка,
		|	Корреспонденты.Ссылка,
		|	Корреспонденты.Наименование + ""~"" + Корреспонденты.ИНН + ""~"" + Корреспонденты.КПП + ""~"" + Корреспонденты.КодПоОКПО,
		|	Корреспонденты.Наименование,
		|	Корреспонденты.Наименование
		|ИЗ
		|	Справочник.Корреспонденты КАК Корреспонденты
		|ГДЕ
		|	НЕ Корреспонденты.ЭтоГруппа
		|	И НЕ Корреспонденты.ПометкаУдаления
		//|	И Корреспонденты.ЮрФизЛицо = &ФизЛицо
		|	И Корреспонденты.Наименование + ""~"" + Корреспонденты.ИНН + ""~"" + Корреспонденты.КПП + ""~"" + Корреспонденты.КодПоОКПО ПОДОБНО &СтрокаПоиска
		|
		|УПОРЯДОЧИТЬ ПО
		|	НаименованиеВладельца,
		|	НаименованиеОбъекта
		|ИТОГИ ПО
		|	ВладелецОбъекта";
		
	Возврат Текст;

КонецФункции

&НаСервере
Процедура НайтиКорреспондентовИКонтактныеЛица()
	
	Запрос = Новый Запрос;
	
	Если ПоискТолькоКорреспондентов Тогда
		Запрос.Текст = ПолучитьТекстЗапросаДляПоискаКорреспондентов();
		//Запрос.Параметры.Вставить("ФизЛицо", Перечисления.ЮрФизЛицо.ФизЛицо);
	Иначе
		Запрос.Текст = ПолучитьТекстЗапросаДляПоискаКорреспондентовИКонтактныхЛиц();
	КонецЕсли;
	
	Запрос.УстановитьПараметр("СтрокаПоиска", "%" + СтрокаПоиска + "%");
	
	Результат = Запрос.Выполнить();

	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	КореньДерева = ДеревоКорреспондентов.ПолучитьЭлементы();
	КореньДерева.Очистить();
	
	Пока Выборка.Следующий() Цикл
		
		Если Не Элементы.ДеревоКорреспондентов.Видимость Тогда 
			Элементы.ДеревоКорреспондентов.Видимость = Истина;
		КонецЕсли;	
		
		НовыйКорреспондент = КореньДерева.Добавить();
		НовыйКорреспондент.Наименование = Выборка.НаименованиеВладельца;
		НовыйКорреспондент.Ссылка = Выборка.ВладелецОбъекта;
		НовыйКорреспондент.НомерКартинки = 4;
		НовыйКорреспондент.ПочтовыйАдрес=ВернутьАдресКорреспондента(Выборка.ВладелецОбъекта);
		
		ВыборкаПоКонтактнымЛицам = Выборка.Выбрать();
		Пока ВыборкаПоКонтактнымЛицам.Следующий() Цикл
			
			ТипОбъекта = ТипЗнч(ВыборкаПоКонтактнымЛицам.ОбъектПоиска);
			Если ТипОбъекта <> Тип("СправочникСсылка.КонтактныеЛица") Тогда
				Продолжить;
			КонецЕсли;
			
			НовоеКонтактноеЛицо = НовыйКорреспондент.ПолучитьЭлементы().Добавить();
			НовоеКонтактноеЛицо.Наименование = ВыборкаПоКонтактнымЛицам.НаименованиеОбъекта;
			НовоеКонтактноеЛицо.Ссылка = ВыборкаПоКонтактнымЛицам.ОбъектПоиска;
			НовоеКонтактноеЛицо.ЭтоКонтактноеЛицо = Истина;
			НовоеКонтактноеЛицо.НомерКартинки = 3;
		
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьРезультатаПоискаКорреспондентов(Видимость);
	
	Если Видимость Тогда	
		Элементы.СтраницыКорреспондентов.ТекущаяСтраница = Элементы.СтраницаДерево;
	Иначе
		Элементы.СтраницыКорреспондентов.ТекущаяСтраница = Элементы.СтраницаСписки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПоиск()

	ПоискВключен = Ложь;
    УстановитьВидимостьРезультатаПоискаКорреспондентов(ПоискВключен);
	
КонецПроцедуры

//МиСофт
&НаКлиенте
Процедура ДеревоКорреспондентовПриАктивизацииСтроки(Элемент)
	//МиСофт+
	ПодключитьОбработчикОжидания("ОбработкаОжиданияКонтактныеЛица", 0.2, Истина);
	//МиСофт-
КонецПроцедуры

Функция ВернутьАдресКорреспондента(Наименование)
	Запрос=Новый Запрос();
	
	Запрос.Текст="ВЫБРАТЬ
	|        	МАКСИМУМ(ВЫБОР
	|			КОГДА Корреспонденты.Ссылка.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)
	|				ТОГДА КонтактнаяИнформацияАдресФизЛица.Представление
	|			ИНАЧЕ КонтактнаяИнформацияПочтовыйАдрес.Представление
	|				КОНЕЦ) КАК ПочтовыйАдрес
	|      ИЗ
	|     	Справочник.Корреспонденты КАК Корреспонденты				
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Корреспонденты.КонтактнаяИнформация КАК КонтактнаяИнформацияПочтовыйАдрес
	|		ПО Корреспонденты.Ссылка = КонтактнаяИнформацияПочтовыйАдрес.Ссылка
	|		И (КонтактнаяИнформацияПочтовыйАдрес.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ПочтовыйАдресКорреспондента))
	|				
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК КонтактнаяИнформацияАдресФизЛица
	|		ПО Корреспонденты.Физлицо = КонтактнаяИнформацияАдресФизЛица.ссылка
	|		И (КонтактнаяИнформацияАдресФизЛица.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ДомашнийАдресФизическогоЛица))
	|	ГДЕ
	|       	Корреспонденты.Ссылка= &Наименование  ";
	Запрос.УстановитьПараметр("Наименование",Наименование);
	Результат=Запрос.Выполнить().Выгрузить();
	возврат Результат.ВыгрузитьКолонку("ПочтовыйАдрес")[0];	
КонецФункции	


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СтрокаПоискаПриИзменении("");
КонецПроцедуры

