&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("Использовать", Использовать);
	Если Параметры.Свойство("Данные") Тогда
		Параметры.Данные.Свойство("Профиль", Профиль);
		Параметры.Данные.Свойство("Отправитель", Отправитель);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ВидПочтовогоКлиента = ПредопределенноеЗначение("Перечисление.ВидыПочтовыхКлиентов.Почта");
	Наименование = Строка(ВидПочтовогоКлиента);
	ДобавитьЗначениеКСтрокеЧерезРазделитель(Наименование, ", ", СокрЛП(Профиль));
	
	Результат = Новый Структура;
	Результат.Вставить("Наименование", Наименование);
	Результат.Вставить("ВидПочтовогоКлиента", ВидПочтовогоКлиента);
	Результат.Вставить("Использовать", Использовать);
	Результат.Вставить("Данные", Новый Структура);
	Результат.Данные.Вставить("Профиль", Профиль);
	Результат.Данные.Вставить("Отправитель", Отправитель);
	Закрыть(Результат);
	
КонецПроцедуры
