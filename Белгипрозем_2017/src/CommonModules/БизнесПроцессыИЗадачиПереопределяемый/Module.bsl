///////////////////////////////////////////////////////////////////////////////
// ИНТЕРФЕЙСНАЯ ЧАСТЬ ПЕРЕОПРЕДЕЛЯЕМОГО МОДУЛЯ

// Возвращает адрес электронной почты пользователя ПользовательСсылка.
//
// Параметры
//  ПользовательСсылка  – СправочникСсылка.Пользователи
//  Адрес               - Строка – возвращаемый адрес электронной почты.
//
Процедура ПолучитьАдресЭлектроннойПочты(Знач ПользовательСсылка, Адрес) Экспорт

	// КонтактнаяИнформация
	Адрес = УправлениеКонтактнойИнформацией.ПолучитьКонтактнуюИнформацияОбъекта(ПользовательСсылка, 
		Справочники.ВидыКонтактнойИнформации.EmailПользователя);
	// Конец КонтактнаяИнформация
	
КонецПроцедуры 

// Вызывается для обновления данных бизнес-процесса в регистре сведений 
// ДанныеБизнесПроцессов.
// 
// Параметры
//  Запись       - РегистрСведенийЗапись.ДанныеБизнесПроцессов
//
Процедура ПриЗаписиСпискаБизнесПроцессов(Запись) Экспорт
КонецПроцедуры

// Вызывается для проверки прав на остановку и продолжение бизнес-процесса
// Параметры
//  БизнесПроцесс       - Ссылка на бизнес-процесс
//
Функция ЕстьПраваНаОстановкуБизнесПроцесса(БизнесПроцесс) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Вызывается для заполнения реквизита ГлавнаяЗадача из данных заполнения
// Параметры
//  БизнесПроцессОбъект       - бизнес-процесс
//  ДанныеЗаполнения		  - данные заполнения, которые передаются в обработчик заполнения	
//
Функция ЗаполнитьГлавнуюЗадачу(БизнесПроцессОбъект, ДанныеЗаполнения) Экспорт
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Если ДанныеЗаполнения.Свойство("ГлавнаяЗадача") Тогда
			БизнесПроцессОбъект.ГлавнаяЗадача = ДанныеЗаполнения.ГлавнаяЗадача;
			Возврат Истина;
		КонецЕсли;  
	КонецЕсли; 
	
	Возврат Ложь;
	
КонецФункции

// Проверяет право доступа пользователя на объект, сразу же генерирует СообщениеПользователя с привязкой к полю
Функция ЕстьПравоДоступаУчастникаБизнесПроцесса(
	Процесс,
	ОбъектДоступа, 
	ПравоДоступаСтрока, 
	УчастникБизнесПроцесса, 
	ОсновнойРеквизитАдресации = Неопределено, 
	ДополнительныйРеквизитАдресации = Неопределено, 
	ИмяРеквизита = Неопределено, 
	ИмяКолонкиУчастникаБизнесПроцесса = Неопределено, 
	НомерСтрокиТабличногоПоля = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ОбъектДоступа)
		Или Не ЗначениеЗаполнено(УчастникБизнесПроцесса) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// если не включена функциональная опция "использовать права доступа" - то не делаем проверки.
	Если Не ДокументооборотПраваДоступаПовтИсп.ВключеноИспользованиеПравДоступа() Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Если ТипЗнч(УчастникБизнесПроцесса) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Пользователь = УчастникБизнесПроцесса;	
		
		РеквизитыПользователя = 
			ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Пользователь, "ПометкаУдаления, Недействителен");
		Если РеквизитыПользователя.ПометкаУдаления Или РеквизитыПользователя.Недействителен Тогда
			Возврат Истина;
		КонецЕсли;
		
		ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(ОбъектДоступа, Пользователь);
		Если Не ПраваПоОбъекту.Свойство(ПравоДоступаСтрока) ИЛИ Не ПраваПоОбъекту[ПравоДоступаСтрока] Тогда 
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(Процесс);
			
			Если ИмяКолонкиУчастникаБизнесПроцесса <> Неопределено Тогда
				Сообщение.Поле = ИмяРеквизита + "[" + Формат(НомерСтрокиТабличногоПоля - 1,"ЧГ=; ЧН=") + "]."
					+ ИмяКолонкиУчастникаБизнесПроцесса;
			Иначе
				Сообщение.Поле = ИмяРеквизита;
			КонецЕсли;
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У пользователя ""%1"" нет прав на ""%2""(%3)'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				Пользователь, ОбъектДоступа, ТипЗнч(ОбъектДоступа));
				
			Сообщение.Текст = ТекстОшибки;
			ВыведенныеСообщения = ПолучитьСообщенияПользователю();
			ВывестиСообщение = Истина;
			Для Каждого ВыведенноеСообщение Из ВыведенныеСообщения Цикл
				Если ВыведенноеСообщение.Текст = Сообщение.Текст Тогда
					ВывестиСообщение = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если ВывестиСообщение Тогда
				Сообщение.Сообщить();
			КонецЕсли;
			
			Если Процесс = Неопределено Тогда
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Запись процесса'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					Неопределено,
					Неопределено,
					ТекстОшибки);
			Иначе
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Запись процесса'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					Процесс.Метаданные(),
					?(ЗначениеЗаполнено(Процесс.Ссылка), Процесс.Ссылка, Неопределено),
					ТекстОшибки);
			КонецЕсли;
				
			Возврат Ложь;
			
		КонецЕсли;
		
		Возврат Истина;
		
	Иначе
		
		// разыменовать УчастникБизнесПроцесса
		МассивПользователей = РегистрыСведений.ИсполнителиЗадач.ПолучитьИсполнителейРоли(
			УчастникБизнесПроцесса, ОсновнойРеквизитАдресации, ДополнительныйРеквизитАдресации, Истина);
		
		КодВозврата = Истина;
		
		Для каждого Строка Из МассивПользователей Цикл
			ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(ОбъектДоступа, Строка.Исполнитель);
			Если Не ПраваПоОбъекту.Свойство(ПравоДоступаСтрока) ИЛИ Не ПраваПоОбъекту[ПравоДоступаСтрока] Тогда
				КодВозврата = Ложь;
				Прервать; // выйти из цикла - дальше проверять не надо
			КонецЕсли;
		КонецЦикла;
		
		Если КодВозврата = Ложь Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.УстановитьДанные(Процесс);
			
			Если ИмяКолонкиУчастникаБизнесПроцесса <> Неопределено Тогда
				Сообщение.Поле = ИмяРеквизита + "[" + Формат(НомерСтрокиТабличногоПоля,"ЧГ=; ЧН=") + "]." + ИмяКолонкиУчастникаБизнесПроцесса;
			Иначе
				Сообщение.Поле = ИмяРеквизита;
			КонецЕсли;
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не все пользователи  роли ""%1"" имеют права на объект ""%2""(%3)'",
					ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УчастникБизнесПроцесса, ОбъектДоступа, ТипЗнч(ОбъектДоступа));
			
			Сообщение.Текст = ТекстОшибки;
			Сообщение.Сообщить();
			
			Если Процесс = Неопределено Тогда
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Запись процесса'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка, 
					Неопределено,
					Неопределено,
					ТекстОшибки);
			Иначе
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Запись процесса'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка, 
					Процесс.Метаданные(), 
					?(ЗначениеЗаполнено(Процесс.Ссылка), Процесс.Ссылка, Неопределено),
					ТекстОшибки);
			КонецЕсли;

		КонецЕсли;	
		
		Возврат КодВозврата;
		
	КонецЕсли;
	
	Возврат Истина;
КонецФункции	

// Возвращает Истина, если используется подсистема ВнешниеЗадачиИБизнесПроцессы
Функция ИспользоватьВнешниеЗадачиИБизнесПроцессы() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает содержание переданного объекта
// Параметры
// Объект - объект, представление которого надо сформировать
// Возвращает содержание в виде HTML или MXL документа
Функция ПолучитьСодержание(Объект) Экспорт
	
	// ВнешниеБизнесПроцессыИЗадачи
	Возврат ВнешниеЗадачиВызовСервера.ПолучитьСодержание(Объект);
	// Конец ВнешниеБизнесПроцессыИЗадачи
	
КонецФункции

// Возвращает массив объектов типа ОписаниеПередаваемогоФайла
// или Неопределено
Функция ПолучитьСписокФайлов(Источник) Экспорт
	
	// ВнешниеБизнесПроцессыИЗадачи
	Возврат	ВнешниеЗадачиВызовСервера.ПолучитьСписокФайлов(Источник);
	// Конец ВнешниеБизнесПроцессыИЗадачи
	
КонецФункции

// Возвращает Истина, если задача является внешней 
Функция ЭтоВнешняяЗадача(ЗадачаСсылка) Экспорт
	
	// ВнешниеБизнесПроцессыИЗадачи
	Возврат ВнешниеЗадачиВызовСервера.ЭтоВнешняяЗадача(ЗадачаСсылка);
	// Конец ВнешниеБизнесПроцессыИЗадачи
	
КонецФункции

// Помечает задачу-источник как выполненную
Процедура ВыполнитьЗадачуИсточник(БизнесПроцесс) Экспорт
	
	// ВнешниеБизнесПроцессыИЗадачи
	ВнешниеЗадачиВызовСервера.ВыполнитьЗадачуИсточник(БизнесПроцесс);
	// Конец ВнешниеБизнесПроцессыИЗадачи
	
КонецПроцедуры

// Вызывается для заполнения параметров формы внешней задачи
//
// Параметры:
//  ИмяБизнесПроцесса           - Строка - название бизнес-процесса
//  ЗадачаСсылка                - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//  ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка.Задание - действие.
//  ПараметрыФормы              - Структура - описание выполнения задачи.
//   Ключ "ИмяФормы" содержит имя формы, передаваемое в метод контекста ОткрытьФорму(). 
//   Ключ "ПараметрыФормы" содержит параметры формы.
//
// Пример заполнения:
//  Если ИмяБизнесПроцесса = "Задание" Тогда
//      ИмяФормы = "БизнесПроцесс.Задание.Форма.ВнешнееДействие" + ТочкаМаршрутаБизнесПроцесса.Имя;
//      ПараметрыФормы.Вставить("ИмяФормы", ИмяФормы);
//  КонецЕсли;
//
Процедура ПриПолученииФормыВыполненияЗадачи(ИмяБизнесПроцесса, ЗадачаСсылка,
											ТочкаМаршрутаБизнесПроцесса, ПараметрыФормы) Экспорт
	
КонецПроцедуры
