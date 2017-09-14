#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ВыбратьИзменения(Знач Узел, Знач НомерСообщения) Экспорт
	
	Если ТранзакцияАктивна() Тогда
		ВызватьИсключение НСтр("ru = 'Выборка изменений данных запрещена в активной транзакции.'");
	КонецЕсли;
	
	Результат = Новый Массив;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИзмененияОбщихДанныхУзлов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Узел", Узел);
		Блокировка.Заблокировать();
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ИзмененияОбщихДанныхУзлов.Узел КАК Узел,
		|	ИзмененияОбщихДанныхУзлов.НомерСообщения КАК НомерСообщения
		|ИЗ
		|	РегистрСведений.ИзмененияОбщихДанныхУзлов КАК ИзмененияОбщихДанныхУзлов
		|ГДЕ
		|	ИзмененияОбщихДанныхУзлов.Узел = &Узел";
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Узел", Узел);
		Запрос.Текст = ТекстЗапроса;
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			Результат.Добавить(Выборка.Узел);
			
			Если Выборка.НомерСообщения = 0 Тогда
				
				СтруктураЗаписи = Новый Структура;
				СтруктураЗаписи.Вставить("Узел", Узел);
				СтруктураЗаписи.Вставить("НомерСообщения", НомерСообщения);
				ДобавитьЗапись(СтруктураЗаписи);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

Процедура ЗарегистрироватьИзменения(Знач Узел) Экспорт
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИзмененияОбщихДанныхУзлов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Узел", Узел);
		Блокировка.Заблокировать();
		
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("Узел", Узел);
		СтруктураЗаписи.Вставить("НомерСообщения", 0);
		ДобавитьЗапись(СтруктураЗаписи);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура УдалитьРегистрациюИзменений(Знач Узел, Знач НомерСообщения = Неопределено) Экспорт
	
	Если ТранзакцияАктивна() Тогда
		ВызватьИсключение НСтр("ru = 'Удаление регистрации изменений данных не может быть выполнено в активной транзакции.'");
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ИзмененияОбщихДанныхУзлов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Узел", Узел);
		Блокировка.Заблокировать();
		
		Если НомерСообщения = Неопределено Тогда
			
			ТекстЗапроса =
			"ВЫБРАТЬ
			|	1 КАК Поле1
			|ИЗ
			|	РегистрСведений.ИзмененияОбщихДанныхУзлов КАК ИзмененияОбщихДанныхУзлов
			|ГДЕ
			|	ИзмененияОбщихДанныхУзлов.Узел = &Узел";
			
		Иначе
			
			ТекстЗапроса =
			"ВЫБРАТЬ
			|	1 КАК Поле1
			|ИЗ
			|	РегистрСведений.ИзмененияОбщихДанныхУзлов КАК ИзмененияОбщихДанныхУзлов
			|ГДЕ
			|	ИзмененияОбщихДанныхУзлов.Узел = &Узел
			|	И ИзмененияОбщихДанныхУзлов.НомерСообщения <= &НомерСообщения
			|	И ИзмененияОбщихДанныхУзлов.НомерСообщения <> 0";
			
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Узел", Узел);
		Запрос.УстановитьПараметр("НомерСообщения", НомерСообщения);
		Запрос.Текст = ТекстЗапроса;
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			
			СтруктураЗаписи = Новый Структура;
			СтруктураЗаписи.Вставить("Узел", Узел);
			УдалитьЗапись(СтруктураЗаписи);
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Процедура добавляет запись в регистр по переданным значениям структуры
Процедура ДобавитьЗапись(СтруктураЗаписи)
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "ИзмененияОбщихДанныхУзлов");
	
КонецПроцедуры

// Процедура удаляет набор записей в регистре по переданным значениям структуры
Процедура УдалитьЗапись(СтруктураЗаписи)
	
	ОбменДаннымиСервер.УдалитьНаборЗаписейВРегистреСведений(СтруктураЗаписи, "ИзмененияОбщихДанныхУзлов");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли