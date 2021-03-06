////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ТекстЗаголовкаФормы;
	Если Параметры.Свойство("ЗаголовокФормы", ТекстЗаголовкаФормы) И
		НЕ ПустаяСтрока(ТекстЗаголовкаФормы) Тогда
		Заголовок = ТекстЗаголовкаФормы;
		АвтоЗаголовок = Ложь;
				
	КонецЕсли;
	
	Если Параметры.Свойство("БизнесПроцесс") Тогда
		СтрокаБизнесПроцесса = Параметры.БизнесПроцесс;
		СтрокаЗадачи = Параметры.Задача;
		Элементы.ГруппаЗаголовок.Видимость = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("ПоказыватьЗадачи") Тогда
		ПоказыватьЗадачи = Параметры.ПоказыватьЗадачи;
	Иначе
		ПоказыватьЗадачи = 2;
	КонецЕсли;
	
	Если Параметры.Свойство("ВидимостьОтборов") Тогда
		Элементы.ГруппаОтбор.Видимость = Параметры.ВидимостьОтборов;
	Иначе	
		ПоАвтору = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	
	Если ПоИсполнителю = Неопределено Тогда
		ПоИсполнителю = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
	НастройкиОтбора = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы + "/ТекущиеДанные");
	
	Если ЗначениеЗаполнено(НастройкиОтбора) Тогда
		ПоказыватьПрерванные = НастройкиОтбора.Получить("ПоказыватьПрерванные");
	Иначе
		ПоказыватьПрерванные = Ложь;
	КонецЕсли;
	
	Элементы.ПоказатьПрерванные.Пометка = ПоказыватьПрерванные;
	
	Если НастройкиОтбора = Неопределено Тогда
		УстановитьОтборСервер();
	Иначе
		УстановитьОтборСписка(Список, НастройкиОтбора);
	КонецЕсли;
	
	Если Параметры.Свойство("БлокировкаОкнаВладельца") Тогда
		РежимОткрытияОкна = Параметры.БлокировкаОкнаВладельца;
	КонецЕсли;	
		
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДФ='dd.MM.yyyy HH:mm'", "ДЛФ=D");
	Элементы.ДатаИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДФ='dd.MM.yyyy HH:mm'", "ДЛФ=D");
	
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список.УсловноеОформление);
	
	// Установка оформления для помеченных на удаление задач
	
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементШрифтОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Font");
	ЭлементШрифтОформления.Значение = Новый Шрифт(,,,,,Истина);
	ЭлементШрифтОформления.Использование = Истина;
	
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПринятаКИсполнению");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементШрифтОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Font");
	ЭлементШрифтОформления.Значение = Новый Шрифт(,, Истина,,, Истина);
	ЭлементШрифтОформления.Использование = Истина;
	
	// автообновление
	Если ОбщегоНазначенияДокументооборот.ПриложениеЯвляетсяВебКлиентом() Тогда
		Элементы.СписокКонтекстноеМенюЗадачиАвтообновление.Видимость = Ложь;
	Иначе
		НастройкиАвтообновления = Автообновление.ПолучитьНастройкиАвтообновленияФормы(ЭтаФорма);
		Элементы.СписокКонтекстноеМенюЗадачиАвтообновление.Видимость = Истина;		
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	
	// Контроль
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда 
		Элементы.СостояниеКонтроля.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗадачаИзменена" И Источник <> ЭтаФорма
		Или ИмяСобытия = "БизнесПроцессСтартован" Тогда
		
		Элементы.Список.Обновить();
		
		УстановитьДоступностьКомандПринятияКИсполнениюДляДереваЗадач();
		
	ИначеЕсли ИмяСобытия = "ИзменилсяФлаг"
		И ТипЗнч(Параметр[0]) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда

		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ЗаписьКонтроля" Тогда
		Если ЗначениеЗаполнено(Параметр.Предмет)
			И ТипЗнч(Параметр.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда 
			ОповеститьОбИзменении(Параметр.Предмет);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если Не ВебКлиент Тогда
		УстановитьАвтообновлениеФормы();
	#КонецЕсли
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПоИсполнителюПриИзменении(Элемент)
		
	ОписаниеОповещения =
		Новый ОписаниеОповещения("ПоИсполнителюПриИзмененииЗавершение", ЭтаФорма);
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьОбъектыАдресацииРоли(
		ЭтаФорма,
		"ПоИсполнителю",
		"ОсновнойОбъектАдресации",
		"ДополнительныйОбъектАдресации",
		ЭтаФорма,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюПриИзмененииЗавершение(Результат, Параметры) Экспорт
	
	УстановитьОтборКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьИсполнителя(Элемент, ПоИсполнителю,,,,,
		ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации);

КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоИсполнителю = ВыбранноеЗначение.РольИсполнителя;
		ОсновнойОбъектАдресации = ВыбранноеЗначение.ОсновнойОбъектАдресации;
		ДополнительныйОбъектАдресации = ВыбранноеЗначение.ДополнительныйОбъектАдресации;
		
		УстановитьОтборКлиент();
		
	Иначе  
		ОсновнойОбъектАдресации = Неопределено;
		ДополнительныйОбъектАдресации = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПоИсполнителю = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	
	УстановитьОтборКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоИсполнителюОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоАвторуПриИзменении(Элемент)
	
	УстановитьОтборКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПроектуПриИзменении(Элемент)	
	
	УстановитьОтборКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьЗадачиПриИзменении(Элемент)
	
	УстановитьОтборКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ОткрытьФорму("ОбщаяФорма.СозданиеБизнесПроцесса");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандПринятияКИсполнениюДляДереваЗадач()
	
	ДоступностьКомандыПринятьКИсполнению = Ложь;
	ДоступностьКомандыОтменитьПринятиеКИсполнению = Ложь;
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
	
		Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
			
			ДоступностьКомандыПринятьКИсполнению = Ложь;
			ДоступностьКомандыОтменитьПринятиеКИсполнению = Ложь;
			
		ИначеЕсли Элементы.Список.ВыделенныеСтроки.Количество() = 1 Тогда
			
			ОбщаяДоступностьКомандПринятияКИсполнению = 
				НЕ Элементы.Список.ТекущиеДанные.Выполнена
				И Элементы.Список.ТекущиеДанные.СостояниеБизнесПроцесса 
					= ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Активен");
			
			ДоступностьКомандыПринятьКИсполнению = 
				НЕ Элементы.Список.ТекущиеДанные.ПринятаКИсполнению
				И ОбщаяДоступностьКомандПринятияКИсполнению;
			
			ДоступностьКомандыОтменитьПринятиеКИсполнению = 
				Элементы.Список.ТекущиеДанные.ПринятаКИсполнению
				И ОбщаяДоступностьКомандПринятияКИсполнению;
			
		Иначе
			
			ДоступностьКомандыПринятьКИсполнению = Истина;
			ДоступностьКомандыОтменитьПринятиеКИсполнению = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.ПринятьКИсполнению.Доступность = 
		ДоступностьКомандыПринятьКИсполнению;
	
	Элементы.ОтменитьПринятиеКИсполнению.Доступность = 
		ДоступностьКомандыОтменитьПринятиеКИсполнению;
		
	Элементы.СписокКонтекстноеМенюПринятьКИсполнению.Доступность = 
		ДоступностьКомандыПринятьКИсполнению;
	
	Элементы.СписокКонтекстноеМенюОтменитьПринятиеКИсполнению.Доступность = 
		ДоступностьКомандыОтменитьПринятиеКИсполнению;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ФЛАГАМИ

&НаКлиенте
Процедура ЖелтыйФлаг(Команда)
	
	УстановитьФлаги(ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Желтый"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗеленыйФлаг(Команда)
	
	УстановитьФлаги(ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Зеленый"));
	
КонецПроцедуры

&НаКлиенте
Процедура КрасныйФлаг(Команда)
	
	УстановитьФлаги(ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Красный"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиловыйФлаг(Команда)
	
	УстановитьФлаги(ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Лиловый"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОранжевыйФлаг(Команда)
	
	УстановитьФлаги(ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Оранжевый"));
	
КонецПроцедуры

&НаКлиенте
Процедура СинийФлаг(Команда)
	
	УстановитьФлаги(ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Синий"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФлаг(Команда)
	
	УстановитьФлаги(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлаги(Флаг)
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагиЗадачам(ВыделенныеСтроки, Флаг);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПоказатьПрерванные(Команда)
	
	ПоказыватьПрерванные = Не ПоказыватьПрерванные;
	Элементы.ПоказатьПрерванные.Пометка = ПоказыватьПрерванные;
	
	УстановитьОтборКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборКлиент()

	УстановитьОтборСервер();
	Элементы.Список.Обновить();

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСервер()
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоАвтору", ПоАвтору);
	ПараметрыОтбора.Вставить("ПоИсполнителю", ПоИсполнителю);
	ПараметрыОтбора.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	ПараметрыОтбора.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	ПараметрыОтбора.Вставить("ПоказыватьЗадачи", ПоказыватьЗадачи);
	ПараметрыОтбора.Вставить("ПоПроекту", ПоПроекту);
	
	Параметрыотбора.Вставить("ПоказыватьПрерванные", ПоказыватьПрерванные);
	
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	ПоАвтору = ПараметрыОтбора["ПоАвтору"];
	Если ЗначениеЗаполнено(ПоАвтору) Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Автор", ПоАвтору);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Автор");
	КонецЕсли;
	
	ПоИсполнителю = ПараметрыОтбора["ПоИсполнителю"];
	ОсновнойОбъектАдресации = ПараметрыОтбора["ОсновнойОбъектАдресации"];
	ДополнительныйОбъектАдресации = ПараметрыОтбора["ДополнительныйОбъектАдресации"];
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Исполнитель");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "РольИсполнителя");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ОсновнойОбъектАдресации");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ДополнительныйОбъектАдресации");
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список,
		"Исполнитель",
		Неопределено,
		Ложь);
				
	Если ЗначениеЗаполнено(ПоИсполнителю) Тогда
		
		Если ТипЗнч(ПоИсполнителю) = Тип("СправочникСсылка.РолиИсполнителей") Тогда 
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "РольИсполнителя", ПоИсполнителю);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Исполнитель", Справочники.Пользователи.ПустаяСсылка());
			Если ЗначениеЗаполнено(ОсновнойОбъектАдресации) Тогда  
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
			КонецЕсли;
			Если ЗначениеЗаполнено(ДополнительныйОбъектАдресации) Тогда  
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
			КонецЕсли;
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
				Список,
				"Исполнитель",
				ПоИсполнителю);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда
		ПоПроекту = ПараметрыОтбора["ПоПроекту"];
		Если ЗначениеЗаполнено(ПоПроекту) Тогда 
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Проект", ПоПроекту);
		Иначе
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Проект");
		КонецЕсли;
	КонецЕсли;	
	
	ПоказыватьЗадачи = ПараметрыОтбора["ПоказыватьЗадачи"];
	Если ЗначениеЗаполнено(ПоказыватьЗадачи) Тогда 
		Если ПоказыватьЗадачи = 1 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Выполнена", Истина);
		КонецЕсли;
		Если ПоказыватьЗадачи = 2 Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Выполнена", Ложь);
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Выполнена");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "СостояниеБизнесПроцесса");
	
	ПоказыватьПрерванные = ПараметрыОтбора["ПоказыватьПрерванные"];
	Если ЗначениеЗаполнено(ПоказыватьПрерванные) И Не ПоказыватьПрерванные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор, 
			"СостояниеБизнесПроцесса", 
			Перечисления.СостоянияБизнесПроцессов.Прерван, 
			ВидСравненияКомпоновкиДанных.НеРавно);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПринятьЗадачиКИсполнению(Элементы.Список.ВыделенныеСтроки, ЭтаФорма);
	
	Элементы.Список.Обновить();
	
	УстановитьДоступностьКомандПринятияКИсполнениюДляДереваЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОтменитьПринятиеЗадачКИсполнению(Элементы.Список.ВыделенныеСтроки, ЭтаФорма);
	
	Элементы.Список.Обновить();
	
	УстановитьДоступностьКомандПринятияКИсполнениюДляДереваЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьДоступностьКоманд", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьКоманд()
	
	Элементы.ЗадачаЗадачаИсполнителяЗадатьВопросАвтору.Доступность = Ложь;
	
	Если Элементы.Список.ТекущиеДанные = Неопределено 
		Или ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Элементы.Список.ТекущиеДанные.БизнесПроцесс) <> Тип("БизнесПроцессСсылка.РешениеВопросовВыполненияЗадач") Тогда
		Элементы.ЗадачаЗадачаИсполнителяЗадатьВопросАвтору.Доступность = Истина;
	КонецЕсли;
	
	УстановитьДоступностьКомандПринятияКИсполнениюДляДереваЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущийЭлемент = Элементы.НомерФлага Тогда
		
		Если ТипЗнч(ВыбраннаяСтрока) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		РаботаСФлагамиОбъектовКлиент.ПереключитьФлагЗадачи(ВыбраннаяСтрока);
		
	Иначе
		
		БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	БизнесПроцессыИЗадачиКлиент.СписокЗадачПередНачаломИзменения(Элемент, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиАвтообновление(Команда)
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения(
			"ЗадачиАвтообновлениеПродолжение",
			ЭтотОбъект);
	
	АвтообновлениеКлиент.УстановитьПараметрыАвтообновленияФормы(
		ЭтаФорма,
		НастройкиАвтообновления,
		ОписаниеОповещения);

	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// АВТООБНОВЛЕНИЕ

&НаКлиенте
Процедура УстановитьАвтообновлениеФормы()
	
	Если ТипЗнч(НастройкиАвтообновления) = Тип("Структура")
		И НастройкиАвтообновления.Автообновление Тогда
		ПодключитьОбработчикОжидания("Автообновление", НастройкиАвтообновления.ПериодАвтоОбновления, Ложь);
	Иначе
		ОтключитьОбработчикОжидания("Автообновление");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Автообновление()
	
	Если ТипЗнч(НастройкиАвтообновления) <> Тип("Структура")
		Или (ТипЗнч(НастройкиАвтообновления) = Тип("Структура")
		И Не НастройкиАвтообновления.Автообновление) Тогда
		ОтключитьОбработчикОжидания("Автообновление");
	Иначе
		ОбновитьСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСервер()

	Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ЗадачиАвтообновлениеПродолжение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		НастройкиАвтообновления = Результат;
		УстановитьАвтообновлениеФормы();
	КонецЕсли;
	
КонецПроцедуры
