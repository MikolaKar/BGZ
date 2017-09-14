
////////////////////////////////////////////////////////////////////////////////
// Команды работы с бизнес процессами клиент.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Отмечает указанный бизнес-процесс как остановленный
//
Процедура Остановить(Знач ПараметрКоманды, Форма) Экспорт
	
	ТекстВопроса = "";
	
	ЧислоЗадач = 0;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		
		ЧислоЗадач = БизнесПроцессыИЗадачиВызовСервера.ПолучитьЧислоНевыполненныхЗадачБизнесПроцессов(ПараметрКоманды);
		Если ПараметрКоманды.Количество() = 1 Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '
				|Будет выполнена остановка процесса ""%1"", его невыполненных задач (%2) и подчиненных процессов. Продолжить?'"), 
				Строка(ПараметрКоманды[0]), ЧислоЗадач);
		ИначеЕсли ПараметрКоманды.Количество() = 0 Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Выберите один или несколько процессов!'"));		
			Возврат;
		Иначе		
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '
				|Будет выполнена остановка процессов (%1), их невыполненных задач (%2) и подчиненных процессов. Продолжить?'"), 
				ПараметрКоманды.Количество(), ЧислоЗадач);
		КонецЕсли;		
		
	Иначе
		
		ЧислоЗадач = БизнесПроцессыИЗадачиВызовСервера.ПолучитьЧислоНевыполненныхЗадачБизнесПроцесса(ПараметрКоманды);
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '
			|Будет выполнена остановка процесса ""%1"", его невыполненных задач (%2) и подчиненных процессов. Продолжить?'"), 
			Строка(ПараметрКоманды), ЧислоЗадач);
			
	КонецЕсли;
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ПараметрКоманды", ПараметрКоманды);
	ПараметрыОбработчика.Вставить("Форма", Форма);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОстановитьПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчика);
	ПоказатьВопрос(
		ОписаниеОповещения, 
		ТекстВопроса, 
		РежимДиалогаВопрос.ДаНет, , 
		КодВозвратаДиалога.Нет, НСтр("ru = 'Остановка процесса'"));

КонецПроцедуры

Процедура ОстановитьПродолжение(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрКоманды = Параметры.ПараметрКоманды;
	Форма = Параметры.Форма;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		Если ПараметрКоманды.Количество() = 1 Тогда
			Состояние(НСтр("ru = 'Идет остановка процесса. Пожалуйста подождите...'"));
		Иначе
			Состояние(НСтр("ru = 'Идет остановка процессов. Пожалуйста подождите...'"));
		КонецЕсли;	
		
		БизнесПроцессыИЗадачиВызовСервера.ОстановитьБизнесПроцессы(ПараметрКоманды);
		
		Если ПараметрКоманды.Количество() = 1 Тогда
			Состояние(НСтр("ru = 'Остановка процесса успешно завершена!'"));
		Иначе	
			Состояние(НСтр("ru = 'Остановка процессов успешно завершена!'"));
		КонецЕсли;	
	Иначе	
		Состояние(НСтр("ru = 'Идет остановка процесса. Пожалуйста подождите...'"));
		БизнесПроцессыИЗадачиВызовСервера.ОстановитьБизнесПроцесс(ПараметрКоманды);
		Состояние(НСтр("ru = 'Остановка процесса успешно завершена!'"));
	КонецЕсли;
	
	Оповестить("БизнесПроцессИзменен", ПараметрКоманды, Форма);
	
КонецПроцедуры

// Отмечает указанный бизнес-процесс как активный
//
Процедура СделатьАктивным(Знач ПараметрКоманды, Форма) Экспорт
	
	ТекстВопроса = "";
	
	ЧислоЗадач = 0;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		
		ЧислоЗадач = БизнесПроцессыИЗадачиВызовСервера.ПолучитьЧислоНевыполненныхЗадачБизнесПроцессов(ПараметрКоманды);
		Если ПараметрКоманды.Количество() = 1 Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '
				|Процесс ""%1"", его задачи (%2) и подчиненные процессы будут сделаны активными. Продолжить?'"), 
				Строка(ПараметрКоманды[0]), ЧислоЗадач);
		ИначеЕсли ПараметрКоманды.Количество() = 0 Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Выберите один или несколько процессов!'"));		
			Возврат;
		Иначе		
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '
				|Процессы (%1), их задачи (%2) и подчиненные процессы будут сделаны активными. Продолжить?'"), 
				ПараметрКоманды.Количество(), ЧислоЗадач);
		КонецЕсли;		
		
	Иначе
		
		ЧислоЗадач = БизнесПроцессыИЗадачиВызовСервера.ПолучитьЧислоНевыполненныхЗадачБизнесПроцесса(ПараметрКоманды);
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '
			|Процесс ""%1"", его задачи (%2) и подчиненные процессы будут сделаны активными. Продолжить?'"), 
			Строка(ПараметрКоманды), ЧислоЗадач);
			
	КонецЕсли;
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ПараметрКоманды", ПараметрКоманды);
	ПараметрыОбработчика.Вставить("Форма", Форма);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СделатьАктивнымПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчика);
	
	ПоказатьВопрос(
		ОписаниеОповещения,
		ТекстВопроса, 
		РежимДиалогаВопрос.ДаНет, , 
		КодВозвратаДиалога.Нет, 
		НСтр("ru = 'Остановка процесса'"));	
	
КонецПроцедуры

Процедура СделатьАктивнымПродолжение(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрКоманды = Параметры.ПараметрКоманды;
	Форма = Параметры.Форма;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		Если ПараметрКоманды.Количество() = 1 Тогда
			Состояние(НСтр("ru = 'Процесс и его задачи делаются активными. Пожалуйста подождите...'"));
		Иначе	
			Состояние(НСтр("ru = 'Процессы и их задачи делаются активными. Пожалуйста подождите...'"));
		КонецЕсли;	
		БизнесПроцессыИЗадачиВызовСервера.СделатьАктивнымБизнесПроцессы(ПараметрКоманды);
		Если ПараметрКоманды.Количество() = 1 Тогда
			Состояние(НСтр("ru = 'Процесс, его задачи и подчиненные процессы сделаны активными!'"));
		Иначе	
			Состояние(НСтр("ru = 'Процессы, их задачи и подчиненные процессы сделаны активными!'"));
		КонецЕсли;	
	Иначе	
		Состояние(НСтр("ru = 'Идет отмена остановки процесса. Пожалуйста подождите...'"));
		БизнесПроцессыИЗадачиВызовСервера.СделатьАктивнымБизнесПроцесс(ПараметрКоманды);
		Состояние(НСтр("ru = 'Процесс, его задачи и подчиненные процессы сделаны активными!'"));
	КонецЕсли;
	
	Оповестить("БизнесПроцессИзменен", ПараметрКоманды, Форма);
	
КонецПроцедуры

// Отмечает указанные задачи как принятые к исполнению
//
Процедура ПринятьЗадачиКИсполнению(Знач МассивЗадач, Форма) Экспорт
	
	ВыбраноЗадач = МассивЗадач.Количество();
	Если ВыбраноЗадач = 0 
		или ВыбраноЗадач = 1 И ТипЗнч(МассивЗадач[0]) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыИЗадачиСервер.ПринятьЗадачиКИсполнению(МассивЗадач);
	Если МассивЗадач.Количество() = 0 Тогда
		Возврат;
	ИначеЕсли МассивЗадач.Количество() <> 1 Тогда
		Состояние(НСтр("ru = 'Задачи приняты к исполнению!'"));
	Иначе		
		Состояние(НСтр("ru = 'Задача принята к исполнению!'"));
	КонецЕсли;	
	
	Оповестить("ЗадачаИзменена", МассивЗадач, Форма);
	
КонецПроцедуры

// Отмечает указанную задачу как принятую к исполнению
//
Процедура ПринятьЗадачуКИсполнению(Форма, ТекущийПользователь) Экспорт
	
	Форма.Объект.ПринятаКИсполнению = Истина;
	Форма.Объект.ДатаПринятияКИсполнению = ТекущаяДата();
	Если Форма.Объект.Исполнитель.Пустая() Тогда
		Форма.Объект.Исполнитель = ТекущийПользователь;
	КонецЕсли;	
			
	Форма.Записать();
	Состояние(НСтр("ru = 'Задача принята к исполнению!'"));
	ОбновитьДоступностьКомандПринятияКИсполнению(Форма);
	
	УстановитьИсполнителя(Форма);
	
	Оповестить("ЗадачаИзменена", Форма.Объект.Ссылка, Форма);

КонецПроцедуры

// Отмечает указанные задачи как не принятые к исполнению
//
Процедура ОтменитьПринятиеЗадачКИсполнению(Знач МассивЗадач, Форма) Экспорт
	
	ВыбраноЗадач = МассивЗадач.Количество();
	Если ВыбраноЗадач = 0 
		или ВыбраноЗадач = 1 И ТипЗнч(МассивЗадач[0]) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыИЗадачиВызовСервера.ОтменитьПринятиеЗадачКИсполнению(МассивЗадач);
	Если МассивЗадач.Количество() = 0 Тогда
		Возврат;
	ИначеЕсли МассивЗадач.Количество() <> 1 Тогда
		Состояние(НСтр("ru = 'Задачи помечены как НЕ принятые к исполнению!'"));
	Иначе		
		Состояние(НСтр("ru = 'Задача помечена как НЕ принятая к исполнению!'"));
	КонецЕсли;		
	
	Оповестить("ЗадачаИзменена", МассивЗадач, Форма);
	
КонецПроцедуры

// Отмечает указанную задачу как не принятую к исполнению
//
Процедура ОтменитьПринятиеЗадачиКИсполнению(Форма) Экспорт
	
	Форма.Объект.ПринятаКИсполнению = Ложь;
	Форма.Объект.ДатаПринятияКИсполнению = "00010101000000";
	Если Не Форма.Объект.РольИсполнителя.Пустая() Тогда
		Форма.Объект.Исполнитель = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	КонецЕсли;	
	
	Форма.Записать();
	Состояние(НСтр("ru = 'Задача помечена как НЕ принятая к исполнению!'"));
	ОбновитьДоступностьКомандПринятияКИсполнению(Форма);
	
	УстановитьИсполнителя(Форма);
	
	Оповестить("ЗадачаИзменена", Форма.Объект.Ссылка, Форма);
	
КонецПроцедуры

// Отмечает указанный бизнес-процесс как остановленный.
// Предназначена для вызова из формы бизнес-процесса.
//
Процедура ОстановитьБизнесПроцессИзФормыОбъекта(Форма) Экспорт
	
	ИзменитьСостояниеБизнесПроцессаИзФормы(
		Форма,
		ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Остановлен"),
		НСтр("ru = 'Процесс остановлен'"));
	
КонецПроцедуры

// Отмечает указанный бизнес-процесс как прерванный.
// Предназначена для вызова из формы бизнес-процесса (Начало).
//
Процедура ПрерватьБизнесПроцессИзФормыОбъекта(Форма) Экспорт
	
	Если Форма.Объект.Завершен Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя прервать уже завершенный процесс!'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ Форма.Объект.Стартован Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя прервать не стартовавшие процессы!'"));
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.Объект.ВедущаяЗадача) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя прервать процесс являющийся частью комплексного или составного процесса!'"));
		Возврат;
	КонецЕсли;
	
	ОбъектСсылка = Форма.Объект.Ссылка;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("БизнесПроцесс", ОбъектСсылка);
	
	ОткрытьФорму("ОбщаяФорма.ПрерываниеПроцесса", ПараметрыФормы, Форма);
	
КонецПроцедуры

// Отмечает указанный бизнес-процесс как прерванный.
// Предназначена для вызова из формы бизнес-процесса (Окончание).
//
Процедура ПрерватьБизнесПроцессИзФормыОбъектаОкончание(Форма, Результат) Экспорт

	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.ВладелецФормы <> Форма Тогда
		Возврат;
	КонецЕсли;

	ОбъектСсылка = Форма.Объект.Ссылка;
	
	ПредыдущееСостояние = Форма.Объект.Состояние;
	
	Форма.ЗаблокироватьДанныеФормыДляРедактирования();
	Форма.Объект.Состояние = ПредопределенноеЗначение(
		"Перечисление.СостоянияБизнесПроцессов.Прерван");
	Форма.Объект.ПричинаПрерывания = Результат.ПричинаПрерывания;
	
	Попытка
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("ПрерываниеПроцесса", Истина);
		Форма.Записать(ПараметрыЗаписи);
	Исключение
		СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ПоказатьПредупреждение(, СообщениеОбОшибке);
		Форма.Объект.Состояние = ПредыдущееСостояние;
		Возврат;
	КонецПопытки;
	
	ПротоколированиеРаботыПользователей.ЗаписатьПрерываниеБизнесПроцесса(ОбъектСсылка);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Процесс прерван'"),
		ПолучитьНавигационнуюСсылку(ОбъектСсылка),
		Строка(ОбъектСсылка),
		БиблиотекаКартинок.Информация32);
	ОповеститьОбИзменении(ОбъектСсылка);
	
	Оповестить("ОтобразитьПрерванныеЗадачиВФормеЗадачиПоБизнесПроцессу", ОбъектСсылка);
	
	Для Каждого СтрокаПредмета из Форма.Объект.Предметы Цикл
		Если Не ЗначениеЗаполнено(СтрокаПредмета.Предмет) Тогда
			Продолжить;
		КонецЕсли;
		
		ИнформацияОЗапуске = Новый Структура();
		ИнформацияОЗапуске.Вставить("СсылкаНаБизнесПроцесс", Форма.Объект.Ссылка);
		ИнформацияОЗапуске.Вставить("СсылкаНаПредметБизнесПроцесса", СтрокаПредмета.Предмет);
		
		Оповестить("БизнесПроцессПрерван", ИнформацияОЗапуске);
	КонецЦикла;
	
КонецПроцедуры

// Отмечает указанный бизнес-процесс как прерванный.
//
Процедура ПрерватьБизнесПроцесс(Процесс, Форма) Экспорт
	
	РеквизитыПроцесса = 
		ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Процесс, "Завершен, Стартован, ВедущаяЗадача, Состояние");
	
	Если РеквизитыПроцесса.Состояние = 
		ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Прерван") Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Процесс уже прерван!'"));
		Возврат;
	КонецЕсли;
	
	Если РеквизитыПроцесса.Завершен Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя прервать уже завершенный процесс!'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ РеквизитыПроцесса.Стартован Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нельзя прервать не стартовавшие процессы!'"));
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РеквизитыПроцесса.ВедущаяЗадача) Тогда
		ПоказатьПредупреждение(,
		НСтр("ru = 'Нельзя прервать процесс являющийся частью комплексного или составного процесса!'"));
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПрерватьБизнесПроцесс_Продолжение", ЭтотОбъект, Процесс);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("БизнесПроцесс", Процесс);
	
	ОткрытьФорму("ОбщаяФорма.ПрерываниеПроцесса",
		ПараметрыФормы, Форма,,,,ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ПрерватьБизнесПроцесс_Продолжение(РезультатПрерывания, Процесс) Экспорт
	
	Если ТипЗнч(РезультатПрерывания) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыИЗадачиВызовСервера.ПрерватьБизнесПроцесс(
		Процесс, РезультатПрерывания.ПричинаПрерывания);
	
	ПротоколированиеРаботыПользователей.ЗаписатьПрерываниеБизнесПроцесса(Процесс);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Процесс прерван'"),
		ПолучитьНавигационнуюСсылку(Процесс),
		Строка(Процесс),
		БиблиотекаКартинок.Информация32);
	ОповеститьОбИзменении(Процесс);
	
	Оповестить("ОтобразитьПрерванныеЗадачиВФормеЗадачиПоБизнесПроцессу", Процесс);
	Оповестить("БизнесПроцессИзменен", Процесс);
	
	Предметы = МультипредметностьВызовСервера.ПолучитьПредметыПроцесса(Процесс, Истина);
	
	Для Каждого Предметы из Предметы Цикл
		Если Не ЗначениеЗаполнено(Предметы) Тогда
			Продолжить;
		КонецЕсли;
		
		ИнформацияОЗапуске = Новый Структура();
		ИнформацияОЗапуске.Вставить("СсылкаНаБизнесПроцесс", Процесс);
		ИнформацияОЗапуске.Вставить("СсылкаНаПредметБизнесПроцесса", Предметы);
		
		Оповестить("БизнесПроцессПрерван", ИнформацияОЗапуске);
	КонецЦикла;
	
КонецПроцедуры

// Показывает окно с причиной прерывания процесса
//
Процедура ПоказатьПричинуПрерывания(Форма) Экспорт
	
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда		
		БизнесПроцесс = ОбщегоНазначения.ПолучитьЗначениеРеквизита(
			Форма.Объект.Ссылка, 
			"БизнесПроцесс");
		Если НЕ ЗначениеЗаполнено(БизнесПроцесс) Тогда
			Возврат;		
		КонецЕсли;
	Иначе
		БизнесПроцесс = Форма.Объект.Ссылка;
	КонецЕсли;
	
	КтоИКогдаПрервалПроцесс = БизнесПроцессыИЗадачиСервер.ПолучитьИнформациюОПрерыванииПроцесса(
		БизнесПроцесс);	
		
	ПараметрыФормы = Новый Структура();
			
	ПараметрыФормы.Вставить("КтоИКогдаПрервалПроцесс", КтоИКогдаПрервалПроцесс);
	
	ОткрытьФорму("ОбщаяФорма.ПричинаПрерыванияПроцесса", ПараметрыФормы,
		Форма,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

// Отмечает указанный бизнес-процесс как активный.
// Предназначена для вызова из формы бизнес-процесса.
//
Процедура ПродолжитьБизнесПроцессИзФормыОбъекта(Форма) Экспорт
	
	ИзменитьСостояниеБизнесПроцессаИзФормы(
		Форма,
		ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Активен"),
		НСтр("ru = 'Процесс сделан активным'"));
	
КонецПроцедуры

// Устанавливает доступность команд принятия к исполнению
//
Процедура ОбновитьДоступностьКомандПринятияКИсполнению(Форма) Экспорт
	
	Если Форма.Объект.ПринятаКИсполнению = Истина Тогда
		Форма.Элементы.ФормаПринятьКИсполнению.Доступность = Ложь;
		Форма.Элементы.ФормаОтменитьПринятиеКИсполнению.Доступность = Истина;
	Иначе	
		Форма.Элементы.ФормаПринятьКИсполнению.Доступность = Истина;
		Форма.Элементы.ФормаОтменитьПринятиеКИсполнению.Доступность = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

// Отменяет выполнение задачи Исполнить в процессах Согласования и Исполнения. При успешной
// отмене выполнения задачи пользователю показывается оповещение.
// Иначе выдается предупреждение о том, что отмена задачи невозможна.
//
// Параметры:
//   Форма - УправляемаяФорма - форма объекта задачи
//
Процедура ОтменитьВыполнениеЗадачи(Форма) Экспорт
	
	Задача = Форма.Объект.Ссылка;
	
	РезультатОтменыВыполнения = БизнесПроцессыИЗадачиВызовСервера.ОтменитьВыполнениеЗадачи(Задача);
	Если РезультатОтменыВыполнения.Отказ Тогда
		ПоказатьПредупреждение(, РезультатОтменыВыполнения.ПричинаОтказа);
		Возврат;
	КонецЕсли;
	
	Оповестить("ОтмененоВыполнениеЗадачи", Задача);
	Оповестить("ЗадачаИзменена", Задача, Форма);
	
	ТекстОповещения = НСтр("ru = 'Выполнение задачи отменено.'");
	
	ПоказатьОповещениеПользователя(
		ТекстОповещения,
		ПолучитьНавигационнуюСсылку(Задача),
		Задача,
		БиблиотекаКартинок.Информация32)
	
КонецПроцедуры

Процедура НастроитьОтложенныйСтарт(Форма, СрокИсполненияПроцесса = '00010101') Экспорт
	
	Объект = Форма.Объект;
	
	Если НЕ Объект.Стартован
		И Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Активен")
		И (Форма.Модифицированность
			ИЛИ Объект.Ссылка.Пустая()
			ИЛИ Форма.НастройкаОтложенногоСтарта = Неопределено
			ИЛИ Форма.НастройкаОтложенногоСтарта.Состояние <> 
				ПредопределенноеЗначение("Перечисление.СостоянияОтложенныхПроцессов.ГотовКСтарту")) Тогда
			
		Форма.ЗаблокироватьДанныеФормыДляРедактирования();
		
		// Проверка заполнения процесса
		Отказ = Ложь;
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("ПроверкаПередОткрытиемФормыОтложенногоСтарта", Истина);
		ПараметрыЗаписи.Вставить("СрокИсполнения", СрокИсполненияПроцесса);
		Форма.ПроверитьЗаполнениеПроцессаДляОтложенногоСтарта(Отказ, ПараметрыЗаписи, Истина);
		Возврат;
		
	Иначе
		ОтложенныйСтартБизнесПроцессовКлиент.НастроитьОтложенныйСтарт(
			Объект.Ссылка, СрокИсполненияПроцесса);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПереключитьХронометраж(Форма) Экспорт
	
	ВключенХронометраж = Форма.ВключенХронометраж;
	ДатаНачалаХронометража = Форма.ДатаНачалаХронометража;
	ВидыРабот = Форма.ВидыРабот;
	
	Попытка
		СсылкаНаЗадачу = Форма.ЗадачиМнеТекущаяЗадача;
	Исключение
		СсылкаНаЗадачу = Форма.Объект.Ссылка;
	КонецПопытки;
	
	СпособУказанияВремени = Форма.СпособУказанияВремени;
	
	ПараметрыОповещения = Неопределено;
	НуженДиалог = УчетВремениКлиент.НуженДиалогДляХронометража(ВключенХронометраж, 
		ДатаНачалаХронометража, ВидыРабот);
		
	Если НуженДиалог = Ложь Тогда
		
		Форма.ПереключитьХронометражСервер(ПараметрыОповещения);
		УчетВремениКлиент.ПоказатьОповещение(ПараметрыОповещения, ВключенХронометраж, СсылкаНаЗадачу);
	
	Иначе
		ДлительностьРаботы = УчетВремениКлиент.ПолучитьДлительностьРаботы(ДатаНачалаХронометража);
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ДатаОтчета", ТекущаяДата());
		ПараметрыФормы.Вставить("ВидыРабот", ВидыРабот);
		ПараметрыФормы.Вставить("ОписаниеРаботы", Строка(СсылкаНаЗадачу));
		ПараметрыФормы.Вставить("ДлительностьРаботы", ДлительностьРаботы);
		ПараметрыФормы.Вставить("НачалоРаботы", ДатаНачалаХронометража);
		ПараметрыФормы.Вставить("Объект", СсылкаНаЗадачу);
		ПараметрыФормы.Вставить("СпособУказанияВремени", СпособУказанияВремени);
		
		ПараметрыОповещения = Новый Структура();
		ПараметрыОповещения.Вставить("ФормаОбъекта", Форма);
		ПараметрыОповещения.Вставить("ТипДействия", "ПереключитьХронометраж");
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗавершениеФормыДобавленияРаботы", УчетВремениКлиент, ПараметрыОповещения);
			
		ОткрытьФорму(
			"РегистрСведений.ФактическиеТрудозатраты.Форма.ФормаДобавленияРаботы", 
			ПараметрыФормы, 
			Форма,,,, 
			ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура Перенаправить(Форма) Экспорт
	
	Если Форма.Объект.Выполнена Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Уже выполненную задачу нельзя перенаправить.'"));
		Возврат;
	КонецЕсли;	
			
	Если Форма.Записать() Тогда
		БизнесПроцессыИЗадачиКлиент.ПеренаправитьЗадачу(Форма.Объект.Ссылка, Форма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьИсполнителя(Форма)
	
	Если НЕ Форма.Объект.Исполнитель.Пустая() Тогда
		Форма.ИсполнительСтрокой = Форма.Объект.Исполнитель;
		Форма.Элементы.ИсполнительСтрокой.КнопкаОткрытия = Истина;
	Иначе
		Форма.ИсполнительСтрокой = Строка(Форма.Объект.РольИсполнителя);
		
		Если Форма.Объект.ОсновнойОбъектАдресации <> Неопределено И НЕ Форма.Объект.ОсновнойОбъектАдресации.Пустая() Тогда
			Форма.ИсполнительСтрокой = Форма.ИсполнительСтрокой + ", " + Форма.Объект.ОсновнойОбъектАдресации;
		КонецЕсли;	
		
		Если Форма.Объект.ДополнительныйОбъектАдресации <> Неопределено И НЕ Форма.Объект.ДополнительныйОбъектАдресации.Пустая() Тогда
			Форма.ИсполнительСтрокой = Форма.ИсполнительСтрокой + ", " + Форма.Объект.ДополнительныйОбъектАдресации;
		КонецЕсли;	
		Форма.Элементы.ИсполнительСтрокой.КнопкаОткрытия = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Изменяет состояние бизнес-процесса из формы. При успешной установке состояния
// пользователю показывается постепенно затухающее окно с ТекстоСообщения.
// Если же состояние не изменено, то выдается предупреждение.
//
// Параметры:
//   - Форма - УправляемаяФорма - форма объекта бизнес-процесса.
//   - НовоеСостояние - ПеречислениеСсылка.СостоянияБизнесПроцессов - новое состояние 
//                      которое необходимо установить процессу из формы
//   - ТекстСообщения - Строка - текст сообщения которые будет показан в постепенно затухающем
//                      окне.
//
Процедура ИзменитьСостояниеБизнесПроцессаИзФормы(Форма, НовоеСостояние, ТекстСообщения)
	
	ПредыдущееСостояние = Форма.Объект.Состояние;
	
	Форма.ЗаблокироватьДанныеФормыДляРедактирования();
	Форма.Объект.Состояние = НовоеСостояние;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ИзменениеСостоянияПроцесса", Истина);
	ПараметрыЗаписи.Вставить("СообщениеПриИзмененииСостоянияПроцесса", ТекстСообщения);
	
	Попытка
		Если НЕ Форма.Записать(ПараметрыЗаписи) Тогда
			Возврат;
		КонецЕсли;;
	Исключение
		СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ПоказатьПредупреждение(, СообщениеОбОшибке);
		Форма.Объект.Состояние = ПредыдущееСостояние;
		Возврат;
	КонецПопытки;
	
	ПоказатьОповещениеПользователя(
		ТекстСообщения,
		ПолучитьНавигационнуюСсылку(Форма.Объект.Ссылка),
		Строка(Форма.Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	ОповеститьОбИзменении(Форма.Объект.Ссылка);
	
КонецПроцедуры



#КонецОбласти
