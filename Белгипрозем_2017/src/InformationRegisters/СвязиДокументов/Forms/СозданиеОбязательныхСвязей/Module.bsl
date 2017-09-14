
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Документ = Параметры.Документ;
	Корреспондент = Параметры.Корреспондент;
	Организация = Параметры.Организация;
	Проект = Параметры.Проект;
	
	Для Каждого Строка Из Параметры.ОбязательныеСвязи Цикл
		
		НоваяСтрока = ОбязательныеСвязи.Добавить();
		
		НоваяСтрока.ТипСвязи = Строка.ТипСвязи;
		НоваяСтрока.СсылкаНа = Строка.СсылкаНа;
		
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ОчиститьСообщения();
	
	Для Каждого Строка Из ОбязательныеСвязи Цикл
		
		Если Не ЗначениеЗаполнено(Строка.СвязанныйДокумент) Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Нужно указать связанный документ.'"));
			Возврат;
		КонецЕсли;	
		
	КонецЦикла;	
	
	МассивВозврата = Новый Массив;
	
	Для Каждого Строка Из ОбязательныеСвязи Цикл
		
		ПараметрыВозврата = Новый Структура("ТипСвязи, СсылкаНа, СвязанныйДокумент", 
			Строка.ТипСвязи, Строка.СсылкаНа, Строка.СвязанныйДокумент);
			
		МассивВозврата.Добавить(ПараметрыВозврата);
		
	КонецЦикла;	
	
	Закрыть(МассивВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбязательныеСвязиСвязанныйДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ОбязательныеСвязи.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ТекущиеДанные = Элементы.ОбязательныеСвязи.ТекущиеДанные;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СвязанныйДокументНачалоВыбораПродолжение",
		ЭтотОбъект);
	
	ОбязательныеСвязиПараметр = Новый Массив;
			
	ПараметрыСвязи = Новый Структура("ТипСвязи, СсылкаНа",
		ТекущиеДанные.ТипСвязи, ТекущиеДанные.СсылкаНа);
	
	ОбязательныеСвязиПараметр.Добавить(ПараметрыСвязи);
	
	ПараметрыОткрытияФормы = Новый Структура(
		"Документ, ОбязательныеСвязи, Корреспондент, Организация, Проект", 
		Документ, ОбязательныеСвязиПараметр,
		Корреспондент, Организация, Проект);	
		
	ИмяФормыСозданияСвязи = "";	
		
	СтрокаПараметров = ТекущиеДанные;
	Если ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.ВнутренниеДокументы")
		Или ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда
		ИмяФормыСозданияСвязи = "Справочник.ВнутренниеДокументы.Форма.ФормаВыбораДляСозданияСвязи";
	ИначеЕсли ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.ВходящиеДокументы")
		Или ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.ВидыВходящихДокументов") Тогда
		ИмяФормыСозданияСвязи = "Справочник.ВходящиеДокументы.Форма.ФормаВыбораДляСозданияСвязи";
	ИначеЕсли ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.ИсходящиеДокументы")
		Или ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
		ИмяФормыСозданияСвязи = "Справочник.ИсходящиеДокументы.Форма.ФормаВыбораДляСозданияСвязи";
	ИначеЕсли ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.Файлы") Тогда
		ИмяФормыСозданияСвязи = "Справочник.Файлы.Форма.ФормаВыбораДляСозданияСвязи";
	ИначеЕсли ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.Мероприятия") Тогда
		ИмяФормыСозданияСвязи = "Справочник.Мероприятия.Форма.ФормаВыбораДляСозданияСвязи";
	ИначеЕсли ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("СправочникСсылка.Проекты") Тогда
		ИмяФормыСозданияСвязи = "Справочник.Проекты.Форма.ФормаВыбораДляСозданияСвязи";
	ИначеЕсли ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("ДокументСсылка.ВходящееПисьмо") Тогда
		ИмяФормыСозданияСвязи = "Документ.ВходящееПисьмо.Форма.ФормаВыбораДляСозданияСвязи";
	ИначеЕсли ТипЗнч(СтрокаПараметров.СсылкаНа) = Тип("ДокументСсылка.ИсходящееПисьмо") Тогда
		ИмяФормыСозданияСвязи = "Документ.ИсходящееПисьмо.Форма.ФормаВыбораДляСозданияСвязи";
	КонецЕсли;	
	
	ОткрытьФорму(ИмяФормыСозданияСвязи, 
		ПараметрыОткрытияФормы, ЭтаФорма,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СвязанныйДокументНачалоВыбораПродолжение(Результат, Параметры) Экспорт 
	
	Если ЗначениеЗаполнено(Результат) Тогда 
		
		Если Элементы.ОбязательныеСвязи.ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;	
		
		ВыбранныеОбязательныеСвязи = Результат; // массив
		Если ВыбранныеОбязательныеСвязи.Количество() = 1 Тогда
			
			Строка = ВыбранныеОбязательныеСвязи[0];
			ТекущиеДанные = Элементы.ОбязательныеСвязи.ТекущиеДанные;
			ТекущиеДанные.СвязанныйДокумент = Строка.СвязанныйДокумент;
			
		КонецЕсли;	
		
	КонецЕсли;	

КонецПроцедуры
