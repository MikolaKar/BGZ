//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("УникальныйИдентификаторФормыВладельца") Тогда 
		УникальныйИдентификаторФормыВладельца = Параметры.УникальныйИдентификаторФормыВладельца;
	КонецЕсли;	
	
	СвязанныйДокумент = Неопределено;
	Если ЗначениеЗаполнено(Запись.СвязанныйДокумент) Тогда 
		СвязанныйДокумент = Запись.СвязанныйДокумент;
	ИначеЕсли ЗначениеЗаполнено(Запись.СвязаннаяСтрока) Тогда 
		СвязанныйДокумент = Запись.СвязаннаяСтрока;
	КонецЕсли;	
	
	ЗаписьОбратнойСвязи = Неопределено;
	Если ЗначениеЗаполнено(Параметры.Ключ) Тогда 
		НачальныйТипСвязи = Запись.ТипСвязи;
		НачальныйСвязанныйДокумент = СвязанныйДокумент;
		ЗаписьОбратнойСвязи = НайтиЗаписьОбратнойСвязи();
	Иначе	
		НачальныйТипСвязи = Справочники.ТипыСвязей.ПустаяСсылка();
		НачальныйСвязанныйДокумент = Неопределено;
		Запись.ДатаУстановки = ТекущаяДатаСеанса();
		Запись.Установил = ПользователиКлиентСервер.ТекущийПользователь();
		
		Если Параметры.Свойство("Документ") И ЗначениеЗаполнено(Параметры.Документ) Тогда 
			Запись.Документ = Параметры.Документ;
		КонецЕсли;	
		
		Если Параметры.Свойство("ТипСвязи") И ЗначениеЗаполнено(Параметры.ТипСвязи) Тогда 
			Запись.ТипСвязи = Параметры.ТипСвязи;
		КонецЕсли;	
	КонецЕсли;	
	
	
	Если ЗначениеЗаполнено(Запись.Документ) Тогда 
		Элементы.Документ.ТолькоПросмотр = Истина;
		Элементы.ТипСвязи.АктивизироватьПоУмолчанию = Истина;
	КонецЕсли;	
	
	Если СвязанныйДокумент <> Неопределено Тогда 
		ТипСвязанногоДокумента = ПолучитьТип(СвязанныйДокумент);
	КонецЕсли;
	Элементы.СвязанныйДокумент.ТолькоПросмотр = Не ЗначениеЗаполнено(ТипСвязанногоДокумента);
	Элементы.СвязанныйДокумент.АвтоОтметкаНезаполненного = ЗначениеЗаполнено(ТипСвязанногоДокумента);
	
	ЗаполнитьНастройкиСвязи();
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда 
		ПрименитьНастройкиСвязи();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// оповещение об удалении связи
	Если УдаленыВсеСвязиТипа Тогда 
		ПараметрОповещения = Новый Структура;
		ПараметрОповещения.Вставить("Документ", Запись.Документ);
		ПараметрОповещения.Вставить("ТипСвязи", НачальныйТипСвязи);
		
		Оповестить("УдаленыВсеСвязиТипа", ПараметрОповещения, ЭтаФорма);
	КонецЕсли;	
	
	// оповещение о создании связи
	ПараметрСобытия = Новый Структура;
	ПараметрСобытия.Вставить("Документ", 			Запись.Документ);
	ПараметрСобытия.Вставить("ТипСвязи", 			Запись.ТипСвязи);
	ПараметрСобытия.Вставить("СвязанныйДокумент", 	СвязанныйДокумент);
	ПараметрСобытия.Вставить("КлючЗаписи", 			Параметры.Ключ);
	Оповестить("СозданаСвязь", ПараметрСобытия, ЭтаФорма);
	
	// оповещение об изменении реквизитов
	Если РеквизитыВладельцаИзменены Тогда 
		Оповестить("ИзмененыРеквизитыПриИзмененииСвязи", Запись.Документ, ЭтаФорма);
	КонецЕсли;	
	
	// оповещение об изменении связи
	Если (НачальныйСвязанныйДокумент <> СвязанныйДокумент) 
	 Или (НачальныйТипСвязи <> Запись.ТипСвязи) Тогда 
		ТипыСвязей = Новый Массив;
		ТипыСвязей.Добавить(Запись.ТипСвязи);
		ТипыСвязей.Добавить(НачальныйТипСвязи);
		
		ПараметрОповещения = Новый Структура;
		ПараметрОповещения.Вставить("Документ", Запись.Документ);
		ПараметрОповещения.Вставить("ТипыСвязей", ТипыСвязей);
		ПараметрОповещения.Вставить("СвязанныйДокумент", Запись.СвязанныйДокумент);

		Оповестить("ИзмененыСвязиДокумента", ПараметрОповещения, ЭтаФорма);
	КонецЕсли;	
	
	НачальныйТипСвязи = Запись.ТипСвязи;
	НачальныйСвязанныйДокумент = СвязанныйДокумент;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Модифицированность Тогда 
		ТекущийОбъект.ДатаУстановки = ТекущаяДатаСеанса();
		ТекущийОбъект.Установил = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;	
	
	Если ТипЗнч(СвязанныйДокумент) = Тип("Строка") Тогда 
		ТекущийОбъект.СвязанныйДокумент = Неопределено;
		ТекущийОбъект.СвязаннаяСтрока = СвязанныйДокумент;
	Иначе
		ТекущийОбъект.СвязанныйДокумент = СвязанныйДокумент;
		ТекущийОбъект.СвязаннаяСтрока = Неопределено;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УдаленыВсеСвязиТипа = Ложь;
	РеквизитыВладельцаИзменены = Ложь;
	
	Если НачальныйТипСвязи.Пустая() Тогда 
		РеквизитыВладельцаИзменены = СвязиДокументов.УстановитьРеквизитыПриДобавленииСвязи(Запись.Документ, УникальныйИдентификаторФормыВладельца, Запись.ТипСвязи);
	ИначеЕсли НачальныйТипСвязи <> Запись.ТипСвязи Тогда 
		РеквизитыВладельцаИзменены1 = СвязиДокументов.УстановитьРеквизитыПриУдаленииСвязи(Запись.Документ, УникальныйИдентификаторФормыВладельца, НачальныйТипСвязи);
		РеквизитыВладельцаИзменены2 = СвязиДокументов.УстановитьРеквизитыПриДобавленииСвязи(Запись.Документ, УникальныйИдентификаторФормыВладельца, Запись.ТипСвязи);
		РеквизитыВладельцаИзменены = РеквизитыВладельцаИзменены1 Или РеквизитыВладельцаИзменены2;
		
		// удалены все связи с начальным типом
		НаборЗаписей = РегистрыСведений.СвязиДокументов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Документ.Установить(Запись.Документ);
		НаборЗаписей.Отбор.ТипСвязи.Установить(НачальныйТипСвязи);
		НаборЗаписей.Прочитать();
		УдаленыВсеСвязиТипа = (НаборЗаписей.Количество() = 0);
	КонецЕсли;
	
	НастройкаСвязи = СвязиДокументов.ПолучитьНастройкуСвязи(Запись.Документ, СвязанныйДокумент, Запись.ТипСвязи);
	Если НастройкаСвязи = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	ТипОбратнойСвязи = НастройкаСвязи.ТипОбратнойСвязи;
	
	Если ЗаписьОбратнойСвязи = Неопределено Тогда 
		Если ЗначениеЗаполнено(ТипОбратнойСвязи) Тогда 
			МенеджерЗаписи = РегистрыСведений.СвязиДокументов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ТипСвязи = ТипОбратнойСвязи;
			МенеджерЗаписи.Документ = СвязанныйДокумент;
			МенеджерЗаписи.СвязанныйДокумент = Запись.Документ;
			МенеджерЗаписи.Установил = Запись.Установил;
			МенеджерЗаписи.ДатаУстановки = Запись.ДатаУстановки;
			МенеджерЗаписи.Комментарий = Запись.Комментарий;
			МенеджерЗаписи.Записать();
			
			СвязиДокументов.УстановитьРеквизитыПриДобавленииСвязи(МенеджерЗаписи.Документ, Неопределено, МенеджерЗаписи.ТипСвязи);
			
			ЗаписьОбратнойСвязи = РегистрыСведений.СвязиДокументов.СоздатьКлючЗаписи(
				Новый Структура("ТипСвязи, Документ, СвязанныйДокумент", 
				МенеджерЗаписи.ТипСвязи, 
				МенеджерЗаписи.Документ, 
				МенеджерЗаписи.СвязанныйДокумент));
		КонецЕсли;	
	Иначе	
		Если ЗначениеЗаполнено(ТипОбратнойСвязи) Тогда 
			МенеджерЗаписи = РегистрыСведений.СвязиДокументов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ТипСвязи = ЗаписьОбратнойСвязи.ТипСвязи;
			МенеджерЗаписи.Документ = ЗаписьОбратнойСвязи.Документ;
			МенеджерЗаписи.СвязанныйДокумент = ЗаписьОбратнойСвязи.СвязанныйДокумент;
			МенеджерЗаписи.Прочитать();
			
			МенеджерЗаписи.ТипСвязи = ТипОбратнойСвязи;
			МенеджерЗаписи.Документ = СвязанныйДокумент;
			МенеджерЗаписи.СвязанныйДокумент = Запись.Документ;
			МенеджерЗаписи.Установил = Запись.Установил;
			МенеджерЗаписи.ДатаУстановки = Запись.ДатаУстановки;
			МенеджерЗаписи.Комментарий = Запись.Комментарий;
			МенеджерЗаписи.Записать();
			
			СвязиДокументов.УстановитьРеквизитыПриУдаленииСвязи(ЗаписьОбратнойСвязи.Документ, Неопределено, ЗаписьОбратнойСвязи.ТипСвязи);
			СвязиДокументов.УстановитьРеквизитыПриДобавленииСвязи(МенеджерЗаписи.Документ, Неопределено, МенеджерЗаписи.ТипСвязи);
			
			ЗаписьОбратнойСвязи = РегистрыСведений.СвязиДокументов.СоздатьКлючЗаписи(
				Новый Структура("ТипСвязи, Документ, СвязанныйДокумент", 
				МенеджерЗаписи.ТипСвязи, 
				МенеджерЗаписи.Документ, 
				МенеджерЗаписи.СвязанныйДокумент));
		Иначе		
			МенеджерЗаписи = РегистрыСведений.СвязиДокументов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ТипСвязи = ЗаписьОбратнойСвязи.ТипСвязи;
			МенеджерЗаписи.Документ = ЗаписьОбратнойСвязи.Документ;
			МенеджерЗаписи.СвязанныйДокумент = ЗаписьОбратнойСвязи.СвязанныйДокумент;
			МенеджерЗаписи.Удалить();
			
			СвязиДокументов.УстановитьРеквизитыПриУдаленииСвязи(ЗаписьОбратнойСвязи.Документ, Неопределено, ЗаписьОбратнойСвязи.ТипСвязи);
			
			ЗаписьОбратнойСвязи = Неопределено;
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Запись.Документ = СвязанныйДокумент Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Указана связь с документом, из которого устанавливается связь!'"),,
			"СвязанныйДокумент",, 
			Отказ);
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(СвязанныйДокумент) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Связанный документ"" не заполнено'"),,
			"СвязанныйДокумент",, 
			Отказ);
	КонецЕсли;	
	
	//МиСофт+ 08.04.2015
	Если Запись.ТипСвязи = Справочники.ТипыСвязей.ПервичноеОбращение 
		Или Запись.ТипСвязи = Справочники.ТипыСвязей.ПовторноеОбращение
		Или Запись.ТипСвязи = Справочники.ТипыСвязей.ОсновноеОбращение
		Или Запись.ТипСвязи = Справочники.ТипыСвязей.Дубликат Тогда 
		Если Не Константы.ВестиУчетОбращенийГраждан.Получить() Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Указанный тип связи может быть использован только при включенном учете обращений!'"),,
				"Запись.ТипСвязи",, 
				Отказ);
			
		ИначеЕсли ТипЗнч(СвязанныйДокумент) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
			ВидСвязанногоДокумента = СвязанныйДокумент.ВидДокумента;
			Если Не ВидСвязанногоДокумента.УчитыватьКакОбращениеГраждан Тогда 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Для текущего типа связи может быть указано только обращение!'"),,
					"СвязанныйДокумент",, 
					Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	//МиСофт- 08.04.2015
	
	// Комплекты документов
	Если Запись.ТипСвязи = Справочники.ТипыСвязей.Содержит Тогда
		Если Не ЭтоКомплект(Запись.Документ) Тогда
			ТекстСообщения = НСтр("ru = 'Документ не может содержать другие документы или файлы, так как он не является комплектом.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Запись.ТипСвязи" ,, Отказ);
		КонецЕсли;
	ИначеЕсли Запись.ТипСвязи = Справочники.ТипыСвязей.ВходитВКомплект Тогда
		Если Не ЭтоКомплект(СвязанныйДокумент) Тогда
			ТекстСообщения = НСтр("ru = 'Связь ""Входит в комплект"" может быть установлена только с документом, являющимся комплектом.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Запись.ТипСвязи" ,, Отказ);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Протоколирование работы пользователей
	Если ТекущийОбъект.ТипСвязи = Справочники.ТипыСвязей.Содержит Тогда
		Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Добавлен новый элемент:
			|%1
			|Ссылка:
			|%2'"),
			ТекущийОбъект.СвязанныйДокумент,
			ПолучитьНавигационнуюСсылку(ТекущийОбъект.СвязанныйДокумент));
		ПротоколированиеРаботыПользователей.ЗаписатьИзменениеСоставаКомплекта(ТекущийОбъект.Документ, Описание);
	ИначеЕсли ТекущийОбъект.ТипСвязи = Справочники.ТипыСвязей.ВходитВКомплект Тогда
		Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Добавлен новый элемент:
			|%1
			|Ссылка:
			|%2'"),
			ТекущийОбъект.Документ,
			ПолучитьНавигационнуюСсылку(ТекущийОбъект.Документ));
		ПротоколированиеРаботыПользователей.ЗаписатьИзменениеСоставаКомплекта(ТекущийОбъект.СвязанныйДокумент, Описание);
	КонецЕсли;
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ПРОЦЕДУРЫ И ФУНКЦИИ 

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТипСоставногоРеквизита(Форма, ИмяРеквизита, ТипРеквизита)
	
	Если ЗначениеЗаполнено(ТипРеквизита) Тогда 
		
		Если ТипРеквизита <> ПолучитьТип(Форма.Запись[ИмяРеквизита]) Тогда 
			Если ИмяРеквизита = "СвязанныйДокумент" Тогда 
				Форма[ИмяРеквизита] = ?(ТипРеквизита = "Строка", "", Новый(ТипРеквизита));
			Иначе	
				Форма.Запись[ИмяРеквизита] = ?(ТипРеквизита = "Строка", "", Новый(ТипРеквизита));
			КонецЕсли;	
		КонецЕсли;
		
		Форма.Элементы[ИмяРеквизита].ТолькоПросмотр = Ложь;
		Форма.Элементы[ИмяРеквизита].АвтоОтметкаНезаполненного = Истина;
		Форма.Элементы[ИмяРеквизита].ОтметкаНезаполненного = Не ЗначениеЗаполнено(Форма.Запись[ИмяРеквизита]);
		
	Иначе
		
		Если ИмяРеквизита = "СвязанныйДокумент" Тогда 
			Форма[ИмяРеквизита] = Неопределено;
		Иначе
			Форма.Запись[ИмяРеквизита] = Неопределено;
		КонецЕсли;	
		
		Форма.Элементы[ИмяРеквизита].ТолькоПросмотр = Истина;
		Форма.Элементы[ИмяРеквизита].АвтоОтметкаНезаполненного = Ложь;
		Форма.Элементы[ИмяРеквизита].ОтметкаНезаполненного = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьТип(Значение)
	
	Если ТипЗнч(Значение) = Тип("Строка") Тогда 
		ИмяТипа = "Строка";
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
		ИмяТипа = "СправочникСсылка.ВходящиеДокументы";
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда 
		ИмяТипа = "СправочникСсылка.ИсходящиеДокументы";
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда 
		ИмяТипа = "СправочникСсылка.ВнутренниеДокументы";
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.Файлы") Тогда
		ИмяТипа = "СправочникСсылка.Файлы";
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.Мероприятия") Тогда
		ИмяТипа = "СправочникСсылка.Мероприятия";
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.Проекты") Тогда 
		ИмяТипа = "СправочникСсылка.Проекты";
	ИначеЕсли ТипЗнч(Значение) = Тип("ДокументСсылка.ВходящееСообщениеСВД") Тогда 
		ИмяТипа = "ДокументСсылка.ВходящееСообщениеСВД";
	ИначеЕсли ТипЗнч(Значение) = Тип("ДокументСсылка.ИсходящееСообщениеСВД") Тогда 
		ИмяТипа = "ДокументСсылка.ИсходящееСообщениеСВД";		
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоВходящееПисьмо(Значение) Тогда
		ИмяТипа = "ДокументСсылка.ВходящееПисьмо";
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоИсходящееПисьмо(Значение) Тогда
		ИмяТипа = "ДокументСсылка.ИсходящееПисьмо";
	Иначе
		ИмяТипа = "";
	КонецЕсли;
	
	Возврат ИмяТипа;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьНастройкиСвязи()
	
	ТаблНастройкиСвязи = СвязиДокументов.ПолучитьНастройкиСвязи(Запись.Документ);
	
	Если Не Константы.ВестиУчетОбращенийГраждан.Получить() Тогда 
		КоличествоСтрок = ТаблНастройкиСвязи.Количество();
		Для Инд = 1 По КоличествоСтрок Цикл 
			Строка = ТаблНастройкиСвязи[КоличествоСтрок-Инд];
			
			Если Строка.ТипСвязи = Справочники.ТипыСвязей.ПервичноеОбращение 
			 Или Строка.ТипСвязи = Справочники.ТипыСвязей.ПовторноеОбращение
			 Или Строка.ТипСвязи = Справочники.ТипыСвязей.ОсновноеОбращение
			 Или Строка.ТипСвязи = Справочники.ТипыСвязей.Дубликат Тогда 
				ТаблНастройкиСвязи.Удалить(Строка)
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли; 
	
	ЗначениеВРеквизитФормы(ТаблНастройкиСвязи, "НастройкиСвязи");
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройкиСвязи()
	
	ТаблНастройкиСвязи = РеквизитФормыВЗначение("НастройкиСвязи");
	
	// тип связи
	НастройкиСвязиТипСвязи = ТаблНастройкиСвязи.Скопировать();
	НастройкиСвязиТипСвязи.Свернуть("ТипСвязи");
	Если НастройкиСвязиТипСвязи.Количество() = 0 Тогда 
		Запись.ТипСвязи = Неопределено;
		ТипСвязанногоДокумента = "";
		СвязанныйДокумент = Неопределено;
		УстановитьТипСоставногоРеквизита(ЭтаФорма, "СвязанныйДокумент", ТипСвязанногоДокумента);
	ИначеЕсли НастройкиСвязиТипСвязи.Количество() = 1 Тогда 	
		Если Запись.ТипСвязи <> НастройкиСвязиТипСвязи[0].ТипСвязи Тогда 
			Запись.ТипСвязи = НастройкиСвязиТипСвязи[0].ТипСвязи;
		КонецЕсли;
	Иначе	
		Если ЗначениеЗаполнено(Запись.ТипСвязи) И НастройкиСвязиТипСвязи.Найти(Запись.ТипСвязи, "ТипСвязи") = Неопределено Тогда 
			Запись.ТипСвязи = Неопределено;
			ТипСвязанногоДокумента = "";
			СвязанныйДокумент = Неопределено;
			УстановитьТипСоставногоРеквизита(ЭтаФорма, "СвязанныйДокумент", ТипСвязанногоДокумента);
		КонецЕсли;
	КонецЕсли;
	
	// тип связанного документа
	Если ЗначениеЗаполнено(Запись.ТипСвязи) Тогда 
		НастройкиСвязиТипСсылкаНа = ТаблНастройкиСвязи.Скопировать();
		НастройкиСвязиТипСсылкаНа.Очистить();
		
		Для Каждого Строка Из ТаблНастройкиСвязи Цикл
			Если Строка.ТипСвязи = Запись.ТипСвязи Тогда 
				НоваяСтрока = НастройкиСвязиТипСсылкаНа.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			КонецЕсли;
		КонецЦикла;	
		
		НастройкиСвязиТипСсылкаНа.Свернуть("ТипСсылкаНа");
		Если НастройкиСвязиТипСсылкаНа.Количество() = 0 Тогда 
			ТипСвязанногоДокумента = "";
			СвязанныйДокумент = Неопределено;
			УстановитьТипСоставногоРеквизита(ЭтаФорма, "СвязанныйДокумент", ТипСвязанногоДокумента);
		ИначеЕсли НастройкиСвязиТипСсылкаНа.Количество() = 1 Тогда 
			Если ТипСвязанногоДокумента <> НастройкиСвязиТипСсылкаНа[0].ТипСсылкаНа Тогда 
				ТипСвязанногоДокумента = НастройкиСвязиТипСсылкаНа[0].ТипСсылкаНа;
				УстановитьТипСоставногоРеквизита(ЭтаФорма, "СвязанныйДокумент", ТипСвязанногоДокумента);
			КонецЕсли;
		Иначе
			Если ЗначениеЗаполнено(ТипСвязанногоДокумента) И НастройкиСвязиТипСсылкаНа.Найти(ТипСвязанногоДокумента, "ТипСсылкаНа") = Неопределено Тогда 
				ТипСвязанногоДокумента = "";
				СвязанныйДокумент = Неопределено;
				УстановитьТипСоставногоРеквизита(ЭтаФорма, "СвязанныйДокумент", ТипСвязанногоДокумента);
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Функция ПолучитьТипыСвязи()
	
	СписокВозврата = Новый СписокЗначений;
	Для Каждого Строка Из НастройкиСвязи Цикл
		Если СписокВозврата.НайтиПоЗначению(Строка.ТипСвязи) = Неопределено Тогда 
			СписокВозврата.Добавить(Строка.ТипСвязи);
		КонецЕсли;	
	КонецЦикла;
	Возврат СписокВозврата;
	
КонецФункции	

&НаКлиенте
Функция ПолучитьТипыСвязанныхДокументов()
	
	СписокВозврата = Новый СписокЗначений;
	Для Каждого Строка Из НастройкиСвязи Цикл
		Если Строка.ТипСвязи = Запись.ТипСвязи Тогда 
			Если СписокВозврата.НайтиПоЗначению(Строка.ТипСсылкаНа) = Неопределено Тогда 
				СписокВозврата.Добавить(Строка.ТипСсылкаНа, Строка.ТипСсылкаНаПредставление);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;	 
	Возврат СписокВозврата;
	
КонецФункции

&НаСервере
Функция ПолучитьВидыСвязанныхДокументов()
	
	СписокВозврата = Новый СписокЗначений;
	Для Каждого Строка Из НастройкиСвязи Цикл
		Если Строка.ТипСвязи = Запись.ТипСвязи И Строка.ТипСсылкаНа = ТипСвязанногоДокумента Тогда 
			Если Строка.СсылкаНа.Пустая() Тогда 
				СписокВозврата.Добавить("Все");
			ИначеЕсли Строка.СсылкаНа.ЭтоГруппа Тогда 
				Подчиненные = Справочники[Строка.СсылкаНа.Метаданные().Имя].ВыбратьИерархически(Строка.СсылкаНа);
				Пока Подчиненные.Следующий() Цикл
					Если Не Подчиненные.ЭтоГруппа Тогда 
						СписокВозврата.Добавить(Подчиненные.Ссылка);
					КонецЕсли;	
				КонецЦикла;	
			Иначе	
				СписокВозврата.Добавить(Строка.СсылкаНа);
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;	
	Возврат СписокВозврата;
	
КонецФункции

&НаСервере
Функция НайтиЗаписьОбратнойСвязи()
	
	НастройкаСвязи = СвязиДокументов.ПолучитьНастройкуСвязи(Запись.Документ, СвязанныйДокумент, Запись.ТипСвязи);
	Если НастройкаСвязи = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;	
	
	ТипОбратнойСвязи = НастройкаСвязи.ТипОбратнойСвязи;
	Если Не ЗначениеЗаполнено(ТипОбратнойСвязи) Тогда 
		Возврат Неопределено;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.СвязиДокументов КАК СвязиДокументов
	|ГДЕ
	|	СвязиДокументов.ТипСвязи = &ТипСвязи
	|	И СвязиДокументов.Документ = &Документ
	|	И СвязиДокументов.СвязанныйДокумент = &СвязанныйДокумент";
	Запрос.УстановитьПараметр("ТипСвязи", 			ТипОбратнойСвязи);
	Запрос.УстановитьПараметр("Документ", 			СвязанныйДокумент);
	Запрос.УстановитьПараметр("СвязанныйДокумент", 	Запись.Документ);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Неопределено;
	КонецЕсли;	
	
	ЗначенияКлюча = Новый Структура("ТипСвязи, Документ, СвязанныйДокумент", 
		ТипОбратнойСвязи, 
		СвязанныйДокумент, 
		Запись.Документ);
	
	Возврат РегистрыСведений.СвязиДокументов.СоздатьКлючЗаписи(ЗначенияКлюча);
	
КонецФункции	


//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ДокументПриИзменении(Элемент)
	
	ЗаполнитьНастройкиСвязи();
	ПрименитьНастройкиСвязи();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСвязиПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Запись.ТипСвязи) Тогда 
		ТипыСвязанныхДокументов = ПолучитьТипыСвязанныхДокументов();
		Если ЗначениеЗаполнено(ТипСвязанногоДокумента) Тогда 
			Если ТипыСвязанныхДокументов.НайтиПоЗначению(ТипСвязанногоДокумента) = Неопределено Тогда 
				ТипСвязанногоДокумента = "";
				СвязанныйДокумент = Неопределено;
				УстановитьТипСоставногоРеквизита(ЭтаФорма, "СвязанныйДокумент", ТипСвязанногоДокумента);
			КонецЕсли;	
		Иначе
			Если ТипыСвязанныхДокументов.Количество() = 1 Тогда 
				ТипСвязанногоДокумента = ТипыСвязанныхДокументов[0].Значение;
				УстановитьТипСоставногоРеквизита(ЭтаФорма, "СвязанныйДокумент", ТипСвязанногоДокумента);
			КонецЕсли;	
		КонецЕсли;	
	Иначе
		Если ЗначениеЗаполнено(ТипСвязанногоДокумента) Тогда 
			ТипСвязанногоДокумента = "";
			СвязанныйДокумент = Неопределено;
			УстановитьТипСоставногоРеквизита(ЭтаФорма, "СвязанныйДокумент", ТипСвязанногоДокумента);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСвязиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(Запись.Документ) Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Объект""'"),,"Запись.Документ");
		Возврат;
	КонецЕсли;	
	
	ДоступныеТипыСвязи = ПолучитьТипыСвязи();
	Если ДоступныеТипыСвязи.Количество() = 0 Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для объекта не настроено ни одного типа связи'"),,"Запись.Документ");
		Возврат;
	КонецЕсли;	
	
	ДанныеВыбора = ДоступныеТипыСвязи;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСвязиАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	Если Не ЗначениеЗаполнено(Запись.Документ) Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Объект""'"),,"Запись.Документ");
		Возврат;
	КонецЕсли;	
	
	ДоступныеТипыСвязи = ПолучитьТипыСвязи();
	Если ДоступныеТипыСвязи.Количество() = 0 Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для объекта не настроено ни одного типа связи'"),,"Запись.Документ");
		Возврат;
	КонецЕсли;	
	
	СписокВыбора = Новый СписокЗначений;
	Для Каждого Тип Из ДоступныеТипыСвязи Цикл 
		ТипТекст = НРег(СокрЛП(Тип));
		ТекстПоиска = НРег(Текст);
		Если Лев(ТипТекст, СтрДлина(Текст)) = ТекстПоиска Тогда 
			СписокВыбора.Добавить(Тип.Значение);
		КонецЕсли;	
	КонецЦикла;
	
	ДанныеВыбора = СписокВыбора;

КонецПроцедуры

&НаКлиенте
Процедура ТипСвязиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
		
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;

		Если Не ЗначениеЗаполнено(Запись.Документ) Тогда 
			ОчиститьСообщения();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Объект""'"),,"Запись.Документ");
			Возврат;
		КонецЕсли;	
		
		ДоступныеТипыСвязи = ПолучитьТипыСвязи();
		Если ДоступныеТипыСвязи.Количество() = 0 Тогда 
			ОчиститьСообщения();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для объекта не настроено ни одного типа связи'"),,"Запись.Документ");
			Возврат;
		КонецЕсли;	
		
		СписокВыбора = Новый СписокЗначений;
		Для Каждого Тип Из ДоступныеТипыСвязи Цикл 
			ТипТекст = НРег(СокрЛП(Тип));
			ТекстПоиска = НРег(Текст);
			Если Лев(ТипТекст, СтрДлина(Текст)) = ТекстПоиска Тогда 
				СписокВыбора.Добавить(Тип.Значение);
			КонецЕсли;	
		КонецЦикла;
		
		ДанныеВыбора = СписокВыбора;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ТипСвязанногоДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ЗначениеЗаполнено(Запись.Документ) Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Объект""'"),,"Запись.Документ");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Запись.ТипСвязи) Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено поле ""Тип связи""'"),,"Запись.ТипСвязи");
		Возврат;
	КонецЕсли;
	
	ТипыСвязанныхДокументов = ПолучитьТипыСвязанныхДокументов();
	Если ТипыСвязанныхДокументов.Количество() = 0 Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для объекта не настроено ни одного типа связи'"),,"Запись.Документ");
		Возврат;	
	КонецЕсли;	
	
	ДанныеВыбора = ТипыСвязанныхДокументов;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСвязанногоДокументаПриИзменении(Элемент)
	
	УстановитьТипСоставногоРеквизита(ЭтаФорма, "СвязанныйДокумент", ТипСвязанногоДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СвязанныйДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ТипСвязанногоДокумента <> "Строка" 
	   И ТипСвязанногоДокумента <> "СправочникСсылка.Файлы"  
	   И ТипСвязанногоДокумента <> "СправочникСсылка.Мероприятия" 
	   И ТипСвязанногоДокумента <> "СправочникСсылка.Проекты" 
	   И ТипСвязанногоДокумента <> "ДокументСсылка.ВходящееСообщениеСВД" 
	   И ТипСвязанногоДокумента <> "ДокументСсылка.ИсходящееСообщениеСВД"
	   И ТипСвязанногоДокумента <> "ДокументСсылка.ВходящееПисьмо" 
	   И ТипСвязанногоДокумента <> "ДокументСсылка.ИсходящееПисьмо" Тогда 
	   
	   СтандартнаяОбработка = Ложь;
		
		ВидыСвязанныхДокументов = ПолучитьВидыСвязанныхДокументов();
		Если ВидыСвязанныхДокументов.Количество() = 0 Тогда 
			ОчиститьСообщения();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для объекта не настроено ни одного типа связи'"),,"Запись.Документ");
			Возврат;	
		КонецЕсли;	
		
		ПараметрыФормы = Новый Структура;
		Если ВидыСвязанныхДокументов.НайтиПоЗначению("Все") = Неопределено Тогда 
			ПараметрыФормы.Вставить("Отбор", Новый Структура("ВидДокумента", ВидыСвязанныхДокументов));
		КонецЕсли;	
		
		Поз = Найти(ТипСвязанногоДокумента, ".");
		ИмяФормыВыбора = "Справочник." + Сред(ТипСвязанногоДокумента, Поз + 1) + ".ФормаВыбора";
		
		ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, Элемент);
		
	ИначеЕсли ТипСвязанногоДокумента = "СправочникСсылка.Файлы" Тогда 
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура("ТекущаяСтрока", СвязанныйДокумент);
		ОткрытьФорму("Справочник.Файлы.Форма.ФормаВыбораФайлаВПапках", ПараметрыФормы, Элемент);
		
	ИначеЕсли ТипСвязанногоДокумента = "СправочникСсылка.Мероприятия" Тогда 	
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура("ТекущаяСтрока", СвязанныйДокумент);
		ОткрытьФорму("Справочник.Мероприятия.ФормаВыбора", ПараметрыФормы, Элемент);
		
	ИначеЕсли ТипСвязанногоДокумента = "СправочникСсылка.Проекты" Тогда 
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура("ТекущаяСтрока", СвязанныйДокумент);
		ОткрытьФорму("Справочник.Проекты.ФормаВыбора", ПараметрыФормы, Элемент);
		
	ИначеЕсли ТипСвязанногоДокумента = "ДокументСсылка.ВходящееСообщениеСВД" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура("ТекущаяСтрока", СвязанныйДокумент);
		ОткрытьФорму("Документ.ВходящееСообщениеСВД.ФормаВыбора", ПараметрыФормы, Элемент);
		
	ИначеЕсли ТипСвязанногоДокумента = "ДокументСсылка.ИсходящееСообщениеСВД" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура("ТекущаяСтрока", СвязанныйДокумент);
		ОткрытьФорму("Документ.ИсходящееСообщениеСВД.ФормаВыбора", ПараметрыФормы, Элемент);		
		
	ИначеЕсли ТипСвязанногоДокумента = "ДокументСсылка.ВходящееПисьмо" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура("ТекущаяСтрока", СвязанныйДокумент);
		ОткрытьФорму("Документ.ВходящееПисьмо.ФормаВыбора", ПараметрыФормы, Элемент);
		
	ИначеЕсли ТипСвязанногоДокумента = "ДокументСсылка.ИсходящееПисьмо" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура("ТекущаяСтрока", СвязанныйДокумент);
		ОткрытьФорму("Документ.ИсходящееПисьмо.ФормаВыбора", ПараметрыФормы, Элемент);		
		
	КонецЕсли;	
	
КонецПроцедуры


// КОМПЛЕКТЫ ДОКУМЕНТОВ

Функция ЭтоКомплект(Документ)
	
	Возврат
	(ТипЗнч(Документ) = Тип("СправочникСсылка.ВнутренниеДокументы")
	Или ТипЗнч(Документ) = Тип("СправочникСсылка.ВходящиеДокументы")
	Или ТипЗнч(Документ) = Тип("СправочникСсылка.ИсходящиеДокументы")
	Или ТипЗнч(Документ) = Тип("СправочникСсылка.ШаблоныВнутреннихДокументов")
	Или ТипЗнч(Документ) = Тип("СправочникСсылка.ШаблоныВходящихДокументов")
	Или ТипЗнч(Документ) = Тип("СправочникСсылка.ШаблоныИсходящихДокументов"))
	И ЗначениеЗаполнено(Документ.ВидДокумента)
	И Документ.ВидДокумента.ЯвляетсяКомплектомДокументов;
	
КонецФункции
