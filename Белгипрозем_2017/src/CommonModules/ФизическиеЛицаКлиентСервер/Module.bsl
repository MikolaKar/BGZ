////////////////////////////////////////////////////////////////////////////////
// Подсистема "Физические лица"
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция склоняет переданную фразу
// Параметры:
//  ФИО (обязательный), тип строка
//   Параметр должен содержать фамилию имя отчества в именительном падеже, которые необходимо просклонять.
//
//  Падеж (обязательный), тип число
//   Падеж, в который необходимо поставить ФИО.
//   1 - Именительный
//   2 - Родительный
//   3 - Дательный
//   4 - Винительный
//   5 - Творительный
//   6 - Предложный
//
//  Результат (обязательный), тип строка
//   Переменная, в которую будет возвращен результат склонения.
//
//  Пол (необязательный), тип число
//   Пол физического лица, 1 - мужской, 2 - женский
//
Функция Просклонять(Знач ФИО, Падеж, Результат, Пол = Неопределено) Экспорт
	
	ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаСклоненияФИО", "Decl");
	Компонента = Новый("AddIn.Decl.CNameDecl");
	
	Результат = "";
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ФИО, " ");
	
	// Выделим первые 3 слова, так как компонента не умеет склонять фразу большую 3х символов
	НомерНесклоняемогоСимвола = 4;
	Для Номер = 1 По Мин(МассивСтрок.Количество(), 3) Цикл
		Если Не ФИОНаписаноВерно(МассивСтрок[Номер-1], Истина) Тогда
			НомерНесклоняемогоСимвола = Номер;
			Прервать;
		КонецЕсли;

		Результат = Результат + ?(Номер > 1, " ", "") + МассивСтрок[Номер-1];
	КонецЦикла;
	
	Если ПустаяСтрока(Результат) Тогда
		Результат = ФИО;
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Если Пол = Неопределено Тогда
			Результат = Компонента.Просклонять(Результат, Падеж) + " ";
			
		Иначе
			Результат = Компонента.Просклонять(Результат, Падеж, Пол) + " ";
			
		КонецЕсли;
		
	Исключение
		Результат = ФИО;
		Возврат Ложь;
		
	КонецПопытки;
	
	// Остальные символы добавим без склонения
	Для Номер = НомерНесклоняемогоСимвола По МассивСтрок.Количество() Цикл
		Результат = Результат + " " + МассивСтрок[Номер-1];
	КонецЦикла;
	
	Результат = СокрЛП(Результат);
	
	Возврат Истина;
	
КонецФункции

// Функция раскладывает ФИО в структуру
//
// Параметры:
//		ФИО - строка - наименование
//
// Возвращаемое значение:
//		СтруктураФИО - Структура с полями: Фамилия, Имя, Отчество
//
Функция ФамилияИмяОтчество(Знач ФИО) Экспорт
	
	СтруктураФИО = Новый Структура("Фамилия, Имя, Отчество");
	
	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ФИО, " ");
	
	Если МассивПодстрок.Количество() > 0 Тогда
		СтруктураФИО.Вставить("Фамилия", МассивПодстрок[0]);
		Если МассивПодстрок.Количество() > 1 Тогда
			СтруктураФИО.Вставить("Имя", МассивПодстрок[1]);
		КонецЕсли;
		Если МассивПодстрок.Количество() > 2 Тогда
			Отчество = "";
			Для Шаг = 2 По МассивПодстрок.Количество()-1 Цикл
				Отчество = Отчество + МассивПодстрок[Шаг] + " ";
			КонецЦикла;
			СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Отчество, 1);
			СтруктураФИО.Вставить("Отчество", Отчество);
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураФИО;
	
КонецФункции

// Формирует фамилию и инициалы либо по переданным строкам.
//
// Параметры
//  ФИОСтрокой	- строка
//  Фамилия		- фамилия физического лица.
//  Имя			- имя физического лица.
//  Отчество	- отчество физического лица.
//
// Возвращаемое значение 
//  Строка - фамилия и инициалы одной строкой. 
//  В параметрах Фамилия, Имя и Отчество записываются вычисленные части.
//
// Пример:
//  Результат = ФамилияИнициалыФизЛица("Иванов Иван Иванович"); // Результат = "Иванов И. И."
//
Функция ФамилияИнициалыФизЛица(ФИОСтрокой = "", Фамилия = " ", Имя = " ", Отчество = " ", ИнициалыСправа = Истина) Экспорт

	ТипОбъекта = ТипЗнч(ФИОСтрокой);
	Если ТипОбъекта = Тип("Строка") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(СокрЛП(ФИОСтрокой)," .,");
	Иначе
		// используем возможно переданные отдельные строки
		Если Не ИнициалыСправа Тогда
			Если Не ПустаяСтрока(Фамилия) Тогда
				Результат = ?(Не ПустаяСтрока(Имя), Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество, 1) + ".", ""), "") + " " + Фамилия;
			КонецЕсли;
		Иначе
			Если Не ПустаяСтрока(Фамилия) Тогда
				Результат = Фамилия + ?(Не ПустаяСтрока(Имя), " " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество, 1) + ".", ""), ""); 
			КонецЕсли;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;
	
	КоличествоПодстрок = ФИО.Количество();
	Фамилия            = ?(КоличествоПодстрок > 0, ФИО[0], "");
	Имя                = ?(КоличествоПодстрок > 1, ФИО[1], "");
	Отчество           = ?(КоличествоПодстрок > 2, ФИО[2], "");
	
	Если Не инициалыСправа Тогда
		Если Не ПустаяСтрока(Фамилия) Тогда
			Результат = ?(Не ПустаяСтрока(Имя), Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество, 1) + ".", ""), "") + " " + Фамилия;
		КонецЕсли;
	Иначе
		Если Не ПустаяСтрока(Фамилия) Тогда
			Результат = Фамилия + ?(Не ПустаяСтрока(Имя), " " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество, 1) + ".", ""), ""); 
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет верно ли написано ФИО
// ФИО может быть написано либо только на кириллице, либо только на латинице
// Также можно указать, что ФИО может быть верным только в кириллице
//
// Параметры:
//		СтрокаПараметр - строка - ФИО
//		ДопустимаТолькоКириллица - если Истина, то ФИО проверяется на кириллицу, латиница в этом случае считается ошибкой.
//									Ложь - ФИО считается верным, если оно написано либо на латинице, либо на кириллице.
//
// Возвращаемое значение:
//		Истина - ФИО написано верно, иначе Ложь
//
Функция ФИОНаписаноВерно(Знач СтрокаПараметр, ТолькоКириллица = Ложь) Экспорт
	
	ДопустимыеСимволы = "-";
	
	Возврат (НЕ ТолькоКириллица И СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(СтрокаПараметр, Ложь, ДопустимыеСимволы)) Или
			СтроковыеФункцииКлиентСервер.ТолькоКириллицаВСтроке(СтрокаПараметр, Ложь, ДопустимыеСимволы);
	
КонецФункции

#КонецОбласти
