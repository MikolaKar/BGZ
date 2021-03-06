
&НаКлиенте
Процедура Ок(Команда)
    ОкНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОкНаСервере()
    // Таблицы
    СоответствиеТаблиц = СкопироватьТаблицы();
    
    // Примечания
    СкопироватьПримечания(СоответствиеТаблиц);
    
КонецПроцедуры

// Копирует таблицы норм времени Источника в Приемник
//
&НаСервере
Функция СкопироватьТаблицы()
    МассивТаблиц = ПолучитьМассивТаблицДляКопирования();
    
    СоответствиеСтрок = Новый Соответствие; // Для записи РС мНормыВремени
    СоответствиеКолонок = Новый Соответствие; // Для записи РС мНормыВремени
    СоответствиеТаблиц = Новый Соответствие; // Для копирования Примечаний
    
    Данные = ПолучитьДанныеДляКопирования(МассивТаблиц);
	
	ИзменятьНаименованиеТаблиц = Приемник = Источник;
    
    Колонки = Данные.Колонки;
    Строки = Данные.Строки;
    
    // Копирование таблицы
    Для каждого СтрТаб Из МассивТаблиц Цикл
        НовТаб = СтрТаб.Скопировать();
        НовТаб.Владелец = Приемник;
        НовТаб.Родитель = "";
		Если ИзменятьНаименованиеТаблиц Тогда
			НовТаб.Наименование = НовТаб.Наименование+" *";
		КонецЕсли; 
        НовТаб.Записать();
        СоответствиеТаблиц.Вставить(СтрТаб, НовТаб.Ссылка);
        
        // Копирование Строк
        Отбор = Новый Структура("Таблицы", СтрТаб);
        
        СтрокиСтрок = Строки.НайтиСтроки(Отбор);
        Для каждого Стр Из СтрокиСтрок Цикл
            НовСтрока = Стр.Строки.Скопировать();
        	НовСтрока.Владелец = НовТаб.Ссылка;
            НовСтрока.Записать();
            СоответствиеСтрок.Вставить(Стр.Строки, НовСтрока.Ссылка);
        КонецЦикла;
        
        // Копирование Колонок
        СтрокиКолонок = Колонки.НайтиСтроки(Отбор);
        Для каждого Стр Из СтрокиКолонок Цикл
            НовКолонка = Стр.Колонки.Скопировать();
        	НовКолонка.Владелец = НовТаб.Ссылка;
            НовКолонка.Записать();
            СоответствиеКолонок.Вставить(Стр.Колонки, НовКолонка.Ссылка);
       КонецЦикла; 
    КонецЦикла; 
    
    СкопироватьРСНормыВремени(МассивТаблиц, СоответствиеТаблиц, СоответствиеСтрок, СоответствиеКолонок);

    Возврат СоответствиеТаблиц;
КонецФункции 

// Копирует Примечания норм времени Источника в Приемник
//
&НаСервере
Процедура СкопироватьПримечания(СоответствиеТаблиц)
    Для каждого Стр Из Примечания Цикл
        Если Стр.Пометка Тогда
            ИскПрим = Справочники.мПримечанияНормВремени.НайтиПоНаименованию(Стр.Представление, Истина, , Приемник);
            
            Если Не ЗначениеЗаполнено(ИскПрим) Тогда
                // Создаем новый
                НовПрим = Стр.Значение.Скопировать();
                НовПрим.Владелец = Приемник;
                НовПрим.Родитель = "";
                
                // Заменяем таблицы Источника на таблицы Приемника 
                Для каждого СтрТаб Из НовПрим.ТаблицыНормВремени Цикл
                    ИскТаблица = СоответствиеТаблиц.Получить(СтрТаб.ТаблицаНормВремени);
                    Если Не ЗначениеЗаполнено(ИскТаблица) Тогда
                        ИскТаблица = Справочники.мТаблицыНормВремени.НайтиПоНаименованию(СтрТаб.ТаблицаНормВремени.Наименование, Истина, ,Приемник);
                        
                        Если Не ЗначениеЗаполнено(ИскТаблица) Тогда
                            ИскТаблица = Справочники.мТаблицыНормВремени.НайтиПоНаименованию(СтрТаб.ТаблицаНормВремени.Наименование, Истина, ,Приемник);
                            
                        КонецЕсли; 
                    КонецЕсли; 
                    СтрТаб.ТаблицаНормВремени = ИскТаблица;
                КонецЦикла; 
                НовПрим.Записать();
                
            Иначе
                // Элемент есть - проверим таблицы
                
            	
            
            КонецЕсли; 
        КонецЕсли; 
    КонецЦикла; 
КонецПроцедуры // СкопироватьПримечания()

// Копирует значения норм времени для новых объектов
&НаСервере
Процедура СкопироватьРСНормыВремени(МассивТаблиц, СоответствиеТаблиц, СоответствиеСтрок, СоответствиеКолонок)
    // 1) Читаем записи для МассивТаблиц
    // 2) Переделываем ТЗ для новых объектов
    // 3) Добавляем данные из ТЗ в РС
    
    // 1) Читаем записи для МассивТаблиц
    Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ
        |	мНормыВремени.СтрокаТаблицы,
        |	мНормыВремени.КолонкаТаблицы,
        |	мНормыВремени.НормаВремени,
        |	мНормыВремени.НормаВремениНачальная,
        |	мНормыВремени.ТаблицаНормВремени,
        |	мНормыВремени.Период
        |ИЗ
        |	РегистрСведений.мНормыВремени КАК мНормыВремени
        |ГДЕ
		//|	мНормыВремени.ТаблицаНормВремени В(&МассивТаблиц)";
		|   (мНормыВремени.СтрокаТаблицы.Владелец В (&МассивТаблиц)
		|           ИЛИ мНормыВремени.КолонкаТаблицы.Владелец В (&МассивТаблиц))";

    Запрос.УстановитьПараметр("МассивТаблиц", МассивТаблиц);

    Результат = Запрос.Выполнить().Выгрузить();

    // 2) Переделываем ТЗ для новых объектов
    Для каждого Стр Из Результат Цикл
        Стр.ТаблицаНормВремени = СоответствиеТаблиц.Получить(Стр.ТаблицаНормВремени);
        Стр.СтрокаТаблицы = СоответствиеСтрок.Получить(Стр.СтрокаТаблицы);
        Стр.КолонкаТаблицы = СоответствиеКолонок.Получить(Стр.КолонкаТаблицы);
		Если ЗначениеЗаполнено(ДатаДействия) Тогда
			Стр.Период = ДатаДействия;
		КонецЕсли; 
    КонецЦикла; 
    
    // 3) Добавляем данные из ТЗ в РС
    мРаботаСоСметами.ЗаписатьНормыВремени(Результат);

КонецПроцедуры 
  
&НаСервере
Функция ПолучитьДанныеДляКопирования(МассивТаблиц)

    Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ
        |   мКолонкиТаблиц.Ссылка КАК Колонки,
        |   мКолонкиТаблиц.Владелец КАК Таблицы
        |ИЗ
        |   Справочник.мКолонкиТаблиц КАК мКолонкиТаблиц
        |ГДЕ
        |   мКолонкиТаблиц.Владелец В(&МассивТаблиц)
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |   мСтрокиТаблиц.Ссылка КАК Строки,
        |   мСтрокиТаблиц.Владелец КАК Таблицы
        |ИЗ
        |   Справочник.мСтрокиТаблиц КАК мСтрокиТаблиц
        |ГДЕ
        |   мСтрокиТаблиц.Владелец В(&МассивТаблиц)";

    Запрос.УстановитьПараметр("МассивТаблиц", МассивТаблиц);

    Результат = Запрос.ВыполнитьПакет();

    Колонки = Результат[0].Выгрузить();
    Строки = Результат[1].Выгрузить();

	Данные = Новый Структура("Колонки, Строки", Колонки, Строки); 
    Возврат Данные;

КонецФункции // ПолучитьДанныеДляКопирования(МассивТаблиц)

&НаСервере
Функция ПолучитьМассивТаблицДляКопирования()
    МассивТаблиц = Новый Массив;
    Для каждого СтрТаб Из Таблицы Цикл
        
        Если СтрТаб.Пометка Тогда
            МассивТаблиц.Добавить(СтрТаб.Значение);
        КонецЕсли; 
        
    КонецЦикла; 
    Возврат МассивТаблиц;
КонецФункции 

&НаКлиенте
Процедура ИсточникПриИзменении(Элемент)
    ИсточникПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ИсточникПриИзмененииНаСервере()
    Таблицы.Очистить();
    Примечания.Очистить();
    
    Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ
        |   мТаблицыНормВремени.Ссылка КАК Таблица
        |ИЗ
        |   Справочник.мТаблицыНормВремени КАК мТаблицыНормВремени
        |ГДЕ
        |   мТаблицыНормВремени.Владелец = &Владелец
        |   И НЕ мТаблицыНормВремени.ЭтоГруппа
        |
        |УПОРЯДОЧИТЬ ПО
        |   мТаблицыНормВремени.Наименование
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |   мПримечанияНормВремени.Ссылка КАК Примечание,
        |   мПримечанияНормВремени.Наименование КАК Наименование
        |ИЗ
        |   Справочник.мПримечанияНормВремени КАК мПримечанияНормВремени
        |ГДЕ
        |   мПримечанияНормВремени.Владелец = &Владелец
        |   И НЕ мПримечанияНормВремени.ЭтоГруппа
        |
        |УПОРЯДОЧИТЬ ПО
        |   Наименование";

    Запрос.УстановитьПараметр("Владелец", Источник);

    РезультатЗапроса = Запрос.ВыполнитьПакет();
    ТзТаблиц = РезультатЗапроса[0].Выгрузить();
    ТзПримечаний = РезультатЗапроса[1].Выгрузить();
    
    МассивТаблиц = ТзТаблиц.ВыгрузитьКолонку("Таблица");
    Таблицы.ЗагрузитьЗначения(МассивТаблиц);
    Таблицы.ЗаполнитьПометки(Истина);
    
    Для каждого СтрПрим Из ТзПримечаний Цикл
        Примечания.Добавить(СтрПрим.Примечание, СтрПрим.Наименование);    
    КонецЦикла; 
     
    Примечания.ЗаполнитьПометки(Истина);

КонецПроцедуры
