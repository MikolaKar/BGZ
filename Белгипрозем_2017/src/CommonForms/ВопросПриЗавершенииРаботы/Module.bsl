

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьОтображениеУведомлений();
	
	Если Элементы.ДекорацияЗанятыеФайлы.Видимость
		ИЛИ Элементы.ДекорацияУведомленияПрограммы.Видимость Тогда
		
		Элементы.ОсновнаяГруппа.ТекущаяСтраница = 
			Элементы.ВопросСУведомлениями;
	Иначе
		Элементы.ОсновнаяГруппа.ТекущаяСтраница = 
			Элементы.ВопросБезУведомлений;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОтключитьУведомленияПрограммы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОтключитьУведомленияПрограммы = ЗакрытьПрограмму;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияЗанятыеФайлыНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбновитьОтображениеУведомленийПослеЗакрытияПодчиненнойФормы", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.Файлы.Форма.СписокЗанятыхФайлов",,,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУведомленияПрограммыНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбновитьОтображениеУведомленийПослеЗакрытияПодчиненнойФормы", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.УведомленияПрограммы.Форма.УведомленияПользователя",,,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Завершить(Команда)
	
	ЗакрытьПрограмму = Истина;
	
	СтруктураВозврата = Новый Структура("ЗакрытьПрограмму, БольшеНеЗадаватьЭтотВопрос", 
		Истина, БольшеНеЗадаватьЭтотВопрос); 
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура НеЗавершать(Команда)
	
	ЗакрытьПрограмму = Ложь;
	
	СтруктураВозврата = Новый Структура("ЗакрытьПрограмму, БольшеНеЗадаватьЭтотВопрос", 
		Ложь, БольшеНеЗадаватьЭтотВопрос);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обновляет отображение уведомлений на форме.
// 
&НаСервере
Процедура ОбновитьОтображениеУведомлений()
	
	КоличествоУведомлений =
		РаботаСУведомлениямиПрограммыСервер.КоличествоУведомленийДляТекущегоПользователя();
	
	// Определение количества занятых файлов
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", "ПоказыватьЗанятыеФайлыПриЗавершенииРаботы", Истина);
	КоличествоЗанятыхФайлов = 0;
	Если ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = Истина Тогда
		ТекущийПользователь = Пользователи.ТекущийПользователь();
		КоличествоЗанятыхФайлов =
			РаботаСФайламиВызовСервера.ПолучитьКоличествоЗанятыхФайлов(Неопределено, ТекущийПользователь);
	КонецЕсли;
	
	Элементы.ДекорацияУведомленияПрограммы.Видимость = Ложь;
	Элементы.ДекорацияЗанятыеФайлы.Видимость = Ложь;
	
	Если КоличествоУведомлений > 0 Тогда
		
		ТекстЗаголовка = НСтр("ru = 'Есть уведомления (%1)'");
		
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстЗаголовка,
			КоличествоУведомлений);
		
		Элементы.ДекорацияУведомленияПрограммы.Заголовок = ТекстЗаголовка;
			
		Элементы.ДекорацияУведомленияПрограммы.Видимость = Истина;
		
	КонецЕсли;
	
	Если КоличествоЗанятыхФайлов > 0 Тогда
		
		ТекстЗаголовка = НСтр("ru = 'Есть занятые файлы (%1)'");
		
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстЗаголовка,
			КоличествоЗанятыхФайлов);
			
		Элементы.ДекорацияЗанятыеФайлы.Заголовок = ТекстЗаголовка;
			
		Элементы.ДекорацияЗанятыеФайлы.Видимость = Истина;
		
	КонецЕсли;
	
	Если НЕ Элементы.ДекорацияУведомленияПрограммы.Видимость
		И НЕ Элементы.ДекорацияЗанятыеФайлы.Видимость Тогда
		
		Элементы.ВопросСУведомлениямиГруппаЭлементов.Видимость = Ложь;
		Элементы.ПустаяДекорация.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеУведомленийПослеЗакрытияПодчиненнойФормы(
	Результат, Параметры) Экспорт
	
	ОбновитьОтображениеУведомлений();
	
КонецПроцедуры

#КонецОбласти
