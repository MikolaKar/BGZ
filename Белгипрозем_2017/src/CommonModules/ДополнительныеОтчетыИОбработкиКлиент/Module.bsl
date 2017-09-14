////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму с доступными командами.
//
// Параметры:
//   ПараметрКоманды            - Передается "как есть" из параметров обработчика команды.
//   ПараметрыВыполненияКоманды - Передается "как есть" из параметров обработчика команды.
//   Вид - Строка - Вид обработки, который можно получить из серии функций:
//       ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработки<...>()
//   ИмяРаздела - Строка - Имя раздела командного интерфейса, из которого вызывается команда.
//
Процедура ОткрытьФормуКомандДополнительныхОтчетовИОбработок(ПараметрКоманды, ПараметрыВыполненияКоманды, Вид, ИмяРаздела = "") Экспорт
	
	ОбъектыНазначения = Новый СписокЗначений;
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда // назначаемая обработка
		ОбъектыНазначения.ЗагрузитьЗначения(ПараметрКоманды);
	КонецЕсли;
	
	Параметры = Новый Структура("ОбъектыНазначения, Вид, ИмяРаздела, РежимОткрытияОкна");
	Параметры.ОбъектыНазначения = ОбъектыНазначения;
	Параметры.Вид = Вид;
	Параметры.ИмяРаздела = ИмяРаздела;
	Параметры.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("УправляемаяФорма") Тогда // назначаемая обработка
		Параметры.Вставить("ИмяФормы", ПараметрыВыполненияКоманды.Источник.ИмяФормы);
	КонецЕсли;
	
	ОткрытьФорму(
		"ОбщаяФорма.ДополнительныеОтчетыИОбработки", 
		Параметры,
		ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

// Открывает форму дополнительного отчета с заданным вариантом.
//
// Параметры:
//   Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка дополнительного отчета.
//   КлючВарианта - Строка - Имя варианта дополнительного отчета.
//
Процедура ОткрытьВариантДополнительногоОтчета(Ссылка, КлючВарианта) Экспорт
	
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяОтчета = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(Ссылка);
	ПараметрыОткрытия = Новый Структура("КлючВарианта", КлючВарианта);
	Уникальность = "ВнешнийОтчет." + ИмяОтчета + "/КлючВарианта." + КлючВарианта;
	ОткрытьФорму("ВнешнийОтчет." + ИмяОтчета + ".Форма", ПараметрыОткрытия, Неопределено, Уникальность);
	
КонецПроцедуры

// Подключает длительную операцию для выполнения команды из формы внешнего отчета или обработки.
//
// Параметры:
//   ИдентификаторКоманды - Строка - Имя команды как оно задано в функции СведенияОВнешнейОбработке() модуля объекта.
//   ПараметрыКоманды - Структура - Параметры выполнения команды. 
//     Обязательные параметры:
//       * ДополнительнаяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки -
//           Передается "Как есть" из параметров формы.
//     Необязательные параметры:
//       * СопровождающийТекст - Строка - Текст длительной операции.
//       * Заголовок           - Строка - Заголовок длительной операции.
//       * ОбъектыНазначения   - Массив - Ссылки объектов, для которых выполняется команда.
//           Используется для назначаемых дополнительных обработок.
//       * РезультатВыполнения - Структура -
//           См. СтандартныеПодсистемыКлиентСервер.НовыйРезультатВыполнения().
//     Служебные параметры, зарезервированные подсистемой:
//       * ИдентификаторКоманды - Строка - Имя выполняемой команды.
//     Помимо обязательных параметров может содержать "свои" для использования в обработчике команды.
//     При добавлении собственных параметров желательно использовать префикс,
//     исключающий пересечение со стандартными механизмами, например "Контекст...".
//   Форма - УправляемаяФорма - Форма, в которую необходимо вернуть результат.
//
// Важно:
//   Результат возвращается в обработчике ОбработкаВыбора().
//   Для первичной идентификации следует использовать функцию ИмяФормыДлительнойОперации().
//   Так же следует учитывать, что фоновые задания доступны только в клиент-серверном режиме.
//   Примеры использования можно найти в дополнительной обработке демо базы.
//
// Возвращаемое значение:
//   РезультатВыполнения - Структура - См. СтандартныеПодсистемыКлиентСервер.НовыйРезультатВыполнения().
//
// Пример обработчика команды:
//&НаКлиенте
//Процедура ОбработчикКоманды(Команда)
//	ИдентификаторКоманды = Команда.Имя;
//	ПараметрыКоманды = Новый Структура("ДополнительнаяОбработкаСсылка, СопровождающийТекст");
//	ПараметрыКоманды.ДополнительнаяОбработкаСсылка = ОбъектСсылка;
//	ПараметрыКоманды.СопровождающийТекст = НСтр("ru = 'Выполняется команда...'");
//	Состояние(ПараметрыКоманды.СопровождающийТекст);
//	Если СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
//		РезультатВыполнения = ВыполнитьКомандуНапрямую(ИдентификаторКоманды, ПараметрыКоманды);
//		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтотОбъект, РезультатВыполнения);
//	Иначе
//		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне(ИдентификаторКоманды, ПараметрыКоманды, ЭтотОбъект);
//	КонецЕсли;
//КонецПроцедуры
//
// Пример кода выполнения команды напрямую:
//&НаСервере
//Функция ВыполнитьКомандуНапрямую(ИдентификаторКоманды, ПараметрыКоманды)
//	Возврат ДополнительныеОтчетыИОбработки.ВыполнитьКомандуИзФормыВнешнегоОбъекта(ИдентификаторКоманды, ПараметрыКоманды, ЭтотОбъект);
//КонецФункции
//
// Пример обработчика выбора:
//&НаКлиенте
//Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
//	Если ИсточникВыбора.ИмяФормы = ДополнительныеОтчетыИОбработкиКлиент.ИмяФормыДлительнойОперации() Тогда
//		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтотОбъект, ВыбранноеЗначение);
//	КонецЕсли;
//КонецПроцедуры
//
// Пример получения ссылки дополнительной обработки:
//&НаСервере
//Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//	ОбъектСсылка = Параметры.ДополнительнаяОбработкаСсылка;
//КонецПроцедуры
//
Процедура ВыполнитьКомандуВФоне(ИдентификаторКоманды, ПараметрыКоманды, Форма) Экспорт
	
	ДополнительнаяОбработкаСсылка = Неопределено;
	ПараметрыКоманды.Свойство("ДополнительнаяОбработкаСсылка", ДополнительнаяОбработкаСсылка);
	НекорректныйТип = ТипЗнч(ДополнительнаяОбработкаСсылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки");
	Если НекорректныйТип ИЛИ ДополнительнаяОбработкаСсылка = ПредопределенноеЗначение("Справочник.ДополнительныеОтчетыИОбработки.ПустаяСсылка") Тогда
		
		ТекстОшибки = НСтр("ru = 'Некорректное значение параметра ""ДополнительнаяОбработкаСсылка"":'") + Символы.ПС;
		Если НекорректныйТип Тогда
			ТекстОшибки = ТекстОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Передан тип ""%1"", ожидался ""%2"".'"),
				Строка(ТипЗнч(ДополнительнаяОбработкаСсылка)),
				Строка(Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки")));
		Иначе
			ТекстОшибки = ТекстОшибки + НСтр("ru = 'Передана пустая ссылка. Вероятно, обработка была открыта напрямую.'");
		КонецЕсли;
		
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	ПараметрыКоманды.Вставить("ИдентификаторКоманды", ИдентификаторКоманды);
	
	ПараметрыФормы = Новый Структура("ПараметрыЗапускаФоновогоЗадания", ПараметрыКоманды);
	
	ОткрытьФорму(ИмяФормыДлительнойОперации(), ПараметрыФормы, Форма);
	
КонецПроцедуры

// Возвращает имя формы для идентификации результата выполнения длительной операции.
//
// Возвращаемое значение:
//   Строка - См. ВыполнитьКомандуВФоне().
//
Функция ИмяФормыДлительнойОперации() Экспорт
	
	Возврат "ОбщаяФорма.ДлительнаяОперацияДополнительныхОтчетовИОбработок";
	
КонецФункции

// Выполняет назначаемую команду на клиенте, используя только неконтекстные серверные вызов.
//   Возвращает Ложь если для выполнения команды требуется серверный вызов.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма, из которой вызвана команда.
//   ИмяЭлемента - Строка - Имя команды формы, которая была нажата.
//
// Возвращаемое значение:
//   Булево - Способ выполнения.
//       Истина - Команда обработки выполняется неконтекстно.
//       Ложь - Для выполнения требуется контекстный вызов сервера.
//
Функция ВыполнитьНазначаемуюКомандуНаКлиенте(Форма, ИмяЭлемента) Экспорт
	ОчиститьСообщения();
	
	Найденные = Форма.КомандыДополнительныхОбработок.НайтиСтроки(Новый Структура("ИмяЭлемента", ИмяЭлемента));
	Если Найденные.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Команда не найдена'");
	КонецЕсли;
	
	ВыполняемаяКоманда = Найденные[0];
	
	Если ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ЗаполнениеФормы") Тогда
		Возврат Ложь; // Для выполнения команды требуется контекстный вызов сервера.
	КонецЕсли;
	
	Объект = Форма.Объект;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма",  Форма);
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ВыполняемаяКоманда", ВыполняемаяКоманда);
	
	Если Объект.Ссылка.Пустая() ИЛИ Форма.Модифицированность Тогда
		ТекстВопроса = СтрЗаменить(
			НСтр("ru = 'Для выполнения команды ""%1"" необходимо записать данные.'"),
			"%1",
			ВыполняемаяКоманда.Представление);
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Записать и продолжить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		Обработчик = Новый ОписаниеОповещения("ВыполнитьНазначаемуюКомандуНаКлиентеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Обработчик, ТекстВопроса, Кнопки, 60, КодВозвратаДиалога.Да);
	Иначе
		ВыполнитьНазначаемуюКомандуНаКлиентеЗавершение(-1, ДополнительныеПараметры);
	КонецЕсли;
	
	Возврат Истина; // Для выполнения команды достаточно клиентского контекста.
КонецФункции

// Отображает результат выполнения команды.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма, для которой требуется вывод.
//   РезультатВыполнения - Структура - См. СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения()
//
Процедура ПоказатьРезультатВыполненияКоманды(Форма, РезультатВыполнения) Экспорт
	
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(Форма, РезультатВыполнения);
	
КонецПроцедуры

// Показывает диалог выбора файлов и помещает выбранные файлы во временное хранилище.
//   Совмещает работу методов глобального метода НачатьПомещениеФайла и ПоместитьФайлы,
//   возвращая идентичный результат вне зависимости от того, подключено расширение работы с файлами, или нет.
//
// Параметры:
//   ОбработчикРезультата - ОписаниеОповещения - Описание процедуры, принимающей результат выбора.
//   ИдентификаторФормы - УникальныйИдентификатор - Уникальный идентификатор формы, из которой выполняется размещение файла.
//   НачальноеИмяФайла - Строка - Полный путь и имя файла, которые будут предложены пользователю в начале выбора.
//   ПараметрыДиалога - Структура, Неопределено - См. свойства ДиалогВыбораФайла в синтакс-помощнике.
//       Используется в случае, если удалось подключить расширение работы с файлами.
//
// Значение первого параметра, возвращаемого в ОбработчикРезультата:
//   ПомещенныеФайлы - Результат выбора.
//       * - Неопределено - Пользователь отказался от выбора.
//       * - Массив из ОписаниеПереданногоФайла, Структура - Пользователь выбрал файл.
//           ** Имя      - Строка - Полное имя выбранного файла.
//           ** Хранение - Строка - Адрес во временном хранилище, по которому размещен файл.
//
// Ограничения:
//   Используется только для интерактивного выбора в диалоге.
//   Не используется для выбора каталогов - эта опция не поддерживается веб-клиентом.
//   Не поддерживается множественный выбор в веб-клиенте, если не установлено расширение работы с файлами.
//   Не поддерживается передача адреса временного хранилища.
//
Процедура ПоказатьПомещениеФайла(ОбработчикРезультата, ИдентификаторФормы, НачальноеИмяФайла, ПараметрыДиалога) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОбработчикРезультата", ОбработчикРезультата);
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		
		Если ПараметрыДиалога = Неопределено Тогда
			ПараметрыДиалога = Новый Структура;
		КонецЕсли;
		Если ПараметрыДиалога.Свойство("Режим") Тогда
			Режим = ПараметрыДиалога.Режим;
			Если Режим = РежимДиалогаВыбораФайла.ВыборКаталога Тогда
				ВызватьИсключение НСтр("ru = 'Выбор каталога не поддерживается'");
			КонецЕсли;
		Иначе
			Режим = РежимДиалогаВыбораФайла.Открытие;
		КонецЕсли;
		
		Диалог = Новый ДиалогВыбораФайла(Режим);
		Диалог.ПолноеИмяФайла = НачальноеИмяФайла;
		ЗаполнитьЗначенияСвойств(Диалог, ПараметрыДиалога);
		
		ПомещенныеФайлы = Новый Массив;
		Если ИдентификаторФормы <> Неопределено Тогда
			ВыборВыполнен = ПоместитьФайлы(, ПомещенныеФайлы, Диалог, Истина, ИдентификаторФормы);
		Иначе
			ВыборВыполнен = ПоместитьФайлы(, ПомещенныеФайлы, Диалог, Истина);
		КонецЕсли;
		ОбработатьРезультатПомещенияФайла(ВыборВыполнен, ПомещенныеФайлы, Неопределено, ДополнительныеПараметры);
		
	Иначе
		
		Обработчик = Новый ОписаниеОповещения("ОбработатьРезультатПомещенияФайла", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПомещениеФайла(Обработчик, , НачальноеИмяФайла, Истина, ИдентификаторФормы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов

// Открывает форму подбора дополнительных отчетов.
//
// Параметры:
//   ЭлементФормы - Произвольный - Элемент формы, в который выполняется подбор элементов.
//
// Места использования:
//   Справочник.РассылкиОтчетов.Форма.ФормаЭлемента.ДобавитьДополнительныйОтчет().
//
Процедура РассылкаОтчетовПодборДопОтчета(ЭлементФормы) Экспорт
	
	ДополнительныйОтчет = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет");
	Отчет               = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.Отчет");
	
	ОтборПоВиду = Новый СписокЗначений;
	ОтборПоВиду.Добавить(ДополнительныйОтчет, ДополнительныйОтчет);
	ОтборПоВиду.Добавить(Отчет, Отчет);
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",  РежимОткрытияОкнаФормы.Независимый);
	ПараметрыФормыВыбора.Вставить("РежимВыбора",        Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормыВыбора.Вставить("Отбор",              Новый Структура("Вид", ОтборПоВиду));
	
	ОткрытьФорму("Справочник.ДополнительныеОтчетыИОбработки.ФормаВыбора", ПараметрыФормыВыбора, ЭлементФормы);
	
КонецПроцедуры

// Обработчик внешней команды печати.
//
// Параметры:
//  ПараметрыКоманды - Структура        - структура из строки таблицы команд, см. ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати
//  Форма            - УправляемаяФорма - форма, в которой выполняется команда печати.
//
Функция ВыполнитьНазначаемуюКомандуПечати(ВыполняемаяКоманда, Форма) Экспорт
	
	// Перенос дополнительных параметров, переданных этой подсистемой, в корень структуры.
	Для Каждого КлючИЗначение Из ВыполняемаяКоманда.ДополнительныеПараметры Цикл
		ВыполняемаяКоманда.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	// Запись фиксированных параметров.
	ВыполняемаяКоманда.Вставить("ЭтоОтчет", Ложь);
	ВыполняемаяКоманда.Вставить("Вид", ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма"));
	
	// Запуск метода обработки, соответствующего контексту команды.
	ВариантЗапуска = ВыполняемаяКоманда.ВариантЗапуска;
	Если ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы") Тогда
		ВыполнитьОткрытиеФормыОбработки(ВыполняемаяКоманда, Форма, ВыполняемаяКоманда.ОбъектыПечати);
	ИначеЕсли ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода") Тогда
		ВыполнитьКлиентскийМетодОбработки(ВыполняемаяКоманда, Форма, ВыполняемаяКоманда.ОбъектыПечати);
	Иначе
		ВыполнитьОткрытиеПечатнойФормы(ВыполняемаяКоманда, Форма, ВыполняемаяКоманда.ОбъектыПечати);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выводит оповещение перед запуском команды.
Процедура ПоказатьОповещениеПриВыполненииКоманды(ВыполняемаяКоманда) Экспорт
	Если ВыполняемаяКоманда.ПоказыватьОповещение Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Команда выполняется...'"), , ВыполняемаяКоманда.Представление);
	КонецЕсли;
КонецПроцедуры

// Открывает форму обработки.
Процедура ВыполнитьОткрытиеФормыОбработки(ВыполняемаяКоманда, Форма, ОбъектыНазначения) Экспорт
	ПараметрыОбработки = Новый Структура("ИдентификаторКоманды, ДополнительнаяОбработкаСсылка, ИмяФормы, КлючСессии");
	ПараметрыОбработки.ИдентификаторКоманды          = ВыполняемаяКоманда.Идентификатор;
	ПараметрыОбработки.ДополнительнаяОбработкаСсылка = ВыполняемаяКоманда.Ссылка;
	ПараметрыОбработки.ИмяФормы                      = ?(Форма = Неопределено, Неопределено, Форма.ИмяФормы);
	ПараметрыОбработки.КлючСессии = ВыполняемаяКоманда.Ссылка.УникальныйИдентификатор();
	
	Если ТипЗнч(ОбъектыНазначения) = Тип("Массив") Тогда
		ПараметрыОбработки.Вставить("ОбъектыНазначения", ОбъектыНазначения);
	КонецЕсли;
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ВнешняяОбработка = ДополнительныеОтчетыИОбработкиВызовСервера.ПолучитьОбъектВнешнейОбработки(ВыполняемаяКоманда.Ссылка);
		ФормаОбработки = ВнешняяОбработка.ПолучитьФорму(, Форма);
		Если ФормаОбработки = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для отчета или обработки ""%1"" не назначена основная форма,
				|или основная форма не предназначена для запуска в обычном приложении.
				|Команда ""%2"" не может быть выполнена.'"),
				Строка(ВыполняемаяКоманда.Ссылка),
				ВыполняемаяКоманда.Представление);
		КонецЕсли;
		ФормаОбработки.Открыть();
		ФормаОбработки = Неопределено;
	#Иначе
		ИмяОбработки = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(ВыполняемаяКоманда.Ссылка);
		Если ВыполняемаяКоманда.ЭтоОтчет Тогда
			ОткрытьФорму("ВнешнийОтчет."+ ИмяОбработки +".Форма", ПараметрыОбработки, Форма);
		Иначе
			ОткрытьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма", ПараметрыОбработки, Форма);
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

// Выполняет клиентский метод обработки.
Процедура ВыполнитьКлиентскийМетодОбработки(ВыполняемаяКоманда, Форма, ОбъектыНазначения) Экспорт
	
	ПоказатьОповещениеПриВыполненииКоманды(ВыполняемаяКоманда);
	
	ПараметрыОбработки = Новый Структура("ИдентификаторКоманды, ДополнительнаяОбработкаСсылка, ИмяФормы");
	ПараметрыОбработки.ИдентификаторКоманды          = ВыполняемаяКоманда.Идентификатор;
	ПараметрыОбработки.ДополнительнаяОбработкаСсылка = ВыполняемаяКоманда.Ссылка;
	ПараметрыОбработки.ИмяФормы                      = ?(Форма = Неопределено, Неопределено, Форма.ИмяФормы);;
	
	Если ТипЗнч(ОбъектыНазначения) = Тип("Массив") Тогда
		ПараметрыОбработки.Вставить("ОбъектыНазначения", ОбъектыНазначения);
	КонецЕсли;
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ВнешняяОбработка = ДополнительныеОтчетыИОбработкиВызовСервера.ПолучитьОбъектВнешнейОбработки(ВыполняемаяКоманда.Ссылка);
		ФормаОбработки = ВнешняяОбработка.ПолучитьФорму(, Форма);
		Если ФормаОбработки = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для отчета или обработки ""%1"" не назначена основная форма,
				|или основная форма не предназначена для запуска в обычном приложении.
				|Команда ""%2"" не может быть выполнена.'"),
				Строка(ВыполняемаяКоманда.Ссылка),
				ВыполняемаяКоманда.Представление);
		КонецЕсли;
	#Иначе
		ИмяОбработки = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(ВыполняемаяКоманда.Ссылка);
		Если ВыполняемаяКоманда.ЭтоОтчет Тогда
			ФормаОбработки = ПолучитьФорму("ВнешнийОтчет."+ ИмяОбработки +".Форма", ПараметрыОбработки, Форма);
		Иначе
			ФормаОбработки = ПолучитьФорму("ВнешняяОбработка."+ ИмяОбработки +".Форма", ПараметрыОбработки, Форма);
		КонецЕсли;
	#КонецЕсли
	
	Если ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка")
		Или ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет") Тогда
		
		ФормаОбработки.ВыполнитьКоманду(ВыполняемаяКоманда.Идентификатор);
		
	ИначеЕсли ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов") Тогда
		
		СозданныеОбъекты = Новый Массив;
		
		ФормаОбработки.ВыполнитьКоманду(ВыполняемаяКоманда.Идентификатор, ОбъектыНазначения, СозданныеОбъекты);
		
		ТипыСозданныхОбъектов = Новый Массив;
		
		Для Каждого СозданныйОбъект Из СозданныеОбъекты Цикл
			Тип = ТипЗнч(СозданныйОбъект);
			Если ТипыСозданныхОбъектов.Найти(Тип) = Неопределено Тогда
				ТипыСозданныхОбъектов.Добавить(Тип);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Тип Из ТипыСозданныхОбъектов Цикл
			ОповеститьОбИзменении(Тип);
		КонецЦикла;
		
	ИначеЕсли ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма") Тогда
		
		ФормаОбработки.Печать(ВыполняемаяКоманда.Идентификатор, ОбъектыНазначения);
		
	ИначеЕсли ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта") Тогда
		
		ФормаОбработки.ВыполнитьКоманду(ВыполняемаяКоманда.Идентификатор, ОбъектыНазначения);
		
		ТипыИзмененныхОбъектов = Новый Массив;
		
		Для Каждого ИзмененныйОбъект Из ОбъектыНазначения Цикл
			Тип = ТипЗнч(ИзмененныйОбъект);
			Если ТипыИзмененныхОбъектов.Найти(Тип) = Неопределено Тогда
				ТипыИзмененныхОбъектов.Добавить(Тип);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Тип Из ТипыИзмененныхОбъектов Цикл
			ОповеститьОбИзменении(Тип);
		КонецЦикла;
		
	ИначеЕсли ВыполняемаяКоманда.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.Отчет") Тогда
		
		ФормаОбработки.ВыполнитьКоманду(ВыполняемаяКоманда.Идентификатор, ОбъектыНазначения);
		
	КонецЕсли;
	
	ФормаОбработки = Неопределено;
	
КонецПроцедуры

// Формирует табличный документ в форме подсистемы "Печать".
Процедура ВыполнитьОткрытиеПечатнойФормы(ВыполняемаяКоманда, Форма, ОбъектыНазначения) Экспорт
	
	СтандартнаяОбработка = Истина;
	ДополнительныеОтчетыИОбработкиКлиентПереопределяемый.ПередВыполнениемКомандыПечатиВнешнейПечатнойФормы(ОбъектыНазначения, СтандартнаяОбработка);
	
	Параметры = Новый Структура;
	Параметры.Вставить("ВыполняемаяКоманда", ВыполняемаяКоманда);
	Параметры.Вставить("Форма", Форма);
	Если СтандартнаяОбработка Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОткрытиеПечатнойФормыЗавершение", ЭтотОбъект, Параметры);
		УправлениеПечатьюКлиент.ПроверитьПроведенностьДокументов(ОписаниеОповещения, ОбъектыНазначения, Форма);
	Иначе
		ВыполнитьОткрытиеПечатнойФормыЗавершение(ОбъектыНазначения, Параметры);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ВыполнитьОткрытиеПечатнойФормы.
Процедура ВыполнитьОткрытиеПечатнойФормыЗавершение(ОбъектыНазначения, ДополнительныеПараметры) Экспорт
	
	ВыполняемаяКоманда = ДополнительныеПараметры.ВыполняемаяКоманда;
	Форма = ДополнительныеПараметры.Форма;
	
	ПараметрыИсточника = Новый Структура;
	ПараметрыИсточника.Вставить("ИдентификаторКоманды", ВыполняемаяКоманда.Идентификатор);
	ПараметрыИсточника.Вставить("ОбъектыНазначения",    ОбъектыНазначения);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИсточникДанных",     ВыполняемаяКоманда.Ссылка);
	ПараметрыОткрытия.Вставить("ПараметрыИсточника", ПараметрыИсточника);
	
	ОткрытьФорму("ОбщаяФорма.ПечатьДокументов", ПараметрыОткрытия, Форма);
	
КонецПроцедуры

// Обработчик продолжения выполнения назначаемой команды на клиенте.
Процедура ВыполнитьНазначаемуюКомандуНаКлиентеЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Форма = ДополнительныеПараметры.Форма;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Если НЕ Форма.Записать() Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли Ответ <> -1 Тогда
		Возврат;
	КонецЕсли;
	
	ВыполняемаяКоманда = ДополнительныеПараметры.ВыполняемаяКоманда;
	Объект = ДополнительныеПараметры.Объект;
	
	ПараметрыВызоваСервера = Новый Структура;
	ПараметрыВызоваСервера.Вставить("ИдентификаторКоманды",          ВыполняемаяКоманда.Идентификатор);
	ПараметрыВызоваСервера.Вставить("ДополнительнаяОбработкаСсылка", ВыполняемаяКоманда.Ссылка);
	ПараметрыВызоваСервера.Вставить("ОбъектыНазначения",             Новый Массив);
	ПараметрыВызоваСервера.Вставить("ИмяФормы",                      Форма.ИмяФормы);
	ПараметрыВызоваСервера.ОбъектыНазначения.Добавить(Объект.Ссылка);
	
	ПоказатьОповещениеПриВыполненииКоманды(ВыполняемаяКоманда);
	
	// Контроль за результатом выполнения поддерживается только для серверных методов.
	// Если открывается форма или вызывается клиентский метод, то вывод результата выполнения выполняется обработкой.
	Если ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы") Тогда
		
		ИмяВнешнегоОбъекта = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(ВыполняемаяКоманда.Ссылка);
		Если ВыполняемаяКоманда.ЭтоОтчет Тогда
			ОткрытьФорму("ВнешнийОтчет."+ ИмяВнешнегоОбъекта +".Форма", ПараметрыВызоваСервера, Форма);
		Иначе
			ОткрытьФорму("ВнешняяОбработка."+ ИмяВнешнегоОбъекта +".Форма", ПараметрыВызоваСервера, Форма);
		КонецЕсли;
		
	ИначеЕсли ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода") Тогда
		
		ИмяВнешнегоОбъекта = ДополнительныеОтчетыИОбработкиВызовСервера.ПодключитьВнешнююОбработку(ВыполняемаяКоманда.Ссылка);
		Если ВыполняемаяКоманда.ЭтоОтчет Тогда
			ФормаВнешнегоОбъекта = ПолучитьФорму("ВнешнийОтчет."+ ИмяВнешнегоОбъекта +".Форма", ПараметрыВызоваСервера, Форма);
		Иначе
			ФормаВнешнегоОбъекта = ПолучитьФорму("ВнешняяОбработка."+ ИмяВнешнегоОбъекта +".Форма", ПараметрыВызоваСервера, Форма);
		КонецЕсли;
		ФормаВнешнегоОбъекта.ВыполнитьКоманду(ПараметрыВызоваСервера.ИдентификаторКоманды, ПараметрыВызоваСервера.ОбъектыНазначения);
		
	ИначеЕсли ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода")
		Или ВыполняемаяКоманда.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.СценарийВБезопасномРежиме") Тогда
		
		ПараметрыВызоваСервера.Вставить("РезультатВыполнения", СтандартныеПодсистемыКлиентСервер.НовыйРезультатВыполнения());
		ДополнительныеОтчетыИОбработкиВызовСервера.ВыполнитьКоманду(ПараметрыВызоваСервера, Неопределено);
		Форма.Прочитать();
		ПоказатьРезультатВыполненияКоманды(Форма, ПараметрыВызоваСервера.РезультатВыполнения);
		
	КонецЕсли;
КонецПроцедуры

// Для редактирования текста в реквизитах таблиц.
Процедура РедактироватьМногострочныйТекст(ФормаИлиОбработчик, ТекстРедактирования, ВладелецРеквизита, ИмяРеквизита, Знач Заголовок = "") Экспорт
	
	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок = НСтр("ru = 'Комментарий'");
	КонецЕсли;
	
	ПараметрыИсточника = Новый Структура;
	ПараметрыИсточника.Вставить("ФормаИлиОбработчик", ФормаИлиОбработчик);
	ПараметрыИсточника.Вставить("ВладелецРеквизита",  ВладелецРеквизита);
	ПараметрыИсточника.Вставить("ИмяРеквизита",       ИмяРеквизита);
	Обработчик = Новый ОписаниеОповещения("РедактироватьМногострочныйТекстЗавершение", ЭтотОбъект, ПараметрыИсточника);
	
	ПоказатьВводСтроки(Обработчик, ТекстРедактирования, Заголовок, , Истина);
	
КонецПроцедуры

// Показывает диалог установки расширения, затем выгружает данные дополнительного отчета или обработки.
Процедура ВыгрузитьВФайл(ПараметрыВыгрузки) Экспорт
	ТекстСообщения = НСтр("ru = 'Для выгрузки внешней обработки (отчета) в файл рекомендуется установить расширение работы с файлами.'");
	Обработчик = Новый ОписаниеОповещения("ВыгрузитьВФайлЗавершение", ЭтотОбъект, ПараметрыВыгрузки);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик, ТекстСообщения);
КонецПроцедуры

// Показывает окно предупреждение, а после его закрытия вызывает обработчик с заданным результатом.
Процедура ВернутьРезультатПослеПоказаПредупреждения(ТекстПредупреждения, Обработчик, Результат) Экспорт
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Обработчик", ПодготовитьОбработчикДляДиалога(Обработчик));
	ПараметрыОбработчика.Вставить("Результат", Результат);
	Обработчик = Новый ОписаниеОповещения("ВернутьРезультатПослеПоказаПредупрежденияЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	ПоказатьПредупреждение(Обработчик, ТекстПредупреждения);
КонецПроцедуры

// Показывает окно предупреждение, а после его закрытия вызывает обработчик с заданным результатом.
Процедура ВернутьРезультатПослеПоказаФормы(Форма, Обработчик, Результат) Экспорт
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Обработчик", ПодготовитьОбработчикДляДиалога(Обработчик));
	ПараметрыОбработчика.Вставить("Результат", Результат);
	Форма.ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ВернутьРезультатПослеПоказаФормыЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	Форма.Открыть();
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВернутьРезультатПослеПоказаПредупрежденияЗавершение(ПараметрыОбработчика) Экспорт

	Если ТипЗнч(ПараметрыОбработчика.Обработчик) = Тип("ОписаниеОповещения") Тогда
		ВыполнитьОбработкуОповещения(ПараметрыОбработчика.Обработчик, ПараметрыОбработчика.Результат);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВернутьРезультатПослеПоказаФормыЗавершение(РезультатЗакрытия, ПараметрыОбработчика) Экспорт

	Если ТипЗнч(ПараметрыОбработчика.Обработчик) = Тип("ОписаниеОповещения") Тогда
		ВыполнитьОбработкуОповещения(ПараметрыОбработчика.Обработчик, ПараметрыОбработчика.Результат);
	КонецЕсли;
	
КонецПроцедуры

// Подготовка обработчика асинхронного диалога.
Функция ПодготовитьОбработчикДляДиалога(ОбработчикИлиСтруктура) Экспорт
	
	Если ТипЗнч(ОбработчикИлиСтруктура) = Тип("Структура") Тогда
		// Рекурсивная регистрация всех обработчиков вызывающего кода.
		Если ОбработчикИлиСтруктура.Свойство("ОбработчикРезультата") Тогда
			ОбработчикИлиСтруктура.ОбработчикРезультата = ПодготовитьОбработчикДляДиалога(ОбработчикИлиСтруктура.ОбработчикРезультата);
		КонецЕсли;
		Если ОбработчикИлиСтруктура.Свойство("АсинхронныйДиалог") Тогда
			// Регистрация открытого диалога.
			ОбработчикИлиСтруктура.АсинхронныйДиалог.Открыт = Истина;
			// Формирование обработчика (при этом фиксируется вся структура параметров).
			Обработчик = Новый ОписаниеОповещения(
				ОбработчикИлиСтруктура.АсинхронныйДиалог.ИмяПроцедуры,
				ОбработчикИлиСтруктура.АсинхронныйДиалог.Модуль,
				ОбработчикИлиСтруктура);
		Иначе
			Обработчик = Неопределено;
		КонецЕсли;
	Иначе
		Обработчик = ОбработчикИлиСтруктура;
	КонецЕсли;
	
	Возврат Обработчик;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Служебные обработчики асинхронных диалогов

// Обработчик результата работы процедуры ПоказатьПомещениеФайла.
Процедура ОбработатьРезультатПомещенияФайла(ВыборВыполнен, АдресИлиРезультатВыбора, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ДополнительныеПараметры.ОбработчикРезультата) = Тип("ОписаниеОповещения") Тогда
		
		Если ВыборВыполнен = Истина Тогда
			Если ТипЗнч(АдресИлиРезультатВыбора) = Тип("Массив") Тогда
				РезультатВыбора = АдресИлиРезультатВыбора;
			Иначе
				РезультатВыбора = Новый Массив;
				ЭлементРезультата = Новый Структура;
				ЭлементРезультата.Вставить("Хранение", АдресИлиРезультатВыбора);
				ЭлементРезультата.Вставить("Имя",      ВыбранноеИмяФайла);
				РезультатВыбора.Добавить(ЭлементРезультата);
			КонецЕсли;
		Иначе
			РезультатВыбора = Неопределено;
		КонецЕсли;
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОбработчикРезультата, РезультатВыбора);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик результата работы процедуры РедактироватьМногострочныйТекст.
Процедура РедактироватьМногострочныйТекстЗавершение(Текст, ПараметрыИсточника) Экспорт
	
	Если ТипЗнч(ПараметрыИсточника.ФормаИлиОбработчик) = Тип("УправляемаяФорма") Тогда
		Форма      = ПараметрыИсточника.ФормаИлиОбработчик;
		Обработчик = Неопределено;
	Иначе
		Форма      = Неопределено;
		Обработчик = ПараметрыИсточника.ФормаИлиОбработчик;
	КонецЕсли;
	
	Если Текст <> Неопределено Тогда
		
		Если ТипЗнч(ПараметрыИсточника.ВладелецРеквизита) = Тип("ДанныеФормыЭлементДерева")
			Или ТипЗнч(ПараметрыИсточника.ВладелецРеквизита) = Тип("ДанныеФормыЭлементКоллекции") Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыИсточника.ВладелецРеквизита, Новый Структура(ПараметрыИсточника.ИмяРеквизита, Текст));
		Иначе
			ПараметрыИсточника.ВладелецРеквизита[ПараметрыИсточника.ИмяРеквизита] = Текст;
		КонецЕсли;
		
		Если Форма <> Неопределено Тогда
			Если Не Форма.Модифицированность Тогда
				Форма.Модифицированность = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Обработчик <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Обработчик, Текст);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик результата работы процедуры ВыгрузитьВФайл.
Процедура ВыгрузитьВФайлЗавершение(Результат, ПараметрыВыгрузки) Экспорт
	Перем Адрес;
	
	ПараметрыВыгрузки.Свойство("АдресДанныхОбработки", Адрес);
	Если Не ЗначениеЗаполнено(Адрес) Тогда
		Адрес = ДополнительныеОтчетыИОбработкиВызовСервера.ПоместитьВХранилище(ПараметрыВыгрузки.Ссылка, Неопределено);
	КонецЕсли;
	
	Если Не ПодключитьРасширениеРаботыСФайлами() Тогда
		ПолучитьФайл(Адрес, ПараметрыВыгрузки.ИмяФайла, Истина);
		Возврат;
	КонецЕсли;
	
	ДиалогСохраненияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогСохраненияФайла.ПолноеИмяФайла = ПараметрыВыгрузки.ИмяФайла;
	ДиалогСохраненияФайла.Фильтр = ДополнительныеОтчетыИОбработкиКлиентСервер.ФильтрДиалоговВыбораИСохранения();
	ДиалогСохраненияФайла.ИндексФильтра = ?(ПараметрыВыгрузки.ЭтоОтчет, 1, 2);
	ДиалогСохраненияФайла.МножественныйВыбор = Ложь;
	ДиалогСохраненияФайла.Заголовок = НСтр("ru = 'Укажите файл'");
	
	Если ДиалогСохраненияФайла.Выбрать() Тогда
		ПолучаемыеФайлы = Новый Массив;
		ПолучаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(, Адрес));
		ПолучитьФайлы(ПолучаемыеФайлы, , ДиалогСохраненияФайла.ПолноеИмяФайла, Ложь);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
