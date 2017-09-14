////////////////////////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контактная информация"
// 
////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс
//

// Возвращает признак того, является ли строка данных контактной информации XML данными
//
// Параметры:
//     Текст - Строка - Проверяемая строка
//
Функция ЭтоКонтактнаяИнформацияВXML(Знач Текст) Экспорт
	// Упрощенная проверка
	Возврат ЭтоСтрокаXML(Текст);
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
//

// МиСофт
Функция СокращениеВпереди(Сокращение) Экспорт
	//МиСофт+
	СокращенияВпереди = Новый СписокЗначений;
	СокращенияВпереди.Добавить("г.", "г.");
	СокращенияВпереди.Добавить("ул.", "ул.");
	СокращенияВпереди.Добавить("пер.", "пер.");
	СокращенияВпереди.Добавить("аг.", "аг.");
	СокращенияВпереди.Добавить("д.", "д.");
	СокращенияВпереди.Добавить("п.", "п.");
	
	Возврат Не СокращенияВпереди.НайтиПоЗначению(Сокращение) = Неопределено;
	//МиСофт-
КонецФункции

//МиСофт
Функция ПолучитьПредставлениеАдресногоЭлемента(Наименование, Сокращение, АдресныйЭлемент = Неопределено) Экспорт
	//МиСофт+
	Результат = ?(СокращениеВпереди(СокрЛП(Сокращение)), 
	СокрЛП(СокрЛП(Сокращение) + " " + СокрЛП(Наименование)), 
	СокрЛП(СокрЛП(Наименование) + " " + СокрЛП(Сокращение)));
	
	Если Не АдресныйЭлемент = Неопределено Тогда
		Если АдресныйЭлемент = "Регион" Тогда
			Результат = ?(ОбластнойЦентр(Результат), "", Результат);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	//МиСофт-
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
//

// Возвращает аккуратно построеное наименование через запятую по парам "Название" + "Сокращение"
//
Функция ПолноеНаименование(Знач н0 = "", Знач с0 = "", Знач н1 = "", Знач с1 = "", Знач н2 = "", Знач с2 = "", Знач н3 = "", Знач с3 = "", Знач н4 = "", Знач с4 = "", Знач н5 = "", Знач с5 = "", Знач н6 = "", Знач с6 = "", Знач н7 = "", Знач с7 = "", Знач н8 = "", Знач с8 = "", Знач н9 = "", Знач с9 = "") Экспорт
	
	// Часть 0
	Результат = ?(ПустаяСтрока(н0), "", СокрЛП( СокрП(н0) + " " + СокрЛ(с0)) );
	
	// Часть 1
	ТекН = СокрЛП(н1);
	Наименование = ?(ТекН = "", "", СокрЛП(ТекН + " " + СокрЛ(с1)));
	Если Наименование = "" Или Результат = "" Тогда
		Результат = Результат + Наименование;
	Иначе
		Результат = Результат + ", " + Наименование;
	КонецЕсли;
	
	// Часть 2
	ТекН = СокрЛП(н2);
	Наименование = ?(ТекН = "", "", СокрЛП(ТекН + " " + СокрЛ(с2)));
	Если Наименование = "" Или Результат = "" Тогда
		Результат = Результат + Наименование;
	Иначе
		Результат = Результат + ", " + Наименование;
	КонецЕсли;
	
	// Часть 3
	ТекН = СокрЛП(н3);
	Наименование = ?(ТекН = "", "", СокрЛП(ТекН + " " + СокрЛ(с3)));
	Если Наименование = "" Или Результат = "" Тогда
		Результат = Результат + Наименование;
	Иначе
		Результат = Результат + ", " + Наименование;
	КонецЕсли;
	
	// Часть 4
	ТекН = СокрЛП(н4);
	Наименование = ?(ТекН = "", "", СокрЛП(ТекН + " " + СокрЛ(с4)));
	Если Наименование = "" Или Результат = "" Тогда
		Результат = Результат + Наименование;
	Иначе
		Результат = Результат + ", " + Наименование;
	КонецЕсли;
	
	// Часть 5
	ТекН = СокрЛП(н5);
	Наименование = ?(ТекН = "", "", СокрЛП(ТекН + " " + СокрЛ(с5)));
	Если Наименование = "" Или Результат = "" Тогда
		Результат = Результат + Наименование;
	Иначе
		Результат = Результат + ", " + Наименование;
	КонецЕсли;
	
	// Часть 6
	ТекН = СокрЛП(н6);
	Наименование = ?(ТекН = "", "", СокрЛП(ТекН + " " + СокрЛ(с6)));
	Если Наименование = "" Или Результат = "" Тогда
		Результат = Результат + Наименование;
	Иначе
		Результат = Результат + ", " + Наименование;
	КонецЕсли;
	
	// Часть 7
	ТекН = СокрЛП(н7);
	Наименование = ?(ТекН = "", "", СокрЛП(ТекН + " " + СокрЛ(с7)));
	Если Наименование = "" Или Результат = "" Тогда
		Результат = Результат + Наименование;
	Иначе
		Результат = Результат + ", " + Наименование;
	КонецЕсли;
	
	// Часть 8
	ТекН = СокрЛП(н8);
	Наименование = ?(ТекН = "", "", СокрЛП(ТекН + " " + СокрЛ(с8)));
	Если Наименование = "" Или Результат = "" Тогда
		Результат = Результат + Наименование;
	Иначе
		Результат = Результат + ", " + Наименование;
	КонецЕсли;
	
	// Часть 9
	ТекН = СокрЛП(н9);
	Наименование = ?(ТекН = "", "", СокрЛП(ТекН + " " + СокрЛ(с9)));
	Если Наименование = "" Или Результат = "" Тогда
		Результат = Результат + Наименование;
	Иначе
		Результат = Результат + ", " + Наименование;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Возвращает структуру с наименованием и сокращением от значения
//
// Параметры:
//     Текст - Строка - Полное наименование
//
Функция НаименованиеСокращение(Знач Текст) Экспорт
	Результат = Новый Структура("Наименование, Сокращение");
	Части = ЧастиАдреса(Текст, Истина);
	Если Части.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Результат, Части[0]);
	Иначе
		Результат.Наименование = Текст;
	КонецЕсли;
	Возврат Результат;
КонецФункции

// Возвращает отдельно сокращение от значения
//
// Параметры:
//     Текст - Строка - Полное наименования
//
Функция Сокращение(Знач Текст) Экспорт
	Части = НаименованиеСокращение(Текст);
	Возврат Части.Сокращение;
КонецФункции

// Разделяет текст на слова по указанным разделителям. По умолчанию разделители - пробельные символы
// Возвращает массив слов.
//
// Параметры:
//     Текст       - Строка - Разделяемая строка
//     Разделители - Строка - Необязательная строка символов-разделителей
//
Функция СловаТекста(Знач Текст, Знач Разделители = Неопределено) Экспорт
	
	НачалоСлова = 0;
	Состояние   = 0;
	Результат   = Новый Массив;
	
	Для Позиция = 1 По СтрДлина(Текст) Цикл
		ТекущийСимвол = Сред(Текст, Позиция, 1);
		ЭтоРазделитель = ?(Разделители = Неопределено, ПустаяСтрока(ТекущийСимвол), Найти(Разделители, ТекущийСимвол) > 0);
		
		Если Состояние = 0 И (Не ЭтоРазделитель) Тогда
			НачалоСлова = Позиция;
			Состояние   = 1;
		ИначеЕсли Состояние = 1 И ЭтоРазделитель Тогда
			Результат.Добавить(Сред(Текст, НачалоСлова, Позиция-НачалоСлова));
			Состояние = 0;
		КонецЕсли;
	КонецЦикла;
	
	Если Состояние = 1 Тогда
		Результат.Добавить(Сред(Текст, НачалоСлова, Позиция-НачалоСлова));    
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Разделяет текст, разделенный запятыми, на массив структур "Наименование, Сокращение"
//
// Параметры:
//     Текст              - Срока - Разделяемый текст
//     ВыделятьСокращения - Булево - Опциональный параметр режима работы
//
Функция ЧастиАдреса(Знач Текст, Знач ВыделятьСокращения = Истина) Экспорт
	
	Результат = Новый Массив;
	Для Каждого Часть Из СловаТекста(Текст, ",") Цикл
		СтрокаЧасти = СокрЛП(Часть);
		Если ПустаяСтрока(СтрокаЧасти) Тогда
			Продолжить;
		КонецЕсли;

//1С-Минск
        // Если в Часть есть слово Совет, то эта часть относится к Сельсоветам и 
        //  сокращения (с/с) у нее не будет.
        Если Найти(СтрокаЧасти, " Совет") > 0 Тогда
			Результат.Добавить(Новый Структура("Наименование, Сокращение", СтрокаЧасти));
            Продолжить;
        КонецЕсли; 
//Конец 1С-Минск 

		Позиция = ?(ВыделятьСокращения, СтрДлина(СтрокаЧасти), 0);
		Пока Позиция > 0 Цикл
			Если Сред(СтрокаЧасти, Позиция, 1) = " " Тогда
				Результат.Добавить(Новый Структура("Наименование, Сокращение",
					СокрЛП(Лев(СтрокаЧасти, Позиция-1)), СокрЛП(Сред(СтрокаЧасти, Позиция))));
				Позиция = -1;
				Прервать;
			КонецЕсли;
			Позиция = Позиция - 1;
		КонецЦикла;
		Если Позиция = 0 Тогда
			Результат.Добавить(Новый Структура("Наименование, Сокращение", СтрокаЧасти));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции    

// Возвращает вариант адресного классификатора: "КЛАДР" или Неопределено.
// 
//
Функция ИспользуемыйАдресныйКлассификатор() Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	ЕстьПодсистемаАдресныйКлассификатор = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор");
#Иначе
	ЕстьПодсистемаАдресныйКлассификатор = ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор");
#КонецЕсли
	
	Если ЕстьПодсистемаАдресныйКлассификатор Тогда
		Возврат "КЛАДР";
	КонецЕсли;
	
	// Нет подсистемы, возможно нет и перечисления
	Возврат Неопределено;
КонецФункции

// Возвращает первый элемент из списка или Неопределено, если такого элемента нет
//
// Параметры:
//     СписокДанных - СписокЗначений, Массив, ПолеФормы
//
Функция ПервыйИлиПустой(Знач СписокДанных) Экспорт
	
	ТипСписка = ТипЗнч(СписокДанных);
	Если ТипСписка = Тип("СписокЗначений") И СписокДанных.Количество() > 0 Тогда
		Возврат СписокДанных[0].Значение;
	ИначеЕсли ТипСписка = Тип("Массив") И СписокДанных.Количество() > 0 Тогда
		Возврат СписокДанных[0];
	ИначеЕсли ТипСписка = Тип("ПолеФормы") Тогда
		Возврат ПервыйИлиПустой(СписокДанных.СписокВыбора);
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Возвращает признак того, хранит ли строка данные XML
//
// Параметры:
//     Текст - Строка - Проверяемая строка
//
Функция ЭтоСтрокаXML(Знач Текст) Экспорт
	// Упрощенная проверка
	Возврат ТипЗнч(Текст) = Тип("Строка") И Лев(СокрЛ(Текст),1) = "<";
КонецФункции

Функция ОбластнойЦентр(Наименование)
	//МиСофт+
	ОбластныеЦентры = Новый СписокЗначений;
	ОбластныеЦентры.Добавить("г. Брест", "г. Брест");
	ОбластныеЦентры.Добавить("г. Витебск", "г. Витебск");
	ОбластныеЦентры.Добавить("г. Гомель", "г. Гомель");
	ОбластныеЦентры.Добавить("г. Гродно", "г. Гродно");
	ОбластныеЦентры.Добавить("г. Минск", "г. Минск");
	ОбластныеЦентры.Добавить("г. Могилев", "г. Могилев");
	
	Возврат ОбластныеЦентры.НайтиПоЗначению(Наименование) <> Неопределено;
	//МиСофт-
КонецФункции

#КонецОбласти
