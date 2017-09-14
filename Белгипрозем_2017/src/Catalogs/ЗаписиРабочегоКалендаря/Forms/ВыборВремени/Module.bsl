#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("Мероприятие") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Мероприятие = Параметры.Мероприятие;
	ПериодОтображения = Перечисления.ПериодОтображенияРабочегоКалендаря.НеделяСТекущейДаты;
	
	Если ЗначениеЗаполнено(Мероприятие.ДатаНачала) И ЗначениеЗаполнено(Мероприятие.ДатаОкончания) Тогда
		ДатаНачала = Мероприятие.ДатаНачала;
		ДатаОкончания = Мероприятие.ДатаОкончания;
		Длительность = ДатаОкончания - ДатаНачала;
	Иначе
		Длительность = 3600;
		ДатаНачала = РаботаСРабочимКалендаремКлиентСервер.КонецПолучаса(ТекущаяДатаСеанса());
		ДатаОкончания = ДатаНачала + Длительность;
	КонецЕсли;
	ОтображаемаяДата = НачалоДня(ДатаНачала);
	
	УчастникиМероприятия = УправлениеМероприятиями.ПолучитьУчастниковМероприятия(Мероприятие, Истина);
	Для Каждого Строка Из УчастникиМероприятия Цикл
		
		Если ТипЗнч(Строка.Исполнитель) <> Тип("СправочникСсылка.Пользователи") Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Участники.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		НоваяСтрока.УчитыватьВПлане = Истина;
		Если НоваяСтрока.ЯвкаОбязательна Тогда
			НоваяСтрока.ИндексКартинки = 2;
		Иначе
			НоваяСтрока.ИндексКартинки = 1;
		КонецЕсли;
		НоваяСтрока.УчастникМероприятия = Истина;
		
	КонецЦикла;
	
	ВремяНачалаОтображения = РаботаСРабочимКалендаремСервер.ПолучитьПерсональнуюНастройку("ВремяНачалаОтображения");
	ВремяОкончанияОтображения = РаботаСРабочимКалендаремСервер.ПолучитьПерсональнуюНастройку("ВремяОкончанияОтображения");
	
	НачальноеЗначениеДатаНачала = ДатаНачала;
	НачальноеЗначениеДатаОкончания = ДатаОкончания;
	Элементы.ДатаНачалаВремя.Маска = "99:99";
	Элементы.ДатаОкончанияВремя.Маска = "99:99";
	Элементы.ВремяНачалаОтображения.Маска = "99:99";
	Элементы.ВремяОкончанияОтображения.Маска = "99:99";
	
	ОбновитьОтображениеСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОбластьВыбора();
	ПриИзмененииДатыВыбора();
	ВывестиДлительностьСобытия();
	ОтобразитьСводку();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СледующаяДатаСтрокойНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОтображаемаяДата = СледующаяДата;
	ПриИзмененииОтображаемойДаты();
	
КонецПроцедуры

&НаКлиенте
Процедура КартинкаСледующаяДатаНажатие(Элемент)
	
	ОтображаемаяДата = СледующаяДата;
	ПриИзмененииОтображаемойДаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущаяДатаСтрокойНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОтображаемаяДата = ПредыдущаяДата;
	ПриИзмененииОтображаемойДаты();
	
КонецПроцедуры

&НаКлиенте
Процедура КартинкаПредыдущаяДатаНажатие(Элемент)
	
	ОтображаемаяДата = ПредыдущаяДата;
	ПриИзмененииОтображаемойДаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображаемаяДатаПриИзменении(Элемент)
	
	ПриИзмененииОтображаемойДаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
		ДатаНачала, ДатаОкончания, Ложь,
		НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания);
	
	ПриИзмененииДатыВыбора();
	НеОбновлятьРекомендации = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаВремяПриИзменении(Элемент)
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
		ДатаНачала, ДатаОкончания, Ложь,
		НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания);
	
	ПриИзмененииДатыВыбора();
	НеОбновлятьРекомендации = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаВремяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Элемент.СписокВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаВремяОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаВремяАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, ДатаНачала);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаВремяОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Текст = "  :  " Тогда
		// Если не заполнено время - не очищать его, показывать список выбора
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, ДатаНачала);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
		ДатаНачала, ДатаОкончания, Ложь,
		НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания,
		Истина);
	
	ПриИзмененииДатыВыбора();
	НеОбновлятьРекомендации = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияВремяПриИзменении(Элемент)
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
		ДатаНачала, ДатаОкончания, Ложь,
		НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания);
	
	ПриИзмененииДатыВыбора();
	НеОбновлятьРекомендации = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияВремяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Элемент.СписокВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияВремяОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияВремяАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, ДатаОкончания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияВремяОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Текст = "  :  " Тогда
		// Если не заполнено время - не очищать его, показывать список выбора
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, ДатаОкончания);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиУчитыватьВПланеПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиИсполнительПриИзменении(Элемент)
	
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.УчитыватьВПлане Тогда
		ОбновитьОтображение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.УчастникМероприятия Тогда
		Отказ = Истина;
		ТекущиеДанные.УчитыватьВПлане = НЕ ТекущиеДанные.УчитыватьВПлане;
		ОбновитьОтображение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	ВыделенныеСтроки = Элемент.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		
		ДаныеСтроки = Элемент.ДанныеСтроки(Строка);
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Исполнитель", ДаныеСтроки.Исполнитель);
		ПараметрыОтбора.Вставить("УчитыватьВПлане", ДаныеСтроки.УчитыватьВПлане);
		НайденныеСтроки = Участники.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НайденнаяСтрока = НайденныеСтроки[0];
		Если НайденнаяСтрока.УчастникМероприятия Тогда
			НайденнаяСтрока.УчитыватьВПлане = Ложь;
		Иначе
			ИндексСтроки = Участники.Индекс(НайденнаяСтрока);
			Участники.Удалить(ИндексСтроки);
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура КалендарьПриАктивизацииОбласти(Элемент)
	
	ПриАктивизацииОбластиВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура КалендарьОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПриАктивизацииОбластиВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура КалендарьВыбор(Элемент, Область, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПриАктивизацииОбластиВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаОтображенияПриИзменении(Элемент)
	
	ПриИзмененииОтображаемогоВремени();
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаОтображенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Элемент.СписокВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаОтображенияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаОтображенияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, , Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяНачалаОтображенияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, , Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияОтображенияПриИзменении(Элемент)
	
	ПриИзмененииОтображаемогоВремени();
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияОтображенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Элемент.СписокВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияОтображенияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияОтображенияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, , Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяОкончанияОтображенияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, , Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура РекомендацииПриАктивизацииСтроки(Элемент)
	
	Если НеОбновлятьРекомендации Тогда
		НеОбновлятьРекомендации = Ложь;
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Элемент.ТекущиеДанные;
	
	Если ДанныеСтроки <> Неопределено И ЗначениеЗаполнено(ДанныеСтроки.ДатаНачала)  Тогда
		ВыбратьРекомендацию(ДанныеСтроки.ДатаНачала);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНастроитьНажатие(Элемент)
	
	Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройкиЗначение;
	
КонецПроцедуры

&НаКлиенте
Процедура ДлительностьЧасовПриИзменении(Элемент)
	
	ПриИзмененииЭлементаДлительности();
	
КонецПроцедуры

&НаКлиенте
Процедура ДлительностьЧасовОчистка(Элемент, СтандартнаяОбработка)
	
	ПриИзмененииЭлементаДлительности();
	
КонецПроцедуры

&НаКлиенте
Процедура ДлительностьМинутПриИзменении(Элемент)
	
	ПриИзмененииЭлементаДлительности();
	
КонецПроцедуры

&НаКлиенте
Процедура ДлительностьМинутОчистка(Элемент, СтандартнаяОбработка)
	
	ПриИзмененииЭлементаДлительности();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ДобавитьУчастниковПодбораВМероприятие() Тогда
		Возврат;
	КонецЕсли;
	
	Время = Новый Структура("ДатаНачала, ДатаОкончания, ДобавленныеУчастники");
	Время.ДатаНачала = ДатаНачала;
	Время.ДатаОкончания = ДатаОкончания;
	Время.ДобавленныеУчастники = Новый Массив;
	
	Закрыть(Время);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьОтображение()
	
	ОтобразитьПояснениеРедактированиеКалендаря();
	
	ОбновитьОтображениеСервер();
	УстановитьОбластьВыбора();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтображениеСервер()
	
	ОбновитьДатыПериодов();
	ОбновитьРекомендации();
	ОтобразитьКалендарьЗанятости();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДатыПериодов()
	
	ПредыдущаяДата =
		РаботаСРабочимКалендаремКлиентСервер.ПолучитьДатуНачалаПредыдущегоПериода(
			ПериодОтображения, ОтображаемаяДата);
	ПредыдущаяДатаКонецПериода =
		РаботаСРабочимКалендаремКлиентСервер.ПолучитьДатуОкончанияОтображаемогоПериода(
			ПериодОтображения, ПредыдущаяДата);
	СледующаяДата =
		РаботаСРабочимКалендаремКлиентСервер.ПолучитьДатуНачалаСледующегоПериода(
			ПериодОтображения, ОтображаемаяДата);
	СледующаяДатаКонецПериода =
		РаботаСРабочимКалендаремКлиентСервер.ПолучитьДатуОкончанияОтображаемогоПериода(
			ПериодОтображения, СледующаяДата);
	ОтображаемаяДатаКонецПериода =
		РаботаСРабочимКалендаремКлиентСервер.ПолучитьДатуОкончанияОтображаемогоПериода(
			ПериодОтображения, ОтображаемаяДата);
	
	ФорматДаты = "ДФ='dd MMMM'";
	ПредыдущаяДатаСтрокой =
		Формат(ПредыдущаяДата, ФорматДаты) + " - " + Формат(ПредыдущаяДатаКонецПериода, ФорматДаты);
	СледующаяДатаСтрокой =
		Формат(СледующаяДата, ФорматДаты) + " - " + Формат(СледующаяДатаКонецПериода, ФорматДаты);
	ОтображаемаяДатаСтрокой =
		Формат(ОтображаемаяДата, ФорматДаты) + " - " + Формат(ОтображаемаяДатаКонецПериода, ФорматДаты);
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьКалендарьЗанятости()
	
	МассивУчастников = ПолучитьМассивУчастников(Ложь);
	
	РаботаСРабочимКалендаремСервер.ОтобразитьКалендарьЗанятости(Календарь,
		ПериодОтображения, ОтображаемаяДата, МассивУчастников,
		ВремяНачалаОтображения, ВремяОкончанияОтображения, Мероприятие);
	
	// Строка общее и по одной строке на участника
	ВысотаОбластиВыбора = 1 + МассивУчастников.Количество();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьРекомендации()
	
	Рекомендации.Очистить();
	
	МассивУчастников = ПолучитьМассивУчастников(Ложь);
	МассивОбязательныхУчастников = ПолучитьМассивУчастников(Истина);
	
	ТаблицаРекомендаций = РаботаСРабочимКалендаремСервер.ПолучитьТаблицуРекомендаций(МассивУчастников,
		ОтображаемаяДата, ОтображаемаяДатаКонецПериода, Длительность, Мероприятие);
	ТаблицаРекомендаций.Колонки.Добавить("ДоступныВсеПользователи");
	ТаблицаРекомендаций.ЗаполнитьЗначения(Истина, "ДоступныВсеПользователи");
	
	Если ТаблицаРекомендаций.Количество() = 0 Тогда
		
		ТаблицаРекомендацийОбязательныхУчастников =
			РаботаСРабочимКалендаремСервер.ПолучитьТаблицуРекомендаций(МассивОбязательныхУчастников,
				ОтображаемаяДата, ОтображаемаяДатаКонецПериода, Длительность, Мероприятие);
		
		Для Каждого РекомендацияОбязательныхУчастников Из ТаблицаРекомендацийОбязательныхУчастников Цикл
			
			ПараметрыОтбора = Новый Структура("ДатаНачала, ДатаОкончания");
			ПараметрыОтбора.ДатаНачала = РекомендацияОбязательныхУчастников.ДатаНачала;
			ПараметрыОтбора.ДатаОкончания = РекомендацияОбязательныхУчастников.ДатаОкончания;
			
			Если ТаблицаРекомендаций.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
				НоваяСтрока = ТаблицаРекомендаций.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, РекомендацияОбязательныхУчастников);
				НоваяСтрока.ДоступныВсеПользователи = Ложь;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ТаблицаРекомендаций.Сортировать("ДоступныВсеПользователи Убыв, ДатаНачала");
	
	ЗаполнитьРекомендации(ТаблицаРекомендаций);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьРекомендацию(РекомендацияДатаНачала)
	
	ДатаНачала = РекомендацияДатаНачала;
	СкорректироватьПараметрыОтображения();
	УстановитьОбластьВыбора();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивУчастников(ТолькоОбязательныеУчастники)
	
	Если ТолькоОбязательныеУчастники Тогда
		ПараметрыОтбора = Новый Структура("УчитыватьВПлане, ЯвкаОбязательна", Истина, Истина);
	Иначе
		ПараметрыОтбора = Новый Структура("УчитыватьВПлане", Истина);
	КонецЕсли;
	Участники.Сортировать("Исполнитель");
	ТаблицаУчастников = Участники.Выгрузить(ПараметрыОтбора, "Исполнитель");
	МассивУчастниковВыгрузка = ТаблицаУчастников.ВыгрузитьКолонку("Исполнитель");
	
	МассивУчастников = Новый Массив;
	Для Каждого Участник Из МассивУчастниковВыгрузка Цикл
		Если ЗначениеЗаполнено(Участник) И МассивУчастников.Найти(Участник) = Неопределено Тогда
			МассивУчастников.Добавить(Участник);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивУчастников;
	
КонецФункции

&НаКлиенте
Процедура ПриАктивизацииОбластиВыбора()
	
	Время = РаботаСРабочимКалендаремКлиент.ПолучитьВремяВВыделеннойОбласти(Календарь);
	
	Если ЗначениеЗаполнено(Время.ДатаНачала) И ЗначениеЗаполнено(Время.ВесьДень) Тогда
		
		Если Время.ВесьДень Тогда
			ДатаНачалаОбластиВыбора = НачалоДня(Время.ДатаНачала) + (ВремяНачалаОтображения - НачалоДня(ВремяНачалаОтображения));
		Иначе
			ДатаНачалаОбластиВыбора = Время.ДатаНачала;
		КонецЕсли;
		
		ДатаНачалаПолучаса = РаботаСРабочимКалендаремКлиентСервер.НачалоПолучаса(ДатаНачала);
		
		Если ДатаНачалаОбластиВыбора <> ДатаНачалаПолучаса Тогда
			ДатаНачала = ДатаНачалаОбластиВыбора;
			СкорректироватьПараметрыОтображения();
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьСпискиВыбора();
	УстановитьОбластьВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииОтображаемойДаты()
	
	ОбновитьОтображение();
	
	Если ДатаНачала < ОтображаемаяДата ИЛИ ДатаНачала > ОтображаемаяДатаКонецПериода Тогда
		ДатаНачала = ОтображаемаяДата + (ДатаНачала - НачалоДня(ДатаНачала));
		СкорректироватьПараметрыОтображения();
	КонецЕсли;
	
	УстановитьОбластьВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииДатыВыбора()
	
	Если ДатаНачала < ОтображаемаяДата ИЛИ ДатаНачала > ОтображаемаяДатаКонецПериода Тогда
		ОтображаемаяДата = НачалоДня(ДатаНачала);
		ОбновитьОтображение();
	КонецЕсли;
	
	Длительность = ДатаОкончания - ДатаНачала;
	СкорректироватьПараметрыОтображения();
	ПриИзмененииДлительности();
	ЗаполнитьСпискиВыбора();
	УстановитьОбластьВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииОтображаемогоВремени()
	
	СкорректироватьВремяОтображения();
	ОтобразитьПояснениеРедактированиеКалендаря();
	ПриИзмененииОтображаемогоВремениСервер();
	
	СкорректироватьПараметрыОтображения();
	УстановитьОбластьВыбора();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииОтображаемогоВремениСервер()
	
	РаботаСРабочимКалендаремСервер.УстановитьПерсональнуюНастройку(
		"ВремяНачалаОтображения", ВремяНачалаОтображения);
	РаботаСРабочимКалендаремСервер.УстановитьПерсональнуюНастройку(
		"ВремяОкончанияОтображения", ВремяОкончанияОтображения);
	ОбновитьОтображениеСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбластьВыбора()
	
	КоординатаY = ПолучитьКоординатуY();
	КоординатаX = ПолучитьКоординатуX();
	
	ДатаНачалаЯчейки = РаботаСРабочимКалендаремКлиентСервер.НачалоПолучаса(ДатаНачала);
	ДатаОкончанияЯчейки = РаботаСРабочимКалендаремКлиентСервер.КонецПолучаса(ДатаОкончания);
	ШиринаОбластиВыбора = (ДатаОкончанияЯчейки - ДатаНачалаЯчейки) / 1800;
	
	НоваяОбластьВерх = КоординатаY;
	НоваяОбластьНиз = КоординатаY + ВысотаОбластиВыбора - 1;
	НоваяОбластьЛево = КоординатаX;
	НоваяОбластьПраво = КоординатаX + ШиринаОбластиВыбора - 1;
	
	Если Элементы.Календарь.ТекущаяОбласть.Верх <> НоваяОбластьВерх
		Или Элементы.Календарь.ТекущаяОбласть.Низ <> НоваяОбластьНиз
		Или Элементы.Календарь.ТекущаяОбласть.Лево <> НоваяОбластьЛево
		Или Элементы.Календарь.ТекущаяОбласть.Право <> НоваяОбластьПраво Тогда
		
		Элементы.Календарь.ТекущаяОбласть = Календарь.Область(
			НоваяОбластьВерх, НоваяОбластьЛево, НоваяОбластьНиз, НоваяОбластьПраво);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьВремяОтображения()
	
	ВремяНачалаОтображения = Дата(1,1,1) + Час(ВремяНачалаОтображения) * 3600;
	ВремяОкончанияОтображения = Дата(1,1,1) + Час(ВремяОкончанияОтображения) * 3600;
	
	// Если время окончания 00:00 - значит это 00:00 следующего дня
	Если ВремяОкончанияОтображения = Дата(1,1,1) Тогда
		ВремяОкончанияОтображения = Дата(1,1,2);
	КонецЕсли;
	
	// Время окончания отображения не может быть времени начала отображения
	Если ВремяОкончанияОтображения < (ВремяНачалаОтображения + 3600) Тогда
		ВремяОкончанияОтображения = ВремяНачалаОтображения + 3600;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкорректироватьПараметрыОтображения()
	
	Если Длительность > (ВремяОкончанияОтображения - ВремяНачалаОтображения) Тогда
		Длительность = ВремяОкончанияОтображения - ВремяНачалаОтображения;
		ПриИзмененииДлительности();
	КонецЕсли;
	
	ДатаОкончания = ДатаНачала + Длительность;
	
	Если (ДатаОкончания - НачалоДня(ДатаНачала)) > (ВремяОкончанияОтображения - НачалоДня(ВремяНачалаОтображения)) Тогда
		
		ОтображениеСНачалаДня = (ВремяНачалаОтображения = Дата("00010101000000")); // Отображать с "00:00" текущего дня
		ОтображениеДоКонцаДня = (ВремяОкончанияОтображения = Дата("00010102000000")); // Отображать по "00:00" следующего дня
		ОтображениеВсегоДня = ОтображениеСНачалаДня И ОтображениеДоКонцаДня;
		Если НЕ ОтображениеВсегоДня Тогда
			ДатаОкончания = НачалоДня(ДатаНачала) + (ВремяОкончанияОтображения - НачалоДня(ВремяНачалаОтображения));
			ДатаНачала = ДатаОкончания - Длительность;
		КонецЕсли;
		
	КонецЕсли;
	
	Если (ДатаНачала - НачалоДня(ДатаНачала)) < (ВремяНачалаОтображения - НачалоДня(ВремяНачалаОтображения)) Тогда
		
		ДатаНачала = НачалоДня(ДатаНачала) + (ВремяНачалаОтображения - НачалоДня(ВремяНачалаОтображения));
		ДатаОкончания = ДатаНачала + Длительность;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКоординатуX()
	
	КоординатаX = 2; // Начиная со 2го столбца идут столбцы времени
	КоличествоСтолбцовВДне = (НачалоЧаса(ВремяОкончанияОтображения) - НачалоЧаса(ВремяНачалаОтображения)) / 1800;
	КоличествоДней = (НачалоДня(ДатаНачала) - НачалоДня(ОтображаемаяДата)) / 86400; // 86400 - число секунд в сутках
	КоличествоПолучасов = ((ДатаНачала - НачалоДня(ДатаНачала)) - (ВремяНачалаОтображения - НачалоДня(ВремяНачалаОтображения))) / 1800;
	
	// Считаем координату начала дня
	КоординатаX = КоординатаX + КоличествоСтолбцовВДне * КоличествоДней;
	
	// Считаем координату в дне
	КоординатаX = КоординатаX + КоличествоПолучасов;
	
	Возврат КоординатаX;
	
КонецФункции

&НаКлиенте
Функция ПолучитьКоординатуY()
	
	Возврат 3; // Начиная с 3ей строки идут строки доступности времени
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьСпискиВыбора()
	
	ЗаполнитьСписокВыбораДатаНачалаВремя();
	ЗаполнитьСписокВыбораДатаОкончанияВремя();
	ЗаполнитьСписокВыбораВремяНачалаОтображения();
	ЗаполнитьСписокВыбораВремяОкончанияОтображения();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораДатаНачалаВремя()
	
	Элементы.ДатаНачалаВремя.СписокВыбора.Очистить();
	
	ТекДата = НачалоДня(ДатаНачала);
	ВремяНачалаЗаполнения = НачалоДня(ТекДата) + (ВремяНачалаОтображения - НачалоДня(ВремяНачалаОтображения));
	ВремяОкончанияЗаполнения = НачалоДня(ТекДата) + (ВремяОкончанияОтображения - НачалоДня(ВремяНачалаОтображения));
	
	// Заполняем список выбора по полчаса
	Для Инд = 1 По 48 Цикл
		
		Если ТекДата >= ВремяНачалаЗаполнения И ТекДата < ВремяОкончанияЗаполнения Тогда
			
			Элементы.ДатаНачалаВремя.СписокВыбора.Добавить(ТекДата, Формат(ТекДата, "ДФ=ЧЧ:мм"));
			Если ДатаНачала > ТекДата И ДатаНачала < ТекДата + 1800 Тогда
				Элементы.ДатаНачалаВремя.СписокВыбора.Добавить(ДатаНачала, Формат(ДатаНачала, "ДФ=ЧЧ:мм"));
			КонецЕсли;
			
		КонецЕсли;
		
		ТекДата = ТекДата + 1800;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораДатаОкончанияВремя()
	
	Элементы.ДатаОкончанияВремя.СписокВыбора.Очистить();
	
	СобытиеВПределахОдногоДня = (НачалоДня(ДатаНачала) = НачалоДня(ДатаОкончания));
	Если СобытиеВПределахОдногоДня Тогда
		
		ТекДата = РаботаСРабочимКалендаремКлиентСервер.КонецПолучаса(ДатаНачала);
		Если ДатаОкончания > ТекДата - 1800 И ДатаОкончания < ТекДата Тогда
			Элементы.ДатаОкончанияВремя.СписокВыбора.Добавить(ДатаОкончания, Формат(ДатаОкончания, "ДФ=ЧЧ:мм"));
		КонецЕсли;
		ВремяНачалаЗаполнения = НачалоДня(ТекДата) + (ВремяНачалаОтображения - НачалоДня(ВремяНачалаОтображения));
		ВремяОкончанияЗаполнения = НачалоДня(ТекДата) + (ВремяОкончанияОтображения - НачалоДня(ВремяНачалаОтображения));
		
	ИначеЕсли ЗначениеЗаполнено(ДатаОкончания) Тогда
		
		ТекДата = НачалоДня(ДатаОкончания);
		ВремяНачалаЗаполнения = НачалоДня(ТекДата);
		ВремяОкончанияЗаполнения = НачалоДня(ТекДата) + (ВремяОкончанияОтображения - НачалоДня(ВремяНачалаОтображения));
		Элементы.ДатаОкончанияВремя.СписокВыбора.Добавить(ТекДата, Формат(ДатаОкончания, "ДФ=ЧЧ:мм"));
		
	КонецЕсли;
	
	Для Инд = 1 По 48 Цикл
		
		Если ТекДата > КонецДня(ДатаОкончания) Тогда
			Прервать;
		КонецЕсли;
		
		Если ТекДата > ВремяНачалаЗаполнения И ТекДата <= ВремяОкончанияЗаполнения И ТекДата > ДатаНачала Тогда
			
			Элементы.ДатаОкончанияВремя.СписокВыбора.Добавить(ТекДата, Формат(ТекДата, "ДФ=ЧЧ:мм"));
			Если ДатаОкончания > ТекДата И ДатаОкончания < ТекДата + 1800 Тогда
				Элементы.ДатаОкончанияВремя.СписокВыбора.Добавить(ДатаОкончания, Формат(ДатаОкончания, "ДФ=ЧЧ:мм"));
			КонецЕсли;
			
		КонецЕсли;
		
		ТекДата = ТекДата + 1800;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораВремяНачалаОтображения()
	
	Элементы.ВремяНачалаОтображения.СписокВыбора.Очистить();
	
	ТекДата = НачалоДня(ВремяНачалаОтображения);
	Для Инд = 1 По 48 Цикл
		
		Если ТекДата < ВремяОкончанияОтображения Тогда
			
			Элементы.ВремяНачалаОтображения.СписокВыбора.Добавить(ТекДата, Формат(ТекДата, "ДФ=ЧЧ:мм; ДП=00:00"));
			
		КонецЕсли;
		
		ТекДата = ТекДата + 3600;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораВремяОкончанияОтображения()
	
	Элементы.ВремяОкончанияОтображения.СписокВыбора.Очистить();
	
	ТекДата = КонецЧаса(ВремяНачалаОтображения) + 1;
	Для Инд = 1 По 48 Цикл
		
		Если ТекДата > КонецДня(ВремяНачалаОтображения) Тогда
			Элементы.ВремяОкончанияОтображения.СписокВыбора.Добавить(ТекДата, Формат(ТекДата, "ДФ=ЧЧ:мм"));
			Прервать;
		КонецЕсли;
		
		Если ТекДата > ВремяНачалаОтображения Тогда
			
			Элементы.ВремяОкончанияОтображения.СписокВыбора.Добавить(ТекДата, Формат(ТекДата, "ДФ=ЧЧ:мм"));
			
		КонецЕсли;
		
		ТекДата = ТекДата + 3600;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиДлительностьСобытия()
	
	ДлительностьСтр = "";
	
	Если Не ЗначениеЗаполнено(Длительность) Тогда 
		Возврат;
	КонецЕсли;
	
	Дней = Цел(Длительность / 86400); // 86400 - число секунд в сутках
	ПодписьДней = ДелопроизводствоКлиентСервер.ПолучитьПодписьДней(Дней);
	
	Часов = Цел((Длительность - Дней * 86400) / 3600); // 86400 - число секунд в сутках
	ПодписьЧасов = ДелопроизводствоКлиентСервер.ПолучитьПодписьЧасов(Часов);
	
	Минут = Цел((Длительность - Дней * 86400 - Часов * 3600) / 60); // 86400 - число секунд в сутках
	ПодписьМинут = ДелопроизводствоКлиентСервер.ПолучитьПодписьМинут(Минут);
	
	Если Дней > 0 Тогда 
		ДлительностьСтр = ДлительностьСтр + Строка(Дней) + " " + ПодписьДней;
	КонецЕсли;
	
	Если Часов > 0 Тогда 
		
		Если Дней > 0 Тогда
			ДлительностьСтр = ДлительностьСтр + " ";
		КонецЕсли;
		
		ДлительностьСтр = ДлительностьСтр + Строка(Часов) + " " + ПодписьЧасов;
	КонецЕсли;
	
	Если Минут > 0 Тогда 
		
		Если Дней > 0 ИЛИ Часов > 0 Тогда
			ДлительностьСтр = ДлительностьСтр + " ";
		КонецЕсли;
		
		ДлительностьСтр = ДлительностьСтр + Строка(Минут) + " " + ПодписьМинут;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРекомендациюСтрокой(РекомендацияДатаНачала, РекомендацияДатаОкончания,
	ДоступныВсеПользователи)
	
	РекомендацияСтрокой = Формат(РекомендацияДатаНачала, "ДФ='ддд, д ММММ ЧЧ:мм'");
	
	Если НачалоДня(РекомендацияДатаНачала) - НачалоДня(РекомендацияДатаОкончания) <> 0 Тогда
		ФорматДатыОкончания = "ДФ='ддд, дд ММММ гггг ЧЧ:мм'";
	Иначе
		ФорматДатыОкончания = "ДФ=ЧЧ:мм";
	КонецЕсли;
	ДобавитьЗначениеКСтрокеЧерезРазделитель(
		РекомендацияСтрокой, " - ", Формат(РекомендацияДатаОкончания, ФорматДатыОкончания));
	
	Если ДоступныВсеПользователи Тогда
		ДоступныеПользователь = НСтр("ru = 'Свободны все участники'");
	Иначе
		ДоступныеПользователь = НСтр("ru = 'Свободны только обязательные участники'");
	КонецЕсли;
	ДобавитьЗначениеКСтрокеЧерезРазделитель(
		РекомендацияСтрокой, "   ", ДоступныеПользователь);
	
	Возврат РекомендацияСтрокой;
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииЭлементаДлительности()
	
	// Если длительность не указана - то она равна 1 часу
	Если ДлительностьЧасов = 1 И ДлительностьМинут = 0 Тогда
		ДлительностьЧасов = 1; 
	КонецЕсли;
	
	Длительность = ДлительностьЧасов * 3600 + ДлительностьМинут * 60;
	Если Длительность > (ВремяОкончанияОтображения - ВремяНачалаОтображения) Тогда
		Длительность = ВремяОкончанияОтображения - ВремяНачалаОтображения;
		ПриИзмененииДлительности();
	КонецЕсли;
	
	ДатаОкончания = ДатаНачала + Длительность;
	ПриИзмененииДатыВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииДлительности()
	
	Дней = Цел(Длительность / 86400); // 86400 - число секунд в сутках
	ПодписьДней = ДелопроизводствоКлиентСервер.ПолучитьПодписьДней(Дней);
	
	Часов = Цел((Длительность - Дней * 86400) / 3600); // 86400 - число секунд в сутках
	ПодписьЧасов = ДелопроизводствоКлиентСервер.ПолучитьПодписьЧасов(Часов);
	
	Минут = Цел((Длительность - Дней * 86400 - Часов * 3600) / 60); // 86400 - число секунд в сутках
	ПодписьМинут = ДелопроизводствоКлиентСервер.ПолучитьПодписьМинут(Минут);
	
	ДлительностьЧасов = Дней * 24 + Часов;
	ДлительностьМинут = Минут;
	
	ВывестиДлительностьСобытия();
	ОбновитьРекомендации();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРекомендации(ТаблицаРекомендаций)
	
	Для Каждого СтрокаРекомендации Из ТаблицаРекомендаций Цикл
		
		Если ТребуетсяКорректировкаПоВремениОтображения() 
			И НачалоДня(СтрокаРекомендации.ДатаНачала) <> НачалоДня(СтрокаРекомендации.ДатаОкончания) Тогда
			
			НачалоТекущегоДня = НачалоДня(СтрокаРекомендации.ДатаНачала);
			НачалоДняОкончания = НачалоДня(СтрокаРекомендации.ДатаОкончания);
			НачалоОтображения = ВремяНачалаОтображения - НачалоДня(ВремяНачалаОтображения);
			ОкончаниеОтображения = ВремяОкончанияОтображения - НачалоДня(ВремяОкончанияОтображения);
			
			ДобавитьРекомендацию(СтрокаРекомендации.ДатаНачала, НачалоТекущегоДня + ОкончаниеОтображения,
				СтрокаРекомендации.ДоступныВсеПользователи);
			НачалоТекущегоДня = НачалоТекущегоДня + 86400;
			
			Пока НачалоТекущегоДня < НачалоДняОкончания Цикл
				ДобавитьРекомендацию(НачалоТекущегоДня + НачалоОтображения, НачалоТекущегоДня + ОкончаниеОтображения,
					СтрокаРекомендации.ДоступныВсеПользователи);
				НачалоТекущегоДня = НачалоТекущегоДня + 86400; // 86400 - число секунд в сутках
			КонецЦикла;
			
			ДобавитьРекомендацию(НачалоТекущегоДня + НачалоОтображения, СтрокаРекомендации.ДатаОкончания,
				СтрокаРекомендации.ДоступныВсеПользователи);
			
		Иначе
			
			ДобавитьРекомендацию(СтрокаРекомендации.ДатаНачала, СтрокаРекомендации.ДатаОкончания,
				СтрокаРекомендации.ДоступныВсеПользователи);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРекомендацию(РекомендацияДатаНачала, РекомендацияДатаОкончания, ДоступныВсеПользователи)
	
	Если ТребуетсяКорректировкаПоВремениОтображения() Тогда
		
		НачалоРекомендации = РекомендацияДатаНачала - НачалоДня(РекомендацияДатаНачала);
		НачалоОтображения = ВремяНачалаОтображения - НачалоДня(ВремяНачалаОтображения);
		Если НачалоРекомендации < НачалоОтображения Тогда
			РекомендацияДатаНачала = НачалоДня(РекомендацияДатаНачала) + НачалоОтображения;
		КонецЕсли;
		
		ОкончаниеРекомендации = РекомендацияДатаОкончания - НачалоДня(РекомендацияДатаОкончания);
		ОкончаниеОтображения = ВремяОкончанияОтображения - НачалоДня(ВремяНачалаОтображения);
		Если ОкончаниеРекомендации > ОкончаниеОтображения Тогда
			РекомендацияДатаОкончания = НачалоДня(РекомендацияДатаОкончания) + ОкончаниеОтображения;
		КонецЕсли;
		
	КонецЕсли;
	
	ДлительностьРекомендации = РекомендацияДатаОкончания - РекомендацияДатаНачала;
	Если ДлительностьРекомендации < Длительность Тогда
		Возврат;
	КонецЕсли;
	
	НоваяРекомендация = Рекомендации.Добавить(); 
	НоваяРекомендация.ДатаНачала = РекомендацияДатаНачала;
	НоваяРекомендация.ДатаОкончания = РекомендацияДатаОкончания;
	НоваяРекомендация.РекомендацияСтрокой = ПолучитьРекомендациюСтрокой(РекомендацияДатаНачала,
		РекомендацияДатаОкончания, ДоступныВсеПользователи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСводку()
	
	СводкаДатыПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'с %1 по %2'"), 
		Формат(ОтображаемаяДата, "ДФ=dd.MM.yyyy"),
		Формат(ОтображаемаяДатаКонецПериода, "ДФ=dd.MM.yyyy"));
	
	Если ВремяНачалаОтображения = Дата(1,1,1) И ВремяОкончанияОтображения = Дата(1,1,2) Тогда
		СводкаВозможноеВремя = НСтр("ru = 'во всем дне'");
	Иначе
		
		СводкаВозможноеВремя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'с %1 по %2'"),
			Формат(ВремяНачалаОтображения, "ДФ=ЧЧ:мм; ДП=00:00"),
			Формат(ВремяОкончанияОтображения, "ДФ=ЧЧ:мм; ДП=00:00"));
		
	КонецЕсли;
	
	КоличествоУчастников = Участники.Количество();
	ПредставлениеУчастников = НСтр("ru = 'участника'") + "," + НСтр("ru = 'участников'") + "," + НСтр("ru = 'участников'");
	ПредставлениеЕдиницыИзмеренияУчастников = 
		ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
			КоличествоУчастников, ПредставлениеУчастников);
	СводкаКоличествоУчастников = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 %2'"),
		КоличествоУчастников, 
		ПредставлениеЕдиницыИзмеренияУчастников);
	
	Сводка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ищем %1 %2 для %3.'"),
		ДлительностьСтр,
		СводкаВозможноеВремя,
		СводкаКоличествоУчастников);
	
КонецПроцедуры

&НаСервере
Функция ТребуетсяКорректировкаПоВремениОтображения()
	
	НетОграниченийОтображения = 
		(ВремяНачалаОтображения = Дата(1,1,1) И ВремяОкончанияОтображения = Дата(1,1,2));
	
	Возврат НЕ НетОграниченийОтображения;
	
КонецФункции

&НаКлиенте
Процедура ОтобразитьПояснениеРедактированиеКалендаря()
	
	ТекстПояснения =
		НСтр("ru = 'Выполняется обновление календаря...
			|Пожалуйста, подождите.'");
	Состояние(ТекстПояснения);
	
КонецПроцедуры

&НаКлиенте
Функция ДобавитьУчастниковПодбораВМероприятие()
	
	УчастникиМероприятия = ПолучитьМассивУчастниковКлиент(Истина);
	ДобавленныеУчтенныеУчастники = ПолучитьМассивУчастниковКлиент(Ложь, Истина);
	ДобавленныеНеучтенныеУчастники = ПолучитьМассивУчастниковКлиент(Ложь, Ложь);
	
	ДобавленныеУчастники = Новый Массив;
	Для Каждого ДобавленныйУчтенныйУчастник Из ДобавленныеУчтенныеУчастники Цикл
		Если УчастникиМероприятия.Найти(ДобавленныйУчтенныйУчастник) <> Неопределено
			Или ДобавленныеУчастники.Найти(ДобавленныйУчтенныйУчастник) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ДобавленныеУчастники.Добавить(ДобавленныйУчтенныйУчастник);
	КонецЦикла;
	ЕстьДобавленныеУчастники = (ДобавленныеУчастники.Количество() > 0);
	
	НеучтенныеУчастники = Новый Массив;
	Для Каждого ДобавленныйНеучтенныйУчастник Из ДобавленныеНеучтенныеУчастники Цикл
		Если ДобавленныеУчастники.Найти(ДобавленныйНеучтенныйУчастник) <> Неопределено
			Или НеучтенныеУчастники.Найти(ДобавленныйНеучтенныйУчастник) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		НеучтенныеУчастники.Добавить(ДобавленныйНеучтенныйУчастник);
	КонецЦикла;
	ЕстьНеучтенныеУчастники = (НеучтенныеУчастники.Количество() > 0);
	
	Если Не ЕстьДобавленныеУчастники И Не ЕстьНеучтенныеУчастники Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстВопроса =НСтр("ru = 'При подборе времени мероприятия были добавлены новые участники.
		|Включить добавленных участников в мероприятие?'");
	
	Если ЕстьНеучтенныеУчастники Тогда
		Если ЕстьДобавленныеУчастники Тогда
			ДополнительныйТекстВопроса = НСтр("ru = 'Некоторые добавленные участники не отображаются в подборе времени.'");
		Иначе
			ДополнительныйТекстВопроса = НСтр("ru = 'Все добавленные участники не отображаются в подборе времени.'");
		КонецЕсли;
		ТекстВопроса = ТекстВопроса + Символы.ПС + Символы.ПС + ДополнительныйТекстВопроса;
	КонецЕсли;
	
	Если ЕстьНеучтенныеУчастники Тогда
		ТекстВариантаВключитьВсех = НСтр("ru = 'Включить всех'");
	Иначе
		ТекстВариантаВключитьВсех = НСтр("ru = 'Включить'");
	КонецЕсли;
	ТекстВариантаВключитьОтображаемых = НСтр("ru = 'Включить отображаемых'");
	ТекстВариантаНеВключать = НСтр("ru = 'Не включать'");
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(ТекстВариантаВключитьВсех);
	Если ЕстьНеучтенныеУчастники И ЕстьДобавленныеУчастники Тогда
		Кнопки.Добавить(ТекстВариантаВключитьОтображаемых);
	КонецЕсли;
	Кнопки.Добавить(КодВозвратаДиалога.Отмена, ТекстВариантаНеВключать);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДобавленныеУчастники", ДобавленныеУчастники);
	ПараметрыОбработчика.Вставить("НеучтенныеУчастники", НеучтенныеУчастники);
	ПараметрыОбработчика.Вставить("ТекстВариантаВключитьВсех", ТекстВариантаВключитьВсех);
	ПараметрыОбработчика.Вставить("ТекстВариантаВключитьОтображаемых", ТекстВариантаВключитьОтображаемых);
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьУчастниковПодбораВМероприятиеЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция ДобавитьУчастниковПодбораВМероприятиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДобавленныеУчастники = ДополнительныеПараметры.ДобавленныеУчастники;
	НеучтенныеУчастники = ДополнительныеПараметры.НеучтенныеУчастники;
	
	Если Результат = ДополнительныеПараметры.ТекстВариантаВключитьВсех Тогда
		Для Каждого НеучтенныйУчастник Из НеучтенныеУчастники Цикл
			ДобавленныеУчастники.Добавить(НеучтенныйУчастник);
		КонецЦикла;
	ИначеЕсли Результат = ДополнительныеПараметры.ТекстВариантаВключитьОтображаемых Тогда
		// ДобавленныеУчастники уже заполнен
	Иначе
		ДобавленныеУчастники.Очистить();
	КонецЕсли;
	
	Время = Новый Структура("ДатаНачала, ДатаОкончания, ДобавленныеУчастники");
	Время.ДатаНачала = ДатаНачала;
	Время.ДатаОкончания = ДатаОкончания;
	Время.ДобавленныеУчастники = ДобавленныеУчастники;
	
	Закрыть(Время);
	
КонецФункции

&НаКлиенте
Функция ПолучитьМассивУчастниковКлиент(УчастникМероприятия, УчитыватьВПлане = Неопределено)
	
	МассивУчастников = Новый Массив;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("УчастникМероприятия", УчастникМероприятия);
	Если УчитыватьВПлане <> Неопределено Тогда
		ПараметрыОтбора.Вставить("УчитыватьВПлане", УчитыватьВПлане);
	КонецЕсли;
	
	НайденныеСтроки = Участники.НайтиСтроки(ПараметрыОтбора);
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		
		Если Не ЗначениеЗаполнено(НайденнаяСтрока.Исполнитель)
			Или МассивУчастников.Найти(НайденнаяСтрока.Исполнитель) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		МассивУчастников.Добавить(НайденнаяСтрока.Исполнитель);
		
	КонецЦикла;
	
	Возврат МассивУчастников;
	
КонецФункции

#КонецОбласти