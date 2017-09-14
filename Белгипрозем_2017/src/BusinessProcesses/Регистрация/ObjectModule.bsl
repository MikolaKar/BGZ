#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	 
Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = ТекущаяДатаСеанса();
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	ДатаНачала = '00010101';
	ДатаЗавершения = '00010101';
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт 
	
	Если ЭтоНовый() Тогда 
		Дата = ТекущаяДатаСеанса();
		Если Не ЗначениеЗаполнено(Автор) Тогда
			Автор = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
		Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
		
		Если Не ЗначениеЗаполнено(Проект) Тогда 
			Проект = РаботаСПроектами.ПолучитьПроектПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ДанныеЗаполнения, Ложь, Истина);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ЗадачаСсылка = ДанныеЗаполнения;
		ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Шаблон") Тогда
			Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ДанныеЗаполнения.Шаблон, ЭтотОбъект);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Предметы") Тогда
			Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ДанныеЗаполнения.Предметы, Ложь, Истина);
			Проект = МультипредметностьПереопределяемый.ПолучитьОсновнойПроектПоПредметам(ДанныеЗаполнения.Предметы);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("АвторСобытия") Тогда
			Автор = ДанныеЗаполнения.АвторСобытия;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Шаблон") Тогда
			ЗаполнитьПоШаблону(ДанныеЗаполнения.Шаблон);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ЗадачаИсполнителя") Тогда
			ЗадачаСсылка = ДанныеЗаполнения.ЗадачаИсполнителя;
			ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ПроектнаяЗадача") Тогда
			ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения.ПроектнаяЗадача);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Проект") Тогда
			Проект = ДанныеЗаполнения.Проект;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Исполнители") Тогда
			Исполнитель = ДанныеЗаполнения.Исполнители[0];
		КонецЕсли;
		
		ТипыПисем = МультипредметностьПереопределяемый.ПолучитьТипыПисем();
		ОсновныеПисьма = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект, ТипыПисем, Истина);
		Для Каждого Письмо Из ОсновныеПисьма Цикл
			Тема = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Письмо, "Тема");
			Проект = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Письмо, "Проект");
			Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Зарегистрировать ""%1""'"),
				Тема);
			Прервать;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
		
		ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения);
		
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(ДанныеЗаполнения) Тогда
		
		Предмет = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ДанныеЗаполнения, "Предмет");
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
	    МультипредметностьКлиентСервер.ЗаполнитьНаименованиеПроцесса(ЭтотОбъект, НСтр("ru = 'Зарегистрировать'"));
	КонецЕсли;
	
	ТипыДокументов = МультипредметностьКлиентСервер.ПолучитьТипыДокументов();
	ПредметыДляПроверки = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект, ТипыДокументов, Истина);
	Для Каждого Предмет Из ПредметыДляПроверки Цикл   
		Если ЗначениеЗаполнено(Предмет.РегистрационныйНомер) Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Документ ""%1"" уже зарегистрирован!'"), Строка(Предмет));
				
			#Если НЕ ВнешнееСоединение Тогда				
			Если ОбработкаЗапросовXDTO.ЭтоВебСервис() Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			КонецЕсли;
			#КонецЕсли
			
			ВызватьИсключение ТекстОшибки;
				
		КонецЕсли;	 
	КонецЦикла;
	
	БизнесПроцессыИЗадачиСервер.ЗаполнитьГлавнуюЗадачу(ЭтотОбъект, ДанныеЗаполнения);	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(Исполнитель) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Поле ""Кому"" не заполнено", ЭтотОбъект,,"ИсполнительСтрокой", Отказ);
	КонецЕсли;
	
	Мультипредметность.ПроверитьКорректностьТиповОсновныхПредметов(ЭтотОбъект, Отказ);
	
	ТипыДокументов = МультипредметностьКлиентСервер.ПолучитьТипыДокументов();
	
	ПредметыДляПроверки = Мультипредметность.ПредметыДляДействийПроцесса(ЭтотОбъект, ТипыДокументов, Истина);
	
	ЗарегистрированныеПредметыПроцесса = Новый Массив;
	Если НЕ ЭтотОбъект.Ссылка.Пустая() Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Процесс", ЭтотОбъект.Ссылка);
		Запрос.УстановитьПараметр("ТочкаМаршрута", БизнесПроцессы.Регистрация.ТочкиМаршрута.Зарегистрировать);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПредметыЗадач.Предмет
		|ИЗ
		|	Задача.ЗадачаИсполнителя.Предметы КАК ПредметыЗадач
		|ГДЕ
		|	ПредметыЗадач.РольПредмета = ЗНАЧЕНИЕ(Перечисление.РолиПредметов.Основной)
		|	И ПредметыЗадач.Ссылка.Выполнена
		|	И ПредметыЗадач.Ссылка.БизнесПроцесс = &Процесс
		|	И ПредметыЗадач.Ссылка.ТочкаМаршрута = &ТочкаМаршрута";
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда
			ЗарегистрированныеПредметыПроцесса = Результат.Выгрузить().ВыгрузитьКолонку("Предмет");
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Предмет Из ПредметыДляПроверки Цикл
		Если ЗарегистрированныеПредметыПроцесса.Найти(Предмет) = Неопределено Тогда
			Если ЗначениеЗаполнено(Предмет.РегистрационныйНомер) Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Документ ""%1"" уже зарегистрирован!'"),
					Строка(Предмет));
				ИндексСтроки = Формат(Предметы.Найти(Предмет).НомерСтроки,"ЧН=0; ЧГ=0");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"Объект.Предметы["+ ИндексСтроки +"].Предмет",,
					Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Проверка прав доступа участников процесса на предмет
	Если МультипредметностьПереопределяемый.ПроверятьПраваУчастниковБизнесПроцессаНаПредметы(ЭтотОбъект) Тогда
		
		ВнешняяТранзакция = ТранзакцияАктивна();
		
		Если Не ВнешняяТранзакция Тогда
			НачатьТранзакцию();
		КонецЕсли;
		
		РаботаСРабочимиГруппами.ПерезаписатьРабочиеГруппыПредметовБизнесПроцесса(ЭтотОбъект, ПредметыДляПроверки);
		
		// Проверка прав на предмет
		Если ПредметыДляПроверки.Количество() > 0 Тогда
			МультипредметностьПереопределяемый.ПроверитьПраваУчастниковБизнесПроцессаНаПредметы(
				ЭтотОбъект, ПредметыДляПроверки, Отказ);
		КонецЕсли;
		
		// Отмена транзакции, в рамках которой была создана рабочая группа для 
		// проверки прав
		Если Не ВнешняяТранзакция Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Обработка выполнения задачи
	Если ДополнительныеСвойства.Свойство("ТекущаяЗадача") Тогда
		Если ДополнительныеСвойства.ТекущаяЗадача.ТочкаМаршрута =
				БизнесПроцессы.Регистрация.ТочкиМаршрута.Зарегистрировать Тогда
				
			НайденнаяСтрока = РезультатыРегистрации.Найти(
				ДополнительныеСвойства.ТекущаяЗадача,
				"ЗадачаИсполнителя");
			
			Если НайденнаяСтрока <> Неопределено Тогда
				НайденнаяСтрока.РезультатРегистрации = ДополнительныеСвойства.РезультатРегистрации;
			Иначе
				ТекстОшибки =
					НСтр("ru = 'Не найдена строка результата для текущего цикла регистрации.'");
				ВызватьИсключение ТекстОшибки;
			КонецЕсли;
			
		ИначеЕсли ДополнительныеСвойства.ТекущаяЗадача.ТочкаМаршрута =
				БизнесПроцессы.Регистрация.ТочкиМаршрута.Ознакомиться Тогда
				
			ПовторитьРегистрацию = ДополнительныеСвойства.ПовторитьРегистрацию;
			НайденнаяСтрока = РезультатыОзнакомлений.Найти(
				ДополнительныеСвойства.ТекущаяЗадача,
				"ЗадачаИсполнителя");
			НайденнаяСтрока.ОтправленоНаПовторнуюРегистрацию = ДополнительныеСвойства.ПовторитьРегистрацию;
		КонецЕсли;
	КонецЕсли;
	
	Если Не РаботаСБизнесПроцессами.ПроверитьПередЗаписью(ЭтотОбъект) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если Не Ссылка.Пустая() Тогда
		ПредыдущаяПометкаУдаления = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ПометкаУдаления");
	КонецЕсли;
	ДополнительныеСвойства.Вставить("ПредыдущаяПометкаУдаления", ПредыдущаяПометкаУдаления);
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Ссылка, ПометкаУдаления);
		
		ПредметыДляУстановки = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект,, Истина);
		Если ПометкаУдаления Тогда 
			Для Каждого Предмет Из ПредметыДляУстановки Цикл
				ПриОткрепленииПредмета(Предмет);
			КонецЦикла;
		Иначе
			ВосстановитьСостояниеПредметов();
		КонецЕсли;
	КонецЕсли;
	
	ПредыдущееСостояние = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Состояние");
	Если Состояние = Перечисления.СостоянияБизнесПроцессов.Прерван
		И Состояние <> ПредыдущееСостояние Тогда
		КомпенсироватьСостояниеПредметов();
	КонецЕсли;
	
	// Обработка рабочей группы	
	РаботаСБизнесПроцессами.СформироватьРабочуюГруппу(ЭтотОбъект);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элементов карты маршрута

Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаНачала = ТекущаяДатаСеанса();
	
	РаботаСПроектами.ОтметитьНачалоВыполненияПроектнойЗадачи(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПодготовкаОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	ЗаписатьСостояниеПредметов(, Перечисления.СостоянияДокументов.НаРегистрации);
	
	НомерИтерации = НомерИтерации + 1;
	ПовторитьУтверждение = Ложь;
	Записать();
	
КонецПроцедуры

Процедура ЗарегистрироватьПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
	
	ЗадачаСсылка = Задачи.ЗадачаИсполнителя.ПолучитьСсылку();
	Задача.УстановитьСсылкуНового(ЗадачаСсылка);
	
	Задача.Дата  	= ТекущаяДатаСеанса();
	Задача.Автор 	= Автор;
	Задача.Описание = Описание;
	Задача.Важность = Важность;
	
	Мультипредметность.ЗадачаПередСозданием(ЭтотОбъект, Задача, ТочкаМаршрутаБизнесПроцесса);
	
	Задача.Наименование   = Наименование;
	Задача.СрокИсполнения = СрокИсполнения;
	Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
	Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
	
	Задача.Проект = Проект;
	Задача.ПроектнаяЗадача = ПроектнаяЗадача;
	
	Если ТипЗнч(Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
		Задача.Исполнитель = Исполнитель;
	Иначе
		Задача.РольИсполнителя = Исполнитель;
		Задача.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
		Задача.ДополнительныйОбъектАдресации = ДополнительныйОбъектАдресации;
	КонецЕсли;
	
	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитов(Задача.БизнесПроцесс, Задача);
	ФормируемыеЗадачи.Добавить(Задача);
	
	УстановитьПривилегированныйРежим(Истина);
	НоваяСтрока = РезультатыРегистрации.Добавить();
	НоваяСтрока.НомерИтерации 	  = НомерИтерации;
	НоваяСтрока.ЗадачаИсполнителя = ЗадачаСсылка;
	Записать();
	
КонецПроцедуры

Процедура ОбработкаРезультатаОбработка(ТочкаМаршрутаБизнесПроцесса)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПовторитьРегистрацию = Ложь;
	
	// результат регистрации
	РезультатРегистрации = Перечисления.РезультатыРегистрации.Зарегистрировано;
	Для Каждого Элемент Из РезультатыРегистрации Цикл
		Если Элемент.НомерИтерации = НомерИтерации Тогда
			
			Если Элемент.РезультатРегистрации = Перечисления.РезультатыРегистрации.НеЗарегистрировано Тогда 
				РезультатРегистрации = Перечисления.РезультатыРегистрации.НеЗарегистрировано;
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Если РезультатРегистрации = Перечисления.РезультатыРегистрации.НеЗарегистрировано Тогда
		ЗаписатьСостояниеПредметов(, Перечисления.СостоянияДокументов.НеЗарегистрирован);
	КонецЕсли;
	
	Записать();
	
КонецПроцедуры

Процедура ОзнакомитьсяПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// для вложенного бп
	Если РезультатРегистрации <> Перечисления.РезультатыРегистрации.НеЗарегистрировано
		И ЗначениеЗаполнено(ВедущаяЗадача) Тогда
		
		БизнесПроцессВедущейЗадачи =
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВедущаяЗадача, "БизнесПроцесс");
			
		Если ТипЗнч(БизнесПроцессВедущейЗадачи) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
	ЗаполнитьЗадачуОзнакомиться(Задача);
	
	ЗадачаСсылка = Задачи.ЗадачаИсполнителя.ПолучитьСсылку();
	Задача.УстановитьСсылкуНового(ЗадачаСсылка);
	
	ФормируемыеЗадачи.Добавить(Задача);
	
	УстановитьПривилегированныйРежим(Истина);
	НоваяСтрока = РезультатыОзнакомлений.Добавить();
	НоваяСтрока.НомерИтерации 	  = НомерИтерации;
	НоваяСтрока.ЗадачаИсполнителя = ЗадачаСсылка;
	Записать();
	
КонецПроцедуры

Процедура ПовторитьРегистрациюПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = ПовторитьРегистрацию;
	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	ДатаЗавершения = ТекущаяДатаСеанса();
	
	РаботаСПроектами.ОтметитьОкончаниеВыполненияПроектнойЗадачи(ЭтотОбъект);
	
	Если РезультатРегистрации <> Перечисления.РезультатыРегистрации.НеЗарегистрировано
		И ЗначениеЗаполнено(ВедущаяЗадача) Тогда
		
		БизнесПроцессВедущейЗадачи =
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВедущаяЗадача, "БизнесПроцесс");
			
		Если ТипЗнч(БизнесПроцессВедущейЗадачи) <> Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
			Возврат;
		КонецЕсли;
		
		Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
		ЗаполнитьЗадачуОзнакомиться(Задача);
		Задача.Записать();
		
		НоваяСтрока = РезультатыОзнакомлений.Добавить();
		НоваяСтрока.НомерИтерации 	  = НомерИтерации;
		НоваяСтрока.ЗадачаИсполнителя = Задача.Ссылка;
		Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры

