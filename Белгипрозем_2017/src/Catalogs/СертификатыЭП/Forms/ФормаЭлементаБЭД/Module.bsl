
&НаСервере
Процедура УстановитьДоступностьВидимость()
	
	Элементы.ГруппаШапка.Доступность 				= Не Объект.Отозван;
	Элементы.ФормаТестСертификата.Доступность 		= Не Объект.Отозван;
	Элементы.ФормаТестСертификата.Доступность 		= Не ЭтаФорма.ТолькоПросмотр;
	Элементы.ФормаКнопкаОтозван.Пометка 			= Объект.Отозван;
	ЗаполнитьЗаголовкиГиперссылок();
	
	// Проверка сертификата на соответствие 63 ФЗ.
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.2.18.108") >= 0 Тогда
		ДанныеФайлаСертификата = Объект.Ссылка.ФайлСертификата.Получить();
		НовыйСертификат = Новый СертификатКриптографии(ДанныеФайлаСертификата);
		
		// Корректно работаем только с сертификатами для подписи стандартной структуры.
		Если (НовыйСертификат.Субъект.Свойство("SN") ИЛИ НовыйСертификат.Субъект.Свойство("CN"))
			И НовыйСертификат.Субъект.Свойство("T") И НовыйСертификат.Субъект.Свойство("ST") Тогда
			
			ФИОВладельца = "";
			Если НовыйСертификат.Субъект.Свойство("SN") Тогда
				ШаблонФИОВладельца = НСтр("ru = '%1 %2'");
				ФИОВладельца = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонФИОВладельца,
				НовыйСертификат.Субъект.SN, НовыйСертификат.Субъект.GN);
			ИначеЕсли НовыйСертификат.Субъект.Свойство("CN") Тогда
				
				ФИОВладельца = НовыйСертификат.Субъект.CN;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ФИОВладельца) Тогда
				Фамилия      = "";
				Имя          = "";
				Отчество     = "";
				
				ЭлектронныеДокументы.ФамилияИнициалыФизЛица(ФИОВладельца, Фамилия, Имя, Отчество);
			КонецЕсли;
			Должность = НовыйСертификат.Субъект.T;
			
			ЗаписатьСертификат = Ложь;
			Если ЗначениеЗаполнено(Фамилия) И Объект.Фамилия <> Фамилия Тогда
				Объект.Фамилия  = Фамилия;
				ЗаписатьСертификат = Истина;
			КонецЕсли;
			Если ЗначениеЗаполнено(Имя) И Объект.Имя <> Имя Тогда
				Объект.Имя      = Имя;
				ЗаписатьСертификат = Истина;
			КонецЕсли;
			Если ЗначениеЗаполнено(Отчество) И Объект.Отчество <> Отчество Тогда
				Объект.Отчество = Отчество;
				ЗаписатьСертификат = Истина;
			КонецЕсли;
			Если ЗначениеЗаполнено(Должность) И Объект.ДолжностьПоСертификату <> Должность Тогда
				Объект.ДолжностьПоСертификату = Должность;
				ЗаписатьСертификат = Истина;
			КонецЕсли;
			
			Если ЗаписатьСертификат Тогда
				Записать();
			КонецЕсли;
			
			Элементы.Фамилия.Доступность  = Ложь;
			Элементы.Имя.Доступность      = Ложь;
			Элементы.Отчество.Доступность = Ложь;
			Элементы.ДолжностьПоСертификату.Доступность  = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗаголовкиГиперссылок()
	
	Если НЕ Объект.ОграничитьДоступКСертификату Тогда
		ТекстГиперссылкиПользователя = Нстр("ru = 'Доступен всем пользователям.'");
	Иначе
		ТекстГиперссылкиПользователя = Нстр("ru = 'Доступен пользователю'") + ": " + ?(ЗначениеЗаполнено(Объект.Пользователь),
			Объект.Пользователь, "<Выбрать пользователя>");
	КонецЕсли;
	
	Если НЕ Объект.ЗапомнитьПарольКСертификату Тогда
		ТекстГиперссылкиПароля = Нстр("ru = 'Пароль не сохранен.'");
	Иначе
		ТекстГиперссылкиПароля = Нстр("ru = 'Изменить пароль.'");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СертификатОтозван(Команда)
	
	Объект.Отозван = НЕ Объект.Отозван;
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ТестНастроекСертификата(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтаФорма.Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	Если ЭлектронныеДокументыСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере() Тогда
		НаКлиенте = Ложь;
		НаСервере = Истина;
	Иначе
		НаКлиенте = Истина;
		НаСервере = Ложь;
	КонецЕсли;
	
	ПараметрыСертификата = ЭлектронныеДокументыСлужебныйВызовСервера.РеквизитыСертификата(Объект.Ссылка);
	ЭлектронныеДокументыСлужебныйКлиент.ТестНастроекСертификата(
		Объект.Ссылка, 
		ПараметрыСертификата, 
		НаКлиенте, 
		НаСервере);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура НазначениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Попытка
		ЭлектроннаяПодписьКлиент.ОткрытьСертификат(Объект.Отпечаток);
	Исключение
		ТекстПредупреждения = НСтр("ru = 'Невозможно открыть сертификат. Возможно он не установлен на локальный компьютер.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	
	Объект.Фамилия = СокрЛП(Объект.Фамилия);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	
	Объект.Имя = СокрЛП(Объект.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	
	Объект.Отчество = СокрЛП(Объект.Отчество);
	
КонецПроцедуры

&НаКлиенте
Процедура ДолжностьПоСертификатуПриИзменении(Элемент)
	
	Объект.ДолжностьПоСертификату = СокрЛП(Объект.ДолжностьПоСертификату);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.Идентификатор) Тогда
		Элементы.ФормаТестСертификата.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьДоступностьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.ОграничитьДоступКСертификату И НЕ ЗначениеЗаполнено(Объект.Пользователь) Тогда
		Отказ = Истина;
		ТекстПредупреждения = НСтр("ru = 'Не указан пользователь, которому доступен сертификат!
                                    |Укажите пользователя, либо снимите ограничение доступа.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭД") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущийОбъект.ВидыДокументов.Количество() = 0 Тогда
		
		АктуальныеЭД = ЭлектронныеДокументыПовтИсп.ПолучитьАктуальныеВидыЭД();
		Для Каждого ЗначениеПеречисления Из АктуальныеЭД Цикл
			Если ЗначениеПеречисления = Перечисления.ВидыЭД.Ошибка
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.Подтверждение
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ДопДанные
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ПлатежноеПоручение
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ЗапросВыписки
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ШтампБанка
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.Квитанция
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ЗапросНочнойВыписки
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ВозвратТоваровМеждуОрганизациями
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ПередачаТоваровМеждуОрганизациями
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.АктВыполненныхРабот
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.КаталогТоваров
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ТОРГ12
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ВыпискаБанка Тогда
					Продолжить;
			КонецЕсли;
			
			НоваяСтрокаТЧ = ТекущийОбъект.ВидыДокументов.Добавить();
			НоваяСтрокаТЧ.ВидДокумента = ЗначениеПеречисления;
			НоваяСтрокаТЧ.ИспользоватьДляПодписи = 
				ЗначениеПеречисления = Перечисления.ВидыЭД.ИзвещениеОПолучении
				ИЛИ ЗначениеПеречисления = Перечисления.ВидыЭД.ПроизвольныйЭД;
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") Тогда
		Объект.Пользователь = ВыбранноеЗначение;
		ЗаполнитьЗаголовкиГиперссылок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ОбновитьСостояниеЭД", Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗапросПароляДляСертификата" И Параметр = Объект.Ссылка Тогда
		ЭтаФорма.Прочитать();
	КонецЕсли;
	
КонецПроцедуры
