
// УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Организация";
	
КонецФункции
	
// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.Организация = ОбъектДоступа.Организация;
	
КонецПроцедуры

// Конец УправлениеДоступом

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
    // Устанавливаем признак достпности печати по-комплектно
    ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
    Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Опись") Тогда

        // Формируем табличный документ и добавляем его в коллекцию печатных форм
        УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
            "Опись", "Опись", ПечатьОписи(МассивОбъектов, ОбъектыПечати), , "ПередачаДелВАрхив.Макет.Опись");

	КонецЕсли;
		
КонецПроцедуры

Функция ПечатьОписи(МассивОбъектов, ОбъектыПечати) Экспорт
	
	// Создаем табличный документ и устанавливаем имя параметров печати
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_ОписьПередачиДелВАрхив";
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	// Получаем запросом необходимые данные
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПередачаДелВАрхив.Ссылка КАК Ссылка,
	|	ПередачаДелВАрхив.Организация КАК Организация,
	|	ПередачаДелВАрхив.Дата КАК Дата,
	|	ПередачаДелВАрхив.Номер КАК Номер,
	|	ПередачаДелВАрхив.Ответственный КАК Ответственный,
	//МиСофт+
	|	ПередачаДелВАрхив.УтвердилРБ,
	|	ПередачаДелВАрхив.ПередалРБ,
	|	ПередачаДелВАрхив.ПодразделениеРБ
	//МиСофт-
	|ИЗ
	|	Документ.ПередачаДелВАрхив КАК ПередачаДелВАрхив
	|ГДЕ
	|	ПередачаДелВАрхив.Ссылка В(&МассивОбъектов)";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаСсылка = Запрос.Выполнить().Выбрать();
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.Индекс КАК Индекс,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.ПолноеНаименование КАК Наименование,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.Раздел КАК Раздел,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.СрокХранения КАК СрокХранения,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.ОтметкаЭПК КАК ОтметкаЭПК,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.Комментарий КАК Примечание,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.ДатаНачала КАК ДатаНачала,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.ДатаОкончания КАК ДатаОкончания,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.КоличествоЛистов КАК КоличествоЛистов,
	//МиСофт+
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.НомераСтатей КАК НомераСтатей,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.Представление КАК Представление,
	//МиСофт-
	|	ДелаХраненияДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ПередачаДелВАрхив.ДелаХраненияДокументов КАК ДелаХраненияДокументов
	|ГДЕ
	|	ДелаХраненияДокументов.Ссылка В(&МассивОбъектов)
	|	И ДелаХраненияДокументов.ДелоХраненияДокументов <> ЗНАЧЕНИЕ(Справочник.ДелаХраненияДокументов.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Индекс
	|ИТОГИ ПО
	|	Ссылка,
	|	Раздел ИЕРАРХИЯ";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаДетали = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	//МиСофт+
	Макет = Документы.ПередачаДелВАрхив.ПолучитьМакет("ОписьРБ");
	//МиСофт-
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка 	 = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока 	 = Макет.ПолучитьОбласть("Строка");
	ОбластьРаздел 	 = Макет.ПолучитьОбласть("Раздел");
	ОбластьПодвал 	 = Макет.ПолучитьОбласть("Подвал");
	
	ПервыйДокумент = Истина;
	Пока ВыборкаСсылка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки с которой начали выводить текущий документ
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		
		// заголовок
		ОбластьЗаголовок.Параметры.НаименованиеПредприятия = РаботаСОрганизациями.ПолучитьНаименованиеОрганизации(ВыборкаСсылка.Организация);
		ОбластьЗаголовок.Параметры.ДатаДок = Формат(ВыборкаСсылка.Дата, "ДФ=dd.MM.yyyy");
		ОбластьЗаголовок.Параметры.НомерДок = ВыборкаСсылка.Номер;
		
		//МиСофт+
		ОбластьЗаголовок.Параметры.УтвердилДолжность = РаботаСПользователями.ПолучитьДолжность(ВыборкаСсылка.Утвердил);
		ОбластьЗаголовок.Параметры.УтвердилФИО = ВыборкаСсылка.Утвердил.ПредставлениеВДокументах;
		ОбластьЗаголовок.Параметры.Подразделение = ВыборкаСсылка.Подразделение;
		//МиСофт-
		
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		// шапка
		ТабличныйДокумент.Вывести(ОбластьШапка);
		Номер = 0;
		
		// разделы
		Если ВыборкаДетали.НайтиСледующий(ВыборкаСсылка.Ссылка, "Ссылка") Тогда
			
			ВыборкаРазделы = ВыборкаДетали.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаРазделы.Следующий() Цикл
				
				ОбластьРаздел.Параметры.Индекс = ВыборкаРазделы.Раздел.Индекс;
				ОбластьРаздел.Параметры.Наименование = ВыборкаРазделы.Раздел.Наименование;
				ТабличныйДокумент.Вывести(ОбластьРаздел);
				
				// строки
				ВыборкаСтроки = ВыборкаРазделы.Выбрать();
				Пока ВыборкаСтроки.Следующий() Цикл
					Номер = Номер + 1;
					
					ОбластьСтрока.Параметры.Заполнить(ВыборкаСтроки);
					ОбластьСтрока.Параметры.Номер = Номер;
					ОбластьСтрока.Параметры.КрайниеДаты = Формат(ВыборкаСтроки.ДатаНачала, "ДФ=dd.MM.yyyy") + " - " + Формат(ВыборкаСтроки.ДатаОкончания, "ДФ=dd.MM.yyyy");
					//МиСофт+
					ОбластьСтрока.Параметры.Наименование = ВыборкаСтроки.Представление;
					//МиСофт-
					
					СрокХранения = ВыборкаСтроки.СрокХранения;
					ОтметкаЭПК = ВыборкаСтроки.ОтметкаЭПК;
					Если ТипЗнч(СрокХранения) = Тип("Число") Тогда 
						//МиСофт+
						ОбластьСтрока.Параметры.СрокХранения = Строка(СрокХранения) + " " + ДелопроизводствоКлиентСервер.ПодписьЛет(СрокХранения) + ?(СокрЛП(ВыборкаСтроки.НомераСтатей)="", "", " ст."+СокрЛП(ВыборкаСтроки.НомераСтатей)) + ?(ОтметкаЭПК, " ЭПК", "");
						//МиСофт-
					Иначе
						ОбластьСтрока.Параметры.СрокХранения = СрокХранения + ?(ОтметкаЭПК, " ЭПК", "");
					КонецЕсли;	
					ТабличныйДокумент.Вывести(ОбластьСтрока);
				КонецЦикла;	
			КонецЦикла;
			
		КонецЕсли;
		
		// подвал
		
		//МиСофт+
		ОбластьПодвал.Параметры.КоличествоДел = Формат(Номер, "ЧГ=") + " (" + СокрЛП(НРЕГ(ЧислоПрописью(Номер, , ",,,с,,,,,0"))) + ")";
		//МиСофт-
		
		ОбластьПодвал.Параметры.НачальныйНомер = 1;
		ОбластьПодвал.Параметры.Конечныйномер = Номер;
		ОбластьПодвал.Параметры.ДатаДок = Формат(ВыборкаСсылка.Дата, "ДФ=dd.MM.yyyy");
		
		//МиСофт+
		ОбластьПодвал.Параметры.ДолжностьРуководителяДОУ = "Протокол ЭПК";
		
		ОбластьПодвал.Параметры.Составитель = ВыборкаСсылка.Ответственный.ПредставлениеВДокументах;
		ОбластьПодвал.Параметры.ДолжностьСоставителя = РаботаСПользователями.ПолучитьДолжность(ВыборкаСсылка.Ответственный);
		
		ОбластьПодвал.Параметры.ДолжностьПередал = РаботаСПользователями.ПолучитьДолжность(ВыборкаСсылка.Передал);
		ОбластьПодвал.Параметры.Передал = ВыборкаСсылка.Передал.ПредставлениеВДокументах;
		//МиСофт-
		
		РуководительАрхива = РаботаСОрганизациями.ПолучитьОтветственноеЛицо("РуководительАрхива", ВыборкаСсылка.Организация, ВыборкаСсылка.Дата);
		ОбластьПодвал.Параметры.РуководительАрхива = РуководительАрхива.ПредставлениеВДокументах;
		ОбластьПодвал.Параметры.ДолжностьРуководителяАрхива = РаботаСПользователями.ПолучитьДолжность(РуководительАрхива);
		
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		
		// В табличном документе зададим имя области в которую был 
		// выведен объект. Нужно для возможности печати по-комплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаСсылка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции
