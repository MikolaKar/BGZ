#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ПраваДоступа

// Возвращает наименования реквизитов, необходимых для определения прав доступа.
//
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка, Автор, Пользователь";
	
КонецФункции

// Возвращает Истина, указывая тем самым, что этот объект сам заполняет свои права.
//
Функция ЕстьМетодЗаполнитьПраваДоступа() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет переданный дескриптор доступа.
//
Процедура ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	// Пользователи
	Если ЗначениеЗаполнено(ОбъектДоступа.Автор) Тогда
		Строка = ДескрипторДоступа.Пользователи.Добавить();
		Строка.Ключ = "Автор";
		Строка.Пользователь = ОбъектДоступа.Автор;
	КонецЕсли;
	Если ЗначениеЗаполнено(ОбъектДоступа.Пользователь) Тогда
		Строка = ДескрипторДоступа.Пользователи.Добавить();
		Строка.Ключ = "Пользователь";
		Строка.Пользователь = ОбъектДоступа.Пользователь;
	КонецЕсли;
	
	// Рабочая группа
	РабочаяГруппа = РаботаСРабочимиГруппами.ПолучитьРабочуюГруппуДокумента(ОбъектДоступа.Ссылка);
	Для каждого Эл Из РабочаяГруппа Цикл
		Строка = ДескрипторДоступа.РабочаяГруппа.Добавить();
		Строка.Участник = Эл.Участник;
		Строка.ОсновнойОбъектАдресации = Эл.ОсновнойОбъектАдресации;
		Строка.ДополнительныйОбъектАдресации = Эл.ДополнительныйОбъектАдресации;
	КонецЦикла;
	
КонецПроцедуры

