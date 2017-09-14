&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("РазделыПоиска", Объект.РазделыПоиска);
	
	СписокСтандартныхРазделов = Новый СписокЗначений;
	Для каждого Элемент Из ПолнотекстовыйПоискСерверДокументооборот.ПолучитьНаименованияСтандартныхРазделовПоиска() Цикл
		СписокСтандартныхРазделов.Добавить(Элемент);
	КонецЦикла;
	УсловноеОформление.Элементы[0].Отбор.Элементы[0].ПравоеЗначение = СписокСтандартныхРазделов;
	
КонецПроцедуры

&НаКлиенте
Процедура РазделыПоискаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекСтрока = Элемент.ТекущаяСтрока;
	
	Данные = Объект.РазделыПоиска.НайтиПоИдентификатору(ТекСтрока);
	Если ПолнотекстовыйПоискСерверДокументооборот.ЭтоСтандартныйРазделПоиска(Данные.Представление) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя редактировать стандартный раздел поиска'"));
		Возврат;
	КонецЕсли;
	
	ПараметрРаздел = Данные.Значение;
	ПараметрНаименование = Данные.Представление;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Раздел", ПараметрРаздел);
	ПараметрыОткрытия.Вставить("Наименование", ПараметрНаименование);
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("РазделыПоискаВыборПродолжение", ЭтотОбъект, ТекСтрока);
	
	ОткрытьФорму("Обработка.ПолнотекстовыйПоискВДанных.Форма.ФормаРазделаПоиска",
		ПараметрыОткрытия,,,,,ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура РазделыПоискаВыборПродолжение(Результат, ТекСтрока) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.РазделыПоиска.НайтиПоИдентификатору(ТекСтрока).Значение = Результат.Раздел;
	Объект.РазделыПоиска.НайтиПоИдентификатору(ТекСтрока).Представление = Результат.Наименование;
	
КонецПроцедуры

&НаКлиенте
Процедура РазделыПоискаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ПараметрОткрытия = Новый Структура;
	Если Копирование Тогда
		ПараметрОткрытия.Вставить("Наименование", Элемент.ТекущиеДанные.Представление);
		ПараметрОткрытия.Вставить("Раздел", Элемент.ТекущиеДанные.Значение);
	Иначе
		ПараметрОткрытия.Вставить("Наименование", НСтр("ru = 'Новый раздел'") + " " + ТекущаяДата());
		ПараметрОткрытия.Вставить("Раздел", Новый Массив);
	КонецЕсли;
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("РазделыПоискаПередНачаломДобавленияПродолжение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ПолнотекстовыйПоискВДанных.Форма.ФормаРазделаПоиска",
		ПараметрОткрытия,,,,,ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура РазделыПоискаПередНачаломДобавленияПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.РазделыПоиска.Добавить(Результат.Раздел, Результат.Наименование);
	
КонецПроцедуры

&НаКлиенте
Процедура РазделыПоискаПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.Имя = "РазделыПоискаЗначение" Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	Закрыть(Объект.РазделыПоиска);
КонецПроцедуры

&НаКлиенте
Процедура РазделыПоискаПередУдалением(Элемент, Отказ)
	
	ТекСтрока = Элемент.ТекущаяСтрока;
	Данные = Объект.РазделыПоиска.НайтиПоИдентификатору(ТекСтрока);
	Если ПолнотекстовыйПоискСерверДокументооборот.ЭтоСтандартныйРазделПоиска(Данные.Представление) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя удалять стандартные разделы поиска'"));
		Возврат;
	КонецЕсли;
	
КонецПроцедуры
