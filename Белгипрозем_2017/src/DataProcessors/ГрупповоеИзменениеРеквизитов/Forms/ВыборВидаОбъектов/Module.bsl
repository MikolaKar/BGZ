#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КоллекцииОбъектовМетаданных = Новый Массив;
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.Справочники);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.Документы);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.БизнесПроцессы);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.Задачи);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.ПланыВидовРасчета);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.ПланыВидовХарактеристик);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.ПланыСчетов);
	КоллекцииОбъектовМетаданных.Добавить(Метаданные.ПланыОбмена);
	
	ПрефиксУдаляемыхОбъектов = "Удалить";
	
	Если ВерсияБСПСоответствуетТребованиям() Тогда
		МенеджерыОбъектов = МенеджерыОбъектовДляРедактированияРеквизитов();
	КонецЕсли;
	
	Для Каждого КоллекцияОбъектовМетаданных Из КоллекцииОбъектовМетаданных Цикл
		Для Каждого ОбъектМетаданных Из КоллекцияОбъектовМетаданных Цикл
			Если Не Параметры.ПоказыватьСкрытые Тогда
				Если НРег(Лев(ОбъектМетаданных.Имя, СтрДлина(ПрефиксУдаляемыхОбъектов))) = НРег(ПрефиксУдаляемыхОбъектов)
					Или ЭтоСлужебныйОбъект(ОбъектМетаданных, МенеджерыОбъектов) Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			Если ПравоДоступа("Изменение", ОбъектМетаданных) Тогда
				ДоступныеОбъектыДляИзменения.Добавить(ОбъектМетаданных.ПолноеИмя(), ОбъектМетаданных.Синоним);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	ДоступныеОбъектыДляИзменения.СортироватьПоПредставлению();
	
	Если Не ПустаяСтрока(Параметры.ТекущийОбъект) Тогда
		Элементы.ДоступныеОбъектыДляИзменения.ТекущаяСтрока = ДоступныеОбъектыДляИзменения.НайтиПоЗначению(Параметры.ТекущийОбъект).ПолучитьИдентификатор();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеОбъектыДляИзмененияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Закрыть(Элементы.ДоступныеОбъектыДляИзменения.ТекущиеДанные.Значение);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ТекущиеДанные = Элементы.ДоступныеОбъектыДляИзменения.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Закрыть(ТекущиеДанные.Значение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЭтоСлужебныйОбъект(ОбъектМетаданных, МенеджерыОбъектов)
	
	Если МенеджерыОбъектов <> Неопределено Тогда
		ДоступныеМетоды = МетодыМенеджераОбъектаДляРедактированияРеквизитов(ОбъектМетаданных.ПолноеИмя(), МенеджерыОбъектов);
		Если ТипЗнч(ДоступныеМетоды) = Тип("Массив") И (ДоступныеМетоды.Количество() = 0 ИЛИ 
			ДоступныеМетоды.Найти("РеквизитыРедактируемыеВГрупповойОбработке") <> Неопределено) Тогда
			
			МенеджерОбъекта = МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
			Редактируемые = МенеджерОбъекта.РеквизитыРедактируемыеВГрупповойОбработке();
		КонецЕсли;
		
	Иначе
		// В конфигурациях без БСП или на старых версиях БСП, пытаемся определить, 
		// есть ли у объекта редактируемые реквизиты.
		МенеджерОбъекта = МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
		Попытка
			Редактируемые = МенеджерОбъекта.РеквизитыРедактируемыеВГрупповойОбработке();
		Исключение
			// метод не найден
			Редактируемые = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	Если Редактируемые <> Неопределено И Редактируемые.Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	//
	
	Если МенеджерыОбъектов <> Неопределено Тогда
		Если ТипЗнч(ДоступныеМетоды) = Тип("Массив") И (ДоступныеМетоды.Количество() = 0 ИЛИ 
			ДоступныеМетоды.Найти("РеквизитыНеРедактируемыеВГрупповойОбработке") <> Неопределено) Тогда
			
			Если МенеджерОбъекта = Неопределено Тогда
				МенеджерОбъекта = МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
			КонецЕсли;	
			НеРедактируемые = МенеджерОбъекта.РеквизитыНеРедактируемыеВГрупповойОбработке();
		КонецЕсли;
		
	Иначе
		// В конфигурациях без БСП или на старых версиях БСП, пытаемся определить, 
		// есть ли у объекта нередактируемые реквизиты.
		Попытка
			НеРедактируемые = МенеджерОбъекта.РеквизитыНеРедактируемыеВГрупповойОбработке();
		Исключение
			// метод не найден
			НеРедактируемые = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	Если НеРедактируемые <> Неопределено И НеРедактируемые.Найти("*") <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервереБезКонтекста
Функция МетодыМенеджераОбъектаДляРедактированияРеквизитов(ИмяОбъекта, МенеджерыОбъектов)
	
	СведенияОМенеджереОбъекта = МенеджерыОбъектов[ИмяОбъекта];
	Если СведенияОМенеджереОбъекта = Неопределено Тогда
		Возврат "НеПоддерживается";
	КонецЕсли;
	ДоступныеМетоды = РазложитьСтрокуВМассивПодстрок(СведенияОМенеджереОбъекта, Символы.ПС, Истина);
	Возврат ДоступныеМетоды;
	
КонецФункции

&НаСервереБезКонтекста
Функция МенеджерыОбъектовДляРедактированияРеквизитов()
	
	МодульИнтеграцияСтандартныхПодсистем = ОбщийМодуль("ИнтеграцияСтандартныхПодсистем");
	МодульГрупповоеИзменениеОбъектовПереопределяемый = ОбщийМодуль("ГрупповоеИзменениеОбъектовПереопределяемый");
	Если МодульИнтеграцияСтандартныхПодсистем = Неопределено Или МодульГрупповоеИзменениеОбъектовПереопределяемый = Неопределено Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	ОбъектыСЗаблокированнымиРеквизитами = Новый Соответствие;
	МодульИнтеграцияСтандартныхПодсистем.ПриОпределенииОбъектовСРедактируемымиРеквизитами(ОбъектыСЗаблокированнымиРеквизитами);
	МодульГрупповоеИзменениеОбъектовПереопределяемый.ПриОпределенииОбъектовСРедактируемымиРеквизитами(ОбъектыСЗаблокированнымиРеквизитами);
	
	Возврат ОбъектыСЗаблокированнымиРеквизитами;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВерсияБСПСоответствуетТребованиям()
	
	Попытка
		МодульСтандартныеПодсистемыСервер = ОбщийМодуль("СтандартныеПодсистемыСервер");
	Исключение
		// Модуль не существует
		МодульСтандартныеПодсистемыСервер = Неопределено;
	КонецПопытки;
	Если МодульСтандартныеПодсистемыСервер = Неопределено Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	ВерсияБСП = МодульСтандартныеПодсистемыСервер.ВерсияБиблиотеки();
	Возврат НомерВерсииВЧисло(ВерсияБСП) >= НомерВерсииВЧисло("2.2.4.9");
	
КонецФункции

&НаСервереБезКонтекста
Функция НомерВерсииВЧисло(НомерВерсии)
	ЧастиНомера = РазложитьСтрокуВМассивПодстрок(НомерВерсии, ".", Истина);
	Если ЧастиНомера.Количество() <> 4 Тогда
		Возврат 0;
	КонецЕсли;
	Результат = 0;
	Для Каждого ЧастьНомера Из ЧастиНомера Цикл
		Результат = Результат * 1000 + Число(ЧастьНомера);
	КонецЦикла;
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции из базовой функциональности для обеспечения автономности.

&НаСервереБезКонтекста
Функция МенеджерОбъектаПоПолномуИмени(ПолноеИмя)
	Перем КлассОМ, ИмяОМ, Менеджер;
	
	ЧастиИмени = РазложитьСтрокуВМассивПодстрок(ПолноеИмя, ".");
	
	Если ЧастиИмени.Количество() = 2 Тогда
		КлассОМ = ЧастиИмени[0];
		ИмяОМ  = ЧастиИмени[1];
	КонецЕсли;
	
	Если      ВРег(КлассОМ) = "ПЛАНОБМЕНА" Тогда
		Менеджер = ПланыОбмена;
		
	ИначеЕсли ВРег(КлассОМ) = "СПРАВОЧНИК" Тогда
		Менеджер = Справочники;
		
	ИначеЕсли ВРег(КлассОМ) = "ДОКУМЕНТ" Тогда
		Менеджер = Документы;
		
	ИначеЕсли ВРег(КлассОМ) = "ЖУРНАЛДОКУМЕНТОВ" Тогда
		Менеджер = ЖурналыДокументов;
		
	ИначеЕсли ВРег(КлассОМ) = "ПЕРЕЧИСЛЕНИЕ" Тогда
		Менеджер = Перечисления;
		
	ИначеЕсли ВРег(КлассОМ) = "ОТЧЕТ" Тогда
		Менеджер = Отчеты;
		
	ИначеЕсли ВРег(КлассОМ) = "ОБРАБОТКА" Тогда
		Менеджер = Обработки;
		
	ИначеЕсли ВРег(КлассОМ) = "ПЛАНВИДОВХАРАКТЕРИСТИК" Тогда
		Менеджер = ПланыВидовХарактеристик;
		
	ИначеЕсли ВРег(КлассОМ) = "ПЛАНСЧЕТОВ" Тогда
		Менеджер = ПланыСчетов;
		
	ИначеЕсли ВРег(КлассОМ) = "ПЛАНВИДОВРАСЧЕТА" Тогда
		Менеджер = ПланыВидовРасчета;
		
	ИначеЕсли ВРег(КлассОМ) = "РЕГИСТРСВЕДЕНИЙ" Тогда
		Менеджер = РегистрыСведений;
		
	ИначеЕсли ВРег(КлассОМ) = "РЕГИСТРНАКОПЛЕНИЯ" Тогда
		Менеджер = РегистрыНакопления;
		
	ИначеЕсли ВРег(КлассОМ) = "РЕГИСТРБУХГАЛТЕРИИ" Тогда
		Менеджер = РегистрыБухгалтерии;
		
	ИначеЕсли ВРег(КлассОМ) = "РЕГИСТРРАСЧЕТА" Тогда
		Если ЧастиИмени.Количество() = 2 Тогда
			// Регистр расчета
			Менеджер = РегистрыРасчета;
		Иначе
			КлассПодчиненногоОМ = ЧастиИмени[2];
			ИмяПодчиненногоОМ = ЧастиИмени[3];
			Если ВРег(КлассПодчиненногоОМ) = "ПЕРЕРАСЧЕТ" Тогда
				// Перерасчет
				Менеджер = РегистрыРасчета[ИмяОМ].Перерасчеты;
			Иначе
				ВызватьИсключение ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Неизвестный тип объекта метаданных ""%1""'"), ПолноеИмя);
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ВРег(КлассОМ) = "БИЗНЕСПРОЦЕСС" Тогда
		Менеджер = БизнесПроцессы;
		
	ИначеЕсли ВРег(КлассОМ) = "ЗАДАЧА" Тогда
		Менеджер = Задачи;
		
	ИначеЕсли ВРег(КлассОМ) = "КОНСТАНТА" Тогда
		Менеджер = Константы;
		
	ИначеЕсли ВРег(КлассОМ) = "ПОСЛЕДОВАТЕЛЬНОСТЬ" Тогда
		Менеджер = Последовательности;
	КонецЕсли;
	
	Если Менеджер <> Неопределено Тогда
		Попытка
			Возврат Менеджер[ИмяОМ];
		Исключение
			Менеджер = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	ВызватьИсключение ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Неизвестный тип объекта метаданных ""%1""'"), ПолноеИмя);
	
КонецФункции

// Разбивает строку на несколько строк по разделителю. Разделитель может иметь любую длину.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями;
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ;
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//    Если параметр не задан, то функция работает в режиме совместимости со своей предыдущей версией:
//     - для разделителя-пробела пустые строки не включаются в результат, для остальных разделителей пустые строки
//       включаются в результат.
//     Е если параметр Строка не содержит значащих символов или не содержит ни одного символа (пустая строка), то в
//       случае разделителя-пробела результатом функции будет массив, содержащий одно значение "" (пустая строка), а
//       при других разделителях результатом функции будет пустой массив.
//
//
// Возвращаемое значение:
//  Массив - массив строк.
//
// Примеры:
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",") - возвратит массив из 5 элементов, три из которых  - пустые
//  строки;
//  РазложитьСтрокуВМассивПодстрок(",один,,два,", ",", Истина) - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок(" один   два  ", " ") - возвратит массив из двух элементов;
//  РазложитьСтрокуВМассивПодстрок("") - возвратит пустой массив;
//  РазложитьСтрокуВМассивПодстрок("",,Ложь) - возвратит массив с одним элементом "" (пустой строкой);
//  РазложитьСтрокуВМассивПодстрок("", " ") - возвратит массив с одним элементом "" (пустой строкой);
//
&НаКлиентеНаСервереБезКонтекста
Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено)
	
	Результат = Новый Массив;
	
	// Для обеспечения обратной совместимости.
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Результат.Добавить(Подстрока);
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Результат.Добавить(Строка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

// Подставляет параметры в строку. 
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров начинается с единицы.
//
// Параметры:
//  СтрокаПодстановки  - Строка - шаблон строки с параметрами (вхождениями вида "%ИмяПараметра");
//  Параметр<n>        - Строка - подставляемый параметр.
//
// Возвращаемое значение:
//  Строка   - текстовая строка с подставленными параметрами.
//
// Пример:
//  ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), "Вася", "Зоопарк") = "Вася пошел в Зоопарк".
//
&НаКлиентеНаСервереБезКонтекста
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено)
	
	ИспользоватьАльтернативныйАлгоритм = 
		Найти(Параметр1, "%")
		Или Найти(Параметр2, "%")
		Или Найти(Параметр3, "%");
		
	Если ИспользоватьАльтернативныйАлгоритм Тогда
		СтрокаПодстановки = ПодставитьПараметрыВСтрокуАльтернативныйАлгоритм(СтрокаПодстановки, Параметр1,
			Параметр2, Параметр3);
	Иначе
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%1", Параметр1);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%2", Параметр2);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%3", Параметр3);
	КонецЕсли;
	
	Возврат СтрокаПодстановки;
КонецФункции

// Вставляет параметры в строку, учитывая, что в параметрах могут использоваться подстановочные слова %1, %2 и т.д.
&НаКлиентеНаСервереБезКонтекста
Функция ПодставитьПараметрыВСтрокуАльтернативныйАлгоритм(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено)
	
	Результат = "";
	Позиция = Найти(СтрокаПодстановки, "%");
	Пока Позиция > 0 Цикл 
		Результат = Результат + Лев(СтрокаПодстановки, Позиция - 1);
		СимволПослеПроцента = Сред(СтрокаПодстановки, Позиция + 1, 1);
		ПодставляемыйПараметр = "";
		Если СимволПослеПроцента = "1" Тогда
			ПодставляемыйПараметр =  Параметр1;
		ИначеЕсли СимволПослеПроцента = "2" Тогда
			ПодставляемыйПараметр =  Параметр2;
		ИначеЕсли СимволПослеПроцента = "3" Тогда
			ПодставляемыйПараметр =  Параметр3;
		КонецЕсли;
		Если ПодставляемыйПараметр = "" Тогда
			Результат = Результат + "%";
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 1);
		Иначе
			Результат = Результат + ПодставляемыйПараметр;
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 2);
		КонецЕсли;
		Позиция = Найти(СтрокаПодстановки, "%");
	КонецЦикла;
	Результат = Результат + СтрокаПодстановки;
	
	Возврат Результат;
