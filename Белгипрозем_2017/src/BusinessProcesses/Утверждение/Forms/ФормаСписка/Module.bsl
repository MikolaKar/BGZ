////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьОтбор()
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоАвтору", ПоАвтору);
	ПараметрыОтбора.Вставить("ПоИсполнителю", ПоИсполнителю);
	ПараметрыОтбора.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	ПараметрыОтбора.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	Параметрыотбора.Вставить("ПоказыватьТолькоАктивныеПроцессы", ПоказыватьТолькоАктивныеПроцессы);
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда
		ПараметрыОтбора.Вставить("ПоПроекту", ПоПроекту);
	КонецЕсли;
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	ПоАвтору = ПараметрыОтбора["ПоАвтору"];
	Если Не ЗначениеЗаполнено(ПоАвтору) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Автор");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Автор", ПоАвтору);
	КонецЕсли;
	
	
	ПоИсполнителю = ПараметрыОтбора["ПоИсполнителю"];
	ОсновнойОбъектАдресации = ПараметрыОтбора["ОсновнойОбъектАдресации"];
	ДополнительныйОбъектАдресации = ПараметрыОтбора["ДополнительныйОбъектАдресации"];
	
	Если Не ЗначениеЗаполнено(ПоИсполнителю) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Исполнитель");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ОсновнойОбъектАдресации");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ДополнительныйОбъектАдресации");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Исполнитель", ПоИсполнителю);
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ОсновнойОбъектАдресации");
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ДополнительныйОбъектАдресации");
		
		Если ТипЗнч(ПоИсполнителю) = Тип("СправочникСсылка.РолиИсполнителей") Тогда 
			Если ЗначениеЗаполнено(ОсновнойОбъектАдресации) Тогда  
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
			КонецЕсли;
			Если ЗначениеЗаполнено(ДополнительныйОбъектАдресации) Тогда  
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда
		Если ПараметрыОтбора["ПоПроекту"] <> Неопределено 
			И ПараметрыОтбора["ПоПроекту"].Пустая() Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Проект");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, 
				"Проект", ПараметрыОтбора["ПоПроекту"]);
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Завершен");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Состояние");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		Список.Отбор, "СтартПроцессаОтложен");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ПометкаУдаления");

	Если ПараметрыОтбора["ПоказыватьТолькоАктивныеПроцессы"] Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Завершен", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ПометкаУдаления", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор, 
			"Состояние", 
			Перечисления.СостоянияБизнесПроцессов.Прерван, 
			ВидСравненияКомпоновкиДанных.НеРавно);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор, 
			"СтартПроцессаОтложен",
			Ложь);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	
	РаботаСБизнесПроцессами.УстановитьФорматДаты(Элементы.СрокИсполнения);
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеБизнесПроцессов(Список.УсловноеОформление);
	
	Если ПоИсполнителю = Неопределено Тогда 
		ПоИсполнителю = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "БизнесПроцессИзменен" Тогда
		
		Элементы.Список.Обновить();
		
		РаботаСБизнесПроцессамиКлиент.
			УстановитьДоступностьКнопокИзмененияСостоянияПроцессов(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПоАвторуПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьИсполнителя(Элемент, ПоИсполнителю,,,,,
		ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		
		ПоИсполнителю = ВыбранноеЗначение.РольИсполнителя;
		ОсновнойОбъектАдресации = ВыбранноеЗначение.ОсновнойОбъектАдресации;
		ДополнительныйОбъектАдресации = ВыбранноеЗначение.ДополнительныйОбъектАдресации;
		
		УстановитьОтбор();
	Иначе  
		ОсновнойОбъектАдресации = Неопределено;
		ДополнительныйОбъектАдресации = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюПриИзменении(Элемент)
	
	ОписаниеОповещения =
		Новый ОписаниеОповещения("ПоИсполнителюПриИзмененииЗавершение", ЭтаФорма);
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьОбъектыАдресацииРоли(
		ЭтаФорма,
		"ПоИсполнителю",
		"ОсновнойОбъектАдресации",
		"ДополнительныйОбъектАдресации",
		ЭтаФорма,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюПриИзмененииЗавершение(Результат, Параметры) Экспорт
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПоИсполнителю = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьТолькоАктивныеПроцессыПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура Остановить(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.Остановить(Элементы.Список.ВыделенныеСтроки, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБизнесПроцесс(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.СделатьАктивным(Элементы.Список.ВыделенныеСтроки, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПовторение(Команда)
	
	ПовторениеБизнесПроцессовКлиент.НастроитьПовторение(Элементы.Список.ТекущаяСтрока, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПроектуПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьДоступностьКоманд", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьКоманд()
	
	РаботаСБизнесПроцессамиКлиент.
		УстановитьДоступностьКнопокИзмененияСостоянияПроцессов(ЭтаФорма);
	
КонецПроцедуры
