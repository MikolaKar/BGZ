#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей шаблона процесса
//
// Возвращаемое значение:
//   Структура
//     Наименование
//     Родитель
//     Ответственный
//     Комментарий
//     ДобавлятьНаименованиеПредмета
//     НаименованиеБизнесПроцесса
//     Описание
//     Важность
//     Автор
//     Предметы
//     РабочаяГруппа
//     НастрокиШаблона
//     СрокИсполнения
//     СрокИсполненияЧас
//     Исполнители
//     ВариантИсполнения
//     Проверяющий
//     ОсновнойОбъектАдресацииПроверяющего
//     ДополнительныйОбъектАдресацииПроверяющего
//     Контролер
//     ОсновнойОбъектАдресацииКонтролера
//     ДополнительныйОбъектАдресацииКонтролера
//     НастрокиШаблона
//
Функция ПолучитьСтруктуруШаблонаИсполнения() Экспорт
	
	ПараметрыПроцесса = Новый Структура;
	ПараметрыПроцесса.Вставить("Наименование");
	ПараметрыПроцесса.Вставить("Родитель");
	ПараметрыПроцесса.Вставить("Ответственный");
	ПараметрыПроцесса.Вставить("Комментарий");
	ПараметрыПроцесса.Вставить("ДобавлятьНаименованиеПредмета");
	ПараметрыПроцесса.Вставить("НаименованиеБизнесПроцесса");
	ПараметрыПроцесса.Вставить("Описание");
	ПараметрыПроцесса.Вставить("Важность");
	ПараметрыПроцесса.Вставить("Автор");
	ПараметрыПроцесса.Вставить("ШаблонВКомплексномПроцессе");
	ПараметрыПроцесса.Вставить("ВладелецШаблона");
	
	Предметы = Новый ТаблицаЗначений;
	Предметы.Колонки.Добавить("РольПредмета");
	Предметы.Колонки.Добавить("ИмяПредмета");
	Предметы.Колонки.Добавить("ТочкаМаршрута");
	Предметы.Колонки.Добавить("ИмяПредметаОснование");
	Предметы.Колонки.Добавить("ШаблонОснование");
	ПараметрыПроцесса.Вставить("Предметы", Предметы);
	
	РабочаяГруппаШаблона = Новый ТаблицаЗначений;
	РабочаяГруппаШаблона.Колонки.Добавить("Участник");
	РабочаяГруппаШаблона.Колонки.Добавить("ОсновнойОбъектАдресации");
	РабочаяГруппаШаблона.Колонки.Добавить("ДополнительныйОбъектАдресации");
	ПараметрыПроцесса.Вставить("РабочаяГруппа", РабочаяГруппаШаблона);
	
	НастрокиШаблона = Новый ТаблицаЗначений;
	НастрокиШаблона.Колонки.Добавить("ВидДокумента");
	Если Константы.ИспользоватьУчетПоОрганизациям.Получить() Тогда
		НастрокиШаблона.Колонки.Добавить("Организация");
	КонецЕсли;
	НастрокиШаблона.Колонки.Добавить("Условие");
	НастрокиШаблона.Колонки.Добавить("ЗапрещеноИзменение");
	НастрокиШаблона.Колонки.Добавить("ИнтерактивныйЗапуск");
	НастрокиШаблона.Колонки.Добавить("ВидИнтерактивногоСобытия");
	ПараметрыПроцесса.Вставить("НастрокиШаблона", НастрокиШаблона);
	
	ПараметрыПроцесса.Вставить("СрокИсполнения");
	ПараметрыПроцесса.Вставить("СрокИсполненияЧас");
	
	ТаблицаИсполнителей = Новый ТаблицаЗначений;
	ТаблицаИсполнителей.Колонки.Добавить("Ответственный");
	ТаблицаИсполнителей.Колонки.Добавить("Исполнитель");
	ТаблицаИсполнителей.Колонки.Добавить("ОсновнойОбъектАдресации");
	ТаблицаИсполнителей.Колонки.Добавить("ДополнительныйОбъектАдресации");
	ТаблицаИсполнителей.Колонки.Добавить("ПорядокИсполнения");
	ТаблицаИсполнителей.Колонки.Добавить("СрокИсполнения");
	ТаблицаИсполнителей.Колонки.Добавить("СрокИсполненияЧас");
	ТаблицаИсполнителей.Колонки.Добавить("Описание");
	ТаблицаИсполнителей.Колонки.Добавить("НаименованиеЗадачи");
	ТаблицаИсполнителей.Колонки.Добавить("ТрудозатратыПланИсполнителя");
	ПараметрыПроцесса.Вставить("Исполнители", ТаблицаИсполнителей);
	
	ПараметрыПроцесса.Вставить("ВариантИсполнения");
	
	ПараметрыПроцесса.Вставить("Проверяющий");
	ПараметрыПроцесса.Вставить("ОсновнойОбъектАдресацииПроверяющего");
	ПараметрыПроцесса.Вставить("ДополнительныйОбъектАдресацииПроверяющего");
	ПараметрыПроцесса.Вставить("ТрудозатратыПланПроверяющего");
	
	ПараметрыПроцесса.Вставить("Контролер");
	ПараметрыПроцесса.Вставить("ОсновнойОбъектАдресацииКонтролера");
	ПараметрыПроцесса.Вставить("ДополнительныйОбъектАдресацииКонтролера");
	ПараметрыПроцесса.Вставить("ТрудозатратыПланКонтролера");
	
	Возврат ПараметрыПроцесса;
	
КонецФункции

// Создает шаблон процесса.
//
// Параметры:
//   СтруктураШаблона - Структура - структура полей шаблона исполнение.
//
// Возвращаемый параметр:
//   СправочникСсылка.ШаблоныИсполнения
//
Функция СоздатьШаблонИсполнения(СтруктураШаблона) Экспорт
	
	НовыйШаблон = СоздатьЭлемент();
	ШаблоныБизнесПроцессов.ЗаполнитьШаблон(НовыйШаблон, СтруктураШаблона);
	
	// Заполнение таблицы Исполнителей
	
	Для Каждого СтрокаИсполнителя Из СтруктураШаблона.Исполнители Цикл
		
		НоваяСтрокаИсполнителя = НовыйШаблон.Исполнители.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаИсполнителя, СтрокаИсполнителя);
		
	КонецЦикла;
	
	НовыйШаблон.Записать();
	
	НастрокиШаблона = 
	СтруктураШаблона.НастрокиШаблона.Скопировать();
	НастрокиШаблона.Колонки.Добавить("ШаблонБизнесПроцесса");
	НастрокиШаблона.ЗаполнитьЗначения(НовыйШаблон.Ссылка, "ШаблонБизнесПроцесса");
	
	НаборЗаписей = РегистрыСведений.НастройкаШаблоновБизнесПроцессов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ШаблонБизнесПроцесса.Установить(НовыйШаблон.Ссылка);
	НаборЗаписей.Загрузить(НастрокиШаблона);
	НаборЗаписей.Записать();
	
	Возврат НовыйШаблон.Ссылка;
	
КонецФункции

Функция ИмяПроцесса(ШаблонСсылка) Экспорт
	
	Возврат "Исполнение";
	
КонецФункции

// Показывает, может ли процесс по данному шаблону использоваться в качестве части комплексного процесса
Функция МожетИспользоватьсяВКомплексномПроцессе() Экспорт
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат 
		"Ответственный,
		|Ссылка,
		|ШаблонВКомплексномПроцессе,
		|ВладелецШаблона";
	
КонецФункции

Процедура ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ШаблоныБизнесПроцессов.ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа);	
	
КонецПроцедуры	

// Возвращает Истина, указывая тем самым что этот объект сам заполняет свои права 
Функция ЕстьМетодЗаполнитьПраваДоступа() Экспорт
	
	Возврат Истина;
	
КонецФункции	

// Заполняет параметр ПраваДоступа правами доступа, вычисляя их на 
// основании переданного дескриптора доступа.
// Если указан параметр ПротоколРасчетаПрав, то в него 
// заносится список данных, которые были использованы для расчета прав.
Процедура ЗаполнитьПраваДоступа(ДескрипторДоступа, ПраваДоступа, ПротоколРасчетаПрав) Экспорт
	
	ШаблоныБизнесПроцессов.ЗаполнитьПраваДоступа(ДескрипторДоступа, ПраваДоступа, ПротоколРасчетаПрав);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли


