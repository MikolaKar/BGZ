
&НаКлиенте
Процедура ОК(Команда)
	
	СтруктураВозврата = Новый Структура("СохранятьСРасшифровкой, РасширениеДляЗашифрованныхФайлов", 
		СохранятьСРасшифровкой, РасширениеДляЗашифрованныхФайлов);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СохранятьСРасшифровкой = 1;
	Заголовок = Параметры.Заголовок;
	
	Если Параметры.Свойство("ПредставленияСертификатов") Тогда
		ПредставленияСертификатов = Параметры.ПредставленияСертификатов;
	Иначе
		Элементы.ПредставленияСертификатов.Видимость = Ложь;
	КонецЕсли;
	
	РасширениеДляЗашифрованныхФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЭП", "РасширениеДляЗашифрованныхФайлов");
	Если ПустаяСтрока(РасширениеДляЗашифрованныхФайлов) Тогда
		РасширениеДляЗашифрованныхФайлов = "p7m";
	КонецЕсли;
	
КонецПроцедуры
