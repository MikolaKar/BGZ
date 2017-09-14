#Область ПрограммныйИнтерфейс

// Возвращает настройку пользователя уведомления о сроке контроля
Функция ПолучитьНастройку(Пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиУведомленияОКонтроле.СрокУведомления,
		|	НастройкиУведомленияОКонтроле.ЧастотаПриближениеСрока,
		|	НастройкиУведомленияОКонтроле.ЧастотаПросроченКонтроль
		|ИЗ
		|	РегистрСведений.НастройкиУведомленияОКонтроле КАК НастройкиУведомленияОКонтроле
		|ГДЕ
		|	НастройкиУведомленияОКонтроле.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Результат = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		НастройкаУведомлений = 
			Новый Структура("СрокПодошелСрокКонтроля, ЧастотаПодошелСрокКонтроля, ЧастотаПросроченКонтроль",
			ВыборкаДетальныеЗаписи.СрокУведомления,
			ВыборкаДетальныеЗаписи.ЧастотаПриближениеСрока,
			ВыборкаДетальныеЗаписи.ЧастотаПросроченКонтроль);
		
		Возврат НастройкаУведомлений;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Записывает настройку уведомления о сроке контроля
Процедура СохранитьНастройку(Пользователь, СрокУведомления, ЧастотаПриближениеСрока, ЧастотаПросроченКонтроль) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.НастройкиУведомленияОКонтроле.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Прочитать();
	
	Запись.Пользователь = Пользователь;
	Запись.СрокУведомления = СрокУведомления;
	Запись.ЧастотаПриближениеСрока = ЧастотаПриближениеСрока;
	Запись.ЧастотаПросроченКонтроль = ЧастотаПросроченКонтроль;
	Запись.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти