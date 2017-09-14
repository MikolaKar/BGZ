
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка = Справочники.ГруппыПользователей.ПустаяСсылка()
	   И Объект.Родитель = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		
		Объект.Родитель = Справочники.ГруппыПользователей.ПустаяСсылка();
	КонецЕсли;
	
	Если Объект.Ссылка = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ЗаполнитьСтатусПользователей();
	
	ОбновитьСписокНедействительныхПользователей(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ГруппыПользователей", Новый Структура, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РодительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ВыборРодителя");
	
	ОткрытьФорму("Справочник.ГруппыПользователей.ФормаВыбора", ПараметрыФормы, Элементы.Родитель);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Объект.Состав.Очистить();
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		
		Для каждого Значение Из ВыбранноеЗначение Цикл
			ОбработкаВыбораПользователя(Значение);
		КонецЦикла;
		
	Иначе
		ОбработкаВыбораПользователя(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	СообщениеПользователю = ПеремещениеПользователяВГруппу(ПараметрыПеретаскивания.Значение, Объект.Ссылка);
	Если СообщениеПользователю <> Неопределено Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Перемещение пользователей'"), , СообщениеПользователю, БиблиотекаКартинок.Информация32);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьПользователей(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормы.Вставить("РасширенныйПодбор", Истина);
	ПараметрыФормы.Вставить("ПараметрыРасширеннойФормыПодбора", ПараметрыРасширеннойФормыПодбора());
	
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, Элементы.Состав);

КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователей(Команда)
	
	ОбновитьСписокНедействительныхПользователей(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Пользователь.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Состав.Недействителен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Серый);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораПользователя(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") Тогда
		Объект.Состав.Добавить().Пользователь = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПеремещениеПользователяВГруппу(МассивПользователей, НоваяГруппаВладелец)
	
	МассивПеремещенныхПользователей = Новый Массив;
	Для Каждого ПользовательСсылка Из МассивПользователей Цикл
		
		ПараметрыОтбора = Новый Структура("Пользователь", ПользовательСсылка);
		Если ТипЗнч(ПользовательСсылка) = Тип("СправочникСсылка.Пользователи")
			И Объект.Состав.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
			Объект.Состав.Добавить().Пользователь = ПользовательСсылка;
			МассивПеремещенныхПользователей.Добавить(ПользовательСсылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПользователиСлужебный.ФормированиеСообщенияПользователю(
		МассивПеремещенныхПользователей, НоваяГруппаВладелец, Ложь);
	
КонецФункции

&НаСервере
Функция ПараметрыРасширеннойФормыПодбора()
	
	ВыбранныеПользователи = Новый ТаблицаЗначений;
	ВыбранныеПользователи.Колонки.Добавить("Пользователь");
	ВыбранныеПользователи.Колонки.Добавить("НомерКартинки");
	
	УчастникиГруппы = Объект.Состав.Выгрузить(, "Пользователь");
	
	Для каждого Элемент Из УчастникиГруппы Цикл
		
		СтрокаВыбранныеПользователи = ВыбранныеПользователи.Добавить();
		СтрокаВыбранныеПользователи.Пользователь = Элемент.Пользователь;
		
	КонецЦикла;
	
	ЗаголовокФормыПодбора = НСтр("ru = 'Подбор участников группы пользователей'");
	ПараметрыРасширеннойФормыПодбора = 
		Новый Структура("ЗаголовокФормыПодбора, ВыбранныеПользователи, ПодборГруппНевозможен",
		                 ЗаголовокФормыПодбора, ВыбранныеПользователи, Истина);
	АдресХранилища = ПоместитьВоВременноеХранилище(ПараметрыРасширеннойФормыПодбора);
	Возврат АдресХранилища;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСтатусПользователей()
	
	Для Каждого СтрокаСоставаГруппы Из Объект.Состав Цикл
		СтрокаСоставаГруппы.Недействителен = 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаСоставаГруппы.Пользователь, "Недействителен");
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокНедействительныхПользователей(ПередОткрытиемФормы)
	
	Элементы.ПоказыватьНедействительныхПользователей.Пометка = ?(ПередОткрытиемФормы, Ложь,
		НЕ Элементы.ПоказыватьНедействительныхПользователей.Пометка);
	
	Отбор = Новый Структура;
	
	Если Не Элементы.ПоказыватьНедействительныхПользователей.Пометка Тогда
		Отбор.Вставить("Недействителен", Ложь);
		Элементы.Состав.ОтборСтрок = Новый ФиксированнаяСтруктура(Отбор);
	Иначе
		Элементы.Состав.ОтборСтрок = Новый ФиксированнаяСтруктура();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
