
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.УчетДоговоров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ЗапасыСервер.ОтразитьУчетДоговоров(ДополнительныеСвойства, Движения, Отказ);
	Если Ссылка.Дата <> Дата(2016, 7, 1) Тогда
		ЗапасыСервер.ОтразитьУчетПроизводства(ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли; 

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
КонецПроцедуры                                          

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	ЭтоНовый = ЭтоНовый();
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый);
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	// Если это попытка Изменить не последний документ в сметной стоимости этапа - отказ
	Если Не ЭтоНовый Тогда
		Результат = мРаботаСДоговорами.ПолучитьПоследнийУчетДоговоров(ЭтотОбъект.Ссылка, ЭтотОбъект.ЭтапДоговора, ЭтотОбъект.Дата);
		Если Не Результат.ПоследнийВПоследовательности Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Нельзя изменять документ, если после него есть другие проведенные";
			Сообщение.Сообщить(); 	
		КонецЕсли; 
	КонецЕсли; 

	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
    Если ЭтотОбъект.Ссылка.ПометкаУдаления <> ЭтотОбъект.ПометкаУдаления Тогда
        // смена пометки удаления
		ЭтотОбъект.ДополнительныеСвойства.Вставить("ПометкаУдаления", ЭтотОбъект.ПометкаУдаления);
    КонецЕсли; 

КонецПроцедуры

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Изменение Этапа договора
	// Если этап помечен на удаление, то его не надо перезаписывать
	Если ЭтотОбъект.ЭтапДоговора.ПометкаУдаления или ЭтотОбъект.ЭтапДоговора.ДатаИсключенИзДоговора=Дата(1,1,1,0,0,0) Тогда
		// Коррекция суммы договора
		ИзменитьСуммуДоговора(ЭтотОбъект.Договор); 
		Возврат;
	КонецЕсли; 
	
	//// Проверка - надо ли изменять этап договора
	//НеИзменятьЭтап = Неопределено;
	//ДополнительныеСвойства.Свойство("НеИзменятьЭтап", НеИзменятьЭтап);
	//Если НеИзменятьЭтап <> Неопределено и НеИзменятьЭтап Тогда
	//	Возврат;	
	//КонецЕсли; 
	//
	////Ищем последний проведенный док
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ ПЕРВЫЕ 1
	//	|	УчетДоговоров.Ссылка,
	//	|	УчетДоговоров.Дата КАК ДатаПоследнейЗаписи,
	//	|	УчетДоговоров.Договор,
	//	|	УчетДоговоров.ЭтапДоговора,
	//	|	УчетДоговоров.Сумма КАК СтоимостьСНДС,
	//	|	УчетДоговоров.НДС КАК СуммаНДС,
	//	|	УчетДоговоров.ОсвобождениеОтНДС,
	//	|	УчетДоговоров.СтавкаНДС,
	//	|	УчетДоговоров.Цена,
	//	|	УчетДоговоров.КоличествоУчастков
	//	|ИЗ
	//	|	Документ.УчетДоговоров КАК УчетДоговоров
	//	|ГДЕ
	//	|	УчетДоговоров.ЭтапДоговора = &ЭтапДоговора
	//	|	И НЕ УчетДоговоров.ПометкаУдаления
	//	|	И УчетДоговоров.Проведен
	//	|	И УчетДоговоров.Ссылка <> &Ссылка
	//	|
	//	|УПОРЯДОЧИТЬ ПО
	//	|	УчетДоговоров.Дата УБЫВ";
	//
	//Запрос.УстановитьПараметр("ЭтапДоговора", ЭтотОбъект.ЭтапДоговора);
	//Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	//
	//Результат = Запрос.Выполнить();
	//
	//Если Результат.Пустой() Тогда
	//	// Это был единственный документ - очистить этап	
	//	ПараметрыЭтапа = Новый Структура("СтоимостьСНДС, СуммаНДС, Цена, КоличествоУчастков, ОсвобождениеОтНДС, СтавкаНДС, ДатаПоследнейЗаписи", 0, 0, 0,0, Неопределено, Неопределено, Неопределено);
	//	ПараметрыЭтапа.Вставить("Стоимость", 0);
	//	Если СтрНайти(ЭтотОбъект.Комментарий, "#Деноминация") > 0 Тогда
	//		ПараметрыЭтапа.Вставить("ДеноминацияОтмена", "#ДеноминацияОтмена");
	//	КонецЕсли; 
	//	
	//	ИзменитьЭтапДоговора(ЭтотОбъект, ПараметрыЭтапа);
	//	Возврат;
	//КонецЕсли; 
	//
	//Выборка = Результат.Выбрать();
	//
	//Если Выборка.Следующий() Тогда
	//	// Приводим этап к последнему проведенному ЭтапуДоговоров
	//	Если ЭтотОбъект.Дата < Выборка.ДатаПоследнейЗаписи Тогда
	//	    Сообщение = Новый СообщениеПользователю;
	//		Сообщение.Текст = "Нельзя изменять документы, если после них есть другие проведенные "
	//		+Выборка.Ссылка;
	//		Сообщение.Сообщить(); 
	//		Если НЕ РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
	//		 	Отказ = Истина;
	//        КонецЕсли; 
	//	КонецЕсли; 
	//	
	//	ПараметрыЭтапа = Новый Структура("СтоимостьСНДС, СуммаНДС, Цена, КоличествоУчастков, ОсвобождениеОтНДС, СтавкаНДС, ДатаПоследнейЗаписи", 0, 0, 0,0, Неопределено, Неопределено, Неопределено);
	//	ЗаполнитьЗначенияСвойств(ПараметрыЭтапа, Выборка);
	//	ПараметрыЭтапа.Вставить("Стоимость", Выборка.СтоимостьСНДС - Выборка.СуммаНДС);
	//	Если СтрНайти(ЭтотОбъект.Комментарий, "#Деноминация") > 0 Тогда
	//		ПараметрыЭтапа.Вставить("ДеноминацияОтмена", "#ДеноминацияОтмена");
	//	КонецЕсли; 
	//	
	//	ИзменитьЭтапДоговора(ЭтотОбъект, ПараметрыЭтапа);
	//КонецЕсли;   
		
КонецПроцедуры

Процедура ИзменитьЭтапДоговора(Источник, ПараметрыЭтапа)
	ЭтапОбъект = Источник.ЭтапДоговора.ПолучитьОбъект();
	Записывать = Ложь;
	
	Для каждого РеквизитЭтапа Из ПараметрыЭтапа Цикл
		Если РеквизитЭтапа.Ключ = "НеИзменятьДоговор" Тогда
			Продолжить;
		КонецЕсли; 
		Если РеквизитЭтапа.Ключ = "Деноминация" Тогда
			ЭтапОбъект.Комментарий = ЭтапОбъект.Комментарий + "#Деноминация";
			Продолжить;
		КонецЕсли; 
		Если РеквизитЭтапа.Ключ = "ДеноминацияОтмена" Тогда
			ЭтапОбъект.Комментарий = СтрЗаменить(ЭтапОбъект.Комментарий, "#Деноминация", "");
			Продолжить;
		КонецЕсли; 
		Если ЭтапОбъект[РеквизитЭтапа.Ключ] <> РеквизитЭтапа.Значение Тогда
			ЭтапОбъект[РеквизитЭтапа.Ключ] = РеквизитЭтапа.Значение;
			Записывать = Истина;
		КонецЕсли; 
	КонецЦикла; 
	Если Записывать Тогда
		Попытка
        	ЭтапОбъект.ДополнительныеСвойства.Вставить("ЗаписьИзУчетДоговора", Истина);
			ЭтапОбъект.Записать();
			
		Исключение
			
		КонецПопытки;
		
		// Коррекция суммы договора
		Если НЕ ПараметрыЭтапа.Свойство("НеИзменятьДоговор") Тогда
			ИзменитьСуммуДоговора(Источник.Договор); 
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

// Коррекция суммы договора
Процедура ИзменитьСуммуДоговора(Договор) 
	СуммаДоговораНовая = мРаботаСДоговорами.ПолучитьСуммуДоговора(Договор);
	СуммаДоговораЕсть = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Договор, "Сумма");
	Если СуммаДоговораНовая <> СуммаДоговораЕсть Тогда
		ДоговорОбъект = Договор.ПолучитьОбъект();
		ДоговорОбъект.Сумма = СуммаДоговораНовая;
		Попытка
			ДоговорОбъект.Записать()
		Исключение
			
		КонецПопытки; 
	КонецЕсли; 
КонецПроцедуры
 
