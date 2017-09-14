////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Подключает внешнюю обработку (отчет).
//   Подробнее - см. ДополнительныеОтчетыИОбработки.ПодключитьВнешнююОбработку().
//
Функция ПодключитьВнешнююОбработку(Ссылка) Экспорт
	
	Возврат ДополнительныеОтчетыИОбработки.ПодключитьВнешнююОбработку(Ссылка);
	
КонецФункции

// Создает и возвращает экземпляр внешней обработки (отчета).
//   Подробнее - см. ДополнительныеОтчетыИОбработки.ПолучитьОбъектВнешнейОбработки().
//
Функция ПолучитьОбъектВнешнейОбработки(Ссылка) Экспорт
	
	Возврат ДополнительныеОтчетыИОбработки.ПолучитьОбъектВнешнейОбработки(Ссылка);
	
КонецФункции

// Функция возвращает вид публикации, который должен использоваться для
//   конфликтующих дополнительных отчетов и обработок.
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ВариантыПубликацииДополнительныхОтчетовИОбработок
//
Функция ВидПубликацииДляКонфликтующихОбработок() Экспорт
	
	Возврат ДополнительныеОтчетыИОбработкиПовтИсп.ВидПубликацииДляКонфликтующихОбработок();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет команду обработки и помещает результат во временное хранилище.
//   Подробнее - см. ДополнительныеОтчетыИОбработки.ВыполнитьКоманду().
//
Функция ВыполнитьКоманду(ПараметрыКоманды, АдресРезультата = Неопределено) Экспорт
	
	Возврат ДополнительныеОтчетыИОбработки.ВыполнитьКоманду(ПараметрыКоманды, АдресРезультата);
	
КонецФункции

// Помещает двоичные данные дополнительного отчета или обработки во временное хранилище.
Функция ПоместитьВХранилище(Ссылка, ИдентификаторФормы) Экспорт
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") 
		Или Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка() Тогда
		Возврат Неопределено;
	КонецЕсли;
	Если НЕ ДополнительныеОтчетыИОбработки.ВозможнаВыгрузкаОбработкиВФайл(Ссылка) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для выгрузки файлов дополнительных отчетов и обработок'");
	КонецЕсли;
	
	ХранилищеОбработки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ХранилищеОбработки");
	
	Возврат ПоместитьВоВременноеХранилище(ХранилищеОбработки.Получить(), ИдентификаторФормы);
КонецФункции

#КонецОбласти
