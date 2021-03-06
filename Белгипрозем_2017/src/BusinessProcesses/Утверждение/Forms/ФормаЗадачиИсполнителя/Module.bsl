
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РезультатыУтвержденияУтверждено = Перечисления.РезультатыУтверждения.Утверждено;
	РезультатыУтвержденияНеУтверждено = Перечисления.РезультатыУтверждения.НеУтверждено;
	
	РаботаСБизнесПроцессами.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
		Элементы.СрокИсполнения, Элементы.ДатаИсполнения);
	
	// номер цикла
	НайденнаяСтрока = Объект.БизнесПроцесс.РезультатыУтверждения.Найти(Объект.Ссылка, "ЗадачаИсполнителя");
	Если НайденнаяСтрока <> Неопределено Тогда 
		НомерИтерации = НайденнаяСтрока.НомерИтерации;
		
		Элементы.ТекстРезультатаВыполнения.Заголовок = Строка(НайденнаяСтрока.РезультатУтверждения) + ".";
		Если НайденнаяСтрока.РезультатУтверждения = Перечисления.РезультатыУтверждения.Утверждено Тогда 
			Элементы.ТекстРезультатаВыполнения.ЦветТекста = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
		ИначеЕсли НайденнаяСтрока.РезультатУтверждения = Перечисления.РезультатыУтверждения.НеУтверждено Тогда 
			Элементы.ТекстРезультатаВыполнения.ЦветТекста = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
		КонецЕсли;
	КонецЕсли;	
		
	Если НомерИтерации <= 1 Тогда 
		Элементы.НомерИтерации.Видимость = Ложь;
		Элементы.История.Видимость = Ложь;
	КонецЕсли;	
	
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		Объект.Ссылка,
		ВидыРабот,
		СпособУказанияВремени,
		ЭтаФорма.Команды.ПереключитьХронометраж,
	    ЭтаФорма.Элементы.ПереключитьХронометраж,
		ЭтаФорма.Элементы.УказатьТрудозатраты);
	
	ПодписыватьЭП = Объект.БизнесПроцесс.ПодписыватьЭП
		И РаботаСФайламиВызовСервера.ПолучитьИспользоватьЭлектронныеПодписиИШифрование();
	
	Если ПодписыватьЭП Тогда
		Команды.Утверждено.Заголовок = НСтр("ru = 'Утверждено (ЭП)'");
		Команды.Утверждено.Подсказка = НСтр("ru = 'При нажатии кнопки ""Утверждено"" потребуется выбрать сертификат для подписи и ввести пароль'");
	КонецЕсли;
	
	РаботаСПроектами.ЗаполнитьТрудозатратыПланСтрокой(
		ЭтаФорма,
		Объект.БизнесПроцесс.ТрудозатратыПланИсполнителя);
	
	БизнесПроцессыИЗадачиВызовСервера.ЗаписатьСобытиеОткрытаКарточкаИОбращениеКОбъекту(Объект.Ссылка);
	
	ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка);
	Если Не ПраваПоОбъекту.Изменение Тогда
		ТолькоПросмотр = Истина;
		Элементы.Утверждено.Доступность = Ложь;
		Элементы.НеУтверждено.Доступность = Ложь;
		Элементы.ДобавитьПредмет.Доступность = Ложь;
		Элементы.ДеревоПриложений.ТолькоПросмотр = Истина;
		Элементы.Перенаправить.Доступность = Ложь;
		Элементы.ФормаПринятьКИсполнению.Доступность = Ложь;
		Элементы.ФормаОтменитьПринятиеКИсполнению.Доступность = Ложь;
	КонецЕсли;
	
	Если Объект.СостояниеБизнесПроцесса <> Перечисления.СостоянияБизнесПроцессов.Активен
		Или Объект.Выполнена Тогда
		Элементы.ДобавитьПредмет.Доступность = Ложь;
		Элементы.ДеревоПриложений.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	// Инструкции
	ПоказыватьИнструкции = ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции");
	ПолучитьИнструкции();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	
	Если ПараметрыЗаписи.Свойство("ВыполнитьЗадачу") И ПараметрыЗаписи.ВыполнитьЗадачу Тогда 
		
		УстановитьПривилегированныйРежим(Истина);
		УтверждениеОбъект = ТекущийОбъект.БизнесПроцесс.ПолучитьОбъект();
		УтверждениеОбъект.ДополнительныеСвойства.Вставить("ТекущаяЗадача",ТекущийОбъект.Ссылка);
		УтверждениеОбъект.ДополнительныеСвойства.Вставить("РезультатУтверждения",ПараметрыЗаписи.РезультатУтверждения);
		ЗаблокироватьДанныеДляРедактирования(УтверждениеОбъект.Ссылка);
		УтверждениеОбъект.Записать();
		
	КонецЕсли;
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	Если ПараметрыЗаписи.Свойство("ВыполнитьЗадачу") И ПараметрыЗаписи.ВыполнитьЗадачу
		И ПараметрыЗаписи.РезультатУтверждения = РезультатыУтвержденияУтверждено
		И ПодписыватьЭП
		И ТипЗнч(ПодписиКПредметам) = Тип("Структура")
		И ПодписиКПредметам.МассивДанныхДляЗанесенияВРегистр.Количество() > 0 Тогда
		
		РаботаСЭП.ЗанестиИнформациюОПодписях(ПодписиКПредметам.МассивДанныхДляЗанесенияВРегистр,
			ПодписиКПредметам.МассивАдресов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыРеквизитыНевыполненныхЗадач" И Параметр = Объект.БизнесПроцесс И Не Объект.Выполнена Тогда 
		
		ДатаИсполнения = Объект.ДатаИсполнения;
		Прочитать();
		Объект.ДатаИсполнения = ДатаИсполнения;
		
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		
		ОбновитьДеревоПриложений();
		
	ИначеЕсли ИмяСобытия = "Изменение_ФактическиеТрудозатратыЗадачи" И Параметр = Объект.Ссылка Тогда
		
		ТрудозатратыФакт = РаботаСБизнесПроцессами.ПолучитьФактическиеТрудозатратыПоЗадаче(Объект.Ссылка);	
		
	ИначеЕсли ИмяСобытия = "ФайлЗанятДляРедактирования" Тогда
		
		ОбновитьДеревоПриложений();
		
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" И Параметр.ИдентификаторРодительскойФормы = УникальныйИдентификатор Тогда
		
		МультипредметностьВызовСервера.ОбработатьДобавлениеПредметаЗадачи(
			Объект.Ссылка, Объект.БизнесПроцесс, Параметр.Файл, УникальныйИдентификатор);
			
		Прочитать();
		ОбновитьДеревоПриложений();
		
	ИначеЕсли ИмяСобытия = "ИзменилсяФлаг"
		И Источник <> ЭтаФорма
		И Параметр.Найти(Объект.Ссылка) <> Неопределено Тогда
		
		РаботаСФлагамиОбъектовКлиентСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "СозданНовыйВопросВыполненияЗадачи" И Параметр = Объект.Ссылка Тогда
		
		БизнесПроцессыИЗадачиКлиентСервер.ЗаполнитьЗаголовокДекорацииЗадатьВопросАвтору(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "ЗадачаИзменена" И Источник <> ЭтаФорма Тогда
		
		ПрочитатьДанныеЗадачиВФорму = Ложь;
		
		Если ТипЗнч(Параметр) = Тип("Массив") Тогда
			ПрочитатьДанныеЗадачиВФорму = Параметр.Найти(Объект.Ссылка) <> Неопределено;
		Иначе
			ПрочитатьДанныеЗадачиВФорму = (Параметр = Объект.Ссылка);
		КонецЕсли;
		
		Если ПрочитатьДанныеЗадачиВФорму Тогда
			Прочитать();
		КонецЕсли;
		
		КомандыРаботыСБизнесПроцессамиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "Перенаправление_ЗадачаИсполнителя" И Источник = Объект.Ссылка Тогда
		Закрыть();
		
	КонецЕсли;
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоПриложений(ТекущееИмяПредметаВДереве = Неопределено)
	
	ТекущаяСсылкаВДереве = Неопределено;
	
	Если Элементы.ДеревоПриложений.ТекущиеДанные <> Неопределено И ТекущееИмяПредметаВДереве = Неопределено Тогда
		ТекущаяСсылкаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.Ссылка;
		ТекущееИмяПредметаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.ИмяПредмета;
	КонецЕсли;
	
	Если Элементы.Найти("ДеревоПриложений") <> Неопределено  Тогда
		ОбновитьДеревоПриложенийСервер();
	КонецЕсли;
	
	Если ТекущаяСсылкаВДереве <> Неопределено ИЛИ ТекущееИмяПредметаВДереве <> Неопределено Тогда
		РаботаСБизнесПроцессамиКлиент.УстановитьТекущуюСтрокуВДеревеПриложений(
			ЭтаФорма, 
			ДеревоПриложений.ПолучитьЭлементы(), 
			ТекущаяСсылкаВДереве, ТекущееИмяПредметаВДереве);
	КонецЕсли;
		
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(
		ЭтаФорма, 
		Элементы.ДеревоПриложений);
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоПриложенийСервер()
	
	РаботаСБизнесПроцессами.ЗаполнитьДеревоПриложений(ЭтаФорма);
	
КонецПроцедуры	

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСБизнесПроцессами.ФормаЗадачиИсполнителяУстановитьВидимостьПредмета(ЭтаФорма);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСФлагамиОбъектовСервер.СохранитьФлагОбъектаИзФормы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Мультипредметность.ИзмененыПредметыЗадачи(Объект.Ссылка) Тогда
			ОбновитьДеревоПриложенийСервер();
		КонецЕсли;
	КонецЕсли;
	
	РаботаСБизнесПроцессами.ФормаЗадачиИсполнителяУстановитьВидимостьПредмета(ЭтаФорма);
	
	Если Не Объект.Выполнена Тогда
		Объект.ДатаИсполнения = ТекущаяДатаСеанса();
	КонецЕсли;
	
	РаботаСФлагамиОбъектовСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
	
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

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)

	Если Настройки["ПоказыватьИнструкции"] <> Неопределено
		И ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции") Тогда
		ПолучитьИнструкции();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗадачаИзменена", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ДекорацияЗадатьВопросАвторуНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Задача", Объект.Ссылка);
	
	Если Элементы.ДекорацияЗадатьВопросАвтору.Заголовок = НСтр("ru = 'Задать вопрос...'") Тогда
		
		ОткрытьФорму("БизнесПроцесс.РешениеВопросовВыполненияЗадач.ФормаОбъекта",
			ПараметрыФормы);
		
	Иначе
		
		ОткрытьФорму("БизнесПроцесс.РешениеВопросовВыполненияЗадач.Форма.ВопросыВыполненияЗадачи",
			ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Задача", Объект.Ссылка);
	ПараметрыФормы.Вставить("ВидВопроса", ПредопределенноеЗначение("Перечисление.ВидыВопросовВыполненияЗадач.ПереносСрока"));

	ОткрытьФорму("БизнесПроцесс.РешениеВопросовВыполненияЗадач.ФормаОбъекта",
		ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПричинаПрерыванияНажатие(Элемент)
		
	КомандыРаботыСБизнесПроцессамиКлиент.ПоказатьПричинуПрерывания(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПринятьЗадачуКИсполнению(ЭтаФорма, ТекущийПользователь);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОтменитьПринятиеЗадачиКИсполнению(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ОчиститьСообщения();
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить(Команда)
	
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Утверждено(Команда)
	
	Если МультипредметностьКлиент.ПроверитьЗаполнениеПредметовЗадачи(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОбработчикаОповещения = Новый Структура;
	ПараметрыОбработчикаОповещения.Вставить("РезультатУтверждения", РезультатыУтвержденияУтверждено);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеПроверкиНаЗанятыеФайлы",
		ЭтотОбъект,
		ПараметрыОбработчикаОповещения);
	
	РаботаСБизнесПроцессамиКлиент.ПроверитьНаличиеЗанятыхФайлов(Объект, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеПроверкиНаЗанятыеФайлы(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ВыполнитьЗадачу", Истина);
	ПараметрыЗаписи.Вставить("РезультатУтверждения", Параметры.РезультатУтверждения);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеПодписанияЭП",
		ЭтотОбъект,
		ПараметрыЗаписи);
		
	Если Параметры.РезультатУтверждения = РезультатыУтвержденияНеУтверждено Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
		Возврат;
	КонецЕсли;
			
	Если Не ПодписатьПредметыЭП(ОписаниеОповещения) Тогда
		Возврат;
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеПодписанияЭП(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Записать(ПараметрыЗаписи) Тогда 
		Возврат;
	КонецЕсли;	
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеВводаВремени",
		ЭтотОбъект);
		
	УчетВремениКлиент.ДобавитьВОтчетПослеВыполненияЗадачи(ОпцияИспользоватьУчетВремени,
		Объект.ДатаИсполнения, Объект.Ссылка, ВключенХронометраж, 
		ДатаНачалаХронометража, ДатаКонцаХронометража,
		ВидыРабот, СпособУказанияВремени, ОписаниеОповещения);
		
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеВводаВремени(Результат, Параметры) Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Выполнение:'"),
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		Строка(Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("ЗадачаВыполнена", Объект.Ссылка);
	Закрыть();
	
КонецПроцедуры
	
&НаКлиенте
Процедура НеУтверждено(Команда)
		
	Если МультипредметностьКлиент.ПроверитьЗаполнениеПредметовЗадачи(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.РезультатВыполнения) Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите причину отклонения документа '"),, 
			"Объект.РезультатВыполнения");
		Возврат;
	КонецЕсли;		
	
	ПараметрыОбработчикаОповещения = Новый Структура;
	ПараметрыОбработчикаОповещения.Вставить("РезультатУтверждения", РезультатыУтвержденияНеУтверждено);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеПроверкиНаЗанятыеФайлы",
		ЭтотОбъект,
		ПараметрыОбработчикаОповещения);
	
	РаботаСБизнесПроцессамиКлиент.ПроверитьНаличиеЗанятыхФайлов(Объект, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительСтрокойОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСБизнесПроцессамиКлиент.ОткрытьИсполнителя(Объект.Исполнитель);
	
КонецПроцедуры

&НаКлиенте
Процедура История(Команда)
	
	ПараметрыФормы = Новый Структура("ЗадачаСсылка", Объект.Ссылка);
	ОткрытьФорму("БизнесПроцесс.Утверждение.Форма.ФормаИсторияУтверждения", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура Дополнительно(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Перенаправить(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.Перенаправить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	
	ПоказатьЗначение(,Объект.БизнесПроцесс);
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьХронометражСервер(ПараметрыОповещения) Экспорт
	
	УчетВремени.ПереключитьХронометражСервер(
	ПараметрыОповещения,
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	Объект.Ссылка,
	ВидыРабот,
	ЭтаФорма.Команды.ПереключитьХронометраж,
	ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтчетИОбновитьФорму(ПараметрыОтчета, ПараметрыОповещения) Экспорт
	
	УчетВремени.ДобавитьВОтчетИОбновитьФорму(
		ПараметрыОтчета, 
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьХронометражСервер() Экспорт
	
	УчетВремени.ОтключитьХронометражСервер(
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	Объект.Ссылка,
	ЭтаФорма.Команды.ПереключитьХронометраж,
	ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьХронометраж(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПереключитьХронометраж(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьТрудозатраты(Команда)
	
	ДатаОтчета = ТекущаяДата();
	Если Объект.Выполнена Тогда
		ДатаОтчета = Объект.ДатаИсполнения;
	КонецЕсли;	
	
	УчетВремениКлиент.ДобавитьВОтчетКлиент(
		ДатаОтчета,
		ВключенХронометраж, 
		ДатаНачалаХронометража, 
		ДатаКонцаХронометража, 
		ВидыРабот, 
		Объект.Ссылка,
		СпособУказанияВремени,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		Объект.Выполнена,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Команда)
	
	ВыполнениеЗадачПоПочтеКлиент.СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ФЛАГОМ

&НаКлиенте
Процедура КрасныйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Красный"),
		БиблиотекаКартинок.КрасныйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура СинийФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Синий"),
		БиблиотекаКартинок.СинийФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЖелтыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Желтый"),
		БиблиотекаКартинок.ЖелтыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗеленыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Зеленый"),
		БиблиотекаКартинок.ЗеленыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОранжевыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Оранжевый"),
		БиблиотекаКартинок.ОранжевыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиловыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Лиловый"),
		БиблиотекаКартинок.ЛиловыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.ПустаяСсылка"),
		БиблиотекаКартинок.ПустойФлаг);
	
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

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ДЛЯ РАБОТЫ С ПРИЛОЖЕНИЯМИ 

&НаКлиенте
Процедура ДеревоПриложенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = ДеревоПриложений.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ЗначениеЗаполнено(ТекущиеДанные.ИмяПредмета) И НЕ ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ОчиститьСообщения();
		СообщениеОбОшибке = "";
		
		ПараметрыОбработчикаОповещения = Новый Структура();
		ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ДеревоПриложенийВыборПродолжение",
			ЭтотОбъект,
			ПараметрыОбработчикаОповещения);         
			
		Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(ЭтаФорма, СообщениеОбОшибке, 
			ТекущиеДанные.ИмяПредмета, ТекущиеДанные.Ссылка, СтандартнаяОбработка, ОписаниеОповещения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СообщениеОбОшибке,, "ДеревоПриложений");
			Возврат;
		КонецЕсли;
	Иначе
		РаботаСБизнесПроцессамиКлиент.ДеревоПриложенийВыбор(
			ЭтаФорма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийВыборПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();	
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПриАктивизацииСтроки(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ОткрытьКарточкуНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЭтаФорма.ТолькоПросмотр Или Элементы.ДеревоПриложений.ТолькоПросмотр Или Объект.Выполнена Тогда 
		Возврат;
	КонецЕсли;
	
	ВладелецФайлаСписка = Объект.БизнесПроцесс;
	НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;
	РаботаСФайламиКлиент.ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыПеретаскивания, ВладелецФайлаСписка, ЭтаФорма, НеОткрыватьКарточкуПослеСозданияИзФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ДеревоПриложенийДобавлениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ДеревоПриложенийУдалениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийДобавлениеНаКлиенте()

	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	НовыйИмяПредмета = Неопределено;
	
	ПараметрыОбработчикаОповещения = Новый Структура();
	ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДеревоПриложенийВыборПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчикаОповещения);
	
	Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(ЭтаФорма, СообщениеОбОшибке, НовыйИмяПредмета,,,ОписаниеОповещения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийДобавлениеНаКлиентеПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();	
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийУдалениеНаКлиенте()
	
	ВыделенныеСтрокиПредметов = Новый Массив;
	Для Каждого ВыделеннаяСтр Из Элементы.ДеревоПриложений.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.ДеревоПриложений.ДанныеСтроки(ВыделеннаяСтр);
		ВыделенныеСтрокиПредметов.Добавить(ДанныеСтроки);
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДеревоПриложенийУдалениеНаКлиентеПродолжение",
		ЭтотОбъект,
		ВыделенныеСтрокиПредметов);
		
	МультипредметностьКлиент.ПолученоПодтверждениеОбУдаленииПредмета(Объект, ВыделенныеСтрокиПредметов, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийУдалениеНаКлиентеПродолжение(Результат, ВыделенныеСтрокиПредметов) Экспорт
	
	Если Результат = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	
	ИменаУдаляемыхПредметов = Новый Массив;
	Для Каждого ВыделеннаяСтр Из ВыделенныеСтрокиПредметов Цикл
		Если ВыделеннаяСтр.ДоступноУдаление Тогда
			ИменаУдаляемыхПредметов.Добавить(ВыделеннаяСтр.ИмяПредмета);
		КонецЕсли;
	КонецЦикла;
	
	Если ИменаУдаляемыхПредметов.Количество() = 0 Тогда
		
		КоличествоВыделенныхСтрок = ВыделенныеСтрокиПредметов.Количество();
		Если КоличествоВыделенныхСтрок = 1 Тогда
			ТекстСообщения = НСтр("ru = 'Удалить текущий предмет можно только в карточке процесса.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Удалить выделенные предметы можно только в карточке процесса.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
	
	Если Не МультипредметностьКлиент.УдалитьПредметыЗадачи(ЭтаФорма, СообщениеОбОшибке, ИменаУдаляемыхПредметов) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
	
	ОбновитьДеревоПриложений();
	УстановитьПредметСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДляПросмотра(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьТекущийФайлДляПросмотра(ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры	

&НаКлиенте
Процедура Редактировать(Команда)
	
	РаботаСБизнесПроцессамиКлиент.РедактироватьТекущийФайл(
		ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ЗакончитьРедактированиеТекущегоФайла(
		ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредмет(Команда)
	
	ДеревоПриложенийДобавлениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПредмет(Команда)
	
	ДеревоПриложенийУдалениеНаКлиенте();
	
КонецПроцедуры


&НаСервере
Процедура УстановитьПредметСервер()
	
	Мультипредметность.УстановитьЗначенияДопРеквизитовИДоступностьЭлементовФормыПроцесса(ЭтаФорма, Объект);
	ПолучитьИнструкции();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновитьДеревоПриложений(Команда)
	
	ОбновитьДеревоПриложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ОткрытьКарточкуНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНаКлиенте()
	
	ТекущиеДанные = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение(,ТекущиеДанные.Ссылка);
	Иначе
		ОчиститьСообщения();
		СообщениеОбОшибке = "";
		
		ПараметрыОбработчикаОповещения = Новый Структура;
		ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОткрытьКарточкуНаКлиентеПродолжение",
			ЭтотОбъект,
			ПараметрыОбработчикаОповещения);
			
		Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(
			ЭтаФорма,
			СообщениеОбОшибке, 
			ТекущиеДанные.ИмяПредмета,
			ТекущиеДанные.Ссылка,,
			ОписаниеОповещения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СообщениеОбОшибке,, "ДеревоПриложений");
			Возврат;
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНаКлиентеПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	РаботаСБизнесПроцессамиКлиент.СохранитьТекущийФайл(ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры	

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Оповестить("ОбновитьСписокПоследних");
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленныеПриложения(Команда)
	
	ОтображатьУдаленныеПриложения = Не ОтображатьУдаленныеПриложения;
	Элементы.ДеревоПриложенийКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленныеПриложения;
	
	ТекущаяСсылкаВДереве = Неопределено;
	Если Элементы.ДеревоПриложений.ТекущиеДанные <> Неопределено Тогда
		ТекущаяСсылкаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.Ссылка;
	КонецЕсли;	
	
	ОтображатьУдаленныеПриложенияСервер();
	
	Если ТекущаяСсылкаВДереве <> Неопределено Тогда
		РаботаСБизнесПроцессамиКлиент.УстановитьТекущуюСтрокуВДеревеПриложений(
			ЭтаФорма, 
			ДеревоПриложений.ПолучитьЭлементы(), 
			ТекущаяСсылкаВДереве);
	КонецЕсли;	
		
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(
		ЭтаФорма, 
		Элементы.ДеревоПриложений);
		
КонецПроцедуры

&НаСервере
Процедура ОтображатьУдаленныеПриложенияСервер()
	
	РаботаСБизнесПроцессами.ЗаполнитьДеревоПриложений(ЭтаФорма);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		ИмяФормы,
		"ОтображатьУдаленныеПриложения",
		ОтображатьУдаленныеПриложения);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Функция ПодписатьПредметыЭП(ОписаниеОповещения)
	
	Если Не ПодписыватьЭП Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		РаботаСЭПКлиент.ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСКриптографией();
		Возврат Ложь;
	КонецЕсли;
	
	ОсновныеПредметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(Объект,, Истина);
	
	ПодписиКПредметам = Новый Структура("МассивДанныхДляЗанесенияВРегистр, МассивАдресов");
	МассивПредметовДляПодписания = Новый Массив;
	МассивДанныхДляЗанесенияВРегистр = Новый Массив;
	МассивАдресов = Новый Массив;
	
	Для Каждого Предмет из ОсновныеПредметы Цикл
		
		Если ТипЗнч(Предмет) = Тип("СправочникСсылка.ВнутренниеДокументы")
			ИЛИ ТипЗнч(Предмет) = Тип("СправочникСсылка.ВходящиеДокументы")
			ИЛИ ТипЗнч(Предмет) = Тип("СправочникСсылка.ИсходящиеДокументы")
			ИЛИ ТипЗнч(Предмет) = Тип("СправочникСсылка.Файлы") Тогда
			
			МассивПредметовДляПодписания.Добавить(Предмет);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивПредметовДляПодписания.Количество() = 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если МассивПредметовДляПодписания.Количество() = 1 Тогда
		ЗаголовокФормыВыбораСертификата = НСтр("ru = 'Подпись предмета'");
	Иначе
		ЗаголовокФормыВыбораСертификата = НСтр("ru = 'Подпись предметов'");
	КонецЕсли;
	
	ПараметрыОбработчикаОповещения = Новый Структура;
	ПараметрыОбработчикаОповещения.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	ПараметрыОбработчикаОповещения.Вставить("МассивАдресов", МассивАдресов);
	
	ОписаниеОповещенияПослеПодписания = Новый ОписаниеОповещения(
		"СформироватьПодписиОбъектовПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчикаОповещения);
	
	РаботаСЭПКлиент.СформироватьПодписиОбъектов(МассивПредметовДляПодписания,
		УникальныйИдентификатор, МассивДанныхДляЗанесенияВРегистр, МассивАдресов, ,
		ЗаголовокФормыВыбораСертификата, ОписаниеОповещенияПослеПодписания);
		
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура СформироватьПодписиОбъектовПродолжение(Результат, Параметры) Экспорт
	
	Если Результат.Флаг = Истина Тогда
		ПодписиКПредметам.МассивДанныхДляЗанесенияВРегистр = Результат.МассивДанныхДляЗанесенияВРегистр;
		ПодписиКПредметам.МассивАдресов = Параметры.МассивАдресов;	
		ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещения, Истина);
	Иначе
		ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещения, Ложь);
	КонецЕсли;
	
КонецПроцедуры

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
