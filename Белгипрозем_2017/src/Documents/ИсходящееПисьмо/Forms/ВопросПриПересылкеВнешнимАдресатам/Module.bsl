
&НаКлиенте
Процедура Переслать(Команда)
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Текст = НСтр("ru = 'Исходное письмо было адресовано только внутренним получателям. 
	|Вы действительно хотите переслать его следующим внешним адресатам:'");
	Текст = Текст + Символы.ПС + Символы.ПС;
	
	Если Параметры.ВнешниеАдресаты.Количество() > 0 Тогда 
		Для Каждого Строка Из Параметры.ВнешниеАдресаты Цикл
			Текст = Текст + " - " + Строка.Представление + Символы.ПС;
		КонецЦикла;
	КонецЕсли;	
	
	Текст = СтрЗаменить(Текст, ">", "");
	Текст = СтрЗаменить(Текст, "<", "");
		
	ТекстСообщения.Добавить(Текст, ТипЭлементаФорматированногоДокумента.Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если БольшеНеСпрашивать Тогда 
		ВстроеннаяПочтаСервер.УстановитьПерсональнуюНастройку(
			"ПредупреждатьПриПересылкеВнутреннихПисемВнешнимПолучателям",
			Ложь);
		
		НастройкиВстроеннойПочты = Новый Структура;
		НастройкиВстроеннойПочты.Вставить("ПредупреждатьПриПересылкеВнутреннихПисемВнешнимПолучателям", Ложь);
		Оповестить("ИзмененыНастройкиВстроеннойПочты", НастройкиВстроеннойПочты, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры
