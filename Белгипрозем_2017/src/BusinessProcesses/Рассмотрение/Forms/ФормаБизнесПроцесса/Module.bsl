

#Область ОбработчикиСобытийФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПредметы

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПредметыВыборПродолжение",
		ЭтотОбъект);
	МультипредметностьКлиент.ПредметыПроцессаИзменитьПредмет(ЭтаФорма, Объект, ВыбраннаяСтрока, СтандартнаяОбработка, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыВыборПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПредметыПредметПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПредметыПередНачаломДобавленияПродолжение",
		ЭтотОбъект);
	МультипредметностьКлиент.ПредметыПроцессаПередНачаломДобавления(ЭтаФорма, Объект, Отказ, Копирование, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередНачаломДобавленияПродолжение(Результат, Параметры) Экспорт
	
	ПредметыПредметПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ВыбраннаяСтрока = Элементы.Предметы.ТекущаяСтрока;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ИзменитьПредметПродолжение",
			ЭтотОбъект);
		МультипредметностьКлиент.ПредметыПроцессаИзменитьПредмет(ЭтаФорма, Объект, ВыбраннаяСтрока,, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередУдалением(Элемент, Отказ)
	
	МультипредметностьКлиент.ПредметыПередУдалением(ЭтаФорма, Объект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПослеУдаления(Элемент)
	
	МультипредметностьКлиентСервер.УстановитьДоступностьКнопокУправленияПредметами(ЭтаФорма);
	ПредметыПредметПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	МультипредметностьКлиент.ОбработкаПеретаскиванияВСписокПредметовПроцесса(
		ЭтаФорма, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыОписаниеПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Предметы.ТекущиеДанные;
	
	ТекущаяСтрока.РольПредмета = ПредопределенноеЗначение("Перечисление.РолиПредметов."+ТекущаяСтрока.Описание);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПредметыОписаниеПриИзменении_Продолжение",
		ЭтотОбъект);
	МультипредметностьКлиент.ПредметыПроцессаИзменитьПредмет(ЭтаФорма, Объект, ТекущаяСтрока.ПолучитьИдентификатор(),, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыОписаниеПриИзменении_Продолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ПредметыПредметПриИзменении();
	Иначе
		ТекущаяСтрока = Элементы.Предметы.ТекущиеДанные;
		Если ТекущаяСтрока <> Неопределено
			И НЕ ЗначениеЗаполнено(ТекущаяСтрока.ИмяПредмета) Тогда
			
			Объект.Предметы.Удалить(ТекущаяСтрока);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьОсновной(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения
		("ДобавитьОсновнойПродолжение",
		ЭтотОбъект);
	МультипредметностьКлиент.ПредметыДобавитьОсновной(ЭтаФорма, Объект, Истина, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОсновнойПродолжение(Результат, Параметры) Экспорт
	
	ПредметыПредметПриИзменении();	
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВспомогательный(Команда)
	
	МультипредметностьКлиент.ПредметыДобавитьВспомогательный(ЭтаФорма, Объект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПредмет(Команда)
	
	ВыбраннаяСтрока = Элементы.Предметы.ТекущаяСтрока;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ИзменитьПредметПродолжение",
			ЭтотОбъект);
		МультипредметностьКлиент.ПредметыПроцессаИзменитьПредмет(ЭтаФорма, Объект, ВыбраннаяСтрока,, ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПредметПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПредметыПредметПриИзменении();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПредметыПредметПриИзменении()
	
	ПредметыПредметПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьДоступность()
	
	ПравоНаИзменение = Истина;
	Если НЕ Объект.Ссылка.Пустая() Тогда
		ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка);
		ПравоНаИзменение = ПраваПоОбъекту.Изменение;
	КонецЕсли;
	
	Если Объект.Завершен
		ИЛИ Не ПравоНаИзменение Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
		Элементы.ФормаСтартИЗакрыть.Доступность = Ложь;
		Элементы.ФормаЗаписатьИЗакрыть.Доступность = Ложь;
		Элементы.Резолюция.Заголовок = НСтр("ru = 'Резолюция'");
		Элементы.Исполнитель.ТолькоПросмотр = ТолькоПросмотр;
	КонецЕсли;
	
	ПереносСроковВыполненияЗадач.УстановкаДоступностиЭлементовФормы(Объект, Элементы);
	
	Если Объект.Стартован Тогда
		Элементы.Резолюция.ТолькоПросмотр = Истина;
		Элементы.ЗаполнитьПоШаблону.Доступность = Ложь;
		Элементы.ФормаСтартИЗакрыть.Доступность = Ложь;
	КонецЕсли;	
	
	Элементы.ГруппаИнфо.Видимость = Не Объект.Ссылка.Пустая();
	Элементы.Длительность.Видимость = Не Объект.Ссылка.Пустая();
	Элементы.ГлавнаяЗадача.Видимость = ЗначениеЗаполнено(Объект.ГлавнаяЗадача);
	Элементы.ФормаУстановитьГлавнуюЗадачу.Видимость = НЕ ЗначениеЗаполнено(Объект.ВедущаяЗадача);
	
	Элементы.ФормаПометитьНаУдаление.Доступность =
		РаботаСБизнесПроцессами.ПроверитьДоступностьПометкиУдаленияБизнесПроцесса(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоШаблонуНаСервере(Шаблон) 
	
	БизнесПроцессОбъект = РеквизитФормыВЗначение("Объект");
	ИсходныеПредметы = Объект.Предметы.Выгрузить();
	БизнесПроцессОбъект.ЗаполнитьПоШаблону(Шаблон);
	Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(Шаблон, БизнесПроцессОбъект);
	Мультипредметность.ПередатьПредметыПроцессу(БизнесПроцессОбъект, ИсходныеПредметы, Ложь, Истина);
	РаботаСБизнесПроцессами.СкопироватьЗначенияДопРеквизитовВФормуБизнесПроцесса(Шаблон, ЭтаФорма);
	ОбновитьЭлементыДополнительныхРеквизитов();
	ЗначениеВРеквизитФормы(БизнесПроцессОбъект, "Объект");
	МультипредметностьКлиентСервер.ЗаполнитьТаблицуПредметовФормы(Объект);
	Мультипредметность.ОбработатьОписаниеПредметовПроцесса(Объект);
	
	// Заполняем строковое представление участников
	ИсполнительСтрокой = РаботаСБизнесПроцессамиКлиентСервер.ПредставлениеУчастникаПроцесса(
		Объект.Исполнитель,
		Объект.ОсновнойОбъектАдресации,
		Объект.ДополнительныйОбъектАдресации);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоПроектнойЗадачеНаСервере(ПроектнаяЗадача) 
	
	БизнесПроцессОбъект = РеквизитФормыВЗначение("Объект");
	БизнесПроцессОбъект.ЗаполнитьПоПроектнойЗадаче(ПроектнаяЗадача);
	ЗначениеВРеквизитФормы(БизнесПроцессОбъект, "Объект");
	МультипредметностьКлиентСервер.ЗаполнитьТаблицуПредметовФормы(Объект);
	Мультипредметность.ОбработатьОписаниеПредметовПроцесса(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПоШаблону()
	
	Если Не ЗначениеЗаполнено(Объект.Шаблон) И Не ЗначениеЗаполнено(Объект.ВедущаяЗадача) Тогда 
		Возврат;
	КонецЕсли;
	
	ДоступностьПоШаблону = ШаблоныБизнесПроцессов.ДоступностьПоШаблону(Объект);
	
	Если ЗначениеЗаполнено(Объект.СрокИсполнения) Тогда 
		Элементы.СрокИсполнения.ТолькоПросмотр = Не ДоступностьПоШаблону;
		Элементы.СрокИсполненияВремя.ТолькоПросмотр = Не ДоступностьПоШаблону;
	Иначе
		Элементы.СрокИсполнения.ТолькоПросмотр = Ложь;
		Элементы.СрокИсполненияВремя.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Исполнитель) Тогда 
		Элементы.Исполнитель.ТолькоПросмотр = Не ДоступностьПоШаблону;
	Иначе
		Элементы.Исполнитель.ТолькоПросмотр = Ложь;
	КонецЕсли;
	Элементы.Исполнитель.ТолькоПросмотр = Элементы.Исполнитель.ТолькоПросмотр ИЛИ ТолькоПросмотр;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеПроекта()
	
	ЕдиницаТрудозатрат = Константы.ОсновнаяЕдиницаТрудозатрат.Получить();
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
		ПроектЗадача = РаботаСПроектамиКлиентСервер.ПредставлениеПроектаЗадачи(Объект.Проект, Объект.ПроектнаяЗадача);	
		Если ЗначениеЗаполнено(Объект.ПроектнаяЗадача) Тогда 
			ЕдиницаТрудозатрат = Объект.ПроектнаяЗадача.ТекущийПланЕдиницаТрудозатрат;
		ИначеЕсли ЗначениеЗаполнено(Объект.Проект) Тогда 
			ЕдиницаТрудозатрат = Объект.Проект.ЕдиницаТрудозатратЗадач;
		КонецЕсли;
	КонецЕсли;
	
	ЕдиницаТрудозатратСтр = ВРег(Лев(ЕдиницаТрудозатрат, 1)) + Сред(ЕдиницаТрудозатрат, 2);	
	Элементы.ТрудозатратыПланИсполнителя.Заголовок = ЕдиницаТрудозатратСтр;
	Элементы.ТрудозатратыПланАвтора.Заголовок = ЕдиницаТрудозатратСтр;
	
КонецПроцедуры	


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПротоколированиеРаботыПользователей.ЗаписатьОткрытие(Объект.Ссылка);
	РаботаСПоследнимиОбъектами.ЗаписатьОбращениеКОбъекту(Объект.Ссылка);
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, Объект, "ГруппаДополнительныеРеквизиты");
	Мультипредметность.УстановитьЗначенияДопРеквизитовИДоступностьЭлементовФормыПроцесса(ЭтаФорма, Объект);
	
	Копирование = ЗначениеЗаполнено(Параметры.ЗначениеКопирования);
	
	Если Объект.Ссылка.Пустая() И Объект.Исполнитель = Неопределено Тогда 
		Объект.Исполнитель = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
	ВестиУчетПоПроектам = ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам");
	ИзменятьЗаданияЗаднимЧислом = ПолучитьФункциональнуюОпцию("ИзменятьЗаданияЗаднимЧислом");
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ИзменитьСрок.Видимость = Параметры.Свойство("ЗаявкаНаПеренос", ЗаявкаНаПереносСрока)
		И ЗначениеЗаполнено(ЗаявкаНаПереносСрока);
		
	ПолучитьДанныеПроекта();
	
	Если Объект.Стартован Тогда
		Если Объект.Завершен Тогда
			Длительность = ДелопроизводствоКлиентСервер.РазностьДатВДнях(Объект.ДатаЗавершения, Объект.ДатаНачала);
		Иначе
			Длительность = ДелопроизводствоКлиентСервер.РазностьДатВДнях(ТекущаяДатаСеанса(), Объект.ДатаНачала);
		КонецЕсли;
	КонецЕсли;
	
	ОтложенныйСтартБизнесПроцессовСервер.
		ЗаполнитьРеквизитНастройкаОтложенногоСтартаВФормеПроцесса(ЭтаФорма);
		
	// Сохранение вводимых значений
	СохранениеВводимыхЗначений.ОбновитьСпискиВыбора(ЭтаФорма, ЭлементыДляСохранения(), ЭтаФорма.ИмяФормы);
		
	ОбновитьДоступностьЭлементовФормыПоСостояниюПроцесса();
	
	УстановитьДоступностьПоШаблону();
	УстановитьДоступность();
	
	УстановитьПривилегированныйРежим(Истина);
	ПредыдущееОписаниеПредметов = МультипредметностьКлиентСервер.ПредметыСтрокой(Объект.Предметы, Истина, Ложь);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЗначениеЗаполнено(Объект.Шаблон) Тогда
		РеквизитыШаблона = ОбщегоНазначенияДокументооборот.ЗначенияРеквизитовОбъектаВПривилегированномРежиме(
			Объект.Шаблон, "ДобавлятьНаименованиеПредмета, НаименованиеБизнесПроцесса");
		НаименованиеИзШаблона = РеквизитыШаблона.НаименованиеБизнесПроцесса;
		ДобавлятьНаименованиеПредмета = РеквизитыШаблона.ДобавлятьНаименованиеПредмета;
	КонецЕсли;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Мультипредметность.ПроцессПриСозданииНаСервере(ЭтаФорма, Объект);
	
	// Инструкции
	ПоказыватьИнструкции = ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции");
	ПолучитьИнструкции();
	
	// Заполняем строковое представление участников
	ИсполнительСтрокой = РаботаСБизнесПроцессамиКлиентСервер.ПредставлениеУчастникаПроцесса(
		Объект.Исполнитель,
		Объект.ОсновнойОбъектАдресации,
		Объект.ДополнительныйОбъектАдресации);
	
	// Заполняем параметры участников. Параметры используются в обработчиках соответствующих полей.
	ПараметрыИсполнителя =
		РаботаСБизнесПроцессамиКлиентСервер.ПолучитьСтруктуруПараметровУчастника(
			"Исполнитель",
			"ИсполнительСтрокой",
			"ОсновнойОбъектАдресации",
			"ДополнительныйОбъектАдресации");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МультипредметностьКлиент.ПроцессПриОткрытии(ЭтаФорма, Объект);
	
	Если Объект.Ссылка.Пустая() И Не Копирование Тогда
		Если ШаблоныПоПредметам.Количество() > 1 Тогда 
			РезультатВыбора = ШаблоныБизнесПроцессовКлиент.ВыбратьШаблонБизнесПроцесса("ШаблоныРассмотрения", ШаблоныПоПредметам);
			Если Не ЗначениеЗаполнено(РезультатВыбора) Тогда 
				Отказ = Истина;
				Возврат;
			КонецЕсли;	
		
			ЗаполнитьПоШаблонуНаСервере(РезультатВыбора);
			УстановитьДоступностьПоШаблону();
		КонецЕсли;
	КонецЕсли;
	
	Оповестить("ОбновитьСписокПоследних");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ИзменитьРеквизитыНевыполненныхЗадач = Ложь;
	
	Если ПараметрыЗаписи.Свойство("Старт") И ПараметрыЗаписи.Старт Тогда
		
		ПараметрыЗаписи.Вставить("ЗакрытьФормуПослеЗаписи", Истина);
		
		РаботаСБизнесПроцессамиКлиент.ПередСтартомБизнесПроцесса(
			Объект,
			Отказ,
			УникальныйИдентификатор,
			ПараметрыЗаписи);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		МультипредметностьКлиент.ПроверитьЗаполнениеПредметовПроцесса(ЭтаФорма, Отказ);
		
		РаботаСБизнесПроцессамиКлиент.ПроверитьСрокВыполненияПроцессаПередСтартом(
			Объект, ЭтаФорма, ПараметрыЗаписи, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
	ИначеЕсли Объект.Стартован И Модифицированность Тогда 
		
		Если ВестиУчетПоПроектам
			И ЗначениеЗаполнено(Объект.ПроектнаяЗадача)
			И Не ПараметрыЗаписи.Свойство("СтартоватьПриНеСоответствииСрокаПроцессаИПроектнойЗадачи")
			И Не ПараметрыЗаписи.Свойство("ПрерываниеПроцесса") Тогда
			
			// Проверка соответствия даты окончания процесса и плановой даты окончания проектной задачи
			РаботаСПроектамиКлиент.ПроверитьСоответствиеСрокаПроцессаИПроектнойЗадачи(
				Объект.ПроектнаяЗадача, 
				Объект.СрокИсполнения, 
				Отказ,
				ПараметрыЗаписи,
				УникальныйИдентификатор);
			Если Отказ Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		ИзменитьРеквизитыНевыполненныхЗадач = Истина;
		
	КонецЕсли;
	
	Если НЕ ПараметрыЗаписи.Свойство("ПроверкаПередОткрытиемФормыОтложенногоСтарта")
		И НЕ Объект.Стартован
		И Модифицированность
		И ЗначениеЗаполнено(НастройкаОтложенногоСтарта)
		И НастройкаОтложенногоСтарта.Состояние = 
			ПредопределенноеЗначение("Перечисление.СостоянияОтложенныхПроцессов.ГотовКСтарту") Тогда
			
		ПараметрыЗаписи.Вставить("ИзменениеОтложенногоПроцесса", Истина);
		ПроверитьЗаполнениеПроцессаДляОтложенногоСтарта(Отказ, ПараметрыЗаписи);
		Если Отказ Тогда
			Возврат;	
		КонецЕсли;
		
		ОтложенныйСтартБизнесПроцессовКлиент.ПроверитьСоответствиеСрокаИсполненияПроцессаИДатыОтложенногоСтарта(
			Отказ, ЭтаФорма, НастройкаОтложенногоСтарта, ПараметрыЗаписи);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("РассмотрениеВыполнениеКомандыСтартовать");
	КонецЕсли;
	
КонецПроцедуры

// Обработчик закрытия формы с вопросом о необходимости старта процесса, если общий срок меньше текущей даты.
// Параметры:
//	Результат - КодВозвратаДиалога - результат ответа пользователя
//	Параметры - Структура - параметры, переданные в обработчик перед открытием вопроса. В данном случае это 
//							параметры записи формы
&НаКлиенте
Процедура ПередЗаписьюПриСтартеЗавершениеВопросаОбОбщемСроке(Результат, Параметры) Экспорт
	
	РаботаСБизнесПроцессамиКлиент.ПередЗаписьюПриСтартеЗавершениеВопросаОбОбщемСроке(
		Результат, Параметры, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("БизнесПроцессИзменен", Объект.Ссылка, ЭтаФорма);
	
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		Оповестить("ОбновитьСписокПоследних");
	КонецЕсли;
	
	Если ПараметрыЗаписи.Свойство("Старт") И ПараметрыЗаписи.Старт Тогда
		
		Если Объект.Предметы.Количество() = 0 Тогда 
			
			ИнформацияОЗапуске = Новый Структура;
			ИнформацияОЗапуске.Вставить("СсылкаНаБизнесПроцесс", Объект.Ссылка);
			ИнформацияОЗапуске.Вставить("СсылкаНаПредметБизнесПроцесса", Неопределено);
			Если ВестиУчетПоПроектам Тогда
				ИнформацияОЗапуске.Вставить("Проект", Объект.Проект);
				ИнформацияОЗапуске.Вставить("ПроектнаяЗадача", Объект.ПроектнаяЗадача);
			КонецЕсли;
			Оповестить("БизнесПроцессСтартован", ИнформацияОЗапуске);
			
		Иначе
		
			Для Каждого СтрокаПредмета из Объект.Предметы Цикл
				
				ИнформацияОЗапуске = Новый Структура();
				ИнформацияОЗапуске.Вставить("СсылкаНаБизнесПроцесс", Объект.Ссылка);
				ИнформацияОЗапуске.Вставить("СсылкаНаПредметБизнесПроцесса", СтрокаПредмета.Предмет);
				Если ВестиУчетПоПроектам Тогда
					ИнформацияОЗапуске.Вставить("Проект", Объект.Проект);
					ИнформацияОЗапуске.Вставить("ПроектнаяЗадача", Объект.ПроектнаяЗадача);
				КонецЕсли;
				Оповестить("БизнесПроцессСтартован", ИнформацияОЗапуске);
				
				Если ЗначениеЗаполнено(СтрокаПредмета.Предмет) Тогда
					ОповеститьОбИзменении(СтрокаПредмета.Предмет);
				КонецЕсли;
				
			КонецЦикла;
		
		КонецЕсли;
		
	ИначеЕсли ИзменитьРеквизитыНевыполненныхЗадач Тогда 
		Оповестить("ИзмененыРеквизитыНевыполненныхЗадач", Объект.Ссылка);
	КонецЕсли;
	
	// Если пользователь отвечал на вопрос при старте процесса, то дальнейший 
	//	старт процесса выполняется неинтерактивно. В этом случае необходимо показать окно оповещения
	//	и добавить ссылку на процесс в историю.
	Если ПараметрыЗаписи.Свойство("СтартоватьПриЗанятыхФайлахДокументов")
		Или ПараметрыЗаписи.Свойство("СтартоватьПриЗанятыхФайлах")
		Или ПараметрыЗаписи.Свойство("СтартоватьЕслиОбщийСрокМеньшеТекущего")
		Или ПараметрыЗаписи.Свойство("СтартоватьПриНеСоответствииСрокаПроцессаИПроектнойЗадачи")
		Или ПараметрыЗаписи.Свойство("ЗаписатьБезСоответствияСрокаИсполненияПроцессаИДатыОтложенногоСтарта")
		Или ПараметрыЗаписи.Свойство("ПроверкаПередОткрытиемФормыОтложенногоСтарта")
		Или ПараметрыЗаписи.Свойство("СтартоватьПриНезарегистрированныхДокументах")
		Или ПараметрыЗаписи.Свойство("СтартоватьПриОшибкахВПроектах") Тогда
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Старт'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ИзменитьРеквизитыНевыполненныхЗадач Тогда
		ТекущийОбъект.ИзменитьРеквизитыНевыполненныхЗадач(
			ТекущийОбъект.ДополнительныеСвойства.СтарыеУчастникиПроцесса, ПараметрыЗаписи);
	КонецЕсли;
	
	// Сохранение вводимых значений
	СохранениеВводимыхЗначений.ОбновитьСпискиВыбора(ЭтаФорма, ЭлементыДляСохранения(), ЭтаФорма.ИмяФормы);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСБизнесПроцессами.ПередЗаписьюНаСервереФормаБизнесПроцесса(
		Отказ, ТекущийОбъект, ПараметрыЗаписи, ЭтаФорма);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка наличия участников процесса среди исполнителей проектной задачи
	// Проверка правильности указания трудозатрат участников процесса
	Если ВестиУчетПоПроектам И ЗначениеЗаполнено(ТекущийОбъект.Проект) Тогда
		РаботаСБизнесПроцессами.ПроверитьСоответствиеПроцессаПроектнойЗадаче(ТекущийОбъект, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ИзменитьРеквизитыНевыполненныхЗадач Тогда
		СтарыеУчастникиПроцесса = БизнесПроцессыИЗадачиВызовСервера.ТекущиеУчастникиПроцесса(Объект.Ссылка);
		ТекущийОбъект.ДополнительныеСвойства.Вставить("СтарыеУчастникиПроцесса", СтарыеУчастникиПроцесса);
	КонецЕсли;
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", НЕ ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	Мультипредметность.ОчиститьНезаполненныеПредметыПроцесса(Объект);
	Мультипредметность.УстановитьЗначенияДопРеквизитовИДоступностьЭлементовФормыПроцесса(ЭтаФорма, Объект);
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПротоколированиеРаботыПользователей.ЗаписатьСоздание(Объект.Ссылка, ПараметрыЗаписи.ЭтоНовыйОбъект);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	ПротоколированиеРаботыПользователей.ЗаписатьСтартБизнесПроцесса(Объект.Ссылка, ПараметрыЗаписи);
	
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСПоследнимиОбъектами.ЗаписатьОбращениеКОбъекту(Объект.Ссылка);
	КонецЕсли;
	
	Мультипредметность.ПроцессПослеЗаписиНаСервере(ЭтаФорма, Объект);
	
	ОбновитьДоступностьЭлементовФормыПоСостояниюПроцесса();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	РаботаСБизнесПроцессами.ПриЧтенииНаСервереФормаБизнесПроцесса(ТекущийОбъект, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	РаботаСБизнесПроцессамиКлиент.ОбработкаОповещенияФормаБизнесПроцесса(
		ИмяСобытия, Параметр, Источник, ЭтаФорма);
	
	Если ИмяСобытия = "Процесс_ТребуетсяЗаписьВладельцаФайла" И Параметр = УникальныйИдентификатор Тогда
		Записать();
		Оповестить("Процесс_ЗаписанВладелецФайла", Источник, Объект.Ссылка);
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" И Параметр.ИдентификаторРодительскойФормы = УникальныйИдентификатор Тогда
		МультипредметностьКлиент.ОбработатьДобавлениеПредметаПроцесса(ЭтаФорма, Параметр.Файл);
	ИначеЕсли ИмяСобытия = "Перенаправление_ЗадачаИсполнителя" 
		И ОбщегоНазначения.ПолучитьЗначениеРеквизита(Источник, "БизнесПроцесс") = Объект.Ссылка Тогда
		Прочитать();	
	КонецЕсли;
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	ИначеЕсли ИмяСобытия = "Процесс_ИзменениеСрока" И Параметр.Предмет = Объект.Ссылка Тогда
		Объект.СрокИсполнения = Параметр.НовыйСрок;
		Модифицированность = Истина;
		Записать(Параметр);
	ИначеЕсли ИмяСобытия = "Процесс_ВводПричиныПрерывания" И Параметр.ВладелецФормы = ЭтаФорма Тогда
		КомандыРаботыСБизнесПроцессамиКлиент.ПрерватьБизнесПроцессИзФормыОбъектаОкончание(
			ЭтаФорма, Параметр);
	КонецЕсли;
		
	Если ИмяСобытия = "ИзмененаНастройкаОтложенногоСтарта" 
		И Параметр.БизнесПроцесс = Объект.Ссылка Тогда
		
		НастройкаОтложенногоСтарта = Параметр;
		
		ОбновитьДоступностьЭлементовФормыПоСостояниюПроцесса();
		
		ОповеститьОбИзменении(Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура Подписаться(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("ОбъектПодписки", Объект.Ссылка);
		ОткрытьФорму("ОбщаяФорма.ПодпискаНаУведомленияПоОбъекту", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ПриЗакрытииСервер(Объект.Ссылка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриЗакрытииСервер(Ссылка)
	
	МультипредметностьВызовСервера.ПроцессПриЗакрытииНаСервере(Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)

	Если Настройки["ПоказыватьИнструкции"] <> Неопределено
		И ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции") Тогда
		ПолучитьИнструкции();
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ПометитьНаУдалениеБизнесПроцесс(ЭтаФорма);
	
	ПометитьНаУдалениеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПометитьНаУдалениеНаСервере()
	
	Прочитать();
	РаботаСБизнесПроцессами.ОбновитьДоступностьЭлементовФормыПоСостояниюПроцесса(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Объект.Автор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	
	Предметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(Объект,, Истина);	
	ШаблоныПоПредметам.ЗагрузитьЗначения(МультипредметностьВызовСервера.ПолучитьШаблоныПоПредметам(Предметы, "ШаблоныРассмотрения", Ложь));
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗаполнитьПоШаблонуПродолжение",
		ЭтотОбъект);
	ШаблоныБизнесПроцессовКлиент.ВыбратьШаблонБизнесПроцесса("ШаблоныРассмотрения", ШаблоныПоПредметам, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблонуПродолжение(РезультатВыбора, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатВыбора) Тогда 
		ЗаполнитьПоШаблонуНаСервере(РезультатВыбора);
		УстановитьДоступностьПоШаблону();
		Модифицированность = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СрокИсполнения)
		И Объект.СрокИсполнения = НачалоДня(Объект.СрокИсполнения) Тогда
		Объект.СрокИсполнения = КонецДня(Объект.СрокИсполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Остановить(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОстановитьБизнесПроцессИзФормыОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьБизнесПроцесс(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПрерватьБизнесПроцессИзФормыОбъекта(ЭтаФорма);
	
КонецПроцедуры        

&НаКлиенте
Процедура ДекорацияПричинаПрерыванияНажатие(Элемент)
		
	КомандыРаботыСБизнесПроцессамиКлиент.ПоказатьПричинуПрерывания(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБизнесПроцесс(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПродолжитьБизнесПроцессИзФормыОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьГлавнуюЗадачу(Команда)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьГлавнуюЗадачуБизнесПроцессИзФормыОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПовторение(Команда)
	
	ПовторениеБизнесПроцессовКлиент.НастроитьПовторениеИзФормыОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГлавнаяЗадачаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Объект.ГлавнаяЗадача);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПроектамиКлиент.ВыбратьПроектЗадачу(Элемент, Объект.Проект, Объект.ПроектнаяЗадача);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда 	
		Объект.Проект = ВыбранноеЗначение.Проект;
		Объект.ПроектнаяЗадача = ВыбранноеЗначение.ПроектнаяЗадача;
		ПолучитьДанныеПроекта();
		Исполнитель = Объект.Исполнитель;
		
		Если ЗначениеЗаполнено(Объект.ПроектнаяЗадача) Тогда 
			ЗаполнитьПоПроектнойЗадачеНаСервере(Объект.ПроектнаяЗадача);
		КонецЕсли;
		Модифицированность = Истина;
		
		Если Исполнитель <> Объект.Исполнитель Тогда 
			// Заполняем строковое представление участников
			ИсполнительСтрокой = РаботаСБизнесПроцессамиКлиентСервер.ПредставлениеУчастникаПроцесса(
				Объект.Исполнитель,
				Объект.ОсновнойОбъектАдресации,
				Объект.ДополнительныйОбъектАдресации);
			
			// Заполняем параметры участников. Параметры используются в обработчиках соответствующих полей.
			ПараметрыИсполнителя =
				РаботаСБизнесПроцессамиКлиентСервер.ПолучитьСтруктуруПараметровУчастника(
					"Исполнитель",
					"ИсполнительСтрокой",
					"ОсновнойОбъектАдресации",
					"ДополнительныйОбъектАдресации");
		КонецЕсли;			
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.ПроектнаяЗадача) Тогда 
		ПоказатьЗначение(, Объект.ПроектнаяЗадача);
	ИначеЕсли ЗначениеЗаполнено(Объект.Проект) Тогда 
		ПоказатьЗначение(, Объект.Проект);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.Проект = Неопределено;
	Объект.ПроектнаяЗадача = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		ДанныеВыбораПроектаЗадачи = РаботаСПроектами.СформироватьДанныеВыбораПроектаЗадачи(Текст);
		
		Если ДанныеВыбораПроектаЗадачи.Количество() = 1 Тогда 
			ВыбранноеЗначение = ДанныеВыбораПроектаЗадачи[0].Значение;
			
			Объект.Проект = ВыбранноеЗначение.Проект;
			Объект.ПроектнаяЗадача = ВыбранноеЗначение.ПроектнаяЗадача;
			ПроектЗадача = РаботаСПроектамиКлиентСервер.ПредставлениеПроектаЗадачи(Объект.Проект, Объект.ПроектнаяЗадача);
		Иначе	
			СтандартнаяОбработка = Ложь;
			ДанныеВыбора = ДанныеВыбораПроектаЗадачи;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ПроектЗадача) Тогда 
		Объект.Проект = Неопределено;
		Объект.ПроектнаяЗадача = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПредметыПредметПриИзмененииСервер()
	
	ПолучитьИнструкции();
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам")
		И Объект.Проект.Пустая() Тогда
		Для Каждого СтрокаПредмета Из Объект.Предметы Цикл
			Если ЗначениеЗаполнено(СтрокаПредмета.Предмет) 
			 И СтрокаПредмета.РольПредмета = Перечисления.РолиПредметов.Основной
			 И СтрокаПредмета.Предмет.Метаданные().Реквизиты.Найти("Проект") <> Неопределено Тогда 
				ПроектПредмета = ОбщегоНазначения.ПолучитьЗначениеРеквизита(СтрокаПредмета.Предмет, "Проект");
				Если ПроектПредмета <> Объект.Проект Тогда 
					Объект.Проект = ПроектПредмета;
					Объект.ПроектнаяЗадача = Неопределено;
					ПолучитьДанныеПроекта();
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ЗаписатьИЗакрыть(Команда, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтложенныйСтарт(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.НастроитьОтложенныйСтарт(ЭтаФорма, Объект.СрокИсполнения);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПроверитьЗаполнениеПроцессаДляОтложенногоСтарта(
	Отказ, ПараметрыЗаписи, ОткрытьФормуНастройкиОтложенногоСтарта = Ложь) Экспорт
	
	ОтложенныйСтартБизнесПроцессовКлиент.ПроверитьЗаполнениеПроцессаДляОтложенногоСтарта(
		Отказ, ПараметрыЗаписи, ЭтаФорма, ОткрытьФормуНастройкиОтложенногоСтарта);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьЭлементовФормыПоСостояниюПроцесса() Экспорт
	
	РаботаСБизнесПроцессами.ОбновитьДоступностьЭлементовФормыПоСостояниюПроцесса(ЭтаФорма);
	
	Элементы.Исполнитель.ТолькоПросмотр = ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСтартОтложенТекстНажатие(Элемент)
	
	ОтложенныйСтартБизнесПроцессовКлиент.ПоказатьПричинуОтменыОтложенногоСтарта(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция ЭлементыДляСохранения()
	
	СохраняемыеЭлементы = Новый Структура("Исполнитель", 
										  Объект.Исполнитель);
	
	Возврат СохранениеВводимыхЗначений.СформироватьТаблицуСохраняемыхЭлементов(СохраняемыеЭлементы);
	
КонецФункции

////////////////////////////////////////////////////////////////////////
// Обработчики поля Исполнитель

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.УчастникПриИзменении(Элемент,
		ЭтаФорма, ПараметрыИсполнителя);
		
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьИсполнителя(Элемент, Объект.Исполнитель,,Истина,,,
		Объект.ОсновнойОбъектАдресации, Объект.ДополнительныйОбъектАдресации);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОчистка(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникОчистка(Элемент, СтандартнаяОбработка,
		ЭтаФорма, ПараметрыИсполнителя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОткрытие(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникОткрытие(Элемент, СтандартнаяОбработка,
		ЭтаФорма, ПараметрыИсполнителя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.
		УчастникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка,
			ЭтаФорма, ПараметрыИсполнителя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.
		УчастникОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка,
			ЭтаФорма, ПараметрыИсполнителя);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ СВОЙСТВ

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма,
	РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСрок(Команда)
	
	ПереносСроковВыполненияЗадачКлиент.ОткрытьФормуПереносаСрокаПроцесса(ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
  Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
    РезультатВыполнения = Неопределено;
    ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
    ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
  КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
  ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

////////////////////////////////////////////////////////////////////////////////
// ИНСТРУКЦИИ

&НаСервере
Процедура ПолучитьИнструкции()
	
	РаботаСИнструкциями.ПолучитьИнструкции(ЭтаФорма, 90, 120);
	
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
