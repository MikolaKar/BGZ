////////////////////////////////////////////////////////////////////////////////
// Подсистема "Рассылка отчетов" (сервер, переопределяемый)
// 
// Выполняется на сервере, изменяется под специфику прикладной конфигурации, 
// но предназначен для использования только данной подсистемой.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет изменить форматы по умолчанию и установить картинки.
//
// Параметры:
//   СписокФорматов - СписокЗначений - Список форматов.
//       * Значение      - ПеречислениеСсылка.ФорматыСохраненияОтчетов - Ссылка формата.
//       * Представление - Строка - Представление формата.
//       * Пометка       - Булево - Признак того, что формат используется по умолчанию.
//       * Картинка      - Картинка - Картинка формата.
//
// Вспомогательные методы:
//   РассылкаОтчетов.УстановитьПараметрыФормата() - для изменения параметров формата.
//
// Например:
//	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "HTML4", , Ложь);
//	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "XLS"  , , Истина);
//
// См. также:
//   Другие примеры использования в РассылкаОтчетовПовтИсп.СписокФорматов().
//
Процедура ПереопределитьПараметрыФорматов(СписокФорматов) Экспорт
	
	
	
КонецПроцедуры

// Позволяет добавить описание кросс объектной связи типов для получателей рассылки.
//
// Важно:
//   Использовать данный механизм требуется только в том случае, если:
//   1. Требуется описать и представить несколько типов как один (как в справочнике Пользователи и Группы пользователей).
//   2. Требуется изменить представление типа без изменения синонима метаданных.
//   3. Требуется указать вид контактной информации E-Mail по умолчанию.
//   4. Требуется определить группу контактной информации.
//
// Параметры:
//   ТаблицаТипов - ТаблицаЗначений - Таблица описания типов.
//   ДоступныеТипы - Массив - Доступные типы.
//
// Вспомогательные методы:
//   РассылкаОтчетов.ДобавитьЭлементВТаблицуТиповПолучателей() - для регистрации параметров типа.
//
// Например:
//	Настройки = Новый Структура;
//	Настройки.Вставить("ОсновнойТип", Тип("СправочникСсылка.Контрагенты"));
//	Настройки.Вставить("ВидКИ", Справочники.ВидыКонтактнойИнформации.EmailКонтрагента);
//	РассылкаОтчетов.ДобавитьЭлементВТаблицуТиповПолучателей(ТаблицаТипов, ДоступныеТипы, Настройки);
//
// См. также:
//   Другие примеры использования в РассылкаОтчетовПовтИсп.ТаблицаТиповПолучателей().
//
Процедура ПереопределитьТаблицуТиповПолучателей(ТаблицаТипов, ДоступныеТипы) Экспорт
	
КонецПроцедуры

// Позволяет определить свой обработчик для сохранения табличного документа в формат.
//
// Параметры:
//   СтандартнаяОбработка - Булево - Признак использования стандартных механизмов подсистемы для сохранения в формат.
//   ТабличныйДокумент    - ТабличныйДокумент - Сохраняемый табличный документ.
//   Формат               - ПеречислениеСсылка.ФорматыСохраненияОтчетов - Формат, в котором сохраняется табличный документ.
//   ПолноеИмяФайла       - Строка - Полное имя файла.
//       Передается без расширения, если формат был добавлен в прикладной конфигурации.
//
// Важно:
//   Если используется нестандартная обработка (СтандартнаяОбработка меняется на Ложь),
//   тогда ПолноеИмяФайла должно содержать полное имя файла с расширением.
//
// Например:
//	Если Формат = Перечисления.ФорматыСохраненияОтчетов.HTML4 Тогда
//		СтандартнаяОбработка = Ложь;
//		ПолноеИмяФайла = ПолноеИмяФайла +".html";
//		ТабличныйДокумент.Записать(ПолноеИмяФайла, ТипФайлаТабличногоДокумента.HTML4);
//	КонецЕсли;
//
Процедура ПередСохранениемТабличногоДокументаВФормат(СтандартнаяОбработка, ТабличныйДокумент, Формат, ПолноеИмяФайла) Экспорт
	
	
	
КонецПроцедуры

// Позволяет определить свой обработчик разузлования списка получателей.
//
// Параметры:
//   ПараметрыПолучателей - Структура - Параметры разузлования получателей рассылки.
//   Запрос - Запрос - Запрос, который будет использован, если значение параметра СтандартнаяОбработка останется Истина.
//   СтандартнаяОбработка - Булево - Признак использования стандартных механизмов.
//   Результат - Соответствие - Получатели с их E-mail адресами.
//       * Ключ     - СправочникСсылка - Получатель.
//       * Значение - Строка - Набор E-mail адресов в строке с разделителями.
// 
Процедура ПередФормированиемСпискаПолучателейРассылки(ПараметрыПолучателей, Запрос, СтандартнаяОбработка, Результат) Экспорт
	
КонецПроцедуры

#КонецОбласти
