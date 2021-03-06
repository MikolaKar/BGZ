#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат 
		"Ссылка,
		|ГрифДоступа,
		|Организация,
		|Руководитель";
	
КонецФункции

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ГрифДоступа = ОбъектДоступа.ГрифДоступа;
	ДескрипторДоступа.Организация = ОбъектДоступа.Организация;
	
	ДескрипторДоступа.ДобавитьПользователя("РуководительПроекта", ОбъектДоступа.Руководитель);
	
	// Рабочая группа
	РабочаяГруппа = РаботаСРабочимиГруппами.ПолучитьРабочуюГруппуДокумента(ОбъектДоступа.Ссылка);
	Для каждого Эл Из РабочаяГруппа Цикл
		Строка = ДескрипторДоступа.РабочаяГруппа.Добавить();
		Строка.Участник = Эл.Участник;
		Строка.ОсновнойОбъектАдресации = Эл.ОсновнойОбъектАдресации;
		Строка.ДополнительныйОбъектАдресации = Эл.ДополнительныйОбъектАдресации;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает Истина, указывая тем самым, что этот объект сам заполняет свои права 
Функция ЕстьМетодЗаполнитьПраваДоступа() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет параметр ПраваДоступа правами доступа, вычисляя их на 
// основании переданного дескриптора доступа.
// Если указан параметр ПротоколРасчетаПрав, то в него 
// заносится список данных, которые были использованы для расчета прав.
Процедура ЗаполнитьПраваДоступа(ДескрипторДоступа, ПраваДоступа, ПротоколРасчетаПрав) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Справочники.ДескрипторыДоступаОбъектов.ЗаполнитьПраваДоступаСтандартно(
		ДескрипторДоступа, 
		ПраваДоступа, 
		ПротоколРасчетаПрав);
		
	
	// Добавление рабочей группы или всех пользователей
	Если ДескрипторДоступа.РабочаяГруппа.Количество() > 0 Тогда
		
		// Добавление рабочей группы проекта в протокол расчета прав
		Если ПротоколРасчетаПрав <> Неопределено Тогда
			ПротоколРасчетаПрав.Добавить(НСтр("ru = 'Рабочая группа проекта'"));
		КонецЕсли;
		
		НовыеПраваДоступа = Новый Соответствие;
		
		Для каждого Эл Из ДескрипторДоступа.РабочаяГруппа Цикл
			
			Если ТипЗнч(Эл.Участник) = Тип("СправочникСсылка.Пользователи") Тогда
				
				НайденноеЗначение = ПраваДоступа.Получить(Эл.Участник);
				Если НайденноеЗначение <> Неопределено Тогда
					
					ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами",
													Истина, Ложь, Ложь, Ложь, Ложь);
													
					ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
						НовыеПраваДоступа,
						Эл.Участник,
						Неопределено,
						Неопределено,
						ПраваПользователя);
							
				КонецЕсли;		
				
			ИначеЕсли ТипЗнч(Эл.Участник) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
				
				// Обходим всех пользователей группы
				СоставГруппы = ДокументооборотПраваДоступаПовтИсп.ПолучитьСоставГруппыПользователей(Эл.Участник);
				Для каждого ЭлГруппы Из СоставГруппы Цикл
					
					НайденноеЗначение = ПраваДоступа.Получить(ЭлГруппы.Пользователь);
					Если НайденноеЗначение <> Неопределено Тогда
						
						ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами",
														Истина, Ложь, Ложь, Ложь, Ложь);
														
						ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
							НовыеПраваДоступа,
							ЭлГруппы.Пользователь,
							Неопределено,
							Неопределено,
							ПраваПользователя);
							
					КонецЕсли;	
				КонецЦикла;
				
			ИначеЕсли ТипЗнч(Эл.Участник) = Тип("СправочникСсылка.РолиИсполнителей") Тогда	
				
				// Обходим всех исполнителей роли
				ИсполнителиРоли = РегистрыСведений.ИсполнителиЗадач.ПолучитьИсполнителейРоли(Эл.Участник, Эл.ОсновнойОбъектАдресации, Эл.ДополнительныйОбъектАдресации);
				Для каждого ИсполнительРоли Из ИсполнителиРоли Цикл
					
					НайденноеЗначение = ПраваДоступа.Получить(ИсполнительРоли.Исполнитель);
					Если НайденноеЗначение <> Неопределено Тогда
							
						ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами",
														Истина, Ложь, Ложь, Ложь, Ложь);
														
						ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
							НовыеПраваДоступа,
							ИсполнительРоли.Исполнитель,
							Неопределено,
							Неопределено,
							ПраваПользователя);
							
					КонецЕсли;	
						
				КонецЦикла;
			КонецЕсли;	
		КонецЦикла;	
		
		ПраваДоступа = НовыеПраваДоступа;
		
	Иначе
		
		НовыеПраваДоступа = Новый Соответствие;
		Для каждого Эл Из ПраваДоступа Цикл
			
			ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами",
											Истина, Ложь, Ложь, Ложь, Ложь);
										
			ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
				НовыеПраваДоступа,
				Эл.Ключ,
				Неопределено,
				Неопределено,
				ПраваПользователя);
				
		КонецЦикла;
		
		ПраваДоступа = НовыеПраваДоступа;
			
	КонецЕсли;
		
	// Добавление руководителя проекта
	Для каждого Эл Из ДескрипторДоступа.Пользователи Цикл
		
		Если Эл.Ключ = "РуководительПроекта" Тогда
			
			УчастникиДобавлены = Истина;
			
			ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами",
											Истина, Истина, Истина, Истина, Ложь);
											
			ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
				ПраваДоступа,
				Эл.Пользователь,
				Эл.ОсновнойОбъектАдресации,
				Эл.ДополнительныйОбъектАдресации,
				ПраваПользователя);
				
			// Добавление руководителя проекта к протоколу расчета прав
			Если ПротоколРасчетаПрав <> Неопределено Тогда
				ПротоколРасчетаПрав.Добавить(НСтр("ru = 'Руководитель проекта'"));
			КонецЕсли;	
			
		Иначе
			
			ВызватьИсключение НСтр("ru = 'Неизвестный ключ пользователя.'");
			
		КонецЕсли;	
			
	КонецЦикла;	
	
КонецПроцедуры

// Конец УправлениеДоступом


// Возвращает признак наличия метода ДобавитьУчастниковВТаблицу у менеджера объекта
//
Функция ЕстьМетодДобавитьУчастниковВТаблицу() Экспорт
	Возврат Истина;
КонецФункции

// Добавляет участников документа в переданную таблицу
//
Процедура ДобавитьУчастниковВТаблицу(ТаблицаНабора, Проект) Экспорт
	
	Для Каждого ЧленКоманды Из Проект.ПроектнаяКоманда Цикл
		Если ТипЗнч(ЧленКоманды.Исполнитель) = Тип("СправочникСсылка.Пользователи")
			ИЛИ ТипЗнч(ЧленКоманды.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
			
			РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(
				ТаблицаНабора, 
				ЧленКоманды.Исполнитель,
				ЧленКоманды.ОсновнойОбъектАдресации,
				ЧленКоманды.ДополнительныйОбъектАдресации);	
			
		КонецЕсли;	
	КонецЦикла;
	
	Если ТипЗнч(Проект) = Тип("СправочникСсылка.Проекты") Тогда 
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Проект, "Руководитель"));
	Иначе 
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Проект.Руководитель);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает имя предмета процесса по умолчанию
//
Функция ПолучитьИмяПредметаПоУмолчанию(Ссылка) Экспорт
	
	Возврат НСтр("ru='Проект'");
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
    // Устанавливаем признак доступности печати по-комплектно
    ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
    Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Карточка") Тогда

        // Формируем табличный документ и добавляем его в коллекцию печатных форм
        УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
            "Карточка", "Проект", ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));	
			
	КонецЕсли;
		
КонецПроцедуры

Функция ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ИспользоватьДополнительныеРеквизитыИСведения = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения");
	
	// Создаем табличный документ и устанавливаем имя параметров печати
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_КарточкаСообщения";
	
	Макет = Справочники.Проекты.ПолучитьМакет("Карточка");
	ОбластьПроектШапка = Макет.ПолучитьОбласть("ПроектШапка");
	
	ПервыйДокумент = Истина;
	
	Для Каждого ОбъектПечати Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		// Запомним номер строки с которой начали выводить текущий документ
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;		
		
		// Заполнение шапки проекта
		ОбластьПроектШапка.Параметры.Наименование = ОбъектПечати.Наименование + " (" + ТипЗнч(ОбъектПечати) + ")";
		ОбластьПроектШапка.Параметры.Описание = ОбъектПечати.Описание;
		ОбластьПроектШапка.Параметры.РуководительПроекта = ОбъектПечати.Руководитель;
		ОбластьПроектШапка.Параметры.Заказчик = ОбъектПечати.Заказчик;
		ОбластьПроектШапка.Параметры.Начало = ОбъектПечати.ТекущийПланНачало;
		ОбластьПроектШапка.Параметры.Окончание = ОбъектПечати.ТекущийПланОкончание;
		ОбластьПроектШапка.Параметры.Трудозатраты = Строка(ОбъектПечати.ТекущийПланТрудозатраты);
		ОбластьПроектШапка.Параметры.Гриф = ОбъектПечати.ГрифДоступа;
		ОбластьПроектШапка.Параметры.Состояние = ОбъектПечати.Состояние;
		ОбластьПроектШапка.Параметры.Вид = ОбъектПечати.ВидПроекта;
		ОбластьПроектШапка.Параметры.Организация = ОбъектПечати.Организация;
		
		ТабличныйДокумент.Вывести(ОбластьПроектШапка);
		
		// Проектная команда
		Если ОбъектПечати.ПроектнаяКоманда.Количество() > 0 Тогда
			ОбластьКомандаШапка = Макет.ПолучитьОбласть("ПроектнаяКомандаШапка");
			ТабличныйДокумент.Вывести(ОбластьКомандаШапка);
			Для Каждого УчастникПроекта Из ОбъектПечати.ПроектнаяКоманда Цикл
				ОбластьКомандаСтрока = Макет.ПолучитьОбласть("ПроектнаяКомандаУчастник");
				Если ТипЗнч(УчастникПроекта.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
					Если ЗначениеЗаполнено(УчастникПроекта.ОсновнойОбъектАдресации)
						И ЗначениеЗаполнено(УчастникПроекта.ДополнительныйОбъектАдресации) Тогда
						ОбластьКомандаСтрока.Параметры.Участник =
							СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 (%2, %3)",
								УчастникПроекта.Исполнитель,
								УчастникПроекта.ОсновнойОбъектАдресации,
								УчастникПроекта.ДополнительныйОбъектАдресации);
					ИначеЕсли ЗначениеЗаполнено(УчастникПроекта.ОсновнойОбъектАдресации) Тогда
						ОбластьКомандаСтрока.Параметры.Участник =
							СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 (%2)",
								УчастникПроекта.Исполнитель,
								УчастникПроекта.ОсновнойОбъектАдресации);		
					Иначе
						ОбластьКомандаСтрока.Параметры.Участник = УчастникПроекта.Исполнитель;
					КонецЕсли;
				Иначе
					ОбластьКомандаСтрока.Параметры.Участник = УчастникПроекта.Исполнитель;
				КонецЕсли;
				ОбластьКомандаСтрока.Параметры.РольУчастника = УчастникПроекта.РольВПроекте;
				ТабличныйДокумент.Вывести(ОбластьКомандаСтрока);
			КонецЦикла;
		КонецЕсли;
		
		// Контроль исполнения
		ЗапросПроектныеЗадачи = Новый Запрос;
		ЗапросПроектныеЗадачи.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ПроектныеЗадачи.Ссылка,
			|	ПроектныеЗадачи.Наименование,
			|	ПроектныеЗадачи.КодСДР КАК КодСДР,
			|	СрокиПроектныхЗадач.ТекущийПланНачало,
			|	СрокиПроектныхЗадач.ТекущийПланОкончание,
			|	ВЫБОР
			|		КОГДА СрокиПроектныхЗадач.ОкончаниеФакт <> ДАТАВРЕМЯ(1, 1, 1)
			|			ТОГДА &Завершены
			|		КОГДА СрокиПроектныхЗадач.НачалоФакт <> ДАТАВРЕМЯ(1, 1, 1)
			|				И СрокиПроектныхЗадач.ТекущийПланОкончание >= &ТекущаяДата
			|			ТОГДА &ВыполняютсяБезПросрочки
			|		КОГДА СрокиПроектныхЗадач.НачалоФакт <> ДАТАВРЕМЯ(1, 1, 1)
			|				И СрокиПроектныхЗадач.ТекущийПланОкончание < &ТекущаяДата
			|			ТОГДА &ВыполняютсяСПросрочкой
			|		КОГДА СрокиПроектныхЗадач.НачалоФакт = ДАТАВРЕМЯ(1, 1, 1)
			|				И СрокиПроектныхЗадач.ТекущийПланНачало < &ТекущаяДата
			|			ТОГДА &НеНачатыВовремя
			|		КОГДА СрокиПроектныхЗадач.НачалоФакт = ДАТАВРЕМЯ(1, 1, 1)
			|				И СрокиПроектныхЗадач.ТекущийПланНачало >= &ТекущаяДата
			|			ТОГДА &НеНачаты
			|	КОНЕЦ КАК ТекущееСостояниеПроектнойЗадачи,
			|	ПроектныеЗадачи.НомерЗадачиВУровне КАК НомерЗадачиВУровне
			|ИЗ
			|	Справочник.ПроектныеЗадачи КАК ПроектныеЗадачи
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СрокиПроектныхЗадач КАК СрокиПроектныхЗадач
			|		ПО ПроектныеЗадачи.Ссылка = СрокиПроектныхЗадач.ПроектнаяЗадача
			|ГДЕ
			|	ПроектныеЗадачи.Владелец = &Проект
			|	И НЕ ПроектныеЗадачи.ПометкаУдаления
			|
			|УПОРЯДОЧИТЬ ПО
			|	КодСДР,
			|	НомерЗадачиВУровне";
			
		ДатаФормирования = ТекущаяДатаСеанса();
		ЗапросПроектныеЗадачи.УстановитьПараметр("Проект", ОбъектПечати);
		ЗапросПроектныеЗадачи.УстановитьПараметр("ТекущаяДата", ДатаФормирования);
		ЗапросПроектныеЗадачи.УстановитьПараметр("Завершены", НСтр("ru = 'Завершены'"));
		ЗапросПроектныеЗадачи.УстановитьПараметр("ВыполняютсяБезПросрочки", НСтр("ru = 'Выполняются без просрочки'"));
		ЗапросПроектныеЗадачи.УстановитьПараметр("ВыполняютсяСПросрочкой", НСтр("ru = 'Выполняются c просрочкой'"));
		ЗапросПроектныеЗадачи.УстановитьПараметр("НеНачатыВовремя", НСтр("ru = 'Не начаты вовремя'"));
		ЗапросПроектныеЗадачи.УстановитьПараметр("НеНачаты", НСтр("ru = 'Не начаты'"));
		
		ТаблицаЗадачи = ЗапросПроектныеЗадачи.Выполнить().Выгрузить();
		
		Если ТаблицаЗадачи.Количество() > 0 Тогда
			ОбластьКонтрольВыполненияШапка = Макет.ПолучитьОбласть("КонтрольВыполненияШапка");
			ОбластьКонтрольВыполненияШапка.Параметры.ДатаФормирования = Формат(ДатаФормирования, "ДФ='dd.MM.yyyy HH:mm'");
			ТабличныйДокумент.Вывести(ОбластьКонтрольВыполненияШапка);
			
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Завершены'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Выполняются без просрочки'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Выполняются c просрочкой'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Не начаты вовремя'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
			ВывестиЗадачиВУказанномСостоянии(НСтр("ru = 'Не начаты'"), ТабличныйДокумент, Макет, ТаблицаЗадачи);
		КонецЕсли;
		
		// В табличном документе зададим имя области в которую был 
		// выведен объект. Нужно для возможности печати по-комплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ОбъектПечати);
	КонецЦикла;		

	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ВывестиЗадачиВУказанномСостоянии(Состояние, ТабличныйДокумент, Макет, ТаблицаЗадачи)
	
	ПараметрыОтбора = Новый Структура("ТекущееСостояниеПроектнойЗадачи", Состояние);
	НайденныеСтроки = ТаблицаЗадачи.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтроки.Количество() > 0 Тогда
		ОбластьСостояниеСтрока = Макет.ПолучитьОбласть("СостояниеСтрока");
		ОбластьСостояниеСтрока.Параметры.Состояние = Состояние;
		ТабличныйДокумент.Вывести(ОбластьСостояниеСтрока);

		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ОбластьЗадача = Макет.ПолучитьОбласть("ЗадачаСтрока");
			ОбластьЗадача.Параметры.КодСДР = НайденнаяСтрока.КодСДР;
			ОбластьЗадача.Параметры.Наименование = НайденнаяСтрока.Наименование;
			ОбластьЗадача.Параметры.НачалоПлан = Формат(НайденнаяСтрока.ТекущийПланНачало, "ДФ='dd.MM.yy HH:mm'");
			ОбластьЗадача.Параметры.ОкончаниеПлан = Формат(НайденнаяСтрока.ТекущийПланОкончание, "ДФ='dd.MM.yy HH:mm'");
			ТабличныйДокумент.Вывести(ОбластьЗадача);
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры

#КонецЕсли