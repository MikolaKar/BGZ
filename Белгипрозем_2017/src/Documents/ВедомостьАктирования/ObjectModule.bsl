
Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ВедомостьАктирования.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьУчетДоговоров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьРасчетыСПокупателями(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьНачислениеЗП(ДополнительныеСвойства, Движения, Отказ);

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
     // Запись даты выполнения работ
	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДатыДоговоров;
	ТабДляДаты = Таблица.Скопировать();
	
	Для каждого СтрокаТаб Из Таблица Цикл
		
		ТабДляДаты.Очистить();
		НоваяСтрока = ТабДляДаты.Добавить();
		НоваяСтрока.Период = СтрокаТаб.Период;
		НоваяСтрока.Корреспондент = СтрокаТаб.Корреспондент;
		НоваяСтрока.Договор = СтрокаТаб.Договор;
		НоваяСтрока.ЭтапДоговора = СтрокаТаб.ЭтапДоговора;
		НоваяСтрока.ВидДатыДоговора = Справочники.мВидыДатДоговоров.ДатаВыполнения;
		НоваяСтрока.Дата = СтрокаТаб.Дата;
		НоваяСтрока.Основание = СтрокаТаб.Основание;
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("ЭтапДоговора", СтрокаТаб.ЭтапДоговора);
		СтруктураОтбора.Вставить("ВидДатыДоговора", Справочники.мВидыДатДоговоров.ДатаВыполнения);
		мРаботаСДоговорами.ЗаписатьДатуДоговора(ТабДляДаты, СтруктураОтбора, Отказ);
 	КонецЦикла; 

	//// Запись даты закрытия этапа договора
	//Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДатыЗакрытия;
	//СтруктураОтбора = Новый Структура;
	//СтруктураОтбора.Вставить("Основание", Ссылка);
	//СтруктураОтбора.Вставить("ВидДатыДоговора", Справочники.мВидыДатДоговоров.ДатаЗакрытия);
	//мРаботаСДоговорами.ЗаписатьДатуДоговора(Таблица, СтруктураОтбора, Отказ);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
КонецПроцедуры

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Удаление даты договора
	мРаботаСДоговорами.УдалитьДатуДоговора(Ссылка, Отказ);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		УдалитьЛишниеСтроки();
	КонецЕсли; 
	
КонецПроцедуры

Процедура УдалитьЛишниеСтроки()
	Отбор = Новый Структура("ДатаАкта", '00010101');
	ПустыеСтроки = ЭтотОбъект.Акты.НайтиСтроки(Отбор);
	
	ВсегоСтрок = -ЭтотОбъект.Акты.Количество()+1;
	
	Для х = ВсегоСтрок По 0 Цикл
		Если ПустыеСтроки.Найти(ЭтотОбъект.Акты[-х]) = Неопределено Тогда
		    Продолжить;
		КонецЕсли;
		ЭтотОбъект.Акты.Удалить(ЭтотОбъект.Акты[-х]);
	КонецЦикла; 

КонецПроцедуры // УдалитьЛишниеСтроки()

