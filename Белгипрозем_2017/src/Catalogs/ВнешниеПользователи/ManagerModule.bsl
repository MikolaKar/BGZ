#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("ОбъектАвторизации");
	НеРедактируемыеРеквизиты.Добавить("УстановитьРолиНепосредственно");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяИБ");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяСервиса");
	НеРедактируемыеРеквизиты.Добавить("СвойстваПользователяИБ");
	НеРедактируемыеРеквизиты.Добавить("УдалитьПароль");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" И Параметры.Свойство("ОбъектАвторизации") Тогда
		
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаЭлемента";
		
		НайденныйВнешнийПользователь = Неопределено;
		ЕстьПравоДобавленияВнешнегоПользователя = Ложь;
		
		ОбъектАвторизацииИспользуется = ПользователиСлужебныйВызовСервера.ОбъектАвторизацииИспользуется(
			Параметры.ОбъектАвторизации,
			,
			НайденныйВнешнийПользователь,
			ЕстьПравоДобавленияВнешнегоПользователя);
		
		Если ОбъектАвторизацииИспользуется Тогда
			Параметры.Вставить("Ключ", НайденныйВнешнийПользователь);
			
		ИначеЕсли ЕстьПравоДобавленияВнешнегоПользователя Тогда
			
			Параметры.Вставить(
				"ОбъектАвторизацииНовогоВнешнегоПользователя", Параметры.ОбъектАвторизации);
		Иначе
			ОписаниеОшибкиКакПредупреждения =
				НСтр("ru = 'Разрешение на вход в программу не предоставлялось.'");
				
			ВызватьИсключение ОписаниеОшибкиКакПредупреждения;
		КонецЕсли;
		
		Параметры.Удалить("ОбъектАвторизации");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
