
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("КонвертацияФайлов") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("РазмещениеФайловВТомах") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		РодительскаяВерсия = Владелец.ТекущаяВерсия;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() Тогда
		
		ЕстьПометкаУдаленияВИБ = ПометкаУдаленияВИБ();
		УстановленаПометкаУдаления = ПометкаУдаления И Не ЕстьПометкаУдаленияВИБ;
		
		ИзмененаПометкаУдаления = Ложь;
		Если ДополнительныеСвойства.Свойство("ИзмененаПометкаУдаления") Тогда
			ИзмененаПометкаУдаления = ДополнительныеСвойства.ИзмененаПометкаУдаления;
		Иначе
			ИзмененаПометкаУдаления = (ПометкаУдаления <> ЕстьПометкаУдаленияВИБ);
			ДополнительныеСвойства.Вставить("ИзмененаПометкаУдаления", ИзмененаПометкаУдаления);
		КонецЕсли;
		
		ЗаписьПодписанногоОбъекта = Ложь;
		Если ДополнительныеСвойства.Свойство("ЗаписьПодписанногоОбъекта") Тогда
			ЗаписьПодписанногоОбъекта = ДополнительныеСвойства.ЗаписьПодписанногоОбъекта;
		КонецЕсли;
		
		// разрешаем ставить пометку удаления на подписанную версию
		Если НЕ ПривилегированныйРежим() И ЗаписьПодписанногоОбъекта <> Истина И НЕ ИзмененаПометкаУдаления Тогда
			
			Если ЗначениеЗаполнено(Ссылка) Тогда
				
				СтруктураРеквизитов = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Ссылка, "ПодписанЭП, Зашифрован");
				СсылкаПодписан = СтруктураРеквизитов.ПодписанЭП;
				СсылкаЗашифрован = СтруктураРеквизитов.Зашифрован;
				
				Если ПодписанЭП И СсылкаПодписан Тогда
					ВызватьИсключение НСтр("ru = 'Подписанную версию нельзя редактировать.'");
				КонецЕсли;
				
				Если Зашифрован И СсылкаЗашифрован И ПодписанЭП И НЕ СсылкаПодписан Тогда
					ВызватьИсключение НСтр("ru = 'Зашифрованный файл нельзя подписывать.'");
				КонецЕсли;
				
			КонецЕсли;
		
		КонецЕсли;
	КонецЕсли;
	
	// Выполним установку индекса пиктограммы при записи объекта
	ИндексКартинки = ФайловыеФункцииКлиентСервер.ПолучитьИндексПиктограммыФайла(Расширение);
	
	Если СтатусИзвлеченияТекста.Пустая() Тогда
		СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен;
	КонецЕсли;
	
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Файлы") Тогда
		Наименование = СокрЛП(ПолноеНаименование);
	КонецЕсли;
	
	Если Владелец.ТекущаяВерсия = Ссылка Тогда
		Если ПометкаУдаления = Истина И Владелец.ПометкаУдаления <> Истина Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Активную версию нельзя удалить!'"));
		КонецЕсли;
	ИначеЕсли РодительскаяВерсия.Пустая() Тогда
		Если ПометкаУдаления = Истина И Владелец.ПометкаУдаления <> Истина Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Первую версию нельзя удалить!'"));
		КонецЕсли;
	ИначеЕсли ПометкаУдаления = Истина И Владелец.ПометкаУдаления <> Истина Тогда
		// Очищаем у версий, дочерних к помеченной, ссылку на родительскую - 
		// переставляем на родительскую версию удаляемой версии
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВерсииФайлов.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ВерсииФайлов КАК ВерсииФайлов
			|ГДЕ
			|	ВерсииФайлов.РодительскаяВерсия = &РодительскаяВерсия";
		
		Запрос.УстановитьПараметр("РодительскаяВерсия", Ссылка);
		
		Результат = Запрос.Выполнить();
		
		Если Не Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка);
			Объект.РодительскаяВерсия = РодительскаяВерсия;
			Объект.Записать();
		КонецЕсли;
	КонецЕсли;
	
	// Заполняем сведения о персональных данных во всех версиях файла
	Если ЭтоНовый() И ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоступаКПерсональнымДанным") Тогда
		СубъектыПерсональныхДанных.Очистить();
	
		Для каждого Субъект Из Владелец.СубъектыПерсональныхДанных Цикл
			Строка = СубъектыПерсональныхДанных.Добавить();
			Строка.ФизическоеЛицо = Субъект.ФизическоеЛицо;
		КонецЦикла;	
	Конецесли;
	
	// Очищаем признак АвтокатегоризацияПройдена и КатегорииПроверены у файла - владельца версии
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюКатегоризациюДанных") Тогда
		РаботаСКатегориямиДанных.СнятьПризнакОбработкиОбъектаПравилами(Владелец);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
		
		Если НЕ Том.Пустая() Тогда
			
			ПолныйПуть = ФайловыеФункции.ПолныйПутьТома(Том) + ПутьКФайлу; 
			Попытка
				Файл = Новый Файл(ПолныйПуть);
				Файл.УстановитьТолькоЧтение(Ложь);
				УдалитьФайлы(ПолныйПуть);
				
				ПутьСПодкаталогом = Файл.Путь;
				МассивФайловВКаталоге = НайтиФайлы(ПутьСПодкаталогом, "*.*");
				Если МассивФайловВКаталоге.Количество() = 0 Тогда
					УдалитьФайлы(ПутьСПодкаталогом);
				КонецЕсли;
				
			Исключение // глотаем исключение, т.к. версия должна быть удалена, даже если файл в томе нельзя удалить
				
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Удаление версии файла'"),
					УровеньЖурналаРегистрации.Ошибка,,,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает текущее значение пометки удаления в информационной базе
Функция ПометкаУдаленияВИБ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВерсииФайлов.ПометкаУдаления
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов
		|ГДЕ
		|	ВерсииФайлов.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ПометкаУдаления;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ПриЗаписи(Отказ)
	
	ДвоичныеДанные = Неопределено;
	Если ДополнительныеСвойства.Свойство("ДвоичныеДанные", ДвоичныеДанные) Тогда
		
		ПутьКФайлуНаТоме = "";
		СсылкаНаТом = Неопределено;
		
		// добавить в один из томов (где есть свободное место)
		ФайловыеФункции.ДобавитьНаДиск(
			ДвоичныеДанные,
			ПутьКФайлуНаТоме, СсылкаНаТом, ДатаМодификацииУниверсальная, 
			НомерВерсии, Наименование, Расширение, Размер, Зашифрован,
			Неопределено, Ссылка);
		
		ПутьКФайлу = ПутьКФайлуНаТоме;
		Том		 = СсылкаНаТом;
		ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске;
		
		ДополнительныеСвойства.Удалить("ДвоичныеДанные");
		Записать();
		
		РаботаСФайламиВызовСервера.УдалитьЗаписьИзРегистраХранимыеФайлыВерсий(Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры
