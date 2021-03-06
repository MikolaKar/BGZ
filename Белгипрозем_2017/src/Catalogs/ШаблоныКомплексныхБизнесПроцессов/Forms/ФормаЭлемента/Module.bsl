
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Протоколирование работы пользователей
	ПротоколированиеРаботыПользователей.ЗаписатьОткрытие(Объект.Ссылка);
	
	УстановитьДоступностьЭлементовПоПравуДоступа();
	
	ИдентификаторЭтапа = Параметры.ИдентификаторЭтапа;
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ВладелецШаблона = Параметры.ВладелецШаблона;
	КонецЕсли;
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	// Рабочие группы
	РаботаСРабочимиГруппами.ШаблонПриСозданииНаСервере(ЭтаФорма);
	
	// Заполнение сроков отложенного старта
	ОтложенныйСтартДни = Цел(Объект.СрокОтложенногоСтарта/86400);
	ОтложенныйСтартЧасы = (Объект.СрокОтложенногоСтарта - ОтложенныйСтартДни * 86400)/3600;
	
	// Инициализация формы механизмом комплексных процессов 
	Если Объект.Ссылка.Пустая() Тогда
		ЗаголовокФормы = НСтр("ru = 'Комплексный процесс (Создание)'");
		Если Не ЗначениеЗаполнено(Объект.ВариантМаршрутизации) Тогда
			Объект.ВариантМаршрутизации = Перечисления.ВариантыМаршрутизацииЗадач.Последовательно;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.Ответственный) Тогда 
			Объект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
	Иначе
		ЗаголовокФормы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Комплексный процесс ""%1""'"), 
			Объект.НаименованиеБизнесПроцесса);
	КонецЕсли;
	РаботаСКомплекснымиБизнесПроцессамиСервер.КарточкаШаблонаБизнесПроцессаПриСозданииНаСервере(
		ЭтаФорма, 
		ЗаголовокФормы);

	Если Объект.Ссылка.Пустая() Тогда
		Если НЕ ЗначениеЗаполнено(Объект.Важность) Тогда
			Объект.Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
		КонецЕсли;
	КонецЕсли;
	
	Копирование = ЗначениеЗаполнено(Параметры.ЗначениеКопирования);
	ИспользоватьВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.ОтложенныйСтартЧасы.Видимость = ИспользоватьВремяВСрокахЗадач;
	Элементы.ДекорацияОтложенныйСтартЧасы.Видимость = ИспользоватьВремяВСрокахЗадач;
	
	Если Объект.ВариантМаршрутизации <> Перечисления.ВариантыМаршрутизацииЗадач.Смешанно Тогда
		Элементы.ЭтапыНастроитьПредшественников.Видимость = Ложь;
		Элементы.ЭтапыКонтекстноеМенюНастроитьПредшественников.Видимость = Ложь;
	КонецЕсли;
	
	РаботаСКомплекснымиБизнесПроцессамиСервер.ЗаполнитьВычисляемыеПоляЭтапов(ЭтаФорма);
	
	// Обработчик подсистемы "Свойства"
	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитов(Объект.Ссылка, ПустойБизнесПроцесс);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ПустойБизнесПроцесс, "ГруппаДополнительныеРеквизиты");
	
	Мультипредметность.ШаблонПриСозданииНаСервере(ЭтаФорма, Объект);
	
	// Заполняем строковое представление участников
	КонтролерСтрокой = РаботаСБизнесПроцессамиКлиентСервер.ПредставлениеУчастникаПроцесса(
		Объект.Контролер,
		Объект.ОсновнойОбъектАдресацииКонтролера,
		Объект.ДополнительныйОбъектАдресацииКонтролера);
		
	// Заполняем параметры участников. Параметры используются в обработчиках соответствующих полей.
	ПараметрыКонтролера =
		РаботаСБизнесПроцессамиКлиентСервер.ПолучитьСтруктуруПараметровУчастника(
			"Контролер",
			"КонтролерСтрокой",
			"ОсновнойОбъектАдресацииКонтролера",
			"ДополнительныйОбъектАдресацииКонтролера");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СозданиеДействия" Тогда
		Если ЭтаФорма = Источник Или Параметр.ВладелецШаблона <> Объект.Ссылка Тогда
			Возврат;
		КонецЕсли;
		ПрименитьНастройкиДействия(Параметр);
		РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.ВычислитьОписаниеПредшественников(Объект);
		Модифицированность = Истина;
		МультипредметностьКлиент.ПредметыШаблонаПриАктивизацииСтроки(ЭтаФорма, Объект);
		СтрокиТочек = ТочкиМаршрута.ПолучитьЭлементы();
		Для Каждого Строка Из СтрокиТочек Цикл
			Элементы.ТочкиМаршрута.Развернуть(Строка.ПолучитьИдентификатор(), Ложь);
		КонецЦикла;
	ИначеЕсли ИмяСобытия = "ВыборШаблонаДействия" Тогда
		Если Объект.Ссылка <> Параметр.ВладелецШаблона Тогда
			Возврат;
		КонецЕсли;
		ПараметрыВозврата = СкопироватьШаблонВНастройкиПроцессаИПолучитьИмяФормы(Параметр.ШаблонБП, Параметр.ВладелецШаблона);
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Ключ", ПараметрыВозврата.Шаблон);
		ПараметрыФормы.Вставить("ВладелецШаблона", Параметр.ВладелецШаблона);
		ПараметрыФормы.Вставить("ИдентификаторЭтапа", Параметр.ИдентификаторЭтапа);
		ПараметрыФормы.Вставить("Предметы", Параметр.Предметы);
		ОткрытьФорму(ПараметрыВозврата.ИмяФормыДляОткрытия, ПараметрыФормы, ЭтаФорма);
	ИначеЕсли ИмяСобытия = "НастройкаПорядкаВыполнения" Тогда
		Если Объект.Ссылка <> Параметр.ВладелецЭтапа Тогда
			Возврат;
		КонецЕсли;
		ДанныеЭтапа = Элементы.Этапы.ТекущиеДанные;
		ДанныеЭтапа.ПредшественникиВариантИспользования = Параметр.ПредшественникиВариантИспользования;
		РаботаСКомплекснымиБизнесПроцессамиКлиент.УстановитьПредшественниковЭтапа(Объект, ДанныеЭтапа.ИдентификаторЭтапа, Параметр.Предшественники);
		РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.ВычислитьОписаниеПредшественников(Объект);
		ПоместитьДлительностьНаФорму();
		Модифицированность = Истина;
	КонецЕсли;
	
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
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПротоколированиеРаботыПользователей.ЗаписатьСоздание(Объект.Ссылка, ПараметрыЗаписи.ЭтоНовыйОбъект);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	Если Объект.ШаблонВКомплексномПроцессе Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Комплексный процесс ""%1""'"), 
			Объект.НаименованиеБизнесПроцесса);
	КонецЕсли;
		
	// Рабочая группа
	РаботаСРабочимиГруппами.ОбъектПослеЗаписиНаСервере(ЭтаФорма, ПараметрыЗаписи);
	
	ПротоколированиеРаботыПользователей.ЗаписатьСоздание(Объект.Ссылка, ПараметрыЗаписи.ЭтоНовыйОбъект);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	
	МультипредметностьКлиентСервер.ЗаполнитьТаблицуПредметовФормы(Объект);
	МультипредметностьКлиентСервер.ЗаполнитьОписаниеПредметовШаблона(Объект);
	
	РаботаСКомплекснымиБизнесПроцессамиСервер.ЗаполнитьВычисляемыеПоляЭтапов(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	РаботаСКомплекснымиБизнесПроцессамиСервер.ЗаполнитьВычисляемыеПоляЭтапов(ЭтаФорма);
	
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
		РеквизитФормыВЗначение("ПустойБизнесПроцесс", Тип("БизнесПроцессОбъект.КомплексныйПроцесс"));
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ПустойБизнесПроцессОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если Объект.ШаблонВКомплексномПроцессе Тогда
		РаботаСКомплекснымиБизнесПроцессамиКлиент.ОповеститьПослеЗаписиНастройкиДействия(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// Заполнение сроков отложенного старта
	Объект.СрокОтложенногоСтарта = (ОтложенныйСтартЧасы * 3600) + (ОтложенныйСтартДни * 86400);
	
	ТекущаяДлительность = Объект.СрокИсполнения * 24 + Объект.СрокИсполненияЧасов;
	Если ЗначениеЗаполнено(ТекущаяДлительность) И ТекущаяДлительность < МаксимальнаяДлительность Тогда
		Текст = НСтр("ru = 'Крайний срок выполнения всех действий превышает указанный срок завершения процесса'");
		ОбщегоНазначенияклиентСервер.СообщитьПользователю(Текст,, "Объект.СрокИсполнения", ,Отказ);							
	КонецЕсли;
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСКомплекснымиБизнесПроцессамиКлиент.ФормаНастройкиДействияПередЗаписью(ЭтаФорма, Отказ);
	
	Если ЭтапыКУдалению.Количество() > 0 Тогда
		УдалитьЭтапы();
		ЭтапыКУдалению.Очистить();
	КонецЕсли;

	РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.ВычислитьОписаниеПредшественников(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЭтапы()
	
	Для Каждого ЭтапКУдалению Из ЭтапыКУдалению Цикл 
		РаботаСКомплекснымиБизнесПроцессамиСервер.УдалитьЭтап(
			ЭтаФорма, 
			ЭтапКУдалению.Значение.ЗадачаЭтапа, 
			ЭтапКУдалению.Значение.ИдентификаторЭтапа);
	КонецЦикла;		
		
	ЭтапыУдалениеСервер();	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтветственныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Объект.Ответственный);
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьПриИзменении(Элемент)
	
	Если Объект.Важность = ПредопределенноеЗначение("Перечисление.ВариантыВажностиЗадачи.Высокая")
		ИЛИ Объект.Важность = ПредопределенноеЗначение("Перечисление.ВариантыВажностиЗадачи.Низкая") Тогда
		УстановитьВажностьВсехЭтапов(Объект.Важность);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВариантМаршрутизацииПриИзменении(Элемент)
	
	ВариантМаршрутизацииПриИзмененииСервер();
	РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.ВычислитьОписаниеПредшественников(Объект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////
// Обработчики поля Контролер

&НаКлиенте
Процедура КонтролерПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.УчастникПриИзменении(Элемент,
		ЭтаФорма, ПараметрыКонтролера);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьИсполнителя(
		Элемент, Объект.Контролер, Истина, Ложь,
		ИспользоватьАвтоподстановки,, Объект.ОсновнойОбъектАдресацииКонтролера,
		Объект.ДополнительныйОбъектАдресацииКонтролера);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерОчистка(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникОчистка(Элемент, СтандартнаяОбработка,
		ЭтаФорма, ПараметрыКонтролера);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерОткрытие(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникОткрытие(Элемент, СтандартнаяОбработка,
		ЭтаФорма, ПараметрыКонтролера);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.
		УчастникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка,
			ЭтаФорма, ПараметрыКонтролера);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.
		УчастникОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка,
			ЭтаФорма, ПараметрыКонтролера);
	
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

#Область ОбработчикиСобытийЭлементовТаблицыФормыЭтапы

&НаКлиенте
Процедура ЭтапыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Поле.Имя <> "ЭтапыПредшественникиЭтапаСтрокой" Тогда
		ИзменитьДействие(Неопределено);
	Иначе
		РаботаСКомплекснымиБизнесПроцессамиКлиент.ОткрытьФормуНастройкиПредшественниковЭтапа(Объект, Элемент.ТекущиеДанные, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИзменитьДействие(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	Если Объект.Ссылка.Пустая() Тогда
		Если НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	РаботаСКомплекснымиБизнесПроцессамиКлиент.ОткрытьФормуВыбораДействияЭтапа(
		Неопределено, 
		ЭтаФорма, 
		Объект.Ссылка, 
		Объект.Предметы);

КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПередУдалением(Элемент, Отказ)
	
 	Отказ = Истина;
	
	ДанныеЭтапа = Элементы.Этапы.ТекущиеДанные;
	Если ДанныеЭтапа = Неопределено Тогда	
		Возврат;
	КонецЕсли;
	
	НаЭтапЕстьСсылки = Ложь;
	Для Каждого Строка Из Объект.ПредшественникиЭтапов Цикл
		Если Строка.ИдентификаторПредшественника = ДанныеЭтапа.ИдентификаторЭтапа Тогда
			НаЭтапЕстьСсылки = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если НаЭтапЕстьСсылки Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Внимание! От данного действия зависит порядок выполнения других действий.
						|Удалить действие ""%1""?'"),
			ДанныеЭтапа.ЗадачаЭтапа);
	Иначе	
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Удалить действие ""%1""?'"),
			ДанныеЭтапа.ЗадачаЭтапа);
	КонецЕсли;
	Режим = Новый СписокЗначений;
	Режим.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Удалить'"));
	Режим.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не удалять'"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЭтапыПередУдалениемПродолжение", ЭтотОбъект, ДанныеЭтапа);
	
	ПоказатьВопрос(ОписаниеОповещения,ТекстВопроса, Режим, 0, КодВозвратаДиалога.Нет);
		
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПередУдалениемПродолжение(Ответ, ДанныеЭтапа) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СтруктураУдаляемогоЭтапа = Новый Структура();
	СтруктураУдаляемогоЭтапа.Вставить("ЗадачаЭтапа", ДанныеЭтапа.ЗадачаЭтапа);
	СтруктураУдаляемогоЭтапа.Вставить("ИдентификаторЭтапа", ДанныеЭтапа.ИдентификаторЭтапа);
	Элементы.Этапы.ТекущиеДанные.Удален = Истина;
	ЭтапыКУдалению.Добавить(СтруктураУдаляемогоЭтапа);
	РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.ВычислитьОписаниеПредшественников(Объект);
	Для Счетчик = 1 по Объект.Этапы.Количество() - 1 Цикл
		Этап = Объект.Этапы[Счетчик]; 
		Если Не ПустаяСтрока(Этап.ПредшественникиЭтапаСтрокой) Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = Объект.ПредшественникиЭтапов.Добавить();
		НоваяСтрока.ИдентификаторПоследователя = Объект.Этапы[Счетчик].ИдентификаторЭтапа;
		
		НовыйПредшественникПодобран = Ложь;
		Для Индекс = 1 по Счетчик Цикл
			ДействительныйИндекс = Счетчик - Индекс;
			Если Не Объект.Этапы[ДействительныйИндекс].Удален Тогда
				НоваяСтрока.ИдентификаторПредшественника = Объект.Этапы[ДействительныйИндекс].ИдентификаторЭтапа;	
				НовыйПредшественникПодобран = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НЕ НовыйПредшественникПодобран Тогда
			НоваяСтрока.ИдентификаторПредшественника = УникальныйИдентификаторПустой();	
		КонецЕсли;
		
		НоваяСтрока.УсловиеРассмотрения = ПредопределенноеЗначение("Перечисление.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения");
	КонецЦикла;
	РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.ВычислитьОписаниеПредшественников(Объект);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПриИзменении(Элемент)
	
	РаботаСКомплекснымиБизнесПроцессамиКлиентСервер.ВычислитьОписаниеПредшественников(Объект);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПриАктивизацииСтроки(Элемент)
	
	ДанныеЭтапа = Элемент.ТекущиеДанные;
	Если ДанныеЭтапа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущийЭтап = ДанныеЭтапа.ИдентификаторЭтапа;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПослеУдаления(Элемент)
	
	ПослеУдаленияДействия();	
	
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

#Область ОбработчикиСобытийЭлементовТаблицыФормыПредметы

&НаКлиенте
Процедура ТочкиМаршрутаПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ИмяКолонки = Элемент.ТекущийЭлемент.Имя;
	
	ТекущаяСтрокаДерева = Элемент.ТекущиеДанные;
	Если ТекущаяСтрокаДерева.Видимость = 2 Тогда 
		ТекущаяСтрокаДерева.Видимость = 0;
	КонецЕсли;
	
	Если Не МультипредметностьКлиентСервер.ЭтоКомплексныйПроцесс(ТекущаяСтрокаДерева.ШаблонБизнесПроцесса) Тогда
		ВложенныеЭлементы = ТекущаяСтрокаДерева.ПолучитьЭлементы();
	
		Если ИмяКолонки = "ТочкиМаршрутаВидимость" И ТекущаяСтрокаДерева.Видимость = Ложь Тогда
			ТекущаяСтрокаДерева.ОбязательноеЗаполнение = Ложь;
		ИначеЕсли ТекущаяСтрокаДерева.ОбязательноеЗаполнение = Истина Тогда
			ТекущаяСтрокаДерева.Видимость = Истина;
		КонецЕсли;
		
		ЗаполняемыйУстановлен = Ложь;
		СуммаВидимость = 0;
		Для Каждого ВложенныйЭлемент Из ВложенныеЭлементы Цикл
			Если ИмяКолонки = "ТочкиМаршрутаВидимость" Тогда
				ВложенныйЭлемент.Видимость = ТекущаяСтрокаДерева.Видимость;
				Если ВложенныйЭлемент.Видимость = Ложь Тогда
					ВложенныйЭлемент.ОбязательноеЗаполнение = Ложь;
				КонецЕсли;
			ИначеЕсли ИмяКолонки = "ТочкиМаршрутаОбязательноеЗаполнение" Тогда
				Если ТекущаяСтрокаДерева.ОбязательноеЗаполнение = Истина Тогда
					Если НЕ ЗаполняемыйУстановлен Тогда
						ВложенныйЭлемент.ОбязательноеЗаполнение = Истина;
						ВложенныйЭлемент.Видимость = Истина;
						ЗаполняемыйУстановлен = Истина;
					Иначе
						ВложенныйЭлемент.ОбязательноеЗаполнение = Ложь;
					КонецЕсли;
				Иначе
					ВложенныйЭлемент.ОбязательноеЗаполнение = Ложь;
				КонецЕсли;
			КонецЕсли;
			СуммаВидимость = СуммаВидимость + ВложенныйЭлемент.Видимость;
		КонецЦикла;
		
		Если СуммаВидимость = ВложенныеЭлементы.Количество() И ВложенныеЭлементы.Количество() > 0 Тогда
			ТекущаяСтрокаДерева.Видимость = Истина;
		ИначеЕсли СуммаВидимость < ВложенныеЭлементы.Количество() И СуммаВидимость > 0 Тогда
			ТекущаяСтрокаДерева.Видимость = 2;
		КонецЕсли;
			
		СтрокаРодитель = ТекущаяСтрокаДерева.ПолучитьРодителя();
		Если ТипЗнч(СтрокаРодитель) = Тип("ДанныеФормыЭлементДерева") Тогда
			СтрокиРодителя = СтрокаРодитель.ПолучитьЭлементы();
			СуммаВидимость = 0;
			СуммаЗаполнение = 0;
			Для Каждого СтрокаРодителя Из СтрокиРодителя Цикл
				СуммаВидимость = СуммаВидимость + СтрокаРодителя.Видимость;
				Если ТекущаяСтрокаДерева.ОбязательноеЗаполнение = Истина И СтрокаРодителя <> ТекущаяСтрокаДерева Тогда
					СтрокаРодителя.ОбязательноеЗаполнение = Ложь;
				КонецЕсли;
				СуммаЗаполнение = СуммаЗаполнение + Число(СтрокаРодителя.ОбязательноеЗаполнение);
			КонецЦикла;
			Если СуммаВидимость = СтрокиРодителя.Количество() Тогда
				СтрокаРодитель.Видимость = Истина;
			ИначеЕсли СуммаВидимость = 0 Тогда
				СтрокаРодитель.Видимость = Ложь;
			Иначе
				СтрокаРодитель.Видимость = 2;
			КонецЕсли;
			Если СуммаЗаполнение = 0 Тогда
				СтрокаРодитель.ОбязательноеЗаполнение = Ложь;
			Иначе
				СтрокаРодитель.ОбязательноеЗаполнение = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеТекущегоПредмета = Элементы.Предметы.ТекущиеДанные;
	Если ДанныеТекущегоПредмета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПредмета = Новый Структура("Предмет, ИмяПредмета, РольПредмета");
	ЗаполнитьЗначенияСвойств(СтруктураПредмета, ДанныеТекущегоПредмета);
	
    МультипредметностьКлиент.УстановитьПредметыЗадачПоТочкамМаршрута(ЭтаФорма, Объект, СтруктураПредмета);
	
КонецПроцедуры

&НаКлиенте
Процедура ТочкиМаршрутаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Поле.Имя = "ТочкиМаршрутаШаблонБизнесПроцесса" Тогда
		СтрокиЭтапа = Объект.Этапы.НайтиСтроки(Новый Структура(
			"ШаблонБизнесПроцесса", Элементы.ТочкиМаршрута.ТекущиеДанные.ШаблонБизнесПроцесса));
		Если СтрокиЭтапа.Количество() > 0 Тогда
			СтандартнаяОбработка = Ложь;
			СтрокаЭтапа = СтрокиЭтапа[0];
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ИдентификаторЭтапа", СтрокаЭтапа.ИдентификаторЭтапа);
			ПараметрыФормы.Вставить("КомплексныйПроцесс", НЕ ЗначениеЗаполнено(СтрокаЭтапа.ИсходныйШаблон));
			ПараметрыФормы.Вставить("Ключ", СтрокаЭтапа.ШаблонБизнесПроцесса);
			ПараметрыФормы.Вставить("ТолькоПросмотр", ЭтаФорма.ТолькоПросмотр);
			
			ИмяФормыДляОткрытия = ПолучитьИмяФормыДляОткрытияДействия(СтрокаЭтапа.ШаблонБизнесПроцесса);
			ОткрытьФорму(ИмяФормыДляОткрытия, ПараметрыФормы);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьДействие(Команда)
	
	Если Элементы.Этапы.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Объект.Ссылка.Пустая() Тогда
		Если Не Записать() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИдентификаторЭтапа", Элементы.Этапы.ТекущиеДанные.ИдентификаторЭтапа);
	ПараметрыФормы.Вставить("КомплексныйПроцесс", НЕ ЗначениеЗаполнено(Элементы.Этапы.ТекущиеДанные.ИсходныйШаблон));
	ПараметрыФормы.Вставить("Ключ", Элементы.Этапы.ТекущиеДанные.ШаблонБизнесПроцесса);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ЭтаФорма.ТолькоПросмотр);
	Если Предметы.Количество() > 0 Тогда
		ПараметрыФормы.Вставить("ПредметыПроцесса", Предметы.ВыгрузитьЗначения());
	КонецЕсли;
	ИмяФормыДляОткрытия = ПолучитьИмяФормыДляОткрытияДействия(Элементы.Этапы.ТекущиеДанные.ШаблонБизнесПроцесса);
	ОткрытьФорму(ИмяФормыДляОткрытия, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПредшественников(Команда)
	
	Если Элементы.Этапы.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ДанныеЭтапа = Элементы.Этапы.ТекущиеДанные;
	РаботаСКомплекснымиБизнесПроцессамиКлиент.ОткрытьФормуНастройкиПредшественниковЭтапа(Объект, ДанныеЭтапа, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьУчастниковРабочейГруппы(Команда)
	
	РаботаСРабочимиГруппамиКлиент.ДокументПодобратьУчастниковРабочейГруппы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыДобавитьВспомогательный(Команда)
	
	МультипредметностьКлиент.ПредметыДобавитьВспомогательный(ЭтаФорма, Объект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыДобавитьЗаполняемый(Команда)
	
	МультипредметностьКлиент.ПредметыДобавитьЗаполняемый(ЭтаФорма, Объект, Ложь);
	
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
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПослеУдаленияДействия()
	
	РаботаСКомплекснымиБизнесПроцессамиСервер.ЗаполнитьВычисляемыеПоляЭтапов(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЭтапыУдалениеСервер()
	
	РаботаСКомплекснымиБизнесПроцессамиСервер.ЗаполнитьВычисляемыеПоляЭтапов(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВажностьВсехЭтапов(ВажностьЭтапов)
	
	Для Каждого Этап Из Объект.Этапы Цикл
		ШаблонОбъект = Этап.ШаблонБизнесПроцесса.ПолучитьОбъект();
		ШаблонОбъект.Важность = ВажностьЭтапов;
		ШаблонОбъект.Записать();
	КонецЦикла;
	РаботаСКомплекснымиБизнесПроцессамиСервер.ЗаполнитьВычисляемыеПоляЭтапов(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройкиДействия(Параметр)
	
	РаботаСКомплекснымиБизнесПроцессамиСервер.ПрименитьНастройкиДействия(ЭтаФорма, Параметр);
	РолиПредметовЭтапов.Загрузить(Мультипредметность.ПолучитьРолиПредметовЭтаповКомплексногоПроцесса(Объект));
	Мультипредметность.ЗаполнитьДеревоТочекПоДействиямПроцесса(ДействияПроцесса, ТочкиМаршрута);
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьДлительностьНаФорму()
	
	РаботаСКомплекснымиБизнесПроцессамиСервер.ПоместитьДлительностьНаФорму(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВариантМаршрутизацииПриИзмененииСервер()
	
	РаботаСКомплекснымиБизнесПроцессамиСервер.ВариантМаршрутизацииПриИзменении(Объект, ЭтапыКУдалению);
	РаботаСКомплекснымиБизнесПроцессамиСервер.ЗаполнитьВычисляемыеПоляЭтапов(ЭтаФорма);
	Если Объект.ВариантМаршрутизации <> Перечисления.ВариантыМаршрутизацииЗадач.Смешанно Тогда
		Элементы.ЭтапыНастроитьПредшественников.Видимость = Ложь;
		Элементы.ЭтапыКонтекстноеМенюНастроитьПредшественников.Видимость = Ложь;
	Иначе
		Элементы.ЭтапыНастроитьПредшественников.Видимость = Истина;
		Элементы.ЭтапыКонтекстноеМенюНастроитьПредшественников.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РабочаяГруппаТаблицаОбработкаВыбораСервер(ВыбранноеЗначение)
	
	РаботаСРабочимиГруппами.ДокументОбработкаВыбора(ЭтаФорма, ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИмяФормыДляОткрытияДействия(Ссылка)
	
	Возврат Ссылка.Метаданные().ПолноеИмя() + ".ФормаОбъекта";
	
КонецФункции

&НаСервере
Функция СкопироватьШаблонВНастройкиПроцессаИПолучитьИмяФормы(ШаблонБП, ВладелецШаблона) 

	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(ВладелецШаблона) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
		//Развернем автоподстановки из шаблона в реальных исполнителей
		ИмяПроцесса = Справочники[ШаблонБП.Метаданные().Имя].ИмяПроцесса(ШаблонБП);
		БизнесПроцессОбъект = БизнесПроцессы[ИмяПроцесса].СоздатьБизнесПроцесс();
		Мультипредметность.ПередатьПредметыПроцессу(БизнесПроцессОбъект, Объект.Предметы);
		БизнесПроцессОбъект.Автор = Объект.Автор;
		БизнесПроцессОбъект.Дата = ТекущаяДатаСеанса();
		БизнесПроцессОбъект.ЗаполнитьПоШаблону(ШаблонБП);
		
		ШаблонДляВставки = БизнесПроцессОбъект.СоздатьШаблонПоПроцессу();
		
		ШаблонДляВставкиОбъект = ШаблонДляВставки.ПолучитьОбъект();
		
	Иначе
		
		ШаблонДляВставкиОбъект = ШаблонБП.Скопировать();
		
	КонецЕсли;
	
	ШаблонДляВставкиОбъект.ИсходныйШаблон = ШаблонБП;
	ШаблонДляВставкиОбъект.ВладелецШаблона = ВладелецШаблона;
	ШаблонДляВставкиОбъект.ШаблонВКомплексномПроцессе = Истина;
	
	Если ВладелецШаблона.Важность = Перечисления.ВариантыВажностиЗадачи.Высокая
		ИЛИ ВладелецШаблона.Важность = Перечисления.ВариантыВажностиЗадачи.Низкая Тогда
		ШаблонДляВставкиОбъект.Важность = ВладелецШаблона.Важность;
	КонецЕсли;

	ШаблонДляВставкиОбъект.Записать();
	ИмяФормыДляОткрытия = ШаблонДляВставкиОбъект.Метаданные().ПолноеИмя() + ".ФормаОбъекта";
	
	ДанныеВозврата = Новый Структура;
	Данныевозврата.Вставить("ИмяФормыДляОткрытия", ИмяФормыДляОткрытия);
	ДанныеВозврата.Вставить("Шаблон", ШаблонДляВставкиОбъект.Ссылка);
	
	Возврат ДанныеВозврата;
	
КонецФункции

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
		
		Элементы.ЭтапыИзменитьДействие.Доступность = Ложь;
		Элементы.ЭтапыКонтекстноеМенюИзменитьДействие.Доступность = Ложь;
		Элементы.ЭтапыНастроитьПредшественников.Доступность = Ложь;
		Элементы.ЭтапыКонтекстноеМенюНастроитьПредшественников.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
