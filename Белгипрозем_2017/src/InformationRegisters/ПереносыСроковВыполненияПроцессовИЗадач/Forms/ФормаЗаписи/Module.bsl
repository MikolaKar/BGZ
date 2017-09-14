
&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач") Тогда
		Элементы.СтарыйСрок.Формат = "ДФ='dd.MM.yyyy'";
		Элементы.НовыйСрок.Формат = "ДФ='dd.MM.yyyy'";
	КонецЕсли;
	
	Если ТипЗнч(Запись.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		Элементы.Предмет.Заголовок = НСтр("ru = 'Перенос срока исполнения задачи'");
	Иначе
		Элементы.Предмет.Заголовок = НСтр("ru = 'Перенос срока исполнения процесса'");
	КонецЕсли;
	
	Если ТипЗнч(Запись.СтарыйСрок) = Тип("Число") Тогда
		Если ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы") Тогда
			Элементы.ДекорацияНовыйСрокПодпись.Заголовок =	
				ДелопроизводствоКлиентСервер.ПолучитьПодписьРабочихДней(Запись.НовыйСрок);
			Элементы.ДекорацияСтарыйСрокПодпись.Заголовок =	
				ДелопроизводствоКлиентСервер.ПолучитьПодписьРабочихДней(Запись.СтарыйСрок);	
		Иначе
			Элементы.ДекорацияНовыйСрокПодпись.Заголовок =	
				ДелопроизводствоКлиентСервер.ПолучитьПодписьДней(Запись.НовыйСрок);
			Элементы.ДекорацияСтарыйСрокПодпись.Заголовок =	
				ДелопроизводствоКлиентСервер.ПолучитьПодписьДней(Запись.СтарыйСрок);	
		КонецЕсли;
		Элементы.НовыйСрок.Ширина = 3;
		Элементы.СтарыйСрок.Ширина = 3;
	Иначе
		Элементы.ДекорацияНовыйСрокПодпись.Заголовок = 
			ПереносСроковВыполненияЗадач.ПолучитьПодписьДлительностьПереноса(
				Неопределено, 
				Запись.СтарыйСрок,
				Запись.НовыйСрок);
		Элементы.ДекорацияСтарыйСрокПодпись.Видимость = Ложь;
		Элементы.НовыйСрок.Ширина = 11;
		Элементы.СтарыйСрок.Ширина = 11;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(Запись.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Запись.Предмет);
	Иначе
		ПоказатьЗначение(, Запись.Предмет);
	КонецЕсли;
	
КонецПроцедуры
