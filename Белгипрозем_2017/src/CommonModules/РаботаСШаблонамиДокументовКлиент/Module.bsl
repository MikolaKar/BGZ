//Показывает общую форму создания документа по шаблону, который используется при создании документа
//Параметры: 
//	ТипШаблонаДокумента - строка "ШаблоныВнутреннихДокументов", "ШаблоныВходящих документов" или "ШаблоныИсходящихДокументов"
//	ПапкаСозданияДокумента - справочник "ПапкиВнутреннихДокументов"
//	СозданиеОбращенияГраждан - Булево - (по умолчанию Ложь) при создании обращений граждан используем не все шаблоны
//Возвращает: ссылку на шаблон документа, если пользователь нажал на кнопку "СоздатьПоШаблону"
//			  строку "СоздатьПустойДокумент", если создается пустой документ
//			  Неопределено, если пользователь нажал на Отмену
Процедура ПоказатьФормуСозданияДокументаПоШаблону(
	ОписаниеОповещения,
	ТипШаблонаДокумента, 
	ПапкаСозданияДокумента = Неопределено, 
	СозданиеОбращенияГраждан = Ложь) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипШаблонаДокумента", ТипШаблонаДокумента);
	ПараметрыФормы.Вставить("ВозможностьСозданияПустогоДокумента", Истина); 
	ПараметрыФормы.Вставить("НаименованиеКнопкиВыбора", НСтр("ru = 'Создать по шаблону'"));
	ПараметрыФормы.Вставить("ПапкаСозданияДокумента", ПапкаСозданияДокумента);
		
	Если СозданиеОбращенияГраждан Тогда 
		ПараметрыФормы.Вставить("СозданиеОбращенияГраждан", СозданиеОбращенияГраждан);
	КонецЕсли;
	
	Попытка
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("ОписаниеОповещения", ОписаниеОповещения);
		ОписаниеОповещенияФормы = Новый ОписаниеОповещения(
			"ПоказатьФормуСозданияДокументаПоШаблонуПродолжение",
			ЭтотОбъект,
			ПараметрыОбработчика);
		
		ОткрытьФорму(
			"ОбщаяФорма.СозданиеДокументаПоШаблону", 
			ПараметрыФормы,,,,,
			ОписаниеОповещенияФормы,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Исключение
		Инфо = ИнформацияОбОшибке();
		Если Инфо.Описание = "СоздатьПустойДокумент" Тогда
			Результат = "СоздатьПустойДокумент";
			ВыполнитьОбработкуОповещения(ОписаниеОповещенияФормы, Результат);
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
		
КонецПроцедуры

Процедура ПоказатьФормуСозданияДокументаПоШаблонуПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = "ПрерватьОперацию" Или Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещения, Результат);
	
КонецПроцедуры

//Показывает общую форму создания документа по шаблону, который используется для заполнения только созданного документа
//Параметры: ТипШаблонаДокумента - строка "ШаблоныВнутреннихДокументов", "ШаблоныВходящих документов" или "ШаблоныИсходящихДокументов"
//Возвращает: ссылку на шаблон документа, если пользователь нажал на кнопку "СоздатьПоШаблону"
//			  Неопределено, если пользователь нажал на Отмену
Процедура ПоказатьФормуЗаполненияДокументаПоШаблону(ОписаниеОповещения, ТипШаблонаДокумента, ПапкаСозданияДокумента = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипШаблонаДокумента", ТипШаблонаДокумента);
	ПараметрыФормы.Вставить("ВозможностьСозданияПустогоДокумента", Ложь);
	ПараметрыФормы.Вставить("НаименованиеКнопкиВыбора", НСтр("ru = 'Заполнить по шаблону'"));
	ПараметрыФормы.Вставить("ПапкаСозданияДокумента", ПапкаСозданияДокумента);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	ОписаниеОповещенияФормы = Новый ОписаниеОповещения(
		"ПоказатьФормуЗаполненияДокументаПоШаблонуПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчика);
	Попытка
		ОткрытьФорму(
			"ОбщаяФорма.СозданиеДокументаПоШаблону",
			ПараметрыФормы,,,,,
			ОписаниеОповещенияФормы,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Исключение
		Инфо = ИнформацияОбОшибке();
		Если Инфо.Описание = "СоздатьПустойДокумент" Тогда
			Результат = "СоздатьПустойДокумент";
			ВыполнитьОбработкуОповещения(ОписаниеОповещенияФормы, Результат);
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
		
КонецПроцедуры

Процедура ПоказатьФормуЗаполненияДокументаПоШаблонуПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = "ПрерватьОперацию" Тогда
		Результат = Неопределено;
	КонецЕсли;
	ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещения, Результат);
	
КонецПроцедуры

Процедура ПоказатьФормуВыбораЗначения(Форма, Элемент) Экспорт
	
	КоличествоТипов = Элемент.Родитель.ТекущиеДанные.ТипЗначения.Типы().Количество(); 
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Форма", Форма);
	ПараметрыОбработчика.Вставить("Элемент", Элемент);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьФормуВыбораЗначенияПродолжение",
		ЭтотОбъект,
		параметрыОбработчика);
	
	Если КоличествоТипов = 1 Тогда
		ТипДляВвода = Элемент.Родитель.ТекущиеДанные.ТипЗначения.Типы()[0];
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, ТипДляВвода);
	ИначеЕсли КоличествоТипов > 1 Тогда
		СписокТипов = Новый СписокЗначений;
		СписокТипов.ЗагрузитьЗначения(Элемент.Родитель.ТекущиеДанные.ТипЗначения.Типы());
		Форма.ПоказатьВыборИзСписка(ОписаниеОповещения, СписокТипов, Элемент);
		Возврат;
	КонецЕсли;
	
	                                                                          		
КонецПроцедуры

Процедура ПоказатьФормуВыбораЗначенияПродолжение(ТипДляВвода, Параметры) Экспорт
	
	Если ТипДляВвода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(ТипДляВвода) = Тип("ЭлементСпискаЗначений") Тогда
		ТипДляВвода = ТипДляВвода.Значение;
	КонецЕсли;
	
	Если ТипДляВвода = Тип("СправочникСсылка.ЗначенияСвойствОбъектов") Тогда
		Отбор = Новый Структура("Владелец", Параметры.Элемент.Родитель.ТекущиеДанные.Реквизит);
		ПараметрыФормы = Новый Структура("Отбор, РежимВыбора", Отбор, Истина);
		ОткрытьФорму("Справочник.ЗначенияСвойствОбъектов.ФормаВыбора", ПараметрыФормы, Параметры.Элемент);
	Иначе	
		
		ПараметрыОповещения = Новый Структура();
		ПараметрыОповещения.Вставить("Элемент", Параметры.Элемент); 
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ВводЗначенияПродолжение",
			ЭтотОбъект,
			ПараметрыОповещения);
		
		ПоказатьВводЗначения(
			ОписаниеОповещения,
			Параметры.Элемент.Родитель.ТекущиеДанные.ЗначениеРеквизита, 
			Строка(Параметры.Элемент.Родитель.ТекущиеДанные.Реквизит),
			ТипДляВвода);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ВводЗначенияПродолжение(Значение, Параметры) Экспорт
	
	Если Значение <> Неопределено Тогда
		Параметры.Элемент.Родитель.ТекущиеДанные.ЗначениеРеквизита = Значение;	
	КонецЕсли;
	
КонецПроцедуры

// Добавляет пользователя или группу пользователей в табличную часть Доступ
//
Процедура ДоступДобавитьПользователя(Объект, Пользователь, ОсновнойОбъектАдресации = Неопределено, ДополнительныйОбъектАдресации = Неопределено) Экспорт
	ДоступСтрока = Объект.Доступ.Добавить();
	ДоступСтрока.Пользователь = Пользователь;
	ДоступСтрока.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
	ДоступСтрока.ДополнительныйОбъектАдресации = ДополнительныйОбъектАдресации;
	ДоступСтрока.Иконка = ПолучитьИконку(Пользователь);
	ДоступСтрока.ЭтоРоль = (ТипЗнч(Пользователь) = Тип("СправочникСсылка.РолиИсполнителей"));
КонецПроцедуры

Функция ПолучитьИконку(Пользователь)
	Возврат ?(ТипЗнч(Пользователь) = Тип("СправочникСсылка.ГруппыПользователей"), 0, 2);
КонецФункции

// Обработчик команды подбора пользователей шаблона
//
Процедура ПодобратьПользователейДоступКШаблону(Форма) Экспорт
	
	ПользователиШаблона = Новый Массив;
	Для каждого ДоступСтрока Из Форма.Объект.Доступ Цикл
		ПользователиШаблона.Добавить(ДоступСтрока.Пользователь);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Подбор пользователей шаблона'"));
	ПараметрыФормы.Вставить("ВыбранныеЗаголовок", НСтр("ru = 'Выбранные пользователи и группы'"));
	ПараметрыФормы.Вставить("Выбранные", ПользователиШаблона);
	ПараметрыФормы.Вставить("ПодбиратьГруппыПользователей", Истина);
	ПараметрыФормы.Вставить("ПоказыватьРоли", Истина);
	ПараметрыФормы.Вставить("ПоказыватьФункции", Ложь);
	ОткрытьФорму("ОбщаяФорма.ПодборИсполнителей", ПараметрыФормы, Форма.Элементы.Доступ);
	
КонецПроцедуры

// Открывает форму выбора пользователя
//
Процедура ДоступПользовательНачалоВыбора(Форма, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Выбор пользователя шаблона'"));
	ПараметрыФормы.Вставить("ВыбиратьГруппуПользователей", Истина);
	ПараметрыФормы.Вставить("ПоказыватьРоли", Истина);
	ПараметрыФормы.Вставить("ПоказыватьФункции", Ложь);
	ПараметрыФормы.Вставить("Исполнитель", Форма.Элементы.Доступ.ТекущиеДанные.Пользователь);
	ОткрытьФорму("ОбщаяФорма.ВыборИсполнителя", ПараметрыФормы, Форма.Элементы.Доступ);
КонецПроцедуры

// Обработчик события ПриПриНачалеРедактирования табличной части Доступ
//
Процедура ДоступПриНачалеРедактирования(Элемент, НоваяСтрока) Экспорт
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Пользователь = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		Элемент.ТекущиеДанные.Иконка = 2;
		Элемент.ТекущиеДанные.ЭтоРоль = Ложь;
	КонецЕсли;
КонецПроцедуры

// Обработчик события Автоподбор колонки Пользователь табличной части Доступ
//
Процедура ДоступПользовательАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = РаботаСРабочимиГруппами.СформироватьДанныеВыбораУчастника(Текст, Ложь);
	КонецЕсли;	
КонецПроцедуры

// Обработчик события ПриОкончанииРедактирования табличной части Доступ
//
Процедура ДоступПриОкончанииРедактирования(Форма, Элемент) Экспорт
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Элемент.ТекущиеДанные.Иконка = ПолучитьИконку(Элемент.ТекущиеДанные.Пользователь);
	Элемент.ТекущиеДанные.ЭтоРоль = (ТипЗнч(Элемент.ТекущиеДанные.Пользователь) = Тип("СправочникСсылка.РолиИсполнителей"));
	Форма.Объект.Доступ.Сортировать("Иконка, ЭтоРоль Убыв, Пользователь");
КонецПроцедуры
