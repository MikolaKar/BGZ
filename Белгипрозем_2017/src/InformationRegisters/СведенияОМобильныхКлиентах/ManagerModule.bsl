// Записывает сведения о мобильном клиенте.
// Параметры:
//	МобильныйКлиент - ссылка на узел плана обмена Мобильный
//	Дата - дата и время последнего подключения
//	Сведения - строка с описанием мобильного клиента
Процедура ЗаписатьСведенияОКлиенте(МобильныйКлиент, Дата, Описание, ВерсияКлиента) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.СведенияОМобильныхКлиентах.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.МобильныйКлиент = МобильныйКлиент;
	МенеджерЗаписи.Прочитать();
	
	МенеджерЗаписи.МобильныйКлиент = МобильныйКлиент;
	МенеджерЗаписи.ДатаПоследнейАктивности = Дата;
	Если Не ЗначениеЗаполнено(МенеджерЗаписи.Описание) Или ЗначениеЗаполнено(Описание) Тогда
		МенеджерЗаписи.Описание = Описание;
	КонецЕсли;
	МенеджерЗаписи.ВерсияКлиента = ВерсияКлиента;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры
	
// Возвращает дату последнего подключения мобильного клиента
// Параметры:
//	МобильныйКлиент - ссылка на узел плана обмена Мобильный
Функция ПолучитьДатуПоследнейАктивностиКлиента(МобильныйКлиент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОМобильныхКлиентах.ДатаПоследнейАктивности
		|ИЗ
		|	РегистрСведений.СведенияОМобильныхКлиентах КАК СведенияОМобильныхКлиентах
		|ГДЕ
		|	СведенияОМобильныхКлиентах.МобильныйКлиент = &МобильныйКлиент";
	Запрос.УстановитьПараметр("МобильныйКлиент", МобильныйКлиент);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ДатаПоследнейАктивности;
	Иначе
		Возврат Дата(1,1,1);
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСведения(МобильныйКлиент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОМобильныхКлиентах.ДатаПоследнейАктивности,
		|	СведенияОМобильныхКлиентах.Описание,
		|	СведенияОМобильныхКлиентах.ВерсияКлиента
		|ИЗ
		|	РегистрСведений.СведенияОМобильныхКлиентах КАК СведенияОМобильныхКлиентах
		|ГДЕ
		|	СведенияОМобильныхКлиентах.МобильныйКлиент = &МобильныйКлиент";
	Запрос.УстановитьПараметр("МобильныйКлиент", МобильныйКлиент);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;	
	
КонецФункции

Функция ПолучитьВерсию(МобильныйКлиент) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	МенеджерЗаписи = РегистрыСведений.СведенияОМобильныхКлиентах.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.МобильныйКлиент = МобильныйКлиент;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		Возврат МенеджерЗаписи.ВерсияКлиента;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции