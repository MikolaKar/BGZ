
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьПоля();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПоля()
	
	ЧислоЗадачВсего = ПолучитьЧислоЗадачВсего();
	ЧислоЗадачРассмотрение = ПолучитьЧислоЗадачРассмотрения();
	ЧислоЗадачСогласование = ПолучитьЧислоЗадачСогласование();
	ЧислоЗадачУтверждение = ПолучитьЧислоЗадачУтверждение();

	ЧислоЗадачОтМеня = ПолучитьЧислоЗадачОтМеня();
	ЧислоЗадачОтМеняПросроченные = ПолучитьЧислоЗадачОтМеняПросроченные();
	
	ИсполнителиПросроченныхЗадач = ПолучитьСписокИсполнителейЗадачОтМеняПросроченные();
	
	Элементы.ДекорацияВсеЗадачи.Гиперссылка = (ЧислоЗадачВсего <> 0);
	Элементы.ДекорацияВсеЗадачи.Заголовок = НСтр("ru='Всего задач мне'") + " (" + Формат(ЧислоЗадачВсего, "ЧН=0") + ")";
	
	Элементы.ДекорацияНаРассмотрение.Гиперссылка = (ЧислоЗадачРассмотрение <> 0);
	Элементы.ДекорацияНаРассмотрение.Заголовок = НСтр("ru='На рассмотрение'") + " (" + Формат(ЧислоЗадачРассмотрение, "ЧН=0") + ")";
	
	Элементы.ДекорацияСогласование.Гиперссылка = (ЧислоЗадачСогласование <> 0);
	Элементы.ДекорацияСогласование.Заголовок = НСтр("ru='На согласование'") + " (" + Формат(ЧислоЗадачСогласование, "ЧН=0") + ")";
	
	Элементы.ДекорацияУтверждение.Гиперссылка = (ЧислоЗадачУтверждение <> 0);
	Элементы.ДекорацияУтверждение.Заголовок = НСтр("ru='На утверждение'") + " (" + Формат(ЧислоЗадачУтверждение, "ЧН=0") + ")";

	Элементы.ДекорацияЗадачиОтМеня.Гиперссылка = (ЧислоЗадачОтМеня <> 0);
	Элементы.ДекорацияЗадачиОтМеня.Заголовок = НСтр("ru='Задачи от меня'") + " (" + Формат(ЧислоЗадачОтМеня, "ЧН=0") + ")";
	
	Элементы.ДекорацияЗадачиОтМеняПросроченные.Гиперссылка = (ЧислоЗадачОтМеняПросроченные <> 0);
	Элементы.ДекорацияЗадачиОтМеняПросроченные.Заголовок = НСтр("ru='Просроченные'") + " (" + Формат(ЧислоЗадачОтМеняПросроченные, "ЧН=0") + ")";
	
	УстановитьКартинкуКоманды("ЗадачВсего", ЧислоЗадачВсего);
	УстановитьКартинкуКоманды("ЗадачОтМеняВсего", ЧислоЗадачОтМеня);
	УстановитьКартинкуКоманды("ЗадачВсегоПросроченные", ЧислоЗадачОтМеняПросроченные);
	УстановитьКартинкуКоманды("Рассмотрение", ЧислоЗадачРассмотрение);
	УстановитьКартинкуКоманды("Согласование", ЧислоЗадачСогласование);
	УстановитьКартинкуКоманды("Утверждение", ЧислоЗадачУтверждение);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинкуКоманды(ТипКартинки, Число)
	
	Картинка = ПолучитьКартинкуКоманды(ТипКартинки, Число);
	
	Если ТипКартинки = "ЗадачВсего" Тогда
		Элементы.КомандаВсеЗадачи.Картинка = Картинка;
	ИначеЕсли ТипКартинки = "ЗадачОтМеняВсего" Тогда
		Элементы.КомандаЗадачиОтМеня.Картинка = Картинка;
	ИначеЕсли ТипКартинки = "ЗадачВсегоПросроченные" Тогда
		Элементы.КомандаЗадачиОтМеняПросроченные.Картинка = Картинка;		
	ИначеЕсли ТипКартинки = "Рассмотрение" Тогда
		Элементы.КомандаРассмотрение.Картинка = Картинка;
	ИначеЕсли ТипКартинки = "Согласование" Тогда	
		Элементы.КомандаСогласование.Картинка = Картинка;					
	ИначеЕсли ТипКартинки = "Утверждение" Тогда
		Элементы.КомандаУтверждение.Картинка = Картинка;
	КонецЕсли;	
			
КонецПроцедуры

&НаСервере
Функция ПолучитьТипКоличества(Число)
	
	Если Число = 0 Тогда 
		Возврат "Нет";
	ИначеЕсли Число <= 5 Тогда 
		Возврат "Мало";	
	ИначеЕсли Число <= 10 Тогда 
		Возврат "Средне";	
	Иначе
		Возврат "Много";	
	КонецЕсли;	
	
КонецФункции

&НаСервере
Функция ПолучитьКартинкуКоманды(ТипКартинки, Число)
	
	ТипКоличества = ПолучитьТипКоличества(Число);
	
	Если ТипКартинки = "ЗадачВсего" ИЛИ ТипКартинки = "ЗадачОтМеняВсего" Тогда
		
		Если ТипКоличества = "Нет" Тогда
			Возврат БиблиотекаКартинок.РабочийСтолНетЗадач;
		ИначеЕсли ТипКоличества = "Мало" Тогда
			Возврат БиблиотекаКартинок.ВсеЗадачиМалоЗадач;
		ИначеЕсли ТипКоличества = "Средне" Тогда
			Возврат БиблиотекаКартинок.ВсеЗадачиСреднеЗадач;
		ИначеЕсли ТипКоличества = "Много" Тогда
			Возврат БиблиотекаКартинок.ВсеЗадачиМногоЗадач;
		КонецЕсли;	
		
	КонецЕсли;	
	
	Если ТипКартинки = "ЗадачВсегоПросроченные" Тогда
		
		Если ТипКоличества = "Нет" Тогда
			Возврат БиблиотекаКартинок.РабочийСтолНетЗадач;
		ИначеЕсли ТипКоличества = "Мало" Тогда
			Возврат БиблиотекаКартинок.ВсеЗадачиПросроченныеМалоЗадач;
		ИначеЕсли ТипКоличества = "Средне" Тогда
			Возврат БиблиотекаКартинок.ВсеЗадачиПросроченныеСреднеЗадач;
		ИначеЕсли ТипКоличества = "Много" Тогда
			Возврат БиблиотекаКартинок.ВсеЗадачиПросроченныеМногоЗадач;
		КонецЕсли;	
		
	КонецЕсли;	
	
	Если ТипКартинки = "Рассмотрение" Тогда
		
		Если ТипКоличества = "Нет" Тогда
			Возврат БиблиотекаКартинок.РабочийСтолНетЗадач;
		ИначеЕсли ТипКоличества = "Мало" Тогда
			Возврат БиблиотекаКартинок.РассмотрениеМалоЗадач;
		ИначеЕсли ТипКоличества = "Средне" Тогда
			Возврат БиблиотекаКартинок.РассмотрениеСреднеЗадач;
		ИначеЕсли ТипКоличества = "Много" Тогда
			Возврат БиблиотекаКартинок.РассмотрениеМногоЗадач;
		КонецЕсли;	
		
	КонецЕсли;	
	
	Если ТипКартинки = "Согласование" Тогда
		
		Если ТипКоличества = "Нет" Тогда
			Возврат БиблиотекаКартинок.РабочийСтолНетЗадач;
		ИначеЕсли ТипКоличества = "Мало" Тогда
			Возврат БиблиотекаКартинок.СогласованиеМалоЗадач;
		ИначеЕсли ТипКоличества = "Средне" Тогда
			Возврат БиблиотекаКартинок.СогласованиеСреднеЗадач;
		ИначеЕсли ТипКоличества = "Много" Тогда
			Возврат БиблиотекаКартинок.СогласованиеМногоЗадач;
		КонецЕсли;	
		
	КонецЕсли;	
	
	Если ТипКартинки = "Утверждение" Тогда
		
		Если ТипКоличества = "Нет" Тогда
			Возврат БиблиотекаКартинок.РабочийСтолНетЗадач;
		ИначеЕсли ТипКоличества = "Мало" Тогда
			Возврат БиблиотекаКартинок.УтверждениеМалоЗадач;
		ИначеЕсли ТипКоличества = "Средне" Тогда
			Возврат БиблиотекаКартинок.УтверждениеСреднеЗадач;
		ИначеЕсли ТипКоличества = "Много" Тогда
			Возврат БиблиотекаКартинок.УтверждениеМногоЗадач;
		КонецЕсли;	
		
	КонецЕсли;	
	
	Возврат БиблиотекаКартинок.РабочийСтолНетЗадач;
	
