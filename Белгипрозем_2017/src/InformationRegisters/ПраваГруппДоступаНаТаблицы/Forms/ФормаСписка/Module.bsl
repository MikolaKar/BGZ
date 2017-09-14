
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = Истина;
	
	Если ЗначениеЗаполнено(Параметры.ОпределительДоступа) Тогда
		Параметры.Таблица = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Параметры.ОпределительДоступа, "Таблица");
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Таблица", Параметры.Таблица);
	Если ЗначениеЗаполнено(Параметры.Таблица) Тогда
		Элементы.Таблица.Видимость = Ложь;
		Автозаголовок = Ложь;
		Заголовок = УправлениеДоступомДокументооборот.ЗаголовокПодчиненнойФормы(
			НСтр("ru = 'Права групп доступа на таблицу: ""%1"" (%2)'"), Параметры.Таблица);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	
КонецПроцедуры

