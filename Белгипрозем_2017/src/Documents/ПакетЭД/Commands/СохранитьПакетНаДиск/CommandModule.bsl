
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДанныеПрисоединенногоФайла = ПолучитьДанныеПрисоединенногоФайлаПакетаНаСервере(ПараметрКоманды);
	СтатусНеизвестногоПакета   = ПредопределенноеЗначение("Перечисление.СтатусыПакетовЭД.Неизвестный");
	ОбменЧерезОператора        = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезОператораЭДОТакском");
	Если НЕ ДанныеПрисоединенногоФайла.СтатусПакета = СтатусНеизвестногоПакета
			И ДанныеПрисоединенногоФайла.СпособОбменаЭД = ОбменЧерезОператора
			И НЕ Найти(ДанныеПрисоединенногоФайла.ОтправительЭД, "2AL") > 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьДанныеФайла(ДанныеПрисоединенногоФайла.ПрисоединенныйФайл,
		ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор);
	
	ДанныеФайлаДляСохранения = Новый Структура;
	ДанныеФайлаДляСохранения.Вставить("Расширение", ДанныеФайла.Расширение);
	ДанныеФайлаДляСохранения.Вставить("ПолноеНаименование", ДанныеФайла.Наименование);
	ДанныеФайлаДляСохранения.Вставить("АдресХранилища", ДанныеФайла.СсылкаНаДвоичныеДанныеФайла);
	
	ЭлектронныеДокументыКлиент.СохранитьКак(ДанныеФайлаДляСохранения);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеПрисоединенногоФайлаПакетаНаСервере(ПакетЭД)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СообщенияЭДО.Ссылка,
		|	СообщенияЭДО.Документ.СпособОбменаЭД КАК СпособОбменаЭД,
		|	СообщенияЭДО.Документ.Отправитель КАК Отправитель,
		|	СообщенияЭДО.Документ.СтатусПакета КАК СтатусПакета
		|ИЗ
		|	Справочник.СообщенияЭДО КАК СообщенияЭДО
		|ГДЕ
		|	СообщенияЭДО.Документ = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", ПакетЭД);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	РезультатЗапроса.Следующий();
	
	СтруктураДанныхПакета = Новый Структура;
	СтруктураДанныхПакета.Вставить("ПрисоединенныйФайл", РезультатЗапроса.Ссылка);
	СтруктураДанныхПакета.Вставить("ОтправительЭД",      РезультатЗапроса.Отправитель);
	СтруктураДанныхПакета.Вставить("СтатусПакета",       РезультатЗапроса.СтатусПакета);
	СтруктураДанныхПакета.Вставить("СпособОбменаЭД",     РезультатЗапроса.СпособОбменаЭД);
	
	Возврат СтруктураДанныхПакета;
	
КонецФункции
