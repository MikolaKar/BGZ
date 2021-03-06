#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей Организации
//
// Возвращаемое значение:
//   Структура
//     Наименование
//     ИНН
//     КодПоОКПО
//     Комментарий
//     КПП
//     ОсновнойБанковскийСчет
//     ПолноеНаименование
//     Префикс
//     ЮрФизЛицо
//
Функция ПолучитьСтруктуруОрганизации() Экспорт
	
	СтруктураОрганизации = Новый Структура;
	СтруктураОрганизации.Вставить("Наименование");
	СтруктураОрганизации.Вставить("ИНН");
	СтруктураОрганизации.Вставить("КодПоОКПО");
	СтруктураОрганизации.Вставить("Комментарий");
	СтруктураОрганизации.Вставить("КПП");
	СтруктураОрганизации.Вставить("ОсновнойБанковскийСчет");
	СтруктураОрганизации.Вставить("ПолноеНаименование");
	СтруктураОрганизации.Вставить("Префикс");
	СтруктураОрганизации.Вставить("ЮрФизЛицо");
	
	Возврат СтруктураОрганизации;
	
КонецФункции

// Создает и записывает в БД организацию
//
// Параметры:
//   СтруктураОрганизации - Структура - структура полей организации.
//
// Возвращаемое значение:
//   СправочникСсылка.Организации
//
Функция СоздатьОрганизацию(СтруктураОрганизации) Экспорт
	
	НоваяОрганизация = СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НоваяОрганизация, СтруктураОрганизации);
	НоваяОрганизация.Записать();
	
	Возврат НоваяОрганизация.Ссылка;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Префикс");
	Результат.Добавить("КонтактнаяИнформация.*");
	
	Возврат Результат
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Использование нескольких организаций

// Возвращает организацию по умолчанию.
// Если в ИБ есть только одна организация, которая не помечена на удаление и не является предопределенной,
// то будет возвращена ссылка на нее, иначе будет возвращена пустая ссылка.
//
// Возвращаемое значение:
//     СправочникСсылка.Организации - ссылка на организацию
//
Функция ОрганизацияПоУмолчанию() Экспорт
	
	Организация = Справочники.Организации.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|	И НЕ Организации.Предопределенный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Организация = Выборка.Организация;
	КонецЕсли;
	
	Возврат Организация;

КонецФункции

// Возвращает количество элементов справочника Организации.
// Не учитывает предопределенные и помеченные на удаление элементы.
//
// Возвращаемое значение:
//     Число - количество организаций
//
Функция КоличествоОрганизаций() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Количество = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(*) КАК Количество
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.Предопределенный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Количество = Выборка.Количество;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Количество;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается при переходе на версию БСП 2.2.1.12
//
Процедура ЗаполнитьКонстантуИспользоватьНесколькоОрганизаций() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") =
			ПолучитьФункциональнуюОпцию("НеИспользоватьНесколькоОрганизаций") Тогда
		// Опции должны иметь противоположные значения.
		// Если это не так, то значит в ИБ раньше не было этих опций - инициализируем их значения.
		Константы.ИспользоватьНесколькоОрганизаций.Установить(КоличествоОрганизаций() > 1);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.Организация = ОбъектДоступа.Ссылка;
	
КонецПроцедуры

// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ПолучитьЗначенияРеквизитов()
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции

#КонецОбласти

#КонецЕсли