КонецФункции

&НаСервере
Функция ПолучитьЧислоЗадачБизнесПроцесса(БизнесПроцесс, ТочкаМаршрута)

	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	КОЛИЧЕСТВО(ЗадачаИсполнителя.Ссылка) КАК ЧислоЗадач
	               |ИЗ
	               |	Задача.ЗадачаИсполнителя.ЗадачиПоИсполнителю КАК ЗадачаИсполнителя
	               |ГДЕ
	               |	ЗадачаИсполнителя.ПометкаУдаления = &ПометкаУдаления
	               |	И ЗадачаИсполнителя.СостояниеБизнесПроцесса = &СостояниеБизнесПроцесса
	               |	И ТИПЗНАЧЕНИЯ(ЗадачаИсполнителя.БизнесПроцесс) = ТИПЗНАЧЕНИЯ(&БизнесПроцесс)
	               |	И ЗадачаИсполнителя.Выполнена = &Выполнена
	               |	И ЗадачаИсполнителя.ТочкаМаршрута = &ТочкаМаршрута";
	
	Запрос.УстановитьПараметр("ПометкаУдаления", Ложь);
	Запрос.УстановитьПараметр("СостояниеБизнесПроцесса", Перечисления.СостоянияБизнесПроцессов.Активен);
	Запрос.УстановитьПараметр("Выполнена", Ложь);
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	Запрос.УстановитьПараметр("ТочкаМаршрута", ТочкаМаршрута);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ЧислоЗадач;

КонецФункции 

&НаСервере
Функция ПолучитьЧислоЗадачСогласование()
	
	Возврат ПолучитьЧислоЗадачБизнесПроцесса(БизнесПроцессы.Согласование.ПустаяСсылка(), 
		БизнесПроцессы.Согласование.ТочкиМаршрута.Согласовать);

КонецФункции 

&НаСервере
Функция ПолучитьЧислоЗадачРассмотрения()

	Возврат ПолучитьЧислоЗадачБизнесПроцесса(БизнесПроцессы.Рассмотрение.ПустаяСсылка(), 
		БизнесПроцессы.Рассмотрение.ТочкиМаршрута.Рассмотреть);

КонецФункции 

&НаСервере
Функция ПолучитьЧислоЗадачУтверждение()

	Возврат ПолучитьЧислоЗадачБизнесПроцесса(БизнесПроцессы.Утверждение.ПустаяСсылка(), 
		БизнесПроцессы.Утверждение.ТочкиМаршрута.Утвердить);

КонецФункции 

&НаСервере
Функция ПолучитьЧислоЗадачВсего()

	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ 
	|	КОЛИЧЕСТВО(ЗадачаИсполнителя.Ссылка) КАК ЧислоЗадач
	|ИЗ
	|	Задача.ЗадачаИсполнителя.ЗадачиПоИсполнителю КАК ЗадачаИсполнителя
	|ГДЕ
	|	ЗадачаИсполнителя.ПометкаУдаления = &ПометкаУдаления
	|	И ЗадачаИсполнителя.СостояниеБизнесПроцесса = &СостояниеБизнесПроцесса
	|	И ЗадачаИсполнителя.Выполнена = &Выполнена";
	
	Запрос.УстановитьПараметр("ПометкаУдаления", Ложь);
	Запрос.УстановитьПараметр("СостояниеБизнесПроцесса", Перечисления.СостоянияБизнесПроцессов.Активен);
	Запрос.УстановитьПараметр("Выполнена", Ложь);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ЧислоЗадач;

КонецФункции 

&НаСервере
Функция ПолучитьЧислоЗадачОтМеня()

	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ 
	               |	КОЛИЧЕСТВО(ЗадачаИсполнителя.Ссылка) КАК ЧислоЗадач
	               |ИЗ
	               |	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	               |ГДЕ
	               |	ЗадачаИсполнителя.ПометкаУдаления = &ПометкаУдаления
	               |	И ЗадачаИсполнителя.СостояниеБизнесПроцесса = &СостояниеБизнесПроцесса
	               |	И ЗадачаИсполнителя.Автор = &Автор
				   |	И ЗадачаИсполнителя.Выполнена = &Выполнена";
	
	Запрос.УстановитьПараметр("ПометкаУдаления", Ложь);
	Запрос.УстановитьПараметр("СостояниеБизнесПроцесса", Перечисления.СостоянияБизнесПроцессов.Активен);
	Запрос.УстановитьПараметр("Автор", ПользователиКлиентСервер.ТекущийПользователь());
	Запрос.УстановитьПараметр("Выполнена", Ложь);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ЧислоЗадач;

КонецФункции 

&НаСервере
Функция ПолучитьЧислоЗадачОтМеняПросроченные()

	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ 
	               |	КОЛИЧЕСТВО(ЗадачаИсполнителя.Ссылка) КАК ЧислоЗадач
	               |ИЗ
	               |	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	               |ГДЕ
	               |	ЗадачаИсполнителя.ПометкаУдаления = &ПометкаУдаления
	               |	И ЗадачаИсполнителя.СостояниеБизнесПроцесса = &СостояниеБизнесПроцесса
	               |	И ЗадачаИсполнителя.Автор = &Автор
	               |	И (ЗадачаИсполнителя.СрокИсполнения <= &СрокИсполнения
			 	   |       И ЗадачаИсполнителя.СрокИсполнения <> ДАТАВРЕМЯ(1, 1, 1))
				   |	И ЗадачаИсполнителя.Выполнена = &Выполнена";
	
	Запрос.УстановитьПараметр("ПометкаУдаления", Ложь);
	Запрос.УстановитьПараметр("СостояниеБизнесПроцесса", Перечисления.СостоянияБизнесПроцессов.Активен);
	Запрос.УстановитьПараметр("Автор", ПользователиКлиентСервер.ТекущийПользователь());
	Запрос.УстановитьПараметр("СрокИсполнения", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Выполнена", Ложь);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ЧислоЗадач;

КонецФункции 

&НаСервере
Функция ПолучитьСписокИсполнителейЗадачОтМеняПросроченные()

	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	ВЫБОР
	               |		КОГДА ЗадачаИсполнителя.Исполнитель <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	               |			ТОГДА ЗадачаИсполнителя.Исполнитель
	               |		ИНАЧЕ ЗадачаИсполнителя.РольИсполнителя
	               |	КОНЕЦ КАК ИсполнительСтрока
	               |ИЗ
	               |	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	               |ГДЕ
	               |	ЗадачаИсполнителя.ПометкаУдаления = &ПометкаУдаления
	               |	И ЗадачаИсполнителя.СостояниеБизнесПроцесса = &СостояниеБизнесПроцесса
	               |	И ЗадачаИсполнителя.Автор = &Автор
	               |	И ЗадачаИсполнителя.СрокИсполнения <= &СрокИсполнения
	               |	И ЗадачаИсполнителя.СрокИсполнения <> ДАТАВРЕМЯ(1, 1, 1)
	               |	И ЗадачаИсполнителя.Выполнена = &Выполнена";
	
	Запрос.УстановитьПараметр("ПометкаУдаления", Ложь);
	Запрос.УстановитьПараметр("СостояниеБизнесПроцесса", Перечисления.СостоянияБизнесПроцессов.Активен);
	Запрос.УстановитьПараметр("Автор", ПользователиКлиентСервер.ТекущийПользователь());
	Запрос.УстановитьПараметр("СрокИсполнения", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Выполнена", Ложь);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Таблица.Сортировать("ИсполнительСтрока");
	
	СписокИсполнителей = "";
	
	Для Каждого Строка Из Таблица Цикл
		
		Если Не ПустаяСтрока(СписокИсполнителей) Тогда
			СписокИсполнителей = СписокИсполнителей + ", ";
		КонецЕсли;	
		
		СписокИсполнителей = СписокИсполнителей + Строка.ИсполнительСтрока;
		
	КонецЦикла;	
	
	Возврат СписокИсполнителей;

КонецФункции 

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьПоля();
КонецПроцедуры

&НаКлиенте
Процедура КомандаРассмотрение(Команда)
	ОткрытьРассмотрение();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРассмотрение()
	
	Если ЧислоЗадачРассмотрение = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура("ИмяБизнесПроцесса, ОткрытаИзФормыРабочийСтолРуководителя", "Рассмотрение", Истина);
	ОткрытьФорму("Обработка.РабочийСтолРуководителя.Форма.ФормаСпискаЗадач", ПараметрыФормы); 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСогласование(Команда)
	ОткрытьСогласование();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСогласование()
	
	Если ЧислоЗадачСогласование = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура("ИмяБизнесПроцесса, ОткрытаИзФормыРабочийСтолРуководителя", "Согласование", Истина);
	ОткрытьФорму("Обработка.РабочийСтолРуководителя.Форма.ФормаСпискаЗадач", ПараметрыФормы); 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаУтверждение(Команда)
	ОткрытьУтверждение();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьУтверждение()
	
	Если ЧислоЗадачУтверждение = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура("ИмяБизнесПроцесса, ОткрытаИзФормыРабочийСтолРуководителя", "Утверждение", Истина);
	ОткрытьФорму("Обработка.РабочийСтолРуководителя.Форма.ФормаСпискаЗадач", ПараметрыФормы); 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВсеЗадачи(Команда)
	ВсеЗадачи();
КонецПроцедуры

&НаКлиенте
Процедура ВсеЗадачи()
	
	Если ЧислоЗадачВсего = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура("ИмяБизнесПроцесса, ОткрытаИзФормыРабочийСтолРуководителя", Неопределено, Истина);
	ОткрытьФорму("Обработка.РабочийСтолРуководителя.Форма.ФормаСпискаЗадач", ПараметрыФормы); 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗадачиОтМеня(Команда)
	ЗадачиОтМеня();
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеня()
	
	Если ЧислоЗадачОтМеня = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура("ЗадачиОтМеня, ТолькоПросроченные, ОткрытаИзФормыРабочийСтолРуководителя", 
		Истина, Ложь, Истина);
	ОткрытьФорму("Обработка.РабочийСтолРуководителя.Форма.ФормаСпискаЗадач", ПараметрыФормы); 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗадачиОтМеняПросроченные(Команда)
	ЗадачиОтМеняПросроченные();
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняПросроченные()
	
	Если ЧислоЗадачОтМеняПросроченные = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	ПараметрыФормы = Новый Структура("ЗадачиОтМеня, ТолькоПросроченные, ОткрытаИзФормыРабочийСтолРуководителя", 
		Истина, Истина, Истина);
	ОткрытьФорму("Обработка.РабочийСтолРуководителя.Форма.ФормаСпискаЗадач", ПараметрыФормы); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ФормаРаботыСЗаявкойЗакрыта" Тогда
		ОбновитьПоля();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВсеЗадачиНажатие(Элемент)
	ВсеЗадачи();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНаРассмотрениеНажатие(Элемент)
	ОткрытьРассмотрение();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСогласованиеНажатие(Элемент)
	ОткрытьСогласование();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУтверждениеНажатие(Элемент)
	ОткрытьУтверждение();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЗадачиОтМеняНажатие(Элемент)
	ЗадачиОтМеня();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЗадачиОтМеняПросроченныеНажатие(Элемент)
	ЗадачиОтМеняПросроченные();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовоеПоручение(Команда)
	
	ПараметрыФормы = Новый Структура("ТекущаяДата", ТекущаяДата());
	ОткрытьФорму("Обработка.РабочийСтолРуководителя.Форма.ФормаНовогоИсполнения", ПараметрыФормы);
	
КонецПроцедуры
