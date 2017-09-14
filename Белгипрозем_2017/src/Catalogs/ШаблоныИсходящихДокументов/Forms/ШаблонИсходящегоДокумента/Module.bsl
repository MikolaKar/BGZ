//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьДоступностьЭлементовПоПравуДоступа();
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ПользователиПустаяСсылка = Справочники.Пользователи.ПустаяСсылка();
	
	// Рабочие группы
	РаботаСРабочимиГруппами.ШаблонПриСозданииНаСервере(ЭтаФорма);
	
	НазваниеОрганизации = Константы.НаименованиеПредприятия.Получить();
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
		Элементы.ДекорацияОрганизация.Видимость = Истина;
		Элементы.ДекорацияОрганизация.Заголовок = НазваниеОрганизации;
	Иначе	
		Элементы.ДекорацияОрганизация.Видимость = Ложь;
	КонецЕсли;	

	НесколькоПолучателей = (Объект.Получатели.Количество() > 1);
	Если Не НесколькоПолучателей И Объект.Получатели.Количество() > 0 Тогда 
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Объект.Получатели[0], "Получатель, Адресат, СпособОтправки");
	КонецЕсли;	
	УстановитьВидимостьПолучателей();
	
	Если ЗначениеЗаполнено(Получатель) И ЗначениеЗаполнено(Адресат) Тогда
		ПолучательТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"%1, %2", Получатель, Адресат);
	Иначе
		ПолучательТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"%1", Получатель);
	КонецЕсли;				

	ИспользоватьГрифыДоступа = ПолучитьФункциональнуюОпцию("ИспользоватьГрифыДоступа");
	ИспользоватьВопросыДеятельности = ПолучитьФункциональнуюОпцию("ИспользоватьВопросыДеятельности");
    ВестиУчетПоПроектам = ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам");
	
	// Протоколирование работы пользователей
	ПротоколированиеРаботыПользователей.ЗаписатьОткрытие(Объект.Ссылка);
	
	// Категории данных
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКатегорииДанных") Тогда
		Для Каждого Категория Из Объект.Категории Цикл
			Категория.ПолноеНаименование = РаботаСКатегориямиДанных.ПолучитьПолныйПутьКатегорииДанных(Категория.Значение);
		КонецЦикла;
	Иначе
		Элементы.СтраницаКатегории.Видимость = Ложь;
	КонецЕсли;
	
	ОбновитьВидимостьРеквизитов();
	ОбновитьИконкиУчастниковРабочейГруппыДокумента();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Рабочие группы
	РаботаСРабочимиГруппами.ДокументПриЧтенииНаСервере(ЭтаФорма);
	
	// Формирование исходной рабочей группы
	Участники = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(Объект.Ссылка);
	ИсходнаяРабочаяГруппа.Очистить();
	Для каждого Эл Из Участники Цикл
		
		Строка = ИсходнаяРабочаяГруппа.Добавить();
		Строка.Участник = Эл.Участник; 
		Строка.ОсновнойОбъектАдресации = Эл.ОсновнойОбъектАдресации;
		Строка.ДополнительныйОбъектАдресации = Эл.ДополнительныйОбъектАдресации;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") И ЭтоАдресВременногоХранилища(ВыбранноеЗначение) Тогда
		ЗагрузитьИсполнителейИзВременногоХранилища(ВыбранноеЗначение);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПередЗаписьюКлиент(ПараметрыЗаписи, Отказ);
	ОбщегоНазначенияДокументооборотКлиент.УдалитьПустыеСтрокиТаблицы(Объект.РабочаяГруппаДокумента, "Участник");
	ОбщегоНазначенияДокументооборотКлиент.УдалитьПустыеСтрокиТаблицы(РабочаяГруппаТаблица, "Участник");
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", НЕ ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	
	// Рабочая группа
	РабочаяГруппаТаблицаКоличество = РабочаяГруппаТаблица.Количество();
	Для Инд = 1 По РабочаяГруппаТаблицаКоличество Цикл
		Строка = РабочаяГруппаТаблица[РабочаяГруппаТаблицаКоличество - Инд];
		Если Не ЗначениеЗаполнено(Строка.Участник) Тогда 
			РабочаяГруппаТаблица.Удалить(Строка);
		КонецЕсли;	
	КонецЦикла;
	
	НоваяРабочаяГруппа = РабочаяГруппаТаблица.Выгрузить();
	РабочаяГруппаДобавить = Новый Массив;
	РабочаяГруппаУдалить = Новый Массив;
	
	// Формирование списка удаленных участников рабочей группы
	Для каждого Эл Из ИсходнаяРабочаяГруппа Цикл
		
		Найден = Ложь;
		
		Для каждого Эл2 Из НоваяРабочаяГруппа Цикл
			Если Эл.Участник = Эл2.Участник 
				И Эл.ОсновнойОбъектАдресации = Эл2.ОсновнойОбъектАдресации 
				И Эл.ДополнительныйОбъектАдресации = Эл2.ДополнительныйОбъектАдресации Тогда
				
				Найден = Истина;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		
		Если Не Найден Тогда
			РабочаяГруппаУдалить.Добавить(Новый Структура("Участник, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", 
				Эл.Участник,
				Эл.ОсновнойОбъектАдресации,
				Эл.ДополнительныйОбъектАдресации));
		КонецЕсли;
		
	КонецЦикла;	
	
	// Формирование списка добавленных участников рабочей группы
	Для каждого Эл Из НоваяРабочаяГруппа Цикл
		
		Найден = Ложь;
		
		Для каждого Эл2 Из ИсходнаяРабочаяГруппа Цикл
			Если Эл.Участник = Эл2.Участник 
				И Эл.ОсновнойОбъектАдресации = Эл2.ОсновнойОбъектАдресации 
				И Эл.ДополнительныйОбъектАдресации = Эл2.ДополнительныйОбъектАдресации Тогда
				
				Найден = Истина;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		
		Если Не Найден Тогда
			РабочаяГруппаДобавить.Добавить(Новый Структура("Участник, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", 
				Эл.Участник,
				Эл.ОсновнойОбъектАдресации,
				Эл.ДополнительныйОбъектАдресации));
		КонецЕсли;
		
	КонецЦикла;	
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("РабочаяГруппаУдалить", РабочаяГруппаУдалить);	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("РабочаяГруппаДобавить", РабочаяГруппаДобавить);
	
	ИсходнаяРабочаяГруппа.Загрузить(НоваяРабочаяГруппа);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Протоколирование работы пользователей
	ПротоколированиеРаботыПользователей.ЗаписатьСоздание(Объект.Ссылка, ПараметрыЗаписи.ЭтоНовыйОбъект);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	
	// Категории данных
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКатегорииДанных") Тогда
		Для Каждого Категория Из Объект.Категории Цикл
			Категория.ПолноеНаименование = РаботаСКатегориямиДанных.ПолучитьПолныйПутьКатегорииДанных(Категория.Значение);
		КонецЦикла;
	Иначе
		Элементы.СтраницаКатегории.Видимость = Ложь;
	КонецЕсли;
	
	Для Каждого Строка Из Объект.Получатели Цикл
		Строка.ПолучательЮрЛицо = Делопроизводство.КорреспондентЮрЛицо(Строка.Получатель);
	КонецЦикла;
	
	// Рабочая группа
	РаботаСРабочимиГруппами.ОбъектПослеЗаписиНаСервере(ЭтаФорма, ПараметрыЗаписи);
	ОбновитьВидимостьРеквизитов();
	КоличествоУчастниковРабочейГруппы = РабочаяГруппаТаблица.Количество();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОтветственныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Объект.Ответственный);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	ПриИзмененииВидаДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРеквизитыЗначениеРеквизитаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСШаблонамиДокументовКлиент.ПоказатьФормуВыбораЗначения(ЭтаФорма, Элемент);
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// Работа с номенклатурой дел