Процедура ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка)
	
	Мультипредметность.ЗаполнитьПредметыПроцессаПоЗадаче(ЭтотОбъект, ЗадачаСсылка);
	
	Проект = ЗадачаСсылка.Проект;
	ПроектнаяЗадача = ЗадачаСсылка.ПроектнаяЗадача;
	
	Если ЗадачаСсылка.ТочкаМаршрута = БизнесПроцессы.Утверждение.ТочкиМаршрута.Ознакомиться 
	 Или ЗадачаСсылка.ТочкаМаршрута = БизнесПроцессы.Согласование.ТочкиМаршрута.Ознакомиться Тогда 
		Важность = ЗадачаСсылка.БизнесПроцесс.Важность;
		СрокИсполнения = ТекущаяДатаСеанса();
	КонецЕсли;
	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитов(ЗадачаСсылка, ЭтотОбъект);
	
КонецПроцедуры

// Обновляет значения реквизитов невыполненных задач 
// при изменении реквизитов бизнес-процесса.
//
Процедура ИзменитьРеквизитыНевыполненныхЗадач(СтарыеУчастникиПроцесса, ПараметрыЗаписи) Экспорт 

	УстановитьПривилегированныйРежим(Истина);
	
	СтарыйИсполнитель = СтарыеУчастникиПроцесса.Исполнитель;
	СтарыйОсновнойОбъектАдресации = СтарыеУчастникиПроцесса.ОсновнойОбъектАдресации;
	СтарыйДополнительныйОбъектАдресации = СтарыеУчастникиПроцесса.ДополнительныйОбъектАдресации;
	
	ИзмененИсполнитель = СтарыйИсполнитель <> Исполнитель
		ИЛИ СтарыйОсновнойОбъектАдресации <> ОсновнойОбъектАдресации
		ИЛИ СтарыйДополнительныйОбъектАдресации <> ДополнительныйОбъектАдресации;
	
	НачатьТранзакцию();
	Попытка
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Задачи.Ссылка
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК Задачи
		|ГДЕ
		|	Задачи.БизнесПроцесс = &БизнесПроцесс
		|	И Задачи.ПометкаУдаления = ЛОЖЬ
		|	И Задачи.Выполнена = ЛОЖЬ";
		
		Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
		Результат = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			ЗаблокироватьДанныеДляРедактирования(ЗадачаОбъект.Ссылка);
			ЗадачаОбъект.Важность = Важность;
			ЗадачаОбъект.СрокИсполнения = СрокИсполнения;
			ЗадачаОбъект.Наименование = Наименование;
			ЗадачаОбъект.Автор = Автор;
			
			ЗадачаОбъект.Проект = Проект;
			ЗадачаОбъект.ПроектнаяЗадача = ПроектнаяЗадача;
			
			// исполнитель
			Если ИзмененИсполнитель Тогда
				
				Если ЗадачаОбъект.ПринятаКИсполнению Тогда
					ЗадачаОбъект.ПринятаКИсполнению = Ложь;
					ЗадачаОбъект.ДатаПринятияКИсполнению = '00010101';
				КонецЕсли;
				
				Если ТипЗнч(Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда 
					ЗадачаОбъект.Исполнитель = Исполнитель;
					ЗадачаОбъект.РольИсполнителя = Неопределено;
					ЗадачаОбъект.ОсновнойОбъектАдресации = Неопределено;
					ЗадачаОбъект.ДополнительныйОбъектАдресации = Неопределено;
				Иначе
					ЗадачаОбъект.Исполнитель = Неопределено;
					ЗадачаОбъект.РольИсполнителя = Исполнитель;
					ЗадачаОбъект.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
					ЗадачаОбъект.ДополнительныйОбъектАдресации = ДополнительныйОбъектАдресации;
				КонецЕсли;
			КонецЕсли;
			
			Если ПараметрыЗаписи.Свойство("ПереносСрока") 
				И ПараметрыЗаписи.ПереносСрока Тогда
				Если ТипЗнч(ПараметрыЗаписи.Предмет) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя")
					И ПараметрыЗаписи.Предмет = ЗадачаОбъект.БизнесПроцесс Тогда
					ПараметрыЗаписи.СтарыйСрок = ЗадачаОбъект.Ссылка.СрокИсполнения;
					ПараметрыЗаписи.НовыйСрок = ЗадачаОбъект.СрокИсполнения;
				КонецЕсли;
				ПереносСроковВыполненияЗадач.СделатьЗаписьОПереносеСрока(ЗадачаОбъект, ПараметрыЗаписи);
			КонецЕсли;
			ЗадачаОбъект.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры 

// Заполняет бизнес-процесс на основании шаблона бизнес-процесса.
//
// Параметры
//  ШаблонБизнесПроцесса  - шаблон бизнес-процесса
//
Процедура ЗаполнитьПоШаблону(ШаблонБизнесПроцесса) Экспорт
	
	Если ШаблонБизнесПроцесса.ШаблонВКомплексномПроцессе 
		И ЗначениеЗаполнено(ШаблонБизнесПроцесса.ИсходныйШаблон) Тогда
		Шаблон = ШаблонБизнесПроцесса.ИсходныйШаблон;
	ИначеЕсли НЕ ШаблонБизнесПроцесса.ШаблонВКомплексномПроцессе Тогда
		Шаблон = ШаблонБизнесПроцесса;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.НаименованиеБизнесПроцесса) Тогда 
		Наименование = ШаблонБизнесПроцесса.НаименованиеБизнесПроцесса;
		НаименованиеСПредметами = МультипредметностьКлиентСервер.ПолучитьНаименованиеСПредметами(СокрЛП(Наименование), Предметы);
		Если ЗначениеЗаполнено(НаименованиеСПредметами) И ШаблонБизнесПроцесса.ДобавлятьНаименованиеПредмета Тогда
			Наименование = НаименованиеСПредметами;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.Описание) Тогда 
		Описание = ШаблонБизнесПроцесса.Описание;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.Важность) Тогда 
		Важность = ШаблонБизнесПроцесса.Важность;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.Автор) Тогда 
		Автор = ШаблонБизнесПроцесса.Автор;
	КонецЕсли;
	
	// заполнение исполнителей
	Если ТипЗнч(ШаблонБизнесПроцесса.Исполнитель) = Тип("Строка") И ЗначениеЗаполнено(ШаблонБизнесПроцесса.Исполнитель) Тогда 
		АвтоподстановкаИсполнитель = ШаблоныБизнесПроцессов.ПолучитьЗначениеАвтоподстановки(ШаблонБизнесПроцесса.Исполнитель, ЭтотОбъект);
		
		Если ТипЗнч(АвтоподстановкаИсполнитель) = Тип("СправочникСсылка.Пользователи")
			Или ТипЗнч(АвтоподстановкаИсполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда 
			
			Исполнитель = АвтоподстановкаИсполнитель;
			
		ИначеЕсли ТипЗнч(АвтоподстановкаИсполнитель) = Тип("Структура") Тогда 
			
			Исполнитель = АвтоподстановкаИсполнитель.РольИсполнителя;
			ОсновнойОбъектАдресации = АвтоподстановкаИсполнитель.ОсновнойОбъектАдресации;
			ДополнительныйОбъектАдресации = АвтоподстановкаИсполнитель.ДополнительныйОбъектАдресации;	
			
		ИначеЕсли ТипЗнч(АвтоподстановкаИсполнитель) = Тип("Массив") Тогда 	
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Автоподстановка ""%1"" не может применяться для поля ""%2"", так как возвращает массив исполнителей'"),
				ШаблонБизнесПроцесса.Исполнитель,
				НСтр("ru = 'Исполнитель'"));
			ВызватьИсключение ТекстСообщения;
			
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ШаблонБизнесПроцесса.Исполнитель) Тогда 
		Исполнитель = ШаблонБизнесПроцесса.Исполнитель;
		ОсновнойОбъектАдресации = ШаблонБизнесПроцесса.ОсновнойОбъектАдресации;
		ДополнительныйОбъектАдресации = ШаблонБизнесПроцесса.ДополнительныйОбъектАдресации;
	КонецЕсли;	
	
	// срок исполнения
	Если ТипЗнч(Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
		ГрафикРаботы = ГрафикиРаботы.ПолучитьГрафикРаботыПользователя(Исполнитель);
	Иначе	
		ГрафикРаботы = ГрафикиРаботы.ПолучитьОсновнойГрафикРаботы();
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач") Тогда 
		Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.СрокИсполнения) 
		 Или ЗначениеЗаполнено(ШаблонБизнесПроцесса.СрокИсполненияЧас) Тогда 
			Если ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы") Тогда 
				СрокИсполнения = ГрафикиРаботы.ПолучитьДатуОкончанияПериода(
					ГрафикРаботы,
					Дата + ?(ШаблонБизнесПроцесса.ШаблонВКомплексномПроцессе, ШаблонБизнесПроцесса.СрокОтложенногоСтарта, 0),
					ШаблонБизнесПроцесса.СрокИсполнения,
					ШаблонБизнесПроцесса.СрокИсполненияЧас);
			Иначе
				СрокИсполнения = 
					Дата + ?(ШаблонБизнесПроцесса.ШаблонВКомплексномПроцессе, ШаблонБизнесПроцесса.СрокОтложенногоСтарта, 0)
					+ ШаблонБизнесПроцесса.СрокИсполнения*24*3600
					+ ШаблонБизнесПроцесса.СрокИсполненияЧас*3600;
			КонецЕсли;	
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(ШаблонБизнесПроцесса.СрокИсполнения) Тогда 
			Если ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы") Тогда 
				СрокИсполнения = ГрафикиРаботы.ПолучитьДатуОкончанияПериода(
					ГрафикРаботы,
					Дата + ?(ШаблонБизнесПроцесса.ШаблонВКомплексномПроцессе, ШаблонБизнесПроцесса.СрокОтложенногоСтарта, 0),
					ШаблонБизнесПроцесса.СрокИсполнения);
			Иначе
				СрокИсполнения = 
					Дата + ?(ШаблонБизнесПроцесса.ШаблонВКомплексномПроцессе, ШаблонБизнесПроцесса.СрокОтложенногоСтарта, 0)
					+ ШаблонБизнесПроцесса.СрокИсполнения*24*3600;
			КонецЕсли;	
			СрокИсполнения = КонецДня(СрокИсполнения);
		КонецЕсли;
	КонецЕсли;	
	
	// трудозатраты
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
		ТрудозатратыПланИсполнителя = ШаблонБизнесПроцесса.ТрудозатратыПланИсполнителя;
	КонецЕсли;
	
	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитов(ШаблонБизнесПроцесса, ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ШаблонДляОтложенногоСтарта", ШаблонБизнесПроцесса);
	
КонецПроцедуры	

// Заполняет бизнес-процесс на основании проектной задачи
//
Процедура ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения) Экспорт 
	
	Проект = ДанныеЗаполнения.Владелец;
	ПроектнаяЗадача = ДанныеЗаполнения;
	
	НаименованиеПоУмолчанию = МультипредметностьКлиентСервер.ПолучитьНаименованиеСПредметами(
		НСтр("ru = 'Зарегистрировать'"), Предметы);
	
	Если Не ЗначениеЗаполнено(Наименование) Или Наименование = НаименованиеПоУмолчанию Тогда
		Наименование = ПроектнаяЗадача.Наименование;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Описание) Тогда 
		Описание = ПроектнаяЗадача.Описание;
	КонецЕсли;

	Если Предметы.Количество() = 0 Тогда 
		Предмет = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ПроектнаяЗадача, "Предмет");
		
		Если Предмет <> Неопределено И Предметы.Найти(Предмет,"Предмет") = Неопределено Тогда
			СтрокаПредметов = Предметы.Добавить();
			СтрокаПредметов.РольПредмета = Перечисления.РолиПредметов.Основной;
			СтрокаПредметов.ИмяПредмета =  МультипредметностьВызовСервера.ПолучитьСсылкуНаИмяПредметаПоСсылкеНаПредмет(
				Предмет, Предметы.ВыгрузитьКолонку("ИмяПредмета"));
			СтрокаПредметов.Предмет = Предмет;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СрокИсполнения) Тогда 
		ДанныеПроектнойЗадачи = РаботаСПроектами.ПолучитьДанныеПроектнойЗадачи(ПроектнаяЗадача);
		СрокИсполнения = ДанныеПроектнойЗадачи.ТекущийПланОкончание;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Исполнитель) И ПроектнаяЗадача.Исполнители.Количество() > 0 Тогда 
		СтрокаИсполнитель = ПроектнаяЗадача.Исполнители[0];
		
		Если ТипЗнч(СтрокаИсполнитель.Исполнитель) = Тип("СправочникСсылка.Пользователи") 
		 Или ТипЗнч(СтрокаИсполнитель.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда 
			Исполнитель = СтрокаИсполнитель.Исполнитель;
			ОсновнойОбъектАдресации = СтрокаИсполнитель.ОсновнойОбъектАдресации;
			ДополнительныйОбъектАдресации = СтрокаИсполнитель.ДополнительныйОбъектАдресации;
			ТрудозатратыПланИсполнителя = СтрокаИсполнитель.ТекущийПланТрудозатраты;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры	

// Восстанавливает состояние предмета БП при отмене удаления
//
Процедура ВосстановитьСостояниеПредметов()
	
	Если ЗначениеЗаполнено(ДатаНачала) Тогда 
		ЗаписатьСостояниеПредметов(, Перечисления.СостоянияДокументов.НаРегистрации);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьСостояниеПредметов(Предмет = Неопределено, СостояниеПредмета)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Предмет <> Неопределено Тогда
		
		Если Не ДелопроизводствоКлиентСервер.ЭтоСсылкаНаДокумент(Предмет) Тогда
			Возврат;
		КонецЕсли;
		ПредметыДляУстановки = Новый Массив;
		ПредметыДляУстановки.Добавить(Предмет);
		
	Иначе
		
		ТипыДокументов = МультипредметностьКлиентСервер.ПолучитьТипыДокументов();
		ПредметыДляУстановки = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект, ТипыДокументов, Истина);
		
	КонецЕсли;
	
	Если ПредметыДляУстановки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда 
		БизнесПроцессСсылка = Ссылка;
	Иначе
		БизнесПроцессСсылка = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(БизнесПроцессСсылка) Тогда
			БизнесПроцессСсылка = БизнесПроцессы.Регистрация.ПолучитьСсылку();
			УстановитьСсылкуНового(БизнесПроцессСсылка);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Предмет Из ПредметыДляУстановки Цикл
		Делопроизводство.ЗаписатьСостояниеДокумента(
			Предмет, 
			ДатаНачала, 
			СостояниеПредмета,
			БизнесПроцессСсылка);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает признак наличия метода ПриПрикрепленииПредмета
// 
Функция ЕстьМетодПриПрикрепленииПредмета() Экспорт
	Возврат Истина;
КонецФункции

// Вызывается при прикреплении предмета к стартованному БП
//
Процедура ПриПрикрепленииПредмета(Предмет = Неопределено) Экспорт
	
	ЗаписатьСостояниеПредметов(Предмет, Перечисления.СостоянияДокументов.НаРегистрации);
	
КонецПроцедуры

// Возвращает признак наличия метода ПриОткрепленииПредмета
// 
Функция ЕстьМетодПриОткрепленииПредмета() Экспорт
	Возврат Истина;
КонецФункции

// Вызывается при откреплении предмета от стартованного БП
//
Процедура ПриОткрепленииПредмета(Документ = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Документ) Тогда 
		Возврат;
	КонецЕсли;
	
	Если ДелопроизводствоКлиентСервер.ЭтоСсылкаНаДокумент(Документ) Тогда 
		Делопроизводство.УдалитьСостояниеДокумента(Документ, Ссылка);
	КонецЕсли;	
	
КонецПроцедуры

// Компенсирует состояние документа при прерывании БП
//
Процедура КомпенсироватьСостояниеПредметов() Экспорт
	
	ОсновныеПредметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ЭтотОбъект,, Истина);
	
	Для Каждого Предмет Из ОсновныеПредметы Цикл
		Если ДелопроизводствоКлиентСервер.ЭтоСсылкаНаДокумент(Предмет) Тогда 
			Делопроизводство.УдалитьСостояниеДокумента(Предмет, Ссылка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Заполняет бизнес-процесс на основании шаблона бизнес-процесса, предмета и автора.
//
// Параметры
//  ШаблонБизнесПроцесса  - шаблон бизнес-процесса
//  Предмет - предмет бизнес-процесса
//  Автор  - автор
//
Процедура ЗаполнитьПоШаблонуИПредмету(ШаблонБизнесПроцесса, ПредметСобытия, АвторСобытия) Экспорт
	
	Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ШаблонБизнесПроцесса, ЭтотОбъект);
	Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ПредметСобытия, Ложь, Истина);
	ЗаполнитьПоШаблону(ШаблонБизнесПроцесса);
	
	Проект = МультипредметностьПереопределяемый.ПолучитьОсновнойПроектПоПредметам(ПредметСобытия);
	
	Дата = ТекущаяДатаСеанса();
	Автор = АвторСобытия;
	
