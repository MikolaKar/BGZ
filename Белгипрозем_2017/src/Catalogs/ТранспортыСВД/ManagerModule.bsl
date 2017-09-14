
// Отправить сообщения СВД
Функция ОтправитьСообщения(Транспорт) Экспорт 
	
	НастройкаПриемаОтправки = Транспорт.НастройкаПриемаОтправки;
	
	Если Транспорт.ФорматСообщения = ПредопределенноеЗначение("Справочник.ФорматыСообщенийСВД.ОператорЭДО1СТакском") Тогда
		МенеджерОбъекта = Справочники.СоглашенияОбИспользованииЭД;
	Иначе
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(НастройкаПриемаОтправки);
	КонецЕсли;
	Если МенеджерОбъекта <> Неопределено Тогда
		Возврат МенеджерОбъекта.ОтправитьСообщения(
			НастройкаПриемаОтправки, Транспорт);
	КонецЕсли;	
		
	Возврат Ложь;
	
КонецФункции	

// Получить сообщения СВД
Функция ПолучитьСообщения(Транспорт) Экспорт 
	
	НастройкаПриемаОтправки = Транспорт.НастройкаПриемаОтправки;
	
	Если Транспорт.ФорматСообщения = ПредопределенноеЗначение("Справочник.ФорматыСообщенийСВД.ОператорЭДО1СТакском") Тогда
		МенеджерОбъекта = Справочники.СоглашенияОбИспользованииЭД;
	Иначе
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(НастройкаПриемаОтправки);
	КонецЕсли;
	Если МенеджерОбъекта <> Неопределено Тогда
		Возврат МенеджерОбъекта.ПолучитьСообщения(
			НастройкаПриемаОтправки, Транспорт);
	КонецЕсли;	
		
	Возврат Ложь;
	
КонецФункции	

// Получить наименование корреспондента в СВД
Функция ПолучитьНаименованиеКорреспондентаВСВД(Корреспондент, Транспорт) Экспорт
	
	НастройкаПриемаОтправки = Транспорт.НастройкаПриемаОтправки;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(НастройкаПриемаОтправки);
	Если МенеджерОбъекта <> Неопределено Тогда
		Возврат МенеджерОбъекта.ПолучитьНаименованиеКорреспондентаВСВД(Корреспондент, Транспорт);
	КонецЕсли;	
		
	Возврат "";
	
КонецФункции	

// Получить наименование организации в СВД
Функция ПолучитьНаименованиеОрганизацииВСВД(ОрганизацияДокумента, Транспорт) Экспорт
	
	НастройкаПриемаОтправки = Транспорт.НастройкаПриемаОтправки;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(НастройкаПриемаОтправки);
	Если МенеджерОбъекта <> Неопределено Тогда
		Возврат МенеджерОбъекта.ПолучитьНаименованиеОрганизацииВСВД(ОрганизацияДокумента, Транспорт);
	КонецЕсли;	
		
	Возврат "";
	
КонецФункции	

//МиСофт
// Получить код организации в СВД
Функция ПолучитьКодОрганизацииВСВД(ОрганизацияДокумента, Транспорт) Экспорт
	
	НастройкаПриемаОтправки = Транспорт.НастройкаПриемаОтправки;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(НастройкаПриемаОтправки);
	Если МенеджерОбъекта <> Неопределено Тогда
		Возврат МенеджерОбъекта.ПолучитьКодОрганизацииВСВД(ОрганизацияДокумента, Транспорт);
	КонецЕсли;	
		
	Возврат "";
	
КонецФункции	
