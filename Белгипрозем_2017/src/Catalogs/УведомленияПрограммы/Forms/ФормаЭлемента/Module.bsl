

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = Истина;
	
	Элементы.ДекорацияПредставлениеУведомления.Заголовок = Строка(Объект.Ссылка);
	
	Если Объект.ВидУведомления = Перечисления.ВидыУведомленийПрограммы.Ошибка Тогда
		Элементы.ДекорацияУведомления.Картинка = БиблиотекаКартинок.Остановить;
	ИначеЕсли Объект.ВидУведомления = Перечисления.ВидыУведомленийПрограммы.Предупреждение Тогда
		Элементы.ДекорацияУведомления.Картинка = БиблиотекаКартинок.Предупреждение;
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь(ТекущийПользователь);
	
	Элементы.ФормаПометитьНаУдаление.Видимость = 
		НЕ Объект.ПометкаУдаления
		И (ТекущийПользователь = Объект.Пользователь
			ИЛИ ЭтоПолноправныйПользователь);
		
	Элементы.Пользователь.Видимость = ТекущийПользователь <> Объект.Пользователь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	ТекстВопроса = НСтр("ru = 'Удалить уведомление?'");
	
	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить(Истина, "Удалить");
	СписокКнопок.Добавить(Ложь, "Отмена");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПометитьНаУдалениеПродолжение",
		ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокКнопок);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеПродолжение(Ответ, Параметры) Экспорт
	
	Если Ответ Тогда
		ПометитьНаУдалениеНаСервере(Объект.Ссылка);
		Закрыть();
		ОповеститьОбИзменении(Объект.Ссылка);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Помечает на удаление Уведомление.
//
// Параметры:
//   - Уведомление - СправочникОбъект.УведомленияПрограммы
//
&НаСервереБезКонтекста
Процедура ПометитьНаУдалениеНаСервере(Уведомление)
	
	УведомлениеОбъект = Уведомление.ПолучитьОбъект();
	УведомлениеОбъект.Заблокировать();
	УведомлениеОбъект.УстановитьПометкуУдаления(Истина);
	
КонецПроцедуры

#КонецОбласти