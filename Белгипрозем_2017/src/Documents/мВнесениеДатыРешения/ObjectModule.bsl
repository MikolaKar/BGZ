Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.мВнесениеДатыРешения.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ТаблицаСроки = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСроки;

	МассивЭтапов = Новый Массив;
	Установил = Неопределено;
	
	// Запись даты решения в этап
	Для каждого Стр Из ТаблицаСроки Цикл
		
		МассивЭтапов.Добавить(Стр.ЭтапДоговора);
		Установил = Стр.Ответственный;
		
		Попытка
			Этап = Стр.ЭтапДоговора.ПолучитьОбъект();
			Этап.ДатаПредоставленияРешения = Стр.ДатаРешения;
			Этап.Записать();
		Исключение
			Сообщить("Дата решения не записалась в этап "+Стр.ЭтапДоговора+" "+Стр.Договор);
			Отказ = Истина;
		КонецПопытки; 
		
		// Установка связи
		Если ЗначениеЗаполнено(Ссылка.Решение) Тогда
	        СвязиДокументов.УстановитьСвязь(Ссылка.Решение, Неопределено, Стр.Договор, Справочники.ТипыСвязей.ПредметПереписки);
		КонецЕсли; 
	КонецЦикла;
	
	// Расчет и запись плановых сроков
	ПлановыеСрокиЭтапов = мРаботаСДоговорами.РассчитатьПлановыеСрокиЭтапов(МассивЭтапов);
	
	ВидДатыДоговора = Справочники.мВидыДатДоговоров.ПлановыйСрок;
	
	НаборЗаписей = РегистрыСведений.мДатыДоговоров.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Основание.Установить(Ссылка);
	
	Для каждого Стр Из ПлановыеСрокиЭтапов Цикл
		НовЗап = НаборЗаписей.Добавить();
		НовЗап.Период = Ссылка.Дата;
		НовЗап.ЭтапДоговора = Стр.ЭтапДоговора;
		НовЗап.ВидДатыДоговора = ВидДатыДоговора;
		НовЗап.Основание = Ссылка;
		НовЗап.Дата = Стр.ПлановыйСрок;
		НовЗап.Комментарий = ""+Ссылка.Решение.РегистрационныйНомер + " от " + Формат(Ссылка.Решение.ДатаРегистрации, "ДФ=dd.MM.yy");
		НовЗап.Установил = Установил;
	КонецЦикла; 
	
	НаборЗаписей.Записать();
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры  

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПустаяДата = Дата(1, 1, 1);
	
	// Очистка даты решения в этапах
	Для каждого Стр Из Ссылка.Сроки Цикл
		
		Попытка
			Этап = Стр.ЭтапДоговора.ПолучитьОбъект();
			Этап.ДатаПредоставленияРешения = ПустаяДата;
			Этап.Записать();
		Исключение
			Сообщить("Дата решения не удалена в этапе "+Стр.ЭтапДоговора+" "+Стр.Договор);
			Отказ = Истина;
		КонецПопытки; 
		
		// Разрыв связи
		Если ЗначениеЗаполнено(Ссылка.Решение) Тогда
	        СвязиДокументов.УдалитьСвязь(Ссылка.Решение, Стр.Договор, Справочники.ТипыСвязей.ПерепискаПоПредмету);
		КонецЕсли; 
	КонецЦикла;
	
	// Удаление плановых сроков
	НаборЗаписей = РегистрыСведений.мДатыДоговоров.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Основание.Установить(Ссылка);
	НаборЗаписей.Записать();
КонецПроцедуры
