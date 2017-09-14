#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Установка отборов динамического списка.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ВыполнятьПоРасписанию", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Ложь,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ПериодичностьРасписания", ,
		ВидСравненияКомпоновкиДанных.Равно, , Ложь,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Подготовлена", Ложь,
		ВидСравненияКомпоновкиДанных.Равно, , Ложь,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Автор", ,
		ВидСравненияКомпоновкиДанных.Равно, , Ложь,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	
	ЗаполнитьПараметрСписка("РежимВыбора");
	ЗаполнитьПараметрСписка("ВыборГруппИЭлементов");
	ЗаполнитьПараметрСписка("МножественныйВыбор");
	ЗаполнитьПараметрСписка("ТекущаяСтрока");
	
	Если Параметры.РежимВыбора Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	Если НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеРассылокОтчетов") Тогда
		// Режим показа только личных рассылок - скрываются группы и лишние колонки.
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ЭтоГруппа", Ложь, , , Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ПустаяДата", '00010101');
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов") Тогда
		Элементы.ИзменитьВыделенные.Видимость = Ложь;
		Элементы.ИзменитьВыделенныеСписок.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	МодульГрупповоеИзменениеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ГрупповоеИзменениеОбъектовКлиент");
	МодульГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПараметрСписка(Ключ)
	Если Параметры.Свойство(Ключ) И ЗначениеЗаполнено(Параметры[Ключ]) Тогда
		Элементы.Список[Ключ] = Параметры[Ключ];
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики ожидания

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеФоновогоЗадания()
	РассылкаОтчетовКлиент.ПроверитьВыполнениеФоновогоЗадания(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти
