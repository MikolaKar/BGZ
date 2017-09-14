
&НаКлиенте
Процедура ДобавитьКВыбранным(Команда)
	
	Если Элементы.ГруппаСпискиВыбора.ТекущаяСтраница = Элементы.ДинамическийСписок Тогда
		Для Каждого ВыделеннаяСтрока Из Элементы.ДинамическийСписокЭлементовДляВыбора.ВыделенныеСтроки Цикл
			ДанныеВыделеннойСтроки = Элементы.ДинамическийСписокЭлементовДляВыбора.Данныестроки(ВыделеннаяСтрока);
			ДобавитьДанныеСтрокиКСпискуВыбранных(ДанныеВыделеннойСтроки);
		КонецЦикла;
	Иначе
		Для Каждого ВыделеннаяСтрока Из Элементы.СписокЭлементовДляВыбора.ВыделенныеСтроки Цикл
			ДанныеВыделеннойСтроки = Элементы.СписокЭлементовДляВыбора.Данныестроки(ВыделеннаяСтрока);
			ДобавитьДанныеСтрокиКСпискуВыбранных(ДанныеВыделеннойСтроки);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзВыбранных(Команда)
	
	МассивСтрокДляУдаления = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.ВыбранныеЗначения.ВыделенныеСтроки Цикл
		МассивСтрокДляУдаления.Добавить(ВыбранныеЗначения.НайтиПоИдентификатору(ВыделеннаяСтрока));
	КонецЦикла;
	Для Каждого СтрокаДляУдаления Из МассивСтрокДляУдаления Цикл
		ВыбранныеЗначения.Удалить(СтрокаДляУдаления);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ДинамическийСписокЭлементовДляВыбора.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Доступные значения реквизита ""%1""'"), Параметры.ПредставлениеРеквизита);
	Элементы.СписокЭлементовДляВыбора.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Доступные значения реквизита ""%1""'"), Параметры.ПредставлениеРеквизита);
	Элементы.ВыбранныеЗначения.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выбранные значения реквизита ""%1""'"), Параметры.ПредставлениеРеквизита);
	Элементы.ДекорацияПояснение.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выберите значения для поиска по реквизиту ""%1"" из списка доступных значений реквизита.'"), 
		Параметры.ПредставлениеРеквизита);
	
	ЭтаФорма.Заголовок = Параметры.ПредставлениеРеквизита;
	
	НеЗаполнено = Параметры.НеЗаполнено;
	Элементы.Массив.Доступность = НЕ НеЗаполнено;
	
	Если Параметры.ТипЗначения.Типы().Количество() > 1 Тогда
		ТипЗначения = Параметры.ТипЗначения;
		ДеревоЭлементов = Новый ДеревоЗначений;
		ДеревоЭлементов = РеквизитФормыВЗначение("СписокЭлементовДляВыбора");
		Для Каждого Тип Из Параметры.ТипЗначения.Типы() Цикл
			ОбъектТипа = Новый(Тип);
			ИмяТипа = ОбъектТипа.Метаданные().Имя;
			
			Если Метаданные.Справочники.Найти(ИмяТипа) <> Неопределено
				И НЕ ПравоДоступа("Чтение", Метаданные.Справочники[ИмяТипа]) Тогда 
				Продолжить;
			КонецЕсли;
			Запрос = Новый Запрос;
			Если Метаданные.Справочники.Найти(ИмяТипа) <> Неопределено Тогда	
				Запрос.Текст = 
					"ВЫБРАТЬ РАЗРЕШЕННЫЕ
					|	СправочникВыбора.Ссылка
					|ИЗ
					|	Справочник." + ИмяТипа + " КАК СправочникВыбора";
				Если ИмяТипа = "ЗначенияСвойствОбъектов" Тогда
					// Для типа ЗначениеСвойствОбъектов дополнительно устанавливается фильтр по доп.реквизиту
					Запрос.Текст = Запрос.Текст
						+ " ГДЕ СправочникВыбора.Владелец В 
						|		(ВЫБРАТЬ
						|			ДополнительныеРеквизитыИСведения.Ссылка
						|		 ИЗ
						|			ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК ДополнительныеРеквизитыИСведения
						|		 ГДЕ
						|			ДополнительныеРеквизитыИСведения.Наименование = &Наименование)";
					Запрос.УстановитьПараметр("Наименование", Параметры.ПредставлениеРеквизита);
				КонецЕсли;
				Запрос.Текст = Запрос.Текст + 
					" УПОРЯДОЧИТЬ ПО СправочникВыбора.Наименование";
			ИначеЕсли Метаданные.Перечисления.Найти(ИмяТипа) <> Неопределено Тогда
				Запрос.Текст = 
					"ВЫБРАТЬ РАЗРЕШЕННЫЕ
					|	ПеречислениеВыбора.Ссылка
					|ИЗ
					|	Перечисление." + ИмяТипа + " КАК ПеречислениеВыбора";
			ИначеЕсли Метаданные.БизнесПроцессы.Найти(ИмяТипа) <> Неопределено Тогда
				Если ИмяТипа = "Поручение" Тогда
					Запрос.Текст = 
						"ВЫБРАТЬ РАЗРЕШЕННЫЕ
						|	ПоручениеВыбора.Ссылка
						|ИЗ
						|	БизнесПроцесс." + ИмяТипа + " КАК ПоручениеВыбора
						|ГДЕ
						|	ПоручениеВыбора.ВнешнееПоручение = Истина";
				Иначе
					Запрос.Текст = 
						"ВЫБРАТЬ РАЗРЕШЕННЫЕ
						|	ПроцессВыбора.Ссылка
						|ИЗ
						|	БизнесПроцесс." + ИмяТипа + " КАК ПроцессВыбора";
				КонецЕсли;
			Иначе
				Продолжить;
			КонецЕсли;
				
			Результат = Запрос.Выполнить();

			ВыборкаДетальныеЗаписи = Результат.Выбрать();

			Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
				НоваяСтрока = ДеревоЭлементов.Строки.Добавить();
				НоваяСтрока.ПредставлениеЭлемента = ОбъектТипа.Метаданные().Синоним;
				НоваяСтрока.Ссылка = Неопределено;
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					СтрокаЗначения = НоваяСтрока.Строки.Добавить();
					СтрокаЗначения.ПредставлениеЭлемента = Строка(ВыборкаДетальныеЗаписи.Ссылка);
					СтрокаЗначения.Ссылка = ВыборкаДетальныеЗаписи.Ссылка;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		ЗначениеВРеквизитФормы(ДеревоЭлементов, "СписокЭлементовДляВыбора"); 
		Если СписокЭлементовДляВыбора.ПолучитьЭлементы().Количество() = 0 Тогда
			ТекстИсключения = НСтр("ru = 'Недостаточно прав для выполнения операций с базой данных.'");
			ВызватьИсключение(ТекстИсключения);
		КонецЕсли;
		Для Каждого ВыбранноеЗначение Из Параметры.СписокВыбранныхЗначений Цикл
			ВыбранныеЗначения.Добавить(ВыбранноеЗначение.Значение);
		КонецЦикла;
		Элементы.ВариантыЗаполненияЗначений.ТекущаяСтраница = Элементы.Массив;
		Элементы.ГруппаСпискиВыбора.ТекущаяСтраница = Элементы.ОбычныйСписок;
	ИначеЕсли Параметры.ТипЗначения.Типы().Количество() = 1 Тогда 
		ОбъектТипа = Новый(Параметры.ТипЗначения.Типы()[0]);
		ИмяТипа = ОбъектТипа.Метаданные().Имя;
		Если Метаданные.Справочники.Найти(ИмяТипа) <> Неопределено
			И НЕ ПравоДоступа("Чтение", Метаданные.Справочники[ИмяТипа]) Тогда	
			ТекстИсключения = НСтр("ru = 'Недостаточно прав для выполнения операций с базой данных.'");
			ВызватьИсключение(ТекстИсключения);
		КонецЕсли;
		Если Метаданные.Справочники.Найти(ИмяТипа) <> Неопределено Тогда
			ДинамическийСписокЭлементовДляВыбора.ОсновнаяТаблица = "Справочник." + ИмяТипа;
			Если Метаданные.Справочники[ИмяТипа].Владельцы.Количество() > 0 Тогда
				ПолеГруппировки = ДинамическийСписокЭлементовДляВыбора.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
				ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("Владелец");					
			КонецЕсли;
			Если ИмяТипа = "ЗначенияСвойствОбъектов" Тогда
				ДинамическийСписокЭлементовДляВыбора.ПроизвольныйЗапрос = Истина;
				// Для типа ЗначениеСвойствОбъектов дополнительно устанавливается фильтр по доп.реквизиту
				ТекстЗапроса = 
					"ВЫБРАТЬ
					|	СправочникВыбора.Ссылка
					|ИЗ
					|	Справочник.ЗначенияСвойствОбъектов КАК СправочникВыбора
					|ГДЕ
					|	СправочникВыбора.Владелец В
					|			(ВЫБРАТЬ
					|				ДополнительныеРеквизитыИСведения.Ссылка
					|			ИЗ
					|				ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК ДополнительныеРеквизитыИСведения
					|			ГДЕ
					|				ДополнительныеРеквизитыИСведения.Наименование = &Наименование)";
				 ДинамическийСписокЭлементовДляВыбора.ТекстЗапроса = ТекстЗапроса;
				 ДинамическийСписокЭлементовДляВыбора.Параметры.УстановитьЗначениеПараметра("Наименование", Параметры.ПредставлениеРеквизита);
				 Элементы.ДинамическийСписокЭлементовДляВыбора.Отображение = ОтображениеТаблицы.Список;
				 ДинамическийСписокЭлементовДляВыбора.Группировка.Элементы.Очистить();
			КонецЕсли;
		Иначе
			ДинамическийСписокЭлементовДляВыбора.ОсновнаяТаблица = "Перечисление." + ИмяТипа;
		КонецЕсли;
				
		Для Каждого ВыбранноеЗначение Из Параметры.СписокВыбранныхЗначений Цикл
			ВыбранныеЗначения.Добавить(ВыбранноеЗначение.Значение);
		КонецЦикла;

		Элементы.ВариантыЗаполненияЗначений.ТекущаяСтраница = Элементы.Массив;
		Элементы.ГруппаСпискиВыбора.ТекущаяСтраница = Элементы.ДинамическийСписок;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьБезСохранения(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	
	Если НЕ НеЗаполнено Тогда
		ДанныеВыбора = Новый Структура;
		ДанныеВыбора.Вставить("ТипЗначения", "Массив");
		ДанныеВыбора.Вставить("СписокВыбранных", ВыбранныеЗначения);
		ДанныеВыбора.Вставить("ОписаниеТипов", ТипЗначения);
		Закрыть(ДанныеВыбора);
	Иначе
		Закрыть(НеЗаполнено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЭлементовДляВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Для Каждого ВыделеннаяСтрока Из Элемент.ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			ПодчиненныеСсылки = ПолучитьЭлементыПоВладельцу(ИмяТипа, ВыделеннаяСтрока.Ключ);
			Для Каждого ПодчиненнаяСсылка Из ПодчиненныеСсылки Цикл
				СтруктураВыбраннойСсылки = Новый Структура;
				СтруктураВыбраннойСсылки.Вставить("Ссылка", ПодчиненнаяСсылка);
				СтруктураВыбраннойСсылки.Вставить("ПредставлениеЭлемента", Строка(ПодчиненнаяСсылка));
				ДобавитьДанныеСтрокиКСпискуВыбранных(СтруктураВыбраннойСсылки);	
			КонецЦикла;
		Иначе
			ДанныеВыделеннойСтроки = Элемент.ДанныеСтроки(ВыделеннаяСтрока);  
			ДобавитьДанныеСтрокиКСпискуВыбранных(ДанныеВыделеннойСтроки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЭлементыПоВладельцу(ИмяТипа, Владелец)
	
	МассивСсылок = Новый Массив;
	Выборка = Справочники[ИмяТипа].Выбрать(, Владелец);
	Пока Выборка.Следующий() Цикл
		МассивСсылок.Добавить(Выборка.Ссылка);
	КонецЦикла;
	Возврат МассивСсылок;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьДанныеСтрокиКСпискуВыбранных(ДанныеВыделеннойСтроки)
	
	Если ЗначениеЗаполнено(ДанныеВыделеннойСтроки.Ссылка)
		И ВыбранныеЗначения.НайтиПоЗначению(ДанныеВыделеннойСтроки.Ссылка) = Неопределено Тогда
		ВыбранныеЗначения.Добавить(ДанныеВыделеннойСтроки.Ссылка);
	Иначе
		ЭлементыВерхнегоУровня = СписокЭлементовДляВыбора.ПолучитьЭлементы();
		Для Каждого ЭлементВерхнегоУровня Из ЭлементыВерхнегоУровня Цикл
			Если ЭлементВерхнегоУровня.ПредставлениеЭлемента = ДанныеВыделеннойСтроки.ПредставлениеЭлемента Тогда
				Для Каждого ПодчиненныйЭлемент Из ЭлементВерхнегоУровня.ПолучитьЭлементы() Цикл
					Если ВыбранныеЗначения.НайтиПоЗначению(ПодчиненныйЭлемент.Ссылка) = Неопределено Тогда
						ВыбранныеЗначения.Добавить(ПодчиненныйЭлемент.Ссылка);	
					КонецЕсли;
				КонецЦикла;
				Прервать;
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	МассивСтрокДляУдаления = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.ВыбранныеЗначения.ВыделенныеСтроки Цикл
		МассивСтрокДляУдаления.Добавить(ВыбранныеЗначения.НайтиПоИдентификатору(ВыделеннаяСтрока));
	КонецЦикла;
	Для Каждого СтрокаДляУдаления Из МассивСтрокДляУдаления Цикл
		ВыбранныеЗначения.Удалить(СтрокаДляУдаления);
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура НеЗаполненоПриИзменении(Элемент)
	
	Элементы.Массив.Доступность = НЕ НеЗаполнено;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Для Каждого Элемент Из ПараметрыПеретаскивания.Значение Цикл
		Если ТипЗнч(Элемент) = Тип("ДанныеФормыЭлементДерева") Тогда
			ДобавитьДанныеСтрокиКСпискуВыбранных(Элемент);
		Иначе
			Если ВыбранныеЗначения.НайтиПоЗначению(Элемент) = Неопределено Тогда
				ВыбранныеЗначения.Добавить(Элемент);
	        КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	УдалитьИзВыбранных(Неопределено);
	
КонецПроцедуры
