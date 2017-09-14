
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ПараметрыВыполненияКоманды", ПараметрыВыполненияКоманды);
	ПараметрыОповещения.Вставить("ПараметрКоманды", ПараметрКоманды);
	РежимОткрытияФормы = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СозданиеДокументаНаОсновании", ЭтотОбъект, ПараметрыОповещения);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипШаблонаДокумента", "ШаблоныИсходящихДокументов");
	ПараметрыФормы.Вставить("ВозможностьСозданияПустогоДокумента", Истина);
	ПараметрыФормы.Вставить("НаименованиеКнопкиВыбора", НСтр("ru = 'Создать по шаблону'"));
	
	Попытка
		ОткрытьФорму(
			"ОбщаяФорма.СозданиеДокументаПоШаблону",
			ПараметрыФормы,,,,,
			ОписаниеОповещения,
			РежимОткрытияФормы);
		Возврат;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Если Инфо.Описание = "СоздатьПустойДокумент" Тогда
			ВыполнитьОбработкуОповещения(ОписаниеОповещения,
				"СоздатьПустойДокумент");
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура СозданиеДокументаНаОсновании(Результат, Параметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Результат) ИЛИ Результат = "ПрерватьОперацию" Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	Если (ТипЗнч(Результат) <> Тип("Строка")) Тогда 
		ПараметрыФормы.Вставить("ШаблонДокумента", Результат.ШаблонДокумента);
		Результат.Вставить("Основание", Параметры.ПараметрКоманды);
		ПараметрыФормы.Вставить("Основание", Результат);
		ПараметрыФормы.Вставить("ЗаполнятьРеквизитыДоСоздания", Истина);
	Иначе
		ПараметрыФормы.Вставить("ШаблонДокумента", Результат);
		ПараметрыФормы.Вставить("Основание", Параметры.ПараметрКоманды);
	КонецЕсли;
	
	Открытьформу("Справочник.ИсходящиеДокументы.ФормаОбъекта", ПараметрыФормы, Параметры.ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры
