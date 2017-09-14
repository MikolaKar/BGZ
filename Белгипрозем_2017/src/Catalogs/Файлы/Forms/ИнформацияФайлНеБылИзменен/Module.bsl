&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	БольшеНеПоказывать = Не Параметры.ПоказыватьИнформациюЧтоФайлНеБылИзменен;
	КомментарийКВерсии = Параметры.КомментарийКВерсии;
	
	ТекстНапоминания = 
	НСтр("ru = 'Версия не была создана, т.к. файл не был изменен на вашем компьютере. Комментарий не сохранен:'");
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)

	Если БольшеНеПоказывать = Истина Тогда
		ПоказыватьИнформациюЧтоФайлНеБылИзменен = Не БольшеНеПоказывать;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьИОбновитьПовторноИспользуемыеЗначения("НастройкиПрограммы", "ПоказыватьИнформациюЧтоФайлНеБылИзменен", ПоказыватьИнформациюЧтоФайлНеБылИзменен);
	КонецЕсли;
	
	Закрыть(БольшеНеПоказывать);
	
КонецПроцедуры
