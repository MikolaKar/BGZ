
&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасчетыСПокупателямиОстатки.Корреспондент,
		|	РасчетыСПокупателямиОстатки.Договор,
		|	РасчетыСПокупателямиОстатки.ЭтапДоговора,
		|	РасчетыСПокупателямиОстатки.СуммаОстаток КАК СуммаДо,
		|	ВЫРАЗИТЬ(РасчетыСПокупателямиОстатки.СуммаОстаток / 10000 КАК ЧИСЛО(19, 2)) КАК СуммаПосле
        //|ПОМЕСТИТЬ ОстаткиДо
		|ИЗ
		|	РегистрНакопления.РасчетыСПокупателями.Остатки(&ДатаДок, ) КАК РасчетыСПокупателямиОстатки
		|ГДЕ
		|	РасчетыСПокупателямиОстатки.СуммаОстаток <> 0";
        //|;
        //|
        //|////////////////////////////////////////////////////////////////////////////////
        //|ВЫБРАТЬ
        //|	РасчетыСПокупателямиОстатки.Корреспондент,
        //|	РасчетыСПокупателямиОстатки.Договор,
        //|	РасчетыСПокупателямиОстатки.ЭтапДоговора,
        //|ПОМЕСТИТЬ ОстаткиПосле
        //|ИЗ
        //|	РегистрНакопления.РасчетыСПокупателями.Остатки(&ДатаДок2, ) КАК РасчетыСПокупателямиОстатки
        //|ГДЕ
        //|	РасчетыСПокупателямиОстатки.СуммаОстаток <> 0
        //|;
        //|
        //|////////////////////////////////////////////////////////////////////////////////
        //|ВЫБРАТЬ
        //|	ОстаткиДо.Корреспондент,
        //|	ОстаткиДо.Договор,
        //|	ОстаткиДо.ЭтапДоговора,
        //|	ОстаткиДо.СуммаДо,
        //|	ОстаткиПосле.СуммаПосле
        //|ИЗ
        //|	ОстаткиДо КАК ОстаткиДо
        //|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиПосле КАК ОстаткиПосле
        //|		ПО ОстаткиДо.ЭтапДоговора = ОстаткиПосле.ЭтапДоговора
        //|ГДЕ
        //|	(ВЫРАЗИТЬ(ОстаткиДо.СуммаДо / 10000 КАК ЧИСЛО(19, 2))) <> (ВЫРАЗИТЬ(ОстаткиПосле.СуммаПосле КАК ЧИСЛО(19, 2)))";
	
	Запрос.УстановитьПараметр("ДатаДок", НачалоДня(Объект.Дата));
    //Запрос.УстановитьПараметр("ДатаДок2", КонецДня(Объект.Дата)+1);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Объект.РасчетыСПокупателями.Загрузить(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Функция ЗаполнитьВедомостьНаСервере() 
	ТабДок = Новый ТабличныйДокумент;
	
	ДокОбъект = РеквизитФормыВЗначение("Объект");
	Макет = ДокОбъект.ПолучитьМакет("ВедомостьПересчета");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ТабДок.Вывести(ОбластьЗаголовок);
	
	ТабДок.Вывести(ОбластьШапка);
	
	НомерПП = 0;
	ИтогДоД	= 0;
	ИтогПослеРасчД	= 0;
	ИтогПослеФактД	= 0;
	ИтогРазницаД	= 0;
	ИтогДоК	= 0;
	ИтогПослеРасчК	= 0;
	ИтогПослеФактК	= 0;
	ИтогРазницаК	= 0;
	
	Для каждого стр из Объект.РасчетыСПокупателями Цикл
		НомерПП = НомерПП+1;
		ДоД	= 0;
		ПослеРасчД	= 0;
		ПослеФактД	= 0;
		РазницаД	= 0;
		ДоК	= 0;
		ПослеРасчК	= 0;
		ПослеФактК	= 0;
		РазницаК	= 0;
		ОбластьСтрока.Параметры.НомерПП = НомерПП;
		ОбластьСтрока.Параметры.Контрагент = Стр.Корреспондент;
		ОбластьСтрока.Параметры.Договор = Стр.Договор.РегистрационныйНомер;
		ОбластьСтрока.Параметры.Этап = Стр.ЭтапДоговора.НомерЭтапа;
		Если Стр.СуммаДо > 0 Тогда
			ДоК = Стр.СуммаДо;
			ПослеФактК = Стр.СуммаПосле;
			ПослеРасчК = Окр(Стр.СуммаДо/10000, 2);
			РазницаК = Стр.СуммаПосле - Окр(Стр.СуммаДо/10000, 2);
		Иначе
			ДоД = -Стр.СуммаДо;
			ПослеФактД = -Стр.СуммаПосле;
			ПослеРасчД = -Окр(Стр.СуммаДо/10000, 2);
			РазницаД = -(Стр.СуммаПосле - Окр(Стр.СуммаДо/10000, 2));
		КонецЕсли; 
		ОбластьСтрока.Параметры.ДоД	= ДоД;
		ОбластьСтрока.Параметры.ПослеРасчД	= ПослеРасчД;
		ОбластьСтрока.Параметры.ПослеФактД	= ПослеФактД;
		ОбластьСтрока.Параметры.РазницаД	= РазницаД;
		ОбластьСтрока.Параметры.ДоК	= ДоК;
		ОбластьСтрока.Параметры.ПослеРасчК	= ПослеРасчК;
		ОбластьСтрока.Параметры.ПослеФактК	= ПослеФактК;
		ОбластьСтрока.Параметры.РазницаК	= РазницаК;
		ТабДок.Вывести(ОбластьСтрока);
		
		ИтогДоД	= ИтогДоД + ДоД;
		ИтогПослеРасчД	= ИтогПослеРасчД + ПослеРасчД;
		ИтогПослеФактД	= ИтогПослеФактД + ПослеФактД;
		ИтогРазницаД	= ИтогРазницаД + РазницаД;
		ИтогДоК	= ИтогДоК + ДоК;
		ИтогПослеРасчК	= ИтогПослеРасчК + ПослеРасчК;
		ИтогПослеФактК	= ИтогПослеФактК + ПослеФактК;
		ИтогРазницаК	= ИтогРазницаК + РазницаК;
		
	КонецЦикла;
	
	ОбластьПодвал.Параметры.ИтогДоД	= ИтогДоД;
	ОбластьПодвал.Параметры.ИтогПослеРасчД	= ИтогПослеРасчД;
	ОбластьПодвал.Параметры.ИтогПослеФактД	= ИтогПослеФактД;
	ОбластьПодвал.Параметры.ИтогРазницаД	= ИтогРазницаД;
	ОбластьПодвал.Параметры.ИтогДоК	= ИтогДоК;
	ОбластьПодвал.Параметры.ИтогПослеРасчК	= ИтогПослеРасчК;
	ОбластьПодвал.Параметры.ИтогПослеФактК	= ИтогПослеФактК;
	ОбластьПодвал.Параметры.ИтогРазницаК	= ИтогРазницаК;
	
	ТабДок.Вывести(ОбластьПодвал);
	
	Возврат ТабДок;
КонецФункции
 
&НаКлиенте
Процедура ПечатьВедомости(Команда)
	ТабДок = ЗаполнитьВедомостьНаСервере();
	
	ТабДок.Автомасштаб = Истина;
	ТабДок.Показать();
КонецПроцедуры
