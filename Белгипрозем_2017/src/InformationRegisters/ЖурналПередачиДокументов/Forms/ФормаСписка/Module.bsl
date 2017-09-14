
&НаСервере
Процедура УстановитьОтбор()
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоПользователю", 	ПоПользователю);
	ПараметрыОтбора.Вставить("ПоДокументу",  	ПоДокументу);
	ПараметрыОтбора.Вставить("Показывать", 		Показывать);
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)

	Если ЗначениеЗаполнено(ПараметрыОтбора["ПоПользователю"]) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Пользователь", ПараметрыОтбора["ПоПользователю"]);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Пользователь");
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ПараметрыОтбора["ПоДокументу"]) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Документ", ПараметрыОтбора["ПоДокументу"]);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Документ");
	КонецЕсли;	
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Возвращен"); 
	Если ПараметрыОтбора["Показывать"] = "Возвращенные" Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Возвращен", Истина);
			
	ИначеЕсли ПараметрыОтбора["Показывать"] = "Невозвращенные" Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Возвращен", Ложь);
			
	КонецЕсли;		
		
КонецПроцедуры	


&НаКлиенте
Процедура ПоПользователюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("ОбщаяФорма.ВыборПользователяКонтактноеЛицо", Новый Структура("ТекущаяСтрока", ПоПользователю), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПользователюПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоДокументуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СписокТипов = Новый СписокЗначений;
	СписокТипов.Добавить("ВнутренниеДокументы", НСтр("ru = 'Внутренний документ'"));
	СписокТипов.Добавить("ВходящиеДокументы",   НСтр("ru = 'Входящий документ'"));
	СписокТипов.Добавить("ИсходящиеДокументы",  НСтр("ru = 'Исходящий документ'"));	
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоДокументуНачалоВыбораПродолжение",
		ЭтотОбъект,
		Новый Структура("Элемент", Элемент));

	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокТипов, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ПоДокументуНачалоВыбораПродолжение(ВыбранныйТип, Параметры) Экспорт 

	Если ВыбранныйТип <> Неопределено Тогда 
		ОткрытьФорму("Справочник." + ВыбранныйТип.Значение + ".ФормаВыбора", , Параметры.Элемент);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоДокументуПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьВозвращен(КлючЗаписи)
	
	МенеджерЗаписи = РегистрыСведений.ЖурналПередачиДокументов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = КлючЗаписи.Период;
	МенеджерЗаписи.Документ = КлючЗаписи.Документ;
	МенеджерЗаписи.ТипЭкземпляра = КлючЗаписи.ТипЭкземпляра;
	МенеджерЗаписи.НомерЭкземпляра = КлючЗаписи.НомерЭкземпляра;
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Возвращен Тогда 
		Возврат;
	КонецЕсли;	
	
	МенеджерЗаписи.Возвращен = Истина;
	МенеджерЗаписи.ДатаВозврата = ТекущаяДата();
	МенеджерЗаписи.Записать();
	
КонецПроцедуры	

&НаКлиенте
Процедура ОтметитьВозврат(Команда)
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ВыделенныеСтроки.Количество() = 1 Тогда 
		Если ТипЗнч(ВыделенныеСтроки[0]) <> Тип("РегистрСведенийКлючЗаписи.ЖурналПередачиДокументов") Тогда 
			ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
			Возврат;
		КонецЕсли;
		Если Элементы.Список.ТекущиеДанные.Возвращен Тогда 
			ПоказатьПредупреждение(, НСтр("ru = 'Документ уже возвращен!'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;	
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) <> Тип("РегистрСведенийКлючЗаписи.ЖурналПередачиДокументов") Тогда 
			Продолжить;
		КонецЕсли;
		
		УстановитьВозвращен(ВыделеннаяСтрока);
	КонецЦикла;	
	
	Если ВыделенныеСтроки.Количество() = 1 Тогда 
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда 
			Оповестить("ИзмененЖурналПередачи", ТекущиеДанные.Документ);
		КонецЕсли;	
	КонецЕсли;	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Показывать = "Невозвращенные";
	УстановитьОтбор();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтборСписка(Список, Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры
