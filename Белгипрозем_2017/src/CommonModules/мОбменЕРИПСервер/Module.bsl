Процедура ЗарегистрироватьДоговорДляОбменаЕРИПНаСервере(МассивДоговоров) Экспорт
	
	ТзДог = ПолучитьСуммыДляЕРИП(МассивДоговоров);
	
	НаборЗаписей = РегистрыСведений.мОбменЕРИП.СоздатьНаборЗаписей();
	
	ОплатитьДо = мОбменЕРИПСервер.ОплатитьЕРИПДо(ТекущаяДата());
	
	Для каждого Договор Из МассивДоговоров Цикл
		
		ИскСтрока = ТзДог.Найти(Договор, "Договор");
		
		Если ИскСтрока = Неопределено Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Договор "+Договор+" не зарегистрирован. Проверьте сметную стоимость договора.";
			Сообщение.Сообщить();
			Продолжить;
		КонецЕсли; 
		
		Если ИскСтрока.Сумма > 0 Тогда
			Запись = НаборЗаписей.Добавить();
			Запись.Период = ТекущаяДата();
			Запись.Договор = Договор;
			Запись.Сумма = ИскСтрока.Сумма;
			Запись.Состояние = Перечисления.мСостояниеОбменЕРИП.ДляОтправки;
			Запись.ОплатитьДо = ОплатитьДо;
		КонецЕсли; 
	КонецЦикла; 
	
	Если НаборЗаписей.Количество() > 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Зарегистрировано "+НаборЗаписей.Количество()+" договоров";
		Сообщение.Сообщить(); 
		
		НаборЗаписей.Записать(Ложь);
	КонецЕсли; 
	
КонецПроцедуры

Функция ПолучитьСостоянияДоговоров(МассивДоговоров)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мОбменЕРИПСрезПоследних.Договор,
		|	мОбменЕРИПСрезПоследних.Состояние,
		|	мОбменЕРИПСрезПоследних.Сумма,
		|	мОбменЕРИПСрезПоследних.Период
		|ИЗ
		|	РегистрСведений.мОбменЕРИП.СрезПоследних(, Договор В (&МассивДоговоров)) КАК мОбменЕРИПСрезПоследних";
	
	Запрос.УстановитьПараметр("МассивДоговоров", МассивДоговоров);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции // ПолучитьСостоянияДоговоров()

Функция ПолучитьКаталогОбменаЕРИП() Экспорт
	Если ПолучитьФункциональнуюОпцию("М_ИспользоватьОбменЕРИП") Тогда
		Возврат Константы.М_КаталогОбменЕРИП.Получить();
	Иначе
		Возврат "";
	КонецЕсли; 
КонецФункции // ПолучитьКаталогОбменаЕРИП()

Процедура ЗарегистрироватьСостояниеЕРИП(Договор, Состояние, ИмяФайла="", Сумма=0, ОплатитьДо = "") Экспорт
	НаборЗаписей = РегистрыСведений.мОбменЕРИП.СоздатьНаборЗаписей();
	Запись = НаборЗаписей.Добавить();
	Запись.Период = ТекущаяДата();
	Запись.Договор = Договор;
	Запись.Сумма = Сумма;
	Запись.ИмяФайла = ИмяФайла;
	Запись.Состояние = Состояние;
	Если НЕ ЗначениеЗаполнено(ОплатитьДо) Тогда
		ОплатитьДо = мОбменЕРИПСервер.ОплатитьЕРИПДо(ТекущаяДата());
	КонецЕсли;
	Запись.ОплатитьДо = ОплатитьДо;
	НаборЗаписей.Записать(Ложь);
КонецПроцедуры

Функция ОплатитьЕРИПДо(НачДата = "") Экспорт
	Если Не ЗначениеЗаполнено(НачДата) Тогда
		НачДата = ТекущаяДата();
	КонецЕсли; 
	ПериодОплаты = Константы.мПериодОплатыЕРИП.Получить() + 1;
	ОплатитьДо = НачалоДня(НачДата + ПериодОплаты * 24*3600);
	Возврат ОплатитьДо;
КонецФункции 

Функция ПолучитьСуммыДляЕРИП(МассивДоговоров)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(мСметнаяСтоимостьСрезПоследних.Сумма) КАК Сумма,
		|	мСметнаяСтоимостьСрезПоследних.ЭтапДоговора.Владелец КАК Договор
		|ПОМЕСТИТЬ Стоимости
		|ИЗ
		|	РегистрСведений.мСметнаяСтоимость.СрезПоследних(, ЭтапДоговора.Владелец В (&МассивДоговоров)) КАК мСметнаяСтоимостьСрезПоследних
		|ГДЕ
		|	НЕ мСметнаяСтоимостьСрезПоследних.ЭтапДоговора.ПометкаУдаления
		|	И НЕ мСметнаяСтоимостьСрезПоследних.ЭтапДоговора.ИсключенИзДоговора
		|
		|СГРУППИРОВАТЬ ПО
		|	мСметнаяСтоимостьСрезПоследних.ЭтапДоговора.Владелец
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РасчетыСПокупателямиОбороты.Договор КАК Договор,
		|	ЕСТЬNULL(РасчетыСПокупателямиОбороты.СуммаПриход, 0) КАК Оплата
		|ПОМЕСТИТЬ Оплаты
		|ИЗ
		|	РегистрНакопления.РасчетыСПокупателями.Обороты(, , , Договор В (&МассивДоговоров)) КАК РасчетыСПокупателямиОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Стоимости.Договор КАК Договор,
		|	Стоимости.Сумма - ЕСТЬNULL(Оплаты.Оплата, 0) КАК Сумма
		|ИЗ
		|	Стоимости КАК Стоимости
		|		ЛЕВОЕ СОЕДИНЕНИЕ Оплаты КАК Оплаты
		|		ПО Стоимости.Договор = Оплаты.Договор";
	
	Запрос.УстановитьПараметр("МассивДоговоров", МассивДоговоров);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса;
КонецФункции 
 
 
