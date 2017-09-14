#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ТемыОбсуждений") Тогда
		ТемаЗаполнения = ДанныеЗаполнения;
		ПервоеСообщениеТемыЗаполнения = РаботаСОбсуждениями.НайтиПервоеСообщениеТемы(ТемаЗаполнения);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПервоеСообщениеТемыЗаполнения,
			"ТекстСообщения, ВопросГолосования, ДобавленоГолосование");
		ВариантыГолосования.Загрузить(ПервоеСообщениеТемыЗаполнения.ВариантыГолосования.Выгрузить());
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ПервоеСообщениеТемы Тогда
		ТемаЗакрыта = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ВладелецСообщения, "Закрытая");
		Если ТемаЗакрыта Тогда
			Отказ = Истина;
			Текст = НСтр("ru = 'Невозможно произвести запись сообщения в закрытую тему.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Объект.ТекстСообщения");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ДобавленоГолосование Тогда
		
		Если ВариантыГолосования.Количество() = 1 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Нужно указать хотя бы два варианта ответа голосования'"),,
					"ВариантыГолосования",
					"Объект",
					Отказ);
		КонецЕсли;
		
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ВопросГолосования");
		МассивНепроверяемыхРеквизитов.Добавить("ВариантыГолосования");
		МассивНепроверяемыхРеквизитов.Добавить("ВариантыГолосования.ТекстВарианта");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель)
		И ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	ПометкаИБ = ПометкаУдаленияВИБ();
	ОбновленоСообщение = Ложь;
	
	РабочаяГруппаДобавить = Неопределено;
	РабочаяГруппаУдалить = Неопределено;
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаДобавить") Тогда
		РабочаяГруппаДобавить = ДополнительныеСвойства.РабочаяГруппаДобавить;
	КонецЕсли;
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаУдалить") Тогда
		РабочаяГруппаУдалить = ДополнительныеСвойства.РабочаяГруппаУдалить;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		
		Если ДополнительныеСвойства.Свойство("СозданиеНовойТемы")
				И ДополнительныеСвойства.Свойство("РеквизитыТемы")
				И ДополнительныеСвойства.СозданиеНовойТемы Тогда
			
			РеквизитыТемы = ДополнительныеСвойства.РеквизитыТемы;
			ПредметТемы = РеквизитыТемы.Документ;
			
			ЕстьТемаПоПредмету = Ложь;
			Если ЗначениеЗаполнено(ПредметТемы) Тогда
				ТемаПоПредмету = РаботаСОбсуждениями.НайтиТемуПоПредмету(ПредметТемы);
				ЕстьТемаПоПредмету = ЗначениеЗаполнено(ТемаПоПредмету);
			КонецЕсли;
			
			Если ЕстьТемаПоПредмету Тогда
				ВладелецСообщения = ТемаПоПредмету;
				ПервоеСообщениеТемы = Ложь;
			Иначе
				ВладелецСообщения = Справочники.ТемыОбсуждений.СоздатьНовуюТему(
					РеквизитыТемы, Автор, РабочаяГруппаДобавить, РабочаяГруппаУдалить);
			КонецЕсли;
			
		КонецЕсли;
		
		ДополнительныеСвойства.Вставить("ОбновленоСообщение", Истина);
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
		
		ДатаСоздания = ТекущаяДатаСеанса();
		НомерСообщения = РаботаСОбсуждениями.ПосчитатьНомерНовогоСообщения(ВладелецСообщения);
		Наименование = РаботаСОбсуждениями.ПолучитьЗаголовок(ТекстСообщения);
		УстановитьТекстСписка();
		
		Если ПервоеСообщениеТемы  Тогда
			Если ЕстьПервоеСообщенияТемы(ВладелецСообщения) Тогда
				ПервоеСообщениеТемы = Ложь;
			Иначе
				ИзменитьАвтораТемы(ВладелецСообщения);
			КонецЕсли;
		Иначе
			Если Не ЕстьПервоеСообщенияТемы(ВладелецСообщения) Тогда
				ИзменитьАвтораТемы(ВладелецСообщения);
				ПервоеСообщениеТемы = Истина;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ПометкаУдаления <> ПометкаИБ Тогда
		
		ДополнительныеСвойства.Вставить("ОбновленоСообщение", Ложь);
		Попытка
			РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Ссылка, ПометкаУдаления);
		Исключение
			Инфо = ИнформацияОбОшибке();
			ВызватьИсключение (Инфо.Описание);
		КонецПопытки;
		
		Если ПервоеСообщениеТемы Тогда
			Если ПометкаУдаления <> ВладелецСообщения.ПометкаУдаления Тогда
				// Попытка заблокировать первое сообщение, если удаляем из списка.
				УстановитьПривилегированныйРежим(Истина);
				Попытка
					ЭтотОбъект.Заблокировать();
				Исключение
					// Если уже заблокировано, значит работаем из карточки сообщения.	
				КонецПопытки;
				ВладелецОбъект = ВладелецСообщения.ПолучитьОбъект();
				ВладелецОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
			КонецЕсли;
		ИначеЕсли ПометкаУдаления = Истина И ВладелецСообщения.ПометкаУдаления <> Истина Тогда
			// Очищаем у сообщений, дочерних к помеченной, ссылку на родительскую - 
			// переставляем на родительское сообщение удаляемой версии
			УстановитьПривилегированныйРежим(Истина);
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	СообщенияОбсуждений.Ссылка КАК Ссылка
				|ИЗ
				|	Справочник.СообщенияОбсуждений КАК СообщенияОбсуждений
				|ГДЕ
				|	СообщенияОбсуждений.Родитель = &Родитель";	
			Запрос.УстановитьПараметр("Родитель", Ссылка);
			Результат = Запрос.Выполнить();
			Если Не Результат.Пустой() Тогда
				Выборка = Результат.Выбрать();
				Пока Выборка.Следующий() Цикл
					Объект = Выборка.Ссылка.ПолучитьОбъект();
					ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка);
					Объект.Родитель = Родитель;
					Объект.Записать();
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ТекстСообщения <> ТекстСообщенияВИБ() Тогда
		
		// Только в случае изменения текста сообщения меняем дату сообщения и просмотр
		ДополнительныеСвойства.Вставить("ОбновленоСообщение", Истина);
		ДатаИзменения = ТекущаяДатаСеанса();
		Наименование = РаботаСОбсуждениями.ПолучитьЗаголовок(ТекстСообщения);
		УстановитьТекстСписка();
		
	КонецЕсли;
	
	Если Не ЭтоНовый() И ПервоеСообщениеТемы
		И (ЗначениеЗаполнено(РабочаяГруппаДобавить) Или ЗначениеЗаполнено(РабочаяГруппаУдалить)) Тогда
		
		ВладелецОбъект = ВладелецСообщения.ПолучитьОбъект();
		
		Если ЗначениеЗаполнено(РабочаяГруппаДобавить) Тогда
			ВладелецОбъект.ДополнительныеСвойства.Вставить("РабочаяГруппаДобавить", РабочаяГруппаДобавить);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РабочаяГруппаУдалить) Тогда
			ВладелецОбъект.ДополнительныеСвойства.Вставить("РабочаяГруппаУдалить", РабочаяГруппаУдалить);
		КонецЕсли;
		
		ВладелецОбъект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель)
		И ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОбновленоСообщение")
			И ДополнительныеСвойства.ОбновленоСообщение Тогда	
		РаботаСПрочтениями.УстановитьОбъектКакНеПрочитанный(Ссылка);	
	КонецЕсли;
	
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		Если ДополнительныеСвойства.Свойство("ЭтоНовый") И ДополнительныеСвойства.ЭтоНовый Тогда
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеСообщения);	
		КонецЕсли;
	КонецЕсли;
	
	РаботаСПрочтениями.ОбновитьПрочтениеГруппы(Ссылка);
	
	РаботаСОбсуждениями.ОбновитьИнформациюОТеме(ВладелецСообщения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПометкаУдаленияВИБ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СообщенияОбсуждений.ПометкаУдаления КАК ПометкаУдаления
		|ИЗ
		|	Справочник.СообщенияОбсуждений КАК СообщенияОбсуждений
		|ГДЕ
		|	СообщенияОбсуждений.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
    	Возврат Неопределено;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ПометкаУдаления;
	
КонецФункции

Функция ТекстСообщенияВИБ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СообщенияОбсуждений.ТекстСообщения
		|ИЗ
		|	Справочник.СообщенияОбсуждений КАК СообщенияОбсуждений
		|ГДЕ
		|	СообщенияОбсуждений.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
    	Возврат Неопределено;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ТекстСообщения;
	
КонецФункции

Процедура УстановитьТекстСписка()
	
	ДлинаСтрокиСписок = 110;
	ДлинаТекстаСписок = 3*ДлинаСтрокиСписок + 10; 
	
	//Удаление незначащих символов слева и справа
	ВременныйТекстСообщенияСписок = СокрЛП(ТекстСообщения);
	
	//Удаление переносов строк
	ВременныйТекстСообщенияСписок = СтрЗаменить(ВременныйТекстСообщенияСписок, Символы.ПС, " ");
	
	//Удаление двойных пробелов
	ПозицияДвойногоПробела = Найти(ВременныйТекстСообщенияСписок, " " + " ");
	Пока ПозицияДвойногоПробела > 0 Цикл
		ВременныйТекстСообщенияСписокПрав = Сред(ВременныйТекстСообщенияСписок, ПозицияДвойногоПробела);
		ВременныйТекстСообщенияСписокПрав = сокрЛ(ВременныйТекстСообщенияСписокПрав);
		ВременныйТекстСообщенияСписокЛев = Лев(ВременныйТекстСообщенияСписок, ПозицияДвойногоПробела);
		ВременныйТекстСообщенияСписок = ВременныйТекстСообщенияСписокЛев + ВременныйТекстСообщенияСписокПрав;
		ПозицияДвойногоПробела = Найти(ВременныйТекстСообщенияСписок, " " + " ");
	КонецЦикла;
	
	ПозицияПробела = СтрДлина(ВременныйТекстСообщенияСписок);
	ПредыдущаяПозицияПробела = ПозицияПробела;
	Пока ПозицияПробела > 0 Цикл
		Пока ПозицияПробела > 0 Цикл
			Если Сред(ВременныйТекстСообщенияСписок, ПозицияПробела, 1) = " " Тогда 
				Прервать;
			КонецЕсли;	
			ПозицияПробела = ПозицияПробела - 1;
		КонецЦикла;
		
		Если (ПредыдущаяПозицияПробела - ПозицияПробела) > ДлинаСтрокиСписок Тогда
			ВременныйТекстСообщенияСписок = 
				Лев(ВременныйТекстСообщенияСписок, ПозицияПробела) 
				+ Сред(ВременныйТекстСообщенияСписок, ПозицияПробела + 1, ДлинаСтрокиСписок - 1) 
				+ "... " 
				+ Сред(ВременныйТекстСообщенияСписок, ПредыдущаяПозицияПробела + 1);  		
		КонецЕсли;
		
		ПредыдущаяПозицияПробела = ПозицияПробела;
		ПозицияПробела = ПозицияПробела - 1;
	КонецЦикла;
	
	Если СтрДлина(ВременныйТекстСообщенияСписок) > ДлинаТекстаСписок Тогда
		ТекстСообщенияСписок = ЛЕВ(ВременныйТекстСообщенияСписок, ДлинаТекстаСписок - 3) + "...";
	Иначе
		ТекстСообщенияСписок = ВременныйТекстСообщенияСписок;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьАвтораТемы(Тема)
	
	УстановитьПривилегированныйРежим(Истина);
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	
	ТемаОбъект = Тема.ПолучитьОбъект();
	Если Автор <> ТемаОбъект.Автор Тогда
		ТемаОбъект.Заблокировать();
		ТемаОбъект.Автор = Автор;
		ТемаОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

Функция ЕстьПервоеСообщенияТемы(Тема)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СообщенияОбсуждений.Ссылка
		|ИЗ
		|	Справочник.СообщенияОбсуждений КАК СообщенияОбсуждений
		|ГДЕ
		|	СообщенияОбсуждений.ВладелецСообщения = &Тема
		|	И СообщенияОбсуждений.ПервоеСообщениеТемы = ИСТИНА";

	Запрос.УстановитьПараметр("Тема", Тема);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
    Выборка.Следующий();
	Если ЗначениеЗаполнено(Выборка.Ссылка) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецЕсли