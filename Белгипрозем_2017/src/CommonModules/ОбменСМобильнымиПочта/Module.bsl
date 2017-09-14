
#Область ПрограммныйИнтерфейс

// Получает массив папок писем, для которых включена синхронизация с указанным мобильным клиентом
Функция ПолучитьСинхронизируемыеПапки(МобильныйКлиент) Экспорт

	Возврат РегистрыСведений.СинхронизацияПапокПисемСМобильнымКлиентом.ПолучитьПапкиДляСинхронизации(
		МобильныйКлиент.Пользователь, Истина);

КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

// Обработчик подписки ОбменСМобильнымКлиентомПередЗаписьюПапкиПисем.
Процедура ОбменСМобильнымКлиентомПередЗаписьюПапкиПисемПередЗаписью(Источник, Отказ) Экспорт

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьМобильныеКлиенты") Тогда
		Возврат;
	КонецЕсли;

	Источник.ДополнительныеСвойства.Вставить("Родитель", Источник.Ссылка.Родитель);

КонецПроцедуры

// Обработчик подписики ОбменСМобильнымКлиентомПриЗаписиПапкиПисем.
// Если синхронизируемая с мобильным клиентом папка писем переносится в несинхронизируюмую папку, 
//	то эта несинхронизируемая папка и все ее родители становятся синхронизируемыми.
Процедура ОбменСМобильнымКлиентомПриЗаписиПапкиПисемПриЗаписи(Источник, Отказ) Экспорт

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьМобильныеКлиенты") Тогда
		Возврат;
	КонецЕсли;

	Если Источник.ДополнительныеСвойства.Родитель = Источник.Родитель Тогда
		Возврат;
	КонецЕсли;

	ПапкиДляСинхронизации = 
		РегистрыСведений.СинхронизацияПапокПисемСМобильнымКлиентом.ПолучитьПапкиДляСинхронизации(
			ПользователиКлиентСервер.ТекущийПользователь());

	Если ПапкиДляСинхронизации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	МассивДобавленныхПапок = Новый Массив;
	БылиДобавленыПапки     = Ложь;

	Если ПапкиДляСинхронизации.Найти(Источник.Ссылка) <> Неопределено Тогда

		МассивРодителейПапки = ПолучитьВсехРодителейПапки(Источник.Ссылка);

		Для Каждого Папка Из МассивРодителейПапки Цикл
			Если ПапкиДляСинхронизации.Найти(Папка) = Неопределено Тогда
				ПапкиДляСинхронизации.Добавить(Папка);
				МассивДобавленныхПапок.Добавить(Папка);
				БылиДобавленыПапки = Истина;
			КонецЕсли;
		КонецЦикла;

		Если БылиДобавленыПапки Тогда
			РегистрыСведений.СинхронизацияПапокПисемСМобильнымКлиентом.ЗаписатьПапки(ПапкиДляСинхронизации);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

// Обработчик подписки ОбменСМобильнымПередЗаписьюПисьма
Процедура ОбменСМобильнымПередЗаписьюПисьмаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт

	Источник.ДополнительныеСвойства.Вставить("ЭтоНовый", Источник.ЭтоНовый());
	Источник.ДополнительныеСвойства.Вставить("ОбменСМобильнымПредыдущаяПапка", 
		ОбщегоНазначения.ПолучитьЗначениеРеквизита(Источник.Ссылка, "Папка"));

КонецПроцедуры

// Обработчик подписики ОбменСМобильнымПриЗаписиПисьма.
// Если письмо было перемещено, то в регистр ПапкиПисем делается запись 
//	для передачи факта перемещения на мобильные клиенты.
Процедура ОбменСМобильнымПриЗаписиПисьмаПриЗаписи(Источник, Отказ) Экспорт

	Если Источник.ДополнительныеСвойства.ОбменСМобильнымПредыдущаяПапка <> Источник.Папка Тогда

		НаборЗаписейРегистра = РегистрыСведений.ПисьмаВПапках.СоздатьНаборЗаписей();
		НаборЗаписейРегистра.Отбор.Письмо.Установить(Источник.Ссылка, Истина);

		НоваяЗапись = НаборЗаписейРегистра.Добавить();
		НоваяЗапись.Письмо = Источник.Ссылка;
		НоваяЗапись.Папка  = Источник.Папка;

		Если Источник.ДополнительныеСвойства.ЭтоНовый Тогда
			НаборЗаписейРегистра.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
			НаборЗаписейРегистра.ОбменДанными.Получатели.Очистить();
		КонецЕсли;

		НаборЗаписейРегистра.Записать();

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьВсехРодителейПапки(Знач Папка)

	МассивРодителей = Новый Массив;

	Пока ЗначениеЗаполнено(Папка.Родитель) Цикл
		МассивРодителей.Добавить(Папка.Родитель);
		Папка = Папка.Родитель;
	КонецЦикла;

	Возврат МассивРодителей;

КонецФункции

#КонецОбласти


