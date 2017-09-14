
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если Количество() = 0 Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СведенияОПользователях.Подразделение
			|ИЗ
			|	РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
			|ГДЕ
			|	СведенияОПользователях.Пользователь = &Пользователь";
		Запрос.УстановитьПараметр("Пользователь", Отбор.Пользователь.Значение);

		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ДополнительныеСвойства.Вставить("Подразделение", Выборка.Подразделение);
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	
	Подразделения = Новый Массив();
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СведенияОПользователях.Подразделение
			|ИЗ
			|	РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
			|ГДЕ
			|	СведенияОПользователях.Пользователь = &Пользователь";
		Запрос.УстановитьПараметр("Пользователь", Запись.Пользователь);

		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Если Подразделения.Найти(Выборка.Подразделение) = Неопределено Тогда
				Подразделения.Добавить(Выборка.Подразделение);	
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;	
	
	ДополнительныеСвойства.Вставить("Подразделения", Подразделения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если Количество() = 0 Тогда
		
		Если ДополнительныеСвойства.Свойство("Подразделение") Тогда
			УправлениеДоступомВызовСервераДокументооборот.ПриИзмененииСоставаСотрудниковПодразделения(
				ДополнительныеСвойства.Подразделение);
		КонецЕсли;	
		
		Возврат;
	КонецЕсли;
	
	Подразделения = Новый Массив();
	
	Если ДополнительныеСвойства.Свойство("Подразделения") Тогда
		
		Подразделения = ДополнительныеСвойства.Подразделения;
		Для Каждого Подразделение Из Подразделения Цикл
			
			УправлениеДоступомВызовСервераДокументооборот.ПриИзмененииСоставаСотрудниковПодразделения(
				Подразделение);
				
		КонецЦикла;	
			
	КонецЕсли;	
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Подразделения.Найти(Запись.Подразделение) = Неопределено Тогда
			УправлениеДоступомВызовСервераДокументооборот.ПриИзмененииСоставаСотрудниковПодразделения(
				Запись.Подразделение);
				
			Подразделения.Добавить(Запись.Подразделение);	
		КонецЕсли;
			
	КонецЦикла;			
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры
