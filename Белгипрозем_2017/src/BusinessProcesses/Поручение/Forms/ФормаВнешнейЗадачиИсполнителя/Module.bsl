
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	РаботаСФлагамиОбъектовСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессами.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
		Элементы.СрокИсполнения, Элементы.ДатаИсполнения);
		
	МультипредметностьКлиентСервер.ЗаполнитьТаблицуПредметовФормы(Объект);
	
	ИсторияВыполнения = РегистрыСведений.ИсторияВыполненияЗадач.ИсторияПоБизнесПроцессу(Объект.БизнесПроцесс);
		
	Если Объект.Выполнена Тогда
		Элементы.ТекстРезультатаВыполнения.Заголовок = НСТР("ru = 'Выполнено.'");
	КонецЕсли;
	
	Если (Объект.Автор.Пустая() ИЛИ Не ПользовательЕстьВБазе(Объект.Автор)) И Не ПустаяСтрока(Объект.АвторСтрокой) Тогда
		Элементы.Автор.Видимость = Ложь;
		Элементы.АвторСтрокой.Видимость = Истина;
	Иначе
		Элементы.Автор.Видимость = Истина;
		Элементы.АвторСтрокой.Видимость = Ложь;
	КонецЕсли;
	
	ДанныеХранилища = Объект.БизнесПроцесс.СодержаниеПредмета.Получить();
	Если ДанныеХранилища <> Неопределено Тогда
		Если ТипЗнч(ДанныеХранилища) = Тип("Строка") Тогда
			ПредметHTML = ДанныеХранилища;
			Элементы.ПредметыHTML.Видимость = Истина;
			Элементы.ПредметыMXL.Видимость = Ложь;
		ИначеЕсли ТипЗнч(ДанныеХранилища) = Тип("ТабличныйДокумент") Тогда	
			ПредметMXL = ДанныеХранилища;
			Элементы.ПредметыHTML.Видимость = Ложь;
			Элементы.ПредметыMXL.Видимость = Истина;
		КонецЕсли;	
		
		Элементы.ИсторияВыполнения.Видимость = Ложь;
		
		Если Объект.Предметы.Количество() = 0 Тогда
			Элементы.Предметы.Видимость = Ложь;
		КонецЕсли;	
	Иначе	
		Элементы.ПредметыHTML.Видимость = Ложь;
		Элементы.ПредметыMXL.Видимость = Ложь;
	КонецЕсли;	
	
	Файлы.Параметры.УстановитьЗначениеПараметра("ВладелецФайла", Объект.БизнесПроцесс.Ссылка);
	Файлы.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());
	РаботаСФайламиВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Файлы);
	
	Если РаботаСФайламиВызовСервера.ПолучитьИспользоватьЭлектронныеПодписиИШифрование() = Ложь Тогда
		Элементы.ФайлыПодписанЭП.Видимость = Ложь;
		Элементы.ФайлыЗашифрован.Видимость = Ложь;
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
	
	БизнесПроцессыИЗадачиВызовСервера.ЗаписатьСобытиеОткрытаКарточкаИОбращениеКОбъекту(Объект.Ссылка);
	
	ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка);
	Если Не ПраваПоОбъекту.Изменение Тогда
		ТолькоПросмотр = Истина;
		Элементы.Выполнено.Доступность = Ложь;
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
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)

	Если Настройки["ПоказыватьИнструкции"] <> Неопределено
		И ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции") Тогда
		ПолучитьИнструкции();
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ДекорацияПричинаПрерыванияНажатие(Элемент)
		
	КомандыРаботыСБизнесПроцессамиКлиент.ПоказатьПричинуПрерывания(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ОчиститьСообщения();
	Если Записать() Тогда
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
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Выполнено(Команда)
	
	Если Не РаботаСБизнесПроцессамиКлиент.ПроверитьНаличиеЗанятыхФайлов(Объект) Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ВыполнитьЗадачу", Истина);
	
	Если Не Записать(ПараметрыЗаписи) Тогда 
		Возврат;
	КонецЕсли;	
	
	УчетВремениКлиент.ДобавитьВОтчетПослеВыполненияЗадачи(ОпцияИспользоватьУчетВремени,
		Объект.ДатаИсполнения, Объект.Ссылка, ВключенХронометраж, 
		ДатаНачалаХронометража, ДатаКонцаХронометража,
		ВидыРабот, СпособУказанияВремени);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Выполнение:'"),
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		Строка(Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("ЗадачаВыполнена", Объект.Ссылка);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительСтрокойОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСБизнесПроцессамиКлиент.ОткрытьИсполнителя(Объект.Исполнитель);
	
КонецПроцедуры

&НаКлиенте
Процедура Подписаться(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("ОбъектПодписки", Объект.Ссылка);
		ОткрытьФорму("ОбщаяФорма.ПодпискаНаУведомленияПоОбъекту", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	МультипредметностьКлиент.ПредметыВыбор(Объект.Предметы, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
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
	
	ПоказатьЗначение(, Объект.БизнесПроцесс);
	
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
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИмпортФайловЗавершен" Тогда
		Элементы.Файлы.Обновить();
		
		Если Параметр <> Неопределено Тогда
			Элементы.Файлы.ТекущаяСтрока = Параметр;
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		Элементы.Файлы.Обновить();
		
		Если ТипЗнч(Параметр) = Тип("Структура") Тогда
			Элементы.Файлы.ТекущаяСтрока = Параметр.Файл;
		КонецЕсли;	
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		
		ВладелецФайла = Неопределено;
		
		Если ТипЗнч(Параметр) = Тип("Структура") И Параметр.Свойство("Владелец") Тогда
			ВладелецФайла = Параметр.Владелец;
		Иначе	
			ВладелецФайла = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Источник, "ВладелецФайла");
		КонецЕсли;	
		
		Если ВладелецФайла = Объект.Ссылка Тогда
			
			Элементы.Файлы.Обновить();
			ОбновитьДоступностьКомандСпискаФайлов();
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИзменилсяФлаг"
		И Источник <> ЭтаФорма
		И Параметр.Найти(Объект.Ссылка) <> Неопределено Тогда
		
		РаботаСФлагамиОбъектовКлиентСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
		
	КонецЕсли;
	
	Если ИмяСобытия = "Перенаправление_ЗадачаИсполнителя" И Источник = Объект.Ссылка Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьКомандСпискаФайлов(Результат = Неопределено, ПараметрыВыполнения = Неопределено) Экспорт
	
	УстановитьДоступностьКоманд(Элементы.Файлы.ТекущиеДанные);
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьДоступностьКоманды(Команда, Доступность)
	Команда.Доступность = Доступность;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда 
		
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОткрытьФайл, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРедактировать, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗакончитьРедактирование, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗанять, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьИзменения, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьКак, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОсвободить, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОбновитьИзФайлаНаДиске, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюПодписатьФайл, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюДобавитьЭПИзФайла, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьВместеСЭП, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗашифровать, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРасшифровать, Ложь);
		
	Иначе	
		
		РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;
		Редактирует = ТекущиеДанные.Редактирует;
		ПодписанЭП 	= ТекущиеДанные.ПодписанЭП;
		Зашифрован 	= ТекущиеДанные.Зашифрован;
		
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОткрытьФайл, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРедактировать, НЕ ТекущиеДанные.ПодписанЭП);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗакончитьРедактирование, РедактируетТекущийПользователь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗанять, Редактирует.Пустая());
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьИзменения, РедактируетТекущийПользователь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьКак, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОсвободить, Не Редактирует.Пустая());
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОбновитьИзФайлаНаДиске, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюПодписатьФайл, Редактирует.Пустая() И НЕ Зашифрован);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюДобавитьЭПИзФайла, Редактирует.Пустая() И НЕ Зашифрован);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьВместеСЭП, ПодписанЭП);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗашифровать, Редактирует.Пустая() И НЕ Зашифрован);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРасшифровать, Зашифрован);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КакОткрывать = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПоказатьЗначение(, ВыбраннаяСтрока);
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		ВыбраннаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	Обработчик = Новый ОписаниеОповещения("СписокВыборПослеВыбораРежимаРедактирования", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиКлиент.ВыбратьРежимИРедактироватьФайл(Обработчик, ДанныеФайла, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеВыбораРежимаРедактирования(Результат, ПараметрыВыполнения) Экспорт
	
	РезультатОткрыть = "Открыть";
	РезультатРедактировать = "Редактировать";
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект, ПараметрыВыполнения);
	
	Если Результат = РезультатРедактировать Тогда
		РаботаСФайламиКлиент.РедактироватьФайл(Обработчик, ПараметрыВыполнения.ДанныеФайла);
	ИначеЕсли Результат = РезультатОткрыть Тогда
		РаботаСФайламиКлиент.ОткрытьФайлСОповещением(Неопределено, ПараметрыВыполнения.ДанныеФайла, УникальныйИдентификатор); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПриАктивизацииСтроки(Элемент)
	ОбновитьДоступностьКомандСпискаФайлов();
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			"Создание:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ВладелецФайла = Объект.БизнесПроцесс;
	ФайлОснование = Элементы.Файлы.ТекущаяСтрока;
	
	Если Не Копирование Тогда
		Попытка
			РежимСоздания = 1;
			РаботаСФайламиКлиент.ДобавитьФайл(Неопределено, ВладелецФайла, ЭтаФорма, РежимСоздания, Истина);
		Исключение
			Инфо = ИнформацияОбОшибке();
			ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			                 НСтр("ru = 'Ошибка создания нового файла: %1'"),
			                 КраткоеПредставлениеОшибки(Инфо)));
		КонецПопытки;
	Иначе
		РаботаСФайламиКлиент.СкопироватьФайл(ВладелецФайла, ФайлОснование);
	КонецЕсли;
	Элементы.Файлы.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Файлы.ТолькоПросмотр Тогда 
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			"Создание:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ВладелецФайлаСписка = Объект.БизнесПроцесс;
	НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;	
	РаботаСФайламиКлиент.ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыПеретаскивания, ВладелецФайлаСписка, ЭтаФорма, НеОткрыватьКарточкуПослеСозданияИзФайла);
	Элементы.Файлы.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(Элементы.Файлы.ТекущаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляСохранения(Элементы.Файлы.ТекущаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьФайл(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСКриптографией(
			Неопределено,
			НСтр("ru = 'Подписать'"));
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(Элементы.Файлы.ТекущаяСтрока);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	Обработчик = Новый ОписаниеОповещения("ПодписатьПослеФормированияПодписи", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиКлиент.СформироватьПодписьФайла(Обработчик, ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьПослеФормированияПодписи(Результат, ПараметрыВыполнения) Экспорт
	
	Если Результат.Успех = Истина Тогда
		РаботаСФайламиВызовСервера.ЗанестиИнформациюОднойПодписи(Результат.ДанныеПодписи);
		
		ЭлектроннаяПодписьКлиент.ИнформироватьОПодписанииОбъекта(ПараметрыВыполнения.ДанныеФайла.Ссылка);
		ОповеститьОбИзменении(ПараметрыВыполнения.ДанныеФайла.Ссылка);	
		Оповестить("ПрисоединенныйФайлПодписан", ПараметрыВыполнения.ДанныеФайла.Владелец);
	КонецЕсли;
	
	ОбновитьДоступностьКомандСпискаФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЭПИзФайла(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(Элементы.Файлы.ТекущаяСтрока);
	
	Обработчик = Новый ОписаниеОповещения("УстановитьДоступностьФайловыхКоманд", ЭтотОбъект);
	РаботаСФайламиКлиент.ДобавитьПодписьИзФайла(Обработчик, ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВместеСЭП(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(
		Элементы.Файлы.ТекущаяСтрока);
	
	РаботаСФайламиКлиент.СохранитьСПодписью(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Зашифровать(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСКриптографией(
			Неопределено,
			НСтр("ru = 'Зашифровать'"));
		Возврат;
	КонецЕсли;
	
	ОбъектСсылка = Элементы.Файлы.ТекущаяСтрока;
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИКоличествоВерсий(ОбъектСсылка);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	ПараметрыОбработчика.Вставить("ОбъектСсылка", ОбъектСсылка);
	Обработчик = Новый ОписаниеОповещения("ЗашифроватьПослеШифрованияНаКлиенте", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиКлиент.Зашифровать(Обработчик, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗашифроватьПослеШифрованияНаКлиенте(Результат, ПараметрыВыполнения) Экспорт
	
	Если Не Результат.Успех Тогда
		Возврат;
	КонецЕсли;
	
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ИмяРабочегоКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	
	МассивФайловВРабочемКаталогеДляУдаления = Новый Массив;
	ЕстьЗашифрованныеИлиЗанятыеФайлы = Неопределено;
	
	ЗашифроватьСервер(
		Результат.МассивДанныхДляЗанесенияВБазу,
		Результат.МассивОтпечатков,
		МассивФайловВРабочемКаталогеДляУдаления,
		ИмяРабочегоКаталога,
		ПараметрыВыполнения.ОбъектСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	РаботаСФайламиКлиент.ИнформироватьОШифровании(
		МассивФайловВРабочемКаталогеДляУдаления,
		ПараметрыВыполнения.ДанныеФайла.Владелец,
		ПараметрыВыполнения.ОбъектСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	ОбновитьДоступностьКомандСпискаФайлов();
	
КонецПроцедуры

&НаСервере
Процедура ЗашифроватьСервер(МассивДанныхДляЗанесенияВБазу, МассивОтпечатков, 
	МассивФайловВРабочемКаталогеДляУдаления,
	ИмяРабочегоКаталога, ОбъектСсылка, ЕстьЗашифрованныеИлиЗанятыеФайлы)
	
	Зашифровать = Истина;
	РаботаСФайламиВызовСервера.ЗанестиИнформациюОШифровании(
		ОбъектСсылка,
		Зашифровать,
		МассивДанныхДляЗанесенияВБазу,
		Неопределено,  // УникальныйИдентификатор
		ИмяРабочегоКаталога,
		МассивФайловВРабочемКаталогеДляУдаления,
		МассивОтпечатков);
	
	СсылкаВладелецФайла = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ОбъектСсылка, "ВладелецФайла");
	ЕстьЗашифрованныеИлиЗанятыеФайлы = РаботаСФайламиВызовСервера.ЕстьЗашифрованныеИлиЗанятыеФайлы(СсылкаВладелецФайла);	

КонецПроцедуры

&НаКлиенте
Процедура Расшифровать(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ОбъектСсылка = Элементы.Файлы.ТекущаяСтрока;
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИКоличествоВерсий(ОбъектСсылка);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	ПараметрыОбработчика.Вставить("ОбъектСсылка", ОбъектСсылка);
	Обработчик = Новый ОписаниеОповещения("РасшифроватьПослеРасшифровкиНаКлиенте", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиКлиент.Расшифровать(
		Обработчик,
		ДанныеФайла.Ссылка,
		УникальныйИдентификатор,
		ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифроватьПослеРасшифровкиНаКлиенте(Результат, ПараметрыВыполнения) Экспорт
	
	Если Не Результат.Успех Тогда
		Возврат;
	КонецЕсли;
	
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ИмяРабочегоКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	
	ЕстьЗашифрованныеИлиЗанятыеФайлы = Неопределено;
	
	РасшифроватьСервер(
		Результат.МассивДанныхДляЗанесенияВБазу,
		ИмяРабочегоКаталога,
		ПараметрыВыполнения.ОбъектСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	РаботаСФайламиКлиент.ИнформироватьОРасшифровке(
		ПараметрыВыполнения.ДанныеФайла.Владелец,
		ПараметрыВыполнения.ОбъектСсылка,
		ЕстьЗашифрованныеИлиЗанятыеФайлы);
	
	ОбновитьДоступностьКомандСпискаФайлов();
	
КонецПроцедуры

&НаСервере
Процедура РасшифроватьСервер(МассивДанныхДляЗанесенияВБазу, 
	ИмяРабочегоКаталога, ОбъектСсылка, ЕстьЗашифрованныеИлиЗанятыеФайлы)
	
	Зашифровать = Ложь;
	МассивОтпечатков = Новый Массив;
	МассивФайловВРабочемКаталогеДляУдаления = Новый Массив;
	
	РаботаСФайламиВызовСервера.ЗанестиИнформациюОШифровании(
		ОбъектСсылка,
		Зашифровать,
		МассивДанныхДляЗанесенияВБазу,
		Неопределено,  // УникальныйИдентификатор
		ИмяРабочегоКаталога,
		МассивФайловВРабочемКаталогеДляУдаления,
		МассивОтпечатков);
	
КонецПроцедуры
     
// Доступны файловые команды - есть хотя бы одна строка в списке и выделена не группировка
&НаКлиенте
Функция ФайловыеКомандыДоступны()
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Элементы.Файлы.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ИмпортФайлов(Команда)
	
	Обработчик = Новый ОписаниеОповещения("ИмпортФайловПослеУстановкиРасширения", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик);

КонецПроцедуры

&НаКлиенте
Процедура ИмпортФайловПослеУстановкиРасширения(Результат, ПараметрыВыполнения) Экспорт
	
	Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСФайлами(Неопределено);
		Возврат;
	КонецЕсли;
		
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			"Создание:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ВыполнитьИмпортФайлов(Объект.БизнесПроцесс);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Команда)
	
	ВыполнениеЗадачПоПочтеКлиент.СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
// Выполнить импорт файлов
Процедура ВыполнитьИмпортФайлов(ВладелецИмпортированныхФайлов)
	
	// заранее выбираем файлы (до открытия диалога импорта)
	Режим = РежимДиалогаВыбораФайла.Открытие;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Истина;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы'");
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		МассивИменФайлов = Новый Массив;
		
		МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
		Для Каждого ИмяФайла Из МассивФайлов Цикл
			МассивИменФайлов.Добавить(ИмяФайла);
		КонецЦикла;
		
		ПараметрыИмпорта = Новый Структура("ПапкаДляДобавления, МассивИменФайлов", 
			ВладелецИмпортированныхФайлов, МассивИменФайлов);
		ОткрытьФорму("Справочник.Файлы.Форма.ФормаИмпортаФайлов", ПараметрыИмпорта);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(Элементы.Файлы.ТекущаяСтрока);
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	
	РаботаСФайламиКлиент.ОбновитьИзФайлаНаДискеСОповещением(
		Обработчик,
		ДанныеФайла, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	Если Объект.Ссылка.Пустая()
		И Элементы.ФайлыДобавленные.ТекущаяСтрока <> Неопределено Тогда
		Если ЭтоАдресВременногоХранилища(Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть) Тогда 
			ТекущийФайлВСпискеДобавленных = ПолучитьИзВременногоХранилища(Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть).Ссылка;
			Записать();
		Иначе			
			РаботаСФайламиКлиент.ЗапуститьПриложениеПоИмениФайла(
				Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть);
		КонецЕсли;	
	Иначе
		
		Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
		РаботаСФайламиКлиент.РедактироватьСОповещением(
			Обработчик, 
			Элементы.Файлы.ТекущаяСтрока);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);

	РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(
		Обработчик,
		Элементы.Файлы.ТекущаяСтрока,
		ЭтаФорма.УникальныйИдентификатор,
		Элементы.Файлы.ТекущиеДанные.ХранитьВерсии,
		Элементы.Файлы.ТекущиеДанные.РедактируетТекущийПользователь,
		Элементы.Файлы.ТекущиеДанные.Редактирует);
		
КонецПроцедуры

&НаКлиенте
Процедура Занять(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;

	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	РаботаСФайламиКлиент.ЗанятьСОповещением(Обработчик, Элементы.Файлы.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	РаботаСФайламиКлиент.ОсвободитьФайлСОповещением(
		Обработчик,
		Элементы.Файлы.ТекущаяСтрока,
		Элементы.Файлы.ТекущиеДанные.ХранитьВерсии,
		Элементы.Файлы.ТекущиеДанные.РедактируетТекущийПользователь,
		Элементы.Файлы.ТекущиеДанные.Редактирует);
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	РаботаСФайламиКлиент.ОпубликоватьФайлСОповещением(
		Обработчик,
		Элементы.Файлы.ТекущаяСтрока, 
		ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗначениеПараметра = Файлы.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВладелецФайла"));
	Если Не ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда 
		Файлы.Параметры.УстановитьЗначениеПараметра("ВладелецФайла", Объект.Ссылка);
	КонецЕсли;	
	
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСПоследнимиОбъектами.ЗаписатьОбращениеКОбъекту(Объект.Ссылка);
		РаботаСФлагамиОбъектовСервер.СохранитьФлагОбъектаИзФормы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Оповестить("ОбновитьСписокПоследних");
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
КонецПроцедуры

&НаСервере
Функция ПользовательЕстьВБазе(Автор)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Пользователи.Ссылка
	               |ИЗ
	               |	Справочник.Пользователи КАК Пользователи
	               |ГДЕ
	               |	Пользователи.Ссылка = &Автор";
				   
	Запрос.УстановитьПараметр("Автор", Автор);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции 	

&НаКлиенте
Процедура ОтображатьУдаленныеФайлы(Команда)
	ОтображатьУдаленныеФайлыСервер();
КонецПроцедуры

&НаСервере
Процедура ОтображатьУдаленныеФайлыСервер()
	РаботаСБизнесПроцессами.ФормаБизнесПроцессаОтображатьУдаленныеФайлы(ЭтаФорма);
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
