&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
	
	ПолучитьНашиРеквизиты();

КонецПроцедуры

&НаСервере
Функция ПолучитьНашиРеквизиты()
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КорреспондентыКонтактнаяИнформация.Ссылка.ПолноеНаименование КАК НашеНазвание,
		|	КорреспондентыКонтактнаяИнформация.Представление КАК НашАдрес,
		|	НашаОрганизация.Значение.ИНН КАК НашУНП
		|ИЗ
		|	Константа.НашаОрганизация КАК НашаОрганизация
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Корреспонденты.КонтактнаяИнформация КАК КорреспондентыКонтактнаяИнформация
		|		ПО НашаОрганизация.Значение = КорреспондентыКонтактнаяИнформация.Ссылка
		|ГДЕ
		|	КорреспондентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
		|	И КорреспондентыКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ЮридическийАдресКорреспондента)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	НашиРеквизиты = Новый Структура("НашУНП, НашеНазвание, НашАдрес"); 
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Выборка);
	КонецЦикла;
	Возврат НашиРеквизиты;
КонецФункции  


&НаКлиенте
Процедура ПрочитатьФайл(Команда)
	ОчиститьСообщения();
	
	ПоказатьОповещениеПользователя("Чтение файла...");
	
	ПрочитатьФайлВДанныеФайла();
	
	ЗаполнитьКорреспондентов();
	
	ЗаполнитьЭСЧФ();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЭСЧФ(Команда)
	СоздатьЭСЧФНаСервере();	
КонецПроцедуры

&НаСервере
Процедура СоздатьЭСЧФНаСервере(Исправленный = Ложь)
	НачатьТранзакцию();
    Сч = 0;
	ТекДок = "";
	Док = "";
	ПредСтрока = "";
	
	Для каждого Стр Из ДанныеФайла Цикл
		Если Не Стр.Пометка Тогда
			Продолжить;
        КонецЕсли; 
        Сч = Сч + 1;
        Если Сч%50=0 Тогда
            ЗафиксироватьТранзакцию();
            НачатьТранзакцию();
		КонецЕсли;
		
		Если ТекДок <> Стр.НомерДок Тогда
			Если ТекДок <> "" Тогда
				// Запись предыдущего
				Док.Записать(РежимЗаписиДокумента.Проведение);
				Если ПредСтрока <> "" Тогда
					ПредСтрока.ЭСЧФ = Док.Ссылка;
				КонецЕсли; 
			КонецЕсли; 
			
			ТекДок = Стр.НомерДок;
			// Открытие следующего
			Если ЗначениеЗаполнено(Стр.ЭСЧФ) Тогда
				ЭтоНовый = Ложь;
				Док = Стр.ЭСЧФ.ПолучитьОбъект();
			Иначе
				ЭтоНовый = Истина;
				Док = Документы.мЭСЧФ.СоздатьДокумент();
				Док.Дата = ДатаСозданияЭСЧФ;
				Док.Номер = НачальныйНомерЭСЧФ;
				НачальныйНомерЭСЧФ = Формат(Число(НачальныйНомерЭСЧФ)+1, "ЧЦ=10; ЧВН=; ЧГ=");
			КонецЕсли; 
			
			// Заполнение
			Док.СтатусСФ = Перечисления.мСтатусыСФ.Подготовлен1С;
			//Док.АктВыполненныхРабот = СтрАкт.Акт;
			
			Док._01_НомерСЧ = Строка(НашУНП)+"-"+Формат(Год(Стр.ДатаДок),"ЧГ=0")+"-"+Док.Номер;
			Док._03_ДатаСовершенияОперации = Стр.ДатаДок;
			//Если Исправленный Тогда
			//	Док._04_ТипСЧ = Перечисления.мТипСЧ.Исправленный;
			//	Док._05_ОтноситсяКСЧ = СтрАкт.ЭСЧФ;//ПолучитьНомерЭСЧФ(СтрАкт.ЭСЧФ);
			//	Док._05_1_ДатаАннулированияСФ = СтрАкт.ДатаСовершенияОперации;
			//Иначе
			Док._04_ТипСЧ = Перечисления.мТипСЧ.Исходный;
			//КонецЕсли; 
			Док._06_СтатусПоставщика = Перечисления.мСтатусыПоставщика.Продавец;
			//Док._06_1_ВзаимозависимоеЛицо = Ложь;
			Док._07_КодСтраныПоставщика = "112";
			Док._08_УНППоставщика = НашУНП;
			Док._09_Поставщик = НашеНазвание;
			Док._10_ЮрАдресПоставщика = НашАдрес;
			Если ЗначениеЗаполнено(Стр.УНП) Тогда
				// Это юрлицо
				Док._15_СтатусПолучателя = Перечисления.мСтатусыПолучателя.Покупатель;
				//Если СтрАкт.НДС=0 И Исправленный Тогда
				//	Док._17_УНППолучателя = "";
				//Иначе	
				Док._16_КодСтраныПолучателя = "112";
				Док._17_УНППолучателя = Стр.УНП;
				
				Отбор = Новый Структура("УНП", Стр.УНП);
				ИскСтроки = Корреспонденты.НайтиСтроки(Отбор);
				Если ИскСтроки.Количество() > 0 Тогда
					Док._06_1_ВзаимозависимоеЛицо = ИскСтроки[0].ВзаимозависимоеЛицо;
					Док._17_1_КодФилиалаПолучателя = ИскСтроки[0].КодФилиала;
					Док._18_Получатель = ИскСтроки[0].Наименование;
					Док._19_ЮрАдресПолучателя = ИскСтроки[0].Адрес;
				КонецЕсли; 
			Иначе
				Док._15_СтатусПолучателя = Перечисления.мСтатусыПолучателя.Потребитель;
			КонецЕсли; 
			Док._30_1_НомерДоговора = Стр.НомерДог; 
			Док._30_2_ДатаДоговора = Стр.ДатаДог;
			
			Если ЭтоНовый Тогда
				СтрРаздел4 = Док.Раздел4.Добавить();
			Иначе
				СтрРаздел4 = Док.Раздел4[0];
			КонецЕсли; 
			СтрРаздел4._22_КодСтраныГрузоотправителя = "112";
			СтрРаздел4._23_УНПГрузоотправителя = НашУНП;
			СтрРаздел4._24_Грузоотправитель = НашеНазвание;
			СтрРаздел4._25_АдресОтправки = НашАдрес;
			СтрРаздел4._26_КодСтраныГрузополучателя = "112";
			СтрРаздел4._27_УНПГрузополучателя = Стр.УНП;
			СтрРаздел4._28_Грузополучатель = Док._18_Получатель;
			СтрРаздел4._29_АдресДоставки = Док._19_ЮрАдресПолучателя;
			
			Если ЭтоНовый Тогда
				СтрРаздел5 = Док.Раздел5.Добавить();
			Иначе
				СтрРаздел5 = Док.Раздел5[0];
			КонецЕсли; 
			СтрРаздел5._30_3_ВидДокумента = Перечисления.мВидыДокументовЭСЧФ.ТН2;
			СтрРаздел5._30_5_ДатаДокумента = Стр.ДатаДок;
			СтрРаздел5._30_6_КодТипаБланка = Стр.КодБланка;
			СтрРаздел5._30_7_СерияБланка = Стр.Серия;
			//СтрРаздел5._30_4_НазваниеДокумента = Перечисления.мВидыДокументовЭСЧФ.АктВыполненныхРабот;
			СтрРаздел5._30_8_НомерБланка = Стр.НомерДок;
			
			Если ЭтоНовый Тогда
				СтрРаздел6 = Док.Раздел6.Добавить();                     
			Иначе
				СтрРаздел6 = Док.Раздел6[0];
			КонецЕсли; 
			СтрРаздел6._2_Наименование = Стр.Наименование;
			СтрРаздел6._4_ЕдиницаИзмерения = "шт";
			СтрРаздел6._5_Количество = Стр.Колво;
			СтрРаздел6._6_Цена = Стр.Цена;
			СтрРаздел6._7_Стоимость = Стр.Стоимость;
			СтрРаздел6._9_СтавкаНДС = Справочники.мСтавкиНДС.НДС_20;
			СтрРаздел6._10_СуммаНДС = Стр.НДС;
			СтрРаздел6._11_СтоимостьСНДС = Стр.Всего;
			
			Если Док._06_1_ВзаимозависимоеЛицо Тогда
				СтрРаздел6._3_2_КодОКЭД = Справочники.мВидыЭкономическойДеятельности.НайтиПоКоду("71200");
			КонецЕсли; 
			Если Стр.НДС = 0 Тогда
				СтрРаздел6._12_ДопДанные1 = Перечисления.мДополнительныеДанныеЭСЧФ.ОсвобождениеОтНДС;
			КонецЕсли; 
			
			Док.ВсегоСтомость = Док.ВсегоСтомость + СтрРаздел6._7_Стоимость;
			Док.ВсегоНДС = Док.ВсегоНДС + СтрРаздел6._10_СуммаНДС;
			Док.ВсегоСтомостьСНДС = Док.ВсегоСтомостьСНДС + СтрРаздел6._11_СтоимостьСНДС;
		
		Иначе	
			// Продолжение заполнения товарного раздела
			СтрРаздел6 = Док.Раздел6.Добавить();                     
			СтрРаздел6._2_Наименование = Стр.Наименование;
			СтрРаздел6._4_ЕдиницаИзмерения = "шт";
			СтрРаздел6._5_Количество = Стр.Колво;
			СтрРаздел6._6_Цена = Стр.Цена;
			СтрРаздел6._7_Стоимость = Стр.Стоимость;
			СтрРаздел6._9_СтавкаНДС = Справочники.мСтавкиНДС.НДС_20;
			СтрРаздел6._10_СуммаНДС = Стр.НДС;
			СтрРаздел6._11_СтоимостьСНДС = Стр.Всего;
			
			Если Док._06_1_ВзаимозависимоеЛицо Тогда
				СтрРаздел6._3_2_КодОКЭД = Справочники.мВидыЭкономическойДеятельности.НайтиПоКоду("71200");
			КонецЕсли; 
			Если Стр.НДС = 0 Тогда
				СтрРаздел6._12_ДопДанные1 = Перечисления.мДополнительныеДанныеЭСЧФ.ОсвобождениеОтНДС;
			КонецЕсли; 
			
			Док.ВсегоСтомость = Док.ВсегоСтомость + СтрРаздел6._7_Стоимость;
			Док.ВсегоНДС = Док.ВсегоНДС + СтрРаздел6._10_СуммаНДС;
			Док.ВсегоСтомостьСНДС = Док.ВсегоСтомостьСНДС + СтрРаздел6._11_СтоимостьСНДС;
		КонецЕсли; 
		ПредСтрока = Стр;
	КонецЦикла;
	
	// Запись Последнего
	Если Док <> "" Тогда
		Док.Записать(РежимЗаписиДокумента.Проведение);
		Если ПредСтрока <> "" Тогда
			ПредСтрока.ЭСЧФ = Док.Ссылка;
		КонецЕсли; 
	КонецЕсли; 
	
    Если ТранзакцияАктивна() Тогда
        ЗафиксироватьТранзакцию();
    КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НачальныйНомерЭСЧФОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	НачальныйНомерЭСЧФ = ДополнитьНулями(Текст); 
КонецПроцедуры

&НаКлиенте
Функция ДополнитьНулями(Текст)
	Результат = Текст;
	Пока СтрДлина(Результат) < 10  Цикл
		Результат = "0"+Результат;
	КонецЦикла; 
	Возврат Результат;
КонецФункции // 

&НаКлиенте
Процедура ПрочитатьФайлВДанныеФайла()
	
	ДанныеФайла.Очистить();
	
	XLSОбъект = Новый COMОбъект("Excel.Application");
	XLSОбъект.Visible       = Ложь;
	XLSОбъект.DisplayAlerts = Ложь;

    Попытка
        Book = XLSОбъект.Workbooks.Open(ПутьКФайлу, , Истина);
    Исключение
        Сообщить ("Проблемы с подключением к Excel");
        Возврат;
	КонецПопытки;
	
    Лист = Book.Sheets(1);
    //КолвоКолонок = Лист.Cells(1,1).SpecialCells(11).Column;
    КолвоСтрок   = Лист.Cells(1,1).SpecialCells(11).Row;
	
	НачСтрока = 2;
	КонСтрока = КолвоСтрок;
	ВсегоСтрок = КонСтрока-НачСтрока+1;
	
	Сообщено = Новый Соответствие;
	
	ТекНомерТТН = "";
	
    Для НомерСтроки = НачСтрока По КонСтрока Цикл

		#Если Клиент Тогда
			Если НомерСтроки%10 = 0 Тогда
				Состояние("Чтение файла: " + Формат(НомерСтроки) + " из " + Формат(КонСтрока), Окр((НомерСтроки-1)/ВсегоСтрок*100));
			КонецЕсли; 
			ОбработкаПрерыванияПользователя();
		#КонецЕсли
		
		НовСтр = ДанныеФайла.Добавить();
		НовСтр.НомерДок = Лист.Cells(НомерСтроки, 2).Value;
		НовСтр.ДатаДок = ПолучитьДатуИзФайла(Лист.Cells(НомерСтроки, 3).Value);
		НовСтр.Серия = Лист.Cells(НомерСтроки, 4).Value;
		НовСтр.КодБланка = Лист.Cells(НомерСтроки, 5).Value;
		НовСтр.УНП = Лист.Cells(НомерСтроки, 6).Value;
		НовСтр.УНП = СтрЗаменить(НовСтр.УНП, Символы.НПП, "");
		НовСтр.НомерДог = Лист.Cells(НомерСтроки, 7).Value;
		НовСтр.ДатаДог = ПолучитьДатуДогИзФайла(Лист.Cells(НомерСтроки, 8).Value);
		НовСтр.ВидДок = Лист.Cells(НомерСтроки, 11).Value;
		НовСтр.Наименование = Лист.Cells(НомерСтроки, 12).Value;
		НовСтр.Колво = Лист.Cells(НомерСтроки, 14).Value;
		НовСтр.Цена = Лист.Cells(НомерСтроки, 15).Value;
		НовСтр.Стоимость = Лист.Cells(НомерСтроки, 16).Value;
		//Ставка = Дата(Лист.Cells(НомерСтроки, 18).Value);
		НовСтр.НДС = Лист.Cells(НомерСтроки, 18).Value;
		НовСтр.Всего = Лист.Cells(НомерСтроки, 19).Value;
		НовСтр.Пометка = Истина;
		
    КонецЦикла;

	ДанныеФайла.Сортировать("НомерДок");
	
    XLSОбъект.Application.Quit();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКорреспондентов()
	Корреспонденты.Очистить();
	
	СпУНП = новый СписокЗначений;
	Для каждого Стр Из ДанныеФайла Цикл
		Если СпУНП.НайтиПоЗначению(Стр.УНП) = Неопределено Тогда
			СпУНП.Добавить(Стр.УНП);
		КонецЕсли; 
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КорреспондентыКонтактнаяИнформация.Представление КАК Адрес,
		|	ВЫРАЗИТЬ(КорреспондентыКонтактнаяИнформация.Ссылка.ПолноеНаименование КАК СТРОКА(1000)) КАК Наименование,
		|	КорреспондентыКонтактнаяИнформация.Ссылка.мКодФилиала КАК КодФилиала,
		|	КорреспондентыКонтактнаяИнформация.Ссылка.мВышестоящаяОрганизация,
		|	КорреспондентыКонтактнаяИнформация.Ссылка КАК Корреспондент,
		|	КорреспондентыКонтактнаяИнформация.Ссылка.мСтрана,
		|	КорреспондентыКонтактнаяИнформация.Ссылка.мВзаимозависимоеЛицо КАК ВзаимозависимоеЛицо,
		|	КорреспондентыКонтактнаяИнформация.Ссылка.мНаименованиеФилиала,
		|	КорреспондентыКонтактнаяИнформация.Ссылка.мЯвляетсяФилиалом,
		|	КорреспондентыКонтактнаяИнформация.Ссылка.ИНН КАК УНП
		|ИЗ
		|	Справочник.Корреспонденты.КонтактнаяИнформация КАК КорреспондентыКонтактнаяИнформация
		|ГДЕ
		|	КорреспондентыКонтактнаяИнформация.Ссылка.ИНН В(&СпУНП)
		|	И КорреспондентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
		|	И (КорреспондентыКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ЮридическийАдресКорреспондента)
		|			ИЛИ КорреспондентыКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ПочтовыйАдресФизическогоЛица))";
	
	Запрос.УстановитьПараметр("СпУНП", СпУНП);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Стр = Корреспонденты.Добавить();
		ЗаполнитьЗначенияСвойств(Стр, Выборка);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭСЧФ()
	
	СпТТН = новый СписокЗначений;
	Для каждого Стр Из ДанныеФайла Цикл
		Если СпТТН.НайтиПоЗначению(Стр.НомерДок) = Неопределено Тогда
			СпТТН.Добавить(Стр.НомерДок);
		КонецЕсли; 
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мЭСЧФРаздел5.Ссылка КАК ЭСЧФ,
		|	мЭСЧФРаздел5._30_8_НомерБланка КАК НомерТТН
		|ИЗ
		|	Документ.мЭСЧФ.Раздел5 КАК мЭСЧФРаздел5
		|ГДЕ
		|	мЭСЧФРаздел5._30_8_НомерБланка В(&СпТТН)";
	
	Запрос.УстановитьПараметр("СпТТН", СпТТН);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Отбор = Новый Структура("НомерДок", Выборка.НомерТТН);
		ИскСтроки = ДанныеФайла.НайтиСтроки(Отбор);
		Если ИскСтроки.Количество() > 0 Тогда
			Для каждого Стр Из ИскСтроки Цикл
				Стр.ЭСЧФ = Выборка.ЭСЧФ;
				Стр.Пометка = Ложь;
			КонецЦикла; 
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры
 

&НаКлиенте
Функция ПолучитьДатуИзФайла(СтрокаДаты)
	ГодДаты = 2000 + Число(Сред(СтрокаДаты, 7, 2));
	МесяцДаты = Число(Сред(СтрокаДаты, 4, 2));
	ЧислоДаты = Число(Лев(СтрокаДаты, 2));
	ИскДата = Дата(ГодДаты, МесяцДаты, ЧислоДаты);
	Возврат ИскДата;
КонецФункции
&НаКлиенте
Функция ПолучитьДатуДогИзФайла(СтрокаДаты)
	ГодДаты = 2000 + Число(Сред(СтрокаДаты, 9, 2));
	МесяцДаты = Число(Сред(СтрокаДаты, 4, 2));
	ЧислоДаты = Число(Лев(СтрокаДаты, 2));
	ИскДата = Дата(ГодДаты, МесяцДаты, ЧислоДаты);
	Возврат ИскДата;
КонецФункции


&НаСервереБезКонтекста
Функция ПолучитьЗначениеСтавкиНДС(СтавкаНДС)
	Возврат СтавкаНДС.Ставка;	
КонецФункции
 
&НаСервере
Функция ПолучитьПолучателя(ТзДог, Договор, Стр)
	НаименованиеОбъекта = ""+Стр.Фамилия+" "+Стр.Имя+" "+Стр.Отчество;
	
	Отбор = Новый Структура("Договор, ОбъектРаботНаименование", Договор, НаименованиеОбъекта); 
	
	ИскСтроки = ТзДог.НайтиСтроки(Отбор);
	Если ИскСтроки.Количество() = 0 Тогда
		НовОбъект = Справочники.мОбъектыРабот.СоздатьЭлемент();
		НовОбъект.Владелец = Договор.Корреспондент;
		НовОбъект.Наименование = НаименованиеОбъекта;
		НовОбъект.ПолноеНаименование = НаименованиеОбъекта;
		НовОбъект.Записать();
		Получатель = НовОбъект.Ссылка;
		
		// Добавить в ТзДог 
		НовСтр = ТзДог.Добавить();
		НовСтр.Договор = Договор;
		НовСтр.ОбъектРаботНаименование = НаименованиеОбъекта;
		НовСтр.ОбъектРабот = Получатель;
	Иначе	
		Получатель = ИскСтроки[0].ОбъектРабот;	
	КонецЕсли; 
	
	Возврат Получатель;
КонецФункции

&НаСервере
Функция ПолучитьДанныеДляАктирования() 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	мЭтапыДоговоров.Ссылка КАК ЭтапДоговора,
	|	мЭтапыДоговоров.Подразделение КАК Подразделение,
	|	мЭтапыДоговоров.Исполнители.(
	|		Исполнитель,
	|		КТУ
	|	) КАК Исполнители,
	|	мЭтапыДоговоров.Владелец КАК Договор,
	|	мЭтапыДоговоров.Владелец.РегистрационныйНомер КАК РегистрационныйНомер,
	|	мЭтапыДоговоров.ОбъектРабот.Наименование КАК ОбъектРаботНаименование,
	|	мЭтапыДоговоров.ОбъектРабот КАК ОбъектРабот,
	|	мЭтапыДоговоров.НомерЭтапа
	|ИЗ
	|	Справочник.мЭтапыДоговоров КАК мЭтапыДоговоров
	|ГДЕ
	|	мЭтапыДоговоров.Владелец.РегистрационныйНомер В(&СписокНомеровДоговоров)
	|	И НЕ мЭтапыДоговоров.ПометкаУдаления";
	
	СписокНомеровДоговоров = ПолучитьСписокНомеровДоговоров();
	Запрос.УстановитьПараметр("СписокНомеровДоговоров", СписокНомеровДоговоров);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
