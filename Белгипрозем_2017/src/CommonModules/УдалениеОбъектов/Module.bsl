
// Возвращает все помеченные на удаление объекты
Функция ПолучитьПомеченныеНаУдаление() Экспорт
	
	МассивПомеченные = НайтиПомеченныеНаУдаление();
	
	Результат = Новый Массив;
	Для Каждого ЭлементПомеченный Из МассивПомеченные Цикл
		Если ПравоДоступа("ИнтерактивноеУдалениеПомеченных", ЭлементПомеченный.Метаданные()) Тогда
			Результат.Добавить(ЭлементПомеченный);
		КонецЕсли
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Удаляет переданный массив объектов
Процедура УдалитьПомеченныеОбъекты(
			Удаляемые, 
			ТипыУдаленныхОбъектовМассив, 
			Результат,
			АдресХранилищаРезультата) Экспорт
			
	ЭтоФайловаяБД = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ПроцентВыполнения = 1;
	ВывестиПроцентВыполнения(ПроцентВыполнения, ЭтоФайловаяБД);
		
	Найденные = Новый ТаблицаЗначений;
	НеУдаленные = Новый Массив;
	
	Найденные.Колонки.Добавить("Ссылка");
	Найденные.Колонки.Добавить("Данные");
	Найденные.Колонки.Добавить("Метаданные");
	Найденные.Колонки.Добавить("ТекстОшибки");
	// Для отображения картинки в строке дерева
	Найденные.Колонки.Добавить("ПрепятствуетУдалениюНепосредственно");
	
	ТипыУдаленныхОбъектов = ПолучитьТаблицуТиповУдаляемыхОбъектов(Удаляемые);
	
	// Предварительная сортировка удаляемых объектов по приоритету
	ТаблицаУдаляемыхСПриоритетами = Новый ТаблицаЗначений;
	ТаблицаУдаляемыхСПриоритетами.Колонки.Добавить("Значение");
	ТаблицаУдаляемыхСПриоритетами.Колонки.Добавить("Приоритет");
	
	УдаляемыхВсего = Удаляемые.Количество();
	Для Сч = 1 По УдаляемыхВсего Цикл
		
		ИндексЭлемента = УдаляемыхВсего - Сч;
		ТекущийУдаляемый = Удаляемые[ИндексЭлемента];
		Приоритет = УдалениеОбъектовПовтИсп.ПорядокУдаленияЭлемента(ТекущийУдаляемый.Метаданные().ПолноеИмя());
		
		// Оставляем только значения с приоритетом 0, остальное записываем в таблицу значений
		Если Приоритет <> 0 Тогда
			Удаляемые.Удалить(ИндексЭлемента);
			Стр = ТаблицаУдаляемыхСПриоритетами.Добавить();
			Стр.Значение = ТекущийУдаляемый;
			Стр.Приоритет = Приоритет;
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаУдаляемыхСПриоритетами.Сортировать("Приоритет");	
	ИндексДляВставкиВНачало = 0;
	Для Каждого Стр Из ТаблицаУдаляемыхСПриоритетами Цикл
		Если Стр.Приоритет < 0 Тогда
			Удаляемые.Вставить(ИндексДляВставкиВНачало, Стр.Значение);
			ИндексДляВставкиВНачало = ИндексДляВставкиВНачало + 1;
		Иначе
			Удаляемые.Добавить(Стр.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ОбработанныеУдаляемые = Новый Массив;
	УдаляемыхОбработано = 0;
	
	Для Каждого УдаляемыйОбъект Из Удаляемые Цикл
		
		НачатьТранзакцию();
		
		// Объекты, найденные по ссылкам на УдаляемыйОбъект, которые были успешно удалены в этой транзакции
		УспешноУдаленныеВРамкахТранзакции = Новый Массив;
		
		ОбъектУдаленУспешно = УдалитьОбъект(УдаляемыйОбъект, Удаляемые, ОбработанныеУдаляемые, 
			УдаляемыхОбработано, НеУдаленные, Найденные, УспешноУдаленныеВРамкахТранзакции);
		
		Если ОбъектУдаленУспешно Тогда
			ЗафиксироватьТранзакцию();
		Иначе
			ОтменитьТранзакцию();
			
			// Эти элементы должны попасть в процедуру удаления еще раз, т.к. транзакция отменена
			Для Каждого УспешноУдаленный Из УспешноУдаленныеВРамкахТранзакции Цикл 
				ИндексНайденногоЭлемента = ОбработанныеУдаляемые.Найти(УспешноУдаленный);
				Если ИндексНайденногоЭлемента <> Неопределено Тогда
					ОбработанныеУдаляемые.Удалить(ИндексНайденногоЭлемента);
					УдаляемыхОбработано = УдаляемыхОбработано - 1;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		ТекущийПроцент = Окр(90 * УдаляемыхОбработано / УдаляемыхВсего) + 5;
		Если ТекущийПроцент > ПроцентВыполнения Тогда
			ПроцентВыполнения = ТекущийПроцент;
			ВывестиПроцентВыполнения(ПроцентВыполнения, ЭтоФайловаяБД);
		КонецЕсли;
		
	КонецЦикла;
	
	ВывестиПроцентВыполнения(97, ЭтоФайловаяБД);
	
	Для Каждого НеУдаленныйОбъект Из НеУдаленные Цикл
		НайденныеСтроки = ТипыУдаленныхОбъектов.НайтиСтроки(Новый Структура("Тип", ТипЗнч(НеУдаленныйОбъект)));
		Если НайденныеСтроки.Количество() > 0 Тогда
			ТипыУдаленныхОбъектов.Удалить(НайденныеСтроки[0]);
		КонецЕсли;
	КонецЦикла;
	
	ТипыУдаленныхОбъектовМассив = ТипыУдаленныхОбъектов.ВыгрузитьКолонку("Тип");
	
	Результат = ЗаполнитьСтатусОперации(
		Новый Структура("Найденные, НеУдаленные, ТипыУдаленныхОбъектов",
		Найденные, НеУдаленные, ТипыУдаленныхОбъектовМассив));
		
	ПоместитьВоВременноеХранилище(Результат, АдресХранилищаРезультата);
	
	ВывестиПроцентВыполнения(98, ЭтоФайловаяБД);
	
КонецПроцедуры
	
Функция УдалитьОбъект(
			УдаляемыйОбъект,
			Удаляемые,
			ОбработанныеУдаляемые,
			УдаляемыхОбработано,
			НеУдаленные,
			Найденные,
			УспешноУдаленныеВРамкахТранзакции)
			
	// Объект в списке не удаленных
	Если НеУдаленные.Найти(УдаляемыйОбъект) <> Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Объект уже удален
	Если ОбработанныеУдаляемые.Найти(УдаляемыйОбъект) <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	ОбработанныеУдаляемые.Добавить(УдаляемыйОбъект);
	УдаляемыхОбработано = УдаляемыхОбработано + 1;
	
	// Формирование полного массива удаляемых объектов
	ТекущийМассивУдаляемых = Новый Массив;
	ТекущийМассивУдаляемых.Добавить(УдаляемыйОбъект);
	
	ТаблицаСвязанных = 
		УдалениеОбъектовПереопределяемый.ПолучитьТаблицуСвязанныхОбъектов(УдаляемыйОбъект);
	
	Для Каждого СтрокаСвязанного Из ТаблицаСвязанных Цикл
		ТекущийМассивУдаляемых.Добавить(СтрокаСвязанного.СвязанныйОбъект);
		// Пометка на удаление связанных объектов
		Если Не СтрокаСвязанного.ПометкаУдаленияСвязанного Тогда
			Попытка
				Объект = СтрокаСвязанного.СвязанныйОбъект.ПолучитьОбъект();
				Объект.УстановитьПометкуУдаления(Истина);
			Исключение
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при удалении объекта %1:
				|Ошибка при пометке удаления связанного объекта %2:'")
				+ Символы.ПС
				+ ОписаниеОшибки(),
				УдаляемыйОбъект,
				СтрокаСвязанного.СвязанныйОбъект);
				ВызватьИсключение(ТекстОшибки);
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	// Удаление данных связанных регистров
	УдалитьДанныеСвязанныхРегистров(ТекущийМассивУдаляемых);
	
	// Блокируем данные для редактирования
	Для Каждого Эл Из ТекущийМассивУдаляемых Цикл
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Эл);
		Исключение
			
			ДанныеОПроблемеУдаления = Новый Структура;
			
			Если Эл = УдаляемыйОбъект Тогда
				ТекстОшибки = НСтр("ru = 'Объект заблокирован'");
				ДанныеОПроблемеУдаления.Вставить("Ссылка", Эл);
			Иначе
				ТекстОшибки = НСтр("ru = 'Связанный объект заблокирован'");
				ДанныеОПроблемеУдаления.Вставить("Ссылка", УдаляемыйОбъект);
				ДанныеОПроблемеУдаления.Вставить("Данные", Эл);
				ДанныеОПроблемеУдаления.Вставить("Метаданные", Эл.Метаданные());
			КонецЕсли;
			
			ЗаполнитьСведенияОНевозможностиУдаления(
				УдаляемыйОбъект, ДанныеОПроблемеУдаления, Найденные, НеУдаленные, ТекстОшибки);
				
			Возврат Ложь;	
			
		КонецПопытки;
		
	КонецЦикла;
	
	// Нужно проверять ссылки на подчиненные объекты, т.к. они удалятся автоматически
	ПодчиненныеОбъекты = Новый Массив;
	ПараметрыДляПоискаПодчиненных = УдалениеОбъектовПовтИсп.ПараметрыДляПоискаПодчиненных(
		УдаляемыйОбъект.Метаданные().ПолноеИмя());
	
	// Подчиненные по иерархии
	//МиСофт+
	Если Не ПараметрыДляПоискаПодчиненных.ЗапросПоИерархии = Неопределено
	//МиСофт-
		И (ПараметрыДляПоискаПодчиненных.ВидИерархии <> "ИерархияГруппИЭлементов"
			Или УдаляемыйОбъект.ЭтоГруппа) Тогда
		
		Запрос = ПараметрыДляПоискаПодчиненных.ЗапросПоИерархии;
		Запрос.УстановитьПараметр("УдаляемыйЭлемент", УдаляемыйОбъект);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ПодчиненныеОбъекты.Добавить(Выборка.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
	// Подчиненные по владельцу
	Если ПараметрыДляПоискаПодчиненных.ЗапросПоВладельцу <> Неопределено Тогда
		
		Запрос = ПараметрыДляПоискаПодчиненных.ЗапросПоВладельцу;
		Запрос.УстановитьПараметр("УдаляемыйЭлемент", УдаляемыйОбъект);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ПодчиненныеОбъекты.Добавить(Выборка.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
	УдалитьОбъекты(ТекущийМассивУдаляемых);
	Для Каждого Эл Из ПодчиненныеОбъекты Цикл
		ТекущийМассивУдаляемых.Добавить(Эл);
	КонецЦикла;
	ТаблицаСсылок = НайтиПоСсылкам(ТекущийМассивУдаляемых);
	ТаблицаСсылок.Колонки.Добавить("ИмяРегистраСведений");
	
	Результат = Истина;
	
	// Проверка оставшихся ссылок на удаляемый объект
	Для Каждого СтрокаСсылки Из ТаблицаСсылок Цикл    
		
		Если Удаляемые.Найти(СтрокаСсылки.Данные) <> Неопределено Тогда
			Если Результат Тогда
				
				// Найдена ссылка в другом удаляемом объекте - его тоже нужно удалить в этой транзакции
				НайденныйПоСсылкеУдаленУспешно = УдалитьОбъект(
					СтрокаСсылки.Данные, Удаляемые, ОбработанныеУдаляемые, УдаляемыхОбработано, 
					НеУдаленные, Найденные, УспешноУдаленныеВРамкахТранзакции);
					
				Результат = Результат И НайденныйПоСсылкеУдаленУспешно;
				
				Если НайденныйПоСсылкеУдаленУспешно Тогда
					УспешноУдаленныеВРамкахТранзакции.Добавить(СтрокаСсылки.Данные);
				КонецЕсли;
				
			КонецЕсли;
		Иначе
			
			ТипНайденныхДанных = ТипЗнч(СтрокаСсылки.Данные);
			ИмяРегистраСведений = ИмяРегистраСведенийПоТипу(ТипНайденныхДанных);
			// Ключи записей регистров пока не препятствуют удалению, т.к. после обработки всех ссылок
			// этих записей в регистрах может уже не быть
			Если ИмяРегистраСведений <> Неопределено Тогда
				СтрокаСсылки.ИмяРегистраСведений = ИмяРегистраСведений;
			Иначе
				Результат = Ложь;
				ЗаполнитьСведенияОНевозможностиУдаления(УдаляемыйОбъект, СтрокаСсылки, Найденные, НеУдаленные);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Проверка наличия записей регистров
	Для Каждого СтрокаСсылки Из ТаблицаСсылок Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаСсылки.ИмяРегистраСведений) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Результат Тогда
			Если ЕстьЗаписьВРегистре(СтрокаСсылки.Данные, СтрокаСсылки.ИмяРегистраСведений) Тогда
				Результат = Ложь;
			КонецЕсли;
		КонецЕсли;
			
		Если Не Результат Тогда
			ЗаполнитьСведенияОНевозможностиУдаления(УдаляемыйОбъект, СтрокаСсылки, Найденные, НеУдаленные);
		КонецЕсли;

	КонецЦикла;
	
	// Вывод ссылок, не препятствующих удалению непосредственно
	Если Результат = Ложь Тогда
		Для Каждого СтрокаСсылки Из ТаблицаСсылок Цикл    
			Если Удаляемые.Найти(СтрокаСсылки.Данные) <> Неопределено Тогда
				ЗаполнитьСведенияОНевозможностиУдаления(
					УдаляемыйОбъект, СтрокаСсылки, Найденные, НеУдаленные,, Ложь);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьСведенияОНевозможностиУдаления(УдаляемыйОбъект, ДанныеОСсылке, Найденные, 
			НеУдаленные, ТекстОшибки = Неопределено, ПрепятствуетУдалениюНепосредственно = Неопределено)
			
	Найденный = Найденные.Добавить();
	ЗаполнитьЗначенияСвойств(Найденный, ДанныеОСсылке);
	
	Если ПрепятствуетУдалениюНепосредственно <> Неопределено Тогда
		Найденный.ПрепятствуетУдалениюНепосредственно = ПрепятствуетУдалениюНепосредственно;
	Иначе
		Найденный.ПрепятствуетУдалениюНепосредственно = Истина;
	КонецЕсли;
	
	Если УдаляемыйОбъект <> ДанныеОСсылке.Ссылка Тогда
		Найденный.Ссылка = УдаляемыйОбъект;
		Найденный.Данные = ДанныеОСсылке.Ссылка;
		Найденный.ПрепятствуетУдалениюНепосредственно = Ложь;
		Найденный.Метаданные = ДанныеОСсылке.Ссылка.Метаданные();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Найденный.ТекстОшибки = ТекстОшибки;
	КонецЕсли;
	
	Если ТипЗнч(Найденный.Метаданные) = Тип("ОбъектМетаданных") Тогда
		// Сохраняется полное имя, т.к. метаданные не сериализуются
		Найденный.Метаданные = Найденный.Метаданные.ПолноеИмя();
	КонецЕсли;

	Если НеУдаленные.Найти(УдаляемыйОбъект) = Неопределено Тогда
		НеУдаленные.Добавить(УдаляемыйОбъект);
	КонецЕсли;
	
	
КонецПроцедуры

Функция ПолучитьТаблицуТиповУдаляемыхОбъектов(Знач УдаляемыеОбъекты)
	
	УдаляемыеТипыОбъектов = Новый ТаблицаЗначений;
	УдаляемыеТипыОбъектов.Колонки.Добавить("Тип", Новый ОписаниеТипов("Тип"));
	
	Для Каждого УдаляемыйОбъект Из УдаляемыеОбъекты Цикл
		НовыйТип = УдаляемыеТипыОбъектов.Добавить();
		НовыйТип.Тип = ТипЗнч(УдаляемыйОбъект);
	КонецЦикла;
	
	УдаляемыеТипыОбъектов.Свернуть("Тип");
	
	Возврат УдаляемыеТипыОбъектов;
	
КонецФункции

// Удаляет записи регистров, имеющие ссылки на удаляемые объекты
Процедура УдалитьДанныеСвязанныхРегистров(УдаляемыеОбъекты)
	
	// ПапкиХраненияФайловОбъектовИнтегрированныхСистем
	ИмяРегистра = "ПапкиХраненияФайловОбъектовИнтегрированныхСистем";
	ПоляПоиска = Новый Массив;
	ПоляПоиска.Добавить("СсылкаНаПапкуФайловДО");
	УдалитьДанныеСвязанногоРегистра(ИмяРегистра, ПоляПоиска, УдаляемыеОбъекты);
	
	// УдалитьВизыСогласования
	ИмяРегистра = "УдалитьВизыСогласования";
	ПоляПоиска = Новый Массив;
	ПоляПоиска.Добавить("Автор");
	ПоляПоиска.Добавить("ПоместилВИсторию");
	ПоляПоиска.Добавить("УстановилРезультат");
	ПоляПоиска.Добавить("Источник");
	УдалитьДанныеСвязанногоРегистра(ИмяРегистра, ПоляПоиска, УдаляемыеОбъекты);
	
	УдалениеОбъектовПереопределяемый.УдалитьДанныеСвязанныхРегистров(УдаляемыеОбъекты);
	
КонецПроцедуры

// Удаляет записи регистра, имеющие ссылки на удаляемые объекты в указанных полях
// Параметры:
//  ИмяРегистра      - имя регистра, как оно задано в конфигураторе
//  ПоляПоиска       - массив полей, в которых нужно искать ссылки на удаляемые объекты
//  УдаляемыеОбъекты - массив удаляемых объектов
//
Процедура УдалитьДанныеСвязанногоРегистра(ИмяРегистра, ПоляПоиска, УдаляемыеОбъекты) Экспорт
	
	Если Не ЗначениеЗаполнено(ИмяРегистра)
		Или Не ЗначениеЗаполнено(ПоляПоиска)
		Или ТипЗнч(ПоляПоиска) <> Тип("Массив")
		Или ПоляПоиска.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	// Формирование текста запроса
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РС.*
		|ИЗ
		|	РегистрСведений." + ИмяРегистра + " КАК РС");
		
	КоличествоПолей = ПоляПоиска.Количество();
	Для Сч = 0 по КоличествоПолей - 1 Цикл
		
		Если Сч = 0 Тогда
			Запрос.Текст = Запрос.Текст + "
			|ГДЕ РС." + ПоляПоиска[Сч] + " В (&УдаляемыеОбъекты)";
		Иначе
			Запрос.Текст = Запрос.Текст + "
			|ИЛИ РС." + ПоляПоиска[Сч] + " В (&УдаляемыеОбъекты)";
		КонецЕсли;
		
	КонецЦикла;
	
	// Удаление найденных записей
	МенеджерЗаписи = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
	Запрос.УстановитьПараметр("УдаляемыеОбъекты", УдаляемыеОбъекты);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка); 
		МенеджерЗаписи.Удалить();
	КонецЦикла;
	
КонецПроцедуры

Функция ЗаполнитьСтатусОперации(знач Значение, знач Статус = Истина)
	
	Возврат Новый Структура("Статус, Значение", Статус, Значение);
	
КонецФункции

Процедура ВывестиПроцентВыполнения(Процент, ЭтоФайловаяБД)
	
	Если Не ЭтоФайловаяБД Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("###" + Процент);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет, что переданный тип является ключом записи регистра сведений
// если да, то возвращает имя регистра
// если нет, то Неопределено
// Параметры:
//  ТипСсылки - Тип ссылки, по которому производится поиск соответствующего регистра
//
Функция ИмяРегистраСведенийПоТипу(ТипСсылки)
	
	ИменаРегистровПоТипамКлючей = УдалениеОбъектовПовтИсп.ВсеТипыРегистровСведений();
	НайденноеИмяРС = ИменаРегистровПоТипамКлючей.Получить(ТипСсылки);
	
	Возврат НайденноеИмяРС;
	
КонецФункции

// Проверяет, что запись, соответствующая ключу, еще существует
// Параметры:
//  КлючЗаписи          - Проверяемый ключ записи регистра
//  ИмяРегистраСведений - Имя регистра сведений, в котором следует искать запись
//
Функция ЕстьЗаписьВРегистре(КлючЗаписи, ИмяРегистраСведений)
	
	МенеджерЗаписи = РегистрыСведений[ИмяРегистраСведений].СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, КлючЗаписи);
	МенеджерЗаписи.Прочитать();
	Возврат МенеджерЗаписи.Выбран();
	
КонецФункции
