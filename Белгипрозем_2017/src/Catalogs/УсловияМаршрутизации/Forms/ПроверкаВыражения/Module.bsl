
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИндексЗначенияПеречисления = Перечисления.ТипыОбъектов.Индекс(Параметры.ТипОбъекта);
	ИмяЗначенияПеречисления = Метаданные.Перечисления.ТипыОбъектов.ЗначенияПеречисления[ИндексЗначенияПеречисления].Имя;
	
	Элементы.Страницы.ТекущаяСтраница = 
		Элементы["Страница" + ИмяЗначенияПеречисления];
	РезультатПроверки = "";	
	ТекстВыражения = Параметры.Выражение;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокПроектныеЗадачи.Отбор,
		"Владелец",
		Справочники.Проекты.ПустаяСсылка(),
		ВидСравненияКомпоновкиДанных.Равно);
		
	ПоказыватьКолонкуРазмер = РаботаСФайламиВызовСервера.ПолучитьПоказыватьКолонкуРазмер();
	Если ПоказыватьКолонкуРазмер = Ложь Тогда
		Элементы.СписокФайлыРазмер.Видимость = Ложь;
	КонецЕсли;
	
	Если РаботаСФайламиВызовСервера.ПолучитьИспользоватьЭлектронныеПодписиИШифрование() = Ложь Тогда
		Элементы.СписокВнутренниеДокументыПодписан.Видимость = Ложь;
		Элементы.СписокВходящиеДокументыПодписан.Видимость = Ложь;
		Элементы.СписокИсходящиеДокументыПодписан.Видимость = Ложь;
		Элементы.СписокФайлыПодписан.Видимость = Ложь;
		Элементы.СписокФайлыЗашифрован.Видимость = Ложь;
	КонецЕсли;	
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьФайлыУВходящихДокументов") Тогда 
		Элементы.СписокВходящиеДокументыФайлы.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьФайлыУИсходящихДокументов") Тогда 
		Элементы.СписокИсходящиеДокументыФайлы.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыИЗадачи") Тогда 
		Элементы.СписокВнутренниеДокументыЗадачи.Видимость = Ложь;
		Элементы.СписокВходящиеДокументыЗадачи.Видимость = Ложь;
		Элементы.СписокИсходящиеДокументыЗадачи.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьВыражение()
	
	Результат = Неопределено;
	РезультатПроверки= "";
	
	Попытка
		Выполнить(ТекстВыражения);
	Исключение
		Результат = Ложь;
		Инфо = ИнформацияОбОшибке();
		
		Описание = "";
		Если ТипЗнч(Инфо.Причина) = Тип("ИнформацияОбОшибке") Тогда
			Описание = Инфо.Причина.Описание;
		Иначе
			Описание = Инфо.Описание;
		КонецЕсли;
		
		РезультатПроверки = НСтр("ru = 'Ошибка.") + Символы.ВК + Описание;
		Возврат;
	КонецПопытки;		
	
	Если ТипЗнч(Результат) <> Тип("Булево") Тогда
		РезультатПроверки = НСтр("ru = 'Ошибка.
			|Переменной ""Результат"" необходимо присвоить значение типа ""Булево""'");	
		Возврат;
	КонецЕсли;
	
	РезультатПроверки = ?(Результат, НСтр("ru = 'Истина'"), НСтр("ru = 'Ложь'"));
		
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПредмет(Ссылка)
	
	Предмет = Ссылка;
	Если ПроверятьАвтоматически Тогда
		ПроверитьВыражение();
	Иначе
		РезультатПроверки = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВнутренниеДокументыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Предмет <> Элемент.ТекущиеДанные.Ссылка Тогда
		ИзменитьПредмет(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВходящиеДокументыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Предмет <> Элемент.ТекущиеДанные.Ссылка Тогда
		ИзменитьПредмет(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИсходящиеДокументыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Предмет <> Элемент.ТекущиеДанные.Ссылка Тогда
		ИзменитьПредмет(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайлыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Предмет <> Элемент.ТекущиеДанные.Ссылка Тогда
		ИзменитьПредмет(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроектыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Предмет <> Элемент.ТекущиеДанные.Ссылка Тогда
		ИзменитьПредмет(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроектныеЗадачиПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Предмет <> Элемент.ТекущиеДанные.Ссылка Тогда
		ИзменитьПредмет(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыражениеВыполнить(Команда)
	
	ПроверитьВыражение();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть(ТекстВыражения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокПроектныеЗадачи.Отбор,
		"Владелец",
		Проект,
		ВидСравненияКомпоновкиДанных.Равно);
	
КонецПроцедуры



