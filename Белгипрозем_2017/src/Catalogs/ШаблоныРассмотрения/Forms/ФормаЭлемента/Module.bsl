
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПротоколированиеРаботыПользователей.ЗаписатьОткрытие(Объект.Ссылка);
	
	УстановитьДоступностьЭлементовПоПравуДоступа();
	
	// Инициализация формы механизмом комплексных процессов 
	Если Объект.Ссылка.Пустая() Тогда
		ЗаголовокФормы = НСтр("ru = 'Рассмотрение (Создание)'");
		Если Не ЗначениеЗаполнено(Объект.Ответственный) Тогда 
			Объект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
	Иначе
		ЗаголовокФормы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Рассмотрение ""%1""'"), 
			Объект.НаименованиеБизнесПроцесса);
	КонецЕсли;
	
	// Рабочие группы
	РаботаСРабочимиГруппами.ШаблонПриСозданииНаСервере(ЭтаФорма);
	
	// Заполнение сроков отложенного старта
	ОтложенныйСтартДни = Цел(Объект.СрокОтложенногоСтарта/86400);
	ОтложенныйСтартЧасы = (Объект.СрокОтложенногоСтарта - ОтложенныйСтартДни * 86400)/3600;
	
	РаботаСКомплекснымиБизнесПроцессамиСервер.КарточкаШаблонаБизнесПроцессаПриСозданииНаСервере(
		ЭтаФорма, 
		ЗаголовокФормы);
	
	// Инициализация учета времени в сроке выполнения
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияЧас.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.Часов.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ОтложенныйСтартЧасы.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДекорацияОтложенныйСтартЧасы.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	
	// Обработчик подсистемы "Свойства"
	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитов(Объект.Ссылка, ПустойБизнесПроцесс);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ПустойБизнесПроцесс, "ГруппаДополнительныеРеквизиты");
	
	// Остальная инициализация
	Если Объект.Ссылка.Пустая() Тогда  
		Если Объект.Исполнитель = Неопределено Тогда 
			Объект.Исполнитель = Справочники.Пользователи.ПустаяСсылка();
		КонецЕсли;	
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
		ЕдиницаТрудозатрат = Константы.ОсновнаяЕдиницаТрудозатрат.Получить();
		ЕдиницаТрудозатратСтр = ВРег(Лев(ЕдиницаТрудозатрат, 1)) + Сред(ЕдиницаТрудозатрат, 2);
		Элементы.ТрудозатратыПланИсполнителя.Заголовок = ЕдиницаТрудозатратСтр;
		Элементы.ТрудозатратыПланАвтора.Заголовок = ЕдиницаТрудозатратСтр;
	КонецЕсли;	
	
	Мультипредметность.ШаблонПриСозданииНаСервере(ЭтаФорма, Объект);
	
	// Заполняем строковое представление участников
	ИсполнительСтрокой = РаботаСБизнесПроцессамиКлиентСервер.ПредставлениеУчастникаПроцесса(
		Объект.Исполнитель,
		Объект.ОсновнойОбъектАдресации,
		Объект.ДополнительныйОбъектАдресации);
	
	// Заполняем параметры участников. Параметры используются в обработчиках соответствующих полей.
	ПараметрыИсполнителя =
		РаботаСБизнесПроцессамиКлиентСервер.ПолучитьСтруктуруПараметровУчастника(
			"Исполнитель",
			"ИсполнительСтрокой",
			"ОсновнойОбъектАдресации",
			"ДополнительныйОбъектАдресации");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// Заполнение сроков отложенного старта
	Объект.СрокОтложенногоСтарта = (ОтложенныйСтартЧасы * 3600) + (ОтложенныйСтартДни * 86400);
	
	РаботаСКомплекснымиБизнесПроцессамиКлиент.ФормаНастройкиДействияПередЗаписью(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", НЕ ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
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
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если Объект.ШаблонВКомплексномПроцессе Тогда
		РаботаСКомплекснымиБизнесПроцессамиКлиент.ОповеститьПослеЗаписиНастройкиДействия(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если Объект.ШаблонВКомплексномПроцессе Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Рассмотрение ""%1""'"), 
			Объект.НаименованиеБизнесПроцесса);
	КонецЕсли;
	ПротоколированиеРаботыПользователей.ЗаписатьСоздание(Объект.Ссылка, ПараметрыЗаписи.ЭтоНовыйОбъект);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	
	// Рабочая группа
	РаботаСРабочимиГруппами.ОбъектПослеЗаписиНаСервере(ЭтаФорма, ПараметрыЗаписи);
	
	МультипредметностьКлиентСервер.ЗаполнитьТаблицуПредметовФормы(Объект);
	МультипредметностьКлиентСервер.ЗаполнитьОписаниеПредметовШаблона(Объект);
	
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
			
	// СтандартныеПодсистемы.Свойства
	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитов(Объект.Ссылка, ПустойБизнесПроцесс);
	ПустойБизнесПроцессОбъект =
		РеквизитФормыВЗначение("ПустойБизнесПроцесс", Тип("БизнесПроцессОбъект.Рассмотрение"));
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ПустойБизнесПроцессОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтветственныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Объект.Ответственный);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Объект.Автор);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////
// Обработчики поля Исполнитель

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.УчастникПриИзменении(Элемент,
		ЭтаФорма, ПараметрыИсполнителя);
		
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИменаПредметовДляФункций = МультипредметностьКлиентСервер.ПолучитьМассивИменПредметовОбъекта(Объект);
	РаботаСПользователямиКлиент.ВыбратьИсполнителя(Элемент, Объект.Исполнитель,,Истина, ИспользоватьАвтоподстановки, ИменаПредметовДляФункций,
		Объект.ОсновнойОбъектАдресации, Объект.ДополнительныйОбъектАдресации);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОчистка(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникОчистка(Элемент, СтандартнаяОбработка,
		ЭтаФорма, ПараметрыИсполнителя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОткрытие(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникОткрытие(Элемент, СтандартнаяОбработка,
		ЭтаФорма, ПараметрыИсполнителя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.
		УчастникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка,
			ЭтаФорма, ПараметрыИсполнителя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.
		УчастникОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка,
			ЭтаФорма, ПараметрыИсполнителя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРабочаяГруппа

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
Процедура РабочаяГруппаТаблицаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РабочаяГруппаТаблицаОбработкаВыбораСервер(ВыбранноеЗначение);
	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаПриОкончанииРедактирования(
		ЭтаФорма,
		Элементы.РабочаяГруппаТаблица,
		Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПредметы

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	МультипредметностьКлиент.ПредметыШаблонаИзменитьПредмет(ЭтаФорма, Объект, ВыбраннаяСтрока, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	МультипредметностьКлиент.ПредметыШаблонаПередНачаломДобавления(ЭтаФорма, Объект, Отказ, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередУдалением(Элемент, Отказ)
	
	МультипредметностьКлиент.ПредметыПередУдалением(ЭтаФорма, Объект, Отказ, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПослеУдаления(Элемент)
	
	МультипредметностьКлиентСервер.УстановитьДоступностьКнопокУправленияПредметами(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПриАктивизацииСтроки(Элемент)
	
	МультипредметностьКлиент.ПредметыШаблонаПриАктивизацииСтроки(ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ВыбраннаяСтрока = Элементы.Предметы.ТекущаяСтрока;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		МультипредметностьКлиент.ПредметыШаблонаИзменитьПредмет(ЭтаФорма, Объект, ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТочкиМаршрута

&НаКлиенте
Процедура ТочкиМаршрутаПриИзменении(Элемент)
	
	МультипредметностьКлиент.ТочкиМаршрутаПриИзменении(ЭтаФорма, Объект, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПредметыДобавитьВспомогательный(Команда)
	
	МультипредметностьКлиент.ПредметыДобавитьВспомогательный(ЭтаФорма, Объект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыДобавитьОсновной(Команда)
	
	МультипредметностьКлиент.ПредметыДобавитьОсновной(ЭтаФорма, Объект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыИзменитьПредмет(Команда)
	
	ВыбраннаяСтрока = Элементы.Предметы.ТекущаяСтрока;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		МультипредметностьКлиент.ПредметыШаблонаИзменитьПредмет(ЭтаФорма, Объект, ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыИзменитьРоль(Команда)
	
	ВыбраннаяСтрока = Элементы.Предметы.ТекущаяСтрока;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		МультипредметностьКлиент.ИзменитьРольПредмета(ЭтаФорма, Объект, ВыбраннаяСтрока, Ложь);
		МультипредметностьКлиент.ПредметыШаблонаПриАктивизацииСтроки(ЭтаФорма, Объект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьУчастниковРабочейГруппы(Команда)
	
	РаботаСРабочимиГруппамиКлиент.ДокументПодобратьУчастниковРабочейГруппы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура РабочаяГруппаТаблицаОбработкаВыбораСервер(ВыбранноеЗначение)
	
	РаботаСРабочимиГруппами.ДокументОбработкаВыбора(ЭтаФорма, ВыбранноеЗначение);
	
КонецПроцедуры

// Устанавливает доступность элементов формы при ее открытии в зависимости от
// прав доступа к шаблону.
//
&НаСервере
Процедура УстановитьДоступностьЭлементовПоПравуДоступа()
	
	Если НЕ Объект.Ссылка.Пустая()
		И НЕ ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка).Изменение Тогда
		
		ТолькоПросмотр = Истина;
		
		Элементы.РабочаяГруппаТаблица.ТолькоПросмотр = Истина;
		Элементы.ТочкиМаршрута.ТолькоПросмотр = Истина;
		
		Элементы.ФормаЗакрытьФорму.Видимость = Истина;
		Элементы.ФормаЗакрытьФорму.КнопкаПоУмолчанию = Истина;
		Элементы.ФормаЗаписатьИЗакрыть.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
