
&НаСервере
Функция ЗаполнитьФормуНаСервере()
	ТабДок = Новый ТабличныйДокумент;
	
	ДокОбъект = РеквизитФормыВЗначение("Объект");
	Макет = ДокОбъект.ПолучитьМакет("АктСписанияЗадолженности");
	
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ОбластьЗаголовок.Параметры.НазваниеДокумента = "АКТ за "+Формат(Объект.Дата, "ДФ='MМММ yyyy'")+"г.";
	
	Комиссия = мРазное.ПолучитьКомиссию(Объект.Комиссия);
	Если ЗначениеЗаполнено(Комиссия.НомерПриказа) Тогда
		ОбластьЗаголовок.Параметры.НомерПриказа = Комиссия.НомерПриказа;
	Иначе
		ОбластьЗаголовок.Параметры.НомерПриказа = "_____";
	КонецЕсли; 
	Если ЗначениеЗаполнено(Комиссия.ДатаПриказа) Тогда
		ОбластьЗаголовок.Параметры.ДатаПриказа = Формат(Комиссия.ДатаПриказа, "ДФ=dd.MM.yyyy");
	Иначе
		ОбластьЗаголовок.Параметры.ДатаПриказа = "______________"+Формат(Год(Объект.Дата), "ЧГ=0");
	КонецЕсли;
	Руководитель = Константы.РуководительПредприятия.Получить();
	ОбластьЗаголовок.Параметры.Руководитель = Руководитель;
	ОбластьЗаголовок.Параметры.ДолжностьРуководителя = РаботаСПользователями.ПолучитьДолжность(Руководитель);
	
	ТабДок.Вывести(ОбластьЗаголовок);
	
	ТабДок.Вывести(ОбластьШапка);
	
	НомерПП = 0;
	Для каждого Стр из Объект.Акты Цикл
		НомерПП = НомерПП + 1;
		ЗаполнитьЗначенияСвойств(ОбластьСтрока.Параметры, Стр);
		ОбластьСтрока.Параметры.НомерПП = НомерПП;
		ОбластьСтрока.Параметры.НомерДоговора = Стр.Договор.РегистрационныйНомер;
		
		ТабДок.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	СуммаВсего = Объект.Акты.Итог("Сумма");
	ОбластьПодвал.Параметры.СуммаВсего = СуммаВсего;
	ОбластьПодвал.Параметры.СуммаВсегоЧисламиИПрописью = М_ПравилаАвтозаполненияШаблонов.ПолучитьСуммуРублейЧисломИПрописью(СуммаВсего);
	ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, Комиссия);
	ТабДок.Вывести(ОбластьПодвал);
	
	Возврат ТабДок;
КонецФункции

&НаКлиенте
Процедура Печать(Команда)
	
	ТабДок = ЗаполнитьФормуНаСервере();
	
	ТабДок.Автомасштаб = Истина;
	ТабДок.Показать();
КонецПроцедуры
