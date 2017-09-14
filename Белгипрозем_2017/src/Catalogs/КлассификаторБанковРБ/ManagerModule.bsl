#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("*");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
//
// Возвращаемое значение: Массив(Строка) - массив имен реквизитов, образующих
//  естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив();
	
	Результат.Добавить("Код");
	
	Возврат Результат;
	
КонецФункции

//Мисофт
// Функция формирует результат запроса по классификатору банков
// с отбором по БИК, корреспондентскому счету, наименованию или городу.
//
// Параметры:
//	БИК - Строка (9) - БИК банка
//	КорСчет - Строка (20) - Корреспондентский счет банка
//	Наименование - Строка - Наименование банка
//	Город - Строка - Город банка
//
// Возвращаемое значение:
//	РезультатЗапроса - Результат запроса по классификатору.
//
Функция ПолучитьРезультатЗапросаПоКлассификатору(
	БИК,
	КоррСчет,
	Наименование,
	Город
	) Экспорт
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	Макет = Справочники.КлассификаторБанковРБ.ПолучитьМакет("КлассификаторБанковРБ");
	//МиСофт+
	КлассификаторТаблица = Новый ТаблицаЗначений;
	КлассификаторТаблица.Колонки.Добавить("БИК");
	КлассификаторТаблица.Колонки.Добавить("Наименование");
	КлассификаторТаблица.Колонки.Добавить("Адрес");
	КлассификаторТаблица.Колонки.Добавить("Телефоны");
	
	ОбластьБанки = Макет.ПолучитьОбласть("Банки");
	КоличествоСтрок = ОбластьБанки.ВысотаТаблицы;
	
	Для НомерСтроки = 1 По КоличествоСтрок Цикл
		НоваяСтрока = КлассификаторТаблица.Добавить();
		НоваяСтрока.БИК          = СокрЛП(ОбластьБанки.Область(НомерСтроки, 1).Текст);
		НоваяСтрока.Наименование = СокрЛП(ОбластьБанки.Область(НомерСтроки, 2).Текст);
		НоваяСтрока.Адрес        = СокрЛП(ОбластьБанки.Область(НомерСтроки, 3).Текст);
		НоваяСтрока.Телефоны     = СокрЛП(ОбластьБанки.Область(НомерСтроки, 4).Текст);
	КонецЦикла;
	//МиСофт-
	
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(КлассификаторТаблица);
	
	Отбор = ПостроительЗапроса.Отбор;
	
	Если ЗначениеЗаполнено(БИК) Тогда
		Отбор.Добавить("БИК");
		Отбор.БИК.Значение = СокрЛП(БИК);
		Отбор.БИК.ВидСравнения = ВидСравнения.Содержит;
		Отбор.БИК.Использование = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Наименование) Тогда
		Отбор.Добавить("Наименование");
		Отбор.Наименование.Значение = СокрЛП(Наименование);
		Отбор.Наименование.ВидСравнения = ВидСравнения.Содержит;
		Отбор.Наименование.Использование = ЗначениеЗаполнено(Наименование);
	КонецЕсли;
	
	ПостроительЗапроса.Выполнить();
    РезультатЗапроса = ПостроительЗапроса.Результат;

	Возврат РезультатЗапроса;

КонецФункции // ПолучитьРезультатЗапросаПоКлассификатору()

#КонецОбласти
 
#КонецЕсли
