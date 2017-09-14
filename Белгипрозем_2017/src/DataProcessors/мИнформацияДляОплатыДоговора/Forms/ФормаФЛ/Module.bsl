&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Договор = Параметры.Договор;
	
	Этапы = мРаботаСДоговорами.ПолучитьСписокЭтаповДоговора(Договор);
	КоличествоЭкземпляров = 1; //По умолчанию
	Для каждого Элем Из Этапы Цикл
		КоличествоЭкземпляров = Макс(КоличествоЭкземпляров, Элем.Значение.КоличествоУчастков);
	КонецЦикла; 
	
	ЗаполнитьВидыПлатежейГосПошлины();
	ЗаполнитьмВидыПлатежейГосРегистрации();
	ЗаполнитьСуммаПлатежейГосРегистрацииОгр();
	флОплатаДоговора = Истина;
    флОплатаГосПошлины = Истина;
    ЭтаФорма.Элементы.ПолучательГосПошлины.АвтоОтметкаНезаполненного = флОплатаГосПошлины;
    флОплатаГосРегистрация = Истина;
    ЭтаФорма.Элементы.ПолучательГосРегистрации.АвтоОтметкаНезаполненного = флОплатаГосРегистрация;
	флОплатаГосРегистрацияОграничение = Истина;
    ЭтаФорма.Элементы.ПолучательГосРегистрацииОграничение.АвтоОтметкаНезаполненного = флОплатаГосРегистрацияОграничение;
	ЭтаФорма.Элементы.ИмяПлательщика.Заголовок = ""+Параметры.Договор.Корреспондент.Наименование+", дог. № "+Параметры.Договор.РегистрационныйНомер+" от "+Формат(Параметры.Договор.ДатаРегистрации, "ДЛФ=D");
	НашаОрганизация = Константы.НашаОрганизация.Получить();
	Если мРазное.ПолучитьГородБазы() = "Брест" Тогда
		//ЭтаФорма.Элементы.Ограничения.Видимость = Ложь;
		флОплатаГосРегистрацияОграничение = Ложь;
	КонецЕсли; 
	//ЭтотОбъект.Заголовок = "Информация для оплаты договора физлицом";
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыПлатежейГосПошлины()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мВидыПлатежейГосРегистрации.Ссылка,
		|	СтавкиГосРегистрацииСрезПоследних.Ставка,
		|	БазоваяВеличинаСрезПоследних.Ставка КАК БазоваяВеличина,
		|	БазоваяВеличинаСрезПоследних.Ставка КАК Сумма,
		|	мВидыПлатежейГосРегистрации.ПолноеНаименование КАК НаименованиеПлатежа
		|ИЗ
		|	РегистрСведений.БазоваяВеличина.СрезПоследних(&ТекДата, ) КАК БазоваяВеличинаСрезПоследних,
		|	Справочник.мВидыПлатежейГосРегистрации КАК мВидыПлатежейГосРегистрации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиГосРегистрации.СрезПоследних(&ТекДата, ) КАК СтавкиГосРегистрацииСрезПоследних
		|		ПО (СтавкиГосРегистрацииСрезПоследних.ВидПлатежа = мВидыПлатежейГосРегистрации.Ссылка)
		|ГДЕ
		|	мВидыПлатежейГосРегистрации.Ссылка = ЗНАЧЕНИЕ(Справочник.мВидыПлатежейГосРегистрации.Госпошлина)
		|	И НЕ мВидыПлатежейГосРегистрации.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	мВидыПлатежейГосРегистрации.Код";

	Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	ВидыПлатежейГосПошлины.Очистить();
	
	ПорядковыйНомер = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ПорядковыйНомер = ПорядковыйНомер + 1;
		НовСтрока = ВидыПлатежейГосПошлины.Добавить();
		НовСтрока.Пометка = Истина;
		НовСтрока.ВидПлатежа = ВыборкаДетальныеЗаписи.Ссылка;
		НовСтрока.НаименованиеПлатежа = ВыборкаДетальныеЗаписи.НаименованиеПлатежа;
		НовСтрока.Сумма = ВыборкаДетальныеЗаписи.Ставка * ВыборкаДетальныеЗаписи.БазоваяВеличина;
	КонецЦикла;