// Заполняет параметр ПраваДоступа правами доступа, вычисляя их на 
// основании переданного дескриптора доступа.
// Если указан параметр ПротоколРасчетаПрав, то в него 
// заносится список данных, которые были использованы для расчета прав.
//
Процедура ЗаполнитьПраваДоступа(ДескрипторДоступа, ПраваДоступа, ПротоколРасчетаПрав) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПраваДоступаСтандартные = Новый Соответствие;
	
	Справочники.ДескрипторыДоступаОбъектов.ЗаполнитьПраваДоступаСтандартно(
		ДескрипторДоступа, 
		ПраваДоступаСтандартные, 
		ПротоколРасчетаПрав);
	
	// Добавление рабочей группы или всех пользователей
	Если ДескрипторДоступа.РабочаяГруппа.Количество() > 0 Тогда
		
		Если ПротоколРасчетаПрав <> Неопределено Тогда
			ПротоколРасчетаПрав.Добавить(НСтр("ru = 'Рабочая группа записи календаря'"));
		КонецЕсли;
		
		Для каждого Эл Из ДескрипторДоступа.РабочаяГруппа Цикл
			
			Если ТипЗнч(Эл.Участник) = Тип("СправочникСсылка.Пользователи") Тогда
				
				НайденноеЗначение = ПраваДоступаСтандартные.Получить(Эл.Участник);
				Если НайденноеЗначение <> Неопределено И НайденноеЗначение.Чтение Тогда
					
					ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами");
					ПраваПользователя.Чтение = Истина;
					ПраваПользователя.Добавление = Ложь;
					ПраваПользователя.Изменение = Ложь;
					ПраваПользователя.Удаление = Ложь;
					ПраваПользователя.УправлениеПравами = Ложь;
					
					ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
						ПраваДоступа,
						Эл.Участник,
						Неопределено,
						Неопределено,
						ПраваПользователя);
					
				КонецЕсли;
				
			ИначеЕсли ТипЗнч(Эл.Участник) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
				
				// Обходим всех пользователей группы
				СоставГруппы = ДокументооборотПраваДоступаПовтИсп.ПолучитьСоставГруппыПользователей(Эл.Участник);
				Для каждого ЭлГруппы Из СоставГруппы Цикл
					
					НайденноеЗначение = ПраваДоступаСтандартные.Получить(ЭлГруппы.Пользователь);
					Если НайденноеЗначение <> Неопределено И НайденноеЗначение.Чтение Тогда
						
						ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами");
						ПраваПользователя.Чтение = Истина;
						ПраваПользователя.Добавление = Ложь;
						ПраваПользователя.Изменение = Ложь;
						ПраваПользователя.Удаление = Ложь;
						ПраваПользователя.УправлениеПравами = Ложь;
						
						ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
							ПраваДоступа,
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
					
					НайденноеЗначение = ПраваДоступаСтандартные.Получить(ИсполнительРоли.Исполнитель);
					Если НайденноеЗначение <> Неопределено И НайденноеЗначение.Чтение Тогда
						
						ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами");
						ПраваПользователя.Чтение = Истина;
						ПраваПользователя.Добавление = Ложь;
						ПраваПользователя.Изменение = Ложь;
						ПраваПользователя.Удаление = Ложь;
						ПраваПользователя.УправлениеПравами = Ложь;
						
						ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
							ПраваДоступа,
							ИсполнительРоли.Исполнитель,
							Неопределено,
							Неопределено,
							ПраваПользователя);
							
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
				
		КонецЦикла;
		
	Иначе
		
		Для каждого Эл Из ПраваДоступаСтандартные Цикл
			
			Если Эл.Значение.Чтение Тогда
				
				ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами");
				ПраваПользователя.Чтение = Истина;
				ПраваПользователя.Добавление = Ложь;
				ПраваПользователя.Изменение = Ложь;
				ПраваПользователя.Удаление = Ложь;
				ПраваПользователя.УправлениеПравами = Ложь;
				
				ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
					ПраваДоступа,
					Эл.Ключ,
					Неопределено,
					Неопределено,
					ПраваПользователя);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Добавление пользователей
	Для каждого Эл Из ДескрипторДоступа.Пользователи Цикл
		
		ПраваПользователяСтандартные = ПраваДоступа.Получить(Эл.Пользователь);
		Если ЗначениеЗаполнено(ПраваПользователяСтандартные) Тогда
			
			Если Эл.Ключ = "Пользователь" Тогда
				
				ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами");
				ПраваПользователя.Чтение = Истина И ПраваПользователяСтандартные.Чтение;
				ПраваПользователя.Добавление = Истина И ПраваПользователяСтандартные.Чтение;
				ПраваПользователя.Изменение = Истина И ПраваПользователяСтандартные.Чтение;
				ПраваПользователя.Удаление = Истина И ПраваПользователяСтандартные.Чтение;
				ПраваПользователя.УправлениеПравами = Ложь;
				
				ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
					ПраваДоступа,
					Эл.Пользователь,
					Неопределено,
					Неопределено,
					ПраваПользователя);
					
				Если ПротоколРасчетаПрав <> Неопределено Тогда
					ПротоколРасчетаПрав.Добавить(НСтр("ru = 'Пользователь'"));
				КонецЕсли;
				
			ИначеЕсли Эл.Ключ = "Автор" Тогда
				
				ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами");
				ПраваПользователя.Чтение = Истина И ПраваПользователяСтандартные.Чтение;
				ПраваПользователя.Добавление = Истина И ПраваПользователяСтандартные.Чтение;
				ПраваПользователя.Изменение = Истина И ПраваПользователяСтандартные.Чтение;
				ПраваПользователя.Удаление = Истина И ПраваПользователяСтандартные.Чтение;
				ПраваПользователя.УправлениеПравами = Ложь;
				
				ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
					ПраваДоступа,
					Эл.Пользователь,
					Неопределено,
					Неопределено,
					ПраваПользователя);
					
				Если ПротоколРасчетаПрав <> Неопределено Тогда
					ПротоколРасчетаПрав.Добавить(НСтр("ru = 'Автор'"));
				КонецЕсли;
				
			Иначе
				
				ВызватьИсключение НСтр("ru = 'Неизвестный ключ пользователя.'");
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Процедура формирования печатной формы.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати по-комплектно
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Карточка") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Карточка", "Карточка записи календаря", ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),
			, "Справочник.ЗаписиРабочегоКалендаря.ПФ_MXL_Карточка");
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует печатную форму карточки записи календаря.
//
Функция ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ЗаписиКалендаря = ПараметрыПечати.ЗаписиКалендаря;
	
	// Создаем табличный документ и устанавливаем имя параметров печати
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_Карточка";
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	// Получаем запросом необходимые данные
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаписиРабочегоКалендаря.Ссылка,
		|	ЗаписиРабочегоКалендаря.Наименование,
		|	ЗаписиРабочегоКалендаря.Пользователь,
		|	ЗаписиРабочегоКалендаря.ДатаНачала,
		|	ЗаписиРабочегоКалендаря.ДатаОкончания,
		|	ЗаписиРабочегоКалендаря.ВесьДень,
		|	ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря,
		|	ЗаписиРабочегоКалендаря.Предмет,
		|	ЗаписиРабочегоКалендаря.Описание
		|ИЗ
		|	Справочник.ЗаписиРабочегоКалендаря КАК ЗаписиРабочегоКалендаря
		|ГДЕ
		|	ЗаписиРабочегоКалендаря.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивРеквизитовЗаписейКалендаря = Новый Массив;
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ТипЗаписиКалендаря = Перечисления.ТипЗаписиКалендаря.Событие
			Или Выборка.ТипЗаписиКалендаря = Перечисления.ТипЗаписиКалендаря.ЭлементПовторяющегосяСобытия Тогда
			
			РеквизитыЗаписиКалендаря = Справочники.ЗаписиРабочегоКалендаря.ПолучитьСтруктуруРеквизитовЗаписиКалендаря();
			ЗаполнитьЗначенияСвойств(РеквизитыЗаписиКалендаря, Выборка);
			МассивРеквизитовЗаписейКалендаря.Добавить(РеквизитыЗаписиКалендаря);
			
		ИначеЕсли Выборка.ТипЗаписиКалендаря = Перечисления.ТипЗаписиКалендаря.ПовторяющеесяСобытие Тогда
			
			ЗаписьКалендаряОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
			Для Каждого ЗаписьКалендаря Из ЗаписиКалендаря Цикл
				Если Выборка.Ссылка = ЗаписьКалендаря.Ссылка Тогда
					РеквизитыЗаписиКалендаря = ЗаписьКалендаряОбъект.ПолучитьРеквизитыЗаписиКалендаря(ЗаписьКалендаря.ДеньНачала);
					МассивРеквизитовЗаписейКалендаря.Добавить(РеквизитыЗаписиКалендаря);
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Получение областей макета 
	Макет = УправлениеПечатью.ПолучитьМакет("Справочник.ЗаписиРабочегоКалендаря.ПФ_MXL_Карточка");
	ОбластьЗаписьКалендаря = Макет.ПолучитьОбласть("ЗаписьКалендаря");
	ОбластьПредмет = Макет.ПолучитьОбласть("Предмет");
	ОбластьПовторять = Макет.ПолучитьОбласть("Повторять");
	ОбластьРеквизитыМероприятия = Макет.ПолучитьОбласть("РеквизитыМероприятия");
	
	ПервыйДокумент = Истина;
	Для Каждого РеквизитыЗаписиКалендаря Из МассивРеквизитовЗаписейКалендаря Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки с которой начали выводить текущий документ
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Вывод записи календаря
		ОбластьЗаписьКалендаря.Параметры.Заполнить(РеквизитыЗаписиКалендаря);
		ОбластьЗаписьКалендаря.Параметры.Наименование =
			РаботаСРабочимКалендаремКлиентСервер.ВыделитьПервуюСтрокуОписания(РеквизитыЗаписиКалендаря.Описание);
		ОбластьЗаписьКалендаря.Параметры.Дата =
			РаботаСРабочимКалендаремКлиентСервер.ПолучитьПредставлениеДаты(
				РеквизитыЗаписиКалендаря.ДатаНачала,
				РеквизитыЗаписиКалендаря.ДатаОкончания, 
				РеквизитыЗаписиКалендаря.ВесьДень);
		ОбластьЗаписьКалендаря.Параметры.Пользователь = "(" + РеквизитыЗаписиКалендаря.Пользователь + ")";
		ТабличныйДокумент.Вывести(ОбластьЗаписьКалендаря);
		
		// Вывод повторения
		Если ЗначениеЗаполнено(РеквизитыЗаписиКалендаря.Повторять) Тогда
			ОбластьПовторять.Параметры.Повторять = РеквизитыЗаписиКалендаря.Повторять;
			ТабличныйДокумент.Вывести(ОбластьПовторять);
		КонецЕсли;
		
		// Вывод предмета
		Если ЗначениеЗаполнено(РеквизитыЗаписиКалендаря.Предмет) Тогда
			
			ПредставлениеПредмета = РаботаСРабочимКалендаремСервер.ПолучитьПредставлениеПредмета(РеквизитыЗаписиКалендаря.Предмет);
			Если ЗначениеЗаполнено(ПредставлениеПредмета) Тогда
				
				ОбластьПредмет.Параметры.Предмет = ПредставлениеПредмета;
				ТабличныйДокумент.Вывести(ОбластьПредмет);
				
				// Вывод мероприятия
				Если ТипЗнч(РеквизитыЗаписиКалендаря.Предмет) = Тип("СправочникСсылка.Мероприятия") Тогда
					РеквизитыМероприятия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РеквизитыЗаписиКалендаря.Предмет, "ВидМероприятия, МестоПроведения, Организатор");
					ОбластьРеквизитыМероприятия.Параметры.Заполнить(РеквизитыМероприятия);
					ТабличныйДокумент.Вывести(ОбластьРеквизитыМероприятия);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		// В табличном документе зададим имя области в которую был 
		// выведен объект. Нужно для возможности печати по-комплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, РеквизитыЗаписиКалендаря.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#Область РабочаяГруппа

// Возвращает признак наличия метода ДобавитьУчастниковВТаблицу у менеджера объекта
//
Функция ЕстьМетодДобавитьУчастниковВТаблицу() Экспорт
	
	Возврат Истина;
	
КонецФункции


// Добавляет участников документа в переданную таблицу
//
Процедура ДобавитьУчастниковВТаблицу(ТаблицаНабора, Документ) Экспорт
	
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Документ.Автор);
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Документ.Пользователь);
	
КонецПроцедуры

#КонецОбласти

// Возвращает структуру события.
//
Функция ПолучитьСтруктуруПравилаПовторения() Экспорт
	
	СтруктураПравилаПовторения = Новый Структура();
	СтруктураПравилаПовторения.Вставить("ДатаНачалаПовторения");
	СтруктураПравилаПовторения.Вставить("ДатаОкончанияПовторения");
	СтруктураПравилаПовторения.Вставить("ИнтервалПовторения");
	СтруктураПравилаПовторения.Вставить("КоличествоПовторов");
	СтруктураПравилаПовторения.Вставить("ОписаниеКраткое");
	СтруктураПравилаПовторения.Вставить("ПовторениеПоДнямМесяца");
	СтруктураПравилаПовторения.Вставить("ПовторениеПоМесяцам");
	СтруктураПравилаПовторения.Вставить("ТипЗаписиКалендаря");
	СтруктураПравилаПовторения.Вставить("ЧастотаПовторения");
	СтруктураПравилаПовторения.Вставить("ИсключенияПовторения");
	СтруктураПравилаПовторения.Вставить("ПовторениеПоДням");
	
	Возврат СтруктураПравилаПовторения;
	
КонецФункции

// Формирует HTML представление записи календаря.
//
Функция СформироватьHTMLПредставление(ЗаписьКалендаря, ДатаЗаписи) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ЗаписьКалендаря)
		ИЛИ ТипЗнч(ЗаписьКалендаря) <> Тип("СправочникСсылка.ЗаписиРабочегоКалендаря") Тогда
		Возврат РаботаСРабочимКалендаремКлиентСервер.ПолучитьПустоеHTMLПредставление();
	КонецЕсли;
	
	ЗаписьКалендаряОбъект = ЗаписьКалендаря.ПолучитьОбъект();
	РеквизитыЗаписиКалендаря = ЗаписьКалендаряОбъект.ПолучитьРеквизитыЗаписиКалендаря(ДатаЗаписи);
	
	Если НЕ ЗначениеЗаполнено(РеквизитыЗаписиКалендаря) Тогда
		Возврат РаботаСРабочимКалендаремКлиентСервер.ПолучитьПустоеHTMLПредставление();
	КонецЕсли;
	
	ТекстТема =
		РаботаСРабочимКалендаремКлиентСервер.ВыделитьПервуюСтрокуОписания(РеквизитыЗаписиКалендаря.Описание);
	РаботаС_HTML.ДобавитьТегиКСсылкам(ТекстТема);
	Если РеквизитыЗаписиКалендаря.Пользователь <> ПользователиКлиентСервер.ТекущийПользователь() Тогда
		ТекстПользователь = Строка(РеквизитыЗаписиКалендаря.Пользователь);
	Иначе
		ТекстПользователь = "";
	КонецЕсли;
	ТекстВремя = Формат(РеквизитыЗаписиКалендаря.ДатаНачала, "ДФ=ЧЧ:мм") + " - "
		+ Формат(РеквизитыЗаписиКалендаря.ДатаОкончания, "ДФ=ЧЧ:мм");
	ТекстДата = Формат(РеквизитыЗаписиКалендаря.ДатаНачала, "ДФ='дддд, д ММММ гггг'");
	ТекстОписание = СтрЗаменить(
		РаботаС_HTML.ЗаменитьСпецСимволыHTML(РеквизитыЗаписиКалендаря.Описание), Символы.ПС, "<br>");
	РаботаС_HTML.ДобавитьТегиКСсылкам(ТекстОписание);
	Если РеквизитыЗаписиКалендаря.ВесьДень Тогда
		ТекстДатаНачала = Формат(РеквизитыЗаписиКалендаря.ДатаНачала, "ДФ='дддд, д ММММ гггг'");
		ТекстДатаОкончания = Формат(РеквизитыЗаписиКалендаря.ДатаОкончания, "ДФ='дддд, д ММММ гггг'");
	Иначе
		ТекстДатаНачала = Формат(РеквизитыЗаписиКалендаря.ДатаНачала, "ДФ='дддд, д ММММ гггг ЧЧ:мм'");
		ТекстДатаОкончания = Формат(РеквизитыЗаписиКалендаря.ДатаОкончания, "ДФ='дддд, д ММММ гггг ЧЧ:мм'");
	КонецЕсли;
	ТекстПовторять = РеквизитыЗаписиКалендаря.Повторять;
	ТекстПредмет = РаботаС_HTML.ПолучитьСсылкуНаПредмет(РеквизитыЗаписиКалендаря.Предмет);
	
	ПредставлениеHTML =
		"<html><body topmargin=0 scroll=auto>
		|<div style='font-size=12px;font-family=Arial;line-height:150%'>
		|<b>[Тема]</b>
		|</div>
		|<div style='font-size=10px;font-family=Arial;top-margin:10px'>
		|<b>[НадписьПользователь]:</b> [Пользователь]<br>
		|<b>[НадписьВремя]:</b> [Время]<br>
		|<b>[НадписьДата]:</b> [Дата]<br>
		|<b>[НадписьДатаНачала]:</b> [ДатаНачала]<br>
		|<b>[НадписьДатаОкончания]:</b> [ДатаОкончания]<br>
		|<b>[НадписьПовторять]:</b> [Повторять]<br>
		|<b>[НадписьПредмет]:</b> [Предмет]<br>
		|</div>
		|<hr>
		|<div style='font-size=10px;font-family=Arial'>
		|[Описание]
		|</div>
		|</body></html>";
	
	Если НачалоДня(РеквизитыЗаписиКалендаря.ДатаОкончания) - НачалоДня(РеквизитыЗаписиКалендаря.ДатаНачала) <> 0 Тогда
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьВремя]:</b> [Время]<br>", "");
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьДата]:</b> [Дата]<br>", "");
	ИначеЕсли РеквизитыЗаписиКалендаря.ВесьДень Тогда
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьВремя]:</b> [Время]<br>", "");
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьДатаНачала]:</b> [ДатаНачала]<br>", "");
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьДатаОкончания]:</b> [ДатаОкончания]<br>", "");
	Иначе
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьДатаНачала]:</b> [ДатаНачала]<br>", "");
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьДатаОкончания]:</b> [ДатаОкончания]<br>", "");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекстПовторять) Тогда
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьПовторять]:</b> [Повторять]<br>", "");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ТекстПредмет) Тогда
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьПредмет]:</b> [Предмет]<br>", "");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ТекстПользователь) Тогда
		ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
			Символы.ПС + "<b>[НадписьПользователь]:</b> [Пользователь]<br>", "");
	КонецЕсли;
	
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьПользователь]", НСтр("ru = 'Пользователь'"));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьВремя]", НСтр("ru = 'Время'"));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьДата]", НСтр("ru = 'Дата'"));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьДатаНачала]", НСтр("ru = 'Дата начала'"));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьДатаОкончания]", НСтр("ru = 'Дата окончания'"));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьПовторять]", НСтр("ru = 'Повторять'"));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[НадписьПредмет]", НСтр("ru = 'Предмет'"));
	
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[Пользователь]", РаботаС_HTML.ЗаменитьСпецСимволыHTML(ТекстПользователь));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[Время]", РаботаС_HTML.ЗаменитьСпецСимволыHTML(ТекстВремя));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[Дата]", РаботаС_HTML.ЗаменитьСпецСимволыHTML(ТекстДата));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[ДатаНачала]", РаботаС_HTML.ЗаменитьСпецСимволыHTML(ТекстДатаНачала));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[ДатаОкончания]", РаботаС_HTML.ЗаменитьСпецСимволыHTML(ТекстДатаОкончания));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML,
		"[Повторять]", РаботаС_HTML.ЗаменитьСпецСимволыHTML(ТекстПовторять));
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML, "[Тема]", ТекстТема);
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML, "[Описание]", ТекстОписание);
	ПредставлениеHTML = СтрЗаменить(ПредставлениеHTML, "[Предмет]", ТекстПредмет);
	
	Возврат ПредставлениеHTML;
	
КонецФункции

// Возвращает таблицу занятости пользователей.
//
Функция ПолучитьТаблицуЗанятости(Знач МассивПользователей, ДатаНачала, ДатаОкончания, ИсключенияЗанятости) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(МассивПользователей) = Тип("СправочникСсылка.Пользователи") Тогда
		Пользователь = МассивПользователей;
		МассивПользователей = Новый Массив;
		МассивПользователей.Добавить(Пользователь);
	КонецЕсли;
	
	МассивИсключенийЗанятости = РегистрыСведений.СвязанныеЗаписиКалендаря.ПолучитьИсключенияЗанятости(ИсключенияЗанятости);
	
	ТаблицаЗанятости = Новый ТаблицаЗначений;
	ТаблицаЗанятости.Колонки.Добавить("Пользователь");
	ТаблицаЗанятости.Колонки.Добавить("ДатаНачала");
	ТаблицаЗанятости.Колонки.Добавить("ДатаОкончания");
	ТаблицаЗанятости.Колонки.Добавить("Занят");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗаписиРабочегоКалендаря.Пользователь КАК Пользователь,
		|	ЗаписиРабочегоКалендаря.ДатаНачала КАК ДатаНачала,
		|	ЗаписиРабочегоКалендаря.ДатаОкончания КАК ДатаОкончания,
		|	ЗаписиРабочегоКалендаря.Состояние
		|ИЗ
		|	Справочник.ЗаписиРабочегоКалендаря КАК ЗаписиРабочегоКалендаря
		|ГДЕ
		|	ЗаписиРабочегоКалендаря.Пользователь В(&МассивПользователей)
		|	И ЗаписиРабочегоКалендаря.ДатаНачала < &ДатаОкончания
		|	И ЗаписиРабочегоКалендаря.ДатаОкончания > &ДатаНачала
		|	И (ЗаписиРабочегоКалендаря.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаписейРабочегоКалендаря.Принято)
		|		ИЛИ ЗаписиРабочегоКалендаря.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаписейРабочегоКалендаря.ПодВопросом))
		|	И ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря <> ЗНАЧЕНИЕ(Перечисление.ТипЗаписиКалендаря.ПовторяющеесяСобытие)
		|	И ЗаписиРабочегоКалендаря.ПометкаУдаления = ЛОЖЬ
		|	И НЕ ЗаписиРабочегоКалендаря.Ссылка В (&ИсключенияЗанятости)";
	
	Запрос.УстановитьПараметр("МассивПользователей", МассивПользователей);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("ИсключенияЗанятости", МассивИсключенийЗанятости);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТаблицаЗанятости.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.Занят =
			РаботаСРабочимКалендаремСервер.ПолучитьСоответствующееСостояниеЗанятости(Выборка.Состояние);
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаписиРабочегоКалендаря.ОписаниеКраткое,
		|	ЗаписиРабочегоКалендаря.ДатаНачала,
		|	ЗаписиРабочегоКалендаря.ДатаОкончания,
		|	ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря,
		|	ЗаписиРабочегоКалендаря.ИсключенияПовторения.(
		|		ДатаИсключения,
		|		ЗаписьИсключения
		|	) КАК ИсключенияПовторенияТаблица,
		|	ЗаписиРабочегоКалендаря.ПовторениеПоДням.(
		|		ДеньНедели,
		|		НомерВхождения
		|	) КАК ПовторениеПоДнямТаблица,
		|	ЗаписиРабочегоКалендаря.ДатаНачалаПовторения,
		|	ЗаписиРабочегоКалендаря.ДатаОкончанияПовторения,
		|	ЗаписиРабочегоКалендаря.ИнтервалПовторения,
		|	ЗаписиРабочегоКалендаря.КоличествоПовторов,
		|	ЗаписиРабочегоКалендаря.ПовторениеПоДнямМесяца,
		|	ЗаписиРабочегоКалендаря.ПовторениеПоМесяцам,
		|	ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря КАК ТипЗаписиКалендаря1,
		|	ЗаписиРабочегоКалендаря.ЧастотаПовторения,
		|	ЗаписиРабочегоКалендаря.Состояние,
		|	ЗаписиРабочегоКалендаря.Пользователь
		|ИЗ
		|	Справочник.ЗаписиРабочегоКалендаря КАК ЗаписиРабочегоКалендаря
		|ГДЕ
		|	ЗаписиРабочегоКалендаря.Пользователь В(&МассивПользователей)
		|	И ЗаписиРабочегоКалендаря.ДатаОкончанияПовторения > &ДатаНачала
		|	И ЗаписиРабочегоКалендаря.ДатаНачалаПовторения < &ДатаОкончания
		|	И (ЗаписиРабочегоКалендаря.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаписейРабочегоКалендаря.Принято)
		|		ИЛИ ЗаписиРабочегоКалендаря.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаписейРабочегоКалендаря.ПодВопросом))
		|	И ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря = ЗНАЧЕНИЕ(Перечисление.ТипЗаписиКалендаря.ПовторяющеесяСобытие)
		|	И ЗаписиРабочегоКалендаря.ПометкаУдаления = ЛОЖЬ
		|	И НЕ ЗаписиРабочегоКалендаря.Ссылка В (&ИсключенияЗанятости)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаписиРабочегоКалендаря.ОписаниеКраткое,
		|	ЗаписиРабочегоКалендаря.ДатаНачала,
		|	ЗаписиРабочегоКалендаря.ДатаОкончания,
		|	ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря,
		|	ЗаписиРабочегоКалендаря.ИсключенияПовторения.(
		|		ДатаИсключения,
		|		ЗаписьИсключения
		|	),
		|	ЗаписиРабочегоКалендаря.ПовторениеПоДням.(
		|		ДеньНедели,
		|		НомерВхождения
		|	),
		|	ЗаписиРабочегоКалендаря.ДатаНачалаПовторения,
		|	ЗаписиРабочегоКалендаря.ДатаОкончанияПовторения,
		|	ЗаписиРабочегоКалендаря.ИнтервалПовторения,
		|	ЗаписиРабочегоКалендаря.КоличествоПовторов,
		|	ЗаписиРабочегоКалендаря.ПовторениеПоДнямМесяца,
		|	ЗаписиРабочегоКалендаря.ПовторениеПоМесяцам,
		|	ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря,
		|	ЗаписиРабочегоКалендаря.ЧастотаПовторения,
		|	ЗаписиРабочегоКалендаря.Состояние,
		|	ЗаписиРабочегоКалендаря.Пользователь
		|ИЗ
		|	Справочник.ЗаписиРабочегоКалендаря КАК ЗаписиРабочегоКалендаря
		|ГДЕ
		|	ЗаписиРабочегоКалендаря.Пользователь В(&МассивПользователей)
		|	И ЗаписиРабочегоКалендаря.ДатаОкончанияПовторения = ДАТАВРЕМЯ(1, 1, 1)
		|	И ЗаписиРабочегоКалендаря.ДатаНачалаПовторения < &ДатаОкончания
		|	И (ЗаписиРабочегоКалендаря.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаписейРабочегоКалендаря.Принято)
		|		ИЛИ ЗаписиРабочегоКалендаря.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаписейРабочегоКалендаря.ПодВопросом))
		|	И ЗаписиРабочегоКалендаря.ТипЗаписиКалендаря = ЗНАЧЕНИЕ(Перечисление.ТипЗаписиКалендаря.ПовторяющеесяСобытие)
		|	И ЗаписиРабочегоКалендаря.ПометкаУдаления = ЛОЖЬ
		|	И НЕ ЗаписиРабочегоКалендаря.Ссылка В (&ИсключенияЗанятости)";
	
	Запрос.УстановитьПараметр("МассивПользователей", МассивПользователей);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("ИсключенияЗанятости", МассивИсключенийЗанятости);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПроверяемаяДата = НачалоДня(ДатаНачала);
		Пока ПроверяемаяДата < ДатаОкончания Цикл
			
			СтруктураПравилаПовторения = Справочники.ЗаписиРабочегоКалендаря.ПолучитьСтруктуруПравилаПовторения();
			ЗаполнитьЗначенияСвойств(СтруктураПравилаПовторения, Выборка);
			СтруктураПравилаПовторения.ИсключенияПовторения = Выборка.ИсключенияПовторенияТаблица.Выгрузить();
			СтруктураПравилаПовторения.ПовторениеПоДням = Выборка.ПовторениеПоДнямТаблица.Выгрузить();
			
			Если РаботаСРабочимКалендаремСервер.ДатаУдовлетворяетПравилуПовторения(
					ПроверяемаяДата, СтруктураПравилаПовторения) Тогда
				
				ДатаНачалаПоПравилуПовторения = НачалоДня(ПроверяемаяДата) + (Выборка.ДатаНачала - НачалоДня(Выборка.ДатаНачала));
				ДатаОкончанияПоПравилуПовторения = НачалоДня(ПроверяемаяДата) + (Выборка.ДатаОкончания - НачалоДня(Выборка.ДатаНачала));
				Если ДатаНачалаПоПравилуПовторения < ДатаОкончания
					И ДатаОкончанияПоПравилуПовторения > ДатаНачала Тогда
					
					НоваяСтрока = ТаблицаЗанятости.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
					НоваяСтрока.ДатаНачала = ДатаНачалаПоПравилуПовторения;
					НоваяСтрока.ДатаОкончания = ДатаОкончанияПоПравилуПовторения;
					НоваяСтрока.Занят = РаботаСРабочимКалендаремСервер.ПолучитьСоответствующееСостояниеЗанятости(Выборка.Состояние);
					
				КонецЕсли;
			КонецЕсли;
			
			ПроверяемаяДата = ПроверяемаяДата + 86400; // 86400 - число секунд в сутках
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТаблицаЗанятости;
	
КонецФункции

// Возвращает структуру реквизитов записи календаря.
Функция ПолучитьСтруктуруРеквизитовЗаписиКалендаря() Экспорт
	
	РеквизитыЗаписиКалендаря = Новый Структура("Ссылка, Описание, Пользователь, ДатаНачала, ДатаОкончания,
		|ВесьДень, Повторять, Предмет");
	РеквизитыЗаписиКалендаря.Повторять = "";
	
	Возврат РеквизитыЗаписиКалендаря;
	
КонецФункции

#КонецОбласти

#КонецЕсли