&НаКлиенте
Процедура НоменклатураДелНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Корреспонденты = Новый Массив;
	Для Каждого Строка Из Объект.Получатели Цикл
		Корреспонденты.Добавить(Строка.Получатель);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", 			Объект.Организация);
	ПараметрыФормы.Вставить("ВидДокумента", 		Объект.ВидДокумента);
	ПараметрыФормы.Вставить("Корреспондент", 		Корреспонденты);
	ПараметрыФормы.Вставить("ВопросДеятельности", 	Объект.ВопросДеятельности);
	ПараметрыФормы.Вставить("ТекущаяСтрока", 		Объект.НоменклатураДел);
	ПараметрыФормы.Вставить("Подразделение", 		Неопределено);
	
	ОткрытьФорму("Справочник.НоменклатураДел.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураДелАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
		
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораНоменклатурыДел(Текст, Объект.Организация);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураДелОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораНоменклатурыДел(Текст, Объект.Организация);
	КонецЕсли;
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// Работа с получателем

&НаКлиенте
Процедура ПолучательТекстНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;                                                       
	ОткрытьФорму("ОбщаяФорма.ВыборКорреспондентаКонтактноеЛицо", Новый Структура("Получатель, Режим", Получатель, "КорреспондентыИСпискиРассылки"), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательТекстОчистка(Элемент, СтандартнаяОбработка)
		
	Получатель = Неопределено;
	Адресат = Неопределено;
	ПолучательТекст = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательТекстОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Адресат) Тогда
		ПоказатьЗначение(, Адресат);
	ИначеЕсли ЗначениеЗаполнено(Получатель) Тогда
		ПоказатьЗначение(, Получатель);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательТекстОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.СпискиРассылкиПоКорреспондентам") Тогда 
				
		ЗаполнитьИсполнителейПоСпискуРассылки(ВыбранноеЗначение);
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПолучатели;
		Возврат;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		
		Получатель = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ВыбранноеЗначение, "Владелец");
		ПолучательТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"%1, %2", Получатель, ВыбранноеЗначение);		
		Адресат = ВыбранноеЗначение;			
			
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Корреспонденты") Тогда 	
		
		ПолучательТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"%1", ВыбранноеЗначение);
		Получатель = ВыбранноеЗначение;						
		Адресат = Неопределено;	

	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
			
		Если ЗначениеЗаполнено(ВыбранноеЗначение.Корреспондент) И ЗначениеЗаполнено(ВыбранноеЗначение.КонтактноеЛицо) Тогда
			ПолучательТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						"%1, %2", ВыбранноеЗначение.Корреспондент, ВыбранноеЗначение.КонтактноеЛицо);
			Получатель = ВыбранноеЗначение.Корреспондент;			
			Адресат = ВыбранноеЗначение.КонтактноеЛицо;			
		Иначе
			ПолучательТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						"%1", ВыбранноеЗначение.Корреспондент);
			Получатель = ВыбранноеЗначение.Корреспондент;						
			Адресат = Неопределено;	
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательТекстАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
		
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		Текст = СокрЛП(Текст);
		
		Если ЗначениеЗаполнено(Получатель) Тогда
			Если Найти(Текст, СокрЛП(Получатель)+",") > 0 Тогда 
				ТекстПоиска = СокрЛП(Прав(Текст, СтрДлина(Текст)-СтрДлина(СокрЛП(Получатель))-1));
				ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораКонтактногоЛицаПолучателя(ТекстПоиска, Получатель);
			Иначе
				ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораПолучателя(Текст);
			КонецЕсли;	
		Иначе
			ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораПолучателя(Текст);
		КонецЕсли;	
	Иначе
		Получатель = Неопределено;
		Адресат = Неопределено;	
		ПолучательТекст = Неопределено;		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательТекстОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		Текст = СокрЛП(Текст);
		
		Если ЗначениеЗаполнено(Получатель) Тогда
			Если Найти(Текст, СокрЛП(Получатель)+",") > 0 Тогда 
				ТекстПоиска = СокрЛП(Прав(Текст, СтрДлина(Текст)-СтрДлина(СокрЛП(Получатель))-1));
				ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораКонтактногоЛицаПолучателя(ТекстПоиска, Получатель);
			Иначе
				ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораПолучателя(Текст);
			КонецЕсли;	
		Иначе
			ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораПолучателя(Текст);
		КонецЕсли;	
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			СтандартнаяОбработка = Истина;
			ПолучательТекстОбработкаВыбора(Элемент, ДанныеВыбора[0].Значение, Ложь)
		КонецЕсли;	
	Иначе
		Получатель = Неопределено;
		Адресат = Неопределено;	
		ПолучательТекст = Неопределено;	
	КонецЕсли;	
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ПРИКРЕПЛЕННЫЕ ФАЙЛЫ

&НаКлиенте
Процедура ПрикрепленныеФайлыПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепленныеФайлыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ОткрытьФорму("Справочник.Файлы.Форма.ФормаВыбораФайлаВПапках", , Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепленныеФайлыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Строка = Объект.ПрикрепленныеФайлы.Добавить();
	Строка.ФайлСсылка = ВыбранноеЗначение;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепленныеФайлыФайлСсылкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("ТекущаяСтрока", Элемент.Родитель.Родитель.ТекущиеДанные.ФайлСсылка);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПрикрепленныеФайлыСсылкаНачалоВыбораПродолжение",
		ЭтотОбъект,
		Новый Структура("Элемент", Элемент));

	ОткрытьФорму("Справочник.Файлы.Форма.ФормаВыбораФайлаВПапках", ПараметрыФормы,,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепленныеФайлыСсылкаНачалоВыбораПродолжение(Результат, Параметры) Экспорт

	Если ЗначениеЗаполнено(Результат) Тогда
		Элемент = Параметры.Элемент;
		Элемент.Родитель.Родитель.ТекущиеДанные.ФайлСсылка = Результат;
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ПОЛУЧАТЕЛИ

&НаКлиенте
Процедура ПолучателиПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Получатели.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Элементы.ПолучателиАдресат.ТолькоПросмотр = Не ТекущиеДанные.ПолучательЮрЛицо И ЗначениеЗаполнено(ТекущиеДанные.Получатель);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПолучательПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Получатели.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеПолучателя = Делопроизводство.ПолучитьДанныеКорреспондента(ТекущиеДанные.Получатель);
	ТекущиеДанные.ПолучательЮрЛицо = ДанныеПолучателя.КорреспондентЮрЛицо;
	ТекущиеДанные.Адресат = ?(ТекущиеДанные.ПолучательЮрЛицо, ДанныеПолучателя.КонтактноеЛицо, Неопределено);
	
	Элементы.ПолучателиАдресат.ТолькоПросмотр = Не ТекущиеДанные.ПолучательЮрЛицо И ЗначениеЗаполнено(ТекущиеДанные.Получатель);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПолучательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;                                                       
	ОткрытьФорму("ОбщаяФорма.ВыборКорреспондентаКонтактноеЛицо",
		Новый Структура("Получатель, Режим",
			Элементы.Получатели.ТекущиеДанные.Получатель, "КорреспондентыИСпискиРассылки"),
		Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПолучательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.СпискиРассылкиПоКорреспондентам") Тогда 
		СтандартнаяОбработка = Ложь;
		ЭлементКоллекции = Объект.Получатели.НайтиПоИдентификатору(Элементы.Получатели.ТекущаяСтрока);
		ЗаполнитьИсполнителейПоСпискуРассылки(ВыбранноеЗначение, Объект.Получатели.Индекс(ЭлементКоллекции));
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КонтактныеЛица") Тогда 	
		
		ЭлементКоллекции = Объект.Получатели.НайтиПоИдентификатору(Элементы.Получатели.ТекущаяСтрока);
		ЗаполнитьИсполнителя(ВыбранноеЗначение, Объект.Получатели.Индекс(ЭлементКоллекции));
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		ЭлементКоллекции = Объект.Получатели.НайтиПоИдентификатору(Элементы.Получатели.ТекущаяСтрока);
		
		Если ЗначениеЗаполнено(ВыбранноеЗначение.Корреспондент) И ЗначениеЗаполнено(ВыбранноеЗначение.КонтактноеЛицо) Тогда
			ЗаполнитьИсполнителя(ВыбранноеЗначение.КонтактноеЛицо, Объект.Получатели.Индекс(ЭлементКоллекции));
		Иначе
			ЗаполнитьИсполнителя(ВыбранноеЗначение.Корреспондент, Объект.Получатели.Индекс(ЭлементКоллекции));
		КонецЕсли;			
			
	КонецЕсли;	
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ РАБОЧАЯ ГРУППА ДОКУМЕНТА

&НаКлиенте
Процедура РабочаяГруппаДокументаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаПриНачалеРедактирования(
		Элемент, // РабочаяГруппаЭлемент
		НоваяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаДокументаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РаботаСРабочимиГруппамиКлиент.ШаблонРабочаяГруппаПриОкончанииРедактирования(
		ЭтаФорма,
		Объект.РабочаяГруппаДокумента,
		Элементы.РабочаяГруппаДокумента,
		ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РабочаяГруппаДокументаОбработкаВыбораСервер(ВыбранноеЗначение);
	РаботаСРабочимиГруппамиКлиент.ШаблонРабочаяГруппаПриОкончанииРедактирования(
		ЭтаФорма,
		Объект.РабочаяГруппаДокумента,
		Элементы.РабочаяГруппаДокумента,
		Ложь); // ОтменаРедактирования
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаДокументаУчастникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСРабочимиГруппамиКлиент.ШаблонРабочаяГруппаУчастникНачалоВыбора(
		ЭтаФорма,
		Элемент,
		ДанныеВыбора,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаДокументаУчастникАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСРабочимиГруппамиКлиент.ШаблонРабочаяГруппаУчастникАвтоПодбор(
		Элемент,
		Текст,
		ДанныеВыбора,
		Ожидание,
		СтандартнаяОбработка);
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ РАБОЧАЯ ГРУППА ТАБЛИЦА

&НаКлиенте
Процедура РабочаяГруппаТаблицаУчастникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСРабочимиГруппамиКлиент.ДокументРабочаяГруппаУчастникНачалоВыбора(
		ЭтаФорма,
		Элемент,
		ДанныеВыбора,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаУчастникАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСРабочимиГруппамиКлиент.ДокументРабочаяГруппаУчастникАвтоПодбор(
		Элемент,
		Текст,
		ДанныеВыбора,
		Ожидание,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаПередУдалением(Элемент, Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"РабочаяГруппаТаблицаПередУдалениемПродолжение",
		ЭтотОбъект);
	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаТаблицаПередУдалением(ЭтаФорма, Отказ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаПередУдалениемПродолжение(Результат, Параметры) Экспорт
	
	ТаблицаРГ = Элементы.РабочаяГруппаТаблица;
	Для Каждого Индекс Из ТаблицаРГ.ВыделенныеСтроки Цикл
		РабочаяГруппаТаблица.Удалить(ТаблицаРГ.ДанныеСтроки(Индекс));
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаПриНачалеРедактирования(Элемент, НоваяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаПриОкончанииРедактирования(
		ЭтаФорма,
		Элемент,
		ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РабочаяГруппаТаблицаОбработкаВыбораСервер(ВыбранноеЗначение);
	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаПриОкончанииРедактирования(
		ЭтаФорма,
		Элементы.РабочаяГруппаТаблица,
		Ложь);
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ИСПОЛНИТЕЛИ СОГЛАСОВАНИЯ

&НаКлиенте
Процедура ИсполнителиСогласованияИсполнительПриИзменении(Элемент)
	
	ТекущийДанные = Элементы.ИсполнителиСогласования.ТекущиеДанные;

	РаботаСБизнесПроцессамиКлиент.ВыбратьОбъектыАдресацииРоли(
		ТекущийДанные,
		"Исполнитель",
		"ОсновнойОбъектАдресации",
		"ДополнительныйОбъектАдресации",
		ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСогласованияИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьИсполнителя(Элемент,
		Элементы.ИсполнителиСогласования.ТекущиеДанные.Исполнитель,,
		Истина,,,
		Элементы.ИсполнителиСогласования.ТекущиеДанные.ОсновнойОбъектАдресации, 
		Элементы.ИсполнителиСогласования.ТекущиеДанные.ДополнительныйОбъектАдресации);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСогласованияИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		ТекущийДанные = Элементы.ИсполнителиСогласования.ТекущиеДанные;
		ТекущийДанные.Исполнитель = ВыбранноеЗначение.РольИсполнителя;
		ТекущийДанные.ОсновнойОбъектАдресации = ВыбранноеЗначение.ОсновнойОбъектАдресации;
		ТекущийДанные.ДополнительныйОбъектАдресации = ВыбранноеЗначение.ДополнительныйОбъектАдресации;
		ВыбранноеЗначение = ТекущийДанные.Исполнитель;
		Элементы.ИсполнителиСогласования.ЗакончитьРедактированиеСтроки(Ложь);
		Модифицированность = Истина;
	Иначе  
		ТекущийДанные = Элементы.ИсполнителиСогласования.ТекущиеДанные;
		ТекущийДанные.ОсновнойОбъектАдресации = Неопределено;
		ТекущийДанные.ДополнительныйОбъектАдресации = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСогласованияИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСогласованияИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСогласованияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда 
		Элементы.ИсполнителиСогласования.ТекущиеДанные.Исполнитель = ПользователиПустаяСсылка;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодобратьСогласующих(Команда)
	
	АдресВременногоХранилища = ПоместитьИсполнителейВоВременноеХранилище();
	РаботаСПользователямиКлиент.ПодборИсполнителей(АдресВременногоХранилища, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьУчастниковРабочейГруппыДокумента(Команда)
	
	РаботаСРабочимиГруппамиКлиент.ШаблонПодобратьУчастниковРабочейГруппы(
		ЭтаФорма,
		Объект.РабочаяГруппаДокумента,
		Элементы.РабочаяГруппаДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьУчастниковРабочейГруппы(Команда)
	
	РаботаСРабочимиГруппамиКлиент.ДокументПодобратьУчастниковРабочейГруппы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура МногоПолучателей(Команда)
	
	НесколькоПолучателей = Истина;
	
	Объект.Получатели.Очистить();
	Объект.Получатели.Добавить();
	ЗаполнитьЗначенияСвойств(Объект.Получатели[0], ЭтаФорма, "Получатель, Адресат, СпособОтправки");
	
	УстановитьВидимостьПолучателей();
    Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПолучатели;
	
КонецПроцедуры

&НаКлиенте
Процедура ОдинПолучатель(Команда)
	
	НесколькоПолучателей = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОдинПолучательПродолжение",
		ЭтотОбъект);

	Если Объект.Получатели.Количество() > 1 Тогда 
		ТекстВопроса = НСтр("ru = 'Все получатели, кроме первого, будут удалены. 
			|Продолжить?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе 
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.ОК);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОдинПолучательПродолжение(Результат, Параметры)Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Пока Объект.Получатели.Количество() > 1 Цикл
			Объект.Получатели.Удалить(1);
		КонецЦикла;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		НесколькоПолучателей = Истина;
		Возврат;
	КонецЕсли;

	Если Объект.Получатели.Количество() > 0 Тогда 	
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Объект.Получатели[0], "Получатель, Адресат, СпособОтправки");
		
		Если ЗначениеЗаполнено(Получатель) И ЗначениеЗаполнено(Адресат) Тогда
			ПолучательТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"%1, %2", Получатель, Адресат);
		Иначе
			ПолучательТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"%1", Получатель);
		КонецЕсли;
		
		Объект.Получатели.Очистить();
	КонецЕсли;
	
	УстановитьВидимостьПолучателей();
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПрикрепленныеФайлы;
	Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура КатегорииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПодобратьКатегории(Неопределено);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьКатегории(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОткрытьФормуПодбораКатегорийПродолжение",
		ЭтотОбъект,
		Новый Структура);

	РаботаСКатегориямиДанныхКлиент.ОткрытьФормуПодбораКатегорийДляСпискаКатегорий(
		Объект.Категории, ОписаниеОповещения); 
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПодбораКатегорийПродолжение(СписокКатегорийДанных, Параметры)Экспорт 
	
	Модифицированность = Параметры.Модифицированность Или Модифицированность;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПередЗаписьюКлиент(ПараметрыЗаписи, Отказ)
	
	Если Не НесколькоПолучателей Тогда 
		Объект.Получатели.Очистить();
		Объект.Получатели.Добавить();
		ЗаполнитьЗначенияСвойств(Объект.Получатели[0], ЭтаФорма, "Получатель, Адресат, СпособОтправки");
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВидаДокумента()
	
	ОбновитьВидимостьРеквизитов();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьРеквизитов()
	
	// ЕдиницыИзмерения
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("ВидИсходящегоДокумента", Объект.ВидДокумента));
	ПараметрыФункциональныхОпций = ПолучитьПараметрыФункциональныхОпцийФормы();

	// Доп. реквизиты
	СписокДопРеквизитов = РаботаСШаблонамиДокументовСервер.ПолучитьНаборДопРеквизитовДокумента("ИсходящиеДокументы", Объект.ВидДокумента, Объект);
	РаботаСШаблонамиДокументовСервер.ПоместитьДопРеквизитыНаФорму(Объект.ДополнительныеРеквизиты, СписокДопРеквизитов);
	КоличествоСвойств = СписокДопРеквизитов.Количество();
	
	Если КоличествоСвойств > 0 Тогда
		Элементы.СтраницаДопРеквизиты.Видимость = Истина;
	Иначе 
		Элементы.СтраницаДопРеквизиты.Видимость = Ложь;
	КонецЕсли;	

	// Визы согласования
	Элементы.СтраницаСогласующие.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьВизыСогласования");
	Элементы.ДекорацияСрока.Видимость = ПараметрыФункциональныхОпций.ВидИсходящегоДокумента.ИспользоватьСрокИсполнения;	
	Элементы.ЕдиницыИзмерения.Видимость = ПараметрыФункциональныхОпций.ВидИсходящегоДокумента.ИспользоватьСрокИсполнения;	
	
	Если ПараметрыФункциональныхОпций.ВидИсходящегоДокумента.ВестиУчетПоНоменклатуреДел Тогда
		Элементы.ДекорацияХранение.Видимость = Ложь;
		Элементы.ГруппаХранение.ОтображатьЗаголовок = Истина;		
	Иначе
		Элементы.ДекорацияХранение.Видимость = Истина;
		Элементы.ГруппаХранение.ОтображатьЗаголовок = Ложь;		
	КонецЕсли;

	Если ИспользоватьГрифыДоступа
		Или ПараметрыФункциональныхОпций.ВидИсходящегоДокумента.ИспользоватьСрокИсполнения 
		Или ИспользоватьВопросыДеятельности 
		Или ВестиУчетПоПроектам Тогда
		Элементы.ДекорацияРеквизиты.Видимость = Ложь;
		Элементы.ГруппаОбщиеРеквизиты.ОтображатьЗаголовок = Истина;		
	Иначе
		Элементы.ДекорацияРеквизиты.Видимость = Истина;
		Элементы.ГруппаОбщиеРеквизиты.ОтображатьЗаголовок = Ложь;		
	Конецесли;

КонецПроцедуры

&НаСервере
Функция ПоместитьИсполнителейВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ИсполнителиСогласования.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗагрузитьИсполнителейИзВременногоХранилища(АдресВременногоХранилища)
	
	Объект.ИсполнителиСогласования.Загрузить(ПолучитьИзВременногоХранилища(АдресВременногоХранилища));
	
КонецПроцедуры

&НаСервере 
Процедура УстановитьВидимостьПолучателей()
	
	Если НесколькоПолучателей Тогда 
		Элементы.Получатели.Видимость = Истина;
		Элементы.ДекорацияКому.Видимость = Истина;
		Элементы.ГруппаКому.ОтображатьЗаголовок = Ложь;
		Элементы.ПолучательТекст.Видимость = Ложь;
		Элементы.СпособОтправки.Видимость = Ложь;
		Элементы.МногоПолучателей.Видимость = Ложь;
	Иначе
		Элементы.Получатели.Видимость = Ложь;
		Элементы.ДекорацияКому.Видимость = Ложь;
		Элементы.ГруппаКому.ОтображатьЗаголовок = Истина;
		Элементы.ПолучательТекст.Видимость = Истина;
		Элементы.СпособОтправки.Видимость = Истина;
		Элементы.МногоПолучателей.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьИсполнителейПоСпискуРассылки(СписокРассылки, НачальнаяСтрока = Неопределено)
	
	ПолучателиКоличество = СписокРассылки.Получатели.Количество();
	Если ПолучателиКоличество = 0 Тогда 
		Возврат;
	КонецЕсли;	
	
	Для Инд = 0 По ПолучателиКоличество - 1 Цикл
		Если НачальнаяСтрока = Неопределено Тогда 
			НоваяСтрока = Объект.Получатели.Добавить();
		Иначе
			НоваяСтрока = Объект.Получатели.Вставить(НачальнаяСтрока + Инд);
		КонецЕсли;	
		НоваяСтрока.Получатель = СписокРассылки.Получатели[Инд].Получатель;
		НоваяСтрока.Адресат = СписокРассылки.Получатели[Инд].Адресат;
		НоваяСтрока.ПолучательЮрЛицо = Делопроизводство.КорреспондентЮрЛицо(НоваяСтрока.Получатель);
	КонецЦикла;	
	Если НачальнаяСтрока <> Неопределено Тогда 
		Объект.Получатели.Удалить(НачальнаяСтрока + ПолучателиКоличество);
	КонецЕсли;	
	
	Если Не НесколькоПолучателей Тогда 
		
		Если Объект.Получатели.Количество() = 1 Тогда 
			ЗаполнитьЗначенияСвойств(ЭтаФорма, Объект.Получатели[0], "Получатель, ПолучательЮрЛицо, Адресат, ПолученОтвет, Отправлен, ДатаОтправки, СпособОтправки, ВходящийНомер, ВходящаяДата");
		Иначе	
			НесколькоПолучателей = Истина;
			УстановитьВидимостьПолучателей();
		КонецЕсли;
		
	КонецЕсли;	
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИсполнителя(ВыбранноеЗначение, НачальнаяСтрока = Неопределено)
	
	Если НачальнаяСтрока = Неопределено Тогда 
		НоваяСтрока = Объект.Получатели.Добавить();
	Иначе
		НоваяСтрока = Объект.Получатели.Вставить(НачальнаяСтрока);
	КонецЕсли;	
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		НоваяСтрока.Адресат = ВыбранноеЗначение;
		НоваяСтрока.Получатель = ВыбранноеЗначение.Владелец;
	Иначе
		НоваяСтрока.Получатель = ВыбранноеЗначение;						
		НоваяСтрока.Адресат = Неопределено;	
	КонецЕсли;	

	НоваяСтрока.ПолучательЮрЛицо = Делопроизводство.КорреспондентЮрЛицо(НоваяСтрока.Получатель);
	
	Если НачальнаяСтрока <> Неопределено Тогда 
		Объект.Получатели.Удалить(НачальнаяСтрока + 1);
	КонецЕсли;	
	
    Получатель = НоваяСтрока.Получатель;
	Модифицированность = Истина;
	
КонецПроцедуры

// Устанавливает доступность элементов формы при ее открытии в зависимости от
// прав доступа к шаблону.
&НаСервере
Процедура УстановитьДоступностьЭлементовПоПравуДоступа()
	
	Если НЕ Объект.Ссылка.Пустая()
		И НЕ ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка).Изменение Тогда
		
		ТолькоПросмотр = Истина;
		
		Элементы.ГруппаСтраницыШаблона.ТолькоПросмотр = Истина;
		Элементы.Страницы.ТолькоПросмотр = Истина;
		
		Элементы.ФормаЗакрыть.Видимость = Истина;
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
		Элементы.ФормаЗаписатьИЗакрыть.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////////////
// Работа с рабочими группами

&НаСервере
Процедура РабочаяГруппаДокументаОбработкаВыбораСервер(ВыбранноеЗначение)
	
	РаботаСРабочимиГруппами.ШаблонОбработкаВыбора(
		ЭтаФорма,
		ВыбранноеЗначение,
		Объект.РабочаяГруппаДокумента,
		Элементы.РабочаяГруппаДокумента);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИконкиУчастниковРабочейГруппыДокумента()
	
	Для Каждого Строка Из  Объект.РабочаяГруппаДокумента Цикл
		Если ТипЗнч(Строка.Участник) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
			Строка.Иконка = 1;
			Строка.ЭтоРоль = Истина;
		ИначеЕсли ТипЗнч(Строка.Участник) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
			Строка.Иконка = 2;
		ИначеЕсли ТипЗнч(Строка.Участник) = Тип("СправочникСсылка.Пользователи") Тогда
			Строка.Иконка = 3;
		ИначеЕсли ТипЗнч(Строка.Участник) = Тип("Строка") Тогда
			Строка.Иконка = 4;
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура РабочаяГруппаТаблицаОбработкаВыбораСервер(ВыбранноеЗначение)
	
	РаботаСРабочимиГруппами.ДокументОбработкаВыбора(ЭтаФорма, ВыбранноеЗначение);
	
КонецПроцедуры
