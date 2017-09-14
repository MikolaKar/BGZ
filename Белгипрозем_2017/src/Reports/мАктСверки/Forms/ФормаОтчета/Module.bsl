
&НаКлиенте
Процедура КорреспондентПриИзменении(Элемент)
    КорреспондентПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура КорреспондентПриИзмененииНаСервере()
    
    Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ
        |   Корреспонденты.Ссылка,
        |   ВЫРАЗИТЬ(Корреспонденты.ПолноеНаименование КАК СТРОКА(1000)) КАК Представление,
        |   ВЫРАЗИТЬ(Корреспонденты.Наименование КАК СТРОКА(1000)) КАК Наименование
        |ИЗ
        |   Справочник.Корреспонденты КАК Корреспонденты
        |ГДЕ
        |   (Корреспонденты.ИНН = &ИНН
        |               И Корреспонденты.ИНН <> """"
        |           ИЛИ Корреспонденты.ИНН = """"
        |               И Корреспонденты.Наименование = &НаименованиеКорреспондента)
        |   И НЕ Корреспонденты.ПометкаУдаления";
    
    Запрос.УстановитьПараметр("ИНН", Корреспондент.ИНН);
    Запрос.УстановитьПараметр("НаименованиеКорреспондента", Корреспондент.Наименование);
   
    РезультатЗапроса = Запрос.Выполнить();
    
    ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
    
    СписокКорреспондентов.Очистить();
    
    Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
        СписокКорреспондентов.Добавить(ВыборкаДетальныеЗаписи.Ссылка, ?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Наименование), ВыборкаДетальныеЗаписи.Наименование,ВыборкаДетальныеЗаписи.Представление+"(Код " + ВыборкаДетальныеЗаписи.Ссылка.Код+")"), Истина); 
    КонецЦикла;
    
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДанныеНаСервере(ВариантЗапроса="")
    
    СписокВыбранныхКонтрагентов = ПолучитьСписокВыбранныхКорреспондентов(СписокКорреспондентов); 
    
    Если СписокВыбранныхКонтрагентов.Количество() = 0 Тогда
        Возврат Неопределено;
    КонецЕсли; 
    
    Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ РАЗРЕШЕННЫЕ
        |   РасчетыСПокупателямиОбороты.Договор КАК Договор,
        |   0 КАК ОстатокНаНачало,
        |   СУММА(ВЫБОР
        |       КОГДА ЕСТЬNULL(РасчетыСПокупателямиОбороты.СуммаПриход,0) > 0
        |           ТОГДА РасчетыСПокупателямиОбороты.СуммаПриход
        |       ИНАЧЕ 0
        |   КОНЕЦ) КАК Оплата,
        |   СУММА(ВЫБОР
        |       КОГДА ЕСТЬNULL(РасчетыСПокупателямиОбороты.СуммаПриход, 0) < 0
        |           ТОГДА -РасчетыСПокупателямиОбороты.СуммаПриход
        |       ИНАЧЕ 0
        |   КОНЕЦ) КАК Возврат,
        |   СУММА(ЕСТЬNULL(РасчетыСПокупателямиОбороты.СуммаРасход,0)) КАК Заактировано,
        |   0 КАК ОстатокНаКонец,
        |   РасчетыСПокупателями.НомерДокумента КАК НомерДокумента,
        |   ВЫБОР
        |       КОГДА РасчетыСПокупателями.ДатаДокумента = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
        |           ТОГДА НАЧАЛОПЕРИОДА(РасчетыСПокупателямиОбороты.Период, ДЕНЬ)
        |       ИНАЧЕ РасчетыСПокупателями.ДатаДокумента
        |   КОНЕЦ КАК ДатаДокумента,
        |   НАЧАЛОПЕРИОДА(РасчетыСПокупателямиОбороты.Период, ДЕНЬ) КАК ДатаПроводки,
        |   ГОД(РасчетыСПокупателямиОбороты.Договор.ДатаРегистрации) КАК ГодРегистрации,
        |   РасчетыСПокупателямиОбороты.Договор.РегистрационныйНомер КАК РегистрационныйНомер,
        |   РасчетыСПокупателямиОбороты.Договор.ЧисловойНомер КАК ЧисловойНомер,
        |   РасчетыСПокупателямиОбороты.Договор.ДатаРегистрации КАК ДатаРегистрации,
        |   РасчетыСПокупателямиОбороты.Регистратор КАК Документ
        |ИЗ
        |   РегистрНакопления.РасчетыСПокупателями.Обороты(
        |           &ДатаНачала,
        |           &ДатаОкончания,
        |           Запись,
        |           Корреспондент В ИЕРАРХИИ (&СписокКонтрагентов)
        |               И ВЫБОР
        |                   КОГДА &ДоговорКонтрагента = Значение(Справочник.ВнутренниеДокументы.ПустаяСсылка) ИЛИ &ДоговорКонтрагента = НЕОПРЕДЕЛЕНО
        |                       ТОГДА ИСТИНА
        |                   ИНАЧЕ Договор В ИЕРАРХИИ (&ДоговорКонтрагента)
        |               КОНЕЦ) КАК РасчетыСПокупателямиОбороты
        |       ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСПокупателями КАК РасчетыСПокупателями
        |       ПО РасчетыСПокупателямиОбороты.ЭтапДоговора = РасчетыСПокупателями.ЭтапДоговора
        |           И РасчетыСПокупателямиОбороты.Регистратор = РасчетыСПокупателями.Регистратор
        |           И РасчетыСПокупателямиОбороты.НомерСтроки = РасчетыСПокупателями.НомерСтроки
        |
         |СГРУППИРОВАТЬ ПО
        |	РасчетыСПокупателями.НомерДокумента,
        |	ВЫБОР
        |		КОГДА РасчетыСПокупателями.ДатаДокумента = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
        |			ТОГДА НАЧАЛОПЕРИОДА(РасчетыСПокупателямиОбороты.Период, ДЕНЬ)
        |		ИНАЧЕ РасчетыСПокупателями.ДатаДокумента
        |	КОНЕЦ,
        |	РасчетыСПокупателямиОбороты.Договор,
        |	РасчетыСПокупателямиОбороты.Договор.РегистрационныйНомер,
        |	РасчетыСПокупателямиОбороты.Договор.ЧисловойНомер,
        |	РасчетыСПокупателямиОбороты.Договор.ДатаРегистрации,
        |	РасчетыСПокупателямиОбороты.Регистратор,
        |	НАЧАЛОПЕРИОДА(РасчетыСПокупателямиОбороты.Период, ДЕНЬ)
         |
      |ОБЪЕДИНИТЬ ВСЕ
        |
        |ВЫБРАТЬ
        |   РасчетыСПокупателямиОстаткиИОбороты.Договор,
        |   ЕСТЬNULL(РасчетыСПокупателямиОстаткиИОбороты.СуммаНачальныйОстаток, 0),
        |   0,
        |   0,
        |   0,
        |   ЕСТЬNULL(РасчетыСПокупателямиОстаткиИОбороты.СуммаКонечныйОстаток,0),
        |   NULL,
        |   """",
        |   NULL,
        |   ГОД(РасчетыСПокупателямиОстаткиИОбороты.Договор.ДатаРегистрации),
        |   РасчетыСПокупателямиОстаткиИОбороты.Договор.РегистрационныйНомер,
        |   РасчетыСПокупателямиОстаткиИОбороты.Договор.ЧисловойНомер,
        |   РасчетыСПокупателямиОстаткиИОбороты.Договор.ДатаРегистрации,
        |   NULL
        |ИЗ
        |   РегистрНакопления.РасчетыСПокупателями.ОстаткиИОбороты(
        |           &ДатаНачала,
        |           &ДатаОкончания,
        |           Период,
        |           ДвиженияИГраницыПериода,
        |           Корреспондент В ИЕРАРХИИ (&СписокКонтрагентов)
        |               И ВЫБОР
        |                   КОГДА &ДоговорКонтрагента = Значение(Справочник.ВнутренниеДокументы.ПустаяСсылка) ИЛИ &ДоговорКонтрагента = НЕОПРЕДЕЛЕНО
        |                       ТОГДА ИСТИНА
        |                   ИНАЧЕ Договор В ИЕРАРХИИ (&ДоговорКонтрагента)
        |               КОНЕЦ) КАК РасчетыСПокупателямиОстаткиИОбороты
	    |
	|УПОРЯДОЧИТЬ ПО";
        
    Если РазбитьПоДоговорам Тогда
        Запрос.Текст = Запрос.Текст +"
        |   ГодРегистрации,
        |   ЧисловойНомер,";
    КонецЕсли; 
    
        Запрос.Текст = Запрос.Текст +"
        |   ДатаДокумента,
        |   НомерДокумента
        |ИТОГИ
        |   СУММА(ОстатокНаНачало),
        |   СУММА(Оплата),
        |   СУММА(Возврат),
        |   СУММА(Заактировано),
        |   СУММА(ОстатокНаКонец)";
    Если РазбитьПоДоговорам Тогда
        Запрос.Текст = Запрос.Текст +"
        |ПО
        |   ОБЩИЕ,
        |   Договор";
    Иначе
        Запрос.Текст = Запрос.Текст +"
        |ПО
        |   ОБЩИЕ";
    КонецЕсли; 
    
    Запрос.УстановитьПараметр("ДоговорКонтрагента", ?(НЕ ЗначениеЗаполнено(Договор), Неопределено,	Договор));
	Если ЗначениеЗаполнено(ВариантЗапроса) Тогда
		Если ВариантЗапроса = "ДоДеноминации" Тогда
			ДатаНачалаЗапроса = ?(НЕ ЗначениеЗаполнено(ДатаНачала), Дата(1,1,1), ДатаНачала);
			ДатаОкончанияЗапроса = НачалоДня(ДатаДеноминации)-1;

		ИначеЕсли ВариантЗапроса = "Деноминация" Тогда
			ДатаНачалаЗапроса = ДатаДеноминации;
			ДатаОкончанияЗапроса = КонецДня(ДатаДеноминации);
		Иначе
			// ПослеДеноминации
			ДатаНачалаЗапроса = КонецДня(ДатаДеноминации)+1;
			ДатаОкончанияЗапроса = ?(НЕ ЗначениеЗаполнено(ДатаОкончания), КонецДня(ТекущаяДата()), КонецДня(ДатаОкончания));
		КонецЕсли; 
	Иначе	
		ДатаНачалаЗапроса = ?(НЕ ЗначениеЗаполнено(ДатаНачала), Дата(1,1,1), ДатаНачала);
		ДатаОкончанияЗапроса = ?(НЕ ЗначениеЗаполнено(ДатаОкончания), КонецДня(ТекущаяДата()), КонецДня(ДатаОкончания));
	КонецЕсли; 
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачалаЗапроса);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончанияЗапроса);
		
    Запрос.УстановитьПараметр("СписокКонтрагентов", СписокВыбранныхКонтрагентов);
    
    РезультатЗапроса = Запрос.Выполнить();
    
    Возврат РезультатЗапроса;
    
КонецФункции

&НаСервере
Функция ПолучитьЧисловойНомер(ТекСтрока)
    ЧисловойНомер = "";
    Для й=1 По СтрДлина(ТекСтрока) Цикл
    	Цифра = Сред(ТекСтрока, й, 1);
        Если Найти("0123456789", Цифра) > 0 Тогда
            ЧисловойНомер = ЧисловойНомер + Цифра;
        Иначе
            Прервать;        
        КонецЕсли; 
    КонецЦикла; 
    Возврат Число(ЧисловойНомер);
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСписокВыбранныхКорреспондентов(СписокКорреспондентов)
    СписокВыбранныхКонтрагентов = Новый СписокЗначений;
    Для каждого Стр Из СписокКорреспондентов Цикл
        Если Стр.Пометка Тогда
            СписокВыбранныхКонтрагентов.Добавить(Стр.Значение);
        КонецЕсли; 
    КонецЦикла; 
    Возврат СписокВыбранныхКонтрагентов;
КонецФункции

&НаКлиенте
Процедура ПечатьАкта(Команда)
    
    Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаАкт;
    
    //ЗаполнитьДанные(Команда);
    
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("НомерАкта", НомерАкта);
	ПараметрыПечати.Вставить("ДатаАкта", ДатаАкта);
	ПараметрыПечати.Вставить("ДатаНачала", Период.ДатаНачала);
	ПараметрыПечати.Вставить("ДатаОкончания", Период.ДатаОкончания);
	//ПараметрыПечати.Вставить("Данные", ПоДаннымОрганизации);
 	ПараметрыПечати.Вставить("Корреспондент", Корреспондент);
  	ПараметрыПечати.Вставить("ДоговорКонтрагента", Договор);
	ПараметрыПечати.Вставить("ОстатокНаНачало", ОстатокНаНачало);
 	ПараметрыПечати.Вставить("ОстатокНаКонец", ОстатокНаКонец);
	ПараметрыПечати.Вставить("ПредставительОрганизации", ПредставительОрганизации);
 	ПараметрыПечати.Вставить("ПредставительКонтрагента", ПредставительКонтрагента);
	ПараметрыПечати.Вставить("ПредставительОрганизации1", ПредставительОрганизации1);
 	ПараметрыПечати.Вставить("ПредставительКонтрагента1", ПредставительКонтрагента1);
 	ПараметрыПечати.Вставить("РазбитьПоДоговорам", РазбитьПоДоговорам);
    
    //УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Отчет.мАктСверки", "ПФ_MXL_АктСверки", Договор, ЭтаФорма, ПараметрыПечати);
    Результат = ПечатьАктаСверки(ПараметрыПечати);
    
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНашуОрганизацию()
    Возврат Константы.НашаОрганизация.Получить().ПолноеНаименование;	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьОсновнаяВалюта()
    Возврат Константы.ОсновнаяВалюта.Получить();	
КонецФункции

&НаСервере
Процедура ВывестиЗаголовокАкта(Макет, ПараметрыПечати, ТабличныйДокумент)
    Корреспондент = ПараметрыПечати.Корреспондент;
    ДоговорКонтрагента = ПараметрыПечати.ДоговорКонтрагента;
	ПредставительОрганизации = ПараметрыПечати.ПредставительОрганизации;
 	ПредставительКонтрагента = ПараметрыПечати.ПредставительКонтрагента;
  	РазбитьПоДоговорам = ПараметрыПечати.РазбитьПоДоговорам;
    
    // Получаем области:
    ОбластьЗаголовок    = Макет.ПолучитьОбласть("Заголовок");
    ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");

	// Заголовок
    ПредставлениеОрганизации = Константы.НашаОрганизация.Получить().ПолноеНаименование; //ПолучитьНашуОрганизацию(); //
    ПредставлениеКонтрагента = Корреспондент.ПолноеНаименование;
    
    Если ЗначениеЗаполнено(НомерАкта) и ЗначениеЗаполнено(ДатаАкта) Тогда
        ОбластьЗаголовок.Параметры.НомерАкта     = "№ "+НомерАкта + " от "+Формат(ДатаАкта,"ДЛФ=Д");
        
    ИначеЕсли ЗначениеЗаполнено(НомерАкта) Тогда
        ОбластьЗаголовок.Параметры.НомерАкта     = "№ "+НомерАкта;
        
    ИначеЕсли ЗначениеЗаполнено(ДатаАкта) Тогда
        ОбластьЗаголовок.Параметры.НомерАкта     = "№ б/н от "+Формат(ДатаАкта,"ДЛФ=Д");
    КонецЕсли; 
    
    ДатаНачалаОтчета = ДатаНачала;
    
    ОписаниеПериода = ?(ЗначениеЗаполнено(ДатаНачалаОтчета),"за период: " + ПредставлениеПериода(НачалоДня( ДатаНачалаОтчета), КонецДня(ПараметрыПечати.ДатаОкончания)),"");
    
    ТекстЗаголовка = "взаимных расчетов " + ОписаниеПериода  + Символы.ПС
    + "между " + ПредставлениеОрганизации + Символы.ПС + "и " + ПредставлениеКонтрагента;
    Если ЗначениеЗаполнено(ДоговорКонтрагента) И НЕ ДоговорКонтрагента.ЭтоГруппа Тогда
        ТекстЗаголовка = ТекстЗаголовка + Символы.ПС + "по договору № "+ДоговорКонтрагента.РегистрационныйНомер+" от "+Формат(ДоговорКонтрагента.ДатаРегистрации, "ДФ=dd.MM.yyyy");
    КонецЕсли;
    
    ОбластьЗаголовок.Параметры.ТекстЗаголовка = ТекстЗаголовка;
	
	ЗаполнитьПредставителя("ПредставительОрганизацииДолжность", "ФИОПредставителя", ПредставительОрганизации, Истина); 
	ЗаполнитьПредставителя("ПредставительОрганизацииДолжность1", "ФИОПредставителя1", ПредставительОрганизации1, Истина); 
	ЗаполнитьПредставителя("ПредставительКонтрагентаДолжность", "ФИОПредставителяКонтрагента", ПредставительКонтрагента, Ложь); 
	ЗаполнитьПредставителя("ПредставительКонтрагентаДолжность1", "ФИОПредставителяКонтрагента1", ПредставительКонтрагента1, Ложь); 
	
	//Если ЗначениеЗаполнено(ПредставительОрганизации) Тогда
	//    ПредставительОрганизацииДолжность = РаботаСПользователями.ПолучитьДолжность(ПредставительОрганизации);
	//    ФИОПредставителя = ПредставительОрганизации.ПредставлениеВДокументах;
	//Иначе
	//    ПредставительОрганизацииДолжность = "________________";
	//    ФИОПредставителя = "________________";
	//КонецЕсли; 
	//
	//Если ЗначениеЗаполнено(ПредставительКонтрагента) Тогда
	//    ПредставительКонтрагентаДолжность = ПредставительКонтрагента.Должность;
	//    ФИОПредставителяКонтрагента = ПредставительКонтрагента.Наименование;
	//Иначе
	//    ПредставительКонтрагентаДолжность = "________________";
	//    ФИОПредставителяКонтрагента = "________________";
	//КонецЕсли; 

    СтрЗаголовокТаблица = "Мы, нижеподписавшиеся, " + ПредставительОрганизацииДолжность + " " + ПредставлениеОрганизации
    + " " + ФИОПредставителя + ", с одной стороны, "
    + "и " + ПредставительКонтрагентаДолжность	+ " " + ПредставлениеКонтрагента + " " + ФИОПредставителяКонтрагента + ", с другой стороны, "
    + "составили настоящий акт сверки в том, что состояние взаимных расчетов по данным учета следующее:";
    
    ОбластьЗаголовок.Параметры.СтрЗаголовокТаблица = СтрЗаголовокТаблица;
    
    ТабличныйДокумент.Вывести(ОбластьЗаголовок);

    // Шапка таблицы
	ОбластьШапкаТаблицы.Параметры.НазваниеОрганизацииШапка     = "По данным " + ПредставлениеОрганизации;
	ОбластьШапкаТаблицы.Параметры.НаименованиеКонтрагентаШапка = "По данным " +  ПредставлениеКонтрагента;
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);

КонецПроцедуры // ВывестиЗаголовокАкта()

&НаСервере
Процедура ЗаполнитьПредставителя(ИмяРеквДолжности, ИмяРеквФИО, Представитель, ЭтоНаш);
	Если ЗначениеЗаполнено(Представитель) Тогда
		Если ЭтоНаш Тогда
			ЭтаФорма[ИмяРеквДолжности] = РаботаСПользователями.ПолучитьДолжность(Представитель);
			ЭтаФорма[ИмяРеквФИО] = Представитель.ПредставлениеВДокументах;
		Иначе
			ЭтаФорма[ИмяРеквДолжности] = Представитель.Должность;
			ЭтаФорма[ИмяРеквФИО] = Представитель.Наименование;
		КонецЕсли; 
    Иначе
        ЭтаФорма[ИмяРеквДолжности] = "________________";
        ЭтаФорма[ИмяРеквФИО] = "________________";
    КонецЕсли; 
КонецПроцедуры
 
&НаСервере
Процедура ВывестиПодвалАкта(Макет, ТабличныйДокумент)
	
    ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		
	ДатаСальдо = ?(НачалоДня(ДатаОкончания) = НачалоДня(ДатаДеноминации), ДатаДеноминации, КонецДня(ДатаОкончания)+1); 
	//ДатаСальдо = КонецДня(ДатаОкончания)+1;

    РезультатыСверки = "на " + Формат(ДатаСальдо, "ДФ=dd.MM.yyyy") + " задолженность ";
    
    Если ОстатокНаКонец < 0 Тогда
        РезультатыСверки = РезультатыСверки + "в пользу " + ПредставлениеОрганизации + " " 
        +мРаботаСДоговорами.СуммаЧисломИПрописью(-ОстатокНаКонец, Константы.ОсновнаяВалюта.Получить());
        
    ИначеЕсли ОстатокНаКонец > 0 Тогда
        РезультатыСверки = РезультатыСверки + "в пользу " + ПредставлениеКонтрагента + " " 
        + мРаботаСДоговорами.СуммаЧисломИПрописью(ОстатокНаКонец, Константы.ОсновнаяВалюта.Получить());
        
    Иначе
        РезультатыСверки = РезультатыСверки + "отсутствует.";
    КонецЕсли;
    
    ОбластьПодвал.Параметры.РезультатыСверки = РезультатыСверки;
    
    ОбластьПодвал.Параметры.НазваниеОрганизации     = ПредставлениеОрганизации;
    ОбластьПодвал.Параметры.НаименованиеКонтрагента = ПредставлениеКонтрагента;
    
    ОбластьПодвал.Параметры.Должность  = ПредставительОрганизацииДолжность;
    ОбластьПодвал.Параметры.ДолжностьК = ПредставительКонтрагентаДолжность;
    
    ОбластьПодвал.Параметры.ФИОПредставителя  = ФИОПредставителя;
    ОбластьПодвал.Параметры.ФИОПредставителяК = ФИОПредставителяКонтрагента;
    
    ТабличныйДокумент.Вывести(ОбластьПодвал);
	
	// Дополнительно Подвал1
	ВыводитьПодвал1 = Ложь;
	_ДолжностьК = "";
	_ФИОК = "";
	_Должность  = "";
	_ФИО  = "";
	
	Если ЗначениеЗаполнено(ПредставительКонтрагента1) Тогда
		ВыводитьПодвал1 = Истина;
		_ДолжностьК = ПредставительКонтрагентаДолжность1;
		_ФИОК = ФИОПредставителяКонтрагента1;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ПредставительОрганизации1) Тогда
		ВыводитьПодвал1 = Истина;
		_Должность  = ПредставительОрганизацииДолжность1;
		_ФИО  = ФИОПредставителя1;
	КонецЕсли; 
	Если ВыводитьПодвал1 Тогда
		ОбластьПодвал1 = Макет.ПолучитьОбласть("Подвал1");
		
		ОбластьПодвал1.Параметры.Должность  = _Должность;
		ОбластьПодвал1.Параметры.ДолжностьК = _ДолжностьК;
		ОбластьПодвал1.Параметры.ФИОПредставителя  = _ФИО;
		ОбластьПодвал1.Параметры.ФИОПредставителяК = _ФИОК;
		
		ТабличныйДокумент.Вывести(ОбластьПодвал1);
	КонецЕсли; 	
КонецПроцедуры // ВывестиПодвалАкта()

&НаСервере
Процедура ВывестиДеноминацию(Макет, ТабличныйДокумент)
	ОбластьНачОстатки   = Макет.ПолучитьОбласть("НачОстатки");
    ОбластьДоговор      = Макет.ПолучитьОбласть("Договор");
    ОбластьДоговорИтоги = Макет.ПолучитьОбласть("ДоговорИтоги");
    ОбластьДоговорИтогиСальдо = Макет.ПолучитьОбласть("ДоговорСальдо");
    ОбластьОбороты      = Макет.ПолучитьОбласть("Обороты");
    ОбластьОборотыИтог  = Макет.ПолучитьОбласть("ОборотыИтог");
    ОбластьКонОстатки   = Макет.ПолучитьОбласть("КонОстатки");
	
	// Вывод движений деноминации
	ОбластьЗаголовокСекции = Макет.ПолучитьОбласть("ЗаголовокСекции");
	ОбластьЗаголовокСекции.Параметры.ЗаголовокСекции = "Деноминация";
	ТабличныйДокумент.Вывести(ОбластьЗаголовокСекции);
	
	ДатаОкончания = КонецДня(ДатаДеноминации);
	РезультатЗапроса = ЗаполнитьДанныеНаСервере("Деноминация");
	
	ВыборкаОбщийИтог = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ВыборкаОбщийИтог.Следующий();       // Общий итог
	
	ОстатокНаНачало = ВыборкаОбщийИтог.ОстатокНаНачало;
	ОстатокНаКонец = ВыборкаОбщийИтог.ОстатокНаКонец;
	
	ОбластьНачОстатки.Параметры.СуммаНачальныйОстатокДт = ?(ОстатокНаНачало < 0, -ОстатокНаНачало, 0);
	ОбластьНачОстатки.Параметры.СуммаНачальныйОстатокКт = ?(ОстатокНаНачало > 0, ОстатокНаНачало, 0);
	ОбластьНачОстатки.Параметры.ТекстСальдоНач = "Сальдо на " + Формат(ДатаНачалаЗапроса,"ДЛФ=Д");
	ТабличныйДокумент.Вывести(ОбластьНачОстатки);
	
	Если НЕ РезультатЗапроса.Пустой() Тогда 
		Если РазбитьПоДоговорам Тогда
			ВыборкаДоговор = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			// Договора
			Пока ВыборкаДоговор.Следующий() Цикл
				
				//Выводим заголовок с договором
				ОбластьДоговор.Параметры.Договор = "Дог. № "+ВыборкаДоговор.РегистрационныйНомер+" от "+Формат(ВыборкаДоговор.ДатаРегистрации, "ДФ=dd.MM.yyyy");
				ОбластьДоговор.Параметры.Регистратор = ВыборкаДоговор.Договор;
				ОбластьДоговор.Параметры.НачСальдоДогКт = ?(ВыборкаДоговор.ОстатокНаНачало > 0, ВыборкаДоговор.ОстатокНаНачало, 0);
				ОбластьДоговор.Параметры.НачСальдоДогДт = ?(ВыборкаДоговор.ОстатокНаНачало < 0, -ВыборкаДоговор.ОстатокНаНачало, 0);
				ТабличныйДокумент.Вывести(ОбластьДоговор);
				
				Выборка = ВыборкаДоговор.Выбрать();
				
				ВыводитьОборотыПоДог = Ложь;
				
				// Документы Оплата = Кредит, Возврат + Заактировано = Дебет
				//Пока Выборка.Следующий() Цикл
				//	ОбластьОбороты.Параметры.ДатаДокумента = Выборка.ДатаПроводки;
				//	Представление = "Деноминирование остатка ";
				//	
				//	ОбластьОбороты.Параметры.РегистраторПредставление = Представление;
				//	ОбластьОбороты.Параметры.Регистратор = Выборка.Документ;
				//	Дебет = Выборка.Заактировано; 
				//	Кредит = -Выборка.Возврат;
				//	ОбластьОбороты.Параметры.СуммаОборотДт = Дебет;
				//	ОбластьОбороты.Параметры.СуммаОборотКт = Кредит;
				//	
				//	Если Дебет <> 0 Или Кредит <> 0 Тогда
				//		ТабличныйДокумент.Вывести(ОбластьОбороты);       
				//		ВыводитьОборотыПоДог = Истина;
				//	КонецЕсли; 
				//КонецЦикла;
				
				//Выводим сальдо по договору, если оно есть
				Если ВыборкаДоговор.ОстатокНаКонец <> 0 Тогда
					
					ОбластьДоговорИтогиСальдо.Параметры.СальдоДогДт = ?(ВыборкаДоговор.ОстатокНаКонец < 0, -ВыборкаДоговор.ОстатокНаКонец, 0);
					ОбластьДоговорИтогиСальдо.Параметры.СальдоДогКт = ?(ВыборкаДоговор.ОстатокНаКонец > 0, ВыборкаДоговор.ОстатокНаКонец, 0);
					ТабличныйДокумент.Вывести(ОбластьДоговорИтогиСальдо);
					
				КонецЕсли; 
			КонецЦикла;
			
		Иначе
			//Выборка = ВыборкаОбщийИтог.Выбрать();
			
			//// Документы
			//Пока Выборка.Следующий() Цикл
			//	// Документы Оплата - Кредит, Возврат и Заактировано - Дебет
			//	ОбластьОбороты.Параметры.ДатаДокумента = Выборка.ДатаПроводки;
			//	Представление = "Деноминирование остатка ";
			//	ОбластьОбороты.Параметры.РегистраторПредставление = Представление;
			//	ОбластьОбороты.Параметры.Регистратор = Выборка.Документ;
			//	Дебет = Выборка.Заактировано;
			//	Кредит = Выборка.Оплата - Выборка.Возврат;
			//	ОбластьОбороты.Параметры.СуммаОборотДт = Дебет;
			//	ОбластьОбороты.Параметры.СуммаОборотКт = Кредит;
			//	
			//	Если Дебет <> 0 Или Кредит <> 0 Тогда
			//		ТабличныйДокумент.Вывести(ОбластьОбороты);       
			//	КонецЕсли; 
			//КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
	ОбластьКонОстатки.Параметры.СуммаКонечныйОстатокДт = ?(ОстатокНаКонец < 0, -ОстатокНаКонец, 0);
	ОбластьКонОстатки.Параметры.СуммаКонечныйОстатокКт = ?(ОстатокНаКонец > 0, ОстатокНаКонец, 0);
	ОбластьКонОстатки.Параметры.ТекстСальдоКон = "Сальдо на " + Формат(ДатаНачалаЗапроса,"ДЛФ=Д");
	
	ТабличныйДокумент.Вывести(ОбластьКонОстатки);
КонецПроцедуры // ВывестиДеноминацию()

&НаСервере
Процедура ВывестиДвижения(ВариантЗапроса="", Макет, ТабличныйДокумент)
	
	ОбластьНачОстатки   = Макет.ПолучитьОбласть("НачОстатки");
    ОбластьДоговор      = Макет.ПолучитьОбласть("Договор");
    ОбластьДоговорИтоги = Макет.ПолучитьОбласть("ДоговорИтоги");
    ОбластьДоговорИтогиСальдо = Макет.ПолучитьОбласть("ДоговорСальдо");
    ОбластьОбороты      = Макет.ПолучитьОбласть("Обороты");
    ОбластьОборотыИтог  = Макет.ПолучитьОбласть("ОборотыИтог");
    ОбластьКонОстатки   = Макет.ПолучитьОбласть("КонОстатки");
	
	Если ВариантЗапроса = "ПослеДеноминации" Тогда
	    ОбластьЗаголовокСекции = Макет.ПолучитьОбласть("ЗаголовокСекции");
		ОбластьЗаголовокСекции.Параметры.ЗаголовокСекции = "";
		ТабличныйДокумент.Вывести(ОбластьЗаголовокСекции);
	КонецЕсли; 
	
	РезультатЗапроса = ЗаполнитьДанныеНаСервере(ВариантЗапроса);
    
    ВыборкаОбщийИтог = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
    
    ВыборкаОбщийИтог.Следующий();       // Общий итог
    
    ОстатокНаНачало = ВыборкаОбщийИтог.ОстатокНаНачало;
    ОстатокНаКонец = ВыборкаОбщийИтог.ОстатокНаКонец;
    
    ОбластьНачОстатки.Параметры.СуммаНачальныйОстатокДт = ?(ОстатокНаНачало < 0, -ОстатокНаНачало, 0);
    ОбластьНачОстатки.Параметры.СуммаНачальныйОстатокКт = ?(ОстатокНаНачало > 0, ОстатокНаНачало, 0);
	ДатаСальдо = ?(НачалоДня(ДатаНачалаЗапроса) = КонецДня(ДатаДеноминации)+1, ДатаДеноминации, ДатаНачалаЗапроса); 
	ОбластьНачОстатки.Параметры.ТекстСальдоНач = "Сальдо на " + Формат(ДатаСальдо,"ДЛФ=Д");
    ТабличныйДокумент.Вывести(ОбластьНачОстатки);
	
	ОбластьОборотыИтог.Параметры.СуммаОборотДт = 0;
	ОбластьОборотыИтог.Параметры.СуммаОборотКт = 0;
	
	Если НЕ РезультатЗапроса.Пустой() Тогда 
		Если РазбитьПоДоговорам Тогда
			ВыборкаДоговор = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			// Договора
			Пока ВыборкаДоговор.Следующий() Цикл
				
				//Выводим заголовок с договором
				ОбластьДоговор.Параметры.Договор = "Дог. № "+ВыборкаДоговор.РегистрационныйНомер+" от "+Формат(ВыборкаДоговор.ДатаРегистрации, "ДФ=dd.MM.yyyy");
				ОбластьДоговор.Параметры.Регистратор = ВыборкаДоговор.Договор;
				ОбластьДоговор.Параметры.НачСальдоДогКт = ?(ВыборкаДоговор.ОстатокНаНачало > 0, ВыборкаДоговор.ОстатокНаНачало, 0);
				ОбластьДоговор.Параметры.НачСальдоДогДт = ?(ВыборкаДоговор.ОстатокНаНачало < 0, -ВыборкаДоговор.ОстатокНаНачало, 0);
				ТабличныйДокумент.Вывести(ОбластьДоговор);
				
				Выборка = ВыборкаДоговор.Выбрать();
				
				ДокументовД = 0;
				ДокументовК = 0;
				
				// Документы Оплата = Кредит, Возврат + Заактировано = Дебет
				Пока Выборка.Следующий() Цикл
					ОбластьОбороты.Параметры.ДатаДокумента = Выборка.ДатаПроводки;
					НаименованиеДокумента = "Пл. пор. № ";
					
					Если ТипЗнч(Выборка.Документ) = Тип("ДокументСсылка.мВзаимозачет") Тогда
						НаименованиеДокумента = "Письмо № ";	
					КонецЕсли;  
					
					Если Выборка.Оплата > 0 Тогда
						Представление = "" +НаименованиеДокумента+ Выборка.НомерДокумента + " от " + Формат(Выборка.ДатаДокумента, "ДФ=dd.MM.yy");
						
					ИначеЕсли Выборка.Возврат > 0 Тогда
						Представление = "" +НаименованиеДокумента+ Выборка.НомерДокумента + " от " + Формат(Выборка.ДатаДокумента, "ДФ=dd.MM.yy"); 
						
					ИначеЕсли Выборка.Заактировано <> 0 Тогда
						Представление = "Акт № "+ Выборка.НомерДокумента + " от " + Формат(Выборка.ДатаДокумента, "ДФ=dd.MM.yy"); 
					КонецЕсли; 
					ОбластьОбороты.Параметры.РегистраторПредставление = Представление;
					ОбластьОбороты.Параметры.Регистратор = Выборка.Документ;
					Дебет = Выборка.Заактировано + Выборка.Возврат;
					Кредит = Выборка.Оплата;
					ОбластьОбороты.Параметры.СуммаОборотДт = Дебет;
					ОбластьОбороты.Параметры.СуммаОборотКт = Кредит;
					
					Если Дебет <> 0 Или Кредит <> 0 Тогда
						ТабличныйДокумент.Вывести(ОбластьОбороты);
						ДокументовД = ?(Дебет <> 0, ДокументовД + 1, ДокументовД);
						ДокументовК = ?(Кредит <> 0, ДокументовК + 1, ДокументовК);
					КонецЕсли; 
				КонецЦикла;
				
				//Выводим обороты по договору когда документов по Д или К больше одного
				Если ДокументовД > 1 ИЛИ ДокументовК > 1 Тогда
					ОбластьДоговорИтоги.Параметры.СуммаДогДт = ВыборкаДоговор.Заактировано + ВыборкаДоговор.Возврат;
					ОбластьДоговорИтоги.Параметры.СуммаДогКт = ВыборкаДоговор.Оплата;
					ТабличныйДокумент.Вывести(ОбластьДоговорИтоги);
				КонецЕсли; 
				
				//Выводим сальдо по договору, если оно есть
				Если ВыборкаДоговор.ОстатокНаКонец <> 0 Тогда
					
					ОбластьДоговорИтогиСальдо.Параметры.СальдоДогДт = ?(ВыборкаДоговор.ОстатокНаКонец < 0, -ВыборкаДоговор.ОстатокНаКонец, 0);
					ОбластьДоговорИтогиСальдо.Параметры.СальдоДогКт = ?(ВыборкаДоговор.ОстатокНаКонец > 0, ВыборкаДоговор.ОстатокНаКонец, 0);
					ТабличныйДокумент.Вывести(ОбластьДоговорИтогиСальдо);
					
				КонецЕсли; 
			КонецЦикла;
			
		Иначе
			Выборка = ВыборкаОбщийИтог.Выбрать();
			ДокументовД = 0;
			ДокументовК = 0;
			
			// Документы
			//Пока Выборка.Следующий() Цикл
				// Документы Оплата - Кредит, Возврат и Заактировано - Дебет
				Пока Выборка.Следующий() Цикл
					ОбластьОбороты.Параметры.ДатаДокумента = Выборка.ДатаПроводки;
					НаименованиеДокумента = "Пл. пор. № ";
					
					Если ТипЗнч(Выборка.Документ) = Тип("ДокументСсылка.мВзаимозачет") Тогда
						НаименованиеДокумента = "Письмо № ";	
					КонецЕсли;  
					
					Если Выборка.Оплата > 0 Тогда
						Представление = "" +НаименованиеДокумента+ Выборка.НомерДокумента + " от " + Формат(Выборка.ДатаДокумента, "ДФ=dd.MM.yy");
						
					ИначеЕсли Выборка.Возврат > 0 Тогда
						Представление = "" +НаименованиеДокумента+ Выборка.НомерДокумента + " от " + Формат(Выборка.ДатаДокумента, "ДФ=dd.MM.yy"); 
						
					ИначеЕсли Выборка.Заактировано <> 0 Тогда
						Представление = "Акт № "+ Выборка.НомерДокумента + " от " + Формат(Выборка.ДатаДокумента, "ДФ=dd.MM.yy"); 
					КонецЕсли; 
					ОбластьОбороты.Параметры.РегистраторПредставление = Представление;
					ОбластьОбороты.Параметры.Регистратор = Выборка.Документ;
					Дебет = Выборка.Заактировано + Выборка.Возврат;
					Кредит = Выборка.Оплата;
					ОбластьОбороты.Параметры.СуммаОборотДт = Дебет;
					ОбластьОбороты.Параметры.СуммаОборотКт = Кредит;
					
					Если Дебет <> 0 Или Кредит <> 0 Тогда
						ДокументовД = ?(Дебет <> 0, ДокументовД + 1, ДокументовД);
						ДокументовК = ?(Кредит <> 0, ДокументовК + 1, ДокументовК);
						ТабличныйДокумент.Вывести(ОбластьОбороты);       
					КонецЕсли; 
				КонецЦикла;
			//КонецЦикла;
			
		КонецЕсли;
		
	    ОбластьОборотыИтог.Параметры.СуммаОборотДт      = ВыборкаОбщийИтог.Заактировано + ВыборкаОбщийИтог.Возврат;
	    ОбластьОборотыИтог.Параметры.СуммаОборотКт      = ВыборкаОбщийИтог.Оплата;
		
	КонецЕсли;
		
    ТабличныйДокумент.Вывести(ОбластьОборотыИтог);
    
    ОбластьКонОстатки.Параметры.СуммаКонечныйОстатокДт = ?(ОстатокНаКонец < 0, -ОстатокНаКонец, 0);
    ОбластьКонОстатки.Параметры.СуммаКонечныйОстатокКт = ?(ОстатокНаКонец > 0, ОстатокНаКонец, 0);
	ДатаСальдо = КонецДня(ДатаОкончанияЗапроса)+1;
	ОбластьКонОстатки.Параметры.ТекстСальдоКон = "Сальдо на " + Формат(ДатаСальдо,"ДЛФ=Д");
    
    ТабличныйДокумент.Вывести(ОбластьКонОстатки);

КонецПроцедуры // ВывестиДвижения(Дата1, Дата2, Макет, ТабличныйДокумент)

// Функция формирует табличный документ с печатной формой накладной,
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
&НаСервере
Функция ПечатьАктаСверки(ПараметрыПечати)
    
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб				= Истина;
	ТабличныйДокумент.ТолькоПросмотр			= Истина;
	ТабличныйДокумент.РазмерКолонтитулаСверху	= 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу	= 10;
	ТабличныйДокумент.ОриентацияСтраницы		= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ИмяПараметровПечати		= "ПАРАМЕТРЫ_ПЕЧАТИ_АктСверкиВзаиморасчетов";
	ТабличныйДокумент.ПовторятьПриПечатиСтроки = ТабличныйДокумент.Область(7, , 8);
	
	Макет = УправлениеПечатью.ПолучитьМакет("Отчет.мАктСверки.ПФ_MXL_АктСверки1");
    
    НомерАкта = ПараметрыПечати.НомерАкта;
    ДатаАкта = ПараметрыПечати.ДатаАкта;
    ДатаНачала = ПараметрыПечати.ДатаНачала;
    ДатаОкончания = ПараметрыПечати.ДатаОкончания;
	
	ДваЗапроса = Ложь;
	ДатаДеноминации = Дата("20160701");
	Если ДатаНачала <= ДатаДеноминации  и ДатаДеноминации < ДатаОкончания Тогда
		ДваЗапроса = Истина;
	КонецЕсли; 
	
	ВывестиЗаголовокАкта(Макет, ПараметрыПечати, ТабличныйДокумент);
	
	Если ДваЗапроса Тогда
		Если ДатаНачала < ДатаДеноминации Тогда
			ДатаОкончания = НачалоДня(ДатаДеноминации)-1; 
			
			ВывестиДвижения("ДоДеноминации", Макет, ТабличныйДокумент);
			ВывестиДеноминацию(Макет, ТабличныйДокумент);
			
			ДатаОкончания = КонецДня(ПараметрыПечати.ДатаОкончания);
			ВывестиДвижения("ПослеДеноминации", Макет, ТабличныйДокумент);
		Иначе
			// Дата начала совпала с датой деноминации
			ВывестиДеноминацию(Макет, ТабличныйДокумент);
			ДатаОкончания = КонецДня(ПараметрыПечати.ДатаОкончания);
			ВывестиДвижения("ПослеДеноминации", Макет, ТабличныйДокумент);
		КонецЕсли;
	Иначе
		ВывестиДвижения("", Макет, ТабличныйДокумент);
		// Если акт за 6-й месяц и дата акта позже деноминации - добавить деноминацию
		Если КонецДня(ПараметрыПечати.ДатаОкончания)+1 = НачалоДня(ДатаДеноминации)
			И ДатаАкта >= ДатаДеноминации Тогда
			ВывестиДеноминацию(Макет, ТабличныйДокумент);
		КонецЕсли; 
	КонецЕсли;
	
	ВывестиПодвалАкта(Макет, ТабличныйДокумент);
	
    Возврат ТабличныйДокумент;
    
КонецФункции


&НаКлиенте
Процедура ДоговорНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    СтандартнаяОбработка = Ложь;
    
    СписокВыбранныхКорреспондентов = ПолучитьСписокВыбранныхКорреспондентов(СписокКорреспондентов);
    
    ДанныеВыбора = ПолучитьСписокДоговоровПоСпискуКорреспондентов(СписокВыбранныхКорреспондентов);
    
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокДоговоровПоСпискуКорреспондентов(СписокВыбранныхКорреспондентов)
    Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
        |   ВнутренниеДокументы.Ссылка КАК Договор,
        |   ВнутренниеДокументы.Корреспондент,
        |   ВнутренниеДокументы.ДатаРегистрации КАК ДатаРегистрации,
        |   ВнутренниеДокументы.РегистрационныйНомер
        |ИЗ
        |   Справочник.ВнутренниеДокументы КАК ВнутренниеДокументы
        |ГДЕ
        |   ВнутренниеДокументы.Корреспондент В ИЕРАРХИИ(&СписокВыбранныхКорреспондентов)
        |   И ВнутренниеДокументы.ВидДокумента В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.ВидыВнутреннихДокументов.ДоговораЗемлеустроительныхРабот))
        |   И ВнутренниеДокументы.ВидДокумента.Наименование ПОДОБНО ""Договор%""
        |
        |СГРУППИРОВАТЬ ПО
        |   ВнутренниеДокументы.Ссылка,
        |   ВнутренниеДокументы.Корреспондент,
        |   ВнутренниеДокументы.ДатаРегистрации
        |
        |УПОРЯДОЧИТЬ ПО
        |   ДатаРегистрации УБЫВ";
        
        
	Запрос.УстановитьПараметр("СписокВыбранныхКорреспондентов", СписокВыбранныхКорреспондентов);

	Выборка = Запрос.Выполнить().Выбрать();
	
	СписокДоговоров = Новый СписокЗначений;
    
    Пока Выборка.Следующий() Цикл
		Представление = Выборка.РегистрационныйНомер + " от " + Формат(Выборка.ДатаРегистрации, "ДЛФ=D"); // + " " + Выборка.Корреспондент
		Значение = Выборка.Договор;
		СписокДоговоров.Добавить(Значение, Представление);
    КонецЦикла; 
	
	Возврат СписокДоговоров;
	
КонецФункции

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	ДатаНачала = Период.ДатаНачала;
	ДатаОкончания = Период.ДатаОкончания;
КонецПроцедуры
