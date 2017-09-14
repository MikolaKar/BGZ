
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мДеноминацияУчетДоговоровУчетДоговоров.Договор.Корреспондент КАК Корреспондент,
		|	мДеноминацияУчетДоговоровУчетДоговоров.Договор,
		|	мДеноминацияУчетДоговоровУчетДоговоров.ЭтапДоговора,
		|	мДеноминацияУчетДоговоровУчетДоговоров.ЭтапДоговора.Подразделение КАК Подразделение,
		|	мДеноминацияУчетДоговоровУчетДоговоров.СуммаПосле КАК Сумма,
		|	мДеноминацияУчетДоговоровУчетДоговоров.НДСПосле КАК НДС,
		|	мДеноминацияУчетДоговоровУчетДоговоров.ОсвобождениеОтНДС,
		|	мДеноминацияУчетДоговоровУчетДоговоров.СтавкаНДС,
		|	ЕСТЬNULL(мДеноминацияУчетДоговоровУчетДоговоров.ЭтапДоговора.КоличествоУчастков, 1) КАК КоличествоУчастков,
		|	""#Деноминация"" КАК Комментарий
		|ИЗ
		|	Документ.мДеноминацияУчетДоговоров.УчетДоговоров КАК мДеноминацияУчетДоговоровУчетДоговоров
		|ГДЕ
		|	мДеноминацияУчетДоговоровУчетДоговоров.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Док = Документы.УчетДоговоров.СоздатьДокумент();
		Док.Дата = НачалоДня(Ссылка.Дата);
		ЗаполнитьЗначенияСвойств(Док, Выборка);
        
        //Если Выборка.СтавкаНДС = Справочники.мСтавкиНДС.НДС_20 Тогда
        //    Док.НДС = Окр(Док.Сумма / 120*20, 2);
        //КонецЕсли; 
		Если Выборка.КоличествоУчастков > 1 Тогда 
			Док.Цена = Выборка.Сумма / Выборка.КоличествоУчастков;
		ИначеЕсли Выборка.КоличествоУчастков = 1 Тогда	
		    Док.Цена = Выборка.Сумма;
		ИначеЕсли Выборка.КоличествоУчастков = 0 Тогда	
		    Док.КоличествоУчастков = 1;
		    Док.Цена = Выборка.Сумма;
		КонецЕсли;
		
		Попытка
		
			Док.Записать(РежимЗаписиДокумента.Проведение);
		
		Исключение
			Сообщить("Не проведен Учет договоров по "+Выборка.Корреспондент+" "+Выборка.Договор+" "+Выборка.ЭтапДоговора);		
		КонецПопытки;
		
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
	КонецЦикла;
	
	//ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	//Документы.мДеноминацияУчетДоговоров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	//
	//ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	//ЗапасыСервер.ОтразитьУчетДоговоров(ДополнительныеСвойства, Движения, Отказ);

	//ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Удаление документов Учет договоров
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетДоговоров.Ссылка
		|ИЗ
		|	Документ.мДеноминацияУчетДоговоров.УчетДоговоров КАК мДеноминацияУчетДоговоровУчетДоговоров
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.УчетДоговоров КАК УчетДоговоров
		|		ПО мДеноминацияУчетДоговоровУчетДоговоров.Договор = УчетДоговоров.Договор
		|			И мДеноминацияУчетДоговоровУчетДоговоров.ЭтапДоговора = УчетДоговоров.ЭтапДоговора
		|ГДЕ
		|	мДеноминацияУчетДоговоровУчетДоговоров.Ссылка = &Ссылка
		|	И НЕ УчетДоговоров.ПометкаУдаления
		|	И УчетДоговоров.Комментарий ПОДОБНО ""#Деноминация%""
		|	И УчетДоговоров.Дата МЕЖДУ &Дата1 И &Дата2";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата1", НачалоДня(Ссылка.Дата));
	Запрос.УстановитьПараметр("Дата2", КонецДня(Ссылка.Дата));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Док = Выборка.Ссылка.ПолучитьОбъект();
		Док.УстановитьПометкуУдаления(Истина);
		Док.Записать(РежимЗаписиДокумента.Запись);
	КонецЦикла;
	
	//ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	//
	//ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	//
	//ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры
