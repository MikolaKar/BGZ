#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере() 
	
	СсылкаНаОбъект = Параметры.СсылкаНаОбъект;
	МетаданныеОбъекта = СсылкаНаОбъект.Метаданные();
	ТаблицаЗначенийДоступа = МетаданныеОбъекта.ПолноеИмя();
	
	Если СсылкаНаОбъект.Родитель.Пустая() Тогда
		Элементы.НаследоватьПраваРодителей.Видимость = Ложь;
	КонецЕсли;	
	
	Заголовок = Заголовок + " " + """" + Строка(СсылкаНаОбъект) + """";
	
	ПрочитатьПрава();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		
		СтруктураПоиска = Новый Структура("Пользователь");
		Для Каждого Эл Из ВыбранноеЗначение Цикл
			
			СтруктураПоиска.Пользователь = Эл;
			НайденныеСтроки = ТаблицаПрав.НайтиСтроки(СтруктураПоиска);
			
			Если НайденныеСтроки.Количество() = 0 Тогда
				Стр = ТаблицаПрав.Добавить();
				Стр.Пользователь = Эл;
				Стр.ПравоЧтения = 1;
				Стр.ПравоЧтенияСтрокой = СтрокаПрава(1);
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		ВызватьИсключение НСтр("ru = 'Неожиданный тип данных'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Права были изменены. Сохранить изменения?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьПраваИЗакрытьФорму();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаследоватьПраваРодителейПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ТаблицаПрав.Очистить();
	ПрочитатьПрава(НаследоватьПраваРодителей);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПрав

&НаКлиенте
Процедура ТаблицаПравВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.Унаследовано Тогда
		ТекстПредупреждения = НСтр("ru = 'Эти права нельзя изменить, т.к. они унаследованы от вышестоящей папки.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "ТаблицаПравПравоЧтенияСтрокой" Тогда
		ИзменитьПраво(Элемент.ТекущиеДанные.ПравоЧтения, Элемент.ТекущиеДанные.ПравоЧтенияСтрокой);
	ИначеЕсли Поле.Имя = "ТаблицаПравПравоДобавленияСтрокой" Тогда
		ИзменитьПраво(Элемент.ТекущиеДанные.ПравоДобавления, Элемент.ТекущиеДанные.ПравоДобавленияСтрокой);
	ИначеЕсли Поле.Имя = "ТаблицаПравПравоИзмененияСтрокой" Тогда
		ИзменитьПраво(Элемент.ТекущиеДанные.ПравоИзменения, Элемент.ТекущиеДанные.ПравоИзмененияСтрокой);
		Если Элемент.ТекущиеДанные.ПравоИзменения <> 1 Тогда
			// Нельзя давать право на удаление без права на изменение
			Если Элемент.ТекущиеДанные.ПравоУдаленияДанных = 1 Тогда
				Элемент.ТекущиеДанные.ПравоУдаленияДанных = 0;
				Элемент.ТекущиеДанные.ПравоУдаленияДанныхСтрокой = СтрокаПрава(0);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Поле.Имя = "ТаблицаПравПравоУдаленияДанныхСтрокой" Тогда
		ИзменитьПраво(Элемент.ТекущиеДанные.ПравоУдаленияДанных, Элемент.ТекущиеДанные.ПравоУдаленияДанныхСтрокой);
		// Нельзя давать право на удаление без права на изменение
		Если Элемент.ТекущиеДанные.ПравоУдаленияДанных = 1 Тогда
			Элемент.ТекущиеДанные.ПравоИзменения = 1;
			Элемент.ТекущиеДанные.ПравоИзмененияСтрокой = СТрокаПрава(Элемент.ТекущиеДанные.ПравоИзменения);
		КонецЕсли;	
	ИначеЕсли Поле.Имя = "ТаблицаПравПравоИзмененияПапокСтрокой" Тогда
		ИзменитьПраво(Элемент.ТекущиеДанные.ПравоИзмененияПапок, Элемент.ТекущиеДанные.ПравоИзмененияПапокСтрокой);
	ИначеЕсли Поле.Имя = "ТаблицаПравПравоУправленияПравамиСтрокой" Тогда
		ИзменитьПраво(Элемент.ТекущиеДанные.ПравоУправленияПравами, Элемент.ТекущиеДанные.ПравоУправленияПравамиСтрокой);
	ИначеЕсли Поле.Имя = "ТаблицаПравПередаватьДочернимСтрокой" Тогда
		Модифицированность = Истина;
		Если Элемент.ТекущиеДанные.ПередаватьДочерним = 1 Тогда
			Элемент.ТекущиеДанные.ПередаватьДочерним = 2;
		Иначе
			Элемент.ТекущиеДанные.ПередаватьДочерним = 1;
		КонецЕсли;
		Элемент.ТекущиеДанные.ПередаватьДочернимСтрокой = СтрокаПрава(Элемент.ТекущиеДанные.ПередаватьДочерним);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПравПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ДокументооборотПраваДоступаКлиент.ДобавитьСтрокуВТаблицуПрав(ЭтаФорма, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПравПередУдалением(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.Унаследовано Тогда
		ТекстПредупреждения = НСтр("ru = 'Эти права нельзя удалить, т.к. они унаследованы от вышестоящей папки.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПравПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбратьПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПравПользовательАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораПользователя(Текст);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	Если Не ДокументооборотПраваДоступаКлиент.ПроверитьТаблицуПравПапки(ТаблицаПрав) Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокаОшибки = ЗаписатьСервер();
	Если Не ПустаяСтрока(СтрокаОшибки) Тогда
		ПоказатьПредупреждение(, СтрокаОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьПраваИЗакрытьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПользователей(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыОткрытияФормы.Вставить("ВыборГруппПользователей", Истина);
	
	ОткрытьФорму("Справочник.Пользователи.Форма.ФормаСписка", ПараметрыОткрытияФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьПрава(СУчетомНаследования = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НастройкиПрав = РегистрыСведений.НастройкиПравОбъектов.Прочитать(СсылкаНаОбъект);
	Если СУчетомНаследования = Неопределено Тогда
		НаследоватьПраваРодителей = НастройкиПрав.Наследовать;
	КонецЕсли;	
	
	Для каждого Настройка Из НастройкиПрав.Настройки Цикл
		
		Если Не НаследоватьПраваРодителей И Настройка.НастройкаРодителя Тогда
			// Права родителей не добавляются
			Продолжить;
		КонецЕсли;
		
		ДобавитьПравоВТаблицуПрав(Настройка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПравоВТаблицуПрав(ОписаниеПрава)
	
	СтрокаПрав = Неопределено;
	
	Если ОписаниеПрава.НастройкаРодителя Тогда
		// Добавляем в начало
		СтрокаПрав = ТаблицаПрав.Вставить(0);
	Иначе	
		// Добавляем в конец	
		СтрокаПрав = ТаблицаПрав.Добавить();
	КонецЕсли;
	
	Если ОписаниеПрава.НастройкаРодителя Тогда
		СтрокаПрав.Унаследовано = Истина;
	Иначе	
		СтрокаПрав.Унаследовано = Ложь;
	КонецЕсли;	
	
	СтрокаПрав.Пользователь = ОписаниеПрава.Пользователь;
	
	// Признак, что эти права унаследованы
	Если ОписаниеПрава.НаследованиеРазрешено Тогда
		СтрокаПрав.ПередаватьДочерним = 1;
	Иначе	
		СтрокаПрав.ПередаватьДочерним = 2;
	КонецЕсли;	
	СтрокаПрав.ПередаватьДочернимСтрокой = СтрокаПрава(СтрокаПрав.ПередаватьДочерним);
	
	// Заполнение строки прав
	
	// Право ЧтениеПапокИТем
	Если ОписаниеПрава.ЧтениеПапокИТем = Ложь Тогда
		// Запрещено
		СтрокаПрав.ПравоЧтения = 2;
	ИначеЕсли ОписаниеПрава.ЧтениеПапокИТем = Истина Тогда
		// Разрешено
		СтрокаПрав.ПравоЧтения = 1;
	Иначе
		// Не определено
		СтрокаПрав.ПравоЧтения = 1;
	КонецЕсли;
	СтрокаПрав.ПравоЧтенияСтрокой = СтрокаПрава(СтрокаПрав.ПравоЧтения);
	
	// Право ДобавлениеТемИСообщений
	Если ОписаниеПрава.ДобавлениеТемИСообщений = Ложь Тогда
		// Запрещено
		СтрокаПрав.ПравоДобавления = 2;
	ИначеЕсли ОписаниеПрава.ДобавлениеТемИСообщений = Истина Тогда
		// Разрешено
		СтрокаПрав.ПравоДобавления = 1;
	Иначе
		// Не определено
		СтрокаПрав.ПравоДобавления = 0;
	КонецЕсли;
	СтрокаПрав.ПравоДобавленияСтрокой = СтрокаПрава(СтрокаПрав.ПравоДобавления);
	
	// Право ИзменениеПапок
	Если ОписаниеПрава.ИзменениеПапок = Ложь Тогда
		// Запрещено
		СтрокаПрав.ПравоИзмененияПапок = 2;
	ИначеЕсли ОписаниеПрава.ИзменениеПапок = Истина Тогда
		// Разрешено
		СтрокаПрав.ПравоИзмененияПапок = 1;
	Иначе
		// Не определено
		СтрокаПрав.ПравоИзмененияПапок = 0;
	КонецЕсли;
	СтрокаПрав.ПравоИзмененияПапокСтрокой = СтрокаПрава(СтрокаПрав.ПравоИзмененияПапок);
	
	// Право ИзменениеТемИСообщений
	Если ОписаниеПрава.ИзменениеТемИСообщений = Ложь Тогда
		// Запрещено
		СтрокаПрав.ПравоИзменения = 2;
	ИначеЕсли ОписаниеПрава.ИзменениеТемИСообщений = Истина Тогда
		// Разрешено
		СтрокаПрав.ПравоИзменения = 1;
	Иначе
		// Не определено
		СтрокаПрав.ПравоИзменения = 0;
	КонецЕсли;
	СтрокаПрав.ПравоИзмененияСтрокой = СтрокаПрава(СтрокаПрав.ПравоИзменения);
	
	// Право ПометкаУдаленияТемИСообщений
	Если ОписаниеПрава.ПометкаУдаленияТемИСообщений = Ложь Тогда
		// Запрещено
		СтрокаПрав.ПравоУдаленияДанных = 2;
	ИначеЕсли ОписаниеПрава.ПометкаУдаленияТемИСообщений = Истина Тогда
		// Разрешено
		СтрокаПрав.ПравоУдаленияДанных = 1;
	Иначе
		// Не определено
		СтрокаПрав.ПравоУдаленияДанных = 0;
	КонецЕсли;
	СтрокаПрав.ПравоУдаленияДанныхСтрокой = СтрокаПрава(СтрокаПрав.ПравоУдаленияДанных);
	
	// Право УправлениеПравами
	Если ОписаниеПрава.УправлениеПравами = Ложь Тогда
		// Запрещено
		СтрокаПрав.ПравоУправленияПравами = 2;
	ИначеЕсли ОписаниеПрава.УправлениеПравами = Истина Тогда
		// Разрешено
		СтрокаПрав.ПравоУправленияПравами = 1;
	Иначе
		// Не определено
		СтрокаПрав.ПравоУправленияПравами = 0;
	КонецЕсли;
	СтрокаПрав.ПравоУправленияПравамиСтрокой = СтрокаПрава(СтрокаПрав.ПравоУправленияПравами);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаПрава(Право)
	
	Если Право = 0 Тогда
		Возврат " ";
	ИначеЕсли Право = 1 Тогда
		Возврат НСтр("ru = 'Да'");
	ИначеЕсли Право = 2 Тогда
		Возврат НСтр("ru = 'Нет'");
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВыбратьПользователей()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ТекущаяСтрока", ?(Элементы.ТаблицаПрав.ТекущиеДанные = Неопределено, 
		Неопределено, Элементы.ТаблицаПрав.ТекущиеДанные.Пользователь));
	ПараметрыФормы.Вставить("ВыборГруппПользователей", Истина);
	
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, Элементы.ТаблицаПравПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПраво(Право, ПравоСтрокой) 
	
	Модифицированность = Истина;
	
	Право = Право + 1;
	Если Право > 2 Тогда
		Право = 0;
	КонецЕсли;
	
	ПравоСтрокой = СтрокаПрава(Право);
	
КонецПроцедуры

&НаСервере
Функция ПроверитьРазрешениеНаУправлениеПравами(ПропуститьВызовИсключения = Ложь, ОписаниеПредупреждения = "")
	
	РазрешеноУправлениеПравами = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(СсылкаНаОбъект).УправлениеПравами;
	
	Если НЕ РазрешеноУправлениеПравами Тогда
		ОписаниеПредупреждения = НСтр("ru = 'Вам более недоступно управление правами.'");
		
		Если НЕ ПропуститьВызовИсключения Тогда
			ВызватьИсключение НСтр("ru = 'Вам недоступно управление правами.'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат РазрешеноУправлениеПравами;
	
КонецФункции

&НаСервере
Функция ПреобразоватьПравоВБулево(Право)
	
	Если Право = 2 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Право = 1 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьПраваИЗакрытьФорму()
	
	Если Не ДокументооборотПраваДоступаКлиент.ПроверитьТаблицуПравПапки(ТаблицаПрав) Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокаОшибки = ЗаписатьСервер();
	Если ПустаяСтрока(СтрокаОшибки) Тогда
		Закрыть();
	Иначе
		ПоказатьПредупреждение(, СтрокаОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьСервер()
	
	ПроверитьРазрешениеНаУправлениеПравами();
	
	// Запись прав
	Попытка
		
		УстановитьПривилегированныйРежим(Истина);
		
		// Запись новых прав исключая права, наследуемые от родителей по иерархии.
		ОписаниеПрав = РегистрыСведений.НастройкиПравОбъектов.Прочитать(СсылкаНаОбъект).Настройки;
		ОписаниеПрав.Очистить();
		
		Для каждого Эл Из ТаблицаПрав Цикл
			
			Если Эл.Унаследовано Или Не ЗначениеЗаполнено(Эл.Пользователь) Тогда
				Продолжить;
			КонецЕсли;
			
			Строка = ОписаниеПрав.Добавить();
			Строка.ВладелецНастройки = СсылкаНаОбъект;
			Строка.ЧтениеПапокИТем = ПреобразоватьПравоВБулево(Эл.ПравоЧтения);
			Строка.ДобавлениеТемИСообщений = ПреобразоватьПравоВБулево(Эл.ПравоДобавления); 
			Строка.ИзменениеТемИСообщений = ПреобразоватьПравоВБулево(Эл.ПравоИзменения);
			Строка.ИзменениеПапок = ПреобразоватьПравоВБулево(Эл.ПравоИзмененияПапок);
			Строка.ПометкаУдаленияТемИСообщений = ПреобразоватьПравоВБулево(Эл.ПравоУдаленияДанных);
			Строка.УправлениеПравами = ПреобразоватьПравоВБулево(Эл.ПравоУправленияПравами);
			Строка.НаследованиеРазрешено = ПреобразоватьПравоВБулево(Эл.ПередаватьДочерним);
			Строка.НастройкаРодителя = Ложь;
			Строка.Пользователь = Эл.Пользователь;
			
		КонецЦикла;
		
		УстановитьПривилегированныйРежим(Истина);
		РегистрыСведений.НастройкиПравОбъектов.Записать(СсылкаНаОбъект, ОписаниеПрав, НаследоватьПраваРодителей);
		УстановитьПривилегированныйРежим(Ложь);
		
		ПротоколированиеРаботыПользователей.ЗаписатьИзменениеПрав(СсылкаНаОбъект);
		
		Модифицированность = Ложь;
		
	Исключение
		
		ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат НСтр("ru = 'Ошибка при записи прав:'") + Символы.ПС + ПредставлениеОшибки;
		
	КонецПопытки;
	
	Возврат "";
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьДанныеВыбораПользователя(Знач Текст, Знач ВключаяГруппы = Истина, Знач ВключаяВнешнихПользователей = Неопределено, БезПользователей = Ложь)
	
	Возврат Пользователи.СформироватьДанныеВыбораПользователя(Текст, ВключаяГруппы, ВключаяВнешнихПользователей, БезПользователей);
	
КонецФункции

#КонецОбласти