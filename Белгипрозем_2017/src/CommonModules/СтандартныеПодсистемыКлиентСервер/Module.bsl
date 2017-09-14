////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработка результата выполнения

// Формирует шаблон результата выполнения.
//
// Возвращаемое значение: 
//   Результат - Структура - См. СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения().
//
Функция НовыйРезультатВыполнения(Результат = Неопределено) Экспорт
	Если Результат = Неопределено Тогда
		Результат = Новый Структура;
	КонецЕсли;
	
	Результат.Вставить("ВыводОповещения",     Новый Структура("Использование, Заголовок, Ссылка, Текст, Картинка", Ложь));
	Результат.Вставить("ВыводСообщения",      Новый Структура("Использование, Текст, ПутьКРеквизитуФормы", Ложь));
	Результат.Вставить("ВыводПредупреждения", Новый Структура("Использование, Заголовок, Текст, ПутьКРеквизитуФормы, ТекстОшибок", Ложь));
	Результат.Вставить("ОповещениеФорм",                Новый Структура("Использование, ИмяСобытия, Параметр, Источник", Ложь));
	Результат.Вставить("ОповещениеДинамическихСписков", Новый Структура("Использование, СсылкаИлиТип", Ложь));
	
	Возврат Результат;
КонецФункции

// Добавляет оповещения для обновления динамических списков по массиву ссылок объектов.
//
// Параметры:
//   ИзмененныеОбъекты - Массив - Ссылки измененных объектов.
//   Результат - Структура - См. СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения().
//
Процедура ПодготовитьОповещениеДинамическихСписков(ИзмененныеОбъекты, Результат) Экспорт
	Если ТипЗнч(ИзмененныеОбъекты) <> Тип("Массив") Или ИзмененныеОбъекты.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Результат.ОповещениеДинамическихСписков;
	Оповещение.Использование = Истина;
	
	Значение = Оповещение.СсылкаИлиТип;
	ЗначениеЗаполнено = ЗначениеЗаполнено(Значение);
	
	Если ИзмененныеОбъекты.Количество() = 1 И НЕ ЗначениеЗаполнено Тогда
		Оповещение.СсылкаИлиТип = ИзмененныеОбъекты[0];
	Иначе
		// Преобразование оповещения в массив.
		ТипЗначения = ТипЗнч(Значение);
		Если ТипЗначения <> Тип("Массив") Тогда
			Оповещение.СсылкаИлиТип = Новый Массив;
			Если ЗначениеЗаполнено Тогда
				Оповещение.СсылкаИлиТип.Добавить(?(ТипЗначения = Тип("Тип"), Значение, ТипЗначения));
			КонецЕсли;
		КонецЕсли;
		
		// Добавление типов измененных объектов.
		Для Каждого ИзмененныйОбъект Из ИзмененныеОбъекты Цикл
			ТипИзмененногоОбъекта = ТипЗнч(ИзмененныйОбъект);
			Если Оповещение.СсылкаИлиТип.Найти(ТипИзмененногоОбъекта) = Неопределено Тогда
				Оповещение.СсылкаИлиТип.Добавить(ТипИзмененногоОбъекта);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

// Добавляет в оповещение для динамических списков типы из массива измененных объектов.
//
// Параметры:
//   Результат  - Структура - См. СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения().
//   ИмяСобытия - Строка - Имя события, которое используется для первичной идентификации сообщений принимающими формами.
//   Параметр   - * - Набор данных, которые используются принимающей формой для обновления состава.
//   Источник   - * - Источник оповещения, например форма-источником.
//
Процедура РезультатВыполненияДобавитьОповещениеОткрытыхФорм(Результат, ИмяСобытия, Параметр = Неопределено, Источник = Неопределено) Экспорт
	Если Не Результат.Свойство("ОповещениеФорм") Тогда
		Результат.Вставить("ОповещениеФорм", Новый Массив);
	ИначеЕсли ТипЗнч(Результат.ОповещениеФорм) = Тип("Структура") Тогда // Структуру в массив структур.
		ОповещениеФорм = Результат.ОповещениеФорм;
		Результат.ОповещениеФорм = Новый Массив;
		Результат.ОповещениеФорм.Добавить(ОповещениеФорм);
	КонецЕсли;
	ОповещениеФорм = Новый Структура("Использование, ИмяСобытия, Параметр, Источник", Истина, ИмяСобытия, Параметр, Источник);
	Результат.ОповещениеФорм.Добавить(ОповещениеФорм);
КонецПроцедуры

#КонецОбласти
