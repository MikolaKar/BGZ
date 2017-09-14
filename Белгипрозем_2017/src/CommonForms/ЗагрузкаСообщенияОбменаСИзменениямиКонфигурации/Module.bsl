////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УзелИнформационнойБазы = ОбменДаннымиСервер.ГлавныйУзел();
	
	Если УзелИнформационнойБазы = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// получаем вид транспорта сообщений обмена по умолчанию для узла;
	// если значение по умолчанию не задано, то устанавливаем значение FILE
	ВидТранспортаСообщенийОбмена = РегистрыСведений.НастройкиТранспортаОбмена.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы);
	Если Не ЗначениеЗаполнено(ВидТранспортаСообщенийОбмена) Тогда
		ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.FILE;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыполнитьЗагрузкуДанных(Команда)
	
	Отказ = Ложь;
	
	Состояние(НСтр("ru = 'Выполняется загрузка данных...'"));
	
	// выполняем загрузку данных
	ОбменДаннымиВызовСервера.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(Отказ, УзелИнформационнойБазы, Истина, Ложь, ВидТранспортаСообщенийОбмена);
	
	Если Отказ Тогда
		
		НСтрока = НСтр("ru = 'При загрузке данных возникли ошибки.
							|Перейти в журнал регистрации?'");
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ВыполнитьЗагрузкуДанныхПродолжение",
			ЭтотОбъект);
			
		ПоказатьВопрос(ОписаниеОповещения, НСтрока, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Да);
		
	Иначе
		
		ПоказатьПредупреждение(,НСтр("ru = 'Загрузка данных успешно завершена.'"), 30);
		
		Закрыть(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуданныхПродолжение(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанныхМодально(УзелИнформационнойБазы, ЭтаФорма, "ЗагрузкаДанных");
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрацииСобытийЗагрузкиДанных(Команда)
	
	ОбменДаннымиКлиент.ПерейтиВЖурналРегистрацииСобытийДанныхМодально(УзелИнформационнойБазы, ЭтаФорма, "ЗагрузкаДанных");
	
КонецПроцедуры
