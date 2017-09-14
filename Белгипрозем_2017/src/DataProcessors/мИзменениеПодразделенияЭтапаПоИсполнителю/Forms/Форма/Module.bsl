
&НаСервере
Процедура ИзменитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мЭтапыДоговоров.Ссылка КАК ЭтапДоговора,
		|	мЭтапыДоговоров.Владелец КАК Владелец,
		|	мЭтапыДоговоров.Подразделение КАК Подразделение
		|ПОМЕСТИТЬ Этапы
		|ИЗ
		|	Документ.мАктирование.Акты КАК мАктированиеАкты
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.мЭтапыДоговоров КАК мЭтапыДоговоров
		|		ПО мАктированиеАкты.ЭтапДоговора = мЭтапыДоговоров.Ссылка
		|ГДЕ
		|	мАктированиеАкты.Ссылка.Дата >= &ДатаРегистрации
		|	И мЭтапыДоговоров.Подразделение.Родитель = &Родитель
		|	И мЭтапыДоговоров.Подразделение = &Подразделение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	мЭтапыДоговоровИсполнители.Исполнитель КАК Исполнитель,
		|	мЭтапыДоговоровИсполнители.Ссылка КАК ЭтапДоговора
		|ПОМЕСТИТЬ Исполнители
		|ИЗ
		|	Справочник.мЭтапыДоговоров.Исполнители КАК мЭтапыДоговоровИсполнители
		|ГДЕ
		|	мЭтапыДоговоровИсполнители.Ссылка В
		|			(ВЫБРАТЬ
		|				Этапы.ЭтапДоговора
		|			ИЗ
		|				Этапы КАК Этапы)
		|	И мЭтапыДоговоровИсполнители.НомерСтроки = 1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СведенияОПользователях.Подразделение КАК Подразделение,
		|	Этапы.ЭтапДоговора,
		|	Этапы.Подразделение КАК Подразделение1,
		|	Исполнители.Исполнитель,
		|	Этапы.Владелец.Представление КАК Договор
		|ИЗ
		|	Этапы КАК Этапы
		|		ЛЕВОЕ СОЕДИНЕНИЕ Исполнители КАК Исполнители
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
		|			ПО Исполнители.Исполнитель = СведенияОПользователях.Пользователь
		|		ПО (Исполнители.ЭтапДоговора = Этапы.ЭтапДоговора)";
	
	Запрос.УстановитьПараметр("ДатаРегистрации", ДатаРегистрации);
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И мЭтапыДоговоров.Подразделение.Родитель = &Родитель", "");
	Иначе
		Запрос.УстановитьПараметр("Родитель", Справочники.СтруктураПредприятия.ПустаяСсылка());
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И мЭтапыДоговоров.Подразделение = &Подразделение", "");
	КонецЕсли; 
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Не ЗначениеЗаполнено(Выборка.Подразделение) Тогда
			Продолжить;
		КонецЕсли; 
		Этап = Выборка.ЭтапДоговора.ПолучитьОбъект();
		Этап.Подразделение = Выборка.Подразделение;
		Этап.Записать();
		Сообщить("Изменен "+Выборка.Договор + " " + Выборка.ЭтапДоговора);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	ИзменитьНаСервере();
КонецПроцедуры
