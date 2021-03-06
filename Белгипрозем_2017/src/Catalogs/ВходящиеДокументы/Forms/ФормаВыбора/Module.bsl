&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Комплекты документов
	Если Параметры.Свойство("ЯвляетсяКомплектомДокументов") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ЯвляетсяКомплектомДокументов", Параметры.ЯвляетсяКомплектомДокументов);
	КонецЕсли;
		
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	// Виды документов
	Если Параметры.Свойство("ВидДокумента") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ВидДокумента", Параметры.ВидДокумента);
	КонецЕсли;
	
	ВыбранныеДокументыНадпись = НСтр("ru = 'Выбранные документы:'");
	
	Если ЗакрыватьПриВыборе Тогда
		Элементы.ВыбранныеДокументыНадпись.Видимость = Ложь;
		Элементы.ВыбранныеЗначения.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ЗакрыватьПриВыборе Тогда
		Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ОповеститьОВыборе(Элементы.Список.ТекущаяСтрока);
	Иначе
		Если ВыбранныеЗначения.Количество() = 0 Тогда
			ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
			Если ВыделенныеСтроки.Количество() = 0 Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'Не выбран ни один документ.'"));
				Возврат;
			КонецЕсли;
			ОповеститьОВыборе(ВыделенныеСтроки);
		ИначеЕсли ВыбранныеЗначения.Количество() = 1 Тогда
			ОповеститьОВыборе(ВыбранныеЗначения[0].Значение);
		ИначеЕсли ВыбранныеЗначения.Количество() > 1 Тогда
			ОповеститьОВыборе(ВыбранныеЗначения.ВыгрузитьЗначения());
		КонецЕсли;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("СправочникСсылка.ВходящиеДокументы") 
	 Или ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		ВыборЗначенияСервер(ПараметрыПеретаскивания.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗакрыватьПриВыборе Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ВыборЗначенияСервер(ВыбраннаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ВыборЗначенияСервер(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда 
		ЗначениеМассив = ВыбранноеЗначение;
	Иначе	
		ЗначениеМассив = Новый Массив;
		ЗначениеМассив.Добавить(ВыбранноеЗначение);
	КонецЕсли;
	
	Для Каждого Значение Из ЗначениеМассив Цикл
		Элемент = ВыбранныеЗначения.НайтиПоЗначению(Значение);
		Если Элемент = Неопределено Тогда
			ВыбранныеЗначения.Добавить(Значение);
			ВыбранныеЗначения.СортироватьПоПредставлению();
		Иначе
			ВыбранныеЗначения.Удалить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтображение()
	ВыбранныеДокументыНадпись = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выбранные документы (%1):'"),
			ВыбранныеЗначения.Количество());
	УсловноеОформление.Элементы[0].Отбор.Элементы[0].ПравоеЗначение = ВыбранныеЗначения;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеЗначенияПослеУдаления(Элемент)
	ОбновитьОтображение();
КонецПроцедуры
