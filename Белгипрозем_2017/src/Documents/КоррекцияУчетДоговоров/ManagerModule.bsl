// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст ="ВЫБРАТЬ
	              |	ДанныеДокумента.Дата КАК Период,
	              |	ДанныеДокумента.Ссылка КАК Ссылка,
	              |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	              |	ДанныеДокумента.Договор КАК Договор,
	              |	ДанныеДокумента.ЭтапДоговора КАК ЭтапДоговора,
	              |	ДанныеДокумента.СтавкаНДС КАК СтавкаНДС,
	              |	ДанныеДокумента.ОсвобождениеОтНДС КАК ОсвобождениеОтНДС,
	              |	"""" КАК НомерДокумента,
	              |	ДанныеДокумента.НДС КАК НДС,
	              |	ДанныеДокумента.Сумма КАК Сумма
	              |ИЗ
	              |	Документ.КоррекцияУчетДоговоров КАК ДанныеДокумента
	              |ГДЕ
	              |	ДанныеДокумента.Ссылка = &Ссылка";
	Результат = Запрос.Выполнить();
	
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаУчетДоговоров", Результат.Выгрузить());
		
КонецПроцедуры // ИнициализироватьДанныеДокумента()
