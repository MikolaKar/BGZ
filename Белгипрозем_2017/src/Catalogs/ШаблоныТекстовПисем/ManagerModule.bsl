// Возвращает текст, сформированный из указанного шаблона
Функция ПолучитьТекстШаблона(ШаблонСсылка) Экспорт
	
	ТекстШаблона = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ШаблонСсылка, "Шаблон");
	
	// Дата
	ТекущаяДата = ТекущаяДатаСеанса();
	ТекстШаблона = СтрЗаменить(ТекстШаблона, "[День]", Формат(ТекущаяДата, "ДФ=дд"));
	ТекстШаблона = СтрЗаменить(ТекстШаблона, "[Месяц]", Формат(ТекущаяДата, "ДФ=ММ"));
	ТекстШаблона = СтрЗаменить(ТекстШаблона, "[Год]", Формат(ТекущаяДата, "ДФ=гггг"));
	
	// Время
	ТекстШаблона = СтрЗаменить(ТекстШаблона, "[Час]", Формат(ТекущаяДата, "ДФ=ЧЧ"));
	ТекстШаблона = СтрЗаменить(ТекстШаблона, "[Минута]", Формат(ТекущаяДата, "ДФ=мм"));
	
	Возврат ТекстШаблона;
	
КонецФункции