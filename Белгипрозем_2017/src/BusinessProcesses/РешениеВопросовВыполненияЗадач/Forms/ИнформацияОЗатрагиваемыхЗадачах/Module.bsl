
&НаКлиенте
Процедура ОткрытьКарточкуЗадачи(Команда)
	
	Если Элементы.СписокЗадач.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Элементы.СписокЗадач.ТекущаяСтрока);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(Истина);		
	
КонецПроцедуры

&НаСервере
Функция ПосчитатьКоличествоЗатрагиваемыхЗадач()
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Количество(ЗадачаИсполнителя.Ссылка) КАК Колво
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.Ссылка В(&МассивСсылок)";
	Запрос.УстановитьПараметр("МассивСсылок", Параметры.МассивЗадач);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Колво;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БизнесПроцесс = Параметры.Процесс;
	ЗадачаИнициаторИзменения = Параметры.Задача;
	НовыйСрок = Параметры.НовыйСрок;
	СтарыйСрок = Параметры.СтарыйСрок;
	СписокЗадач.Параметры.УстановитьЗначениеПараметра("МассивСсылок", Параметры.МассивЗадач);
	СписокЗадач.Параметры.УстановитьЗначениеПараметра("НовыйСрок", НовыйСрок);
	СписокЗадач.Параметры.УстановитьЗначениеПараметра("Задача", ЗадачаИнициаторИзменения);
	
	НаименованиеПроцессаСсылка = БизнесПроцесс.Наименование;
	
	ИспользоватьВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Если НЕ ИспользоватьВремяВСрокахЗадач Тогда
		Элементы.СтарыйСрок.Формат = "ДФ='dd.MM.yyyy'";
		Элементы.НовыйСрок.Формат = "ДФ='dd.MM.yyyy'";
		Элементы.СписокЗадачСрокИсполнения.Формат = "ДФ='dd.MM.yyyy'";
		Элементы.СписокЗадачСрокИсполнения.Ширина = 5;
		Элементы.СписокЗадачНовыйСрок.Формат = "ДФ='dd.MM.yyyy'";
		Элементы.СписокЗадачНовыйСрок.Ширина = 5;
	КонецЕсли;
	
	КоличествоЗатрагиваемыхЗадач = ПосчитатьКоличествоЗатрагиваемыхЗадач();
	Если КоличествоЗатрагиваемыхЗадач > 0 Тогда
		Элементы.ДекорацияПояснение.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Перенос срока затронет следующие задачи в данном процессе (%1 шт.):'"),
				Строка(КоличествоЗатрагиваемыхЗадач));
	КонецЕсли;
	ДлительностьПереноса = ПереносСроковВыполненияЗадач.ПолучитьПодписьДлительностьПереноса(
		ЗадачаИнициаторИзменения.Исполнитель, 
		СтарыйСрок, 
		НовыйСрок);		
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элементы.СписокЗадач.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Элементы.СписокЗадач.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура БизнесПроцессНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, БизнесПроцесс);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

