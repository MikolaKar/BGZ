&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Договор = Параметры.Договор;
	
	Если Не ЗначениеЗаполнено(Договор) Тогда
		Сообщить("Печать информации возможна только из договора!");
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	ПараметрыКарточки = ПолучитьПараметрыКарточки(Договор);
	
	ЗаполнитьВидыПлатежей(ПараметрыКарточки);
	
    флОплатаГосПошлины = Истина;
    ЭтаФорма.Элементы.ПолучательГосПошлины.АвтоОтметкаНезаполненного = флОплатаГосПошлины;
    флОплатаГосРегистрация = Истина;
    ЭтаФорма.Элементы.ПолучательГосРегистрации.АвтоОтметкаНезаполненного = флОплатаГосРегистрация;
	ЭтаФорма.Элементы.ИмяПлательщика.Заголовок = ""+Параметры.Договор.Корреспондент.Наименование+", дог. № "+Параметры.Договор.РегистрационныйНомер+" от "+Формат(Параметры.Договор.ДатаРегистрации, "ДЛФ=D");
	НашаОрганизация = Константы.НашаОрганизация.Получить();
	//ЭтотОбъект.Заголовок = "Информация для оплаты договора юрлицом";
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыКарточки(Договор)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мЭтапыДоговоров.КарточкаОбъектаРабот КАК Карточка
		|ПОМЕСТИТЬ Этапы
		|ИЗ
		|	Справочник.мЭтапыДоговоров КАК мЭтапыДоговоров
		|ГДЕ
		|	мЭтапыДоговоров.Владелец = &Договор
		|	И НЕ мЭтапыДоговоров.ПометкаУдаления
		|	И мЭтапыДоговоров.ДатаИсключенИзДоговора=ДатаВремя(1,1,1,0,0,0)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	мКарточкиОбъектовРаботПараметрыОбъекта.Значение КАК Значение
		|ПОМЕСТИТЬ Ограничения
		|ИЗ
		|	Справочник.мКарточкиОбъектовРабот.ПараметрыОбъекта КАК мКарточкиОбъектовРаботПараметрыОбъекта
		|ГДЕ
		|	мКарточкиОбъектовРаботПараметрыОбъекта.Ссылка В
		|			(ВЫБРАТЬ
		|				Этапы.Карточка
		|			ИЗ
		|				Этапы КАК Этапы)
		|	И мКарточкиОбъектовРаботПараметрыОбъекта.ПараметрОбъекта = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ПараметрыОбъектов.НаличиеОграничений)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	мКарточкиОбъектовРаботПараметрыОбъекта.Значение КАК Значение
		|ПОМЕСТИТЬ Участки
		|ИЗ
		|	Справочник.мКарточкиОбъектовРабот.ПараметрыОбъекта КАК мКарточкиОбъектовРаботПараметрыОбъекта
		|ГДЕ
		|	мКарточкиОбъектовРаботПараметрыОбъекта.Ссылка В
		|			(ВЫБРАТЬ
		|				Этапы.Карточка
		|			ИЗ
		|				Этапы КАК Этапы)
		|	И мКарточкиОбъектовРаботПараметрыОбъекта.ПараметрОбъекта = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ПараметрыОбъектов.КоличествоУчастковДляВнесенияВЗИС)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ Первые 1
		|	ЕстьNULL(Ограничения.Значение, 0) КАК Ограничения,
		|	ЕстьNULL(Участки.Значение, 0) КАК Участки
		|ИЗ
		|	Ограничения КАК Ограничения,
		|	Участки КАК Участки";
	
	Запрос.УстановитьПараметр("Договор", Договор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Рекв = Новый Структура("Ограничения, Участки", 0, 0); 
	Пока Выборка.Следующий() Цикл
		Рекв.Вставить("Ограничения", Выборка.Ограничения);	
		Рекв.Вставить("Участки", Выборка.Участки);	
	КонецЦикла;
	Возврат Рекв;
КонецФункции

&НаСервере
Процедура ЗаполнитьВидыПлатежей(ПараметрыКарточки)
	
	Госпошлина = Справочники.мВидыПлатежейГосРегистрации.ГоспошлинаЮрЛица;
	Регистрация1 = Справочники.мВидыПлатежейГосРегистрации.РегистрацияОдногоОбъектаЮрЛица;
	Регистрация2 = Справочники.мВидыПлатежейГосРегистрации.РегистрацияКаждогоПоследующегоОбъектаЮрЛица;
	План = Справочники.мВидыПлатежейГосРегистрации.СоставлениеВыдачаПланаЗемельногоУчастка;
	ОграниченияБольше5 = Справочники.мВидыПлатежейГосРегистрации.РегистрацияОграниченийБолее5;
	ОграниченияДо6 = Справочники.мВидыПлатежейГосРегистрации.РегистрацияОграниченийДо6;
	
	МассивПлатежей = Новый Массив;
	МассивПлатежей.Добавить(Госпошлина);	
	МассивПлатежей.Добавить(Регистрация1);	
	МассивПлатежей.Добавить(Регистрация2);	
	МассивПлатежей.Добавить(План);	
	МассивПлатежей.Добавить(ОграниченияБольше5);	
	МассивПлатежей.Добавить(ОграниченияДо6);	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мВидыПлатежейГосРегистрации.Ссылка КАК ВидПлатежа,
		|	ЕстьNULL(СтавкиГосРегистрацииСрезПоследних.Ставка, 0) КАК Ставка,
		|	БазоваяВеличинаСрезПоследних.Ставка КАК БазоваяВеличина,
		|	мВидыПлатежейГосРегистрации.ПолноеНаименование КАК НаименованиеПлатежа
		|ИЗ
		|	РегистрСведений.БазоваяВеличина.СрезПоследних(&ТекДата, ) КАК БазоваяВеличинаСрезПоследних,
		|	Справочник.мВидыПлатежейГосРегистрации КАК мВидыПлатежейГосРегистрации
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиГосРегистрации.СрезПоследних(&ТекДата, ВидПлатежа В (&МассивПлатежей)) КАК СтавкиГосРегистрацииСрезПоследних
		|		ПО (СтавкиГосРегистрацииСрезПоследних.ВидПлатежа = мВидыПлатежейГосРегистрации.Ссылка)";

	Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
	Запрос.УстановитьПараметр("МассивПлатежей", МассивПлатежей);

	Результат = Запрос.Выполнить().Выгрузить();

	// Заполнение ВидыПлатежейГосПошлины
	ВидыПлатежейГосПошлины.Очистить();
	ДобавитьСтрокуТаблицы("Госпошлина", Госпошлина, Результат, 0);
	
	// Заполнение ВидыПлатежейГосРегистрации
	ВидыПлатежейГосРегистрации.Очистить();
	ДобавитьСтрокуТаблицы("ГосРег", Регистрация1, Результат, 1);
	
	Больше1 = ПараметрыКарточки.Участки - 1;
	Если Больше1 > 0 Тогда
		ДобавитьСтрокуТаблицы("ГосРег", Регистрация2, Результат, Больше1);
	КонецЕсли; 
	
	//ДобавитьСтрокуТаблицы("ГосРег", План, Результат, ПараметрыКарточки.Участки);
	ДобавитьСтрокуТаблицы("ГосРег", План, Результат, 1);
	
	Если ПараметрыКарточки.Ограничения > 0 Тогда
		Если ПараметрыКарточки.Участки > 5 Тогда
			ДобавитьСтрокуТаблицы("ГосРег", ОграниченияБольше5, Результат, 1);
		Иначе
			ДобавитьСтрокуТаблицы("ГосРег", ОграниченияДо6, Результат, 1);
		КонецЕсли; 	
	КонецЕсли; 
КонецПроцедуры // ЗаполнитьВидыПлатежейГосПошлины()

&НаСервере
Процедура ДобавитьСтрокуТаблицы(ВидТабл, ВидПлатежа, Результат, Количество)
	Если ВидТабл = "Госпошлина" Тогда
		Отбор = Новый Структура("ВидПлатежа", ВидПлатежа); 
		ИскСтроки = Результат.НайтиСтроки(Отбор);
		Если ИскСтроки.Количество() > 0 Тогда
			НовСтрока = ВидыПлатежейГосПошлины.Добавить();
			НовСтрока.Пометка = Истина;
			НовСтрока.ВидПлатежа = ВидПлатежа;
			НовСтрока.НаименованиеПлатежа = ИскСтроки[0].НаименованиеПлатежа;
			НовСтрока.Сумма = ИскСтроки[0].Ставка * ИскСтроки[0].БазоваяВеличина;
		КонецЕсли; 
	Иначе
		Отбор = Новый Структура("ВидПлатежа", ВидПлатежа); 
		ИскСтроки = Результат.НайтиСтроки(Отбор);
		Если ИскСтроки.Количество() > 0 Тогда
			НовСтрока = ВидыПлатежейГосРегистрации.Добавить();
			НовСтрока.Пометка = Истина;
			НовСтрока.ВидПлатежа = ВидПлатежа;
			НовСтрока.НаименованиеПлатежа = ИскСтроки[0].НаименованиеПлатежа;
			НовСтрока.Цена = ИскСтроки[0].Ставка * ИскСтроки[0].БазоваяВеличина;
			НовСтрока.Количество = Количество;
			НовСтрока.Сумма = НовСтрока.Цена * НовСтрока.Количество;
		КонецЕсли; 
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
Процедура Печать(Команда)
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
    КонецЕсли;
    
	Источник = ЭтаФорма;
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ПолучательГосПошлины", Источник.ПолучательГосПошлины);
	ПараметрыПечати.Вставить("ПолучательГосРегистрации", Источник.ПолучательГосРегистрации);
	ПараметрыПечати.Вставить("флОплатаГосПошлины", Источник.флОплатаГосПошлины);
	ПараметрыПечати.Вставить("флОплатаГосРегистрация", Источник.флОплатаГосРегистрация);
	ПараметрыПечати.Вставить("НазначениеПлатежаГоспошлина", Источник.НазначениеПлатежаГоспошлина);
	ПараметрыПечати.Вставить("НазначениеПлатежаГосрегистрация", Источник.НазначениеПлатежаГосрегистрация);
	
	НомерПП = 0;
	Для каждого Платеж Из Источник.ВидыПлатежейГосРегистрации Цикл
		Если Платеж.Пометка Тогда
			НомерПП = НомерПП+1;
			СтруктураПлатежей = Новый Структура("НаименованиеПлатежа, Цена, Количество, Сумма");//, Пометка");
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
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.мИнформацияДляОплатыДоговора", "ДляОплатыДоговораЮрЛица", Договор, Источник, ПараметрыПечати);
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
    
КонецПроцедуры