КонецПроцедуры // ЗаполнитьВидыПлатежейГосПошлины()

&НаСервере
Процедура ЗаполнитьмВидыПлатежейГосРегистрации()
	МассивСтавок = Новый Массив;
	МассивСтавок.Добавить(Справочники.мВидыПлатежейГосРегистрации.РегистрацияЗемУчастка);
	МассивСтавок.Добавить(Справочники.мВидыПлатежейГосРегистрации.РегистрацияИныхПрав);
	МассивСтавок.Добавить(Справочники.мВидыПлатежейГосРегистрации.РегистрацияЗемУчастка);
	МассивСтавок.Добавить(Справочники.мВидыПлатежейГосРегистрации.РегистрацияПраваНаЗемУчасток);
	Массивставок.Добавить(Справочники.мВидыПлатежейГосРегистрации.НайтиПоНаименованию("Изготовление земельно-кадастового плана"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мВидыПлатежейГосРегистрации.Ссылка,
		|	СтавкиГосРегистрацииСрезПоследних.Ставка,
		|	БазоваяВеличинаСрезПоследних.Ставка КАК БазоваяВеличина,
		|	БазоваяВеличинаСрезПоследних.Ставка КАК Сумма,
		|	мВидыПлатежейГосРегистрации.ПолноеНаименование КАК НаименованиеПлатежа
		|ИЗ
		|	РегистрСведений.БазоваяВеличина.СрезПоследних(&ТекДата, ) КАК БазоваяВеличинаСрезПоследних,
		|	Справочник.мВидыПлатежейГосРегистрации КАК мВидыПлатежейГосРегистрации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиГосРегистрации.СрезПоследних(&ТекДата, ) КАК СтавкиГосРегистрацииСрезПоследних
		|		ПО (СтавкиГосРегистрацииСрезПоследних.ВидПлатежа = мВидыПлатежейГосРегистрации.Ссылка)
		|ГДЕ
		|	мВидыПлатежейГосРегистрации.Ссылка В (&МассивСтавок)
		|	И НЕ мВидыПлатежейГосРегистрации.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	мВидыПлатежейГосРегистрации.Код";

	Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
	Запрос.УстановитьПараметр("МассивСтавок", МассивСтавок);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	ВидыПлатежейГосРегистрации.Очистить();
	
	ПорядковыйНомер = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ПорядковыйНомер = ПорядковыйНомер + 1;
		НовСтрока = ВидыПлатежейГосРегистрации.Добавить();
		НовСтрока.Пометка = Истина;
		НовСтрока.ВидПлатежа = ВыборкаДетальныеЗаписи.Ссылка;
		НовСтрока.Сумма = ВыборкаДетальныеЗаписи.Ставка * ВыборкаДетальныеЗаписи.БазоваяВеличина;
		НовСтрока.НаименованиеПлатежа = ВыборкаДетальныеЗаписи.НаименованиеПлатежа;
		НовСтрока.ПорядковыйНомер = ПорядковыйНомер;
	КонецЦикла;

КонецПроцедуры // ЗаполнитьмВидыПлатежейГосРегистрации()

&НаСервере
Процедура ЗаполнитьСуммаПлатежейГосРегистрацииОгр()
	МассивСтавок = Новый Массив;
	МассивСтавок.Добавить(Справочники.мВидыПлатежейГосРегистрации.РегистрацияОграничений);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мВидыПлатежейГосРегистрации.Ссылка,
		|	СтавкиГосРегистрацииСрезПоследних.Ставка,
		|	БазоваяВеличинаСрезПоследних.Ставка КАК БазоваяВеличина,
		|	БазоваяВеличинаСрезПоследних.Ставка КАК Сумма
		|ИЗ
		|	РегистрСведений.БазоваяВеличина.СрезПоследних(&ТекДата, ) КАК БазоваяВеличинаСрезПоследних,
		|	Справочник.мВидыПлатежейГосРегистрации КАК мВидыПлатежейГосРегистрации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиГосРегистрации.СрезПоследних(&ТекДата, ) КАК СтавкиГосРегистрацииСрезПоследних
		|		ПО (СтавкиГосРегистрацииСрезПоследних.ВидПлатежа = мВидыПлатежейГосРегистрации.Ссылка)
		|ГДЕ
		|	мВидыПлатежейГосРегистрации.Ссылка  В (&МассивСтавок)
		|
		|УПОРЯДОЧИТЬ ПО
		|	мВидыПлатежейГосРегистрации.Код";

	Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
	Запрос.УстановитьПараметр("МассивСтавок", МассивСтавок);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	ПорядковыйНомер = 0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СуммаОграничения = ВыборкаДетальныеЗаписи.Ставка * ВыборкаДетальныеЗаписи.БазоваяВеличина;
		//Если ВыборкаДетальныеЗаписи.Ссылка = Справочники.мВидыПлатежейГосРегистрации.РегистрацияОграничений1 Тогда
		//    Сумма1 = Сумма;
		//ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка = Справочники.мВидыПлатежейГосРегистрации.РегистрацияОграничений2 Тогда
		//    Сумма2 = Сумма;
		//ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка = Справочники.мВидыПлатежейГосРегистрации.РегистрацияОграничений3 Тогда
		//    Сумма3 = Сумма;
		//ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка = Справочники.мВидыПлатежейГосРегистрации.РегистрацияОграничений4 Тогда
		//    Сумма4 = Сумма;
		//ИначеЕсли ВыборкаДетальныеЗаписи.Ссылка = Справочники.мВидыПлатежейГосРегистрации.РегистрацияОграничений5 Тогда
		//    Сумма5 = Сумма;
		//КонецЕсли; 
	КонецЦикла;

КонецПроцедуры // ЗаполнитьСуммаПлатежейГосРегистрацииОгр()

&НаКлиенте
Процедура ПолучательГосРегистрацииПриИзменении(Элемент)
	Если НЕ флПолучательНашаОрганизация Тогда
	    ПолучательГосРегистрацииОграничение = ПолучательГосРегистрации;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура флПолучательНашаОрганизацияПриИзменении(Элемент)
	Если флПолучательНашаОрганизация Тогда
		ПолучательГосРегистрацииОграничение = НашаОрганизация; 
	Иначе	
	    ПолучательГосРегистрацииОграничение = ПолучательГосРегистрации;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура флОплатаГосПошлиныПриИзменении(Элемент)
   	Элементы.ПолучательГосПошлины.АвтоОтметкаНезаполненного = флОплатаГосПошлины;
КонецПроцедуры

&НаКлиенте
Процедура флОплатаГосРегистрацияПриИзменении(Элемент)
    Элементы.ПолучательГосРегистрации.АвтоОтметкаНезаполненного = флОплатаГосРегистрация;
КонецПроцедуры

&НаКлиенте
Процедура флОплатаГосРегистрацияОграничениеПриИзменении(Элемент)
    Элементы.ПолучательГосРегистрацииОграничение.АвтоОтметкаНезаполненного = флОплатаГосРегистрацияОграничение;
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
    КонецЕсли;
    
	Источник = ЭтаФорма;
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ПолучательГосПошлины", Источник.ПолучательГосПошлины);
	ПараметрыПечати.Вставить("ПолучательГосРегистрации", Источник.ПолучательГосРегистрации);
	ПараметрыПечати.Вставить("ПолучательГосРегистрацииОграничение", Источник.ПолучательГосРегистрацииОграничение);
	ПараметрыПечати.Вставить("флОплатаДоговора", Источник.флОплатаДоговора);
	ПараметрыПечати.Вставить("флОплатаГосПошлины", Источник.флОплатаГосПошлины);
	ПараметрыПечати.Вставить("флОплатаГосРегистрация", Источник.флОплатаГосРегистрация);
	ПараметрыПечати.Вставить("флОплатаГосРегистрацияОграничение", Источник.флОплатаГосРегистрацияОграничение);
	ПараметрыПечати.Вставить("СуммаОграничения", СуммаОграничения);
	ПараметрыПечати.Вставить("КоличествоЭкземпляров", КоличествоЭкземпляров);
	
	НомерПП = 0;
	Для каждого Платеж Из Источник.ВидыПлатежейГосРегистрации Цикл
		Если Платеж.Пометка Тогда
			НомерПП = НомерПП+1;
			СтруктураПлатежей = Новый Структура("НаименованиеПлатежа, Сумма");//, Пометка");
			ЗаполнитьЗначенияСвойств(СтруктураПлатежей, Платеж);
			ПараметрыПечати.Вставить("Платеж"+НомерПП, СтруктураПлатежей);
		КонецЕсли; 
	КонецЦикла; 
	ПараметрыПечати.Вставить("КоличествоПлатежейГосРегистрации", НомерПП);

	НомерПП = 0;
	Для каждого Платеж Из Источник.ВидыПлатежейГосПошлины Цикл
		Если Платеж.Пометка Тогда
			НомерПП = НомерПП+1;
			СтруктураПлатежей = Новый Структура("НаименованиеПлатежа, Сумма");//, Пометка");
			ЗаполнитьЗначенияСвойств(СтруктураПлатежей, Платеж);
			ПараметрыПечати.Вставить("ГосПошлинаПлатеж"+НомерПП, СтруктураПлатежей);
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	ПараметрыПечати.Вставить("КоличествоПлатежейГосПошлины", НомерПП);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.мИнформацияДляОплатыДоговора", "ДляОплатыДоговораФизЛица", Договор, Источник, ПараметрыПечати);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если флОплатаГосПошлины Тогда 
		ПроверяемыеРеквизиты.Добавить("ПолучательГосПошлины");
    Иначе
        УдаляемыйПроверяемыйРеквизит = ПроверяемыеРеквизиты.Найти("ПолучательГосПошлины");
        Если УдаляемыйПроверяемыйРеквизит <> Неопределено Тогда
            ПроверяемыеРеквизиты.Удалить(УдаляемыйПроверяемыйРеквизит);
        КонецЕсли; 
    КонецЕсли;
    
	Если флОплатаГосРегистрация Тогда 
		ПроверяемыеРеквизиты.Добавить("ПолучательГосРегистрации");
    Иначе
        УдаляемыйПроверяемыйРеквизит = ПроверяемыеРеквизиты.Найти("ПолучательГосРегистрации");
        Если УдаляемыйПроверяемыйРеквизит <> Неопределено Тогда
            ПроверяемыеРеквизиты.Удалить(УдаляемыйПроверяемыйРеквизит);
        КонецЕсли; 
    КонецЕсли;
    
	Если флОплатаГосРегистрацияОграничение Тогда 
		ПроверяемыеРеквизиты.Добавить("ПолучательГосРегистрацииОграничение");
    Иначе
        УдаляемыйПроверяемыйРеквизит = ПроверяемыеРеквизиты.Найти("ПолучательГосРегистрацииОграничение");
        Если УдаляемыйПроверяемыйРеквизит <> Неопределено Тогда
            ПроверяемыеРеквизиты.Удалить(УдаляемыйПроверяемыйРеквизит);
        КонецЕсли; 
	КонецЕсли;
КонецПроцедуры
