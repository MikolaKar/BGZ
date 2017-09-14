
Перем ПереданныеТипыСвязей;
Перем ПереданноеКоличествоУровней;

Процедура Сформировать(ТабличныйДокумент, Документ, ТипыСвязей = Неопределено, КоличествоУровней = 0) Экспорт 
	
	ПереданныеТипыСвязей = ТипыСвязей;
	ПереданноеКоличествоУровней = КоличествоУровней;
	
	ТабличныйДокумент.Очистить(); 
	Макет = ПолучитьМакет("СтруктураСвязей");
	ТабличныйДокумент.Вывести(Макет); 
	
	ДеревоСвязей = Новый ДеревоЗначений;
	ДеревоСвязей.Колонки.Добавить("Документ");
	ДеревоСвязей.Колонки.Добавить("ТипСвязи");
	ДеревоСвязей.Колонки.Добавить("Уровень");
	
	НоваяСтрока = ДеревоСвязей.Строки.Добавить();
	НоваяСтрока.Документ = Документ;
	НоваяСтрока.ТипСвязи = Справочники.ТипыСвязей.ПустаяСсылка();
	НоваяСтрока.Уровень  = 0;
	
	ЗаполнитьВеткуДереваСвязей(НоваяСтрока);
	
	// удаление задвоенных
	СтрокаДерева = ДеревоСвязей.Строки[0];
	
	// вывод
	СтрокаДерева = ДеревоСвязей.Строки[0];
	СтрокаНиз = 4;
	ВывестиДокументИЛинии(ТабличныйДокумент, СтрокаДерева, 2, 2, СтрокаНиз);
	
КонецПроцедуры

Процедура ЗаполнитьВеткуДереваСвязей(СтрокаДерева)
	
	Уровень = СтрокаДерева.Уровень + 1; 
	
	Если ЗначениеЗаполнено(ПереданноеКоличествоУровней)
	   И Уровень > ПереданноеКоличествоУровней Тогда 
		Возврат;
	КонецЕсли;		
	
	Если ТипЗнч(СтрокаДерева.Документ) = Тип("Строка") Тогда
		Возврат;
	КонецЕсли;	
	
	СвязанныеДокументы = ПолучитьСвязанныеДокументы(СтрокаДерева.Документ);
	Для Каждого СтрокаТаблицы Из СвязанныеДокументы Цикл
		
		Найден = Ложь;
		ТекущийРодитель = СтрокаДерева.Родитель;
		Пока ТекущийРодитель <> Неопределено Цикл  
			Если ТекущийРодитель.Документ = СтрокаТаблицы.Документ Тогда 
				Найден = Истина;
				Прервать;
			КонецЕсли;	
			ТекущийРодитель = ТекущийРодитель.Родитель;
		КонецЦикла;
		
		Если Найден Тогда 
			Продолжить;
		КонецЕсли;	
		
		НоваяСтрока = СтрокаДерева.Строки.Добавить();
		НоваяСтрока.ТипСвязи = СтрокаТаблицы.ТипСвязи;
		НоваяСтрока.Уровень  = Уровень;
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.Документ) Тогда 
			НоваяСтрока.Документ = СтрокаТаблицы.Документ;
		ИначеЕсли ЗначениеЗаполнено(СтрокаТаблицы.СвязаннаяСтрока) Тогда 
			НоваяСтрока.Документ = СтрокаТаблицы.СвязаннаяСтрока;
		КонецЕсли;	

		ЗаполнитьВеткуДереваСвязей(НоваяСтрока);
		
	КонецЦикла;
	
КонецПроцедуры	

Процедура ВывестиДокументИЛинии(ТабличныйДокумент, СтрокаДерева, Строка, Колонка, СтрокаНиз)
	
	// вывести документ
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2);
	Шрифт = Новый Шрифт(,8);
	
	Область = ТабличныйДокумент.Область(Строка, Колонка, Строка+1, Колонка+25);
	Область.Объединить();
	Область.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
	Область.Текст = Строка(СтрокаДерева.Документ);
	Область.Обвести(Линия, Линия, Линия, Линия);
	Область.Расшифровка = СтрокаДерева.Документ;
	
	Для Каждого ДочерняяСтрока Из СтрокаДерева.Строки Цикл
		
		Лево = СтрокаНиз + 1;
		Право = Колонка + 6;
		
		Область = ТабличныйДокумент.Область(Строка+2, Колонка+2, Лево+1, Колонка+2);
		Область.Обвести(Линия);
		
		Область = ТабличныйДокумент.Область(Лево+1, Колонка+2, Лево+1, Право-1);
		Область.Объединить();
		Область.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
		Область.ВертикальноеПоложение = ВертикальноеПоложение.Верх;
		Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
		Область.Шрифт = Шрифт;
		Область.Текст = Строка(ДочерняяСтрока.ТипСвязи);
		Область.Обвести(,Линия);
		
		СтрокаНиз = СтрокаНиз + 3;
		ВывестиДокументИЛинии(ТабличныйДокумент, ДочерняяСтрока, Лево, Право, СтрокаНиз);
		
	КонецЦикла;	
	
КонецПроцедуры

Функция ПолучитьСвязанныеДокументы(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СвязиДокументов.СвязанныйДокумент КАК Документ,
	|	СвязиДокументов.СвязаннаяСтрока,
	|	СвязиДокументов.ТипСвязи,
	|	СвязиДокументов.ДатаУстановки
	|ИЗ
	|	РегистрСведений.СвязиДокументов КАК СвязиДокументов
	|ГДЕ
	|	СвязиДокументов.Документ = &Документ";
	
	Если ПереданныеТипыСвязей <> Неопределено И ПереданныеТипыСвязей.Количество() > 0 Тогда 
		Запрос.Текст = Запрос.Текст + " И ТипСвязи В (&ТипыСвязей)";
		запрос.УстановитьПараметр("ТипыСвязей", ПереданныеТипыСвязей);
	КонецЕсли;	
	
	Запрос.Текст = Запрос.Текст + "
		|
		|УПОРЯДОЧИТЬ ПО
		|	СвязиДокументов.ТипСвязи";

	Запрос.УстановитьПараметр("Документ", Документ);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции