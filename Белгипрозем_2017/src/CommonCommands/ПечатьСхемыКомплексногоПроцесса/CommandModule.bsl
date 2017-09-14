
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
		
	ТабличныйДокументСхема = Новый ТабличныйДокумент;
	Сформировать(ТабличныйДокументСхема, ПараметрКоманды);
	ТабличныйДокументСхема.ТолькоПросмотр = Истина;
	ТабличныйДокументСхема.АвтоМасштаб = Истина;
	ТабличныйДокументСхема.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокументСхема.ОтображатьЗаголовки = Ложь;
	ТабличныйДокументСхема.ОтображатьСетку = Ложь;
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	    НСтр("ru = 'Схема процесса ""%1""'"),
		ОбщегоНазначения.ПолучитьЗначениеРеквизита(ПараметрКоманды, "Наименование"));
	ТабличныйДокументСхема.Показать(Заголовок);
	
КонецПроцедуры

&НаСервере
Процедура Сформировать(ТабличныйДокумент, БизнесПроцесс) 
		
	ТабличныйДокумент.Очистить(); 
	Макет = ПолучитьОбщийМакет("СхемаКомплексногоПроцесса");
	ТабличныйДокумент.Вывести(Макет); 
	ГСЧ = Новый ГенераторСлучайныхЧисел(255);
	//Вывод переходов
	Для Каждого Этап Из БизнесПроцесс.Этапы Цикл
		ОдинЦвет = Истина;
		Цвет = Новый Цвет(255,255,255);
		Если Этап.ПредшественникиВариантИспользования = "ОдинИзПредшественников" Тогда
			ОдинЦвет = Ложь; 
		КонецЕсли;	
		Для каждого ЗаписьОПереходе Из БизнесПроцесс.ПредшественникиЭтапов Цикл
			Если ЗаписьОПереходе.ИдентификаторПоследователя = Этап.ИдентификаторЭтапа Тогда
				Если НЕ ОдинЦвет Тогда
					Цвет = Новый Цвет(200, 200, 200); 
				КонецЕсли;
				ВывестиПереходМеждуЭтапами(ТабличныйДокумент, БизнесПроцесс, ЗаписьОПереходе, Цвет);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	//Вывод безусловных переходов, заданных неявно (выполнение в порядке очереди)
	Для Счетчик = 1 По БизнесПроцесс.Этапы.Количество()-1 Цикл
		Индекс = БизнесПроцесс.Этапы.Количество() - Счетчик;
		Если Индекс > 0 
			И НЕ УЭтапаЕстьПредшественники(БизнесПроцесс, БизнесПроцесс.Этапы[Индекс]) 
			И НЕ ЭтапСтартуетСоСтартомПроцесса(БизнесПроцесс, БизнесПроцесс.Этапы[Индекс]) Тогда
			НарисоватьЛинию(БизнесПроцесс, ТабличныйДокумент, Индекс + 1, Индекс + 2);
		КонецЕсли;
	КонецЦикла;
	
	Если БизнесПроцесс.Этапы.Количество() > 0 Тогда 
		//Вывод перехода от старта к первому этапу
		Если НЕ УЭтапаЕстьПредшественники(БизнесПроцесс, БизнесПроцесс.Этапы[0]) 
			ИЛИ НЕ СредиЭтаповЕстьПоследователиСтартаПроцесса(БизнесПроцесс) Тогда
			НарисоватьЛинию(БизнесПроцесс, ТабличныйДокумент, 1, 2);
		КонецЕсли;
	КонецЕсли;
	
	//Вывод этапа "Старт процесса"
    Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2); 
	Шрифт = Новый Шрифт(,7);
    Строка = 2;
	Колонка = 2;
	
	Область = ТабличныйДокумент.Область(Строка, Колонка, Строка + 1, Колонка + 5);
	Область.Объединить();
	Область.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
	Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	Область.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
	Область.Текст = НСтр("ru = 'Старт процесса'");
	Область.Обвести(Линия, Линия, Линия, Линия);
	Область.Шрифт = Шрифт;
	Область.Гиперссылка = Истина;
	Область.Расшифровка = НСтр("ru = 'Старт процесса'");
	Если ТипЗнч(БизнесПроцесс.Ссылка) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
		Если БизнесПроцесс.Стартован Тогда
			Область.ЦветРамки = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
		Иначе
			Область.Шрифт = Новый Шрифт(Шрифт, , , Истина);
		КонецЕсли;
	КонецЕсли;
		
	// ВыводЭтапов
	Для каждого Этап Из БизнесПроцесс.Этапы Цикл
		ВывестиЭтапПроцесса(ТабличныйДокумент, Этап, БизнесПроцесс);	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиЭтапПроцесса(ТабличныйДокумент, ЭтапПроцесса, БизнесПроцесс)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2); 
	Шрифт = Новый Шрифт(,7);
	Номер = ЭтапПроцесса.НомерСтроки + 1;
	Строка = 3 * Номер - 1;
	Колонка = 6 * Номер - 4;
	
	Область = ТабличныйДокумент.Область(Строка, Колонка, Строка + 1, Колонка + 5);
	Область.Объединить();
	Область.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
	Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
	Область.ВертикальноеПоложение = ВертикальноеПоложение.Центр;	
	СтрокаСрок = "";
	Попытка
		БизнесПроцессыИЗадачиКлиентСервер.ПолучитьСрокИсполненияПрописью(
			ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач"),
			СтрокаСрок,
			ЭтапПроцесса.ШаблонБизнесПроцесса.СрокИсполнения,
			ЭтапПроцесса.ШаблонБизнесПроцесса.СрокИсполненияЧас);
	Исключение
		СтрокаСрок = "";		
	КонецПопытки;
	
	ИсполнителиПредставление = ЭтапПроцесса.ИсполнителиЭтапаСтрокой;
	
	Если ТипЗнч(БизнесПроцесс) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс")
		И ЗначениеЗаполнено(ЭтапПроцесса.ЗапущенныйБизнесПроцесс) 
		И Не ЭтапПроцесса.ЗадачаВыполнена Тогда
	
		Если ТипЗнч(ЭтапПроцесса.ЗапущенныйБизнесПроцесс) <> Тип("БизнесПроцессСсылка.КомплексныйПроцесс")
			И ТипЗнч(ЭтапПроцесса.ЗапущенныйБизнеспроцесс) <> Тип("БизнесПроцессСсылка.ОбработкаВнутреннегоДокумента")
			И ТипЗнч(ЭтапПроцесса.ЗапущенныйБизнеспроцесс) <> Тип("БизнесПроцессСсылка.ОбработкаВходящегоДокумента")
			И ТипЗнч(ЭтапПроцесса.ЗапущенныйБизнеспроцесс) <> Тип("БизнесПроцессСсылка.ОбработкаИсходящегоДокумента") Тогда
							
			МассивЗадач = РаботаСБизнесПроцессами.ПолучитьМассивЗадачПоБизнесПроцессу(
				ЭтапПроцесса.ЗапущенныйБизнесПроцесс,
				Истина);
			ИсполнителиПредставление = "";
			Для Каждого Задача Из МассивЗадач Цикл
				Если ЗначениеЗаполнено(Задача.Ссылка.Исполнитель) Тогда
					ИсполнителиПредставление = 
						ИсполнителиПредставление + Строка(Задача.Ссылка.Исполнитель) + "; ";
				ИначеЕсли ЗначениеЗаполнено(Задача.Ссылка.РольИсполнителя) Тогда
					ИсполнителиПредставление = 
						ИсполнителиПредставление + Строка(Задача.Ссылка.РольИсполнителя) + "; ";
				КонецЕсли;	
			КонецЦикла;	
						
		КонецЕсли;
	КонецЕсли;
	
	Область.Текст = 
		ЭтапПроцесса.ШаблонБизнесПроцесса.НаименованиеБизнесПроцесса
		+ Символы.ПС + НСтр("ru = 'Исполнители") + ": " + ИсполнителиПредставление
		+ ?(ЗначениеЗаполнено(СтрокаСрок), Символы.ПС + НСтр("ru = 'Срок'") + ": " + СтрокаСрок, "");;
		
		
	Если ТипЗнч(БизнесПроцесс) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
		Если ЗначениеЗаполнено(ЭтапПроцесса.ЗапущенныйБизнесПроцесс) И Не ЭтапПроцесса.ЗадачаВыполнена Тогда	
			Шрифт = Новый Шрифт(Шрифт, , , Истина);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ЭтапПроцесса.ЗапущенныйБизнесПроцесс) Тогда
			Область.ЦветРамки = Новый Цвет(100,100,100);
			Область.ЦветТекста = Новый Цвет(100,100,100);
		ИначеЕсли ЗначениеЗаполнено(ЭтапПроцесса.ЗапущенныйБизнесПроцесс) И НЕ ЭтапПроцесса.ЗадачаВыполнена Тогда
			Область.ЦветРамки = Новый Цвет(0,0,0);
		ИначеЕсли ЗначениеЗаполнено(ЭтапПроцесса.ЗапущенныйБизнесПроцесс) И ЭтапПроцесса.ЗадачаВыполнена Тогда	
			МенеджерПроцесса = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ЭтапПроцесса.ЗапущенныйБизнесПроцесс);
			Если МенеджерПроцесса.ПроцессЗавершилсяУдачно(ЭтапПроцесса.ЗапущенныйБизнесПроцесс) Тогда
				Область.ЦветРамки = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
				Область.ЦветТекста = Новый Цвет(0,0,0);
			Иначе
				Область.ЦветРамки = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
				Область.ЦветТекста = Новый Цвет(0,0,0);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Область.Гиперссылка = Истина;
	Область.Обвести(Линия, Линия, Линия, Линия);
	Область.Шрифт = Шрифт;
	
	Область.Расшифровка = ЭтапПроцесса.ШаблонБизнесПроцесса;
	Если ТипЗнч(БизнесПроцесс) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс")
		И ЗначениеЗаполнено(ЭтапПроцесса.ЗапущенныйБизнесПроцесс) Тогда
		
		Область.Расшифровка = ЭтапПроцесса.ЗапущенныйБизнесПроцесс;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиПереходМеждуЭтапами(ТабличныйДокумент, БизнесПроцесс, ЗаписьОПереходе, Цвет)
	
	НомерПредшественника = 0;
	НомерПоследователя = 0;
	
	Если ЗаписьОПереходе.ИдентификаторПредшественника = УникальныйИдентификаторПустой() Тогда
		НомерПредшественника = 1;
	КонецЕсли;
	Для Каждого Этап Из БизнесПроцесс.Этапы Цикл
				
		Если Этап.ИдентификаторЭтапа = ЗаписьОПереходе.ИдентификаторПредшественника Тогда
			НомерПредшественника = Этап.НомерСтроки + 1;
		КонецЕсли;
		Если Этап.ИдентификаторЭтапа = ЗаписьОПереходе.ИдентификаторПоследователя Тогда
			НомерПоследователя = Этап.НомерСтроки + 1;
		КонецЕсли;
		Если НомерПредшественника > 0 И НомерПоследователя > 0 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	НарисоватьЛинию(БизнесПроцесс, ТабличныйДокумент, НомерПредшественника, НомерПоследователя, ЗаписьОПереходе, Цвет);
	
КонецПроцедуры

&НаСервере
Процедура НарисоватьЛинию(БизнесПроцесс, ТабличныйДокумент, НомерПредшественника, НомерПоследователя, ЗаписьОПереходе = Неопределено, Цвет = Неопределено)
	
	Если НомерПредшественника > 0 И НомерПоследователя > 0 Тогда
		Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
		Шрифт = Новый Шрифт(,6);
		РисункиТабличногоДокумента = ТабличныйДокумент.Рисунки;
		Если НомерПредшественника < НомерПоследователя Тогда
			СтрокаЛевыйВерхний = 3 * НомерПредшественника + 1;
			КолонкаЛевыйВерхний = 6 * НомерПредшественника - 3;
			СтрокаПравыйНижний = 3 * НомерПоследователя - 1;
			КолонкаПравыйНижний = 6 * НомерПоследователя - 5;
			Область = ТабличныйДокумент.Область(СтрокаЛевыйВерхний, КолонкаЛевыйВерхний, СтрокаПравыйНижний, КолонкаПравыйНижний);
			Область.Обвести(Линия, , ,Линия);
			Если ЗаписьОПереходе <> Неопределено  
				И ЗначениеЗаполнено(ЗаписьОПереходе.УсловиеРассмотрения) Тогда
				ОбластьУсловие = ТабличныйДокумент.Область(СтрокаПравыйНижний, КолонкаЛевыйВерхний+1, СтрокаПравыйНижний, КолонкаЛевыйВерхний + 3);
			КонецЕсли;
			
			НовыйРисунок = РисункиТабличногоДокумента.Добавить(ТипРисункаТабличногоДокумента.Картинка);
	    	НовыйРисунок.Картинка = БиблиотекаКартинок.ПереместитьВправо;
	    	НовыйРисунок.РазмерКартинки=РазмерКартинки.АвтоРазмер;
			Если Цвет <> Неопределено Тогда
				НовыйРисунок.ЦветФона = Цвет;
			КонецЕсли;
	    	ОбластьРисунка = ТабличныйДокумент.Область(СтрокаПравыйНижний, КолонкаЛевыйВерхний);
			ОбластьРисунка.ВысотаСтроки = 0;//авторазмер
	    	НовыйРисунок.Расположить(ОбластьРисунка);
						
		КонецЕсли;
		
		Если НомерПредшественника > НомерПоследователя Тогда
			СтрокаЛевыйВерхний = 3 * НомерПоследователя;
			КолонкаЛевыйВерхний = 6 * НомерПоследователя - 2;
			СтрокаПравыйНижний = 3 * НомерПредшественника - 2;
			КолонкаПравыйНижний = 6 * НомерПредшественника;
			Область = ТабличныйДокумент.Область(СтрокаЛевыйВерхний, КолонкаЛевыйВерхний, СтрокаПравыйНижний, КолонкаПравыйНижний);
			Область.Обвести(, Линия, Линия);			
			Если ЗаписьОПереходе <> Неопределено  
				И ЗначениеЗаполнено(ЗаписьОПереходе.УсловиеРассмотрения) Тогда
				ОбластьУсловие = ТабличныйДокумент.Область(СтрокаЛевыйВерхний, КолонкаПравыйНижний - 3, СтрокаЛевыйВерхний, КолонкаПравыйНижний - 1);
			КонецЕсли;
	        
	    	НовыйРисунок = РисункиТабличногоДокумента.Добавить(ТипРисункаТабличногоДокумента.Картинка);
	    	НовыйРисунок.Картинка = БиблиотекаКартинок.ПереместитьВлево;
	    	НовыйРисунок.РазмерКартинки=РазмерКартинки.АвтоРазмер;
			Если Цвет <> Неопределено Тогда
				НовыйРисунок.ЦветФона = Цвет;
			КонецЕсли;
	    	ОбластьРисунка = ТабличныйДокумент.Область(СтрокаЛевыйВерхний, КолонкаПравыйНижний);
			ОбластьРисунка.ВысотаСтроки = 0;//авторазмер
	    	НовыйРисунок.Расположить(ОбластьРисунка);
		КонецЕсли;
		
		Область.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
		Область.Шрифт = Шрифт;

		Если ОбластьУсловие <> Неопределено Тогда
			ОбластьУсловие.Объединить();
			ОбластьУсловие.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
			ОбластьУсловие.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
			ОбластьУсловие.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
			ОбластьУсловие.Обвести(Линия, Линия, Линия, Линия);
			ОбластьУсловие.Расшифровка = ЗаписьОПереходе.УсловиеПерехода;
			ОбластьУсловие.Шрифт = Шрифт;
			СтрокаУсловиеРассмотрения = "";
			СтрокаУсловиеПерехода = "";
			Если ЗаписьОПереходе.УсловиеРассмотрения <>
				Перечисления.УсловияРассмотренияПредшественниковЭтапа.НезависимоОтРезультатаВыполнения Тогда
				СтрокаУсловиеРассмотрения = Строка(ЗаписьОПереходе.УсловиеРассмотрения);
				Если ТипЗнч(БизнесПроцесс.Ссылка) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда 
					Если ЗаписьОПереходе.УсловныйПереходБылВыполнен Тогда
						Если ЗаписьОПереходе.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеУспешногоВыполнения Тогда
							ОбластьУсловие.ЦветРамки = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
							ОбластьУсловие.ЦветТекста = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
							НовыйРисунок.ЦветЛинии = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
						ИначеЕсли ЗаписьОПереходе.УсловиеРассмотрения = Перечисления.УсловияРассмотренияПредшественниковЭтапа.ПослеНеуспешногоВыполнения Тогда
							ОбластьУсловие.ЦветРамки = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
							ОбластьУсловие.ЦветТекста = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
							НовыйРисунок.ЦветЛинии = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
						КонецЕсли;	
					Иначе
						ОбластьУсловие.ЦветРамки = Новый Цвет(100,100,100);
						ОбластьУсловие.ЦветТекста = Новый Цвет(100,100,100);
						НовыйРисунок.ЦветЛинии = Новый Цвет(100,100,100);
					КонецЕсли;
				КонецЕсли;
			ИначеЕсли ТипЗнч(БизнесПроцесс.Ссылка) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") И ЗаписьОПереходе.УсловныйПереходБылВыполнен Тогда
				ОбластьУсловие.ЦветРамки = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
				ОбластьУсловие.ЦветТекста = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
				НовыйРисунок.ЦветЛинии = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
			КонецЕсли;
			Если ЗначениеЗаполнено(ЗаписьОПереходе.УсловиеПерехода) Тогда
				СтрокаУсловиеПерехода = Строка(ЗаписьОПереходе.УсловиеПерехода);
				ОбластьУсловие.Гиперссылка = Истина;
				ОбластьУсловие.Расшифровка = ЗаписьОПереходе.УсловиеПерехода;
			КонецЕсли;
			ОбластьУсловие.Текст = 
				?(ЗначениеЗаполнено(СтрокаУсловиеРассмотрения), СтрокаУсловиеРассмотрения + Символы.ПС, "")
				+ Строка(ЗаписьОПереходе.УсловиеПерехода);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УЭтапаЕстьПредшественники(БизнесПроцесс, Этап)
	
	Для каждого ЗаписьОПереходе Из БизнесПроцесс.ПредшественникиЭтапов Цикл
		Если ЗаписьОПереходе.ИдентификаторПоследователя = Этап.ИдентификаторЭтапа 
			И ЗаписьОПереходе.ИдентификаторПредшественника <> УникальныйИдентификаторПустой() Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла; 	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция ЭтапСтартуетСоСтартомПроцесса(БизнесПроцесс, Этап)
	
	Для каждого ЗаписьОПереходе Из БизнесПроцесс.ПредшественникиЭтапов Цикл
		Если ЗаписьОПереходе.ИдентификаторПоследователя = Этап.ИдентификаторЭтапа 
			И ЗаписьОПереходе.ИдентификаторПредшественника = УникальныйИдентификаторПустой() Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла; 	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция СредиЭтаповЕстьПоследователиСтартаПроцесса(БизнесПроцесс)
	
	Для каждого ЗаписьОПереходе Из БизнесПроцесс.ПредшественникиЭтапов Цикл
		Если ЗаписьОПереходе.ИдентификаторПредшественника = УникальныйИдентификаторПустой() Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла; 	
	Возврат Ложь;

КонецФункции