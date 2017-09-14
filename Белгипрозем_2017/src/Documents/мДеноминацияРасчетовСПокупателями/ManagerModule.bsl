// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст ="ВЫБРАТЬ
	              |	НАЧАЛОПЕРИОДА(ДанныеДокумента.Ссылка.Дата, ДЕНЬ) КАК Период,
	              |	ДанныеДокумента.Ссылка КАК Ссылка,
	              |	ВЫБОР
	              |		КОГДА ДанныеДокумента.СуммаДо > 0
	              |			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	              |		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	              |	КОНЕЦ КАК ВидДвижения,
	              |	ДанныеДокумента.Корреспондент КАК Корреспондент,
	              |	ДанныеДокумента.Договор КАК Договор,
	              |	ДанныеДокумента.ЭтапДоговора КАК ЭтапДоговора,
	              |	ВЫБОР
	              |		КОГДА ДанныеДокумента.СуммаДо > 0
	              |			ТОГДА -ДанныеДокумента.СуммаДо + ДанныеДокумента.СуммаПосле
	              |		ИНАЧЕ ДанныеДокумента.СуммаДо - ДанныеДокумента.СуммаПосле
	              |	КОНЕЦ КАК Сумма,
	              |	ДанныеДокумента.ЭтапДоговора.СтавкаНДС,
	              |	ДанныеДокумента.ЭтапДоговора.ОсвобождениеОтНДС,
	              |	ДанныеДокумента.ЭтапДоговора.СуммаНДС
	              |ИЗ
	              |	Документ.мДеноминацияРасчетовСПокупателями.РасчетыСПокупателями КАК ДанныеДокумента
	              |ГДЕ
	              |	ДанныеДокумента.Ссылка = &Ссылка";
	
    Результат = Запрос.Выполнить().Выгрузить();
  
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаРасчетыСПокупателями", Результат);
		
КонецПроцедуры // ИнициализироватьДанныеДокумента()
