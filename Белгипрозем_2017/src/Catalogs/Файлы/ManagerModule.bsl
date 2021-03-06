#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей файла
//
// Возвращаемое значение:
//   Структура
//     Владелец
//     ПутьКФайлуНаДиске
//     ИмяФайла
//
Функция ПолучитьСтруктуруФайла() Экспорт
	
	СтруктураФайла = Новый Структура;
	СтруктураФайла.Вставить("Владелец");
	СтруктураФайла.Вставить("ПутьКФайлуНаДиске");
	СтруктураФайла.Вставить("ИмяФайла");
	
	Возврат СтруктураФайла;
	
КонецФункции

// Создает файл.
//
// Параметры:
//   СтруктураФайла - Структура - структура полей файла.
//
// Возвращаемый параметр:
//   СправочникСсылка.Файлы
//
Функция СоздатьФайл(СтруктураФайла) Экспорт
	
	НовыйФайл = РаботаСФайламиВнешнийВызов.СоздатьФайлНаОсновеФайлаНаДиске(
		СтруктураФайла.Владелец,
		СтруктураФайла.ПутьКФайлуНаДиске,
		СтруктураФайла.ИмяФайла,,
		Истина);
	
	Возврат НовыйФайл;
	
КонецФункции

// Проверяет, подходит ли объект к шаблону бизнес-процесса
Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат БизнесСобытияВызовСервера.ШаблонПодходитДляАвтозапускаБизнесПроцессаПоДокументу(ШаблонСсылка, 
		ПредметСсылка, Подписчик, ВидСобытия, Условие);
	
КонецФункции

// Возвращает имя предмета процесса по умолчанию
//
Функция ПолучитьИмяПредметаПоУмолчанию(Ссылка) Экспорт
	
	Возврат НСтр("ru='Файл'");
	
КонецФункции

#КонецОбласти

#КонецЕсли
