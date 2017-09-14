#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение списка сертификатов.
	Если Не Параметры.Свойство("СертификатыПользователя")
		ИЛИ ТипЗнч(Параметры.СертификатыПользователя) <> Тип("ТаблицаЗначений") Тогда
		
		ВызватьИсключение НСтр("ru = 'Не найдены сертификаты для подписания.'");
	КонецЕсли;
	Если Параметры.СертификатыПользователя.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Для Каждого Сертификат Из Параметры.СертификатыПользователя Цикл
		НоваяСтрока = Сертификаты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Сертификат);
	КонецЦикла;
	
	// Установка начальной видимости элементов.
	Элементы.ГруппаИнформацияДляУсиленных.Видимость = Ложь;
	
	// Обработка информационной надписи и заголовка формы.
	Элементы.ГруппаИнформация.Видимость = Параметры.Свойство("ИнформационнаяНадпись")
		И ЗначениеЗаполнено(Параметры.ИнформационнаяНадпись);
	Если Элементы.ГруппаИнформация.Видимость Тогда
		Элементы.ДекорацияИнформационнаяНадпись.Заголовок = Параметры.ИнформационнаяНадпись;
	КонецЕсли;
	
	ФайлСсылка = Неопределено;
	Если Параметры.Свойство("ОбъектСсылка") Тогда
		ФайлСсылка = Параметры.ОбъектСсылка;
	КонецЕсли;
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Подписать ""%1""'"),
		Строка(ФайлСсылка));
	Если Параметры.Свойство("ЗаголовокФормы") Тогда
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
	
	// Определение и вывод инструкций.
	ПоказыватьИнструкции = ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции");
	ПолучитьИнструкции();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если Сертификаты.Количество() = 0 Тогда
		ТекстПредупреждения = РаботаСЭПКлиентСервер.СообщениеОбОтсутствииУстановленныхСертификатов();
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки["ПоказыватьИнструкции"] <> Неопределено
		И ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции") Тогда
		
		ПолучитьИнструкции();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификаты

&НаКлиенте
Процедура СертификатыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СертификатУсиленный = Элемент.ТекущиеДанные.Усиленный;
	
	Элементы.Пароль.Доступность = Не СертификатУсиленный;
	Элементы.ГруппаИнформацияДляУсиленных.Видимость = СертификатУсиленный;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработкаВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификат(Команда)
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(Неопределено, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаВыбора()
	
	// Возвращаемое значение:
	//  Структура -
	//   Сертификат - СертификатКриптографии - выбранный сертификат.
	//   НастройкиКриптографии - Структура
	//    ПровайдерЭП - Строка
	//    ПутьМодуляКриптографии - Строка
	//    ТипПровайдераЭП - Число
	//    АлгоритмПодписи - Строка
	//    АлгоритмХеширования - Строка
	//    АлгоритмШифрования - Строка
	//   Пароль - Строка - Пароль к закрытому ключу.
	//   Комментарий - Комментарий к подписи.
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ВозвратПароль = Пароль;
	Если ПустаяСтрока(Пароль) И НЕ ПустаяСтрока(Элементы.Пароль.ТекстРедактирования) Тогда
		ВозвратПароль = Элементы.Пароль.ТекстРедактирования;
	КонецЕсли;
	
	ВыбранныйСертификат = ЭлектроннаяПодписьКлиент.ПолучитьСертификатПоОтпечатку(ТекущиеДанные.Отпечаток);
	НастройкиКриптографии = Новый Структура(
		"ПровайдерЭП,
		|ПутьМодуляКриптографии,
		|ТипПровайдераЭП,
		|АлгоритмПодписи,
		|АлгоритмХеширования,
		|АлгоритмШифрования");
	ЗаполнитьЗначенияСвойств(НастройкиКриптографии, ТекущиеДанные);
	
	// Проверка сертификата перед подписанием
	Попытка
		МассивРежимовПроверки = Новый Массив;
		МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.РазрешитьТестовыеСертификаты);
		МенеджерКриптографии = ЭлектроннаяПодписьКлиент.ПолучитьМенеджерКриптографии();
		МенеджерКриптографии.ПроверитьСертификат(ВыбранныйСертификат, МассивРежимовПроверки);
	Исключение
		ОшибкаИнфо = ИнформацияОбОшибке();
		
		ЗаписьОшибкиВЖурналРегистрации(
			НСтр("ru = 'Ошибка при проверке сертификата'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			ПодробноеПредставлениеОшибки(ОшибкаИнфо));
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
				|
				|Выберите другой сертификат или обратитесь к администратору.'",
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			КраткоеПредставлениеОшибки(ОшибкаИнфо));
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Ошибка подписания'"));
		ПараметрыФормы.Вставить("ТекстСообщения", ТекстСообщения);
		ОткрытьФорму("ОбщаяФорма.Сообщение", ПараметрыФормы, ЭтаФорма);
		
		Возврат;
	КонецПопытки;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Сертификат", ВыбранныйСертификат);
	СтруктураВозврата.Вставить("НастройкиКриптографии", НастройкиКриптографии);
	СтруктураВозврата.Вставить("Комментарий", Комментарий);
	
	Если ТекущиеДанные.Усиленный Тогда
		СтруктураВозврата.Вставить("Пароль", "");
	Иначе
		СтруктураВозврата.Вставить("Пароль", ВозвратПароль);
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Комментарий) Тогда
		ЗаписатьВводимыеЗначения();
	КонецЕсли;
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписьОшибкиВЖурналРегистрации(ИмяСобытия, ТекстОшибки)
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , ТекстОшибки);
	
КонецПроцедуры

&НаСервере
Функция ЭлементыДляСохранения()
	
	СохраняемыеЭлементы = Новый Структура;
	СохраняемыеЭлементы.Вставить("Комментарий", Комментарий);
	
	Возврат СохранениеВводимыхЗначений.СформироватьТаблицуСохраняемыхЭлементов(СохраняемыеЭлементы);
	
КонецФункции

&НаСервере
Процедура ЗаписатьВводимыеЗначения()
	
	СохранениеВводимыхЗначений.ОбновитьСпискиВыбора(ЭтаФорма, ЭлементыДляСохранения(), ЭтаФорма.ИмяФормы);
	
КонецПроцедуры	

#Область РаботаСИнструкциями

&НаСервере
Процедура ПолучитьИнструкции()
	
	РаботаСИнструкциями.ПолучитьИнструкции(ЭтаФорма, 70, 100);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСИнструкциямиКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element, Элемент.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьИнструкции(Команда)
	
	ПоказыватьИнструкции = Не ПоказыватьИнструкции;
	ПолучитьИнструкции();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
