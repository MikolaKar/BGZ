
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого ПодчиненныйЭлементы Из Элементы.СтраницыСписков.ПодчиненныеЭлементы Цикл
		ПодчиненныйЭлементы.Видимость = Ложь;	
	КонецЦикла;
	
	Для Каждого ДопустимыйТип Из Параметры.ПравилоАвтокатегоризации.ТипыОбъектов Цикл
		ИндексЗначенияПеречисления = Перечисления.ТипыОбъектов.Индекс(ДопустимыйТип.ТипДанных);
		ИмяЗначенияПеречисления = Метаданные.Перечисления.ТипыОбъектов.ЗначенияПеречисления[ИндексЗначенияПеречисления].Имя;
		Элементы["Страница" + ИмяЗначенияПеречисления].Видимость = Истина;
	КонецЦикла;
	
	СписокВнутренниеДокументы.Параметры.УстановитьЗначениеПараметра("Правило", Параметры.ПравилоАвтокатегоризации);
	СписокВходящиеДокументы.Параметры.УстановитьЗначениеПараметра("Правило", Параметры.ПравилоАвтокатегоризации);
	СписокИсходящиеДокументы.Параметры.УстановитьЗначениеПараметра("Правило", Параметры.ПравилоАвтокатегоризации);
	СписокФайлы.Параметры.УстановитьЗначениеПараметра("Правило", Параметры.ПравилоАвтокатегоризации);
	СписокФайлы.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());	
	
	РаботаСФайламиВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(СписокФайлы);
	
	//подсчет количества объектов в списках
	Запрос = Новый Запрос;
	Для Каждого Страница Из Элементы.СтраницыСписков.ПодчиненныеЭлементы Цикл
		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Объекты.Ссылка
		|ИЗ
	 	|	Справочник." + СтрЗаменить(Страница.Имя, "Страница", "") + " КАК Объекты
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КатегорииОбъектов КАК КатегорииОбъектов
		|		ПО КатегорииОбъектов.ОбъектДанных = Объекты.Ссылка
		|		И КатегорииОбъектов.Автор = &Правило
		|	<СоединениеДляФайлов>";
		
		Если Найти(Страница.Имя, "Файлы") > 0 Тогда
			СоединениеДляФайлов = 
				"ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПапкиФайлов КАК СправочникПапкиФайлов
				|ПО Объекты.ВладелецФайла = СправочникПапкиФайлов.Ссылка";
		Иначе
			СоединениеДляФайлов = "";
		КонецЕсли;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "<СоединениеДляФайлов>", СоединениеДляФайлов); 	
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("Правило", Параметры.ПравилоАвтокатегоризации); 
		Количество = Запрос.Выполнить().Выбрать().Количество();
		
		Страница.Заголовок = Страница.Заголовок + ?(Количество > 0, " (" + Строка(Количество) + ")", "(0)")
	КонецЦикла;
		
КонецПроцедуры
