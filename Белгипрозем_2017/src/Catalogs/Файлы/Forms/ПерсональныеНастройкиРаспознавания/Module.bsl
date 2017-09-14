
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Макет = Справочники.Файлы.ПолучитьМакет("ЯзыкиРаспознавания");
	ТабЗначений = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	
	Для Каждого Запись Из ТабЗначений Цикл
		Элементы.ЯзыкРаспознавания.СписокВыбора.Добавить(Запись.Language, Запись.Name);
	КонецЦикла;	
	
	ЯзыкРаспознавания = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Распознавание", "ЯзыкРаспознавания");
	Если ЯзыкРаспознавания = "" Тогда
		ЯзыкРаспознавания = РаботаСФайламиВызовСервера.ПолучитьЯзыкРаспознавания();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "Распознавание");
	Элемент.Вставить("Настройка", "ЯзыкРаспознавания");
	Элемент.Вставить("Значение", ЯзыкРаспознавания);
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
	Закрыть();
КонецПроцедуры
