
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Данные = Объект.Ссылка.ДанныеСообщения.Получить();
	Размер = СтрДлина(Данные);
	ТекстСообщения = Данные;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.Ссылка.Пустая() Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Сообщения интегрированных систем можно создавать только вызовом операций веб-сервиса DMMessages.'"));
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры
