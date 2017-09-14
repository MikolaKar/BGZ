
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.РежимОткрытияОкна <> Неопределено Тогда
		РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
	КонецЕсли;
	
	Если Параметры.ТабличныйДокумент.ВысотаТаблицы = 0 Тогда
		Если Не ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета) Тогда
			ЗагрузитьТабличныйДокументИзМетаданных();
		КонецЕсли;
	Иначе
		ТабличныйДокумент = Параметры.ТабличныйДокумент;
	КонецЕсли;
	
	Элементы.ТабличныйДокумент.Редактирование = Параметры.Редактирование;
	Элементы.ТабличныйДокумент.ОтображатьГруппировки = Истина;
	
	ЭтоМакет = Не ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета);
	Элементы.Предупреждение.Видимость = ЭтоМакет И Параметры.Редактирование;
	
	Если Не ПустаяСтрока(Параметры.ИмяДокумента) Тогда
		ИмяДокумента = Параметры.ИмяДокумента;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(Параметры.ПутьКФайлу) Тогда
		Файл = Новый Файл(Параметры.ПутьКФайлу);
		Если ПустаяСтрока(ИмяДокумента) Тогда
			ИмяДокумента = Файл.ИмяБезРасширения;
		КонецЕсли;
		РедактированиеЗапрещено = Файл.ПолучитьТолькоЧтение();
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяДокумента) Тогда
		ИспользованныеИмена = Новый Массив;
		Оповестить("ЗапросИменРедактируемыхТабличныхДокументов", ИспользованныеИмена, ЭтотОбъект);
		
		Индекс = 1;
		Пока ИспользованныеИмена.Найти(ИмяНовогоДокумента() + Индекс) <> Неопределено Цикл
			Индекс = Индекс + 1;
		КонецЦикла;
		
		ИмяДокумента = ИмяНовогоДокумента() + Индекс;
	КонецЕсли;
	
	Элементы.ТабличныйДокумент.Редактирование = Элементы.ТабличныйДокумент.Редактирование Или Не ПустаяСтрока(Параметры.ПутьКФайлу) И Не РедактированиеЗапрещено;
	
	УстановитьЗаголовок();
	НастроитьПредставлениеКоманд();
	НастроитьОтображениеТабличногоДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сохранить изменения в %1?'"), ИмяДокумента);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодтвердитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОписаниеОповещения, Отказ, ТекстВопроса);
	
	Если Не Модифицированность Тогда
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ПутьКФайлу", Параметры.ПутьКФайлу);
		ПараметрыОповещения.Вставить("ИмяОбъектаМетаданныхМакета", Параметры.ИмяОбъектаМетаданныхМакета);
		Если ЗаписьВыполнена Тогда
			ИмяСобытия = "Запись_ТабличныйДокумент";
			ПараметрыОповещения.Вставить("ТабличныйДокумент", ТабличныйДокумент);
		Иначе
			ИмяСобытия = "ОтменаРедактированияТабличногоДокумента";
		КонецЕсли;
		Оповестить(ИмяСобытия, ПараметрыОповещения, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	Если ЗаписатьТабличныйДокумент() Тогда 
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗапросИменРедактируемыхТабличныхДокументов" И Источник <> ЭтотОбъект Тогда
		Параметр.Добавить(ИмяДокумента);
	ИначеЕсли ИмяСобытия = "ЗакрытиеФормыВладельца" И Источник = ВладелецФормы Тогда
		Закрыть();
		Если Открыта() Тогда
			Параметр.Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТабличныйДокументПриАктивизацииОбласти(Элемент)
	ОбновитьПометкиКнопокКоманднойПанели();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Действия с документом

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Если ЗаписатьТабличныйДокумент() Тогда 
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьТабличныйДокумент();
КонецПроцедуры

&НаКлиенте
Процедура Редактирование(Команда)
	Элементы.ТабличныйДокумент.Редактирование = Не Элементы.ТабличныйДокумент.Редактирование;
	НастроитьПредставлениеКоманд();
	НастроитьОтображениеТабличногоДокумента();
КонецПроцедуры

// Форматирование

&НаКлиенте
Процедура Шрифт(Команда)
	
	ДиалогВыбораШрифта = Новый ДиалогВыбораШрифта;
	
	ОбрабатываемыеОбласти = СписокОбластейДляИзмененияШрифта();
	Если ОбрабатываемыеОбласти.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	#Если Не ВебКлиент Тогда
		ОбщийШрифт = Новый Шрифт(ОбрабатываемыеОбласти[0].Шрифт);
		
		Для НомерОбласти = 1 По ОбрабатываемыеОбласти.Количество()-1 Цикл
			Область = ОбрабатываемыеОбласти[НомерОбласти];
			Если Область.Шрифт <> ОбщийШрифт Тогда
				ИмяШрифта = ?(Область.Шрифт.Имя = ОбщийШрифт.Имя, Неопределено, "");
				Размер = ?(Область.Шрифт.Размер = ОбщийШрифт.Размер, Неопределено, 0);
				Жирный = ?(Область.Шрифт.Жирный = ОбщийШрифт.Жирный, Неопределено, Ложь);
				Наклонный = ?(Область.Шрифт.Наклонный = ОбщийШрифт.Наклонный, Неопределено, Ложь);
				Подчеркнутый = ?(Область.Шрифт.Подчеркивание = ОбщийШрифт.Подчеркивание, Неопределено, Ложь);
				Зачеркнутый = ?(Область.Шрифт.Подчеркивание = ОбщийШрифт.Зачеркивание, Неопределено, Ложь);
				
				ОбщийШрифт = Новый Шрифт(ОбрабатываемыеОбласти[0].Шрифт, ИмяШрифта, Размер, Жирный, Наклонный, Подчеркнутый, Зачеркнутый);
			КонецЕсли;
		КонецЦикла;
		ДиалогВыбораШрифта.Шрифт = ОбщийШрифт;
	#КонецЕсли
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииВыбораШрифта", ЭтотОбъект, ОбрабатываемыеОбласти);
	ДиалогВыбораШрифта.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура УвеличитьРазмерШрифта(Команда)
	
	Для Каждого Область Из СписокОбластейДляИзмененияШрифта() Цикл
		Размер = Область.Шрифт.Размер;
		Размер = Размер + ШагИзмененияРазмераШрифтаУвеличение(Размер);
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,Размер);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УменьшитьРазмерШрифта(Команда)
	
	Для Каждого Область Из СписокОбластейДляИзмененияШрифта() Цикл
		Размер = Область.Шрифт.Размер;
		Размер = Размер - ШагИзмененияРазмераШрифтаУменьшение(Размер);
		Если Размер < 1 Тогда
			Размер = 1;
		КонецЕсли;
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,Размер);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Полужирный(Команда)
	
	УстанавливаемоеЗначение = Неопределено;
	Для Каждого Область Из СписокОбластейДляИзмененияШрифта() Цикл
		Если УстанавливаемоеЗначение = Неопределено Тогда
			УстанавливаемоеЗначение = Не Область.Шрифт.Жирный = Истина;
		КонецЕсли;
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,,УстанавливаемоеЗначение);
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура Курсив(Команда)
	
	УстанавливаемоеЗначение = Неопределено;
	Для Каждого Область Из СписокОбластейДляИзмененияШрифта() Цикл
		Если УстанавливаемоеЗначение = Неопределено Тогда
			УстанавливаемоеЗначение = Не Область.Шрифт.Наклонный = Истина;
		КонецЕсли;
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,,,УстанавливаемоеЗначение);
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура Подчеркивание(Команда)
	
	УстанавливаемоеЗначение = Неопределено;
	Для Каждого Область Из СписокОбластейДляИзмененияШрифта() Цикл
		Если УстанавливаемоеЗначение = Неопределено Тогда
			УстанавливаемоеЗначение = Не Область.Шрифт.Подчеркивание = Истина;
		КонецЕсли;
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,,,,УстанавливаемоеЗначение);
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура Зачеркивание(Команда)
	
	УстанавливаемоеЗначение = Неопределено;
	Для Каждого Область Из СписокОбластейДляИзмененияШрифта() Цикл
		Если УстанавливаемоеЗначение = Неопределено Тогда
			УстанавливаемоеЗначение = Не Область.Шрифт.Зачеркивание = Истина;
		КонецЕсли;
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,,,,,УстанавливаемоеЗначение);
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦветФона(Команда)
	ДиалогВыбораЦвета = Новый ДиалогВыбораЦвета;
	#Если Не ВебКлиент Тогда
	ДиалогВыбораЦвета.Цвет = Элементы.ТабличныйДокумент.ТекущаяОбласть.ЦветФона;
	#КонецЕсли
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииВыбораЦветаФона", ЭтотОбъект);
	ДиалогВыбораЦвета.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ЦветТекста(Команда)
	ДиалогВыбораЦвета = Новый ДиалогВыбораЦвета;
	#Если Не ВебКлиент Тогда
	ДиалогВыбораЦвета.Цвет = Элементы.ТабличныйДокумент.ТекущаяОбласть.ЦветТекста;
	#КонецЕсли
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииВыбораЦветаТекста", ЭтотОбъект);
	ДиалогВыбораЦвета.Показать(ОписаниеОповещения);
КонецПроцедуры

// Выравнивание

&НаКлиенте
Процедура Влево(Команда)
	
	Для Каждого Область Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура Вправо(Команда)
	
	Для Каждого Область Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Право;
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоЦентру(Команда)
	
	Для Каждого Область Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоШирине(Команда)
	
	Для Каждого Область Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.ПоШирине;
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

// Границы

&НаКлиенте
Процедура ГраницаСлева(Команда)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	Для Каждого ОбрабатываемаяОбласть Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		НарисоватьГраницуСлева(ОбрабатываемаяОбласть, Линия);
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ГраницаСверху(Команда)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	Для Каждого ОбрабатываемаяОбласть Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		НарисоватьГраницуСверху(ОбрабатываемаяОбласть, Линия);
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ГраницаСправа(Команда)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	Для Каждого ОбрабатываемаяОбласть Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		НарисоватьГраницуСправа(ОбрабатываемаяОбласть, Линия);
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ГраницаСнизу(Команда)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	Для Каждого ОбрабатываемаяОбласть Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		НарисоватьГраницуСнизу(ОбрабатываемаяОбласть, Линия);
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ГраницаВезде(Команда)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	Для Каждого Область Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		Область.ГраницаСлева = Линия;
		Область.ГраницаСверху = Линия;
		Область.ГраницаСправа = Линия;
		Область.ГраницаСнизу = Линия;
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ГраницаВокруг(Команда)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	Для Каждого Область Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		#Если ВебКлиент Тогда
			НарисоватьГраницуСлева(Область, Линия);
			НарисоватьГраницуСверху(Область, Линия);
			НарисоватьГраницуСправа(Область, Линия);
			НарисоватьГраницуСнизу(Область, Линия);
		#Иначе
			Область.Обвести(Линия, Линия, Линия, Линия);
		#КонецЕсли
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ГраницаВнутри(Команда)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	Для Каждого ОбрабатываемаяОбласть Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		
		Если ОбрабатываемаяОбласть.Лево <> ОбрабатываемаяОбласть.Право Тогда
			Область = ТабличныйДокумент.Область(
			Элементы.ТабличныйДокумент.ТекущаяОбласть.Верх,
			Элементы.ТабличныйДокумент.ТекущаяОбласть.Лево + 1,
			Элементы.ТабличныйДокумент.ТекущаяОбласть.Низ,
			Элементы.ТабличныйДокумент.ТекущаяОбласть.Право);
			
			Область.ГраницаСлева = Линия;
		КонецЕсли;
		
		Если ОбрабатываемаяОбласть.Верх <> ОбрабатываемаяОбласть.Низ Тогда
			Область = ТабличныйДокумент.Область(
			Элементы.ТабличныйДокумент.ТекущаяОбласть.Верх + 1,
			Элементы.ТабличныйДокумент.ТекущаяОбласть.Лево,
			Элементы.ТабличныйДокумент.ТекущаяОбласть.Низ,
			Элементы.ТабличныйДокумент.ТекущаяОбласть.Право);
			
			Область.ГраницаСверху = Линия;
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ТолстаяГраницаВокруг(Команда)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2);
	
	Для Каждого Область Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		#Если ВебКлиент Тогда
			НарисоватьГраницуСлева(Область, Линия);
			НарисоватьГраницуСверху(Область, Линия);
			НарисоватьГраницуСправа(Область, Линия);
			НарисоватьГраницуСнизу(Область, Линия);
		#Иначе
			Область.Обвести(Линия, Линия, Линия, Линия);
		#КонецЕсли
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ТолстаяГраницаСверху(Команда)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2);
	
	Для Каждого ОбрабатываемаяОбласть Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		НарисоватьГраницуСверху(ОбрабатываемаяОбласть, Линия);
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ТолстаяГраницаСнизу(Команда)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 2);
	
	Для Каждого ОбрабатываемаяОбласть Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		НарисоватьГраницуСнизу(ОбрабатываемаяОбласть, Линия);
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура НетГраницы(Команда)
	
	Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.НетЛинии);

	Область = Элементы.ТабличныйДокумент.ТекущаяОбласть;
	Область.ГраницаСлева = Линия;
	Область.ГраницаСверху = Линия;
	Область.ГраницаСправа = Линия;
	Область.ГраницаСнизу = Линия;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

// Действия с областью

&НаКлиенте
Процедура Объединить(Команда)
	
	Область = Элементы.ТабличныйДокумент.ТекущаяОбласть;
	Область.Объединить();
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура Разъединить(Команда)
	
	Область = Элементы.ТабличныйДокумент.ТекущаяОбласть;
	Область.Разъединить();
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьПримечание(Команда)
	Примечание = Элементы.ТабличныйДокумент.ТекущаяОбласть.Примечание.Текст;
	ОписаниеОповещения = Новый ОписаниеОповещения("ВставитьПримечаниеЗавершение", ЭтотОбъект);
	ПоказатьВводСтроки(ОписаниеОповещения, Примечание, НСтр("ru = 'Примечание'"), , Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьТабличныйДокументИзМетаданных()
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
		ТабличныйДокумент = МодульУправлениеПечатью.МакетПечатнойФормы(Параметры.ИмяОбъектаМетаданныхМакета);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтображениеТабличногоДокумента()
	Элементы.ТабличныйДокумент.ОтображатьЗаголовки = Элементы.ТабличныйДокумент.Редактирование;
	Элементы.ТабличныйДокумент.ОтображатьСетку = Элементы.ТабличныйДокумент.Редактирование;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПометкиКнопокКоманднойПанели();
	
	#Если Не ВебКлиент Тогда
	Область = Элементы.ТабличныйДокумент.ТекущаяОбласть;
	Если ТипЗнч(Область) <> Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		Возврат;
	КонецЕсли;
	
	// Шрифт
	Шрифт = Область.Шрифт;
	Элементы.Полужирный.Пометка = Шрифт <> Неопределено И Шрифт.Жирный = Истина;
	Элементы.Курсив.Пометка = Шрифт <> Неопределено И Шрифт.Наклонный = Истина;
	Элементы.Подчеркивание.Пометка = Шрифт <> Неопределено И Шрифт.Подчеркивание = Истина;
	Элементы.Зачеркивание.Пометка = Шрифт <> Неопределено И Шрифт.Зачеркивание = Истина;
	
	// Горизонтальное положение
	Элементы.Влево.Пометка = Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
	Элементы.ПоЦентру.Пометка = Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	Элементы.Вправо.Пометка = Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Право;
	Элементы.ПоШирине.Пометка = Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.ПоШирине;
	
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Функция ШагИзмененияРазмераШрифтаУвеличение(Размер)
	Если Размер = -1 Тогда
		Возврат 10;
	КонецЕсли;
	
	Если Размер < 10 Тогда
		Возврат 1;
	ИначеЕсли 10 <= Размер И  Размер < 20 Тогда
		Возврат 2;
	ИначеЕсли 20 <= Размер И  Размер < 48 Тогда
		Возврат 4;
	ИначеЕсли 48 <= Размер И  Размер < 72 Тогда
		Возврат 6;
	ИначеЕсли 72 <= Размер И  Размер < 96 Тогда
		Возврат 8;
	Иначе
		Возврат Окр(Размер / 10);
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция ШагИзмененияРазмераШрифтаУменьшение(Размер)
	Если Размер = -1 Тогда
		Возврат -8;
	КонецЕсли;
	
	Если Размер <= 11 Тогда
		Возврат 1;
	ИначеЕсли 11 < Размер и Размер <= 23 Тогда
		Возврат 2;
	ИначеЕсли 23 < Размер и Размер <= 53 Тогда
		Возврат 4;
	ИначеЕсли 53 < Размер и Размер <= 79 Тогда
		Возврат 6;
	ИначеЕсли 79 < Размер и Размер <= 105 Тогда
		Возврат 8;
	Иначе
		Возврат Окр(Размер / 11);
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция СписокОбластейДляИзмененияШрифта()
	
	Результат = Новый Массив;
	
	Для Каждого ОбрабатываемаяОбласть Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		Если ОбрабатываемаяОбласть.Шрифт <> Неопределено Тогда
			Результат.Добавить(ОбрабатываемаяОбласть);
			Продолжить;
		КонецЕсли;
		
		ОбрабатываемаяОбластьВерх = ОбрабатываемаяОбласть.Верх;
		ОбрабатываемаяОбластьНиз = ОбрабатываемаяОбласть.Низ;
		ОбрабатываемаяОбластьЛево = ОбрабатываемаяОбласть.Лево;
		ОбрабатываемаяОбластьПраво = ОбрабатываемаяОбласть.Право;
		
		Если ОбрабатываемаяОбластьВерх = 0 Тогда
			ОбрабатываемаяОбластьВерх = 1;
		КонецЕсли;
		
		Если ОбрабатываемаяОбластьНиз = 0 Тогда
			ОбрабатываемаяОбластьНиз = ТабличныйДокумент.ВысотаТаблицы;
		КонецЕсли;
		
		Если ОбрабатываемаяОбластьЛево = 0 Тогда
			ОбрабатываемаяОбластьЛево = 1;
		КонецЕсли;
		
		Если ОбрабатываемаяОбластьПраво = 0 Тогда
			ОбрабатываемаяОбластьПраво = ТабличныйДокумент.ШиринаТаблицы;
		КонецЕсли;
		
		Если ОбрабатываемаяОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Колонки Тогда
			ОбрабатываемаяОбластьВерх = ОбрабатываемаяОбласть.Низ;
			ОбрабатываемаяОбластьНиз = ТабличныйДокумент.ВысотаТаблицы;
		КонецЕсли;
			
		Для НомерКолонки = ОбрабатываемаяОбластьЛево По ОбрабатываемаяОбластьПраво Цикл
			ШиринаКолонки = Неопределено;
			Для НомерСтроки = ОбрабатываемаяОбластьВерх По ОбрабатываемаяОбластьНиз Цикл
				Ячейка = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
				Если ОбрабатываемаяОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Колонки Тогда
					Если ШиринаКолонки = Неопределено Тогда
						ШиринаКолонки = Ячейка.ШиринаКолонки;
					КонецЕсли;
					Если Ячейка.ШиринаКолонки <> ШиринаКолонки Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				Если Ячейка.Шрифт <> Неопределено Тогда
					Результат.Добавить(Ячейка);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ЗаписатьТабличныйДокумент()
	
	Если ЭтоНовый() Или РедактированиеЗапрещено Тогда
		ДиалогСохраненияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		ДиалогСохраненияФайла.ПолноеИмяФайла = ИмяДокумента;
		ДиалогСохраненияФайла.Фильтр = НСтр("ru = 'Табличный документ'") + " (*.mxl)|*.mxl";
		Если ДиалогСохраненияФайла.Выбрать() Тогда
			Параметры.ПутьКФайлу = ДиалогСохраненияФайла.ПолноеИмяФайла;
			ИмяДокумента = Сред(ДиалогСохраненияФайла.ПолноеИмяФайла, СтрДлина(ДиалогСохраненияФайла.Каталог) + 1);
			Если Нрег(Прав(ИмяДокумента, 4)) = ".mxl" Тогда
				ИмяДокумента = Лев(ИмяДокумента, СтрДлина(ИмяДокумента) - 4);
			КонецЕсли;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
		
	Если Не ПустаяСтрока(Параметры.ПутьКФайлу) Тогда
		ТабличныйДокумент.Записать(Параметры.ПутьКФайлу);
		РедактированиеЗапрещено = Ложь;
	КонецЕсли;
	
	ЗаписьВыполнена = Истина;
	Модифицированность = Ложь;
	УстановитьЗаголовок();
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция ИмяНовогоДокумента()
	Возврат НСтр("ru = 'Новый'");
КонецФункции

&НаКлиенте
Процедура УстановитьЗаголовок()
	
	Заголовок = ИмяДокумента;
	Если ЭтоНовый() Тогда
		Заголовок = Заголовок + " (" + НСтр("ru = 'создание'") + ")";
	ИначеЕсли РедактированиеЗапрещено Тогда
		Заголовок = Заголовок + " (" + НСтр("ru = 'только просмотр'") + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПредставлениеКоманд()
	
	ДокументРедактируется = Элементы.ТабличныйДокумент.Редактирование;
	Элементы.Редактирование.Пометка = ДокументРедактируется;
	Элементы.КомандыРедактирования.Доступность = ДокументРедактируется;
	Элементы.ЗаписатьИЗакрыть.Доступность = ДокументРедактируется Или Модифицированность;
	Элементы.Записать.Доступность = ДокументРедактируется Или Модифицированность;
	
	Если ДокументРедактируется И Не ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета) Тогда
		Элементы.Предупреждение.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЭтоНовый()
	Возврат ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета) И ПустаяСтрока(Параметры.ПутьКФайлу);
КонецФункции

&НаКлиенте
Процедура НарисоватьГраницуСлева(ОбрабатываемаяОбласть, Линия)
	
	Область = ТабличныйДокумент.Область(
		ОбрабатываемаяОбласть.Верх,
		ОбрабатываемаяОбласть.Лево,
		ОбрабатываемаяОбласть.Низ,
		ОбрабатываемаяОбласть.Лево);
	
	Область.ГраницаСлева = Линия;
	
КонецПроцедуры

&НаКлиенте
Процедура НарисоватьГраницуСверху(ОбрабатываемаяОбласть, Линия)
	
	Область = ТабличныйДокумент.Область(
		ОбрабатываемаяОбласть.Верх,
		ОбрабатываемаяОбласть.Лево,
		ОбрабатываемаяОбласть.Верх,
		ОбрабатываемаяОбласть.Право);
	
	Область.ГраницаСверху = Линия;
	
КонецПроцедуры

&НаКлиенте
Процедура НарисоватьГраницуСправа(ОбрабатываемаяОбласть, Линия)
	
	Область = ТабличныйДокумент.Область(
		ОбрабатываемаяОбласть.Верх,
		ОбрабатываемаяОбласть.Право,
		ОбрабатываемаяОбласть.Низ,
		ОбрабатываемаяОбласть.Право);
	
	Область.ГраницаСправа = Линия;
	