КонецФункции

// Возвращает ссылку на общий модуль по имени.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "ОбщегоНазначения",
//                 "ОбщегоНазначенияКлиент".
//
// Возвращаемое значение:
//  ОбщийМодуль.
//
&НаКлиентеНаСервереБезКонтекста
Функция ОбщийМодуль(Имя)
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Если Метаданные.ОбщиеМодули.Найти(Имя) <> Неопределено Тогда
		Модуль = Вычислить(Имя);
	Иначе
		Модуль = Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
		ВызватьИсключение ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Общий модуль ""%1"" не найден.'"), Имя);
	КонецЕсли;
#Иначе
	Модуль = Вычислить(Имя);
#Если НЕ ВебКлиент Тогда
	Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
		ВызватьИсключение ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Общий модуль ""%1"" не найден.'"), Имя);
	КонецЕсли;
#КонецЕсли
#КонецЕсли
	
	Возврат Модуль;
	
КонецФункции

&НаСервереБезКонтекста
Функция ИменаПодчиненныхПодсистем(РодительскаяПодсистема)
	
	Имена = Новый Соответствие;
	
	Для Каждого ТекущаяПодсистема Из РодительскаяПодсистема.Подсистемы Цикл
		
		Имена.Вставить(ТекущаяПодсистема.Имя, Истина);
		ИменаПодчиненных = ИменаПодчиненныхПодсистем(ТекущаяПодсистема);
		
		Для каждого ИмяПодчиненной Из ИменаПодчиненных Цикл
			Имена.Вставить(ТекущаяПодсистема.Имя + "." + ИмяПодчиненной.Ключ, Истина);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Имена;
	
КонецФункции

#КонецОбласти
