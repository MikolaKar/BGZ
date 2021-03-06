// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("ВидДокумента", Справочники.ВидыВнутреннихДокументов.АктВыполненныхРабот);
	Запрос.УстановитьПараметр("ВидДоговораГКИ", Справочники.ВидыВнутреннихДокументов.ДоговорГКИ);
	Запрос.Текст ="ВЫБРАТЬ
	              |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	              |	ВедомостьАктированияАкты.Договор.Корреспондент КАК Корреспондент,
	              |	ВедомостьАктированияАкты.Договор КАК Договор,
	              |	ВедомостьАктированияАкты.Договор.ВидДокумента КАК ВидДоговора,
	              |	ВедомостьАктированияАкты.ЭтапДоговора КАК ЭтапДоговора,
	              |	ВедомостьАктированияАкты.ЭтапДоговора.Подразделение КАК Подразделение,
	              |	ВедомостьАктированияАкты.ЭтапДоговора.СтавкаНДС КАК СтавкаНДС,
	              |	ВедомостьАктированияАкты.ЭтапДоговора.ОсвобождениеОтНДС КАК ОсвобождениеОтНДС,
	              |	ВедомостьАктированияАкты.ДатаАкта КАК Период,
	              |	ВедомостьАктированияАкты.ДатаАкта КАК ДатаДокумента,
	              |	ВедомостьАктированияАкты.Сумма КАК Сумма,
	              |	ВедомостьАктированияАкты.НДС КАК НДС,
	              |	ВедомостьАктированияАкты.НомерАкта КАК НомерДокумента
	              |ИЗ
	              |	Документ.мАктирование.Акты КАК ВедомостьАктированияАкты
	              |ГДЕ
	              |	ВедомостьАктированияАкты.Ссылка = &Ссылка
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	ЗНАЧЕНИЕ(Справочник.мВидыДатДоговоров.ДатаВыполнения) КАК ВидДатыДоговора,
	              |	ВедомостьАктированияАкты.Ссылка КАК Основание,
	              |	ВедомостьАктированияАкты.ЭтапДоговора КАК ЭтапДоговора,
	              |	ВедомостьАктированияАкты.ДатаАкта КАК Период,
	              |	ВедомостьАктированияАкты.Акт КАК Акт,
	              |	ВедомостьАктированияАкты.Акт.ДатаРегистрации КАК ДатаРегистрацииАкта,
	              |	ВедомостьАктированияАкты.ДатаАкта КАК Дата,
	              |	ВЫБОР
	              |		КОГДА ВедомостьАктированияАкты.Договор.Корреспондент.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)
	              |			ТОГДА ИСТИНА
	              |		ИНАЧЕ ЛОЖЬ
	              |	КОНЕЦ КАК ЭтоФизЛицо,
	              |	мУсловияДоговоровСрезПоследних.УчетДатыВыполненияПредыдущегоЭтапа,
	              |	ВедомостьАктированияАкты.ЭтапДоговора.НомерЭтапа КАК НомерЭтапа,
	              |	ВедомостьАктированияАкты.ЭтапДоговора.Владелец КАК Договор
	              |ИЗ
	              |	Документ.мАктирование.Акты КАК ВедомостьАктированияАкты
	              |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.мУсловияДоговоров.СрезПоследних(
	              |				,
	              |				ЭтапДоговора В
	              |					(ВЫБРАТЬ
	              |						мАктированиеАкты.ЭтапДоговора
	              |					ИЗ
	              |						Документ.мАктирование.Акты КАК мАктированиеАкты
	              |					ГДЕ
	              |						мАктированиеАкты.Ссылка = &Ссылка)) КАК мУсловияДоговоровСрезПоследних
	              |		ПО ВедомостьАктированияАкты.ЭтапДоговора = мУсловияДоговоровСрезПоследних.ЭтапДоговора
	              |ГДЕ
	              |	ВедомостьАктированияАкты.Ссылка = &Ссылка
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	мАктированиеЗарплата.Исполнитель КАК Исполнитель,
	              |	мАктированиеАкты.ДатаАкта КАК ДатаАкта,
	              |	мАктированиеЗарплата.НомерАкта КАК НомерАкта,
	              |	мАктированиеЗарплата.Начислено КАК Начислено,
	              |	мАктированиеЗарплата.БазовоеНачисление КАК БазовоеНачисление,
	              |	МАКСИМУМ(мСведенияОСотрудниках.Период) КАК Период,
	              |	мАктированиеЗарплата.Подразделение КАК Подразделение,
	              |	мАктированиеЗарплата.ОбъектРабот КАК ОбъектРабот
	              |ПОМЕСТИТЬ Данные
	              |ИЗ
	              |	Документ.мАктирование.Зарплата КАК мАктированиеЗарплата
	              |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.мАктирование.Акты КАК мАктированиеАкты
	              |		ПО мАктированиеЗарплата.НомерАкта = мАктированиеАкты.НомерАкта
	              |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.мСведенияОСотрудниках КАК мСведенияОСотрудниках
	              |		ПО (мСведенияОСотрудниках.Период <= мАктированиеАкты.ДатаАкта)
	              |			И мАктированиеЗарплата.Исполнитель = мСведенияОСотрудниках.Пользователь
	              |ГДЕ
	              |	мАктированиеАкты.Ссылка = &Ссылка
	              |	И мАктированиеЗарплата.Ссылка = &Ссылка
	              |
	              |СГРУППИРОВАТЬ ПО
	              |	мАктированиеЗарплата.Исполнитель,
	              |	мАктированиеАкты.ДатаАкта,
	              |	мАктированиеЗарплата.Начислено,
	              |	мАктированиеЗарплата.БазовоеНачисление,
	              |	мАктированиеЗарплата.НомерАкта,
	              |	мАктированиеЗарплата.Подразделение,
	              |	мАктированиеЗарплата.ОбъектРабот
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	Данные.Исполнитель КАК Исполнитель,
	              |	Данные.НомерАкта КАК НомерАкта,
	              |	СУММА(Данные.Начислено) КАК Начислено,
	              |	СУММА(Данные.БазовоеНачисление) КАК БазовоеНачисление,
	              |	мСведенияОСотрудниках.Должность КАК Должность,
	              |	мСведенияОСотрудниках.Оклад КАК Оклад,
	              |	Данные.Подразделение КАК Подразделение,
	              |	Данные.ОбъектРабот КАК ОбъектРабот
	              |ПОМЕСТИТЬ Начисления
	              |ИЗ
	              |	Данные КАК Данные
	              |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.мСведенияОСотрудниках КАК мСведенияОСотрудниках
	              |		ПО Данные.Исполнитель = мСведенияОСотрудниках.Пользователь
	              |			И (мСведенияОСотрудниках.Период = Данные.Период)
	              |
	              |СГРУППИРОВАТЬ ПО
	              |	Данные.Исполнитель,
	              |	Данные.НомерАкта,
	              |	мСведенияОСотрудниках.Должность,
	              |	мСведенияОСотрудниках.Оклад,
	              |	Данные.Подразделение,
	              |	Данные.ОбъектРабот
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	              |	мАктированиеЗарплата.Исполнитель,
	              |	ЕСТЬNULL(Начисления.Начислено, 0) КАК Сумма,
	              |	ЕСТЬNULL(Начисления.БазовоеНачисление, 0) КАК БазовоеНачисление,
	              |	Начисления.Должность,
	              |	Начисления.Оклад,
	              |	Начисления.ОбъектРабот,
	              |	мАктированиеЗарплата.ОбъектРабот КАК ОбъектРабот,
	              |	мАктированиеЗарплата.ЭтапДоговора,
	              |	мАктированиеЗарплата.Подразделение КАК Подразделение,
	              |	мАктированиеЗарплата.Ссылка.Дата КАК Период,
	              |	мАктированиеЗарплата.КТУ,
	              |	мАктированиеЗарплата.Коэффициент
	              |ИЗ
	              |	Документ.мАктирование.Зарплата КАК мАктированиеЗарплата
	              |		ЛЕВОЕ СОЕДИНЕНИЕ Начисления КАК Начисления
	              |		ПО мАктированиеЗарплата.Исполнитель = Начисления.Исполнитель
	              |			И мАктированиеЗарплата.НомерАкта = Начисления.НомерАкта
	              |			И мАктированиеЗарплата.ОбъектРабот = Начисления.ОбъектРабот
	              |ГДЕ
	              |	мАктированиеЗарплата.Ссылка = &Ссылка
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ РАЗЛИЧНЫЕ
	              |	мАктированиеЗарплата.ЭтапДоговора КАК ЭтапДоговора,
	              |	мАктированиеЗарплата.Исполнитель,
	              |	мАктированиеЗарплата.КТУ,
	              |	мАктированиеЗарплата.ОбъектРабот КАК ОбъектРабот,
	              |	мАктированиеЗарплата.ЭтапДоговора.Владелец.ВидДокумента КАК ВидДоговора,
	              |	мАктированиеЗарплата.НомерСтроки КАК НомерСтроки
	              |ИЗ
	              |	Документ.мАктирование.Зарплата КАК мАктированиеЗарплата
	              |ГДЕ
	              |	мАктированиеЗарплата.Ссылка = &Ссылка
	              |
	              |УПОРЯДОЧИТЬ ПО
	              |	НомерСтроки
	              |ИТОГИ ПО
	              |	ЭтапДоговора
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ РАЗЛИЧНЫЕ
	              |	мАктированиеЗарплата.ЭтапДоговора.Владелец КАК Договор,
	              |	мАктированиеЗарплата.Исполнитель,
	              |	мАктированиеЗарплата.НомерСтроки КАК НомерСтроки
	              |ИЗ
	              |	Документ.мАктирование.Зарплата КАК мАктированиеЗарплата
	              |ГДЕ
	              |	мАктированиеЗарплата.Ссылка = &Ссылка
	              |
	              |УПОРЯДОЧИТЬ ПО
	              |	НомерСтроки
	              |ИТОГИ ПО
	              |	Договор
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	мАктированиеАкты.Ссылка.Дата КАК Период,
	              |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	              |	мЭтапыДоговоровНоменклатура.НоменклатураПроизводства,
	              |	мЭтапыДоговоровНоменклатура.Калькуляция,
	              |	мЭтапыДоговоровНоменклатура.Количество,
	              |	мАктированиеАкты.ЭтапДоговора
	              |ИЗ
	              |	Документ.мАктирование.Акты КАК мАктированиеАкты
	              |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.мЭтапыДоговоров.Номенклатура КАК мЭтапыДоговоровНоменклатура
	              |		ПО мАктированиеАкты.ЭтапДоговора = мЭтапыДоговоровНоменклатура.Ссылка
	              |ГДЕ
	              |	мАктированиеАкты.Ссылка = &Ссылка
	              |	И НЕ мЭтапыДоговоровНоменклатура.Ссылка.ПометкаУдаления
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	мЭтапыДоговоровИсполнители.Исполнитель,
	              |	мЭтапыДоговоровИсполнители.ОбъектРабот КАК ОбъектРабот,
	              |	мЭтапыДоговоровИсполнители.Ссылка КАК ЭтапДоговора
	              |ИЗ
	              |	Документ.мАктирование.Акты КАК мАктированиеАкты
	              |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.мЭтапыДоговоров.Исполнители КАК мЭтапыДоговоровИсполнители
	              |		ПО мАктированиеАкты.ЭтапДоговора = мЭтапыДоговоровИсполнители.Ссылка
	              |ГДЕ
	              |	мАктированиеАкты.Ссылка = &Ссылка
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	мАктированиеАкты.ЭтапДоговора
	              |ПОМЕСТИТЬ ЭтапыГКИ
	              |ИЗ
	              |	Документ.мАктирование.Акты КАК мАктированиеАкты
	              |ГДЕ
	              |	мАктированиеАкты.Ссылка = &Ссылка
	              |	И мАктированиеАкты.Договор.ВидДокумента = &ВидДоговораГКИ
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	мЭтапыДоговоровОбъектыРабот.ОбъектРабот,
	              |	мЭтапыДоговоровОбъектыРабот.ВидРабот,
	              |	мЭтапыДоговоровОбъектыРабот.Смета,
	              |	мЭтапыДоговоровОбъектыРабот.Ссылка.Владелец КАК Договор
	              |ПОМЕСТИТЬ Сметы
	              |ИЗ
	              |	Справочник.мЭтапыДоговоров.ОбъектыРабот КАК мЭтапыДоговоровОбъектыРабот
	              |ГДЕ
	              |	мЭтапыДоговоровОбъектыРабот.Ссылка В
	              |			(ВЫБРАТЬ
	              |				ЭтапыГКИ.ЭтапДоговора
	              |			ИЗ
	              |				ЭтапыГКИ КАК ЭтапыГКИ)
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	              |	Сметы.ОбъектРабот КАК ОбъектРабот,
	              |	Сметы.ВидРабот КАК ВидРабот,
	              |	Сметы.Договор КАК Договор,
	              |	Сметы.Смета КАК Смета,
	              |	мСметыОбъемРабот.СтадияРабот КАК СтадияРабот,
	              |	СУММА(мСметыОбъемРабот.Стоимость) КАК Сумма,
	              |	МАКСИМУМ(Сметы.Смета.НДС) КАК НДС,
	              |	мАктирование.Дата КАК Период
	              |ИЗ
	              |	Сметы КАК Сметы
	              |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.мСметы.ОбъемРабот КАК мСметыОбъемРабот
	              |		ПО Сметы.Смета = мСметыОбъемРабот.Ссылка,
	              |	Документ.мАктирование КАК мАктирование
	              |ГДЕ
	              |	мСметыОбъемРабот.Стоимость > 0
	              |	И мАктирование.Ссылка = &Ссылка
	              |
	              |СГРУППИРОВАТЬ ПО
	              |	Сметы.ОбъектРабот,
	              |	Сметы.ВидРабот,
	              |	Сметы.Договор,
	              |	Сметы.Смета,
	              |	мСметыОбъемРабот.СтадияРабот,
	              |	мАктирование.Дата
	              |ИТОГИ
	              |	МАКСИМУМ(ВидРабот),
	              |	МАКСИМУМ(Договор),
	              |	МАКСИМУМ(Смета),
	              |	МАКСИМУМ(СтадияРабот),
	              |	СУММА(Сумма),
	              |	МАКСИМУМ(НДС),
	              |	МАКСИМУМ(Период)
	              |ПО
	              |	ОбъектРабот";
				  
	Результат = Запрос.ВыполнитьПакет();
  
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаРасчетыСПокупателями", Результат[0].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаУчетДоговоров", Результат[0].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаДатыДоговоров", Результат[1].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаНачислениеЗП", Результат[4].Выгрузить());
	ТаблицыДляДвижений.Вставить("ВыборкаИсполнителей", Результат[5]);
	ТаблицыДляДвижений.Вставить("ВыборкаИсполнителейПоДоговорам", Результат[6]);
	ТаблицыДляДвижений.Вставить("ТаблицаНоменклатураПроизводства", Результат[7].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаИсполнителейЭтапов", Результат[8].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаСмет", Результат[11].Выгрузить());
		
КонецПроцедуры 

