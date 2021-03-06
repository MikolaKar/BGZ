Процедура ЗаполнитьПоШаблону(ПроцессОбъект, ШаблонБизнесПроцесса) Экспорт
	
	// трудозатраты
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
		ПроцессОбъект.ТрудозатратыПланКонтролера = ШаблонБизнесПроцесса.ТрудозатратыПланКонтролера;
	КонецЕсли;
	
	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитов(ШаблонБизнесПроцесса, ПроцессОбъект);
	
КонецПроцедуры

Процедура ИзменениеРеквизитовНевыполненныхЗадач(ПараметрыЗаписи, ПроцессОбъект, ЗадачаОбъект) Экспорт
	
	ЗадачаОбъект.Проект = ПроцессОбъект.Проект;
	ЗадачаОбъект.ПроектнаяЗадача = ПроцессОбъект.ПроектнаяЗадача;
			
	Если ПараметрыЗаписи.Свойство("ПереносСрока") 
		И ПараметрыЗаписи.ПереносСрока Тогда
		Если ТипЗнч(ПараметрыЗаписи.Предмет) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя")
			И ПараметрыЗаписи.Предмет = ЗадачаОбъект.БизнесПроцесс Тогда
			ПараметрыЗаписи.СтарыйСрок = ЗадачаОбъект.Ссылка.СрокИсполнения;
			ПараметрыЗаписи.НовыйСрок = ЗадачаОбъект.СрокИсполнения;
		КонецЕсли;
		ПереносСроковВыполненияЗадач.СделатьЗаписьОПереносеСрока(ЗадачаОбъект, ПараметрыЗаписи);
	КонецЕсли;
	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитов(ПроцессОбъект, ЗадачаОбъект);
	
КонецПроцедуры

Процедура ЗаполнениеПроцессаПоЗадаче(ПроцессОбъект, ЗадачаСсылка) Экспорт
	
	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитов(ЗадачаСсылка, ПроцессОбъект);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ПроцессОбъект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ПроцессОбъект.ЭтоНовый() Тогда 
		Если Не ЗначениеЗаполнено(ПроцессОбъект.Проект) Тогда 
			ПроцессОбъект.Проект = РаботаСПроектами.ПолучитьПроектПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			
		Если ДанныеЗаполнения.Свойство("Проект") Тогда
			ПроцессОбъект.Проект = ДанныеЗаполнения.Проект;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("АвторСобытия") Тогда
			ПроцессОбъект.Автор = ДанныеЗаполнения.АвторСобытия;
		КонецЕсли;
		
		ТипыПисем = МультипредметностьПереопределяемый.ПолучитьТипыПисем();
		ОсновныеПисьма = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ПроцессОбъект, ТипыПисем, Истина);
		Для Каждого Письмо Из ОсновныеПисьма Цикл
			Тема = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Письмо, "Тема");
			ПроцессОбъект.Проект = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Письмо, "Проект");
			Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обработать ""%1""'"),
				Тема);
			Прервать;
		КонецЦикла;
			
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ДанныеЗаполнения.Свойство("Предметы") Тогда
		СсылкаНаПроект = МультипредметностьПереопределяемый.ПолучитьОсновнойПроектПоПредметам(ДанныеЗаполнения.Предметы);
		Если ЗначениеЗаполнено(СсылкаНаПроект) Тогда
			ПроцессОбъект.Проект = СсылкаНаПроект;
		КонецЕсли;
	КонецЕсли;
			
	Если Не ЗначениеЗаполнено(ПроцессОбъект.СрокИсполнения) Тогда 
		ТипыДокументов = МультипредметностьКлиентСервер.ПолучитьТипыДокументов();
		ОбрабатываемыеПредметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ПроцессОбъект, ТипыДокументов, Истина);
		
		Для Каждого Предмет Из ОбрабатываемыеПредметы Цикл
			СрокИсполнения = Предмет.СрокИсполнения;
			Прервать;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура КонтролерПередСозданиемЗадач(ПроцессОбъект, Задача) Экспорт
	
	Задача.Проект = ПроцессОбъект.Проект;
	Задача.ПроектнаяЗадача = ПроцессОбъект.ПроектнаяЗадача;

	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитов(Задача.БизнесПроцесс, Задача);
	
КонецПроцедуры

Процедура ПередЗаписью(ПроцессОбъект) Экспорт
	
	// Обработка рабочей группы	
	РаботаСБизнесПроцессами.СформироватьРабочуюГруппу(ПроцессОбъект);
	
КонецПроцедуры

Процедура СоздатьПроцессПоЭтапуЗаполнениеВедущейЗадачи(КомплексныйПроцессОбъект, ВедущаяЗадачаОбъект) Экспорт
	
	ВедущаяЗадачаОбъект.Проект = КомплексныйПроцессОбъект.Проект;
	ВедущаяЗадачаОбъект.ПроектнаяЗадача = КомплексныйПроцессОбъект.ПроектнаяЗадача;
	
КонецПроцедуры

Процедура СоздатьПроцессПоЭтапуДоЗаписиПроцесса(КомплексныйПроцессОбъект, СозданныйПроцессОбъект) Экспорт
	
	СозданныйПроцессОбъект.Проект = КомплексныйПроцессОбъект.Проект;
	СозданныйПроцессОбъект.ПроектнаяЗадача = КомплексныйПроцессОбъект.ПроектнаяЗадача;
	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитов(КомплексныйПроцессОбъект, СозданныйПроцессОбъект);
	
КонецПроцедуры

Процедура СоздатьПроцессПоЭтапуПослеЗаписиПроцесса(КомплексныйПроцессОбъект, СозданныйПроцессОбъект) Экспорт
	
	// Копирование рабочей группы
	РаботаСРабочимиГруппами.ДобавитьУчастниковВРабочуюГруппуДокументаИзИсточника(
		СозданныйПроцессОбъект.Ссылка, 
		КомплексныйПроцессОбъект.Ссылка, 
		Истина);
	
	ТаблицаУчастников = РаботаСРабочимиГруппами.ПолучитьРабочуюГруппуДокумента(СозданныйПроцессОбъект.Ссылка);
	КоличествоУчастниковБыло = ТаблицаУчастников.Количество();
	РаботаСРабочимиГруппами.ДобавитьУчастниковИзИсточника(ТаблицаУчастников, КомплексныйПроцессОбъект.Ссылка);
	РаботаСРабочимиГруппами.ПерезаписатьРабочуюГруппуОбъекта(СозданныйПроцессОбъект.Ссылка, ТаблицаУчастников, Ложь);
	
КонецПроцедуры
