#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей ВидаВходящихДокументов
//
// Возвращаемое значение:
//   Структура
//
Функция ПолучитьСтруктуруВидаВходящихДокументов() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Наименование");
	Параметры.Вставить("Нумератор");
	Параметры.Вставить("СпособНумерации");
	Параметры.Вставить("АвтоматическиВестиСоставУчастниковРабочейГруппы");
	Параметры.Вставить("ВестиУчетПоНоменклатуреДел");
	Параметры.Вставить("ИспользоватьСрокИсполнения");
	Параметры.Вставить("ОбязателенФайлОригинала");
	Параметры.Вставить("ОбязательноеЗаполнениеРабочихГруппДокументов");
	Параметры.Вставить("УчитыватьКакОбращениеГраждан");
	Параметры.Вставить("УчитыватьСуммуДокумента");
	Параметры.Вставить("ЯвляетсяОбращениемОтГраждан");
	Параметры.Вставить("ПодписыватьРезолюцииЭП");
	
	Возврат Параметры;
	
КонецФункции

// Создает и записывает в БД вид входящего документа
//
// Параметры:
//   СтруктураВидаВходящегоДокумента - Структура - структура полей видов входящих документов.
//
Функция СоздатьВидВходящегоДокумента(СтруктураВидаВходящегоДокумента) Экспорт
	
	НовыйВидВходящегоДокумента = СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовыйВидВходящегоДокумента, СтруктураВидаВходящегоДокумента);
	НовыйВидВходящегоДокумента.Записать();
	
	Возврат НовыйВидВходящегоДокумента.Ссылка;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ВидОбъекта = ОбъектДоступа.Ссылка;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
