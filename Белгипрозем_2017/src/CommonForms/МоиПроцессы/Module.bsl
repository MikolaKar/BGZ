
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	// Восстановление настроек формы
	СохраненныеРеквизиты = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы + "/ТекущиеДанные");
	Если ТипЗнч(СохраненныеРеквизиты) = Тип("Соответствие") Тогда
		ПоказыватьТолькоАктивныеПроцессы = СохраненныеРеквизиты.Получить("ПоказыватьТолькоАктивныеПроцессы");
		ПоТипуПроцесса = СохраненныеРеквизиты.Получить("ПоТипуПроцесса");
		ПоИсполнителю = СохраненныеРеквизиты.Получить("ПоИсполнителю");
		ПоПредмету = СохраненныеРеквизиты.Получить("ПоПредмету");
	Иначе
		ПоказыватьТолькоАктивныеПроцессы = Истина;
		ПоИсполнителю = Неопределено;
		ПоПредмету = Неопределено;
	КонецЕсли;
	Элементы.СписокПроцессовПоказыватьТолькоАктивныеПроцессы.Пометка = ПоказыватьТолькоАктивныеПроцессы;
	
	// Установка параметров списку процессов
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СписокПроцессов,
		"ТекущаяДата",
		ТекущаяДатаСеанса);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СписокПроцессов,
		"Автор",
		ТекущийПользователь);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СписокПроцессов,
		"ПоказыватьТолькоАктивныеПроцессы",
		ПоказыватьТолькоАктивныеПроцессы,
		ПоказыватьТолькоАктивныеПроцессы);
	
	УстановитьУсловноеОформлениеСпискаПроцессов(ТекущаяДатаСеанса);
	
	ДатаОбновленияПараметраТекущаяДата = ТекущаяДатаСеанса;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "БизнесПроцессИзменен"
		ИЛИ ИмяСобытия = "ЗадачаИзменена" Тогда
		
		Элементы.СписокПроцессов.Обновить();
		ТекущийПроцесс = Неопределено;
		СписокПроцессовПриАктивизацииСтроки(Элементы.СписокПроцессов);
	КонецЕсли;
	
	Если ИмяСобытия = "ЗаписьКонтроля" Тогда
		Если ЗначениеЗаполнено(Параметр.Предмет) И ЭтоПоддерживаемыйБизнесПроцесс(Параметр.Предмет) Тогда
			Элементы.СписокПроцессов.Обновить();
			ОповеститьОбИзменении(Параметр.Предмет);
			
			ТекущийПроцесс = Неопределено;
			ПодключитьОбработчикОжидания("ОбновитьHTMLПредставление", 0.2, Истина);
			СписокПроцессовПриАктивизацииСтроки(Элементы.СписокПроцессов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ОбзорПроцессовКлиент.ПредставлениеHTMLПриНажатии(
		Элемент, ДанныеСобытия, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокПроцессов

&НаКлиенте
Процедура СписокПроцессовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СписокПроцессов.ДанныеСтроки(ВыбраннаяСтрока);
	
	Если Поле.Имя = "СписокПроцессовОсновнойПредмет" Тогда
		Если ТипЗнч(ТекущиеДанные.ОсновнойПредмет) = Тип("Строка") Тогда
			ПоказатьЗначение(, ТекущиеДанные.Процесс)
		Иначе
			ПоказатьЗначение(, ТекущиеДанные.ОсновнойПредмет);
		КонецЕсли;
	Иначе
		ПоказатьЗначение(, ТекущиеДанные.Процесс);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроцессовПриАктивизацииСтроки(Элемент)
	
	НовыйТекущийПроцесс = Неопределено;
	
	Если Элементы.СписокПроцессов.ТекущиеДанные <> Неопределено Тогда
		НовыйТекущийПроцесс = Элементы.СписокПроцессов.ТекущиеДанные.Процесс;
	КонецЕсли;
	
	Если НовыйТекущийПроцесс = ТекущийПроцесс Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийПроцесс = НовыйТекущийПроцесс;
	
	ПодключитьОбработчикОжидания("ОбновитьHTMLПредставление", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокПроцессов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьБизнесПроцесс(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.Остановить(ВыделенныеПроцессы(), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБизнесПроцесс(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.СделатьАктивным(ВыделенныеПроцессы(), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьБизнесПроцесс(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПрерватьБизнесПроцесс(ТекущийПроцесс, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСрок(Команда)
	
	ТекущиеДанные = Элементы.СписокПроцессов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТипПроцесса = ТипЗнч(ТекущийПроцесс);
	
	Если ТипПроцесса = Тип("БизнесПроцессСсылка.ОбработкаВнутреннегоДокумента")
		Или ТипПроцесса = Тип("БизнесПроцессСсылка.ОбработкаВходящегоДокумента")
		Или ТипПроцесса = Тип("БизнесПроцессСсылка.ОбработкаИсходящегоДокумента") Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Изменение срока невозможно, т.к. для процесса не предусмотрены сроки выполнения.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если ТипПроцесса = Тип("БизнесПроцессСсылка.Исполнение")
		И ЕстьОсобыеСрокиВПроцессеИсполнения(ТекущийПроцесс) Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Изменение срока возможно только в карточке процесса, т.к. исполнителям назначены особые сроки.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если ТипПроцесса = Тип("БизнесПроцессСсылка.Согласование")
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийПроцесс, "РазныеСроки") = Истина Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Изменение срока возможно только в карточке процесса, т.к. исполнителям назначены разные сроки.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьСрок_Продолжение", ЭтотОбъект);
	
	Если ТипПроцесса = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СрокИсполнения", ТекущиеДанные.СрокИсполнения);
		ПараметрыФормы.Вставить("Стартован", ТекущиеДанные.Стартован);
		Если ТекущиеДанные.Стартован Тогда
			ПараметрыФормы.Вставить("ДатаНачалаОтсчета", ТекущиеДанные.ДатаНачала);
		Иначе
			ПараметрыФормы.Вставить("ДатаНачалаОтсчета", ТекущиеДанные.Дата);
		КонецЕсли;
		ПараметрыФормы.Вставить("ОписаниеСрока", "");
		
		ОткрытьФорму(
			"БизнесПроцесс.КомплексныйПроцесс.Форма.ФормаВводКонтрольногоСрока",
			ПараметрыФормы,
			ЭтаФорма,,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("БизнесПроцесс", ТекущийПроцесс);
	ПараметрыФормы.Вставить("ЗаявкаНаПереносСрока", 
		ПредопределенноеЗначение("БизнесПроцесс.РешениеВопросовВыполненияЗадач.ПустаяСсылка"));
	ПараметрыФормы.Вставить("Идентификатор", УникальныйИдентификатор);
	
	ОткрытьФорму(
		"БизнесПроцесс.РешениеВопросовВыполненияЗадач.Форма.ФормаПереносСрокаБизнесПроцесса", 
		ПараметрыФормы, ЭтаФорма,,,,ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСрок_Продолжение(РезультатПереносаСрока, ДопПараметры) Экспорт
	
	Если ТипЗнч(РезультатПереносаСрока) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущийПроцесс) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
		ПараметрыПереносаСрока = Новый Структура;
		ПараметрыПереносаСрока.Вставить("НовыйСрок", РезультатПереносаСрока.СрокИсполнения);
	Иначе
		ПараметрыПереносаСрока = РезультатПереносаСрока;
	КонецЕсли;
	
	Если ПеренестиСрокПроцесса(ТекущийПроцесс, ПараметрыПереносаСрока) = Истина Тогда
		Оповестить("БизнесПроцессИзменен", ТекущийПроцесс);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Контроль(Команда)
	
	ТекущиеДанные = Элементы.СписокПроцессов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат
	КонецЕсли;
	
	КонтрольКлиент.ОбработкаКомандыКонтроль(ТекущиеДанные.Процесс, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	ВыделенныеСтроки = Элементы.СписокПроцессов.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПроцессыДляПометкиНаУдаление = Новый Массив;
	ПроцессыДляСнятияПометкиУдаления = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		ДанныеВыделеннойСтроки = Элементы.СписокПроцессов.ДанныеСтроки(ВыделеннаяСтрока);
		
		Если ДанныеВыделеннойСтроки.ПометкаУдаления Тогда
			ПроцессыДляСнятияПометкиУдаления.Добавить(ДанныеВыделеннойСтроки.Процесс);
		Иначе
			ПроцессыДляПометкиНаУдаление.Добавить(ДанныеВыделеннойСтроки.Процесс);
		КонецЕсли;
		
	КонецЦикла;
	
	КоличествоПроцессовДляСнятияПометкиУдаления = ПроцессыДляСнятияПометкиУдаления.Количество();
	КоличествоПроцессовДляПометкиНаУдаление = ПроцессыДляПометкиНаУдаление.Количество();
	
	ПроцессыДляОбработки = Неопределено;
	
	Если КоличествоПроцессовДляСнятияПометкиУдаления > 0 Тогда
		Если КоличествоПроцессовДляСнятияПометкиУдаления = 1 Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Снять с ""%1"" пометку на удаление?'"),
				ПроцессыДляСнятияПометкиУдаления[0]);
		Иначе
			ТекстВопроса = НСтр("ru = 'Снять с выделенных элементов пометку на удаление?'");
		КонецЕсли;
		ПроцессыДляОбработки = ПроцессыДляСнятияПометкиУдаления;
	ИначеЕсли КоличествоПроцессовДляПометкиНаУдаление > 0 Тогда
		Если КоличествоПроцессовДляПометкиНаУдаление = 1 Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Пометить ""%1"" на удаление?'"),
				ПроцессыДляПометкиНаУдаление[0]);
		Иначе
			ТекстВопроса = НСтр("ru = 'Пометить выделенные элементы на удаление?'");
		КонецЕсли;
		ПроцессыДляОбработки = ПроцессыДляПометкиНаУдаление;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПометитьНаУдаление_Продолжение", ЭтаФорма, ПроцессыДляОбработки);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
	//РаботаСБизнесПроцессамиКлиент.ПометитьНаУдалениеБизнесПроцесс(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление_Продолжение(Ответ, ПроцессыДляОбработки) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	РезультатПометкиУдаления = ПометитьНаУдалениеПроцессы(ПроцессыДляОбработки);
	
	Если ЗначениеЗаполнено(РезультатПометкиУдаления) Тогда
		ПоказатьПредупреждение(, РезультатПометкиУдаления);
	КонецЕсли;
	
	Элементы.СписокПроцессов.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьТолькоАктивныеПроцессы(Команда)
	
	ПоказыватьТолькоАктивныеПроцессы = Не ПоказыватьТолькоАктивныеПроцессы;
	
	Элементы.СписокПроцессовПоказыватьТолькоАктивныеПроцессы.Пометка = ПоказыватьТолькоАктивныеПроцессы;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СписокПроцессов,
		"ПоказыватьТолькоАктивныеПроцессы",
		ПоказыватьТолькоАктивныеПроцессы,
		ПоказыватьТолькоАктивныеПроцессы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПометитьНаУдалениеПроцессы(Процессы)
	
	Результат = "";
	
	ОбщееКоличествоПроцессов = Процессы.Количество();
	КоличествоУдаленныхПроцессов = 0;
	
	ПропускатьИсключения = Процессы.Количество() > 1;
	
	Для Каждого Процесс Из Процессы Цикл
		
		Попытка
			РаботаСБизнесПроцессами.ПометитьНаУдалениеБизнесПроцесс(Процесс);
			КоличествоУдаленныхПроцессов = КоличествоУдаленныхПроцессов + 1;
		Исключение
			// Если процессов более 1го, тогда маскируем исключение, чтобы не прерывать обработку очереди.
			Если Не ПропускатьИсключения Тогда
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
		
	КонецЦикла;
	
	Если ПропускатьИсключения
		И КоличествоУдаленныхПроцессов <> ОбщееКоличествоПроцессов Тогда
		
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для %1 из %2 процессов установлена/снята пометка удаления.'"),
			КоличествоУдаленныхПроцессов,
			ОбщееКоличествоПроцессов);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформлениеСпискаПроцессов(ТекущаяДатаСеанса)
	
	СписокПроцессов.УсловноеОформление.Элементы.Очистить();
	
	// нестартованные процессы
	ПредставлениеЭлемента = "Процесс не стартован (стандартная настройка)";
	ЭлементУсловногоОформления = БизнесПроцессыИЗадачиСервер.ЭлементУсловногоОформленияПоПредставлению(
		СписокПроцессов.УсловноеОформление, ПредставлениеЭлемента);
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Стартован");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ЦветТекста");
	ЭлементЦветаОформления.Значение = ЦветаСтиля.НеСтартованныйБизнесПроцесс; 
	ЭлементЦветаОформления.Использование = Истина;
	
	Поле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	Поле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ДатаНачала");
	
	// помеченные на удаление процессы
	ПредставлениеЭлемента = "Процесс помечен на удаление (стандартная настройка)";
	ЭлементУсловногоОформления = БизнесПроцессыИЗадачиСервер.ЭлементУсловногоОформленияПоПредставлению(
		СписокПроцессов.УсловноеОформление, ПредставлениеЭлемента);
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Шрифт");
	ЭлементЦветаОформления.Значение = Новый Шрифт(,,,,,Истина);
	ЭлементЦветаОформления.Использование = Истина;
	
	Поле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	
	// завершенные процессы
	ПредставлениеЭлемента = "Процесс завершен (стандартная настройка)";
	ЭлементУсловногоОформления = БизнесПроцессыИЗадачиСервер.ЭлементУсловногоОформленияПоПредставлению(
		СписокПроцессов.УсловноеОформление, ПредставлениеЭлемента);
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Завершен");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ЦветТекста");
	ЭлементЦветаОформления.Значение = ЦветаСтиля.ЗавершенныйБизнесПроцесс;
	ЭлементЦветаОформления.Использование = Истина;
	
	Поле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	
	// Просроченные процессы
	ПредставлениеЭлемента = "Процесс просрочен (стандартная настройка)";
	ЭлементУсловногоОформления = БизнесПроцессыИЗадачиСервер.ЭлементУсловногоОформленияПоПредставлению(
		СписокПроцессов.УсловноеОформление, ПредставлениеЭлемента);
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбораДанных.ПравоеЗначение = ТекущаяДатаСеанса;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ЦветТекста");
	ЭлементЦветаОформления.Значение = ЦветаСтиля.ПросроченныеДанныеЦвет;
	ЭлементЦветаОформления.Использование = Истина;
	
	Поле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("СрокИсполнения");
	Поле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("Дней");
	
	// Процессы, до завершения срока которых остался один день
	ПредставлениеЭлемента = "До окончания срока остался один день (стандартная настройка)";
	ЭлементУсловногоОформления = БизнесПроцессыИЗадачиСервер.ЭлементУсловногоОформленияПоПредставлению(
		СписокПроцессов.УсловноеОформление, ПредставлениеЭлемента);
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дней");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дней");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = 1;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ЦветТекста");
	ЭлементЦветаОформления.Значение = ЦветаСтиля.ПросроченныеДанныеЦвет;
	ЭлементЦветаОформления.Использование = Истина;
	
	Поле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("Дней");
	
	// Процессы, у которых количество циклов более 5
	ПредставлениеЭлемента = "Количество циклов выполнения процесса более 5 (стандартная настройка)";
	ЭлементУсловногоОформления = БизнесПроцессыИЗадачиСервер.ЭлементУсловногоОформленияПоПредставлению(
		СписокПроцессов.УсловноеОформление, ПредставлениеЭлемента);
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Цикл");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ЭлементОтбораДанных.ПравоеЗначение = 5;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ЦветТекста");
	ЭлементЦветаОформления.Значение = ЦветаСтиля.ПросроченныеДанныеЦвет;
	ЭлементЦветаОформления.Использование = Истина;
	
	Поле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("Цикл");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокПроцессов()
	
	ТекущаяДата = ТекущаяДата();
	
	Если ТекущаяДата - ДатаОбновленияПараметраТекущаяДата > 43200 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			СписокПроцессов,
			"ТекущаяДата",
			ТекущаяДата);
		УстановитьУсловноеОформлениеСпискаПроцессов(ТекущаяДата);
		ДатаОбновленияПараметраТекущаяДата = ТекущаяДата;
	КонецЕсли;
	
	Элементы.СписокПроцессов.Обновить();
	
КонецПроцедуры

// Возвращает массив выделенных процессов в списке.
//
// Возвращаемое значение:
//   Массив
//
&НаКлиенте
Функция ВыделенныеПроцессы()
	
	Результат = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.СписокПроцессов.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.СписокПроцессов.ДанныеСтроки(ВыделеннаяСтрока);
		Результат.Добавить(ДанныеСтроки.Процесс);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ЭтоПоддерживаемыйБизнесПроцесс(Ссылка)
	
	ТипПроцесса = ТипЗнч(Ссылка);
	
	ТипыПоддерживаемыхПроцессов = Новый Массив;
	ТипыПоддерживаемыхПроцессов.Добавить(Тип("БизнесПроцессСсылка.Исполнение"));
	ТипыПоддерживаемыхПроцессов.Добавить(Тип("БизнесПроцессСсылка.КомплексныйПроцесс"));
	ТипыПоддерживаемыхПроцессов.Добавить(Тип("БизнесПроцессСсылка.ОбработкаВнутреннегоДокумента"));
	ТипыПоддерживаемыхПроцессов.Добавить(Тип("БизнесПроцессСсылка.ОбработкаВходящегоДокумента"));
	ТипыПоддерживаемыхПроцессов.Добавить(Тип("БизнесПроцессСсылка.ОбработкаИсходящегоДокумента"));
	ТипыПоддерживаемыхПроцессов.Добавить(Тип("БизнесПроцессСсылка.Ознакомление"));
	ТипыПоддерживаемыхПроцессов.Добавить(Тип("БизнесПроцессСсылка.Поручение"));
	ТипыПоддерживаемыхПроцессов.Добавить(Тип("БизнесПроцессСсылка.Приглашение"));
	ТипыПоддерживаемыхПроцессов.Добавить(Тип("БизнесПроцессСсылка.Рассмотрение"));
	ТипыПоддерживаемыхПроцессов.Добавить(Тип("БизнесПроцессСсылка.Регистрация"));
	ТипыПоддерживаемыхПроцессов.Добавить(Тип("БизнесПроцессСсылка.Согласование"));
	ТипыПоддерживаемыхПроцессов.Добавить(Тип("БизнесПроцессСсылка.Утверждение"));
	
	ЭтоПоддерживаемыйБизнесПроцесс = 
		ТипыПоддерживаемыхПроцессов.Найти(ТипПроцесса) <> Неопределено;
		
	Возврат ЭтоПоддерживаемыйБизнесПроцесс;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьHTMLПредставление()
	
	ПредставлениеHTML = ОбзорПроцессовВызовСервера.ПолучитьОбзорПроцесса(ТекущийПроцесс);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьОсобыеСрокиВПроцессеИсполнения(Процесс)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИсполнениеИсполнители.Исполнитель
		|ИЗ
		|	БизнесПроцесс.Исполнение.Исполнители КАК ИсполнениеИсполнители
		|ГДЕ
		|	ИсполнениеИсполнители.Ссылка = &Процесс
		|	И ИсполнениеИсполнители.СрокИсполнения <> ДАТАВРЕМЯ(1, 1, 1)";
		
	Запрос.УстановитьПараметр("Процесс", Процесс);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервереБезКонтекста
Функция ПеренестиСрокПроцесса(Процесс, Параметры)
	
	НачатьТранзакцию();
	
	ЗаблокироватьДанныеДляРедактирования(Процесс);
	
	ПроцессОбъект = Процесс.ПолучитьОбъект();
	ПроцессОбъект.СрокИсполнения = Параметры.НовыйСрок;
	
	Если ТипЗнч(Процесс) <> Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
		ПереносСроковВыполненияЗадач.СделатьЗаписьОПереносеСрока(ПроцессОбъект, Параметры);
	КонецЕсли;
	
	ПроцессОбъект.Записать();
	
	РазблокироватьДанныеДляРедактирования(Процесс);
	
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
