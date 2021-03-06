
////////////////////////////////////////////////////////////////////////////////
// Повторение бизнес процессов: содержит серверные процедуры и функции механизма
//                              повторение процессов
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет формирование бизнес-процессов из регламентного задания 
//
Процедура ПовторениеБизнесПроцессовПоРасписанию() Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПовторениеБизнесПроцессов") Тогда
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкаПовторенияБизнесПроцессов.БизнесПроцесс,
		|	НастройкаПовторенияБизнесПроцессов.Расписание,
		|	НастройкаПовторенияБизнесПроцессов.ДатаПоследнегоПовторения,
		|	НастройкаПовторенияБизнесПроцессов.ГрафикРаботы
		|ИЗ
		|	РегистрСведений.НастройкаПовторенияБизнесПроцессов КАК НастройкаПовторенияБизнесПроцессов
		|ГДЕ
		|	НЕ НастройкаПовторенияБизнесПроцессов.ПовторениеЗавершено";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Расписание = Выборка.Расписание.Получить();
		
		ТекущаяДата = ТекущаяДатаСеанса();
		
		Если ЗначениеЗаполнено(Выборка.ГрафикРаботы)
			И ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы")
			И НЕ ГрафикиРаботы.ЭтоРабочаяДатаВремя(Выборка.ГрафикРаботы, ТекущаяДата) Тогда
			
			Продолжить;
		КонецЕсли;
		
		Если Расписание.ТребуетсяВыполнение(ТекущаяДата, Выборка.ДатаПоследнегоПовторения) Тогда
			Результат = ПовторитьБизнесПроцесс(ТекущаяДата, Выборка.БизнесПроцесс);
			
			Если Результат Тогда 
				МенеджерЗаписи = РегистрыСведений.НастройкаПовторенияБизнесПроцессов.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.БизнесПроцесс = Выборка.БизнесПроцесс;
				МенеджерЗаписи.Прочитать();
				МенеджерЗаписи.ДатаПоследнегоПовторения = ТекущаяДата;
				МенеджерЗаписи.Записать();
			КонецЕсли;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(Расписание.ДатаКонца) И ТекущаяДата > Расписание.ДатаКонца Тогда 
			МенеджерЗаписи = РегистрыСведений.НастройкаПовторенияБизнесПроцессов.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.БизнесПроцесс = Выборка.БизнесПроцесс;
			МенеджерЗаписи.Прочитать();
			МенеджерЗаписи.ПовторениеЗавершено = Истина;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает представление расписания в удобном для чтения виде
//
// Параметры:
//   Расписание - РасписаниеРегламентногоЗадания - расписание повторения процесса
//   ГрафикРаботы - СправочникСсылка.ГрафикиРаботы - график работы по которому происходит
//                  повторение процесса
//
// Возвращаемое значение:
//   Строка
//
Функция ПолучитьПредставлениеРасписания(Знач Расписание, ГрафикРаботы) Экспорт
	
	Если Расписание = Неопределено Тогда 
		Возврат НСтр("ru = 'Расписание не задано'");
	КонецЕсли;	
	
	ПредставлениеРасписания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполнять с %1'"),
		Формат(Расписание.ДатаНачала, "ДФ=dd.MM.yyyy"));
	
	Если ЗначениеЗаполнено(Расписание.ДатаКонца) Тогда 
		ПредставлениеРасписания = ПредставлениеРасписания + 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = ' по %1'"),
			Формат(Расписание.ДатаКонца, "ДФ=dd.MM.yyyy"));
	КонецЕсли;
	
	ПредставлениеРасписания = ПредставлениеРасписания + 
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = ' в %1'"), 
		Формат(Расписание.ВремяНачала, "ДФ=ЧЧ:мм; ДП=00:00"));
	
	Если Расписание.ДниНедели.Количество() > 0 Тогда  
		
		Если Расписание.ПериодНедель = 1 Тогда
			ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = ' еженедельно в '");
		Иначе
			ПредставлениеНедель = ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
				Расписание.ПериодНедель, 
				НСтр("ru = 'неделю'") + "," + НСтр("ru = 'недели'") + "," + НСтр("ru = 'недель'"));
			
			ПредставлениеКаждый = ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
				Расписание.ПериодНедель,
				НСтр("ru = 'каждую'") + "," + НСтр("ru = 'каждые'") + "," + НСтр("ru = 'каждые'"));
				
			ПредставлениеРасписания = ПредставлениеРасписания
				+ " " + ПредставлениеКаждый
				+ " " + Расписание.ПериодНедель
				+ " " + ПредставлениеНедель
				+ НСтр("ru = ' в '");
			
		КонецЕсли;
		
		Для Каждого ДеньНедели Из Расписание.ДниНедели Цикл
			Если ДеньНедели = 1 Тогда 
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'понедельник, '");
			КонецЕсли;
			Если ДеньНедели = 2 Тогда
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'вторник, '");
			КонецЕсли;
			Если ДеньНедели = 3 Тогда
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'среда, '");
			КонецЕсли;
			Если ДеньНедели = 4 Тогда
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'четверг, '");
			КонецЕсли;
			Если ДеньНедели = 5 Тогда
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'пятница, '");
			КонецЕсли;
			Если ДеньНедели = 6 Тогда
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'суббота, '");
			КонецЕсли;
			Если ДеньНедели = 7 Тогда
				ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'воскресенье, '");
			КонецЕсли;
		КонецЦикла;	
		ПредставлениеРасписания = Лев(ПредставлениеРасписания, СтрДлина(ПредставлениеРасписания)-2);
		
	ИначеЕсли Расписание.ДеньВМесяце <> 0 Тогда 
		
		Если Расписание.Месяцы.Количество() > 0 Тогда
			
			ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = ' в '");
			
			Для Каждого Месяц Из Расписание.Месяцы Цикл
				Если Месяц = 1 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'янв, '");
				КонецЕсли;
				Если Месяц = 2 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'фев, '");
				КонецЕсли;
				Если Месяц = 3 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'мар, '")  КонецЕсли;
				Если Месяц = 4 Тогда ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'апр, '");
				КонецЕсли;
				Если Месяц = 5 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'май, '");
				КонецЕсли;
				Если Месяц = 6 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'июн, '");
				КонецЕсли;
				Если Месяц = 7 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'июл, '");
				КонецЕсли;
				Если Месяц = 8 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'авг, '");
				КонецЕсли;
				Если Месяц = 9 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'сен, '");
				КонецЕсли;
				Если Месяц = 10 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'окт, '");
				КонецЕсли;
				Если Месяц = 11 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'ноя, '");
				КонецЕсли;
				Если Месяц = 12 Тогда
					ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = 'дек, '");
				КонецЕсли;
			КонецЦикла;
			
		Иначе
			ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = ' ежемесячно '");
		КонецЕсли;
		
		Если Расписание.ДеньВМесяце > 0 Тогда 
			ПредставлениеРасписания = ПредставлениеРасписания
				+ Строка(Расписание.ДеньВМесяце)
				+ НСтр("ru = '-го числа месяца'");
		Иначе
			ПредставлениеРасписания = ПредставлениеРасписания
				+ Строка(-Расписание.ДеньВМесяце)
				+ НСтр("ru = '-го дня месяца с конца'");
		КонецЕсли;
		
	Иначе
		
		Если Расписание.ПериодПовтораДней = 1 Тогда
			ПредставлениеРасписания = ПредставлениеРасписания + НСтр("ru = ' ежедневно'");
		Иначе
		
			ПредставлениеДней = ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
				Расписание.ПериодПовтораДней, 
				НСтр("ru = 'день'") + "," + НСтр("ru = 'дня'") + "," + НСтр("ru = 'дней'"));
			
			ПредставлениеКаждый = ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
				Расписание.ПериодПовтораДней,
				НСтр("ru = 'каждый'") + "," + НСтр("ru = 'каждые'") + "," + НСтр("ru = 'каждые'"));
				
			ПредставлениеРасписания = ПредставлениеРасписания
				+ " " + ПредставлениеКаждый
				+ " " + Расписание.ПериодПовтораДней
				+ " " + ПредставлениеДней;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы")
		И ЗначениеЗаполнено(ГрафикРаботы) Тогда
		
		ОписаниеГрафикаРабот = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = ' по графику работ: ""%1""'"),
			ГрафикРаботы);
		ПредставлениеРасписания = ПредставлениеРасписания + ОписаниеГрафикаРабот;
	КонецЕсли;
	
	Возврат ПредставлениеРасписания;
	
КонецФункции	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Создает новый процесс по основанию, от заданной даты.
//
// Параметры:
//   ТекущаяДата - Дата - дата и время создания нового процесса.
//   БизнесПроцессОснование - БизнесПроцессСсылка - ссылка на процесс Основание
//
// Возвращаемое значение:
//   Булево - если процесс создан успешно возвращается Истина, иначе формируется
//            уведомление пользователю, пишется запись в журнал регистрации и
//            возвращается Ложь.
//
Функция ПовторитьБизнесПроцесс(ТекущаяДата, БизнесПроцессОснование)
	
	Результат = Истина;
	ТекстСообщения = "";
	
	НачатьТранзакцию();
	Попытка
		
		НовыйБизнесПроцесс = БизнесПроцессОснование.Скопировать();
		НовыйБизнесПроцесс.Дата = ТекущаяДата;
		НовыйБизнесПроцесс.Автор = БизнесПроцессОснование.Автор;
		
		Если БизнесПроцессОснование.Метаданные().Реквизиты.Найти("СрокИсполнения") <> Неопределено Тогда
			
			Если ТипЗнч(БизнесПроцессОснование) <> Тип("БизнесПроцессСсылка.Согласование")
				И ЗначениеЗаполнено(БизнесПроцессОснование.СрокИсполнения) Тогда
				
				НовыйБизнесПроцесс.СрокИсполнения = ВычислитьСрокИсполнения(
					НовыйБизнесПроцесс.Дата,
					БизнесПроцессОснование.СрокИсполнения,
					БизнесПроцессОснование.Дата);
			КонецЕсли;	
			
			Если ТипЗнч(БизнесПроцессОснование) = Тип("БизнесПроцессСсылка.Исполнение") Тогда
				
				Для Каждого Строка Из БизнесПроцессОснование.Исполнители Цикл
					Инд = БизнесПроцессОснование.Исполнители.Индекс(Строка);
					НоваяСтрока = НовыйБизнесПроцесс.Исполнители[Инд];
					
					Если ЗначениеЗаполнено(Строка.СрокИсполнения) Тогда 
						НоваяСтрока.СрокИсполнения = ВычислитьСрокИсполнения(
							НовыйБизнесПроцесс.Дата,
							Строка.СрокИсполнения,
							БизнесПроцессОснование.Дата);
					КонецЕсли;	
				КонецЦикла;	
				
			КонецЕсли;	
				
		КонецЕсли;
		
		НовыйБизнесПроцесс.Записать();
		НовыйБизнесПроцесс.Старт();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При автоматическом повторении процесса произошла ошибка: %1.'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		УровеньВажностиСобытия = УровеньЖурналаРегистрации.Ошибка;
		
		Результат = Ложь;
		
		РаботаСУведомлениямиПрограммыСервер.ДобавитьУведомление(
			ТекущаяДатаСеанса(),
			ТекстСообщения,
			Перечисления.ВидыУведомленийПрограммы.Ошибка,
			БизнесПроцессОснование.Автор,
			БизнесПроцессОснование);
		
	КонецПопытки;	
	
	Если ПустаяСтрока(ТекстСообщения) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выполнено повторение процесса. Сформирован новый процесс %1.'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			Строка(НовыйБизнесПроцесс));
		УровеньВажностиСобытия = УровеньЖурналаРегистрации.Информация;
	КонецЕсли;	
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Повторение процессов.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньВажностиСобытия, 
		БизнесПроцессОснование.Метаданные(),
		БизнесПроцессОснование, 
		ТекстСообщения);
		
	Возврат Результат;
	
КонецФункции

// Вычисляет срок исполнения для нового бизнес-процесса относительно даты старта нового процесса
// по сроку и дате процесса основания.
//
// Параметры:
//   ДатаНовогоБизнесПроцесса - Дата
//   СрокОснования - Дата
//   ДатаОснования - Дата
//
// Возвращаемое значение:
//   Дата
//
Функция ВычислитьСрокИсполнения(ДатаНовогоБизнесПроцесса, СрокОснования, ДатаОснования)
	
	ИспользоватьДатуИВремяВСрокахЗадач = 
		ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	
	Если Не ИспользоватьДатуИВремяВСрокахЗадач Тогда 
		ДлительностьДн = НачалоДня(СрокОснования) - НачалоДня(ДатаОснования);
		Возврат КонецДня(ДатаНовогоБизнесПроцесса + ДлительностьДн);
	Иначе
		Если НачалоДня(СрокОснования) = НачалоДня(ДатаОснования) Тогда 
			ДлительностьСек = СрокОснования - ДатаОснования;
			Возврат ДатаНовогоБизнесПроцесса + ДлительностьСек;
		Иначе	
			ДлительностьДн = НачалоДня(СрокОснования) - НачалоДня(ДатаОснования);
			ДлительностьСек = СрокОснования - НачалоДня(СрокОснования);
			Возврат НачалоДня(ДатаНовогоБизнесПроцесса) + ДлительностьДн + ДлительностьСек;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции	

#КонецОбласти




