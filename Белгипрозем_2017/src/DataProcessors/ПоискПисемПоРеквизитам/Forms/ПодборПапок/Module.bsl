
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОтображатьУдаленные") Тогда
		ОтображатьУдаленные = Параметры.ОтображатьУдаленные;
	Иначе
		ОтображатьУдаленные =
			ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку("ОтображатьУдаленныеПисьмаИПапки");
	КонецЕсли;

	Если Параметры.Свойство("ОтображатьТолькоМоиПапки") Тогда
		ОтображатьТолькоМоиПапки = Параметры.ОтображатьТолькоМоиПапки;
	Иначе
		ОтображатьТолькоМоиПапки = ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку("РежимМоиПапки");
	КонецЕсли;
	
	Если Параметры.Свойство("ОтмеченныеЗначения") Тогда
		ДобавитьПапкиВСписокВыбранныхСервер(Параметры.ОтмеченныеЗначения);
	КонецЕсли;
	
	ЗаполнитьДеревоПапок();
	
	СостояниеДереваПапок = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		ЭтаФорма.ИмяФормы, 
		"СостояниеДерева", 
		Неопределено);
	Если СостояниеДереваПапок = Неопределено И Параметры.Свойство("СостояниеДереваПапок") Тогда
		СостояниеДереваПапок = Параметры.СостояниеДереваПапок;
	КонецЕсли;
	
	Элементы.ДеревоПапокКонтекстноеМенюТолькоМоиПапки.Пометка = ОтображатьТолькоМоиПапки;
	Элементы.ДеревоПапокКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленные;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	Если СостояниеДереваПапок <> Неопределено Тогда
		ВосстановитьСостояниеДереваПапок(СостояниеДереваПапок);
	КонецЕсли;
	
	ИзмененоСостояниеДерева = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПапкаПисемСохранена" Тогда
		СостояниеДерева = ЗапомнитьСостояниеДереваПапок();
		ЗаполнитьДеревоПапок();
		СостояниеДерева.ТекСсылка = Параметр;
		ВосстановитьСостояниеДереваПапок(СостояниеДерева);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбойтиДерево(ДеревоЭлементы, Контекст, ИмяПроцедуры)
	
	Для каждого Элемент Из ДеревоЭлементы Цикл
		// Рекурсивный вызов
		ОбойтиДерево(Элемент.ПолучитьЭлементы(), Контекст, ИмяПроцедуры);
		Результат = Вычислить(ИмяПроцедуры + "(Элемент, Контекст)");
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ЗапомнитьСостояниеДереваПапок()
	
	Состояние = Новый Структура;
	Состояние.Вставить("ТекСсылка", Неопределено);
	Если Элементы.ДеревоПапок.ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = Элементы.ДеревоПапок.ТекущиеДанные;
		Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
			Состояние.ТекСсылка = ТекущиеДанные.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Дерево", ДеревоПапок);
	Контекст.Вставить("ФормаДерево", Элементы.ДеревоПапок);
	Контекст.Вставить("Состояние", Новый Соответствие);
	ОбойтиДерево(ДеревоПапок.ПолучитьЭлементы(), Контекст, "ЗапомнитьСостояниеРазвернут");
	Состояние.Вставить("Развернут", Контекст.Состояние);
	
	Возврат Состояние;
	
КонецФункции

&НаКлиенте
Функция ЗапомнитьСостояниеРазвернут(Элемент, Контекст)
	
	ИдентификаторСтроки = Элемент.ПолучитьИдентификатор();
	ТекДанные = Контекст.Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
	Контекст.Состояние.Вставить(ТекДанные.Ссылка, Контекст.ФормаДерево.Развернут(ИдентификаторСтроки));
	
КонецФункции

&НаКлиенте
Процедура ВосстановитьСостояниеДереваПапок(Состояние)
	
	Контекст = Новый Структура;
	Контекст.Вставить("Дерево", ДеревоПапок);
	Контекст.Вставить("ФормаДерево", Элементы.ДеревоПапок);
	Контекст.Вставить("Состояние", Состояние.Развернут);
	Контекст.Вставить("ТекСсылка", Состояние.ТекСсылка);
	ОбойтиДерево(ДеревоПапок.ПолучитьЭлементы(), Контекст, "УстановитьСостояниеРазвернут");
	
КонецПроцедуры

&НаКлиенте
Функция УстановитьСостояниеРазвернут(Элемент, Контекст)
	
	ИдентификаторСтроки = Элемент.ПолучитьИдентификатор();
	ТекДанные = Контекст.Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если Контекст.Состояние.Получить(ТекДанные.Ссылка) = Истина Тогда
		Контекст.ФормаДерево.Развернуть(ИдентификаторСтроки);
	Иначе
		Контекст.ФормаДерево.Свернуть(ИдентификаторСтроки);
	КонецЕсли;
	Если ТекДанные.Ссылка = Контекст.ТекСсылка Тогда
		Контекст.ФормаДерево.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДеревоПапок()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПапкиПисем.Ссылка КАК Ссылка,
		|	ВЫБОР
		|		КОГДА ПапкиПисем.Ссылка В (&СписокВыбранныхПапок)
		|			ТОГДА Истина
		|		ИНАЧЕ Ложь
		|	КОНЕЦ КАК Выбрана,
		|	ПапкиПисем.ПометкаУдаления КАК ПометкаУдаления,
		|	ПапкиПисем.Представление КАК Представление,
		|	ПапкиПисем.ВидПапки КАК ВидПапки,
		|	ВЫБОР
		|		КОГДА ПапкиПисем.ПометкаУдаления
		|			ТОГДА 1
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Черновики)
		|			ТОГДА 2
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Корзина)
		|			ТОГДА 4
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК НомерКартинки,
		|	ВЫБОР
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Входящие)
		|			ТОГДА 1
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Исходящие)
		|			ТОГДА 2
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Отправленные)
		|			ТОГДА 3
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Корзина)
		|			ТОГДА 5
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Черновики)
		|			ТОГДА 6
		|		ИНАЧЕ 7
		|	КОНЕЦ КАК Порядок,
		|	ПапкиПисем.ВариантОтображенияКоличестваПисем,");
		
	Если ОтображатьТолькоМоиПапки Тогда
		Запрос.Текст = Запрос.Текст +
			"
			|	ВЫБОР КОГДА ИСТИНА ТОГДА ЛОЖЬ КОНЕЦ КАК ПапкаБыстрогоДоступа";
	Иначе
		Запрос.Текст = Запрос.Текст +
			"
			|ВЫБОР
			|	КОГДА ПапкиПисемБыстрогоДоступа.Папка ЕСТЬ NULL 
			|		ТОГДА ЛОЖЬ
			|	ИНАЧЕ ИСТИНА
			|КОНЕЦ КАК ПапкаБыстрогоДоступа"
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст +
		"
		|ИЗ
		|	Справочник.ПапкиПисем КАК ПапкиПисем
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПапкиПисемБыстрогоДоступа КАК ПапкиПисемБыстрогоДоступа
		|	ПО (ПапкиПисемБыстрогоДоступа.Папка = ПапкиПисем.Ссылка И ПапкиПисемБыстрогоДоступа.Пользователь = &ТекущийПользователь)
		|ГДЕ
		|	((НЕ ПапкиПисем.ПометкаУдаления)
		|			ИЛИ &ОтображатьУдаленные)";
		
	Если ОтображатьТолькоМоиПапки Тогда
		Запрос.Текст = Запрос.Текст +
			"
			|	И ПапкиПисем.Ссылка В ИЕРАРХИИ
			|		(ВЫБРАТЬ
			|			ПапкиПисемБыстрогоДоступа.Папка
			|		ИЗ
			|			РегистрСведений.ПапкиПисемБыстрогоДоступа КАК ПапкиПисемБыстрогоДоступа
			|		ГДЕ
			|			ПапкиПисемБыстрогоДоступа.Пользователь = &ТекущийПользователь)";
	КонецЕсли;
		
	Запрос.Текст = Запрос.Текст +
		"
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка ИЕРАРХИЯ";
		
	Запрос.УстановитьПараметр("ОтображатьУдаленные", ОтображатьУдаленные);
	Запрос.УстановитьПараметр("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	СписокВыбранныхПапок = Новый Массив;
	Для Каждого СтрокаВыбраннойПапки из ВыбранныеПапки Цикл
		СписокВыбранныхПапок.Добавить(СтрокаВыбраннойПапки.Ссылка);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("СписокВыбранныхПапок", СписокВыбранныхПапок);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ТекУчетнаяЗапись = Неопределено;
	СтрокаУчетнаяЗапись = Неопределено;
	
	ДеревоПапокОбъект = РеквизитФормыВЗначение("ДеревоПапок");
	ДеревоПапокОбъект.Строки.Очистить();
	ДобавитьПапкиВДерево(ДеревоПапокОбъект.Строки, Дерево.Строки);
	СортироватьИерархически(ДеревоПапокОбъект.Строки, "Порядок, Наименование");
	
	ВсеМоиПапкиПользователя = ВстроеннаяПочтаСервер.ПолучитьВсеПапкиПисемПользователя(ПользователиКлиентСервер.ТекущийПользователь());
	Если ВсеМоиПапкиПользователя.Количество() > 0 Тогда
		СтрокаМоиПапки = ДеревоПапокОбъект.Строки.Вставить(0);
		СтрокаМоиПапки.Ссылка = "МоиПапки";
		СтрокаМоиПапки.Наименование = НСтр("ru = 'Все ""Мои папки""'");
		СтрокаМоиПапки.ПолныйПуть = НСтр("ru = 'Все ""Мои папки""'");
		СтрокаМоиПапки.Выбрана = ВыбранныеПапки.НайтиСтроки(Новый Структура("Ссылка", "МоиПапки")).Количество() > 0;
		СтрокаМоиПапки.НомерКартинки = 0;
		СтрокаМоиПапки.ПапкаБыстрогоДоступа = Истина;
	КонецЕсли;
	
	ЗначениеВДанныеФормы(ДеревоПапокОбъект, ДеревоПапок);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПапкиВДерево(ДеревоСтроки, ИсточникСтроки)
	
	МенеджерПапокПисем = Справочники.ПапкиПисем;
	
	Для каждого ПапкаИнфо Из ИсточникСтроки Цикл
		СтрокаПапка = ДеревоСтроки.Добавить();
		СтрокаПапка.Ссылка = ПапкаИнфо.Ссылка;
		СтрокаПапка.Выбрана = ПапкаИнфо.Выбрана;
		СтрокаПапка.Наименование = ПапкаИнфо.Представление;
		СтрокаПапка.ПолныйПуть = МенеджерПапокПисем.ПолучитьПолныйПутьПапки(ПапкаИнфо.Ссылка);
		СтрокаПапка.ВидПапки = ПапкаИнфо.ВидПапки;
		СтрокаПапка.Порядок = ПапкаИнфо.Порядок;
		СтрокаПапка.НомерКартинки = ПапкаИнфо.НомерКартинки;
		СтрокаПапка.ВариантОтображенияКоличестваПисем = ПапкаИнфо.ВариантОтображенияКоличестваПисем;
		СтрокаПапка.ПапкаБыстрогоДоступа = ПапкаИнфо.ПапкаБыстрогоДоступа;
		СтрокаПапка.ПометкаУдаления = ПапкаИнфо.ПометкаУдаления;
		ДобавитьПапкиВДерево(СтрокаПапка.Строки, ПапкаИнфо.Строки);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СортироватьИерархически(СтрокиДерева, Знач Колонки)
	
	СтрокиДерева.Сортировать(Колонки);
	Для каждого СтрокаДерева Из СтрокиДерева Цикл
		Если СтрокаДерева.Строки.Количество() > 0 Тогда
			СортироватьИерархически(СтрокаДерева.Строки, Колонки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПапкиВСписокВыбранныхСервер(Папки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПапкиПисем.Ссылка КАК Ссылка,
		|	ПапкиПисем.ПометкаУдаления КАК ПометкаУдаления,
		|	ВЫБОР
		|		КОГДА ПапкиПисем.ПометкаУдаления
		|			ТОГДА 1
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Черновики)
		|			ТОГДА 2
		|		КОГДА ПапкиПисем.ВидПапки = ЗНАЧЕНИЕ(Перечисление.ВидыПапокПисем.Корзина)
		|			ТОГДА 4
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК НомерКартинки,
		|	ВЫБОР
		|		КОГДА ПапкиПисемБыстрогоДоступа.Папка ЕСТЬ NULL 
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ПапкаБыстрогоДоступа
		|ИЗ
		|	Справочник.ПапкиПисем КАК ПапкиПисем
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПапкиПисемБыстрогоДоступа КАК ПапкиПисемБыстрогоДоступа
		|		ПО (ПапкиПисемБыстрогоДоступа.Папка = ПапкиПисем.Ссылка)
		|			И (ПапкиПисемБыстрогоДоступа.Пользователь = &ТекущийПользователь)
		|ГДЕ
		|	(ПапкиПисем.Ссылка В (&Папки))";
		
	Запрос.УстановитьПараметр("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());
	Запрос.УстановитьПараметр("Папки", Папки);
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ВыбранныеПапки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.ПолныйПуть = Справочники.ПапкиПисем.ПолучитьПолныйПутьПапки(Выборка.Ссылка);
	КонецЦикла;
	
	Если Папки.Найти("МоиПапки") <> Неопределено Тогда
		НоваяСтрока = ВыбранныеПапки.Вставить(0);
		НоваяСтрока.Ссылка = "МоиПапки";
		НоваяСтрока.ПолныйПуть = "Все ""Мои папки""";
		НоваяСтрока.ПапкаБыстрогоДоступа = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Функция ИдентификаторСтрокиДереваПоСсылке(Ссылка, СтрокиДерева, Идентификатор = Неопределено)
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		
		Если Идентификатор <> Неопределено Тогда
			Возврат Идентификатор;
		КонецЕсли;
		
		Если СтрокаДерева.Ссылка = Ссылка Тогда
			Идентификатор = СтрокаДерева.ПолучитьИдентификатор();
		Иначе
			ИдентификаторСтрокиДереваПоСсылке(Ссылка, СтрокаДерева.ПолучитьЭлементы(), Идентификатор);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Идентификатор
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура Готово(Команда)
	
	Если ИзмененоСостояниеДерева Тогда
		СостояниеДерева = ЗапомнитьСостояниеДереваПапок();
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ЭтаФорма.ИмяФормы, "СостояниеДерева", СостояниеДерева);
	КонецЕсли;
	
	СписокВыбранныхПапок = Новый Массив;
	Для Каждого СтрокаВыбраннойПапки из ВыбранныеПапки Цикл
		СписокВыбранныхПапок.Добавить(СтрокаВыбраннойПапки.Ссылка);
	КонецЦикла;
	
	Закрыть(СписокВыбранныхПапок);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПапокВыбранаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоПапок.ТекущиеДанные;
	
	Если ТекущиеДанные.Выбрана Тогда
		ПараметрыОтбора = Новый Структура("Ссылка", ТекущиеДанные.Ссылка);
		Если ВыбранныеПапки.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда 
			НоваяСтрока = ?(ТекущиеДанные.Ссылка = "МоиПапки", ВыбранныеПапки.Вставить(0), ВыбранныеПапки.Добавить());
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		КонецЕсли;
		ТекущаяСтрока = Элементы.ДеревоПапок.ТекущаяСтрока;
		ЭлементДерева = ДеревоПапок.НайтиПоИдентификатору(ТекущаяСтрока);
		ПометитьДочерниеПапки(ЭлементДерева);
	Иначе
		НайденныеСтроки = ВыбранныеПапки.НайтиСтроки(Новый Структура("Ссылка", ТекущиеДанные.Ссылка));
		Если НайденныеСтроки.Количество() > 0 Тогда
			ВыбранныеПапки.Удалить(НайденныеСтроки[0]);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьДочерниеПапки(ЭлементДерева)
	
	ПодчиненныеЭлементыДерева = ЭлементДерева.ПолучитьЭлементы();
	Для Каждого ПодчиненныйЭлементДерева Из ПодчиненныеЭлементыДерева Цикл
		ПодчиненныйЭлементДерева.Выбрана = Истина;
		ПараметрыОтбора = Новый Структура("Ссылка", ПодчиненныйЭлементДерева.Ссылка);
		Если ВыбранныеПапки.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
			НоваяСтрока = ВыбранныеПапки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ДеревоПапок.НайтиПоИдентификатору(ПодчиненныйЭлементДерева.ПолучитьИдентификатор()));
		КонецЕсли;
		ПометитьДочерниеПапки(ПодчиненныйЭлементДерева);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПапокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Элементы.ДеревоПапок.ТекущиеДанные.Выбрана = Не Элементы.ДеревоПапок.ТекущиеДанные.Выбрана;
	ДеревоПапокВыбранаПриИзменении(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПапкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПапкиПередУдалением(Элемент, Отказ)
	
	Для Каждого ИдентификаторУдаляемойСтроки из Элемент.ВыделенныеСтроки Цикл
		
		УдаляемаяСтрока = ВыбранныеПапки.НайтиПоИдентификатору(ИдентификаторУдаляемойСтроки);
		ИдентификаторСтрокиДерева = ИдентификаторСтрокиДереваПоСсылке(
									УдаляемаяСтрока.Ссылка, ДеревоПапок.ПолучитьЭлементы());
		
		Если ИдентификаторСтрокиДерева <> Неопределено Тогда
			СтрокаДерева = ДеревоПапок.НайтиПоИдентификатору(ИдентификаторСтрокиДерева);
			СтрокаДерева.Выбрана = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоМоиПапки(Команда)
	
	ОтображатьТолькоМоиПапки = Не ОтображатьТолькоМоиПапки;
	Элементы.ДеревоПапокКонтекстноеМенюТолькоМоиПапки.Пометка = ОтображатьТолькоМоиПапки;
	ЗаполнитьДеревоПапок();
	
	ВосстановитьСостояниеДереваПапок(СостояниеДереваПапок);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленные(Команда)
	
	ОтображатьУдаленные = Не ОтображатьУдаленные;
	Элементы.ДеревоПапокКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленные;
	ЗаполнитьДеревоПапок();
	
	ВосстановитьСостояниеДереваПапок(СостояниеДереваПапок);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПапокПередРазворачиванием(Элемент, Строка, Отказ)
	ИзмененоСостояниеДерева = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПапокПередСворачиванием(Элемент, Строка, Отказ)
	ИзмененоСостояниеДерева = Истина;
КонецПроцедуры
