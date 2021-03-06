
// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ДекорацияЗаголовокИмя.Ширина = 8;
		Элементы.ДекорацияЗаголовокГород.Ширина = 8;
		Элементы.ГруппаПоясненияКЗаголовку.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаКонтента.Отображение = ОтображениеОбычнойГруппы.Нет;
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
Процедура ЛогинПриИзменении(Элемент)
	
	Логин = СокрЛП(Логин);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектроннаяПочтаПриИзменении(Элемент)
	
	ЭлектроннаяПочта = СокрЛП(ЭлектроннаяПочта);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеКЗаголовкуДваОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	Если НавигационнаяСсылка = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		ПараметрыПередачи = Новый Структура("ТипСообщения", 8);
		ПараметрыПередачи.Вставить("login"      , Логин);
		ПараметрыПередачи.Вставить("Email"      , ЭлектроннаяПочта);
		ПараметрыПередачи.Вставить("Фамилия"    , Фамилия);
		ПараметрыПередачи.Вставить("Имя"        , Имя);
		ПараметрыПередачи.Вставить("Отчетсво"   , Отчетсво);
		ПараметрыПередачи.Вставить("Город"      , Город);
		ПараметрыПередачи.Вставить("Телефон"    , Телефон);
		ПараметрыПередачи.Вставить("МестоРаботы", МестоРаботы);
		
		ИнтернетПоддержкаПользователейКлиент.ОткрытьДиалогОтправкиЭлектронногоПисьма(
			КонтекстВзаимодействия,
			ПараметрыПередачи);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗарегистрироватьсяИВойти(Команда)
	
	Если НЕ ЗаполнениеПолейКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "login"      , Логин));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "password"   , Пароль));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "email"      , ЭлектроннаяПочта));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "SecondName" , Фамилия));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "FirstName"  , Имя));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "MiddleName" , Отчетсво));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "City"       , Город));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "phoneNumber", Телефон));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "workPlace"  , МестоРаботы));
	
	ИнтернетПоддержкаПользователейКлиент.ОбработкаКомандСервиса(
		КонтекстВзаимодействия,
		ЭтотОбъект,
		ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СообщитьПользователю(ТекстСообщения, ИмяПоля, Отказ)
	
	Отказ = Истина;
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Поле  = ИмяПоля;
	Сообщение.Сообщить();
	
КонецПроцедуры

// Выполняет проверку заполненности полей формы
//
// Возвращаемое значение: Булево. Истина - поля заполнены Некорректно,
//		Ложь - в противном случае.
//
&НаКлиенте
Функция ЗаполнениеПолейКорректно()
	
	Отказ = Ложь;
	
	Если ПустаяСтрока(Логин) Тогда
		СообщитьПользователю(
			НСтр("ru = 'Поле ""Логин"" не заполнено.'"),
			"Логин",
			Отказ);
	КонецЕсли;
	
	Если ПустаяСтрока(Пароль) Тогда
		СообщитьПользователю(
			НСтр("ru = 'Поле ""Пароль"" не заполнено.'"),
			"Пароль",
			Отказ);
	ИначеЕсли Пароль <> ПарольПодтверждение Тогда
		СообщитьПользователю(
			НСтр("ru = 'Не совпадают пароль и его подтверждение.'"),
			"ПарольПодтверждение",
			Отказ);
	КонецЕсли;
	
	Если ПустаяСтрока(ЭлектроннаяПочта) Тогда
		СообщитьПользователю(
			НСтр("ru = 'Поле ""E-mail"" не заполнено.'"),
			"ЭлектроннаяПочта",
			Отказ);
	КонецЕсли;
	
	Возврат (НЕ Отказ);
	
КонецФункции

#КонецОбласти
