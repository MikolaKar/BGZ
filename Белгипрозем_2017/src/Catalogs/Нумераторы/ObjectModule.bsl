
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ОписаниеОшибки = "";
	СтруктураФорматаНомера = Неопределено;
	
	Если Не Нумерация.РазобратьФорматНомера(ФорматНомера, ОписаниеОшибки, СтруктураФорматаНомера) Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка в формате номера: %1'"), ОписаниеОшибки);

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ФорматНомера",,
			Отказ);
		Возврат;	
	КонецЕсли;
	
	НайденТегНомер = Ложь;
	Для Каждого Строка Из СтруктураФорматаНомера Цикл
		Если Строка.Ключ = "СлужебноеПоле" И Строка.Значение = "Номер" Тогда 
			НайденТегНомер = Истина;
		КонецЕсли;	
	КонецЦикла;
	Если Не НайденТегНомер Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Формат номера не содержит служебное поле ""Номер""'"),
			ЭтотОбъект,
			"ФорматНомера",,
			Отказ);
	КонецЕсли;	
	
	Если (Найти(ФорматНомера, "НомерСвязДок") > 0) Или НезависимаяНумерацияПоСвязанномуДокументу Тогда 
		ПроверяемыеРеквизиты.Добавить("ТипСвязи");
	КонецЕсли;	
	
	// Проверка настроек типа связи
	Если ЗначениеЗаполнено(ТипСвязи) Тогда 
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	НастройкаСвязей.СсылкаНа,
		|	ВЫБОР
		|		КОГДА НастройкаСвязей.ХарактерСвязи = ЗНАЧЕНИЕ(Перечисление.ХарактерСвязей.Множественная)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЭтоМножественнаяСвязь
		|ИЗ
		|	РегистрСведений.НастройкаСвязей КАК НастройкаСвязей
		|ГДЕ
		|	НастройкаСвязей.ТипСвязи = &ТипСвязи";
		
		Запрос.УстановитьПараметр("ТипСвязи", ТипСвязи);
		Выборка = Запрос.Выполнить().Выбрать();
		
		РазрешенныеТипы = Новый Массив;
		РазрешенныеТипы.Добавить(Тип("СправочникСсылка.ВидыВнутреннихДокументов"));
		РазрешенныеТипы.Добавить(Тип("СправочникСсылка.ВидыВходящихДокументов"));
		РазрешенныеТипы.Добавить(Тип("СправочникСсылка.ВидыИсходящихДокументов"));
		
		ЕстьМножественныеСвязи = Ложь;
		НедопустимыеТипы = "";
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ЭтоМножественнаяСвязь Тогда
				ЕстьМножественныеСвязи = Истина;
			КонецЕсли;
			
			ТипСвязанногоДокумента = ТипЗнч(Выборка.СсылкаНа);
			Если РазрешенныеТипы.Найти(ТипСвязанногоДокумента) = Неопределено Тогда
				
				Если ТипСвязанногоДокумента = Тип("Строка") Тогда
					ПредставлениеНедопустимогоТипа = НСтр("ru = 'Внешняя ссылка'");
				Иначе
					ПредставлениеНедопустимогоТипа = Строка(ТипСвязанногоДокумента);
				КонецЕсли;
				
				НедопустимыеТипы = НедопустимыеТипы + ?(НедопустимыеТипы = "", "", ", ") + ПредставлениеНедопустимогоТипа;
				
			КонецЕсли
			
		КонецЦикла;
		
		Если ЕстьМножественныеСвязи Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Настройки типа связи не должны содержать связи множественного характера'"),
				ЭтотОбъект,
				"ТипСвязи",,
				Отказ);
		КонецЕсли;
		
		Если НедопустимыеТипы <> "" Тогда
			Если Найти(НедопустимыеТипы, ",") = 0 Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Настройки типа связи содержат недопустимый тип связанного документа: %1'"),
					НедопустимыеТипы);
			Иначе
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Настройки типа связи содержат недопустимые типы связанного документа: %1'"),
					НедопустимыеТипы);
			КонецЕсли;	
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ТипСвязи",,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда 
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда 
			НезависимаяНумерацияПоОрганизациям = Истина;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры
