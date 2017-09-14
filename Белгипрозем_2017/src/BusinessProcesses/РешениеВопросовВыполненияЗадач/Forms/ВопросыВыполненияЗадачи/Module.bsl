
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.Задача) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗадачаПараметр = Параметры.Задача;
	СписокВопросов.Параметры.УстановитьЗначениеПараметра("ПредметРассмотрения", ЗадачаПараметр);
	АвторЗадачи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗадачаПараметр, "Автор");;
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаданВопросАвторуЗадачи" И Параметр = ЗадачаПараметр 
		ИЛИ ИмяСобытия = "ЗадачаВыполнена" Тогда
		Элементы.СписокВопросов.Обновить();
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВопросовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Задача", ЗадачаПараметр);
	ПараметрыФормы.Вставить("Кому", АвторЗадачи);
	
	ОткрытьФорму("БизнесПроцесс.РешениеВопросовВыполненияЗадач.ФормаОбъекта", ПараметрыФормы, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//Код процедур и функций
#КонецОбласти

