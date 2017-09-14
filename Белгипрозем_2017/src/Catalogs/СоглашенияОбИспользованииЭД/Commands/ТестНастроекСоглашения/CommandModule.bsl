
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОчиститьСообщения();
	ПараметрыСоглашения = ПараметрыСоглашения(ПараметрКоманды);
		
	Если ПараметрыСоглашения.СтатусСоглашения <> ПредопределенноеЗначение("Перечисление.СтатусыСоглашенийЭД.Действует") Тогда
		ТекстСообщения = НСтр("ru = 'Обмен производится только по соглашениям со статусом Действует.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ПараметрКоманды, "Статус");
	КонецЕсли;
	
	Если ПараметрыСоглашения.СпособОбменаЭД = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезОператораЭДОТакском") Тогда
		
		// Блок проверки связи с оператором.
		Состояние(
				НСтр("ru = 'Тест настроек соглашения.'"),
				,
				НСтр("ru = 'Выполняется тестирование связи с оператором. Подождите...'"));
		
		ЗавершитьТесты = Ложь;
		
		// Блок проверки версии платформы.
		СистемнаяИнформация = Новый СистемнаяИнформация;
		
		РезультатТеста = НСтр("ru = 'Пройден успешно.'");
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.2.17.0") < 0 Тогда
			РезультатТеста = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьСообщениеОбОшибке("106");
			ЗавершитьТесты = Истина;
		КонецЕсли;
		ШаблонСообщения = НСтр("ru = 'Тест. Проверка версии платформы 1С.
                                |%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, РезультатТеста);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		// Критичная ошибка - дальше тесты не проводим.
		Если ЗавершитьТесты Тогда
			Возврат;
		КонецЕсли;
		
		// Блок проверки заполненности идентификатора организации.
		Если Не ЗначениеЗаполнено(ПараметрыСоглашения.ИдентификаторОрганизации) Тогда
			ШаблонСообщения = НСтр("ru = 'Тест не пройден.
                                    |%1'");
			РезультатТеста = ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСообщения("Поле", "Заполнение", "Идентификатор организации");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, РезультатТеста);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ПараметрКоманды, "Идентификатор организации");
			Возврат;
		КонецЕсли;
		
		Если ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьАвторизациюНаСервере() Тогда
			НаКлиенте = Ложь;
			НаСервере = Истина;
		Иначе
			НаКлиенте = Истина;
			НаСервере = Ложь;
		КонецЕсли;
		
		СоотвСертификатовИИхСтруктур = ПараметрыСоглашения.СертификатыПодписейОрганизации;
		ТестОчередногоСертификата(НаКлиенте, НаСервере, СоотвСертификатовИИхСтруктур);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестОчередногоСертификата(НаКлиенте, НаСервере, СоотвСертификатовИИхСтруктур) Экспорт
	
	Если СоотвСертификатовИИхСтруктур.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из СоотвСертификатовИИхСтруктур Цикл
		Сертификат = Элемент.Ключ;
		ПараметрыСертификата = Элемент.Значение;
		Прервать;
	КонецЦикла;
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ПараметрыСертификата", ПараметрыСертификата);
	ПараметрыВыполнения.Вставить("СоотвСертификатовИИхСтруктур", СоотвСертификатовИИхСтруктур);
	ПараметрыВыполнения.Вставить("НаКлиенте", НаКлиенте);
	ПараметрыВыполнения.Вставить("НаСервере", НаСервере);
	ПараметрыВыполнения.Вставить("Сертификат", Сертификат);
	
	Обработчик = Новый ОписаниеОповещения(
		"ТестОчередногоСертификатаЗавершение",
		ЭтотОбъект,
		ПараметрыВыполнения);
	
	ЭлектронныеДокументыСлужебныйКлиент.ТестНастроекСертификата(
		Сертификат,
		ПараметрыСертификата,
		НаКлиенте,
		НаСервере,,,,
		Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестОчередногоСертификатаЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	ПараметрыСертификата = ПараметрыВыполнения.ПараметрыСертификата;
	НаКлиенте = ПараметрыВыполнения.НаКлиенте;
	НаСервере = ПараметрыВыполнения.НаСервере;
	СоотвСертификатовИИхСтруктур = ПараметрыВыполнения.СоотвСертификатовИИхСтруктур;
	Сертификат = ПараметрыВыполнения.Сертификат;
	
	Если Результат.Успешно Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Тест. Проверка связи с сервисом Такском.'"));
		
		Если НаКлиенте Тогда
			ЭлектронныеДокументыСлужебныйКлиент.ТестСвязиСОператоромЭДО(ПараметрыСертификата);
		Иначе
			ЭлектронныеДокументыСлужебныйВызовСервера.ТестСвязиСОператоромЭДО(ПараметрыСертификата);
		КонецЕсли;
	КонецЕсли;
	
	СоотвСертификатовИИхСтруктур.Удалить(Сертификат);
	Если СоотвСертификатовИИхСтруктур.Количество() > 0 Тогда
		ТестОчередногоСертификата(НаКлиенте, НаСервере, СоотвСертификатовИИхСтруктур);
	КонецЕсли;
	
КонецПроцедуры
	
&НаСервере
Функция ПараметрыСоглашения(Соглашение)
	
	СтПараметров = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Соглашение,
		"СтатусСоглашения, СпособОбменаЭД, РесурсВходящихДокументов, РесурсИсходящихДокументов, СертификатОрганизацииДляРасшифровки, Наименование, ИдентификаторОрганизации, СертификатыПодписейОрганизации");
	ВыборкаСертификатов = СтПараметров.СертификатыПодписейОрганизации.Выбрать();
	СоотвСертификатовИИхСтруктур = Новый Соответствие;
	Если ВыборкаСертификатов.Количество() > 0 Тогда
		Пока ВыборкаСертификатов.Следующий() Цикл
			Сертификат = ВыборкаСертификатов.Сертификат;
			ПараметрыСертификата = ЭлектронныеДокументыСлужебныйВызовСервера.РеквизитыСертификата(Сертификат);
			ПараметрыСертификата.Вставить("СертификатПодписи", Сертификат);
			СоотвСертификатовИИхСтруктур.Вставить(Сертификат, ПараметрыСертификата);
		КонецЦикла;
	КонецЕсли;
	СтПараметров.Вставить("СертификатыПодписейОрганизации", СоотвСертификатовИИхСтруктур);
	
	Возврат СтПараметров;
	
КонецФункции