КонецПроцедуры	

// Возвращает описание задачи, специфичное для бизнес-процесса
Функция ПолучитьОписаниеУведомленияЗадачи(Задача) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Заполняет задачу создаваемую в точке маршрута "Ознакомиться".
//
// Параметры:
//   - Задача - ЗадачаОбъект.ЗадачаИсполнителя
//
Процедура ЗаполнитьЗадачуОзнакомиться(Задача)
	
	ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.Регистрация.ТочкиМаршрута.Ознакомиться;
	
	Задача.Дата  	= ТекущаяДатаСеанса();
	Задача.Автор 	= Автор;
	Задача.Важность = Важность;
	
	Мультипредметность.ЗадачаПередСозданием(ЭтотОбъект, Задача, ТочкаМаршрутаБизнесПроцесса);
	
	Задача.Исполнитель 	  = Автор;
	Задача.СрокИсполнения = '00010101';
	Задача.БизнесПроцесс  = Ссылка;
	Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
	
	Задача.Проект = Проект;
	Задача.ПроектнаяЗадача = ПроектнаяЗадача;
	
	МассивПредметов = МультипредметностьКлиентСервер.ПолучитьМассивСтруктурПредметовОбъекта(ЭтотОбъект,,Истина);
	СтрокаПредметов = МультипредметностьКлиентСервер.ПредметыСтрокой(МассивПредметов, Истина, Ложь);
	
	Если ЗначениеЗаполнено(СтрокаПредметов) Тогда 
		Задача.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ознакомиться с результатом регистрации: %1'"),
		    Строка(СтрокаПредметов));
	Иначе
		Задача.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ознакомиться с результатом регистрации: %1'"),
			Наименование);
	КонецЕсли;	
	
	Если РезультатРегистрации = Перечисления.РезультатыРегистрации.Зарегистрировано Тогда
	
		Для Каждого СтрокаПредмета Из МассивПредметов Цикл 
			Если ДелопроизводствоКлиентСервер.ЭтоСсылкаНаДокумент(СтрокаПредмета.Предмет) Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Документ зарегистрирован %1 под номером %2'"),
						Формат(СтрокаПредмета.Предмет.ДатаРегистрации, "ДЛФ=D"),
						СтрокаПредмета.Предмет.РегистрационныйНомер);
					
				Задача.Описание = ТекстСообщения 
					+ ?(ПустаяСтрока(Описание), "", Символы.ПС + Символы.ПС + Описание);
			Иначе	
				Задача.Описание = Описание;
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		
		Задача.Описание = Описание;
		
	КонецЕсли;
	
	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитов(Задача.БизнесПроцесс, Задача);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы со стартом процесса

Процедура ОтложенныйСтарт() Экспорт
	
	ОтложенныйСтартБизнесПроцессовСервер.СтартоватьПроцессОтложенно(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОтключитьОтложенныйСтарт() Экспорт
	
	ОтложенныйСтартБизнесПроцессовСервер.ОтключитьОтложенныйСтарт(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для поддержки комплексных процессов

// Формирует шаблон по процессу
// Параметры:
//	ВладелецШаблона - ссылка на шаблон комплексного процесса или комплексный процесс, который будет владельцем
//		создаваемого шаблона процесса
// Возвращает:
//	Ссылка на созданный шаблон
Функция СоздатьШаблонПоПроцессу(ВладелецШаблона = Неопределено) Экспорт
	
	ИмяТипа = БизнесПроцессы[ЭтотОбъект.Метаданные().Имя].ТипШаблона();	
	ШаблонОбъект = Справочники[СтрЗаменить(ИмяТипа, "Справочник.", "")].СоздатьЭлемент();
	
	// Перенос базовых реквизитов процесса
	ШаблонОбъект.Наименование = Наименование;
	ШаблонОбъект.НаименованиеБизнесПроцесса = Наименование;
	ШаблонОбъект.Описание = Описание;
	ШаблонОбъект.Важность = Важность;
	ШаблонОбъект.Автор = ПользователиКлиентСервер.ТекущийПользователь();
	ШаблонОбъект.ВладелецШаблона = ВладелецШаблона;
	
	ШаблонОбъект.Предметы.Загрузить(Предметы.Выгрузить());
	Для Каждого СтрокаПредмета Из ШаблонОбъект.Предметы Цикл
		Если ЗначениеЗаполнено(СтрокаПредмета.Предмет) Тогда
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтрокаПредмета.Предмет.Метаданные().ПолноеИмя()).ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	ШаблонОбъект.ПредметыЗадач.Загрузить(ПредметыЗадач.Выгрузить());
	
	// Перенос общего срока
	Если ЗначениеЗаполнено(СрокИсполнения) Тогда
		РазностьСрокаИсполнения = СрокИсполнения - Дата;
		ШаблонОбъект.СрокИсполнения = Цел(РазностьСрокаИсполнения/(3600*24));
		Если ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач") Тогда
			ШаблонОбъект.СрокИсполненияЧас = Цел((РазностьСрокаИсполнения - ШаблонОбъект.СрокИсполнения*3600*24)/3600);
		КонецЕсли;
	КонецЕсли;
	
	// Перенос исполнителя
	ШаблонОбъект.Исполнитель = Исполнитель;
	ШаблонОбъект.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
	ШаблонОбъект.ДополнительныйОбъектАдресации = ДополнительныйОбъектАдресации;
	
	ШаблонОбъект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();	
	ШаблонОбъект.Записать();
	Возврат ШаблонОбъект.Ссылка;
	
КонецФункции

// Дополняет описание процесса общим описанием
Процедура ДополнитьОписание(ОбщееОписание) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ОбщееОписание) Тогда
		Возврат;
	КонецЕсли;
	Описание = ОбщееОписание + Символы.ПС + Описание;
	Записать();
	
КонецПроцедуры

// Проверяет что заполнены поля шаблона
Функция ПолучитьСписокНезаполненныхПолейНеобходимыхДляСтарта() Экспорт
	
	МассивПолей = Новый Массив;
	
	Если Не ЗначениеЗаполнено(Исполнитель) Тогда
		МассивПолей.Добавить("Исполнитель");
	КонецЕсли;	
	
	Возврат МассивПолей;
	
КонецФункции	

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если ДополнительныеСвойства.Свойство("ПредыдущаяПометкаУдаления") Тогда
		ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущаяПометкаУдаления;
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		ПротоколированиеРаботыПользователей.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;
	
	ОтложенныйСтартБизнесПроцессовСервер.ПроцессПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецЕсли