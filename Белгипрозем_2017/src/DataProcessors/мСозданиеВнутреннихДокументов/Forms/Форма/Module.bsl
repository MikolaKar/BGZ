#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьСписокЗакладок();
КонецПроцедуры




#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы



#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Сотрудники
&НаКлиенте
Процедура СотрудникиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Если Новаястрока и НЕ ОтменаРедактирования Тогда
		ОбновитьЗаголовокЗакладки("Сотрудники");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПослеУдаления(Элемент)
	ОбновитьЗаголовокЗакладки("Сотрудники");
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПометкаПриИзменении(Элемент)
	ОбновитьЗаголовокЗакладки("Сотрудники");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ВнутрДоки
&НаКлиенте
Процедура ВнутрДокиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Если Новаястрока и НЕ ОтменаРедактирования Тогда
		ОбновитьЗаголовокЗакладки("ВнутрДоки");
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВнутрДокиПослеУдаления(Элемент)
	ОбновитьЗаголовокЗакладки("ВнутрДоки");
КонецПроцедуры

&НаКлиенте
Процедура ВнутрДокиПометкаПриИзменении(Элемент)
	ОбновитьЗаголовокЗакладки("ВнутрДоки");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ПометитьВсе(Команда)
	УстановкаФлажков(Сотрудники, 1);
	ОбновитьЗаголовокЗакладки("Сотрудники");
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	УстановкаФлажков(Сотрудники, 0);
	ОбновитьЗаголовокЗакладки("Сотрудники");
КонецПроцедуры

&НаКлиенте
Процедура УстановкаФлажков(ЭлементКоллекции, ЗначениеПометки)
    Для Каждого ТекЭлемент Из ЭлементКоллекции Цикл
        ТекЭлемент.Пометка = ЗначениеПометки;
    КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СоздатьНаСервере()
	
	СтруктураШаблона = ПодготовитьДанныеДляЗаполнения(ШаблонВнутреннегоДокумента);
	
	
	Для каждого Стр Из Сотрудники Цикл
		Если Не Стр.Пометка Тогда
			Продолжить;
		КонецЕсли; 
		
		Если Не ЗначениеЗаполнено(Стр.Сотрудник) Тогда
			Продолжить;
		КонецЕсли; 
		
		НовДок = Справочники.ВнутренниеДокументы.СоздатьЭлемент();
		СтруктураШаблона.Вставить("Основание", ШаблонВнутреннегоДокумента);
		НовДок.Заполнить(СтруктураШаблона);
		НовДок.Утвердил = Подписал;
		НовДок.Подготовил = Стр.Сотрудник;
		НовДок.ДатаРегистрации = ДатаРегистрации;
		НовДок.Комментарий = СтрокаПоиска;
		// сформируем текущий номер
		СформироватьЧисловойНомерДокумента(НовДок);
		СформироватьСтроковыйНомерДокумента(НовДок);
		НовДок.Наименование = "Доп. соглашение " + Стр.Сотрудник;
		НовДок.Заголовок = "Доп. соглашение " + Стр.Сотрудник;
		НовДок.Записать();
		
		Стр.ВнДок = НовДок.Ссылка;
		
	КонецЦикла; 
КонецПроцедуры

&НаСервере
Процедура СформироватьЧисловойНомерДокумента(ТекущийОбъект)
	
	СтруктураПараметров = НумерацияКлиентСервер.ПолучитьПараметрыНумерации(ТекущийОбъект);
	//СтруктураПараметров.Вставить("ПерепискаПоПредмету",	ПерепискаПоПредмету);
	//СтруктураПараметров.Вставить("НеДействуетВСоответствии", НеДействуетВСоответствии);
	//СтруктураПараметров.Вставить("СвязанныйДокумент", СвязанныйДокументДляНумерации);
	
	Нумерация.СформироватьЧисловойНомерДокумента(СтруктураПараметров, ТекущийОбъект.ЧисловойНомер);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСтроковыйНомерДокумента(ТекущийОбъект)
	
	СтруктураПараметров = НумерацияКлиентСервер.ПолучитьПараметрыНумерации(ТекущийОбъект);
	//СтруктураПараметров.Вставить("ПерепискаПоПредмету",	ПерепискаПоПредмету);
	//СтруктураПараметров.Вставить("НеДействуетВСоответствии", НеДействуетВСоответствии);
	//СтруктураПараметров.Вставить("СвязанныйДокумент", СвязанныйДокументДляНумерации);
	
	ОписанияОшибок = Новый СписокЗначений;
	Нумерация.СформироватьСтроковыйНомерДокумента(СтруктураПараметров, ТекущийОбъект.РегистрационныйНомер, ОписанияОшибок);
	
	Для Каждого ОписаниеОшибки Из ОписанияОшибок Цикл
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ОписаниеОшибки.Представление,,
			ОписаниеОшибки.Значение,
			"Объект");
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура Создать(Команда)
	СоздатьНаСервере();
	ОбновитьЗаголовокЗакладки("ВнутрДоки");
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПечФормы(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры




#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ОбновитьЗаголовокЗакладки(ИмяЗакладки)
    Закладка = СписокЗакладок.НайтиПоЗначению(ИмяЗакладки);
    Если Закладка = Неопределено Тогда
        Сообщить("Не найдена закладка "+ИмяЗакладки);
        Возврат;
    КонецЕсли; 
    
    ТекЗаголовок = Закладка.Представление;
	Количество = ЭтаФорма[Закладка.Значение].Количество();
	
	Если Количество > 0 Тогда
		//Если ИмяЗакладки = "Сотрудники" Тогда
			Помеченных = 0;
			Для й=0 По Количество-1 Цикл
				Если ЭтаФорма[Закладка.Значение][й].Пометка Тогда
					Помеченных = Помеченных + 1;
				КонецЕсли; 
			КонецЦикла; 
			
			ТекЗаголовок = ТекЗаголовок + " (" + Помеченных + " из " + Количество + ")";
			
		//Иначе	
		//	ТекЗаголовок = ТекЗаголовок + " (" + Количество + ")";
		//КонецЕсли; 
	КонецЕсли; 
	
	Элементы["Группа"+Закладка.Значение].Заголовок = ТекЗаголовок;	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокЗакладок()

	СписокЗакладок.Очистить();
    СписокЗакладок.Добавить("Сотрудники", "Исходные данные");
    СписокЗакладок.Добавить("ВнутрДоки", "Документы");

КонецПроцедуры

&НаСервере
Функция ПодготовитьДанныеДляЗаполнения(Шаблон)

	ДанныеДляЗаполненияДокумента = Новый Структура();
	
	Для Каждого Справочник из Метаданные.Справочники Цикл
		Если Справочник.ПредставлениеОбъекта = Строка(ТипЗнч(Шаблон)) Тогда
			Для Каждого Реквизит из Справочник.Реквизиты Цикл
				Если Реквизит.Имя = "КомментарийКДокументу" И
					 НЕ ПустаяСтрока(Шаблон.КомментарийКДокументу) Тогда
					ДанныеДляЗаполненияДокумента.Вставить("Комментарий",Шаблон.КомментарийКДокументу);
					
				ИначеЕсли Реквизит.Имя = "ДлительностьИсполнения" И
					НЕ Шаблон.ДлительностьИсполнения = 0 Тогда
					
					ДанныеДляЗаполненияДокумента.Вставить("СрокИсполнения",ТекущаяДата() + Шаблон.ДлительностьИсполнения*60*60*24); 
					
				ИначеЕсли Реквизит.Имя <> "КомментарийКШаблону" И 
					Реквизит.Имя <> "ВладелецШаблона" И 
					Реквизит.Имя <> "КомментарийКДокументу" И 
					Реквизит.Имя <> "ДлительностьИсполнения" Тогда
					
					СтрКоманда = "ДанныеДляЗаполненияДокумента.Вставить(""" + Реквизит.Имя + """,Шаблон." + Реквизит.Имя + ");";
					Выполнить(СтрКоманда);
					
				КонецЕсли;
			КонецЦикла;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДанныеДляЗаполненияДокумента;
	
КонецФункции





#КонецОбласти
