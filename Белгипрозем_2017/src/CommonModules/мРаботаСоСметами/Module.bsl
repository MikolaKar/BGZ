Функция ПолучитьРеквизитыСметы(Источник) Экспорт
	РеквизитыСметы = Новый Структура(); 	
	РеквизитыСметы.Вставить("Смета", Источник);	
	РеквизитыСметы.Вставить("Стоимость", Источник.Итого);	
	РеквизитыСметы.Вставить("СуммаНДС", Источник.НДС);	
	РеквизитыСметы.Вставить("СтоимостьСНДС", Источник.КОплате);	
	РеквизитыСметы.Вставить("СтавкаНДС", Источник.СтавкаНДС);	
	РеквизитыСметы.Вставить("ОсвобождениеОтНДС", Источник.ОсвобождениеОтНДС);	
	РеквизитыСметы.Вставить("ДоляОбъекта", Источник.ДоляОбъекта);	
	РеквизитыСметы.Вставить("ДатаПоследнейЗаписи", Источник.ДатаРасчетаСметы);	
	РеквизитыСметы.Вставить("БезНДС", Источник.СтавкаНДС.НеОблагается);	
	РеквизитыСметы.Вставить("ПометкаУдаления", Источник.ПометкаУдаления);	
	Возврат РеквизитыСметы;
КонецФункции // ПолучитьРеквизитыСметы()

Функция МожноУдалитьСмету(ТекСмета) Экспорт
	// Нельзя удалять смету, если после нее были доки УчетДоговоров
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетДоговоров.Ссылка
		|ИЗ
		|	Документ.УчетДоговоров КАК УчетДоговоров
		|ГДЕ
		|	УчетДоговоров.Дата > &Дата
		|	И УчетДоговоров.Проведен
		|	И УчетДоговоров.ЭтапДоговора = &ЭтапДоговора";
	
	Запрос.УстановитьПараметр("Дата", ТекСмета.ДатаРасчетаСметы);
	Запрос.УстановитьПараметр("ЭтапДоговора", ТекСмета.ЭтапДоговора);
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса.Пустой();
КонецФункции  

Функция ПолучитьИндексЦен(СборникНормВремени, ДатаРасчетаСметы) Экспорт
    СтруктураИндексаЦен = Новый Структура("Значение, Период, Должность, НомерПриказа, ДатаПриказа", 1, Дата(1,1,1), "", "", Дата(1,1,1));
	
	Если Не ЗначениеЗаполнено(СборникНормВремени) Тогда
		Возврат СтруктураИндексаЦен;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ
        |	мИндексЦенСрезПоследних.Значение,
        |	мИндексЦенСрезПоследних.Период,
        |	мИндексЦенСрезПоследних.Должность,
        |	мИндексЦенСрезПоследних.НомерПриказа,
        |	мИндексЦенСрезПоследних.ДатаПриказа
        |ИЗ
        |	РегистрСведений.мИндексЦен.СрезПоследних(&ДатаРасчетаСметы, СборникНормВремени = &СборникНормВремени) КАК мИндексЦенСрезПоследних";

    Запрос.УстановитьПараметр("ДатаРасчетаСметы", ДатаРасчетаСметы);
    Запрос.УстановитьПараметр("СборникНормВремени", СборникНормВремени);

    РезультатЗапроса = Запрос.Выполнить();

    ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

    Если ВыборкаДетальныеЗаписи.Следующий() Тогда
        ЗаполнитьЗначенияСвойств(СтруктураИндексаЦен, ВыборкаДетальныеЗаписи);
    КонецЕсли;   
    
    Возврат СтруктураИндексаЦен;
КонецФункции 

Функция КоличествоСметЭтапаДоговора(Этап) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ мЭтапыДоговоровСметы.Смета) КАК КоличествоСмет
		|ИЗ
		|	Справочник.мЭтапыДоговоров.Сметы КАК мЭтапыДоговоровСметы
		|ГДЕ
		|	мЭтапыДоговоровСметы.Ссылка = &Этап
		|	И НЕ мЭтапыДоговоровСметы.Смета.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Этап", Этап);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.КоличествоСмет;
	КонецЕсли;
	Возврат 0;
КонецФункции 
 
// Добавляет записи из ТЗ в РС мНормыВремени
//  Структура ТЗ аналогична структуре РС
//
// Принцип: Из РС читаются все записи, которые не совпадают с ТЗ
//          к ним добавляются записи из ТЗ и весь РС перезаписывается полностью 
Процедура ЗаписатьНормыВремени(ТЗ) Экспорт
	Если Тз.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
        
    НаборЗаписей = РегистрыСведений.мНормыВремени.СоздатьНаборЗаписей();
    НаборЗаписей.Отбор.ТаблицаНормВремени.Установить(Тз[0].ТаблицаНормВремени);
    НаборЗаписей.Прочитать();
    
    НаборЗаписей.Загрузить(Тз);
	
    НаборЗаписей.Записать();
КонецПроцедуры 

// Помечает на удаление Строки и Колонки указанной Таблицы норм времени.
//
// Параметры
//  ТаблицаНормВремениСсылка  - Таблица норм времени
//  ПометкаУдаления  - Булево - значение свойства ПометкаУдаления.
//
Процедура УстановитьПометкуУдаленияСтрокИКолонокНормВремени(ТаблицаНормВремениСсылка, ПометкаУдаления) Экспорт
	
	НачатьТранзакцию();
	Попытка
    
        Запрос = Новый Запрос;
        Запрос.Текст = 
        "ВЫБРАТЬ
        |   мКолонкиТаблиц.Ссылка КАК КолонкаТаблицы,
        |   мСтрокиТаблиц.Ссылка КАК СтрокаТаблицы
        |ИЗ
        |   Справочник.мКолонкиТаблиц КАК мКолонкиТаблиц,
        |   Справочник.мСтрокиТаблиц КАК мСтрокиТаблиц
        |ГДЕ
        |   (мКолонкиТаблиц.Владелец = &Владелец
        |           И мСтрокиТаблиц.Владелец = &Владелец)";
        
        Запрос.УстановитьПараметр("Владелец", ТаблицаНормВремениСсылка);
        
        Выборка = Запрос.Выполнить().Выбрать();
		
        Пока Выборка.Следующий() Цикл
            Если ЗначениеЗаполнено(Выборка.КолонкаТаблицы) Тогда
                ПодчиненныйОбъект = Выборка.КолонкаТаблицы.ПолучитьОбъект();
                ПодчиненныйОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
            КонецЕсли; 
            Если ЗначениеЗаполнено(Выборка.СтрокаТаблицы) Тогда
                ПодчиненныйОбъект = Выборка.СтрокаТаблицы.ПолучитьОбъект();
                ПодчиненныйОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
            КонецЕсли; 
		КонецЦикла;	
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, 
			ТаблицаНормВремениСсылка.Метаданные(), ТаблицаНормВремениСсылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры // УстановитьПометкуУдаленияСтрокИКолонокНормВремени(Источник.Ссылка, Источник.ПометкаУдаления)

// Помечает на удаление Строки и Колонки указанной Таблицы норм времени.
//
// Параметры
//  СборникНормВремениСсылка  - Сборник норм времени
//  ПометкаУдаления  - Булево - значение свойства ПометкаУдаления.
//
Процедура УстановитьПометкуУдаленияПримечанийИТаблицНормВремени(СборникНормВремениСсылка, ПометкаУдаления) Экспорт
	
	НачатьТранзакцию();
	Попытка
    
        Запрос = Новый Запрос;
        Запрос.Текст = 
        "ВЫБРАТЬ
        |   мПримечанияНормВремени.Ссылка КАК Примечание,
        |   мТаблицыНормВремени.Ссылка КАК Таблица
        |ИЗ
        |   Справочник.мПримечанияНормВремени КАК мПримечанияНормВремени,
        |   Справочник.мТаблицыНормВремени КАК мТаблицыНормВремени
        |ГДЕ
        |   (мПримечанияНормВремени.Владелец = &Владелец
        |           И мТаблицыНормВремени.Владелец = &Владелец)";
        
        Запрос.УстановитьПараметр("Владелец", СборникНормВремениСсылка);
        
        Выборка = Запрос.Выполнить().Выбрать();
		
        Пока Выборка.Следующий() Цикл
            Если ЗначениеЗаполнено(Выборка.Примечание) Тогда
                ПодчиненныйОбъект = Выборка.Примечание.ПолучитьОбъект();
                ПодчиненныйОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
            КонецЕсли; 
            Если ЗначениеЗаполнено(Выборка.Таблица) Тогда
                ПодчиненныйОбъект = Выборка.Таблица.ПолучитьОбъект();
                ПодчиненныйОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
            КонецЕсли; 
		КонецЦикла;	
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, 
			СборникНормВремениСсылка.Метаданные(), СборникНормВремениСсылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры // УстановитьПометкуУдаленияПримечанийИТаблицНормВремени(Источник.Ссылка, Источник.ПометкаУдаления)

// Вид события журнала регистрации для событий данной подсистемы.
//
Функция СобытиеЖурналаРегистрации() Экспорт
	Возврат НСтр("ru = 'Смета'");
КонецФункции

Функция ПолучитьДопРеквизит(ВидСправочника, Объект, ИмяРеквизита) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДополнительныеРеквизиты.Значение КАК ЗначениеСвойства
		|ИЗ
		|	Справочник."+ВидСправочника+".ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
		|ГДЕ
		|	ДополнительныеРеквизиты.Ссылка = &Объект
		|	И ДополнительныеРеквизиты.Свойство = &ВыбСвойство";

    ВыбСвойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(ИмяРеквизита);
	Запрос.УстановитьПараметр("Объект", Объект);
	Запрос.УстановитьПараметр("ВыбСвойство", ВыбСвойство);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ЗначениеСвойства;
	КонецЕсли; 

	Возврат Неопределено;
КонецФункции // ПолучитьДопРеквизит()

// Возвращает реквизиты ставки НДС
Функция ПолучитьРеквСтавкиНДС(СсылкаСтавкаНДС) Экспорт
    Рекв = Новый Структура("Ставка, БезНДС", 0, Истина); 
    Если ЗначениеЗаполнено(СсылкаСтавкаНДС) Тогда
        Рекв.Вставить("Ставка", СсылкаСтавкаНДС.Ставка);

        Если (СсылкаСтавкаНДС <> Справочники.мСтавкиНДС.БезНДС)И(СсылкаСтавкаНДС <> Справочники.мСтавкиНДС.НДС_0) Тогда
            Рекв.Вставить("БезНДС", Ложь);
        КонецЕсли; 
    КонецЕсли;
    Возврат Рекв;
КонецФункции // ПолучитьЗначениеСтавкиНДС(Объект.СтавкаНДС)

Функция НеУказанПунктОсвобожденияОтНДС(СсылкаСтавкаНДС, СсылкаОсвобождениеОтНДС) Экспорт
    НеУказанПункт = Ложь;
    
    РеквСтавкиНДС = мРаботаСоСметами.ПолучитьРеквСтавкиНДС(СсылкаСтавкаНДС);
    ЗначениеСтавкиНДС = РеквСтавкиНДС.Ставка;
    БезНДС = РеквСтавкиНДС.БезНДС;
    
    Если БезНДС и Не ЗначениеЗаполнено(СсылкаОсвобождениеОтНДС) Тогда
        //Сообщить("Не указан пункт Освобождения от НДС!");
        НеУказанПункт = Истина;
    КонецЕсли; 
    Возврат НеУказанПункт;
КонецФункции

// Возвращает 2 первых слова из параметра Наименование
Функция ПолучитьДваСлова(Наименование) Экспорт
    ВозвращаемаяСтрока = "";
    КоличествоПробелов = 0;
    ДлинаСтроки = СтрДлина(Наименование);
    
    Для й=1 По ДлинаСтроки Цикл
        СимволСтроки = Сред(Наименование, й, 1);
        Если СимволСтроки = " " Тогда
            КоличествоПробелов = КоличествоПробелов + 1;
        КонецЕсли; 
        Если КоличествоПробелов = 2 Тогда
            Прервать;
        КонецЕсли; 
        ВозвращаемаяСтрока = ВозвращаемаяСтрока + СимволСтроки;                            
    КонецЦикла;
    Возврат ВозвращаемаяСтрока;
КонецФункции 

// Возвращает Истину, если сборник действует на ПроверяемаяДата
Функция СборникНормВремениДействует(Сборник, ПроверяемаяДата) Экспорт
	Действует = Истина;
	Если ЗначениеЗаполнено(Сборник.ДатаОкончания) и Сборник.ДатаОкончания < ПроверяемаяДата Тогда
		Действует = Ложь;
	КонецЕсли; 
	Если ЗначениеЗаполнено(Сборник.ДатаНачала) и Сборник.ДатаНачала > ПроверяемаяДата Тогда
		Действует = Ложь;
	КонецЕсли; 
	Возврат Действует;
КонецФункции 

// Возвращает Истину, если Шаблон Сметы действует на ПроверяемаяДата
Функция ШаблонСметыДействует(ШаблонСметы, ПроверяемаяДата) Экспорт
	Действует = Истина;
	Если ЗначениеЗаполнено(ШаблонСметы.ДатаОкончания) и ШаблонСметы.ДатаОкончания < ПроверяемаяДата Тогда
		Действует = Ложь;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ШаблонСметы.ДатаНачала) и ШаблонСметы.ДатаНачала > ПроверяемаяДата Тогда
		Действует = Ложь;
	КонецЕсли; 
	Возврат Действует;
КонецФункции 

// Возвращает ссылку на карточку по Поручению
Функция ПолучитьКарточкуПоПоручению(ВходДок) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мКарточкиОбъектовРабот.Ссылка
		|ИЗ
		|	Справочник.мКарточкиОбъектовРабот КАК мКарточкиОбъектовРабот
		|ГДЕ
		|	мКарточкиОбъектовРабот.Поручение = &Поручение
		|	И НЕ мКарточкиОбъектовРабот.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Поручение", ВходДок);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Ссылка; 
	КонецЦикла;
	
КонецФункции // ПолучитьКарточкуПоПоручению(ПараметрКоманды)

Функция ПолучитьСборникУтвержден(Сборник, НаДату = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мСборникУтвержденСрезПоследних.Утвержден
		|ИЗ
		|	РегистрСведений.мСборникУтвержден.СрезПоследних(&НаДату, СборникНормВремени = &Сборник) КАК мСборникУтвержденСрезПоследних";
	
	Запрос.УстановитьПараметр("НаДату", НаДату);
	Запрос.УстановитьПараметр("Сборник", Сборник);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Утвержден;
	КонецЦикла;
	
	Возврат "";
	
КонецФункции // ПолучитьСборникУтвержден()

#Область РасходМатериалов

// Определяет какие параметры объектов относятся к расходуемым материалам
Функция ПолучитьМассивРасходуемыхМатериалов() Экспорт
	МассивМатериалов = Новый Массив;
	МассивМатериалов.Добавить(ПланыВидовХарактеристик.ПараметрыОбъектов.КоличествоМежевыхЗнаков);
	МассивМатериалов.Добавить(ПланыВидовХарактеристик.ПараметрыОбъектов.КоличествоМеталлическихШтырей);
	
	Возврат МассивМатериалов;
КонецФункции // ПолучитьМассивРасходуемыхМатериалов()

// По переданному этапу определяет есть ли дело и если есть,
//  то записывает по нему план расхода материалов
Процедура ОпределитьПланРасходМатериалов(ЭтапДоговора) Экспорт
	Дело = мРаботаСДоговорами.ПолучитьДелоЭтапаДоговора(ЭтапДоговора);
	Если Не ЗначениеЗаполнено(Дело) Тогда
		Возврат;
	КонецЕсли; 
	
	МассивРасходов = мРаботаСоСметами.ПолучитьМассивПланРасходовМатериалов(Дело, Дело.Корреспондент);
	мРаботаСоСметами.ЗаписатьПланРасходМатериалов(МассивРасходов, Дело);

КонецПроцедуры // ОпределитьПланРасходМатериалов(ЭтапДоговора)

// Возвращает массив плановых расходов материалов по делу
Функция ПолучитьМассивПланРасходовМатериалов(Дело, Корреспондент) Экспорт
	Если мРаботаСДоговорами.ЭтоФизЛицо(Корреспондент) Тогда
		МассивРасходов = Новый Массив;
		Материал = ПланыВидовХарактеристик.ПараметрыОбъектов.КоличествоМежевыхЗнаков;
		Расход = Новый Структура("Материал, План", Материал, 4);
		МассивРасходов.Добавить(Расход);
	Иначе	
		МассивМатериалов = мРаботаСоСметами.ПолучитьМассивРасходуемыхМатериалов();
		МассивРасходов = мРаботаСоСметами.ПолучитьПлановоеКоличествоМатериалов(Дело, МассивМатериалов);
	КонецЕсли; 
	
	Возврат МассивРасходов;
КонецФункции // ПолучитьМассивРасходуемыхМатериалов()

// Возвращает план расходов материалов по переданному массиву материалов
Функция ПолучитьПлановоеКоличествоМатериалов(Дело, МассивМатериалов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мКарточкиОбъектовРаботПараметрыОбъекта.ПараметрОбъекта КАК Материал,
		|	мКарточкиОбъектовРаботПараметрыОбъекта.Значение КАК План
		|ИЗ
		|	Справочник.мЭтапыДоговоров КАК мЭтапыДоговоров
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.мКарточкиОбъектовРабот.ПараметрыОбъекта КАК мКарточкиОбъектовРаботПараметрыОбъекта
		|		ПО мЭтапыДоговоров.КарточкаОбъектаРабот = мКарточкиОбъектовРаботПараметрыОбъекта.Ссылка
		|ГДЕ
		|	мЭтапыДоговоров.Ссылка = &ЭтапДоговора
		|	И мКарточкиОбъектовРаботПараметрыОбъекта.ПараметрОбъекта В (&МассивМатериалов)";
	
	Запрос.УстановитьПараметр("МассивМатериалов", МассивМатериалов);
	Запрос.УстановитьПараметр("ЭтапДоговора", Дело.ЭтапДоговора);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивПланРасход = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		Расход = Новый Структура("Материал, План", Выборка.Материал, Число(Выборка.План));
		МассивПланРасход.Добавить(Расход);
	КонецЦикла;
	
	Возврат МассивПланРасход;
КонецФункции // ПолучитьПлановоеКоличествоМатериалов(Источник.Ссылка, МассивМатериалов)

// Записывает плановый расход материалов в РС
Функция ЗаписатьПланРасходМатериалов(МассивРасходов, Дело) Экспорт
	Если МассивРасходов.Количество() > 0 Тогда
		НаборЗаписей = РегистрыСведений.мРасходМатериалов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Дело.Установить(Дело);
		
		Записывать = Ложь;
		
		Для каждого Расход Из МассивРасходов Цикл
			Если Расход.План <> 0 Тогда
				НаборЗаписей.Отбор.Материал.Установить(Расход.Материал);
				НаборЗаписей.Прочитать();
				
				Если НаборЗаписей.Количество() = 0 Тогда
					ЗаписьНабора = НаборЗаписей.Добавить();
				Иначе
					ЗаписьНабора = НаборЗаписей[0];
				КонецЕсли; 
				
				ЗаписьНабора.Дело = Дело;
				ЗаписьНабора.Материал = Расход.Материал;
				ЗаписьНабора.План = Расход.План;
				
				Записывать = Истина;
			КонецЕсли; 
		КонецЦикла;
		Если Записывать Тогда
			НаборЗаписей.Записать();
		КонецЕсли; 
	КонецЕсли;  
КонецФункции // ЗаписатьРасходМатериалов(МассивРасходов)

// Возвращает массив данных из РС мРасходМатериалов
Функция ПрочитатьРасходМатериалов(Дело, МассивМатериалов = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мРасходМатериалов.Материал,
		|	мРасходМатериалов.План,
		|	мРасходМатериалов.Факт
		|ИЗ
		|	РегистрСведений.мРасходМатериалов КАК мРасходМатериалов
		|ГДЕ
		|	мРасходМатериалов.Дело = &Дело";
		
		Если МассивМатериалов <> Неопределено Тогда
			Запрос.Текст = Запрос.Текст + "
			|	И мРасходМатериалов.Материал В(&МассивМатериалов)";
			
			Запрос.УстановитьПараметр("МассивМатериалов", МассивМатериалов);
		КонецЕсли; 
	
	Запрос.УстановитьПараметр("Дело", Дело);
	
	Выборка = Запрос.Выполнить().Выбрать();
	МассивРасходов = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		СтруктураРасхода = Новый Структура("Материал, План, Факт");
		ЗаполнитьЗначенияСвойств(СтруктураРасхода, Выборка);
		МассивРасходов.Добавить(СтруктураРасхода);
	КонецЦикла;
	
	Возврат МассивРасходов;
КонецФункции // ПрочитатьРасходМатериалов()
#КонецОбласти 