Функция ПолучитьСписокДоступныхФункций() Экспорт
	
	ДоступныеФункции = ШаблоныДокументовПереопределяемый.ПолучитьСписокДоступныхФункций();
	
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.ТекущийПользователь()",
		НСтр("ru = 'Текущий пользователь'"));
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.НепосредственныйРуководительТекущегоПользователя()",
		НСтр("ru = 'Непосредственный руководитель текущего пользователя'"));
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.ВсеРуководителиТекущегоПользователя()",
		НСтр("ru = 'Все руководители текущего пользователя'"));
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.ВсеПодчиненныеТекущегоПользователя()",
		НСтр("ru = 'Все подчиненные текущего пользователя'"));
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.РуководительОрганизации(Объект)",
		НСтр("ru = 'Руководитель организации'"));
	ДоступныеФункции.Добавить(
		"ШаблоныДокументов.ОтветственныйЗаДокумент(Объект)",
		НСтр("ru = 'Ответственный за документ'"));
	
	Возврат ДоступныеФункции;
	
КонецФункции

Функция ПолучитьЗначениеАвтоподстановки(Автоподстановка, Объект) Экспорт
	
	ФункцияАвтоподстановки = "";
	
	СписокФункций = ПолучитьСписокДоступныхФункций();
	Для Инд = 0 По СписокФункций.Количество() - 1 Цикл
		Если СписокФункций[Инд].Представление = Автоподстановка Тогда 
			ФункцияАвтоподстановки = СписокФункций[Инд].Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;	
	
	Если ФункцияАвтоподстановки = "" Тогда 
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не определена автоподстановка %1'"), Автоподстановка);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	РезультатФункции = Неопределено;
	Попытка
		Выполнить("РезультатФункции = " + ФункцияАвтоподстановки);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при выполнении автоподстановки %1:
			|%2'"), Автоподстановка, ИнформацияОбОшибке().Описание);
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
	
	Если (ТипЗнч(РезультатФункции) = Тип("СправочникСсылка.Пользователи") И ЗначениеЗаполнено(РезультатФункции)) Или
		 (ТипЗнч(РезультатФункции) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(РезультатФункции)) Или
		 (ТипЗнч(РезультатФункции) = Тип("Структура")) Или
		 (ТипЗнч(РезультатФункции) = Тип("Массив") И РезультатФункции.Количество() > 0) Тогда 
		Возврат РезультатФункции;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции	

Функция ТекущийПользователь() Экспорт
	
	Возврат ПараметрыСеанса.ТекущийПользователь;

КонецФункции

Функция НепосредственныйРуководительТекущегоПользователя() Экспорт 
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователях.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|ГДЕ
	|	СведенияОПользователях.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", ТекущийПользователь);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Подразделение = Выборка.Подразделение;
	Если Подразделение.Руководитель <> ТекущийПользователь Тогда 
		Возврат Подразделение.Руководитель;
	КонецЕсли;		
	
	Пока Подразделение.Родитель <> Неопределено Цикл
		Подразделение = Подразделение.Родитель;
		Если Подразделение.Руководитель <> ТекущийПользователь Тогда 
			Возврат Подразделение.Руководитель;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат Подразделение.Руководитель;	
	
КонецФункции	

Функция ВсеРуководителиТекущегоПользователя() Экспорт
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	МассивРуководителей = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователях.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|ГДЕ
	|	СведенияОПользователях.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", ТекущийПользователь);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат МассивРуководителей;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Подразделение = Выборка.Подразделение;
	
	Пока ЗначениеЗаполнено(Подразделение) Цикл
		Руководитель = Подразделение.Руководитель;
		Если ЗначениеЗаполнено(Руководитель) И Руководитель <> ТекущийПользователь И Не Руководитель.Недействителен Тогда 
			МассивРуководителей.Добавить(Руководитель);
		КонецЕсли;	
		
		Подразделение = Подразделение.Родитель;
	КонецЦикла;
	
	Возврат МассивРуководителей;
	
КонецФункции

Функция ВсеПодчиненныеТекущегоПользователя() Экспорт
	
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СведенияОПользователях.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|ГДЕ
	|	СведенияОПользователях.Подразделение В ИЕРАРХИИ
	|			(ВЫБРАТЬ
	|				Справочник.СтруктураПредприятия.Ссылка
	|			ИЗ
	|				Справочник.СтруктураПредприятия
	|			ГДЕ
	|				Справочник.СтруктураПредприятия.Руководитель = &Руководитель)
	|	И СведенияОПользователях.Пользователь <> &Руководитель
	|	И НЕ СведенияОПользователях.Пользователь.Недействителен";
	Запрос.УстановитьПараметр("Руководитель", ТекущийПользователь);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
	
КонецФункции	

Функция РуководительОрганизации(ДокументОбъект) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда 
		Возврат Константы.РуководительПредприятия.Получить();
	КонецЕсли;	
		
	Если ТипЗнч(ДокументОбъект.Ссылка) <> Тип("СправочникСсылка.ИсходящиеДокументы")
	   И ТипЗнч(ДокументОбъект.Ссылка) <> Тип("СправочникСсылка.ВнутренниеДокументы")
	   И ТипЗнч(ДокументОбъект.Ссылка) <> Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
		 Возврат Справочники.Пользователи.ПустаяСсылка();
	 КонецЕсли;	  
	 
	Если Не ЗначениеЗаполнено(ДокументОбъект.Организация) Тогда 
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;	
	
	Организация = ДокументОбъект.Организация;
	Если Не ЗначениеЗаполнено(Организация) Тогда 
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.РуководительОрганизации;
	
	Отбор = Новый Структура("Организация, ОтветственноеЛицо", Организация, ОтветственноеЛицо);
	Возврат РегистрыСведений.ОтветственныеЛицаОрганизаций.
		ПолучитьПоследнее(ДокументОбъект.ДатаСоздания, Отбор).Пользователь;
	
КонецФункции

Функция ОтветственныйЗаДокумент(ДокументОбъект) Экспорт
	
	Если ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы") Или 
		 ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы") Или 
		 ТипЗнч(ДокументОбъект.Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда 
		
		Возврат ДокументОбъект.Ответственный;
		
	КонецЕсли;
	
	Возврат Справочники.Пользователи.ПустаяСсылка();
	
КонецФункции