КонецПроцедуры

&НаКлиенте
Процедура НарисоватьГраницуСнизу(ОбрабатываемаяОбласть, Линия)
	
	Область = ТабличныйДокумент.Область(
		ОбрабатываемаяОбласть.Низ,
		ОбрабатываемаяОбласть.Лево,
		ОбрабатываемаяОбласть.Низ,
		ОбрабатываемаяОбласть.Право);
	
	Область.ГраницаСнизу = Линия;
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьПримечаниеЗавершение(Строка, ДополнительныеПараметры) Экспорт
	Если Строка <> Неопределено Тогда
		Элементы.ТабличныйДокумент.ТекущаяОбласть.Примечание.Текст = Строка;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииВыбораШрифта(ВыбранныйШрифт, ОбрабатываемыеОбласти) Экспорт
	
	Если ВыбранныйШрифт = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Область Из ОбрабатываемыеОбласти Цикл
		Область.Шрифт = ВыбранныйШрифт;
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииВыбораЦветаФона(ВыбранныйЦвет, ДополнительныеПараметры) Экспорт
	Если ВыбранныйЦвет <> Неопределено Тогда
		Элементы.ТабличныйДокумент.ТекущаяОбласть.ЦветФона = ВыбранныйЦвет;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииВыбораЦветаТекста(ВыбранныйЦвет, ДополнительныеПараметры) Экспорт
	Если ВыбранныйЦвет <> Неопределено Тогда
		Элементы.ТабличныйДокумент.ТекущаяОбласть.ЦветТекста = ВыбранныйЦвет;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
