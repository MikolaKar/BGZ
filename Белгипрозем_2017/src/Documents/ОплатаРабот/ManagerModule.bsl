// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Установил", Пользователи.ТекущийПользователь());
	Запрос.Текст ="ВЫБРАТЬ
	|	ДанныеДокумента.Дата                            КАК Период,
	|	ДанныеДокумента.Ссылка                          КАК Ссылка,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)          КАК ВидДвижения,
	|	ДанныеДокумента.Корреспондент                   КАК Корреспондент,
	|	ДанныеДокумента.Договор                         КАК Договор,
	|	ДанныеДокумента.ЭтапДоговора            		КАК ЭтапДоговора,
	|	ДанныеДокумента.НомерПлатежногоДокумента        КАК НомерДокумента,
	|	ДанныеДокумента.Сумма 		КАК Сумма
	|ИЗ
	|	Документ.ОплатаРабот                          КАК ДанныеДокумента
	|ГДЕ
    |	ДанныеДокумента.Ссылка = &Ссылка
    |;
    // 1 ТаблицаДатыДоговоров
    |ВЫБРАТЬ
    |	ДанныеДокумента.Дата КАК Период,
    |	ДанныеДокумента.Договор.ДатаРегистрации КАК Дата,
    |	ДанныеДокумента.Ссылка КАК Ссылка,
    |	ДанныеДокумента.Корреспондент КАК Корреспондент,
    |	ДанныеДокумента.Договор КАК Договор,
    |	&Установил КАК Установил,
    |	ДанныеДокумента.ЭтапДоговора КАК ЭтапДоговора,
    |	ДанныеДокумента.Ссылка КАК Основание,
    |	ЗНАЧЕНИЕ(Справочник.мВидыДатДоговоров.ДатаОплаты) КАК ВидДатыДоговора
    |ИЗ
    |	Документ.ОплатаРабот КАК ДанныеДокумента
    |ГДЕ
    |	ДанныеДокумента.Ссылка = &Ссылка";
    Результат = Запрос.ВыполнитьПакет();
  
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаРасчетыСПокупателями", Результат[0].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаДатыДоговоров", Результат[1].Выгрузить());
		
КонецПроцедуры // ИнициализироватьДанныеДокумента()
