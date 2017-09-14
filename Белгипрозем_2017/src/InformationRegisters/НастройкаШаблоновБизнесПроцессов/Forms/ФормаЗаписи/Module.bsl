
&НаКлиенте
Процедура УстановитьДоступность()
	
	Если ВариантЗаданияОрганизации = 0 Тогда
		Элементы.Организация.Доступность = Ложь;
	Иначе
		Элементы.Организация.Доступность = Истина;
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Функция ПолучитьТипыОбъекта()
	
	СписокТипов = Новый СписокЗначений;
	ТипыОбъекта = Метаданные.РегистрыСведений.НастройкаШаблоновБизнесПроцессов.Измерения.ШаблонБизнесПроцесса.Тип.Типы();
	
	Для Каждого ТипОбъекта Из ТипыОбъекта Цикл
		ОбъектСсылка = Новый(ТипОбъекта);
  СписокТипов.Добавить(ОбъектСсылка.Метаданные().Имя, ОбъектСсылка.Метаданные().Синоним);
	КонецЦикла;	
	СписокТипов.СортироватьПоПредставлению();
	
	Возврат СписокТипов;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Запись.Организация) Тогда 
		ВариантЗаданияОрганизации = 1;
	Иначе
		ВариантЗаданияОрганизации = 0;
	КонецЕсли;	
	
	СписокТипов = ПолучитьТипыОбъекта();
	
	ЗаполнитьСписокСобытий();
	
	Элементы.ВидИнтерактивногоСобытия.Доступность = Запись.ИнтерактивныйЗапуск;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокСобытий()
	
	// заполним интерактивные события
	Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Очистить();
	Если ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда
		Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Добавить(Перечисления.ВидыИнтерактивныхДействий.ЗакрытиеКарточкиТолькоЧтоСозданногоВнутреннегоДокумента);
		Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Добавить(Перечисления.ВидыИнтерактивныхДействий.ИнтерактивнаяРегистрацияВнутреннегоДокумента);
	ИначеЕсли ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыВходящихДокументов") Тогда
		Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Добавить(Перечисления.ВидыИнтерактивныхДействий.ЗакрытиеКарточкиТолькоЧтоСозданногоВходящегоДокумента);
		Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Добавить(Перечисления.ВидыИнтерактивныхДействий.ИнтерактивнаяРегистрацияВходящегоДокумента);
	ИначеЕсли ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
		Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Добавить(Перечисления.ВидыИнтерактивныхДействий.ЗакрытиеКарточкиТолькоЧтоСозданногоИсходящегоДокумента);
		Элементы.ВидИнтерактивногоСобытия.СписокВыбора.Добавить(Перечисления.ВидыИнтерактивныхДействий.ИнтерактивнаяРегистрацияИсходящегоДокумента);
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПравилаАвтоматическогоЗапускаБизнесПроцессов.ШаблонБизнесПроцесса КАК ШаблонБизнесПроцесса,
		|	ПравилаАвтоматическогоЗапускаБизнесПроцессов.ВидБизнесСобытия КАК ВидБизнесСобытия,
		|	ПравилаАвтоматическогоЗапускаБизнесПроцессов.Условие
		|ИЗ
		|	РегистрСведений.ПравилаАвтоматическогоЗапускаБизнесПроцессов КАК ПравилаАвтоматическогоЗапускаБизнесПроцессов
		|ГДЕ
		|	ПравилаАвтоматическогоЗапускаБизнесПроцессов.ШаблонБизнесПроцесса = &ШаблонБизнесПроцесса
		|	И (ПравилаАвтоматическогоЗапускаБизнесПроцессов.ОрганизацияИсточникаБизнесСобытия = &Организация
		|			ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
		|	И ПравилаАвтоматическогоЗапускаБизнесПроцессов.КлассИсточникаБизнесСобытия = &КлассИсточникаБизнесСобытия";
				
	Запрос.УстановитьПараметр("ШаблонБизнесПроцесса", Запись.ШаблонБизнесПроцесса);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		Запрос.УстановитьПараметр("Организация", Запись.Организация);
	Иначе
		Запрос.УстановитьПараметр("Организация", Неопределено);
	КонецЕсли;
	Запрос.УстановитьПараметр("КлассИсточникаБизнесСобытия", Запись.ВидДокумента);
	
	Таблица = Запрос.Выполнить().Выгрузить();	
	
	Выборка = Справочники.ВидыБизнесСобытий.Выбрать();
	
	ВидыБизнесСобытий.Очистить();
	ВсеВидыБизнесСобытий.Очистить();
	Пока Выборка.Следующий() Цикл
		
		Если Не Выборка.ЭтоГруппа Тогда
			
			ВсеВидыБизнесСобытий.Добавить(Выборка.Ссылка);
			
			ВидСобытияИмя = Выборка.Ссылка.Наименование;
			НужноДобавить = Ложь;
			
			Если ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда
			 
			Если Выборка.Ссылка = Справочники.ВидыБизнесСобытий.СозданиеВнутреннегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.ИзменениеВнутреннегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.РегистрацияВнутреннегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.ПеререгистрацияВнутреннегоДокумента Тогда
				НужноДобавить = Истина;
			КонецЕсли;	
			 
			ИначеЕсли ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыВходящихДокументов") Тогда
			 
			Если Выборка.Ссылка = Справочники.ВидыБизнесСобытий.СозданиеВходящегоДокумента Тогда
				НужноДобавить = Истина;
			ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.ИзменениеВходящегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.РегистрацияВходящегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.ПеререгистрацияВходящегоДокумента Тогда
				НужноДобавить = Истина;
			 КонецЕсли;	
			 
			ИначеЕсли ТипЗнч(Запись.ВидДокумента) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
			 
			Если Выборка.Ссылка = Справочники.ВидыБизнесСобытий.СозданиеИсходящегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.ИзменениеИсходящегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.РегистрацияИсходящегоДокумента Тогда
				НужноДобавить = Истина;
			 ИначеЕсли Выборка.Ссылка = Справочники.ВидыБизнесСобытий.ПеререгистрацияИсходящегоДокумента Тогда
				НужноДобавить = Истина;
			 КонецЕсли;	
	 	 	  
			КонецЕсли;	
			
			Если НужноДобавить Тогда
				Строка = ВидыБизнесСобытий.Добавить();
				Строка.Значение = Выборка.Ссылка;
				Строка.Представление = Выборка.Наименование;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;		
	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		
		Отбор = Новый Структура("Значение", СтрокаТаблицы.ВидБизнесСобытия);
		МассивСтрок = ВидыБизнесСобытий.НайтиСтроки(Отбор);
		Если МассивСтрок.Количество() = 1 Тогда
			МассивСтрок[0].Пометка = Истина;
			МассивСтрок[0].Загружено = Истина;
			МассивСтрок[0].Условие = СтрокаТаблицы.Условие;
		КонецЕсли;
	
	КонецЦикла;	
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗаданияОрганизацииПриИзменении(Элемент)
	
	Если ВариантЗаданияОрганизации = 0 Тогда
		Запись.Организация = Неопределено;
	КонецЕсли;	
	
	Элементы.Организация.АвтоОтметкаНезаполненного = (ВариантЗаданияОрганизации <> 0);
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") И (ВариантЗаданияОрганизации = 1) И Не ЗначениеЗаполнено(Запись.Организация) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Организация""!'"),,
			"Запись.Организация",, 
			Отказ);
	КонецЕсли;	
	
	Если Запись.ИнтерактивныйЗапуск И Не ЗначениеЗаполнено(Запись.ВидИнтерактивногоСобытия) Тогда	
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Действие""!'"),,
			"Запись.ВидИнтерактивногоСобытия",, 
			Отказ);
		
	КонецЕсли;	
	
	ЕстьПомеченные = Ложь;
	Для Каждого Строка Из ВидыБизнесСобытий Цикл
		
		Если Строка.Пометка Тогда
			ЕстьПомеченные = Истина;
			Прервать;
		КонецЕсли;	
		
	КонецЦикла;
	
	Если ЕстьПомеченные И ЗначениеЗаполнено(Запись.ШаблонБизнесПроцесса) Тогда
		
		ШаблонОбъект = Запись.ШаблонБизнесПроцесса.ПолучитьОбъект();
		
		МассивПолей = ШаблонОбъект.ПолучитьСписокНезаполненныхПолейНеобходимыхДляСтарта();
		Если МассивПолей.Количество() <> 0 Тогда
			
			СтрокаПолей = БизнесСобытияВызовСервера.МассивПолейВСтроку(МассивПолей);
		
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Шаблон нельзя использовать для автоматического запуска процессов, т.к. не заполнены поля: %1'"),
				СтрокаПолей);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,,
				"Запись.ШаблонБизнесПроцесса",, 
				Отказ);
		
		КонецЕсли;
		
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Запись.ШаблонБизнесПроцесса) И ЗначениеЗаполнено(Запись.ВидДокумента) Тогда
		Если Не ПроверитьСовместимостьШаблонаИВидаДокумента(
				Запись.ШаблонБизнесПроцесса, 
				Запись.ВидДокумента) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Указанный предмет не может быть использован в указанном процессе.'"),,
				"Запись.ВидДокумента",, 
				Отказ);
		КонецЕсли;			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонБизнесПроцессаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Запись.ШаблонБизнесПроцесса) Тогда 
		Возврат;
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ШаблонБизнесПроцессаНачалоВыбораПродолжение",
		ЭтотОбъект,
		Новый Структура("Элемент", Элемент));
			
	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокТипов, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонБизнесПроцессаНачалоВыбораПродолжение(ВыбранныйТип, Параметры) Экспорт 

	Если ВыбранныйТип <> Неопределено Тогда 
		ОткрытьФорму("Справочник." + ВыбранныйТип.Значение + ".ФормаВыбора", , Параметры.Элемент);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	//  делается запись в регистр ПодпискиАвтоматическогоЗапускаБизнесПроцессов.
		
	Для Каждого Строка Из ВсеВидыБизнесСобытий Цикл
		
		Если ЗначениеЗаполнено(ВидДокументаПриОткрытии) И ЗначениеЗаполнено(ШаблонБизнесПроцессаПриОткрытии) Тогда
			БизнесСобытияВызовСервера.УдалитьПравилоАвтоматическогоЗапускаБизнесПроцессов(
				Строка.Значение, ШаблонБизнесПроцессаПриОткрытии, ВидДокументаПриОткрытии, ОрганизацияПриОткрытии);
		КонецЕсли;	
		
		БизнесСобытияВызовСервера.УдалитьПравилоАвтоматическогоЗапускаБизнесПроцессов(
			Строка.Значение, Запись.ШаблонБизнесПроцесса, Запись.ВидДокумента, Запись.Организация);
			
		Отбор = Новый Структура("Значение", Строка.Значение);
		МассивСтрок = ВидыБизнесСобытий.НайтиСтроки(Отбор);
		Если МассивСтрок.Количество() = 1 Тогда
			
			Если МассивСтрок[0].Пометка Тогда
				БизнесСобытияВызовСервера.СохранитьПравилоАвтоматическогоЗапускаБизнесПроцессов(
					Строка.Значение, Запись.ШаблонБизнесПроцесса, Запись.ВидДокумента, МассивСтрок[0].Условие, 
					Запись.Организация);
				Продолжить;
			КонецЕсли;	
			
		КонецЕсли;
			
	КонецЦикла;
		
	ЗаполнитьСписокСобытий();	
	
	ТекстПредупреждения = "";
	ИспользоватьУчетПоОрганизациям = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям");
	Если ИспользоватьУчетПоОрганизациям Тогда
		
		Для Каждого Строка Из ВидыБизнесСобытий Цикл
			
			ВидСобытия = Строка.Значение;
			
			НастройкиДляПустойОрганизации = ПолучитьНастройкиАвтозапускаПроцессов(Истина, ВидСобытия);
			НастройкиДляНеПустойОрганизации = ПолучитьНастройкиАвтозапускаПроцессов(Ложь, ВидСобытия);
			
			Если НастройкиДляПустойОрганизации.Количество() <> 0 
				И НастройкиДляНеПустойОрганизации.Количество() <> 0 Тогда
				
				Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
					ТекстПредупреждения = ТекстПредупреждения + Символы.ПС;
				КонецЕсли;
				
				СтрокаПолей = "";
				МассивОрганизаций = НастройкиДляНеПустойОрганизации.ВыгрузитьКолонку("ОрганизацияИсточникаБизнесСобытия");
				Для Каждого Организация Из МассивОрганизаций Цикл
					Если ЗначениеЗаполнено(СтрокаПолей) Тогда
						СтрокаПолей = СтрокаПолей + "; ";
					КонецЕсли;
					СтрокаПолей = СтрокаПолей + Строка(Организация);
				КонецЦикла;	

				Если НастройкиДляНеПустойОрганизации.Количество() = 1 Тогда
					ТекстПредупреждения = ТекстПредупреждения 
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Автозапуск процессов уже настроен для всех организаций. 
							|Настройка для конкретной организации (""%1"") при этом недействительна. 
							|Проверьте настройки еще раз.'"),
							СтрокаПолей);
				Иначе
					ТекстПредупреждения = ТекстПредупреждения 
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Автозапуск процессов уже настроен для всех организаций. 
							|Настройка для конкретных организаций (""%1"") при этом недействительна. 
							|Проверьте настройки еще раз.'"),
							СтрокаПолей);
				КонецЕсли;	
				
			КонецЕсли;	
			
		КонецЦикла;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНастройкиАвтозапускаПроцессов(ТолькоДляПустойОрганизации, ВидСобытия)
	
	Запрос = Новый Запрос;
	
	// в запросе объединяем данные для конкретной и для пустой организации
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПравилаАвтоматическогоЗапускаБизнесПроцессов.ОрганизацияИсточникаБизнесСобытия КАК ОрганизацияИсточникаБизнесСобытия
		|ИЗ
		|	РегистрСведений.ПравилаАвтоматическогоЗапускаБизнесПроцессов КАК ПравилаАвтоматическогоЗапускаБизнесПроцессов
		|ГДЕ
		|	ПравилаАвтоматическогоЗапускаБизнесПроцессов.ВидБизнесСобытия = &ВидБизнесСобытия
		|	И ПравилаАвтоматическогоЗапускаБизнесПроцессов.ШаблонБизнесПроцесса = &ШаблонБизнесПроцесса
		|	И ПравилаАвтоматическогоЗапускаБизнесПроцессов.КлассИсточникаБизнесСобытия = &КлассИсточникаБизнесСобытия";
		
	Если ТолькоДляПустойОрганизации = Истина Тогда
		Запрос.Текст = Запрос.Текст + 
			"	И ПравилаАвтоматическогоЗапускаБизнесПроцессов.ОрганизацияИсточникаБизнесСобытия = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
	Иначе		
		Запрос.Текст = Запрос.Текст + 
			"	И ПравилаАвтоматическогоЗапускаБизнесПроцессов.ОрганизацияИсточникаБизнесСобытия <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
	КонецЕсли;	
		
	Запрос.УстановитьПараметр("ВидБизнесСобытия", ВидСобытия);
	Запрос.УстановитьПараметр("ШаблонБизнесПроцесса", Запись.ШаблонБизнесПроцесса);
	Запрос.УстановитьПараметр("КлассИсточникаБизнесСобытия", Запись.ВидДокумента);
	
	РезультатЗапроса = Запрос.Выполнить();
	Таблица = РезультатЗапроса.Выгрузить();
	Возврат Таблица;
	
КонецФункции	

&НаСервере
// Сохраняет в регистре сведений ПравилаАвтоматическогоЗапускаБизнесПроцессов подписку
Функция ПолучитьКлюч(ВидСобытия, ШаблонБизнесПроцесса, Подписчик, Организация)
	
	ПараметрыКлюча = Новый Структура("ВидБизнесСобытия, ШаблонБизнесПроцесса, КлассИсточникаБизнесСобытия, ОрганизацияИсточникаБизнесСобытия", 
		ВидСобытия, ШаблонБизнесПроцесса, Подписчик, Организация);
	Ключ = РегистрыСведений.ПравилаАвтоматическогоЗапускаБизнесПроцессов.СоздатьКлючЗаписи(ПараметрыКлюча);
	Возврат Ключ;
	
КонецФункции

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	ЗаполнитьСписокСобытий();
КонецПроцедуры

&НаКлиенте
Процедура ПредлагатьЗапускПользователюПриИзменении(Элемент)
	
	Элементы.ВидИнтерактивногоСобытия.Доступность = Запись.ИнтерактивныйЗапуск;
	Элементы.ВидИнтерактивногоСобытия.АвтоОтметкаНезаполненного = Запись.ИнтерактивныйЗапуск;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыБизнесСобытийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не Элементы.ВидыБизнесСобытий.ТекущиеДанные.Пометка Тогда
		Возврат;
	КонецЕсли;	
	
	Если Поле = Элементы.ВидыБизнесСобытийУсловие Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыборУсловияМаршрутизации", ЭтотОбъект);
			
		ОткрытьФорму("Справочник.УсловияМаршрутизации.ФормаВыбора", , Элементы.ВидыБизнесСобытийУсловие,,,,
			ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);		
		Возврат;
		
	КонецЕсли;	
	
	Если Не Элементы.ВидыБизнесСобытий.ТекущиеДанные.Загружено Тогда
		Возврат;
	КонецЕсли;	
	
	// открыть запись регистра сведений ПравилаАвтоматическогоЗапускаБизнесПроцессов
	ВидСобытия = Элементы.ВидыБизнесСобытий.ТекущиеДанные.Значение;
	ШаблонБизнесПроцесса = Запись.ШаблонБизнесПроцесса;
	
	Ключ = ПолучитьКлюч(ВидСобытия, ШаблонБизнесПроцесса, Запись.ВидДокумента, Запись.Организация);
	ОписаниеВыбора = Новый ОписаниеОповещения("ВидыБизнесСобытийВыборПродолжение", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("Ключ", Ключ);
	ОткрытьФорму("РегистрСведений.ПравилаАвтоматическогоЗапускаБизнесПроцессов.ФормаЗаписи",
		ПараметрыФормы,
		ЭтаФорма,,,,
		ОписаниеВыбора,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборУсловияМаршрутизации(Результат, Параметры) Экспорт  
	
	Если ЗначениеЗаполнено(Результат) Тогда 
		Элементы.ВидыБизнесСобытий.ТекущиеДанные.Условие = Результат;
		Модифицированность = Истина;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ВидыБизнесСобытийВыборПродолжение(Результат, Параметры) Экспорт  
	
	ЗаполнитьСписокСобытий();

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ШаблонБизнесПроцессаПриОткрытии = ТекущийОбъект.ШаблонБизнесПроцесса;
	ОрганизацияПриОткрытии = ТекущийОбъект.Организация;
	ВидДокументаПриОткрытии = ТекущийОбъект.ВидДокумента;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьСовместимостьШаблонаИВидаДокумента(Шаблон, ВидДокумента)
	
	МенеджерШаблонаПроцесса = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Шаблон);
	ИмяПроцесса = МенеджерШаблонаПроцесса.ИмяПроцесса(Шаблон);
	МетаданныеПроцесса = Метаданные.БизнесПроцессы.Найти(ИмяПроцесса);	
	Если ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда
		Возврат ПроцессМожетСоздаватьсяПоПредмету(МетаданныеПроцесса, Метаданные.Справочники.ВнутренниеДокументы);
	ИначеЕсли ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыВходящихДокументов") Тогда
		Возврат ПроцессМожетСоздаватьсяПоПредмету(МетаданныеПроцесса, Метаданные.Справочники.ВходящиеДокументы);
	ИначеЕсли ТипЗнч(ВидДокумента) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
		Возврат ПроцессМожетСоздаватьсяПоПредмету(МетаданныеПроцесса, Метаданные.Справочники.ИсходящиеДокументы);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроцессМожетСоздаватьсяПоПредмету(МетаданныеПроцесса, МетаданныеДокумента)
	
	Для Каждого ЭлементМетаданных Из МетаданныеПроцесса.ВводитсяНаОсновании Цикл
		Если ЭлементМетаданных = МетаданныеДокумента Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		ТекстПредупреждения = "";
	КонецЕсли;	
	
КонецПроцедуры
	