КонецФункции

&НаСервере
Функция ПолучитьСписокНомеровДоговоров()
	СписокНомеров = Новый СписокЗначений;
	//Договоры = СтрокиИзФайла.ПолучитьЭлементы();
	//Договоры = СтрокиИзФайла.ПолучитьЭлементы();
	Для каждого Стр Из ДанныеФайла Цикл
		Если Стр.Пометка Тогда
			СписокНомеров.Добавить(Стр.НомерДог);
		КонецЕсли; 
	КонецЦикла; 
	Возврат СписокНомеров;
КонецФункции


&НаКлиенте
Процедура ПометитьВсе(Команда)
	ПометитьЭлементы(ДанныеФайла, 1);
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	ПометитьЭлементы(ДанныеФайла, 0);
КонецПроцедуры

&НаКлиенте
Процедура ПометитьЭлементы(ТекЭл, Флаг)
	//Строки = ТекЭл.ПолучитьЭлементы();
	Для й=0 По ТекЭл.Количество()-1 Цикл
		ТекЭл[й].Пометка = Флаг;
		//ПометитьЭлементы(Эл, Флаг);
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура АктыПометкаПриИзменении(Элемент)
	ТекДанные = Элементы.СтрокиИзФайла.ТекущиеДанные;
	Если ТекДанные.Пометка = 2 Тогда
		ТекДанные.Пометка = 0;	
	КонецЕсли; 
	ТекЭлемент = СтрокиИзФайла.НайтиПоИдентификатору(ТекДанные.ПолучитьИдентификатор());
	
	ПометитьЭлементы(ТекЭлемент, ТекДанные.Пометка);
	
	Родитель = ТекЭлемент.ПолучитьРодителя();
	Пока Родитель <> Неопределено Цикл
		Родитель.Пометка = ?(УстановленноДляВсех(ТекЭлемент), ТекЭлемент.Пометка, 2);
		Родитель = Родитель.ПолучитьРодителя();
	КонецЦикла;
	
	//ПересчитатьИтогоПоДоговору(ТекДанные.Договор);
	
КонецПроцедуры

&НаКлиенте
Функция УстановленноДляВсех(ТекЭлемент)
	Родитель = ТекЭлемент.ПолучитьРодителя();
	Строки = Родитель.ПолучитьЭлементы();
	Для Каждого Стр Из Строки Цикл
		Если Стр.Пометка <> ТекЭлемент.Пометка Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ОчиститьАкты()
	Договоры = СтрокиИзФайла.ПолучитьЭлементы();
	
	й = Договоры.Количество()-1;
	Пока й >= 0 Цикл
		Договоры.Удалить(й);
		й = й-1;
	КонецЦикла; 	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Заголовок = "Открыть файл с данными";
	ДиалогВыбораФайла.Фильтр    = "Файлы Excel (*.xlsx)|*.xlsx|Файлы Excel (*.xls)|*.xls";
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ПутьКФайлу = ДиалогВыбораФайла.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры

#Область Печать

&НаКлиенте
Функция ПолучитьМассивСтрок(КолвоСтрок)
	МассивСтрок = Новый Массив;
	СтрокНаСтранице = 50;
	МинСтрокПервая = 20;
	МаксСтрокПервая = 36;
	МаксСтрокПоследняя = 31;
	
	Если КолвоСтрок < МинСтрокПервая Тогда
		// все на одной странице
		Возврат МассивСтрок;
		
	ИначеЕсли КолвоСтрок <= МаксСтрокПервая Тогда
		// на вторую надо перенести одну последнюю строку
		МассивСтрок.Добавить(КолвоСтрок-1);
		Возврат МассивСтрок;
	КонецЕсли; 
	
	// Две уже есть
	НомерСтраницы = 2;
	
	// переходим ко второй странице
	МассивСтрок.Добавить(МаксСтрокПервая);
	
	Пока 1=1 Цикл
	
		МаксНомерНаСтранице = МаксСтрокПервая + (НомерСтраницы-1)*СтрокНаСтранице;
		Если МаксНомерНаСтранице < КолвоСтрок Тогда
			// страница заполняется полностью и остается еще что-то на следующую
			МассивСтрок.Добавить(МаксНомерНаСтранице);
	    	НомерСтраницы = НомерСтраницы+1;
		Иначе
			// страница последняя, но не заполнена до конца, поместятся ли все строки на ней?
			МаксНомерПоследней = МаксСтрокПервая + МаксСтрокПоследняя + (НомерСтраницы-2)*СтрокНаСтранице;  
			Если МаксНомерПоследней <= КолвоСтрок Тогда
				// не влазит, надо еще одну страницу добавить с одной строкой
				МассивСтрок.Добавить(КолвоСтрок-1);
				НомерСтраницы = НомерСтраницы+1;
			КонецЕсли; 
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат МассивСтрок;
КонецФункции
 

&НаСервере
Функция ПолучитьЧисловойНомерДоговора(НомерАкта)
	Поз = СтрНайти(НомерАкта, "-");
	Если Поз > 0 Тогда
		Возврат Число(Лев(НомерАкта, Поз-1));
	КонецЕсли; 
	Возврат 0;
КонецФункции

#КонецОбласти 


#Область ОбработчикиФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьНачальныйНомерЭСЧФ();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНачальныйНомерЭСЧФ()
	НачальныйНомерЭСЧФ = ПривестиНомерЭСЧФКФормату(ПолучитьПоследнийНомерЭСЧФ() + 1);
КонецПроцедуры

&НаСервере
Функция ПолучитьПоследнийНомерЭСЧФ()
	Запрос       = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	мЭСЧФ.Номер
		|ИЗ
		|	Документ.мЭСЧФ КАК мЭСЧФ
		|ГДЕ
		|	ГОД(мЭСЧФ.Дата) = &ГодСФ
		|УПОРЯДОЧИТЬ ПО
		|	мЭСЧФ.Номер УБЫВ";
		
	ГодСФ                  = Год(ДатаСозданияЭСЧФ);
	Запрос.УстановитьПараметр("ГодСФ",ГодСФ);
	РезультатЗапроса       = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ?(ВыборкаДетальныеЗаписи.Следующий(), ОбщегоНазначения.ВЧисло(ВыборкаДетальныеЗаписи.Номер), 0);
КонецФункции

&НаСервереБезКонтекста
Функция ПривестиНомерЭСЧФКФормату(Номер)
	Возврат Формат(ОбщегоНазначения.ВЧисло(Номер), "ЧЦ=10; ЧВН=; ЧГ=0"); 
КонецФункции

&НаСервере
Процедура СоздатьАктыНаСервере()
	Док = Актирование.ПолучитьОбъект();

	Док.Акты.Очистить();
	Док.Зарплата.Очистить();
	
	ТзДог = ПолучитьДанныеДляАктирования();
	
	Для каждого Акт Из ДанныеФайла Цикл
		Если Не Акт.Пометка Тогда
			Продолжить;
		КонецЕсли; 
	
		Отбор = Новый Структура("РегистрационныйНомер",	Акт.НомерДог); 
			
		ИскСтроки = ТзДог.НайтиСтроки(Отбор);
		
		Если ИскСтроки.Количество() = 0 Тогда
			Сообщить("Не найден договор "+ Акт.НомерДог);
			Сообщить("Акт не создан!");
			Продолжить;
		КонецЕсли; 
		
		НовАкт = Док.Акты.Добавить();
		НовАкт.Договор = ИскСтроки[0].Договор;
		НовАкт.ЭтапДоговора = ИскСтроки[0].ЭтапДоговора;
		НовАкт.НомерАкта = Акт.НомерДог + "/" + Акт.НомерДок;
		НовАкт.ДатаАкта = Акт.ДатаДок;
		НовАкт.Сумма = Акт.Всего;
		НовАкт.НДС = Акт.НДС;
		
		Если ИскСтроки[0].Исполнители.Количество() > 0 Тогда
			Для каждого Исп Из ИскСтроки[0].Исполнители Цикл
				НовЗП = Док.Зарплата.Добавить();
				НовЗП.ЭтапДоговора = ИскСтроки[0].ЭтапДоговора;
				НовЗП.Исполнитель = Исп.Исполнитель;
				НовЗП.КТУ = Исп.КТУ;
				НовЗП.Норматив = 0;
				НовЗП.Коэффициент = 1;
				НовЗП.ОбъемРабот = Акт.Всего - Акт.НДС;
				НовЗП.Начислено = 0;
				Если ЗначениеЗаполнено(ИскСтроки[0].Подразделение) Тогда
					НовЗП.Подразделение = ИскСтроки[0].Подразделение;
				Иначе
					НовЗП.Подразделение = РаботаСПользователями.ПолучитьПодразделение(Исп.Исполнитель);
				КонецЕсли; 
				НовЗП.НомерАкта = НовАкт.НомерАкта;
				НовЗП.БазовоеНачисление = 0;
			КонецЦикла; 
		КонецЕсли; 
	КонецЦикла; 
	Док.Записать(РежимЗаписиДокумента.Запись);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьАкты(Команда)
	Если ДокНеПуст(Актирование) Тогда
		Ответ = Вопрос("Табличные части документа будут очищены! Продолжать?", РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли; 
	КонецЕсли; 
	
	СоздатьАктыНаСервере();

	Оповестить("Журналы загружены");
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДокНеПуст(Актирование) 
	Если Актирование.Акты.Количество() = 0 и 
		Актирование.Зарплата.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли; 
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ДатаСозданияЭСЧФПриИзменении(Элемент)
	УстановитьНачальныйНомерЭСЧФ();
КонецПроцедуры

	

#КонецОбласти
 


