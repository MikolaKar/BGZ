&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
    //Если Объект.Ссылка.Пустая() Тогда
    //	Объект.Владелец = Параметры.Корреспондент;	
    //КонецЕсли; 
	
	//КонтактнаяИнформацияОбновлениеИБОбъектаРабот();	
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, Объект, "ГруппаКонтактнаяИнформация");

	// Заполним адрес земельного участка объекта на основании поручения
	Если Объект.Ссылка.Пустая() Тогда
		Если ЗначениеЗаполнено(Параметры.Корреспондент) Тогда
			Объект.Владелец = Параметры.Корреспондент;
			Если Параметры.Свойство("Копирование") Тогда
				Если Параметры.Копирование Тогда
					Объект.Наименование = Параметры.НаименованиеОбъекта;
					Объект.ПолноеНаименование = Параметры.ПолноеНаименование;
				КонецЕсли; 
			КонецЕсли; 
			//Объект.Наименование = Параметры.НаименованиеОбъекта;
			//Объект.ПолноеНаименование = Параметры.НаименованиеОбъекта;
			Объект.ВидОбъекта = Перечисления.мВидыОбъектов.Площадной;
		КонецЕсли; 
			
		Если ЗначениеЗаполнено(Параметры.СтруктураАдресаЗемельногоУчастка) Тогда
			Отбор = Новый Структура("Вид", Справочники.ВидыКонтактнойИнформации.АдресЗемельногоУчасткаОбъектаРабот);
			СтрокаИнфо = ЭтаФорма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
			
			ЗаполнитьЗначенияСвойств(СтрокаИнфо[0], Параметры.СтруктураАдресаЗемельногоУчастка); 
			СтрокаИнфо[0].Вид = Справочники.ВидыКонтактнойИнформации.АдресЗемельногоУчасткаОбъектаРабот;
			АдресЗемельногоУчастка = Параметры.СтруктураАдресаЗемельногоУчастка.Представление;
			Объект.АдресЗемельногоУчастка = АдресЗемельногоУчастка;
			//АдресЗемельногоУчастка = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Поручение, Справочники.ВидыКонтактнойИнформации.АдресЗемельногоУчастка);
			ЭтаФорма[СтрокаИнфо[0].ИмяРеквизита] = АдресЗемельногоУчастка;
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(Параметры.Договор) Тогда
			Объект.Владелец = Параметры.Договор.Корреспондент;
			Поручение = ПолучитьОснованиеДоговора(Параметры.Договор);
			Отбор = Новый Структура("Вид", Справочники.ВидыКонтактнойИнформации.АдресЗемельногоУчасткаОбъектаРабот);
			СтрокаИнфо = ЭтаФорма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
			Если ЗначениеЗаполнено(Поручение) и (СтрокаИнфо.Количество() > 0) Тогда
				Для каждого Стр Из Поручение.КонтактнаяИнформация Цикл
					Если Стр.Вид = Справочники.ВидыКонтактнойИнформации.АдресЗемельногоУчастка Тогда
						ЗаполнитьЗначенияСвойств(СтрокаИнфо[0], Стр);
						//СтрокаИнфо[0].ЗначенияПолей = УправлениеКонтактнойИнформацией.ПреобразоватьСтрокуВСписокПолей(Стр.ЗначенияПолей);
                        СтрокаИнфо[0].Вид = Справочники.ВидыКонтактнойИнформации.АдресЗемельногоУчасткаОбъектаРабот;
						АдресЗемельногоУчастка = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Поручение, Справочники.ВидыКонтактнойИнформации.АдресЗемельногоУчастка);
						ЭтаФорма[СтрокаИнфо[0].ИмяРеквизита] = АдресЗемельногоУчастка;
						Объект.Наименование = "Участок " + СокрЛП(АдресЗемельногоУчастка);
						Объект.ПолноеНаименование = "Участок " + СокрЛП(АдресЗемельногоУчастка);
					КонецЕсли;
				КонецЦикла; 
			КонецЕсли; 
		КонецЕсли;
		
		Если Параметры.Свойство("Родитель") И ЗначениеЗаполнено(Параметры.Родитель) Тогда
			Объект.Родитель = Параметры.Родитель;
		КонецЕсли; 
		
	КонецЕсли; 
КонецПроцедуры

// <Описание процедуры>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура КонтактнаяИнформацияОбновлениеИБОбъектаРабот() Экспорт
	
	// Справочник "Объекты работ"
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.АдресЗемельногоУчасткаОбъектаРабот,
		Перечисления.ТипыКонтактнойИнформации.Адрес,
		НСтр("ru='Адрес земельного участка объекта работ'"),
		Истина, Ложь, Ложь, 1, Истина);
	
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресОбъектаРабот,
		Перечисления.ТипыКонтактнойИнформации.Адрес,
		НСтр("ru='Почтовый адрес объекта работ'"),
		Истина, Ложь, Ложь, 2, Истина);
		
КонецПроцедуры // ()

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Контактная информация"
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ЗаписатьАдресЗемельногоУчастка(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьАдресЗемельногоУчастка(ТекущийОбъект)
	Для каждого Стр Из ТекущийОбъект.КонтактнаяИнформация Цикл
		Если Стр.Вид = Справочники.ВидыКонтактнойИнформации.АдресЗемельногоУчасткаОбъектаРабот Тогда
			ТекущийОбъект.АдресЗемельногоУчастка = Стр.Представление;
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры // ЗаписатьАдресЗемельногоУчастка()

&НаСервере
Процедура ИзменитьКонтактнуюИнформацию()
	
	массРеквизитов = Новый Массив;
	Для Каждого ДопРеквизит Из ЭтаФорма.__КИ_ОписаниеДополнительныхРеквизитов Цикл
		массРеквизитов.Добавить(ДопРеквизит.ИмяРеквизита);
	КонецЦикла;	
	массРеквизитов.Добавить("__КИ_ОписаниеДополнительныхРеквизитов");
	ЭтаФорма.ИзменитьРеквизиты(,массРеквизитов);
	
	Для Каждого ДопРеквизит Из массРеквизитов Цикл
		Элемент = ЭтаФорма.Элементы.Найти(ДопРеквизит);
		Если Элемент <> Неопределено Тогда 
			ЭтаФорма.Элементы.Удалить(Элемент);
		КонецЕсли;	
	КонецЦикла;	
		
	// Обработчик подсистемы "Контактная информация"
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, Объект, "ГруппаКонтактнаяИнформация");
	
КонецПроцедуры	

&НаСервере
Процедура ЗагрузитьКонтактнуюИнформацию()
	
	Объект.КонтактнаяИнформация.Загрузить(Объект.КонтактнаяИнформация.Выгрузить());
	ИзменитьКонтактнуюИнформацию();	
	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ПолучитьОснованиеДоговора(Договор)

	Возврат СвязиДокументов.ПолучитьСвязанныйДокумент(Договор, Справочники.ТипыСвязей.НаОснованииПоручения);

КонецФункции // ПолучитьОснованиеДоговора(Договор)

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)	
	Если Не ЗначениеЗаполнено(Объект.ПолноеНаименование) Тогда
		Объект.ПолноеНаименование = СокрЛП(Элемент.ТекстРедактирования);
	КонецЕсли; 
КонецПроцедуры

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
  УправлениеКонтактнойИнформациейКлиент.ПредставлениеПриИзменении(ЭтаФорма, Элемент);
  
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
  Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеНачалоВыбора(ЭтаФорма, Элемент, , СтандартнаяОбработка);
  ОбновитьКонтактнуюИнформацию(Результат);
  
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
  Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеОчистка(ЭтаФорма, Элемент.Имя);
  ОбновитьКонтактнуюИнформацию(Результат);
  
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
  Результат = УправлениеКонтактнойИнформациейКлиент.ПодключаемаяКоманда(ЭтаФорма, Команда.Имя);
  ОбновитьКонтактнуюИнформацию(Результат);
  УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуВводаАдреса(ЭтаФорма, Результат);
  
КонецПроцедуры

&НаСервере
Функция ОбновитьКонтактнуюИнформацию(Результат = Неопределено)
	
  Возврат УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтаФорма, Объект, Результат);
  
КонецФункции

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
    ОповеститьОЗаписиНового(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПолноеНаименованиеПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда
		Объект.Наименование = СОкрЛП(Объект.ПолноеНаименование);
	КонецЕсли; 
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация
