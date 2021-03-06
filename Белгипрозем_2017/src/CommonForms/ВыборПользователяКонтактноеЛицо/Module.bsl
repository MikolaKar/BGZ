
&НаСервере
Процедура УстановитьИерархию(Отметка)
	
	Если Отметка = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Элементы.ИспользоватьИерархию.Пометка = Отметка;
	Если Отметка = Истина Тогда 
		Элементы.СтруктураПредприятия.Видимость = Истина;
	Иначе
		Элементы.СтруктураПредприятия.Видимость = Ложь;
	КонецЕсли;
	СписокПользователи.Параметры.УстановитьЗначениеПараметра("ИспользоватьИерархию", Отметка);
	
КонецПроцедуры	

&НаКлиенте
Процедура ОбработкаОжиданияПользователи()
	
	Если Элементы.СтруктураПредприятия.ТекущаяСтрока <> Неопределено Тогда 
		СписокПользователи.Параметры.УстановитьЗначениеПараметра("Подразделение", Элементы.СтруктураПредприятия.ТекущаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжиданияКонтактныеЛица()
	
	Если Элементы.Корреспонденты.ТекущаяСтрока <> Неопределено Тогда 
		СписокКонтактныеЛица.Параметры.УстановитьЗначениеПараметра("Корреспондент", Элементы.Корреспонденты.ТекущаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Режим) И Параметры.Режим = "ТолькоКонтактныеЛица" Тогда 
		Элементы.Пользователи.Видимость = Ложь;
		ЭтаФорма.Заголовок = НСтр("ru = 'Контактные лица'");
	КонецЕсли;	
	
	ТекущаяСтрока = Параметры.ТекущаяСтрока;
	Если ЗначениеЗаполнено(ТекущаяСтрока) Тогда
		
		Если ТипЗнч(ТекущаяСтрока) = Тип("СправочникСсылка.Пользователи") Тогда 
		
			Подразделение = РаботаСПользователями.ПолучитьПодразделение(ТекущаяСтрока);
			Если Не Подразделение.Пустая() Тогда
				Элементы.СтруктураПредприятия.ТекущаяСтрока = Подразделение;
				Элементы.СписокПользователи.ТекущаяСтрока = ТекущаяСтрока;
			КонецЕсли;
			Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаПользователи;
			
		ИначеЕсли ТипЗнч(ТекущаяСтрока) = Тип("СправочникСсылка.КонтактныеЛица") Тогда 
			Элементы.Корреспонденты.ТекущаяСтрока = ТекущаяСтрока.Владелец;
			Элементы.СписокКонтактныеЛица.ТекущаяСтрока = ТекущаяСтрока;
			Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаКорреспонденты;
			
		КонецЕсли;	
		
	КонецЕсли;	
	
	СписокПользователи.Параметры.УстановитьЗначениеПараметра("Подразделение", Элементы.СтруктураПредприятия.ТекущаяСтрока);
	СписокКонтактныеЛица.Параметры.УстановитьЗначениеПараметра("Корреспондент", Элементы.Корреспонденты.ТекущаяСтрока);
	
	ИспользоватьИерархию = Истина;
	УстановитьИерархию(ИспользоватьИерархию);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьИерархию(Настройки["ИспользоватьИерархию"]);
	
КонецПроцедуры


&НаКлиенте
Процедура СтруктураПредприятияПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжиданияПользователи", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура КорреспондентыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжиданияКонтактныеЛица", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКонтактныеЛицаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИерархию(Команда)
	
	ИспользоватьИерархию = Не ИспользоватьИерархию;
	Если ИспользоватьИерархию И (Элементы.СписокПользователи.ТекущиеДанные <> Неопределено) Тогда 
		Элементы.СтруктураПредприятия.ТекущаяСтрока = Элементы.СписокПользователи.ТекущиеДанные.Подразделение;
		СписокПользователи.Параметры.УстановитьЗначениеПараметра("Подразделение", Элементы.СтруктураПредприятия.ТекущаяСтрока);
	КонецЕсли;	
	УстановитьИерархию(ИспользоватьИерархию);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаПользователи Тогда 
		Если Элементы.СписокПользователи.ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли;	
			
		ОповеститьОВыборе(Элементы.СписокПользователи.ТекущаяСтрока);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаКорреспонденты Тогда 
		Если Элементы.СписокКонтактныеЛица.ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли;	
		
		ОповеститьОВыборе(Элементы.СписокКонтактныеЛица.ТекущаяСтрока);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКонтактныеЛицаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда 
		Возврат;
	КонецЕсли;	
	
	ТекущиеДанные = Элементы.Корреспонденты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;	
	
	Отказ = Истина;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Владелец", ТекущиеДанные.Ссылка);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
	ОткрытьФорму("Справочник.КонтактныеЛица.ФормаОбъекта", ПараметрыФормы, Элемент);	
	
КонецПроцедуры
