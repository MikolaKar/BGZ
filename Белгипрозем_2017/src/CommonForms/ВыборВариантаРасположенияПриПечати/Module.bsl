
&НаКлиенте
Процедура ВариантыРасположенияПриИзменении(Элемент)
	
	ПереключитьСтандартныеЗначенияНастроек();
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьСтандартныеЗначенияНастроек()
	
	Элементы.ПоГоризонтали.Доступность = Ложь;
	Элементы.ПоВертикали.Доступность = Ложь;
	Элементы.ПоГоризонтали.Маска = "";
	Элементы.ПоВертикали.Маска = "";
	Элементы.ГруппаСмещениеПоВертикали.Доступность = Ложь;
	Элементы.ГруппаСмещениеПоГоризонтали.Доступность = Ложь;
	
	Если ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ПравыйНижний Тогда
		СмещениеПоГоризонтали = "MAX";
		СмещениеПоВертикали = "MAX";
	ИначеЕсли ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ПравыйВерхний Тогда
		СмещениеПоГоризонтали = "MAX";
		СмещениеПоВертикали = "MIN";
	ИначеЕсли ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ЛевыйВерхний Тогда
		СмещениеПоГоризонтали = "MIN";
		СмещениеПоВертикали = "MIN";
	ИначеЕсли ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ЛевыйНижний Тогда
		СмещениеПоГоризонтали = "MIN";
		СмещениеПоВертикали = "MAX";
	Иначе
		Элементы.ПоГоризонтали.Доступность = Истина;
		Элементы.ПоВертикали.Доступность = Истина;
		Элементы.ПоГоризонтали.Маска = "999";
		Элементы.ПоВертикали.Маска = "999";
		Элементы.ГруппаСмещениеПоВертикали.Доступность = Истина;
		Элементы.ГруппаСмещениеПоГоризонтали.Доступность = Истина;
		СмещениеПоГоризонтали = 0;
		СмещениеПоВертикали = 0;
	КонецЕсли;
	
	УстановитьИндексКартинки();
			
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = ?(ЗначениеЗаполнено(Параметры.Заголовок), Параметры.Заголовок, НСтр("ru = 'Выбор варианта расположения'"));
	Иначе
		Заголовок = НСтр("ru = 'Выбор варианта расположения'");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкоды") Тогда
		Элементы.ГруппаВысота.Видимость = Ложь;
	КонецЕсли;
	
	//Настройки штрихкода
	Если Параметры.Свойство("НастройкиШтрихкода") Тогда
		НастройкиШтрихкода = Параметры.НастройкиШтрихкода;
	КонецЕсли;
	
	Если НастройкиШтрихкода = Неопределено Тогда
		НастройкиШтрихкода = ШтрихкодированиеСервер.ПолучитьПерсональныеНастройкиПоложенияШтрихкодаНаСтранице();
	КонецЕсли;
	
	Если НастройкиШтрихкода <> Неопределено И НастройкиШтрихкода.ПоказыватьФормуНастройки <> Неопределено Тогда
		НеПоказыватьФормуНастройки = НЕ НастройкиШтрихкода.ПоказыватьФормуНастройки;
		ПоложениеШтрихкода = НастройкиШтрихкода.ПоложениеНаСтранице;
		ПоГоризонтали = НастройкиШтрихкода.СмещениеПоГоризонтали;
		ПоВертикали = НастройкиШтрихкода.СмещениеПоВертикали;
	Иначе 
		ПоГоризонтали = "MIN";
		ПоВертикали = "MIN";
		ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ЛевыйВерхний;
	КонецЕсли;
	
	Если ПоложениеШтрихкода <> Перечисления.ВариантыРасположенияШтрихкода.ПроизвольноеПоложение Тогда
		Элементы.ПоГоризонтали.Доступность = Ложь;
		Элементы.ПоВертикали.Доступность = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПоложениеШтрихкода) Тогда
		ПоложениеШтрихкода = Перечисления.ВариантыРасположенияШтрихкода.ЛевыйВерхний;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗапросОриентацииСтраницы") И Параметры.ЗапросОриентацииСтраницы Тогда
		Элементы.ОриентацияСтраницы.Видимость = Истина;
		ОриентацияСтраницы = "Портретная";
	Иначе
		Элементы.ОриентацияСтраницы.Видимость = Ложь;
	КонецЕсли;
	
	РежимИспользованияНастроек = Параметры.РежимИспользованияНастроек;
	ДляВставки = Параметры.ДляВставки;
	
	ВставлятьЦифрыВШК = ХранилищеОбщихНастроек.Загрузить("НастройкиШтрихкода", "ВставлятьЦифрыВШК");
	ВысотаШтрихкодаПриВставкеВФайл = ХранилищеОбщихНастроек.Загрузить("НастройкиШтрихкода", "ВысотаШтрихкодаПриВставкеВФайл");
	Если НЕ ЗначениеЗаполнено(ВысотаШтрихкодаПриВставкеВФайл)
		ИЛИ ВысотаШтрихкодаПриВставкеВФайл < 10 И НЕ ВставлятьЦифрыВШК
		ИЛИ ВысотаШтрихкодаПриВставкеВФайл < 13 И ВставлятьЦифрыВШК Тогда
		Если ВставлятьЦифрыВШК Тогда
			ВысотаШтрихкодаПриВставкеВФайл = 13;
		Иначе
			ВысотаШтрихкодаПриВставкеВФайл = 10;
		КонецЕсли;
	КонецЕсли;
	
	ПереключитьСтандартныеЗначенияНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если РежимИспользованияНастроек < 2 Тогда // штрихкод
		
		Если ВысотаШтрихкодаПриВставкеВФайл < 10 И НЕ ВставлятьЦифрыВШК Тогда
			ОчиститьСообщения();
			ТекстСообщения = НСтр("ru = 'Введена слишком маленькая высота штрихкода. Минимальная высота штрихкода без вставки цифр составляет 10 мм.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,, "ВысотаШтрихкодаПриВставкеВФайл");
			Возврат;
		КонецЕсли;
		
		Если ВысотаШтрихкодаПриВставкеВФайл < 13
			И ВставлятьЦифрыВШК Тогда
			ОчиститьСообщения();
			ТекстСообщения = НСтр("ru = 'Введена слишком маленькая высота штрихкода. Минимальная высота штрихкода со вставкой цифр составляет 13 мм.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,, "ВысотаШтрихкодаПриВставкеВФайл");
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеОПоложении = Новый Структура;
	ДанныеОПоложении.Вставить("СмещениеПоГоризонтали", ПоГоризонтали);
	ДанныеОПоложении.Вставить("СмещениеПоВертикали", ПоВертикали);
	ДанныеОПоложении.Вставить("ПоложениеНаСтранице", ПоложениеШтрихкода);
	ДанныеОПоложении.Вставить("ПоказыватьФормуНастройки", Не НеПоказыватьФормуНастройки); 
	ДанныеОПоложении.Вставить("ВысотаШК", ВысотаШтрихкодаПриВставкеВФайл);
	ДанныеОПоложении.Вставить("ПоказыватьЦифры", ВставлятьЦифрыВШК);
	
	ШтрихкодированиеСервер.ЗаписатьПерсональныеНастройкиОкнаСвойствШтрихкода(ДанныеОПоложении);
	
	Если Элементы.ОриентацияСтраницы.Видимость = Истина Тогда
		ДанныеОПоложении.Вставить("ОриентацияСтраницы", ОриентацияСтраницы);
	КонецЕсли;
	
	Закрыть(ДанныеОПоложении);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОриентацияСтраницыПриИзменении(Элемент)
	
	УстановитьИндексКартинки();	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИндексКартинки()
	
	Если ДляВставки Тогда
		
		Элементы.Напечатать.Заголовок = НСтр("ru = 'Вставить'");
		
		Элементы.КартинкаДляПредпросмотра.ТекстНевыбраннойКартинки = НСтр("ru = 'После вставки штрихкода в файл его положение можно изменить в самом файле, открыв его на редактирование'");
		
	ИначеЕсли РежимИспользованияНастроек = 0 Тогда
		
		Элементы.КартинкаДляПредпросмотра.ТекстНевыбраннойКартинки = НСтр("ru = 'Рапечатайте пробный лист для проверки правильности расположения штрихкода'");
		
	КонецЕсли;
	
	КартинкаДляПредпросмотра = -1;
		
	Если СмещениеПоГоризонтали = "MIN" Тогда
		КартинкаДляПредпросмотра = КартинкаДляПредпросмотра + 1;
	ИначеЕсли СмещениеПоГоризонтали = "MAX" Тогда
		КартинкаДляПредпросмотра = КартинкаДляПредпросмотра + 3;
	КонецЕсли;
	
	Если СмещениеПоВертикали = "MAX" Тогда
		КартинкаДляПредпросмотра = КартинкаДляПредпросмотра + 1;
	КонецЕсли;
	
	Если НЕ Элементы.ПоГоризонтали.Доступность Тогда 
	
		Если РежимИспользованияНастроек = 1 Тогда 
			КартинкаДляПредпросмотра = 2 * КартинкаДляПредпросмотра + 12;	
		ИначеЕсли РежимИспользованияНастроек = 0 И ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкоды") Тогда 
			КартинкаДляПредпросмотра = 2 * КартинкаДляПредпросмотра + 4;
		ИначеЕсли РежимИспользованияНастроек = 2 Тогда 
			КартинкаДляПредпросмотра = КартинкаДляПредпросмотра + 20;
		КонецЕсли;	
	
		Если Элементы.ОриентацияСтраницы.Видимость И ОриентацияСтраницы = "Альбомная" Тогда
			КартинкаДляПредпросмотра = КартинкаДляПредпросмотра + 20;
		КонецЕсли;
	
		Если РежимИспользованияНастроек < 2 Тогда 
			Если ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкоды") и Не ВставлятьЦифрыВШК Тогда
				КартинкаДляПредпросмотра = КартинкаДляПредпросмотра + 1;	
			КонецЕсли;
		КонецЕсли;	
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставлятьЦифрыПриИзменении(Элемент)
	
	УстановитьИндексКартинки();
	
КонецПроцедуры
