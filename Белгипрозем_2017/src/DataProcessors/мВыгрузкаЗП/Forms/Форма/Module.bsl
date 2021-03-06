
&НаКлиенте
Процедура ФайлВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	
	ДиалогВыбораФайла.Заголовок = "Выберите Файл";
	ДиалогВыбораФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'DBF'; en = 'DBF'") + "(*.dbf)|*.dbf";
	ДиалогВыбораФайла.Фильтр = Фильтр;

	Если ДиалогВыбораФайла.Выбрать() Тогда
		ФайлВыгрузки = ДиалогВыбораФайла.ПолноеИмяФайла;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ВыгрузитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	&НачПер КАК MES,
		|	НачисленаЗПОбороты.СуммаОборот КАК SUM,
		|	НачисленаЗПОбороты.ЧасыОборот КАК CHAS,
		|	НачисленаЗПОбороты.Исполнитель.ТабельныйНомер КАК KOD,
		|	НачисленаЗПОбороты.Исполнитель.Наименование КАК NAME,
		|	НачисленаЗПОбороты.Подразделение.Наименование КАК NAMEPD,
		|	НачисленаЗПОбороты.Подразделение.Код КАК KODPD,
		|	НачисленаЗПОбороты.ВидНачисления.Код КАК KODVR,
		|	НачисленаЗПОбороты.ВидНачисления.Наименование КАК NAMEVR,
		|	НачисленаЗПОбороты.ВидДеятельности.Код КАК KODVD,
		|	НачисленаЗПОбороты.ВидДеятельности.Наименование КАК NAMEVD,
		|	СведенияОПользователях.Должность.Наименование КАК NAMEDOLG
		|ИЗ
		|	РегистрНакопления.НачисленаЗП.Обороты(&НачПер, &КонПер, Период, Подразделение = &Подразделение) КАК НачисленаЗПОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
		|		ПО НачисленаЗПОбороты.Исполнитель = СведенияОПользователях.Пользователь";
	
	Запрос.УстановитьПараметр("КонПер", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("НачПер", Период.ДатаНачала);
	Если ЗначениеЗаполнено(Подразделение) Тогда
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Подразделение = &Подразделение", "");	
	КонецЕсли; 
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	ЗначениеВДанныеФормы(Результат, ТЗ);
КонецПроцедуры

&НаКлиенте
Функция СоздатьФайлДБФ()
	НовыйФайл = Новый XBase;
	НовыйФайл.Кодировка = КодировкаXBase.ANSI;
	НовыйФайл.Поля.Добавить("MES","D");
	НовыйФайл.Поля.Добавить("SUM","N",15,2);
	НовыйФайл.Поля.Добавить("CHAS","N",10,2) ;
	НовыйФайл.Поля.Добавить("KOD","S",10) ;
	НовыйФайл.Поля.Добавить("NAME","S",150) ;
	НовыйФайл.Поля.Добавить("NAMEPD","S",150) ;
	НовыйФайл.Поля.Добавить("KODPD","S",10) ;
	НовыйФайл.Поля.Добавить("KODVR","S",10) ;
	НовыйФайл.Поля.Добавить("NAMEVR","S",150) ;
	НовыйФайл.Поля.Добавить("KODVD","S",10) ;
	НовыйФайл.Поля.Добавить("NAMEVD","S",150) ;
	НовыйФайл.Поля.Добавить("NAMEDOLG","S",150) ;
	
	НовыйФайл.СоздатьФайл(ФайлВыгрузки);
	Возврат НовыйФайл;
КонецФункции 

&НаКлиенте
Процедура Выгрузить(Команда)
	ВыгрузитьНаСервере();
	
	ФайлДБФ = СоздатьФайлДБФ();
	
	Для каждого Стр Из ТЗ Цикл
		ФайлДБФ.Добавить();	
		ЗаполнитьЗначенияСвойств(ФайлДБФ, Стр);
		ФайлДБФ.Записать();
	КонецЦикла; 
	
	Если ФайлДБФ.Открыта() Тогда
		ФайлДБФ.ЗакрытьФайл();	
	КонецЕсли; 
	ПоказатьОповещениеПользователя("Данные выгружены!"); 
КонецПроцедуры
