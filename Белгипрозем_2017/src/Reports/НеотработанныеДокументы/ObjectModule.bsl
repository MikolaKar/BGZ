#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	// Документы
	ЕстьПравоЧтенияВсехДокументов = ДокументооборотПраваДоступа.ЕстьРоль("ПолныеПрава");
	
	// Внутренние документы
	ЕстьПравоЧтенияВнутреннихДокументов = ЕстьПравоЧтенияВсехДокументов
		Или ДокументооборотПраваДоступа.ЕстьРоль("РаботаСВнутреннимиДокументами")
		Или ДокументооборотПраваДоступа.ЕстьРоль("РегистрацияВнутреннихДокументов");
	Если Не ЕстьПравоЧтенияВнутреннихДокументов Тогда
		СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.Удалить(
			СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.Внутренние);
	КонецЕсли;
	
	// Входящие документы
	ЕстьПравоЧтенияВходяшихДокументов = ЕстьПравоЧтенияВсехДокументов
		Или ДокументооборотПраваДоступа.ЕстьРоль("ЧтениеВходящихДокументов")
		Или ДокументооборотПраваДоступа.ЕстьРоль("ДобавлениеИзменениеВходящихДокументов");
	Если Не ЕстьПравоЧтенияВходяшихДокументов Тогда
		СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.Удалить(
			СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.Входящие);
	КонецЕсли;
	
	// Исходящие документы
	ЕстьПравоЧтенияИсходящихДокументов = ЕстьПравоЧтенияВсехДокументов
		Или ДокументооборотПраваДоступа.ЕстьРоль("ЧтениеИсходящихДокументов")
		Или ДокументооборотПраваДоступа.ЕстьРоль("ДобавлениеИзменениеИсходящихДокументов")
		Или ДокументооборотПраваДоступа.ЕстьРоль("РегистрацияИсходящихДокументов");
	Если Не ЕстьПравоЧтенияИсходящихДокументов Тогда
		СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.Удалить(
			СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.Исходящие);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли