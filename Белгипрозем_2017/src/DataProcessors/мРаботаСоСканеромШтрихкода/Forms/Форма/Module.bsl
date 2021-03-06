&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    //Справочники.Пользователи.НайтиПоНаименованию("Гесь Леонид Георгиевич");
    Проверяющий = ПользователиКлиентСервер.ТекущийПользователь();
	
	// Создание списка доступных операций
	СписокВыбора = Элементы.Операция.СписокВыбора;
	СписокВыбора.Очистить();
	Если ДокументооборотПраваДоступа.ЕстьРоль("РегистрацияВнутреннихДокументов") Тогда
		СписокВыбора.Добавить("Регистрация дела", "Регистрация дела");
		СписокВыбора.Добавить("Отправка исх. документа", "Отправка исх. документа");
		СписокВыбора.Добавить("Получение расписки", "Получение расписки");
	КонецЕсли; 
	Если ДокументооборотПраваДоступа.ЕстьРоль("мРаботаСАктамиПроверки") Тогда
		СписокВыбора.Добавить("Прием дела в подразделение", "Прием дела в подразделение");
		СписокВыбора.Добавить("Прием дела на проверку", "Прием дела на проверку");
		СписокВыбора.Добавить("Возврат дела на исправление", "Возврат дела на исправление");
		СписокВыбора.Добавить("Открыть акт проверки", "Открыть акт проверки");
		СписокВыбора.Добавить("Открыть дело", "Открыть дело");
		СписокВыбора.Добавить("Передать дело на регистрацию", "Передать дело на регистрацию");
	КонецЕсли; 
	Если СписокВыбора.Количество()=0 Тогда
		Сообщить("Нет прав для работы со сканером!");
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияПриИзменении(Элемент)
	ЗапомнитьОперацию();
	УправлениеДиалогом();
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	Операция = мРазное.ПолучитьОперациюСканераШтрихкода(ИдентификаторКлиента);
	УправлениеДиалогом();
	
	Штрихкод = "";
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
	ДатаРегистрации = '00010101000000';

КонецПроцедуры

&НаКлиенте
Функция СформироватьНастройку(Значение, ИдентификаторКлиента)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкаОперацииСканераШтрихкода");
	Элемент.Вставить("Настройка", ИдентификаторКлиента);
	Элемент.Вставить("Значение", Значение);
	Возврат Элемент;
	
КонецФункции	

&НаКлиенте
Процедура ОК(Команда)
	ЗапомнитьОперацию();
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьОперацию() 
	МассивСтруктур = Новый Массив;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	МассивСтруктур.Добавить (СформироватьНастройку(Операция, ИдентификаторКлиента));
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
КонецПроцедуры 

&НаСервере
Функция УстановитьДатуРегистрацииДела(Дело, Дата) 
	Если ЗначениеЗаполнено(Дело) Тогда
		Попытка
			ДелоОбъект = Дело.ПолучитьОбъект();
			ДелоОбъект.ДатаРегистрации = Дата;
			ДелоОбъект.Записать();
			Возврат Истина;
		Исключение
		КонецПопытки; 
	КонецЕсли; 
	Возврат Ложь;
КонецФункции 

&НаКлиенте
Функция ПолучитьЗадачуСогласования(Дело, Проверяющий)
	ЗадачаСогласования = Неопределено;
	МассивЗадач = мПроверкаДела.ПолучитьМассивЗадачПроверкиДела(Дело, Проверяющий);
	Для й=0 По МассивЗадач.Количество()-1 Цикл
		ТочкаМаршрутаИмя = ПолучитьИмяТочкиМаршрута(МассивЗадач[й]);
		Если ТочкаМаршрутаИмя = "Согласовать" Тогда
			ЗадачаСогласования = МассивЗадач[й];
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	Возврат ЗадачаСогласования;
КонецФункции
 
&НаКлиенте
Процедура ОбработкаОжидания()

    ЭтаФорма.ТекущийЭлемент = Элементы.Штрихкод;

    Если Не ЗначениеЗаполнено(Штрихкод) Тогда
		Возврат;
	КонецЕсли; 
	
	Если Операция = "Регистрация дела" Тогда
		ВыполнитьРегистрацияДела();
		
	ИначеЕсли Операция = "Отправка исх. документа" Тогда
		ВыполнитьОтправкаИсхДокумента();
		
	ИначеЕсли Операция = "Получение расписки" Тогда
		ВыполнитьПолучениеРасписки();
		
	ИначеЕсли Операция = "Прием дела в подразделение" Тогда
		ВыполнитьПриемДелаВПодразделение();
		
	ИначеЕсли Операция = "Прием дела на проверку" Тогда
		ВыполнитьПриемДелаНаПроверку();
		
	ИначеЕсли Операция = "Возврат дела на исправление" Тогда
		ВыполнитьВозвратДелаНаИсправление();	
		
	ИначеЕсли Операция = "Открыть акт проверки" Тогда
		ВыполнитьОткрытьАктПроверки();	
		
	ИначеЕсли Операция = "Открыть дело" Тогда
		ВыполнитьОткрытьДело();	
		
	ИначеЕсли Операция = "Передать дело на регистрацию" Тогда
		ВыполнитьПередатьДелоНаРегистрацию();
	КонецЕсли;
	
	Штрихкод = "";	  
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
КонецПроцедуры 

&НаКлиенте
Процедура ВыполнитьРегистрацияДела()
	
	Дело = ПолучитьДокПоШтрихкоду(Штрихкод);
	Если Не ЗначениеЗаполнено(Дело) Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
		Возврат;
	КонецЕсли;
	
	// При регистрации дела в акте проверки последний проверяющий должен соответствовать связям проверки актов
	ОписаниеОшибки = "";
	Если Не АктПроверенБезОшибок(Дело, ОписаниеОшибки) Тогда
		Сообщить(ОписаниеОшибки);
	    Сообщить("Сообщите Администратору для ее устранения");
		Возврат;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ДатаРегистрации) Тогда
		ДатаУстановлена = УстановитьДатуРегистрацииДела(Дело, ДатаРегистрации);
	Иначе	
		ДатаУстановлена = УстановитьДатуРегистрацииДела(Дело, ТекущаяДата());
	КонецЕсли; 
	Если ДатаУстановлена Тогда
		ПоказатьОповещениеПользователя("Дата регистрации "+ТекущаяДата()+" установлена в "+Дело+"!");
	Иначе
		Сообщить("Нет ссылки на дело для записи даты регистрации!");
	КонецЕсли; 
	
	// изменение состояния Дела
	Состояние = ПредопределенноеЗначение("Перечисление.мСостоянияДела.ПровереноОтправлено");
	//Исполнитель = ПользователиКлиентСервер.ТекущийПользователь();
	мПроверкаДела.ЗаписатьСостояниеДела(Дело, Состояние, ТекущаяДата(), , Проверяющий);  
	
	ПоказатьОповещениеПользователя("Дело "+ПолучитьНомерДела(Дело)+" зарегистрировано!");
	
	// Создание Расписки в получении
	ПараметрыФормы = Новый Структура("Дело", Дело);
	ПараметрыФормы.Вставить("ВидДокумента", "РаспискаВПолучении");
	ПараметрыФормы.Вставить("Основание", Дело);
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытиеФормыРаспискиВПолучении", ЭтотОбъект);
	ОткрытьФорму("Справочник.ИсходящиеДокументы.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОтправкаИсхДокумента()
	ИсхДок = ПолучитьДокПоШтрихкоду(Штрихкод);
	Если Не ЗначениеЗаполнено(ИсхДок) Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
		Возврат;
	КонецЕсли;
	
	Если ЭтоРасписка(ИсхДок) Тогда
		
		Если ЕстьДатаОтправки(ИсхДок) Тогда
			// Если есть дата отправки, то открыть исх. док
			ПараметрыФормы = Новый Структура();
			ПараметрыФормы.Вставить("Ключ", ИсхДок);
			ОткрытьФорму("Справочник.ИсходящиеДокументы.ФормаОбъекта", ПараметрыФормы);
			Возврат;
		КонецЕсли; 
		
		Если ЭтоОтправкаНарочно(СпособОтправки) Тогда
			// Если нарочно, то запись только Отправка, СпособОтправки без даты,
			//    Запись Журнала передачи
			ОперацияВыполнена = УстановитьРеквизитыИсхДок(ИсхДок, Дата(1,1,1), СпособОтправки);
			Если ОперацияВыполнена Тогда
				ПоказатьОповещениеПользователя("Изменения сохранены в "+ИсхДок+"!");
			Иначе
				Сообщить("Нет ссылки на исх. письмо для записи изменений!");
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Получил) Тогда
				Сообщить("Надо указать кто получил дело!");
			    Возврат;
			КонецЕсли; 
			
			//Пользователь = ПолучитьПользователя(ИсхДок);
			СтруктураПараметров = Новый Структура("Документ, Пользователь", ИсхДок, Получил);
			Если ОтметитьПередачуВЖурналеПередачи(СтруктураПараметров) Тогда
				ПоказатьОповещениеПользователя("Записана передача "+ИсхДок+" "+Получил);
			Иначе
				ПоказатьОповещениеПользователя("Ошибка записи передачи "+ИсхДок+" "+Получил);
			КонецЕсли; 

		Иначе
			
			ОперацияВыполнена = УстановитьРеквизитыИсхДок(ИсхДок, ДатаОтправки, СпособОтправки);
			Если ОперацияВыполнена Тогда
				ПоказатьОповещениеПользователя("Изменения сохранены в "+ИсхДок+"!");
			Иначе
				Сообщить("Нет ссылки на исх. письмо для записи изменений!");
			КонецЕсли; 
		КонецЕсли; 
	Иначе
		ОперацияВыполнена = УстановитьРеквизитыИсхДок(ИсхДок, ДатаОтправки, СпособОтправки);
		Если ОперацияВыполнена Тогда
			//ВидИсхДок = ПолучитьВидИсходящегоДокумента(ИсхДок);	
			//Если ВидИсхДок = ПредопределенноеЗначение("Справочник.ВидыИсходящихДокументов.ПисьмоОНеПодписанииДоговора") Тогда
			//	
			//	НеПодписан = ПредопределенноеЗначение("Перечисление.мСостоянияДоговоров.НеПодписан");
			//	мРаботаСДоговорами.УстановитьСостояниеДоговора(ИсхДок, НеПодписан);
			//	мРаботаСДоговорами.РасторгнутьДоговор(ИсхДок, ТекущаяДата());

			//ИначеЕсли ВидИсхДок = ПредопределенноеЗначение("Справочник.ВидыИсходящихДокументов.ПисьмоОРасторженииДоговора") Тогда
			//
			//	Расторгнут = ПредопределенноеЗначение("Перечисление.мСостоянияДоговоров.Расторгнут");
			//	мРаботаСДоговорами.УстановитьСостояниеДоговора(ИсхДок, Расторгнут);
			//	мРаботаСДоговорами.РасторгнутьДоговор(ИсхДок, ТекущаяДата());
			//
			//КонецЕсли; 
			
			ПоказатьОповещениеПользователя("Изменения сохранены в "+ИсхДок+"!");
		Иначе
			Сообщить("Нет ссылки на исх. письмо для записи изменений!");
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПолучениеРасписки()
	ИсхДок = ПолучитьДокПоШтрихкоду(Штрихкод);
	ДатаОтправкиРасписки = ТекущаяДата();
	Если ВвестиДату(ДатаОтправкиРасписки, "Введите дату отправки", ЧастиДаты.Дата)  Тогда
		ОперацияВыполнена = УстановитьРеквизитыИсхДок(ИсхДок, ДатаОтправкиРасписки);
		Если ОперацияВыполнена Тогда
			ПоказатьОповещениеПользователя("Изменения сохранены в "+ИсхДок+"!");
		Иначе
			Сообщить("Нет ссылки на исх. письмо для записи изменений!");
		КонецЕсли; 
		
		ОтметитьВозвратВЖурналеПередачи(ИсхДок);
	КонецЕсли; 
КонецПроцедуры
 
&НаКлиенте
Процедура ВыполнитьПриемДелаВПодразделение()
	Дело = ПолучитьДокПоШтрихкоду(Штрихкод);
	Если Не ЗначениеЗаполнено(Дело) Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
		Возврат;
	КонецЕсли;
	
	// изменение состояния Дела
	РеквУровняПроверки = мПроверкаДела.ПолучитьРеквизитыУровняПроверкиДела(Дело);
	
	Если мПроверкаДела.СостояниеДелаПроверено(РеквУровняПроверки.Состояние) Тогда
		Сообщить("Дело уже проверено!");
		Штрихкод = "";
		Возврат;
	КонецЕсли; 
	
	// Проверить наличие задачи к исполнению
	ЗадачаСогласования = ПолучитьЗадачуСогласования(Дело, Проверяющий);
	
	Если Не ЗначениеЗаполнено(ЗадачаСогласования) Тогда
		Сообщить("Нельзя получить дело "+ПолучитьНомерДела(Дело)+" в подразделение, если оно не было направлено на проверку!");
		Возврат;
	КонецЕсли; 
	
	Состояние = ПредопределенноеЗначение("Перечисление.мСостоянияДела.ПолученоНаПроверку");
	Если РеквУровняПроверки.Состояние <> Состояние Тогда
		ТекУровеньПроверки = РеквУровняПроверки.УровеньПроверки;
		Если ТекУровеньПроверки = ПредопределенноеЗначение("Перечисление.мУровниПроверки.Исполнитель") Тогда
			// могут быть варианты с запуском процессов по 2-м шаблонам 1 или 2 уровней
			БизнесПроцесс = ПолучитьБПЗадачи(ЗадачаСогласования);
			УровеньШаблонаПроцесса = мПроверкаДела.ПолучитьУровеньШаблонаПроверкиДела(БизнесПроцесс);
			Если УровеньШаблонаПроцесса = 1 Тогда
				СледУровеньПроверки = ПредопределенноеЗначение("Перечисление.мУровниПроверки.Отряд");
			ИначеЕсли УровеньШаблонаПроцесса = 2 Тогда
				СледУровеньПроверки = ПредопределенноеЗначение("Перечисление.мУровниПроверки.Отдел");
			КонецЕсли;    
			
			// важно Подразделение исполнителя работ
			Проверяемый = мПроверкаДела.ПолучитьИсполнителяДела(Дело);
			Подразделение = РаботаСПользователями.ПолучитьПодразделение(Проверяемый);
		Иначе
			// важно подразделение проверяющего
			Подразделение = РаботаСПользователями.ПолучитьПодразделение(Проверяющий);
			ПараметрыЗапроса = мПроверкаДела.ЗаполнитьПараметрыЗапросаУровняПроверки(Дело, ТекУровеньПроверки, Подразделение);
			СледУровеньПроверки = мПроверкаДела.ПолучитьСледующийУровеньПроверки(ПараметрыЗапроса);
		КонецЕсли; 
		мПроверкаДела.ЗаписатьСостояниеДела(Дело, Состояние, ТекущаяДата(), Подразделение, Проверяющий, СледУровеньПроверки);  
		
		ПоказатьОповещениеПользователя("Дело "+ПолучитьНомерДела(Дело)+" получено на проверку!");
	Иначе
		Сообщить("Дело уже получено на проверку!");
		Штрихкод = "";
	КонецЕсли; 
	
КонецПроцедуры
 
&НаКлиенте
Процедура ВыполнитьПриемДелаНаПроверку()
	
	Дело = ПолучитьДокПоШтрихкоду(Штрихкод);
	Если Не ЗначениеЗаполнено(Дело) Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
		Возврат;
	КонецЕсли;
	
	// Проверить наличие задачи к исполнению
	ЗадачаСогласования = ПолучитьЗадачуСогласования(Дело, Проверяющий);
	
	Если Не ЗначениеЗаполнено(ЗадачаСогласования) Тогда
		Сообщить("Нельзя принять дело "+ПолучитьНомерДела(Дело)+" на проверку, если оно не было на него направлено!");
		Возврат;
	КонецЕсли; 
	
	РеквУровняПроверки = мПроверкаДела.ПолучитьРеквизитыУровняПроверкиДела(Дело);
	
	Если мПроверкаДела.СостояниеДелаПроверено(РеквУровняПроверки.Состояние) Тогда
		Сообщить("Дело уже проверено!");
		Штрихкод = "";
		Возврат;
	КонецЕсли; 
	
	// Принять задачу к исполнению
	//МассивЗадач = мПроверкаДела.ПолучитьМассивЗадачПроверкиДела(Дело, Проверяющий);
	//Для й=0 По МассивЗадач.Количество()-1 Цикл
	//	ТочкаМаршрутаИмя = ПолучитьИмяТочкиМаршрута(МассивЗадач[й]);
	//	Если ТочкаМаршрутаИмя = "Согласовать" Тогда
	//		ЗадачаСогласования = МассивЗадач[й];
	//		//ИначеЕсли ТочкаМаршрутаИмя = "Ознакомиться" Тогда
	//		//    ЗадачаОзнакомления = МассивЗадач[й];	
	//	КонецЕсли; 
	//КонецЦикла; 
	
	Если мПроверкаДела.ПринятьЗадачуКИсполнению(ЗадачаСогласования, Проверяющий) Тогда
		Оповестить("ЗадачаИзменена", ЗадачаСогласования);
		ПоказатьОповещениеПользователя("Задача "+ЗадачаСогласования+" принята к исполнению!");
	Иначе	
		ПоказатьОповещениеПользователя("Задача "+ЗадачаСогласования+" не была принята к исполнению!");
	КонецЕсли; 
	
	// изменение состояния Дела
	
	СостояниеНаПроверке = ПредопределенноеЗначение("Перечисление.мСостоянияДела.НаПроверке");
	Если РеквУровняПроверки.Состояние <> СостояниеНаПроверке Тогда
		ТекУровеньПроверки = РеквУровняПроверки.УровеньПроверки;
		Подразделение = РаботаСПользователями.ПолучитьПодразделение(Проверяющий);
		
		// Дело сначала должно быть Получено на проверку в подразделение, а потом На проверку
		СостояниеПолученоНаПроверку = ПредопределенноеЗначение("Перечисление.мСостоянияДела.ПолученоНаПроверку");
		Если РеквУровняПроверки.Состояние <> СостояниеПолученоНаПроверку Тогда
			// Надо получить новый уровень проверки
			Если ТекУровеньПроверки = ПредопределенноеЗначение("Перечисление.мУровниПроверки.Исполнитель") Тогда
				// могут быть варианты с запуском процессов по 2-м шаблонам 1 или 2 уровней
				БизнесПроцесс = ПолучитьБПЗадачи(ЗадачаСогласования);
				УровеньШаблонаПроцесса = мПроверкаДела.ПолучитьУровеньШаблонаПроверкиДела(БизнесПроцесс);
				Если УровеньШаблонаПроцесса = 1 Тогда
					СледУровеньПроверки = ПредопределенноеЗначение("Перечисление.мУровниПроверки.Отряд");
				ИначеЕсли УровеньШаблонаПроцесса = 2 Тогда
					СледУровеньПроверки = ПредопределенноеЗначение("Перечисление.мУровниПроверки.Отдел");
				КонецЕсли;    
				
				// важно Подразделение исполнителя работ
				Проверяемый = мПроверкаДела.ПолучитьИсполнителяДела(Дело);
				Подразделение = РаботаСПользователями.ПолучитьПодразделение(Проверяемый);
			Иначе
				// важно подразделение проверяющего
				Подразделение = РаботаСПользователями.ПолучитьПодразделение(Проверяющий);
				ПараметрыЗапроса = мПроверкаДела.ЗаполнитьПараметрыЗапросаУровняПроверки(Дело, ТекУровеньПроверки, Подразделение);
				СледУровеньПроверки = мПроверкаДела.ПолучитьСледующийУровеньПроверки(ПараметрыЗапроса);
			КонецЕсли; 
			мПроверкаДела.ЗаписатьСостояниеДела(Дело, СостояниеПолученоНаПроверку, ТекущаяДата(), Подразделение, Проверяющий, СледУровеньПроверки);  
			
			ПоказатьОповещениеПользователя("Дело "+ПолучитьНомерДела(Дело)+" получено на проверку!");
			
			// для приема на проверку надо изменить уровень
			УровеньПроверки = СледУровеньПроверки;
		Иначе
			// Уровень проверки не меняем
			УровеньПроверки = ТекУровеньПроверки;
		КонецЕсли; 
		
		мПроверкаДела.ЗаписатьСостояниеДела(Дело, СостояниеНаПроверке, ТекущаяДата(), Подразделение, Проверяющий, УровеньПроверки);  
		
		ПоказатьОповещениеПользователя("Дело "+ПолучитьНомерДела(Дело)+" на проверке!");
	Иначе
		Сообщить("Дело уже на проверке!");
		Штрихкод = "";
	КонецЕсли; 
	
	// Создание/Открытие Акта проверки
	МассивАктов = мПроверкаДела.ПолучитьАктыПроверкиДела(Дело);
	
	КолвоАктов = МассивАктов.Количество();
	
	Если КолвоАктов = 0 Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Основание", Дело);
		ПараметрыФормы.Вставить("НаПроверку", Истина);
		
		ОткрытьФорму("Справочник.мАктыПроверки.ФормаОбъекта", ПараметрыФормы);
		
	ИначеЕсли КолвоАктов = 1 Тогда
		
		АктПроверки = МассивАктов[0];
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Ключ", АктПроверки);
		ПараметрыФормы.Вставить("НаПроверку", Истина);
		ОткрытьФорму("Справочник.мАктыПроверки.ФормаОбъекта", ПараметрыФормы);
		
	ИначеЕсли КолвоАктов > 1 Тогда	
		
		СписАктов = Новый СписокЗначений;
		СписАктов.ЗагрузитьЗначения(МассивАктов);
		ВыбрЭлемент = СписАктов.ВыбратьЭлемент("Выберите акт проверки");
		Если ВыбрЭлемент = Неопределено Тогда
			ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
			Возврат;
		КонецЕсли; 
		
		АктПроверки = ВыбрЭлемент.Значение;
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Ключ", АктПроверки);
		ПараметрыФормы.Вставить("НаПроверку", Истина);
		ОткрытьФорму("Справочник.мАктыПроверки.ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли;
КонецПроцедуры
 
&НаКлиенте
Процедура ВыполнитьВозвратДелаНаИсправление()
	
	Дело = ПолучитьДокПоШтрихкоду(Штрихкод);
	Если Не ЗначениеЗаполнено(Дело) Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
		Возврат;
	КонецЕсли;
	
	РеквУровняПроверки = мПроверкаДела.ПолучитьРеквизитыУровняПроверкиДела(Дело);
	
	Если мПроверкаДела.СостояниеДелаПроверено(РеквУровняПроверки.Состояние) Тогда
		Сообщить("Дело уже проверено!");
		Штрихкод = "";
		Возврат;
	КонецЕсли; 
	
	//Проверяющий = ПользователиКлиентСервер.ТекущийПользователь();
	Подразделение = РаботаСПользователями.ПолучитьПодразделение(Проверяющий);
	
	// изменение состояния Дела
	СтруктураУровняПроверки = мПроверкаДела.ПолучитьРеквизитыУровняПроверкиДела(Дело);
	
	// Контроль предыдущего состояния
	Состояние = ПредопределенноеЗначение("Перечисление.мСостоянияДела.НаИсправлении");
	Если СтруктураУровняПроверки.Состояние = Состояние Тогда
		Сообщить("Дело уже было передано на исправление!");
		Штрихкод = "";
		Возврат;
	ИначеЕсли СтруктураУровняПроверки.Состояние <> ПредопределенноеЗначение("Перечисление.мСостоянияДела.ВозвратНаИсправление") Тогда
		Сообщить("Возвращать можно только несогласованные дела!");
		Штрихкод = "";
		Возврат;
	КонецЕсли; 
	
	ПараметрыЗапроса = мПроверкаДела.ЗаполнитьПараметрыЗапросаУровняПроверки(Дело, СтруктураУровняПроверки.УровеньПроверки);
	ПредУровеньПроверки = мПроверкаДела.ПолучитьПредыдущийУровеньПроверки(ПараметрыЗапроса);
	Если ПредУровеньПроверки = ПредопределенноеЗначение("Перечисление.мУровниПроверки.Исполнитель") Тогда
		// важно Подразделение исполнителя работ
		Проверяющий = мПроверкаДела.ПолучитьИсполнителяДела(Дело);
		Подразделение = РаботаСПользователями.ПолучитьПодразделение(Проверяющий);
	КонецЕсли; 
	
	РеквУровняПроверки = мПроверкаДела.ПолучитьРеквизитыУровняПроверкиДела(Дело, ПредУровеньПроверки);
	Если ЗначениеЗаполнено(РеквУровняПроверки) Тогда
		ПредПроверяющий = РеквУровняПроверки.Исполнитель;
		ПредПодразделение = РеквУровняПроверки.Подразделение;
	Иначе	
		ПредПроверяющий = Проверяющий;
		ПредПодразделение = Подразделение;
	КонецЕсли; 
	
	мПроверкаДела.ЗаписатьСостояниеДела(Дело, Состояние, ТекущаяДата(), ПредПодразделение, ПредПроверяющий, ПредУровеньПроверки);  
	
	ПоказатьОповещениеПользователя("Дело "+ПолучитьНомерДела(Дело)+" на исправлении!");
	
КонецПроцедуры
 
&НаКлиенте
Процедура ВыполнитьОткрытьАктПроверки()
	
	Дело = ПолучитьДокПоШтрихкоду(Штрихкод);
	Если Не ЗначениеЗаполнено(Дело) Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
		Возврат;
	КонецЕсли;
	
	// Создание/Открытие Акта проверки
	МассивАктов = мПроверкаДела.ПолучитьАктыПроверкиДела(Дело);
	
	КолвоАктов = МассивАктов.Количество();
	
	Если КолвоАктов = 0 Тогда
		// нечего открыть
		Сообщить("Акт проверки дела "+ПолучитьНомерДела(Дело)+" не найден!");
		Возврат;
		
	ИначеЕсли КолвоАктов = 1 Тогда
		
		АктПроверки = МассивАктов[0];
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Ключ", АктПроверки);
		//ПараметрыФормы.Вставить("НаПроверку", Истина);
		ОткрытьФорму("Справочник.мАктыПроверки.ФормаОбъекта", ПараметрыФормы);
		
	ИначеЕсли КолвоАктов > 1 Тогда	
		
		СписАктов = Новый СписокЗначений;
		СписАктов.ЗагрузитьЗначения(МассивАктов);
		ВыбрЭлемент = СписАктов.ВыбратьЭлемент("Выберите акт проверки");
		Если ВыбрЭлемент = Неопределено Тогда
			ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
			Возврат;
		КонецЕсли; 
		
		АктПроверки = ВыбрЭлемент.Значение;
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Ключ", АктПроверки);
		ПараметрыФормы.Вставить("НаПроверку", Истина);
		ОткрытьФорму("Справочник.мАктыПроверки.ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры
 
&НаКлиенте
Процедура ВыполнитьОткрытьДело()
	
	Дело = ПолучитьДокПоШтрихкоду(Штрихкод);
	Если Не ЗначениеЗаполнено(Дело) Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", Дело);
	ОткрытьФорму("Справочник.ВнутренниеДокументы.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры
 
&НаКлиенте
Процедура ВыполнитьПередатьДелоНаРегистрацию()
	
	Дело = ПолучитьДокПоШтрихкоду(Штрихкод);
	Если Не ЗначениеЗаполнено(Дело) Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
		Возврат;
	КонецЕсли;
	
	// Контроль предыдущего состояния
	СтруктураУровняПроверки = мПроверкаДела.ПолучитьРеквизитыУровняПроверкиДела(Дело);
	Состояние = ПредопределенноеЗначение("Перечисление.мСостоянияДела.ПровереноПереданоНаРегистрацию");
	Если СтруктураУровняПроверки.Состояние = Состояние Тогда
		Сообщить("Дело уже было передано на регистрацию!");
		Штрихкод = "";
		Возврат;
	ИначеЕсли СтруктураУровняПроверки.Состояние <> ПредопределенноеЗначение("Перечисление.мСостоянияДела.Проверено") Тогда
		Сообщить("Передать на регистрацию можно только проверенные дела!");
		Штрихкод = "";
		Возврат;
	КонецЕсли; 
	
	// изменение состояния Дела
	мПроверкаДела.ЗаписатьСостояниеДела(Дело, Состояние, ТекущаяДата(), , Проверяющий);  
	
	ПоказатьОповещениеПользователя("Дело "+ПолучитьНомерДела(Дело)+" передано на регистрацию!");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьБПЗадачи(ЗадачаСогласования)
    Возврат ЗадачаСогласования.БизнесПроцесс;
КонецФункции // ПолучитьБПЗадачи(ЗадачаСогласования)()
 
&НаСервереБезКонтекста
Функция ПолучитьИмяТочкиМаршрута(ЗадачаБП)
	Возврат ЗадачаБП.ТочкаМаршрута.Имя;	
КонецФункции
 
&НаКлиенте
Процедура ЗакрытиеФормыРаспискиВПолучении(Результат, Параметры) Экспорт
	// Включение запроса штрихкода
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина); 
КонецПроцедуры 
 
&НаКлиенте
Функция ПолучитьДокПоШтрихкоду(Штрихкод)
	МассивДел = ШтрихкодированиеСервер.НайтиОбъектыПоШтрихкоду(Штрихкод);
	Если МассивДел.Количество() = 0 Тогда
		Сообщить("Не найден владелец штрихкода " +Штрихкод+ "!");
		ШтрихКод = "";
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат МассивДел[0].Ключ;
КонецФункции 

&НаСервереБезКонтекста
Функция ПолучитьНомерДела(Дело)
	Возврат Дело.РегистрационныйНомер;
КонецФункции

&НаКлиенте
Процедура ШтрихкодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
    ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура УправлениеДиалогом()
	Элементы.ДатаРегистрации.Видимость = Ложь;	
	Элементы.ДатаОтправки.Видимость = Ложь;
	Элементы.СпособОтправки.Видимость = Ложь;
	Элементы.Получил.Видимость = Ложь;
	Если Операция = "Отправка исх. документа"  Тогда
		Элементы.ДатаОтправки.Видимость = Истина;
		Элементы.СпособОтправки.Видимость = Истина;
		Если ЗначениеЗаполнено(СпособОтправки) Тогда
			Если ЭтоОтправкаНарочно(СпособОтправки) Тогда
				Элементы.Получил.Видимость = Истина;
			КонецЕсли; 
		КонецЕсли; 
		ДатаОтправки = ТекущаяДата();
		
	//ИначеЕсли Операция = "Регистрация дела" Тогда
		//Элементы.ДатаРегистрации.Видимость = Истина;	
	КонецЕсли; 
	УстановитьОписаниеДействия();
КонецПроцедуры

&НаСервереБезКонтекста
Функция УстановитьРеквизитыИсхДок(ИсхДок, Дата, Способ=Неопределено) 
	Если ЗначениеЗаполнено(ИсхДок) Тогда
		Попытка
			ИсхДокОбъект = ИсхДок.ПолучитьОбъект();
			Получатели = ИсхДокОбъект.Получатели;
			Для каждого Стр Из Получатели Цикл
				Если ЗначениеЗаполнено(Способ) Тогда
					Стр.СпособОтправки = Способ;
				КонецЕсли; 
				// Если дата отправки сегодня, то запись со временем, если завтра, то без времени
				Сегодня = НачалоДня(ТекущаяДата());
				ДеньОтправки = НачалоДня(Дата);
				Если ДеньОтправки <= Сегодня Тогда
					Стр.ДатаОтправки = Дата;
				ИначеЕсли ДеньОтправки > Сегодня Тогда
					Стр.ДатаОтправки = ДеньОтправки;	
				КонецЕсли; 
				Стр.Отправлен = Истина;
			КонецЦикла; 
			ИсхДокОбъект.Записать();
			Возврат Истина;
		Исключение
		КонецПопытки; 
	КонецЕсли; 
	Возврат Ложь;
КонецФункции 

&НаСервереБезКонтекста
Функция ЭтоРасписка(ИсхДок)
	Возврат Найти(ИсхДок.ВидДокумента.Наименование, "Расписка") > 0;	
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоОтправкаНарочно(СпособОтправки)
	Возврат Найти(СпособОтправки.Наименование, "Нарочно") > 0;	
КонецФункции

&НаСервереБезКонтекста
Функция ЕстьДатаОтправки(ИсхДок)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИсходящиеДокументыПолучатели.ДатаОтправки,
		|	ИсходящиеДокументыПолучатели.СпособОтправки,
		|	ИсходящиеДокументыПолучатели.Отправлен
		|ИЗ
		|	Справочник.ИсходящиеДокументы.Получатели КАК ИсходящиеДокументыПолучатели
		|ГДЕ
		|	ИсходящиеДокументыПолучатели.Ссылка = &ИсхДок";
	
	Запрос.УстановитьПараметр("ИсхДок", ИсхДок);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.ДатаОтправки) Тогда
			Возврат Истина;
		КонецЕсли; 
	КонецЦикла;
	Возврат Ложь;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПользователя(ИсхДок)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(СвязиДокументов.СвязанныйДокумент КАК Справочник.ВнутренниеДокументы) КАК СвязанныйДокумент,
		|	мЭтапыДоговоровИсполнители.Исполнитель КАК Исполнитель
		|ИЗ
		|	РегистрСведений.СвязиДокументов КАК СвязиДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.мЭтапыДоговоров.Исполнители КАК мЭтапыДоговоровИсполнители
		|		ПО СвязиДокументов.СвязанныйДокумент.ЭтапДоговора = мЭтапыДоговоровИсполнители.Ссылка
		|ГДЕ
		|	СвязиДокументов.Документ = &Документ
		|	И СвязиДокументов.ТипСвязи = &ТипСвязи
		|	И мЭтапыДоговоровИсполнители.НомерСтроки = 1";
	
	Запрос.УстановитьПараметр("Документ", ИсхДок);
	Запрос.УстановитьПараметр("ТипСвязи", Справочники.ТипыСвязей.ПредметПереписки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Исполнитель;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

&НаСервереБезКонтекста
Функция ОтметитьВозвратВЖурналеПередачи(ИсхДок)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЖурналПередачиДокументов.ТипЭкземпляра КАК ТипЭкземпляра,
		|	ЖурналПередачиДокументов.Период КАК Период,
		|	ЖурналПередачиДокументов.Документ КАК Документ,
		|	ЖурналПередачиДокументов.НомерЭкземпляра КАК НомерЭкземпляра
		|ИЗ
		|	РегистрСведений.ЖурналПередачиДокументов КАК ЖурналПередачиДокументов
		|ГДЕ
		|	ЖурналПередачиДокументов.Документ = &Документ
		|	И ЖурналПередачиДокументов.Возвращен = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Документ", ИсхДок);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда 
		МенеджерЗаписи = РегистрыСведений.ЖурналПередачиДокументов.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Документ 		= Выборка.Документ;
		МенеджерЗаписи.ТипЭкземпляра 	= Выборка.ТипЭкземпляра;
		МенеджерЗаписи.Период 			= Выборка.Период;
		МенеджерЗаписи.НомерЭкземпляра 	= Выборка.НомерЭкземпляра;
		МенеджерЗаписи.Прочитать();
		
		МенеджерЗаписи.Возвращен = Истина;
		МенеджерЗаписи.ДатаВозврата = ТекущаяДата();
		МенеджерЗаписи.Записать();
	КонецЕсли;
		
КонецФункции

&НаСервереБезКонтекста
Функция ОтметитьПередачуВЖурналеПередачи(СтруктураПараметров)
	ИсхДок = СтруктураПараметров.Документ;
	Пользователь = СтруктураПараметров.Пользователь;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЖурналПередачиДокументов.ТипЭкземпляра КАК ТипЭкземпляра,
		|	ЖурналПередачиДокументов.Период КАК Период,
		|	ЖурналПередачиДокументов.Документ КАК Документ,
		|	ЖурналПередачиДокументов.НомерЭкземпляра КАК НомерЭкземпляра
		|ИЗ
		|	РегистрСведений.ЖурналПередачиДокументов КАК ЖурналПередачиДокументов
		|ГДЕ
		|	ЖурналПередачиДокументов.Документ = &Документ
		|	И ЖурналПередачиДокументов.Возвращен = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Документ", ИсхДок);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		// Документ уже был передан - отмечаем возврат и снова делаем передачу 
		МенеджерЗаписи = РегистрыСведений.ЖурналПередачиДокументов.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Документ 		= Выборка.Документ;
		МенеджерЗаписи.ТипЭкземпляра 	= Выборка.ТипЭкземпляра;
		МенеджерЗаписи.Период 			= Выборка.Период;
		МенеджерЗаписи.НомерЭкземпляра 	= Выборка.НомерЭкземпляра;
		МенеджерЗаписи.Прочитать();
		
		МенеджерЗаписи.Возвращен = Истина;
		МенеджерЗаписи.ДатаВозврата = ТекущаяДата();
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
	// Передача
	
	НаборЗаписей = РегистрыСведений.ЖурналПередачиДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(ИсхДок);
	НаборЗаписей.Отбор.Период.Установить(ТекущаяДата());
	НаборЗаписей.Прочитать();
	
	НовЗап = НаборЗаписей.Добавить();
	НовЗап.Документ = ИсхДок;
	НовЗап.Период = ТекущаяДата();
	НовЗап.ТипЭкземпляра = Перечисления.ТипыЭкземпляров.Оригинал;
	НовЗап.НомерЭкземпляра = 1;
	НовЗап.Пользователь = Пользователь;
	НовЗап.СрокВозврата = ТекущаяДата() + 15*24*3600;
	
	НаборЗаписан = Ложь;
	Попытка
		НаборЗаписей.Записать();
		НаборЗаписан = Истина;
	Исключение
	КонецПопытки; 
	Возврат НаборЗаписан;		
КонецФункции 
 
&НаКлиенте
Процедура УстановитьОписаниеДействия()
	Если Операция = "Регистрация дела" Тогда
		ОписаниеДействия = "Установление даты регистрации дела.
		|Запись изменения состояния дела.
		|Создание Расписки в получении и открытие ее для печати."		
		
	ИначеЕсли Операция = "Отправка исх. письма" Тогда
		ОписаниеДействия = "Установление даты отправки, способа отправки, отметки, что письмо отправлено, без открытия самого письма.
		|Если это расписка, то установление способа отправки и отметки, что отправлено,
		|Запись передачи в Журнал передачи документов.";
		
	ИначеЕсли Операция = "Получение расписки" Тогда
		ОписаниеДействия = "Установление даты отправки вручную.
		|Отметка в Журнале передачи события возврата документа.";
		
	ИначеЕсли Операция = "Прием дела в подразделение" Тогда
		
		ОписаниеДействия = "Изменение состояния дела на ""Получено на проверку"".
		|Изменение уровня проверки на следующий.";
		
	ИначеЕсли Операция = "Прием дела на проверку" Тогда
		
		ОписаниеДействия = "Изменение состояния дела на ""На проверке"".
		|Принятие задачи на проверку дела к исполнению.
		|Создание/Открытие Акта проверки для работы.";
		
	ИначеЕсли Операция = "Возврат дела на исправление" Тогда
		
		ОписаниеДействия = "Изменение состояния дела на ""На исправлении"".
		|Изменение уровня проверки на предыдущий.";
		
	ИначеЕсли Операция = "Открыть акт проверки" Тогда
		ОписаниеДействия = "Открытие Акта проверки для просмотра, работы.";
		
	ИначеЕсли Операция = "Открыть дело" Тогда
		ОписаниеДействия = "Открытие Дела для просмотра, работы.";
		
	ИначеЕсли Операция = "Передать дело на регистрацию" Тогда
		ОписаниеДействия = "Изменение состояния дела на ""Передано на регистрацию"".";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СпособОтправкиПриИзменении(Элемент)
	Элементы.Получил.Видимость = ЭтоОтправкаНарочно(СпособОтправки);
КонецПроцедуры
 
&НаСервереБезКонтекста
Функция ПолучитьВидИсходящегоДокумента(ИсхДок)
	Возврат ИсхДок.ВидДокумента;	
КонецФункции

&НаСервере
Функция АктПроверенБезОшибок(Дело, ОписаниеОшибки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мАктыПроверки.Ссылка КАК Акт,
		|	мАктыПроверки.Владелец КАК Дело
		|ПОМЕСТИТЬ Акты
		|ИЗ
		|	Справочник.мАктыПроверки КАК мАктыПроверки
		|ГДЕ
		|	(мАктыПроверки.Состояние = &Состояние
		|			ИЛИ мАктыПроверки.Состояние = &Состояние1)
		|	И мАктыПроверки.Владелец = &Дело
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	мИсторияСостоянийДелСрезПоследних.Дело КАК Дело,
		|	МАКСИМУМ(мИсторияСостоянийДелСрезПоследних.Период) КАК Период
		|ПОМЕСТИТЬ МаксСроки
		|ИЗ
		|	РегистрСведений.мИсторияСостоянийДел.СрезПоследних(, Дело = &Дело) КАК мИсторияСостоянийДелСрезПоследних
		|
		|СГРУППИРОВАТЬ ПО
		|	мИсторияСостоянийДелСрезПоследних.Дело
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	мАктыПроверкиПроверкиКачества.Ссылка КАК Акт,
		|	МАКСИМУМ(мАктыПроверкиПроверкиКачества.НомерСтроки) КАК НомерСтроки
		|ПОМЕСТИТЬ МаксСтроки
		|ИЗ
		|	Справочник.мАктыПроверки.ПроверкиКачества КАК мАктыПроверкиПроверкиКачества
		|ГДЕ
		|	мАктыПроверкиПроверкиКачества.Ссылка В
		|			(ВЫБРАТЬ
		|				Акты.Акт
		|			ИЗ
		|				Акты КАК Акты)
		|
		|СГРУППИРОВАТЬ ПО
		|	мАктыПроверкиПроверкиКачества.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	мАктыПроверкиПроверкиКачества.Проверяющий КАК Проверяющий,
		|	мАктыПроверкиПроверкиКачества.Ссылка КАК Акт
		|ПОМЕСТИТЬ Проверяющие
		|ИЗ
		|	МаксСтроки КАК МаксСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.мАктыПроверки.ПроверкиКачества КАК мАктыПроверкиПроверкиКачества
		|		ПО МаксСтроки.Акт = мАктыПроверкиПроверкиКачества.Ссылка
		|			И МаксСтроки.НомерСтроки = мАктыПроверкиПроверкиКачества.НомерСтроки
		|ГДЕ
		|	мАктыПроверкиПроверкиКачества.Ссылка В
		|			(ВЫБРАТЬ
		|				Акты.Акт
		|			ИЗ
		|				Акты КАК Акты)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Акты.Акт КАК Акт,
		|	Акты.Акт.УровеньПроверки КАК АктУровеньПроверки,
		|	Проверяющие.Проверяющий КАК Проверяющий,
		|	мИсторияСостоянийДелСрезПоследних.Состояние КАК Состояние,
		|	мИсторияСостоянийДелСрезПоследних.УровеньПроверки КАК УровеньПроверки,
		|	мИсторияСостоянийДелСрезПоследних.Подразделение КАК Подразделение,
		|	Акты.Дело КАК Дело,
		|	Акты.Дело.Корреспондент.ЮрФизЛицо КАК ЮрФизЛицо,
		|	Акты.Дело.ЭтапДоговора.ВидРабот КАК ВидРабот,
		|	Акты.Дело.Организация КАК Организация,
		|	Акты.Дело.ЭтапДоговора.Подразделение КАК ПодразделениеЭтапа
		|ИЗ
		|	Акты КАК Акты
		|		ЛЕВОЕ СОЕДИНЕНИЕ МаксСроки КАК МаксСроки
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.мИсторияСостоянийДел.СрезПоследних КАК мИсторияСостоянийДелСрезПоследних
		|			ПО МаксСроки.Дело = мИсторияСостоянийДелСрезПоследних.Дело
		|				И МаксСроки.Период = мИсторияСостоянийДелСрезПоследних.Период
		|		ПО Акты.Дело = МаксСроки.Дело
		|		ЛЕВОЕ СОЕДИНЕНИЕ Проверяющие КАК Проверяющие
		|		ПО Акты.Акт = Проверяющие.Акт";
	
	Запрос.УстановитьПараметр("Дело", Дело);
	Запрос.УстановитьПараметр("Состояние", Перечисления.М_СостоянияАктовПроверки.НаКомиссии);
	Запрос.УстановитьПараметр("Состояние1", Перечисления.М_СостоянияАктовПроверки.Проверен);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		//Сообщить("Уровень: "+Выборка.АктУровеньПроверки+" Проверил: "+Выборка.Проверяющий);
		
		Пар = Новый Структура;
		Пар.Вставить("ВидЛица", Выборка.ЮрФизЛицо);
		Пар.Вставить("ВидРабот", Выборка.ВидРабот);
		Пар.Вставить("Организация", Выборка.Организация);
		Пар.Вставить("Подразделение", Выборка.ПодразделениеЭтапа);
		ПоследнийУровень = мПроверкаДела.ПолучитьПоследнийУровеньПроверки(Пар);
		
		Если Выборка.АктУровеньПроверки <> ПоследнийУровень Тогда
			ОписаниеОшибки = "Ошибка: Уровень проверки должен быть: "+ПоследнийУровень;
			//Сообщить("Ошибка: Уровень проверки должен быть: "+ПоследнийУровень);
			//Сообщить("Сообщите Администратору для ее устранения");
			Возврат Ложь;
		КонецЕсли; 
	КонецЦикла;
	Возврат Истина;
КонецФункции
