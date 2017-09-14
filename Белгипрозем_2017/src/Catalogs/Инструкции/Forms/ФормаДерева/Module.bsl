#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СостояниеДереваИнструкций = Неопределено;
	ПоказыватьУдаленные = Ложь;
			
	ЗаполнитьДеревоИнструкций();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СостояниеДереваИнструкций <> Неопределено Тогда
		ВосстановитьСостояниеДереваИнструкций(СостояниеДереваИнструкций);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СостояниеДереваИнструкций = ЗапомнитьСостояниеДереваИнструкций();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоИнструкцийПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено
		И ТипЗнч(Элемент.ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.Инструкции") Тогда
		ТекстВыбраннойИнструкции = РаботаСИнструкциямиКлиент.ТекстИнструкции(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	УстановитьДоступностьКоманд(Элемент.ТекущиеДанные);

КонецПроцедуры

&НаКлиенте
Процедура ДеревоИнструкцийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПредметИнструкции", Элемент.ТекущиеДанные.ПредметИнструкции);
		ОткрытьФорму("Справочник.Инструкции.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоИнструкцийПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если Элемент.ТекущиеДанные <> Неопределено
		И ТипЗнч(Элемент.ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.Инструкции") Тогда
		
		ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.Ссылка);
		
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоИнструкцийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	УстановитьЭлементуПометкуУдаления();
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	Если ТекстВыбраннойИнструкции <> Неопределено Тогда
		Элементы.ТекстВыбраннойИнструкции.Документ.execCommand("Print");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	Элементы.ФормаПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
	СостояниеДерева = ЗапомнитьСостояниеДереваИнструкций();
	ЗаполнитьДеревоИнструкций();
	ВосстановитьСостояниеДереваИнструкций(СостояниеДерева);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Запись_Инструкции" Тогда
		СостояниеДерева = ЗапомнитьСостояниеДереваИнструкций();
		ЗаполнитьДеревоИнструкций();
		СостояниеДерева.ТекСсылка = Параметр;
		ВосстановитьСостояниеДереваИнструкций(СостояниеДерева);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоИнструкцийПослеУдаления(Элемент)
	Элементы.ДеревоИнструкций.Обновить();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоИнструкций()
	
	// Заполнение предметами
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Предметы.Ссылка КАК Предмет,
		|	Предметы.Наименование КАК ПредставлениеПредмета,
		|	Предметы.ПометкаУдаления КАК ПометкаУдаления,
		|	ВЫБОР
		|		КОГДА Предметы.ПометкаУдаления
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК НомерКартинки
		|ИЗ
		|	Справочник.ПредметыИнструкций КАК Предметы
		|ГДЕ
		|	((НЕ Предметы.ПометкаУдаления) ИЛИ &ПоказыватьУдаленные)
		|УПОРЯДОЧИТЬ ПО
		|	ПредставлениеПредмета ИЕРАРХИЯ";
		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ПоказыватьУдаленные", ПоказыватьУдаленные);
	ДеревоПредметов = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	НовоеДерево = РеквизитФормыВЗначение("ДеревоИнструкций");
	НовоеДерево.Строки.Очистить();
	
	ДобавитьПредметыИнструкцийВДерево(НовоеДерево.Строки, ДеревоПредметов.Строки);
	
	// Заполнение инструкциями
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Инструкции.Ссылка КАК Инструкция,
		|	Инструкции.Наименование КАК ПредставлениеИнструкции,
		|	Инструкции.ПредметИнструкции КАК Предмет,
		|	Инструкции.ПометкаУдаления КАК ПометкаУдаления,
		|	Инструкции.Активна КАК Активна,
		|	ВЫБОР
		|		КОГДА Инструкции.ПометкаУдаления
		|			ТОГДА 3
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК НомерКартинки
		|ИЗ
		|	Справочник.Инструкции КАК Инструкции
		|ГДЕ
		|	((НЕ Инструкции.ПометкаУдаления) ИЛИ &ПоказыватьУдаленные)
		|УПОРЯДОЧИТЬ ПО
		|	ПредставлениеИнструкции";
		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ПоказыватьУдаленные", ПоказыватьУдаленные);
	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		
		НайденныйПредмет = НовоеДерево.Строки.Найти(Выборка.Предмет, "Ссылка", Истина);
		
		Если НайденныйПредмет <> Неопределено Тогда
			
			НоваяСтрока = НайденныйПредмет.Строки.Добавить();
			НоваяСтрока.Ссылка = Выборка.Инструкция;
			НоваяСтрока.Представление = Выборка.ПредставлениеИнструкции;
			НоваяСтрока.НомерКартинки = Выборка.НомерКартинки;
			НоваяСтрока.ПометкаУдаления = Выборка.ПометкаУдаления;
			НоваяСтрока.ПредметИнструкции = Выборка.Предмет;
			НоваяСтрока.Активна = Выборка.Активна;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗначениеВДанныеФормы(НовоеДерево, ДеревоИнструкций);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПредметыИнструкцийВДерево(СтрокиДерева, СтрокиИсточника)
	
	Для каждого СтрокаИсточника Из СтрокиИсточника Цикл
		
		НоваяСтрока = СтрокиДерева.Добавить();
		НоваяСтрока.Ссылка = СтрокаИсточника.Предмет;
		НоваяСтрока.Представление = СтрокаИсточника.ПредставлениеПредмета;
		НоваяСтрока.НомерКартинки = СтрокаИсточника.НомерКартинки;
		НоваяСтрока.ПометкаУдаления = СтрокаИсточника.ПометкаУдаления;
		НоваяСтрока.ПредметИнструкции = СтрокаИсточника.Предмет;
		НоваяСтрока.Активна = Истина;
		НоваяСтрока.ЯвляетсяПредметом = Истина;
		
		ДобавитьПредметыИнструкцийВДерево(НоваяСтрока.Строки, СтрокаИсточника.Строки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЭлементуПометкуУдаления()
	
	ТекущиеДанные = Элементы.ДеревоИнструкций.ТекущиеДанные;
	ТекущаяПометкаУдаления = ТекущиеДанные.ПометкаУдаления;
	
	ЭлементЕстьПредмет = ТипЗнч(ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.ПредметыИнструкций");
	ЭлементЕстьИнструкция = ТипЗнч(ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.Инструкции");
	
	Если Не ЭлементЕстьПредмет И Не ЭлементЕстьИнструкция Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭлементЕстьПредмет Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пометить на удаление все инструкции из группы ""%1""?'"),
			ТекущиеДанные.Представление);
	ИначеЕсли ЭлементЕстьИнструкция Тогда
		Если ТекущаяПометкаУдаления Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Cнять пометку на удаление с инструкции ""%1""?'"),
				ТекущиеДанные.Представление);
		Иначе
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Пометить на удаление инструкцию ""%1""?'"),
				ТекущиеДанные.Представление);
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"УстановитьЭлементуПометкуУдаленияПродолжение",
		ЭтотОбъект);
		
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЭлементуПометкуУдаленияПродолжение(ОтветНаВопрос, Параметры) Экспорт
	
	Если ОтветНаВопрос <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ДеревоИнструкций.ТекущиеДанные;
	ТекущаяПометкаУдаления = ТекущиеДанные.ПометкаУдаления;
	ЭлементЕстьПредмет = ТипЗнч(ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.ПредметыИнструкций");
	ЭлементЕстьИнструкция = ТипЗнч(ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.Инструкции");
	Результат = УстановитьЭлементуПометкуУдаленияНаСервере(ТекущиеДанные.Ссылка, НЕ ТекущаяПометкаУдаления);
	
	Если ЭлементЕстьПредмет Тогда
		Если Результат Тогда
			Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Пометка на удаление успешно установлена для всех инструкций из группы ""%1"".'"),
				ТекущиеДанные.Представление));
		Иначе
			ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось установить пометку на удаление для всех инструкций из группы ""%1"".'"),
				ТекущиеДанные.Представление);
			ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		КонецЕсли;			
	ИначеЕсли ЭлементЕстьИнструкция Тогда
		Если Результат Тогда
			Если ТекущаяПометкаУдаления Тогда
				Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Пометка на удаление с инструкции ""%1"" успешно снята.'"),
					ТекущиеДанные.Представление));
			Иначе
				Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Пометка на удаление успешно установлена для инструкции ""%1"".'"),
					ТекущиеДанные.Представление));
			КонецЕсли;
		Иначе
			Если ТекущаяПометкаУдаления Тогда
				ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось снять пометку на удаление с инструкции ""%1"".'"),
					ТекущиеДанные.Представление);
			Иначе
				ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось установить пометку на удаление для инструкции ""%1"".'"),
					ТекущиеДанные.Представление);
			КонецЕсли;
			ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		КонецЕсли;
	КонецЕсли;
	
	Если Результат Тогда
		СостояниеДерева = ЗапомнитьСостояниеДереваИнструкций();
		ЗаполнитьДеревоИнструкций();
		ВосстановитьСостояниеДереваИнструкций(СостояниеДерева);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция УстановитьЭлементуПометкуУдаленияНаСервере(СсылкаНаЭлемент, ЗначениеПометкиУдаления)

	Если ТипЗнч(СсылкаНаЭлемент) = Тип("СправочникСсылка.ПредметыИнструкций") Тогда
		
		ВыборкаИнструкций = РаботаСИнструкциями.ИнструкцииПоПредмету(СсылкаНаЭлемент, Ложь);
		
		Пока ВыборкаИнструкций.Следующий() Цикл
			Попытка
				ОбъектЭлемента = ВыборкаИнструкций.Ссылка.ПолучитьОбъект();
				ОбъектЭлемента.Заблокировать();
			Исключение
				Возврат Ложь;
			КонецПопытки;
				
			ОбъектЭлемента.УстановитьПометкуУдаления(ЗначениеПометкиУдаления);
			ОбъектЭлемента.Разблокировать();
		КонецЦикла;
		
		Возврат Истина;
		
	ИначеЕсли ТипЗнч(СсылкаНаЭлемент) = Тип("СправочникСсылка.Инструкции") Тогда
		
		Попытка
			ОбъектЭлемента = СсылкаНаЭлемент.ПолучитьОбъект();
			ОбъектЭлемента.Заблокировать();
		Исключение
			Возврат Ложь;
		КонецПопытки;
			
		ОбъектЭлемента.УстановитьПометкуУдаления(ЗначениеПометкиУдаления);
		ОбъектЭлемента.Разблокировать();
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции	

&НаКлиенте
Процедура УстановитьДоступностьКоманд(ТекущиеДанные = Неопределено)
	
	Если ТекущиеДанные <> Неопределено
		И ТипЗнч(ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.Инструкции")	Тогда
		Элементы.ФормаИзменить.Доступность = Истина;
	Иначе
		Элементы.ФормаИзменить.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЗапомнитьСостояниеДереваИнструкций()
	
	Состояние = Новый Структура;
	Состояние.Вставить("ТекСсылка", Неопределено);
	Если Элементы.ДеревоИнструкций.ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = Элементы.ДеревоИнструкций.ТекущиеДанные;
		Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
			Состояние.ТекСсылка = ТекущиеДанные.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Дерево", ДеревоИнструкций);
	Контекст.Вставить("ФормаДерево", Элементы.ДеревоИнструкций);
	Контекст.Вставить("Состояние", Новый Соответствие);
	ОбойтиДерево(ДеревоИнструкций.ПолучитьЭлементы(), Контекст, "ЗапомнитьСостояниеРазвернут");
	Состояние.Вставить("Развернут", Контекст.Состояние);
	
	Возврат Состояние;
	
КонецФункции

&НаКлиенте
Процедура ВосстановитьСостояниеДереваИнструкций(Состояние)
	
	Контекст = Новый Структура;
	Контекст.Вставить("Дерево", ДеревоИнструкций);
	Контекст.Вставить("ФормаДерево", Элементы.ДеревоИнструкций);
	Контекст.Вставить("Состояние", Состояние.Развернут);
	Контекст.Вставить("ТекСсылка", Состояние.ТекСсылка);
	ОбойтиДерево(ДеревоИнструкций.ПолучитьЭлементы(), Контекст, "УстановитьСостояниеРазвернут");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбойтиДерево(ДеревоЭлементы, Контекст, ИмяПроцедуры)
	
	Для каждого Элемент Из ДеревоЭлементы Цикл
		ПодчиненныеУзлы = Элемент.ПолучитьЭлементы();
		Если ПодчиненныеУзлы.Количество() > 0 Тогда
			ОбойтиДерево(ПодчиненныеУзлы, Контекст, ИмяПроцедуры);
		КонецЕсли;
		Результат = Вычислить(ИмяПроцедуры + "(Элемент, Контекст)");
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ЗапомнитьСостояниеРазвернут(Элемент, Контекст)
	
	ИдентификаторСтроки = Элемент.ПолучитьИдентификатор();
	ТекДанные = Контекст.Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
	Ключ = ТекДанные.Ссылка;
	Если Ключ = Неопределено Тогда
		Ключ = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПустаяСсылка");
	КонецЕсли;
	Контекст.Состояние.Вставить(Ключ, Контекст.ФормаДерево.Развернут(ИдентификаторСтроки));
	
КонецФункции

&НаКлиенте
Функция УстановитьСостояниеРазвернут(Элемент, Контекст)
	
	ИдентификаторСтроки = Элемент.ПолучитьИдентификатор();
	ТекДанные = Контекст.Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
	Ключ = ТекДанные.Ссылка;
	Если Ключ = Неопределено Тогда
		Ключ = ПредопределенноеЗначение("Справочник.ПредметыИнструкций.ПустаяСсылка");
	КонецЕсли;	
	Если Контекст.Состояние.Получить(Ключ) = Истина Тогда
		Контекст.ФормаДерево.Развернуть(ИдентификаторСтроки);
	Иначе
		Контекст.ФормаДерево.Свернуть(ИдентификаторСтроки);
	КонецЕсли;
	Если ТекДанные.Ссылка = Контекст.ТекСсылка Тогда
		Контекст.ФормаДерево.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьИнструкции(Команда)
	
	Если Элементы.ДеревоИнструкций.Видимость Тогда
		ЗаполнитьДеревоИнструкций();
		Если СостояниеДереваИнструкций <> Неопределено Тогда
			ВосстановитьСостояниеДереваИнструкций(СостояниеДереваИнструкций);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки["СостояниеДереваИнструкций"] <> Неопределено Тогда
		СостояниеДереваИнструкций = Настройки["СостояниеДереваИнструкций"];
		ЗаполнитьДеревоИнструкций();
	КонецЕсли;
	
	Если Настройки["ПоказыватьУдаленные"] <> Неопределено Тогда
		Элементы.ФормаПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	КонецЕсли;
			
КонецПроцедуры

#КонецОбласти
