////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение файлов из Интернета"
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Добавление обработчиков служебных событий (подписок)

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"ПолучениеФайловИзИнтернетаСлужебный");
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистем"].Добавить(
		"ПолучениеФайловИзИнтернетаСлужебный");
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриВключенииИспользованияПрофилейБезопасности"].Добавить(
		"ПолучениеФайловИзИнтернетаСлужебный");
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "1.2.1.4";
	Обработчик.Процедура = "ПолучениеФайловИзИнтернетаСлужебный.ОбновитьХранимыеНастройкиПрокси";
	
КонецПроцедуры

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации.
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиентскойЛогикиСтандартныхПодсистем(Параметры) Экспорт
	
	Параметры.Вставить("НастройкиПроксиСервера", ПолучениеФайловИзИнтернета.ПолучитьНастройкуПроксиСервера());
	
КонецПроцедуры

// Вызывается при включении использования для информационной базы профилей безопасности.
//
Процедура ПриВключенииИспользованияПрофилейБезопасности() Экспорт
	
	// Сброс настроек прокси-сервера на системные.
	СохранитьНастройкиПроксиНаСервере1СПредприятие(Неопределено);
	
	ЗаписьЖурналаРегистрации(ПолучениеФайловИзИнтернетаКлиентСервер.СобытиеЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Предупреждение, Метаданные.Константы.НастройкаПроксиСервера,,
		НСтр("ru = 'При включении профилей безопасности настройки прокси-сервера сброшены на системные.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Сохраняет параметры настройки прокси сервера на стороне сервера 1С:Предприятие
//
Процедура СохранитьНастройкиПроксиНаСервере1СПредприятие(Знач Настройки) Экспорт
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение(НСтр("ru = 'Недостаточно прав для выполнения операции'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Константы.НастройкаПроксиСервера.Установить(Новый ХранилищеЗначения(Настройки));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Инициализирует новые настройки прокси-сервера "ИспользоватьПрокси"
// и "ИспользоватьСистемныеНастройки".
//
Процедура ОбновитьХранимыеНастройкиПрокси() Экспорт
	
	МассивПользователейИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	Для Каждого ПользовательИБ Из МассивПользователейИБ Цикл
		
		НастройкаПроксиСервера = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкаПроксиСервера", ,	, ,	ПользовательИБ.Имя);
		
		Если ТипЗнч(НастройкаПроксиСервера) = Тип("Соответствие") Тогда
			
			СохранитьНастройкиПользователя = Ложь;
			Если НастройкаПроксиСервера.Получить("ИспользоватьПрокси") = Неопределено Тогда
				НастройкаПроксиСервера.Вставить("ИспользоватьПрокси", Ложь);
				СохранитьНастройкиПользователя = Истина;
			КонецЕсли;
			Если НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки") = Неопределено Тогда
				НастройкаПроксиСервера.Вставить("ИспользоватьСистемныеНастройки", Ложь);
				СохранитьНастройкиПользователя = Истина;
			КонецЕсли;
			Если СохранитьНастройкиПользователя Тогда
				ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
					"НастройкаПроксиСервера", , НастройкаПроксиСервера, , ПользовательИБ.Имя);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	
	Если ТипЗнч(НастройкаПроксиСервера) = Тип("Соответствие") Тогда
		
		СохранитьНастройкиСервера = Ложь;
		Если НастройкаПроксиСервера.Получить("ИспользоватьПрокси") = Неопределено Тогда
			НастройкаПроксиСервера.Вставить("ИспользоватьПрокси", Ложь);
			СохранитьНастройкиСервера = Истина;
		КонецЕсли;
		Если НастройкаПроксиСервера.Получить("ИспользоватьСистемныеНастройки") = Неопределено Тогда
			НастройкаПроксиСервера.Вставить("ИспользоватьСистемныеНастройки", Ложь);
			СохранитьНастройкиСервера = Истина;
		КонецЕсли;
		Если СохранитьНастройкиСервера Тогда
			СохранитьНастройкиПроксиНаСервере1СПредприятие(НастройкаПроксиСервера);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
