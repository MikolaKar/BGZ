
// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаОбработка = ОбработкаОбъект();
	
	МестоЗапуска = Параметры.МестоЗапуска;
	
	// Заполнение формы необходимыми параметрами.
	ЗаполнитьФорму();
	
	// При пустом логине и пароле переопределяется заполнение имени пользователя и
	// пароля по умолчанию
	Если ПустаяСтрока(Логин) Тогда
		ДанныеПользователя = ИнтернетПоддержкаПользователейКлиентСервер.НовыйДанныеПользователяИнтернетПоддержки();
		ИнтернетПоддержкаПользователейСерверПереопределяемый.ПриОпределенииДанныхПользователяИнтернетПоддержки(
			ДанныеПользователя);
		Если ТипЗнч(ДанныеПользователя) = Тип("Структура") Тогда
			Если ДанныеПользователя.Свойство("Логин") Тогда
				Логин = ДанныеПользователя.Логин;
				Если ДанныеПользователя.Свойство("Пароль") Тогда
					Пароль = ДанныеПользователя.Пароль;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если МестоЗапуска <> "systemStart" И МестоЗапуска <> "systemStartNew" Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаПояснениеКЗаголовкуАвторизация.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаЗаполднеияКонтентеАвторизации.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если НЕ ПрограммноеЗакрытие Тогда
		ИнтернетПоддержкаПользователейКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СайтUsersПодключениеАвторизацииНажатие(Элемент)
	
	АдресСтраницы = "http://users.v8.1c.ru";
	ЗаголовокСтраницы = НСтр("ru = 'Поддержка пользователей системы 1С:Предприятие 8'");
	ИнтернетПоддержкаПользователейКлиентПереопределяемый.ЗапуститьИнтернетСтраницуВОбозревателе(АдресСтраницы,
		ЗаголовокСтраницы);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВосстановленияПароляАвторизацияНажатие(Элемент)
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "remindPassword", "true"));
	
	ИнтернетПоддержкаПользователейКлиент.ОбработкаКомандСервиса(КонтекстВзаимодействия, ЭтотОбъект, ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеЗаголовкаАвторизацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "TechSupport" Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыСообщения = Новый Структура("ТипСообщения, Логин", 1, Логин);
		ИнтернетПоддержкаПользователейКлиент.ОткрытьДиалогОтправкиЭлектронногоПисьма(
			КонтекстВзаимодействия,
			ПараметрыСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВойтиАвторизация(Команда)
	
	Если НЕ ЗаполнениеПолейКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	ИнтернетПоддержкаПользователейКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"login",
		Логин);
	ИнтернетПоддержкаПользователейКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"password",
		Пароль);
	ИнтернетПоддержкаПользователейКлиентСервер.ЗаписатьПараметрКонтекста(
		КонтекстВзаимодействия.КСКонтекст,
		"savePassword",
		?(СохранятьПароль, "true", "false"));
	
	// Сохранение логина и пароля пользователя, при успешной авторизации
	// будут переданы в метод
	// ИнтернетПоддержкаПользователейСерверПереопределяемый.ПриАвторизацииПользователяВИнтернетПоддержке()
	
	КонтекстВзаимодействия.КСКонтекст.Логин  = Логин;
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "login", Логин));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "password", Пароль));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "savePassword", ?(СохранятьПароль, "true", "false")));
	
	ИнтернетПоддержкаПользователейКлиент.ОбработкаКомандСервиса(КонтекстВзаимодействия, ЭтотОбъект, ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает значение внешней обработки.
//
// Возвращаемое значение: объект типа ВнешняяОбработка - внешняя обработка.
//
&НаСервере
Функция ОбработкаОбъект()
	
	Возврат РеквизитФормыВЗначение("Объект");
	
КонецФункции

// Выполняет начальное заполнение полей формы
&НаСервере
Процедура ЗаполнитьФорму()
	
	ЗаголовокПользователя = НСтр("ru = 'Логин:'") + " " + Параметры.login;
	
	Логин  = Параметры.login;
	Пароль = Параметры.password;
	
	СохранятьПароль = (Параметры.savePassword <> "false");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проверки на заполненность полей.

// Выполняет проверку заполненности полей Логин и Пароль
//
// Возвращаемое значение: Булево. Истина - поля заполнены Некорректно,
//		Ложь - в противном случае.
//
&НаКлиенте
Функция ЗаполнениеПолейКорректно()
	
	Если ПустаяСтрока(Логин) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнено поле ""Логин""'");
		Сообщение.Поле  = "Логин";
		Сообщение.Сообщить();
		Возврат Ложь;
		
	КонецЕсли;
	
	Если ПустаяСтрока(Пароль) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не заполнено поле ""Пароль""'");
		Сообщение.Поле  = "Пароль";
		Сообщение.Сообщить();
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
