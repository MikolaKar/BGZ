
// Формирует дерево значений с реквизитами и допреквизитами документа указанного типа.
//
// Параметры:
//  ВидВладельцаФайла - СправочникСсылка.ВидыВнутреннихДокументов, СправочникСсылка.ВидыИсходящихДокументов - 
//						Текстовое описание параметра процедуры (функции).
//  ТипДокумента - Строка - Строковое представление типа документа
//
// Возвращаемое значение:
//  ДеревоЗначений - дерево значений с реквизитами документа
//	 * Наименование - Строка - Имя реквизита.
//	 * Тип - Строка - Имя типа реквизита.
//	 * ОбъектРодитель - Строка - полный путь до элемента дерева реквизитов
Функция ЗаполнитьДеревоРеквизитовДляВыбора(ВидВладельцаФайла, ТипДокумента) Экспорт
	
	Типы = Новый ОписаниеТипов("Строка");
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("Наименование", Типы);
	Дерево.Колонки.Добавить("Тип", Типы);
	Дерево.Колонки.Добавить("ОбъектРодитель", Типы);
	
	НоваяСтрокаФайл = Дерево.Строки.Добавить();
	НоваяСтрокаФайл.Наименование = НСтр("ru = 'Файл'");
	НоваяСтрокаФайл.Тип = НСтр("ru = 'Справочник'");
	
	ЗаполнитьДеревоРеквизитов(НоваяСтрокаФайл, Метаданные.Справочники.Файлы.СтандартныеРеквизиты, "Файл", 1, ВидВладельцаФайла);
	ЗаполнитьДеревоРеквизитов(НоваяСтрокаФайл, Метаданные.Справочники.Файлы.Реквизиты, "Файл", 1, ВидВладельцаФайла);
	
	НоваяСтрокаВидВладельцаФайла = Дерево.Строки.Добавить();
	НоваяСтрокаВидВладельцаФайла.Наименование = "ВладелецФайла";
	НоваяСтрокаВидВладельцаФайла.Тип = ТипДокумента;
	
	Для Каждого СправочникОбъект Из Метаданные.Справочники Цикл
		Если СправочникОбъект.ПредставлениеОбъекта = ТипДокумента  Тогда
        	ЗаполнитьДеревоРеквизитов(НоваяСтрокаВидВладельцаФайла, СправочникОбъект.СтандартныеРеквизиты, "ВладелецФайла", 1, ВидВладельцаФайла);
			ЗаполнитьДеревоРеквизитов(НоваяСтрокаВидВладельцаФайла, СправочникОбъект.Реквизиты, "ВладелецФайла", 1, ВидВладельцаФайла);
			Прервать;
		КонецЕсли
	КонецЦикла;
	
	Попытка
		НаборСвойств = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(ВидВладельцаФайла);
		НоваяСтрокаДопРеквизиты = НоваяСтрокаВидВладельцаФайла.Строки.Добавить();
		НоваяСтрокаДопРеквизиты.Наименование = НСтр("ru = 'ДопРеквизиты'");
		НоваяСтрокаДопРеквизиты.Тип = "";
		
		Для Каждого ЭлементНабораСвойств Из НаборСвойств Цикл
			Для Каждого ДопРеквизит Из ЭлементНабораСвойств.Набор.ДополнительныеРеквизиты Цикл
				Если ДопРеквизит <> Неопределено И ЗначениеЗаполнено(ДопРеквизит.Свойство) Тогда
					НоваяСтрокаДопРеквизит = НоваяСтрокаДопРеквизиты.Строки.Добавить();
					НоваяСтрокаДопРеквизит.Наименование = ДопРеквизит.Свойство.Наименование;
					НоваяСтрокаДопРеквизит.Тип = ДопРеквизит.Свойство.ТипЗначения;
					НоваяСтрокаДопРеквизит.ОбъектРодитель = "ВладелецФайла.ДопРеквизиты";
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	Исключение
		// у владельца файла может не быть доп.реквизитов
	КонецПопытки;

	Возврат Дерево;
	
КонецФункции

Процедура ЗаполнитьДеревоРеквизитов(Родитель, НаборРеквизитов, Путь, УровеньВложенности, ВидВладельцаФайла)
	
	Если УровеньВложенности > 2 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Реквизит Из НаборРеквизитов Цикл
		
		Если ТипЗнч(Реквизит) <> Тип("ОписаниеСтандартногоРеквизита") Тогда
			РеквизитВключен = Истина;
			РеквизитВходитВФункциональныеОпции = Ложь;
			Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
				Если ФункциональнаяОпция.Состав.Содержит(Реквизит) Тогда
					РеквизитВходитВФункциональныеОпции = Истина;
					РеквизитВключен = ПолучитьФункциональнуюОпцию(ФункциональнаяОпция.Имя);
					Если РеквизитВключен Тогда
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Если РеквизитВходитВФункциональныеОпции И НЕ РеквизитВключен Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Строка = Родитель.Строки.Добавить();
		Строка.Наименование = Реквизит.Имя;
		Строка.Тип = Реквизит.Тип;
		Строка.ОбъектРодитель = Путь;
		Для Каждого СправочникОбъект Из Метаданные.Справочники Цикл
			Если СправочникОбъект.ПредставлениеОбъекта = Строка(Реквизит.Тип) Тогда
				ЗаполнитьДеревоРеквизитов(Строка, СправочникОбъект.СтандартныеРеквизиты, Путь + "|" + Строка.Наименование, УровеньВложенности + 1, ВидВладельцаФайла);
				ЗаполнитьДеревоРеквизитов(Строка, СправочникОбъект.Реквизиты, Путь + "|" + Строка.Наименование, УровеньВложенности + 1, ВидВладельцаФайла);
				Попытка
					Если СправочникОбъект.ТабличныеЧасти.Найти("ДополнительныеРеквизиты") <> Неопределено Тогда
						ЗаполнитьСписокДопРеквизитов(Строка, СправочникОбъект, Путь + "|" + Реквизит.Имя, ВидВладельцаФайла);		
					КонецЕсли;
				Исключение
					// у справочника может не быть ни одного настроенного доп.реквизита
				КонецПопытки;
				Если СправочникОбъект.ТабличныеЧасти.Найти("КонтактнаяИнформация") <> Неопределено Тогда
					ЗаполнитьСписокКонтактнойИнформации(Строка, СправочникОбъект, Путь + "|" + Реквизит.Имя);
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСписокДопРеквизитов(Строка, СправочникОбъект, Путь, ВидВладельцаФайла)
	
	УстановитьПривилегированныйРежим(Истина);
	Объект = Справочники[СправочникОбъект.Имя].СоздатьЭлемент();
	Если ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект) Тогда
		Объект.ВидДокумента = ВидВладельцаФайла;
	КонецЕсли;
	НаборСвойств = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(Объект);
	КоличествоНаборов = НаборСвойств.Количество();
	
	Если КоличествоНаборов > 0 Тогда
		НоваяСтрокаДопРеквизиты = Строка.Строки.Добавить();
		НоваяСтрокаДопРеквизиты.Наименование = НСтр("ru = 'ДопРеквизиты'");
		НоваяСтрокаДопРеквизиты.Тип = "";
		Для Каждого ВложенныйНаборСвойств Из НаборСвойств Цикл
			НоваяСтрокаВложенныеДопРеквизиты = НоваяСтрокаДопРеквизиты.Строки.Добавить();
			НоваяСтрокаВложенныеДопРеквизиты.Наименование = ВложенныйНаборСвойств.Набор.Наименование;
			НоваяСтрокаВложенныеДопРеквизиты.Тип = "";
			Для Каждого ДопРеквизит Из ВложенныйНаборСвойств.Набор.ДополнительныеРеквизиты Цикл
				НоваяСтрокаДопРеквизит = НоваяСтрокаВложенныеДопРеквизиты.Строки.Добавить();
				НоваяСтрокаДопРеквизит.Наименование = ДопРеквизит.Свойство.Наименование;
				НоваяСтрокаДопРеквизит.Тип = ДопРеквизит.Свойство.ТипЗначения;
				
				Если КоличествоНаборов = 1 Тогда 
					НаборНаименование = "";
				Иначе 
					НаборНаименование = ВложенныйНаборСвойств.Набор.Наименование;
				КонецЕсли;
				
				НоваяСтрокаДопРеквизит.ОбъектРодитель = Путь + "|" + НоваяСтрокаДопРеквизиты.Наименование 
					+ ?(ЗначениеЗаполнено(НаборНаименование), "|" + НаборНаименование, "");
				НоваяСтрокаДопРеквизит.ОбъектРодитель = СтрЗаменить(НоваяСтрокаДопРеквизит.ОбъектРодитель, 
					НСтр("ru = 'Доп. свойства'"), НСтр("ru = 'ДопСвойства'"));
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьСписокКонтактнойИнформации(Строка, СправочникОбъект, Путь)
	
	//Получение набора контактной информации для данного справочника
	// Получим список видов КИ
	ИмяСправочника = СправочникОбъект.Имя;
	ГруппаВидовКИ = Справочники.ВидыКонтактнойИнформации["Справочник" + ИмяСправочника];
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыКонтактнойИнформации.Ссылка КАК Вид,
	|	ВидыКонтактнойИнформации.Наименование,
	|	ВидыКонтактнойИнформации.Тип,
	|	ВидыКонтактнойИнформации.РедактированиеТолькоВДиалоге,
	|	ВидыКонтактнойИнформации.АдресТолькоРоссийский,
	|	ВидыКонтактнойИнформации.ПометкаУдаления КАК ПометкаУдаления,
	|	ИСТИНА КАК Использовать
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.Родитель = &ГруппаВидовКИ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПометкаУдаления,
	|	ВидыКонтактнойИнформации.РеквизитДопУпорядочивания";
	
	Запрос.УстановитьПараметр("ГруппаВидовКИ", ГруппаВидовКИ);
	УстановитьПривилегированныйРежим(Истина);
	КонтактнаяИнформация = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	Если КонтактнаяИнформация.Количество() > 0 Тогда
		НоваяСтрокаКонтактнаяИнформация = Строка.Строки.Добавить();
		НоваяСтрокаКонтактнаяИнформация.Наименование = НСтр("ru = 'Контактная информация'");
		НоваяСтрокаКонтактнаяИнформация.Тип = "";

		Для Каждого Запись Из КонтактнаяИнформация Цикл
			НоваяСтрока = НоваяСтрокаКонтактнаяИнформация.Строки.Добавить();
			НоваяСтрока.Наименование = Запись.Наименование;
			НоваяСтрока.Тип = Запись.Тип;
			НоваяСтрока.ОбъектРодитель = Путь 
				+ "|" 
				+ СтрЗаменить(
					НоваяСтрокаКонтактнаяИнформация.Наименование, 
					НСтр("ru = 'Контактная информация'"), 
					НСтр("ru = 'КонтактнаяИнформация'"));
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры