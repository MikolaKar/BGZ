// Возвращает содержание переданного объекта
// Параметры
// Объект - объект, представление которого надо сформировать
// Возвращает содержание в виде HTML или MXL документа
Функция ПолучитьСодержание(Объект) Экспорт
	
	Если Объект = Неопределено Или Объект.Пустая() Тогда
		Возврат "";
	КонецЕсли;
	
	Строка = "";
	ВнешниеЗадачиВызовСервераПереопределяемый.ПолучитьСодержание(Объект, Строка);
	
	Возврат Строка;
	
КонецФункции

// Возвращает массив объектов типа ОписаниеПередаваемогоФайла
// или Неопределено
Функция ПолучитьСписокФайлов(Источник) Экспорт
	
	МассивФайлов = Новый Массив;
	ВнешниеЗадачиВызовСервераПереопределяемый.ПолучитьСписокФайлов(Источник, МассивФайлов);
	Возврат МассивФайлов;
	
КонецФункции

// Возвращает Истина, если задача является внешней 
Функция ЭтоВнешняяЗадача(ЗадачаСсылка) Экспорт
	
	ВнешняяЗадача = ВнешниеЗадачиВызовСервераПереопределяемый.ЭтоВнешняяЗадача(ЗадачаСсылка);
	Если ВнешняяЗадача <> Неопределено Тогда
		Возврат ВнешняяЗадача;
	КонецЕсли;	
		
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьВнешниеЗадачи") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Проверяем роль исполнителя
	Роль = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ЗадачаСсылка, "РольИсполнителя");
	
	Если Роль <> Неопределено И Роль.ВнешняяРоль = Истина Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Возврат Ложь;
	
КонецФункции

// Создает и стартует внешний бизнес-процесс Задание 
// при записи задачи другого бизнес-процесса, если эта задача 
// является внешней
Процедура СтартВнешнегоЗаданияПриЗаписиЗадач(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли; 
	
	Если Источник.ДополнительныеСвойства.Свойство("ЗаписьНовойЗадачи") Тогда
		ВнешняяРоль = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Источник.РольИсполнителя, "ВнешняяРоль");
		Если Не Источник.РольИсполнителя.Пустая() И ВнешняяРоль = Истина Тогда
			// Создаем и стартуем внешний бизнес-процесс
			СтартоватьВнешнийБизнесПроцесс(Источник);
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

Процедура СтартоватьВнешнийБизнесПроцесс(Задача)
	
	Если ВнешниеЗадачиВызовСервераПереопределяемый.СтартоватьВнешнийБизнесПроцесс(Задача) Тогда
		Возврат;
	КонецЕсли;	
	
	// Создаем бизнес-процесс задание
	Задание = БизнесПроцессы.Задание.СоздатьБизнесПроцесс();
	Задание.Дата = ТекущаяДатаСеанса();
	Задание.Автор = Задача.Автор;
	Задание.Важность = Задача.Важность;
	Задание.Исполнитель = Задача.РольИсполнителя;
	Задание.Наименование = Задача.Наименование;
	
	Для каждого Строка Из Задача.Предметы Цикл
		СтрокаПредмета = Задание.Предметы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПредмета, Строка);
	КонецЦикла;
	
	Задание.СрокИсполнения = Задача.СрокИсполнения;
	Задание.ЗадачаИсточник = Задача.Ссылка;
	
	Задание.Записать();
	Задание.Старт();
	
КонецПроцедуры

// Помечает задачу-источник как выполненную
Процедура ВыполнитьЗадачуИсточник(БизнесПроцесс) Экспорт
	
	Если ВнешниеЗадачиВызовСервераПереопределяемый.ВыполнитьЗадачуИсточник(БизнесПроцесс) Тогда
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(БизнесПроцесс) = Тип("БизнесПроцессОбъект.Задание") Тогда
		Задача = БизнесПроцесс.ЗадачаИсточник.ПолучитьОбъект();
		Задача.РезультатВыполнения = БизнесПроцесс.РезультатВыполнения;
		Задача.ВыполнитьЗадачу();
	КонецЕсли;	
	
КонецПроцедуры

// Сохраняет сведения о записи новой задачи для последующей обработки
// в обработчике перед записью
Процедура СтартВнешнегоЗаданияПередЗаписьюЗадач(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
        Возврат;  
	КонецЕсли; 
	
	Если Источник.ЭтоНовый() Тогда
		Источник.ДополнительныеСвойства.Вставить("ЗаписьНовойЗадачи");
	КонецЕсли;	
		
КонецПроцедуры
