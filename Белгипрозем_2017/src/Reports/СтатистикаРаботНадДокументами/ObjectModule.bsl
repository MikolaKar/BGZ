#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	// Документы
	ЕстьПравоЧтенияВсехДокументов = ДокументооборотПраваДоступа.ЕстьРоль("ПолныеПрава");
	
	// Входящие документы
	ЕстьПравоЧтенияВходяшихДокументов = ЕстьПравоЧтенияВсехДокументов
		Или ДокументооборотПраваДоступа.ЕстьРоль("ЧтениеВходящихДокументов")
		Или ДокументооборотПраваДоступа.ЕстьРоль("ДобавлениеИзменениеВходящихДокументов");
	Если Не ЕстьПравоЧтенияВходяшихДокументов Тогда
		СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.Удалить(
			СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.ВходящиеДокументы);
	КонецЕсли;
	
	// Внутренние документы
	ЕстьПравоЧтенияВнутреннихДокументов = ЕстьПравоЧтенияВсехДокументов
		Или ДокументооборотПраваДоступа.ЕстьРоль("РаботаСВнутреннимиДокументами")
		Или ДокументооборотПраваДоступа.ЕстьРоль("РегистрацияВнутреннихДокументов");
	Если Не ЕстьПравоЧтенияВнутреннихДокументов Тогда
		СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.Удалить(
			СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.ВнутренниеДокументы);
	КонецЕсли;
	
	// Исходящие документы
	ЕстьПравоЧтенияИсходящихДокументов = ЕстьПравоЧтенияВсехДокументов
		Или ДокументооборотПраваДоступа.ЕстьРоль("ЧтениеИсходящихДокументов")
		Или ДокументооборотПраваДоступа.ЕстьРоль("ДобавлениеИзменениеИсходящихДокументов")
		Или ДокументооборотПраваДоступа.ЕстьРоль("РегистрацияИсходящихДокументов");
	Если Не ЕстьПравоЧтенияИсходящихДокументов Тогда
		СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.Удалить(
			СхемаКомпоновкиДанных.НаборыДанных.Документы.Элементы.ИсходящиеДокументы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли