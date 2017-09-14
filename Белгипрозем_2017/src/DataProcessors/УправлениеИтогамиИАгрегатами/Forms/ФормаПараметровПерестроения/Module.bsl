
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОтносительныйРазмер = Параметры.ОтносительныйРазмер;
	МинимальныйЭффект = Параметры.МинимальныйЭффект;
	Элементы.МинимальныйЭффект.Видимость = Параметры.РежимПерестроения;
	Заголовок = ?(Параметры.РежимПерестроения,
	              НСтр("ru='Параметры перестроения'"),
	              НСтр("ru='Параметр расчета оптимальных агрегатов'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	РезультатВыбора = Новый Структура("ОтносительныйРазмер, МинимальныйЭффект");
	ЗаполнитьЗначенияСвойств(РезультатВыбора, ЭтотОбъект);
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти
