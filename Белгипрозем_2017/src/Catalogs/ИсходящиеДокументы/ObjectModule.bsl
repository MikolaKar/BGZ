#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриКопировании(ОбъектКопирования)
	
	РегистрационныйНомер = "";
	ЧисловойНомер 	= 0;
	ДатаРегистрации	= '00010101';
	ДатаСоздания 	= ТекущаяДатаСеанса();
	Зарегистрировал = Справочники.Пользователи.ПустаяСсылка();
	Подготовил 		= ПользователиКлиентСервер.ТекущийПользователь();
	Подразделение 	= РаботаСПользователями.ПолучитьПодразделение(Подготовил);
	Подписал		= Справочники.Пользователи.ПустаяСсылка();
	
	Для Каждого Строка Из Получатели Цикл
		Строка.Отправлен 	  = Ложь;
		Строка.ДатаОтправки	  = '00010101';
		Строка.СпособОтправки = Справочники.СпособыДоставки.ПустаяСсылка();
		Строка.ВходящийНомер  = "";
		Строка.ВходящаяДата   = '00010101';
	КонецЦикла;	
	
	КоличествоЭкземпляров = 1;
	КоличествоЛистов 	  = 1;
	КоличествоПриложений  = 0;
	ЛистовВПриложениях 	  = 0;
	Дело = Справочники.ДелаХраненияДокументов.ПустаяСсылка();
	
	ПодписанЭП = Ложь;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт 
	
	Если ЭтоНовый() Тогда 
		
		РегистрационныйНомер = "";
		ЧисловойНомер = 0;
		ДатаРегистрации = '00010101';
		ДатаСоздания = ТекущаяДатаСеанса();
		Зарегистрировал = Справочники.Пользователи.ПустаяСсылка();
		Подготовил = ПользователиКлиентСервер.ТекущийПользователь();
		Подразделение = РаботаСПользователями.ПолучитьПодразделение(Подготовил);
		Подписал = Справочники.Пользователи.ПустаяСсылка();
		СрокИсполнения = '00010101';
		
		Для Каждого Строка Из Получатели Цикл
			Строка.Отправлен = Ложь;
			Строка.ДатаОтправки = '00010101';
			Строка.СпособОтправки = Справочники.СпособыДоставки.ПустаяСсылка();
		КонецЦикла;
		
		КоличествоЭкземпляров = 1;
		КоличествоЛистов = 1;
		КоличествоПриложений = 0;
		ЛистовВПриложениях = 0;
		Дело = Справочники.ДелаХраненияДокументов.ПустаяСсылка();
		
		Если Не ЗначениеЗаполнено(ВидДокумента) Тогда
			ВидДокумента = Делопроизводство.ПолучитьВидДокументаПоУмолчанию(Ссылка);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Организация) Тогда
			Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
		КонецЕсли;
		
		Если Константы.ИспользоватьГрифыДоступа.Получить() Тогда
			ГрифДоступа = Константы.ГрифДоступаПоУмолчанию.Получить();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВидДокумента) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьСуммуВИсходящих", 
				Новый Структура("ВидИсходящегоДокумента", ВидДокумента)) Тогда 
			Валюта = Делопроизводство.ПолучитьВалютуПоУмолчанию();
		КонецЕсли;
	
		Если Не ЗначениеЗаполнено(Проект) Тогда 
			Проект = РаботаСПроектами.ПолучитьПроектПоУмолчанию();
		КонецЕсли;
	
	КонецЕсли;
	
	ОснованиеЗаполнения = ДанныеЗаполнения;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("Основание") Тогда
		//заполнить данными из шаблона 
		ОснованиеЗаполнения = ДанныеЗаполнения.Основание;
		СписокРеквизитовЗаполнения = "";
		МетаданныеОбъекта = ЭтотОбъект.Метаданные();
		Для Каждого АтрибутШаблона Из ДанныеЗаполнения Цикл
			Если МетаданныеОбъекта.Реквизиты.Найти(АтрибутШаблона.Ключ) <> Неопределено
				И ЗначениеЗаполнено(АтрибутШаблона.Значение) Тогда
				Если ЗначениеЗаполнено(СписокРеквизитовЗаполнения) Тогда
					СписокРеквизитовЗаполнения = СписокРеквизитовЗаполнения + "," + АтрибутШаблона.Ключ;
				Иначе
					СписокРеквизитовЗаполнения = АтрибутШаблона.Ключ;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Если ЗначениеЗаполнено(СписокРеквизитовЗаполнения) Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, СписокРеквизитовЗаполнения);
		КонецЕсли;
	КонецЕсли;
	
	// Ввод на основании
	Если ТипЗнч(ОснованиеЗаполнения) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
		
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ответ на ""%1""'"), ОснованиеЗаполнения.Заголовок);
		
		НоваяСтрока = Получатели.Добавить();
		НоваяСтрока.Получатель = ОснованиеЗаполнения.Отправитель;
		НоваяСтрока.Адресат = ОснованиеЗаполнения.Подписал;
		Если РаботаССВД.ДокументПолученПоСВД(ОснованиеЗаполнения) Тогда
			НоваяСтрока.СпособОтправки = Справочники.СпособыДоставки.СВД;
		КонецЕсли;	
		
		ГрифДоступа = ОснованиеЗаполнения.ГрифДоступа;
		ВопросДеятельности = ОснованиеЗаполнения.ВопросДеятельности;
		Организация = ОснованиеЗаполнения.Организация;
		Проект = ОснованиеЗаполнения.Проект;
		
	ИначеЕсли ТипЗнч(ОснованиеЗаполнения) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Отправка ""%1""'"), ОснованиеЗаполнения.Заголовок);
		Подписал = ОснованиеЗаполнения.Утвердил;
		ГрифДоступа = ОснованиеЗаполнения.ГрифДоступа;
		ВопросДеятельности = ОснованиеЗаполнения.ВопросДеятельности;
		Организация = ОснованиеЗаполнения.Организация;
		Проект = ОснованиеЗаполнения.Проект;
		
		Если ОснованиеЗаполнения.ВидДокумента.ВестиУчетПоКорреспондентам Тогда
			НоваяСтрока = Получатели.Добавить();
			НоваяСтрока.Получатель = ОснованиеЗаполнения.Корреспондент;
			НоваяСтрока.Адресат = ОснованиеЗаполнения.КонтактноеЛицо;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОснованиеЗаполнения) = Тип("Массив")  
		И ОснованиеЗаполнения.Количество() > 0
		И ТипЗнч(ОснованиеЗаполнения[0]) = Тип("СправочникСсылка.Файлы") Тогда 
		
		Если ОснованиеЗаполнения.Количество() = 1 И Не ЗначениеЗаполнено(Заголовок) Тогда			
			Заголовок = ОснованиеЗаполнения[0].ПолноеНаименование;			
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") И Не ЗначениеЗаполнено(Проект) Тогда
			Проекты = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ОснованиеЗаполнения, "Проект");
			Проект = Проекты.Получить(ОснованиеЗаполнения[0]);
			Для Каждого Строка Из Проекты Цикл
				Если Строка.Значение <> Проект Тогда 
					Проект = Неопределено;
					Прервать;
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;	
		
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(ОснованиеЗаполнения) Тогда
		
		ОснованиеЗаполненияОбъект = ОснованиеЗаполнения.ПолучитьОбъект();
		
		Содержание = ОснованиеЗаполненияОбъект.ПолучитьТекстовоеПредставлениеСодержанияПисьма();
		Заголовок = ОснованиеЗаполненияОбъект.Тема;
		Проект = ОснованиеЗаполненияОбъект.Проект;
		
		Если ВстроеннаяПочтаКлиентСервер.ЭтоВходящееПисьмо(ОснованиеЗаполнения) Тогда
			
			СтруктураРезультата = ВстроеннаяПочтаСервер.ПолучитьКорреспондентаИКонтактноеЛицоПоСтрокеАдреса(ОснованиеЗаполненияОбъект.ОтправительАдресат.Адрес);
			Если СтруктураРезультата <> Неопределено Тогда
				НоваяСтрока = Получатели.Добавить();
				НоваяСтрока.Получатель = СтруктураРезультата.Корреспондент;
				НоваяСтрока.Адресат = СтруктураРезультата.КонтактноеЛицо;
			КонецЕсли;
			
		ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоИсходящееПисьмо(ОснованиеЗаполнения) Тогда
			
			ПисьмоОтправлено = ЗначениеЗаполнено(ОснованиеЗаполненияОбъект.ДатаОтправки);
			
			ОбработатьЗаполнениеПолучателей(ОснованиеЗаполненияОбъект.ПолучателиПисьма, ОснованиеЗаполненияОбъект.ДатаОтправки, ПисьмоОтправлено);
			ОбработатьЗаполнениеПолучателей(ОснованиеЗаполненияОбъект.ПолучателиКопий, ОснованиеЗаполненияОбъект.ДатаОтправки, ПисьмоОтправлено);
			ОбработатьЗаполнениеПолучателей(ОснованиеЗаполненияОбъект.ПолучателиСкрытыхКопий, ОснованиеЗаполненияОбъект.ДатаОтправки, ПисьмоОтправлено);
			
		КонецЕсли;
		
        //{{1С-Минск
	ИначеЕсли ТипЗнч(ОснованиеЗаполнения)=Тип("Массив")
		И ОснованиеЗаполнения.Количество() > 0
		И ТипЗнч(ОснованиеЗаполнения[0]) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
        // Ввод на основании нескольких входящих
		//  В заголовок выводим все, а реквизиты заполняем по первому, т.к. предполагается, что все остальные аналогичны
        Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Ответ на ""%1""'"), ОснованиеЗаполнения[0].Заголовок);
        Для й = 1 По ОснованиеЗаполнения.ВГраница() Цикл
            Заголовок = Заголовок +  
        	         СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = ', ""%1""'"), ОснованиеЗаполнения[й].Заголовок);
        КонецЦикла; 
		
		НоваяСтрока = Получатели.Добавить();
		НоваяСтрока.Получатель = ОснованиеЗаполнения[0].Отправитель;
		НоваяСтрока.Адресат = ОснованиеЗаполнения[0].Подписал;
		ГрифДоступа = ОснованиеЗаполнения[0].ГрифДоступа;
		ВопросДеятельности = ОснованиеЗаполнения[0].ВопросДеятельности;
		Организация = ОснованиеЗаполнения[0].Организация;
		Проект = ОснованиеЗаполнения[0].Проект;    
    //}}1C-Минск
    
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьЗаполнениеПолучателей(ПолучателиПисьма, ДатаОтправки, ПисьмоОтправлено)
	
	Для Каждого Получатель Из ПолучателиПисьма Цикл
		
		СтруктураРезультата = ВстроеннаяПочтаСервер.ПолучитьКорреспондентаИКонтактноеЛицоПоСтрокеАдреса(Получатель.Адресат.Адрес);
		Если СтруктураРезультата <> Неопределено Тогда
			
			НоваяСтрока = Получатели.Добавить();
			НоваяСтрока.Получатель = СтруктураРезультата.Корреспондент;
			НоваяСтрока.Адресат = СтруктураРезультата.КонтактноеЛицо;
			
			Если ПисьмоОтправлено Тогда
				НоваяСтрока.Отправлен = Истина;
				НоваяСтрока.СпособОтправки = Справочники.СпособыДоставки.НайтиПоНаименованию("Email");
				НоваяСтрока.ДатаОтправки = ДатаОтправки;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры	

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСуммуВИсходящих", Новый Структура("ВидИсходящегоДокумента", ВидДокумента)) Тогда 
		Если ЗначениеЗаполнено(Сумма) Тогда 
			ПроверяемыеРеквизиты.Добавить("Валюта");
		КонецЕсли;	
	КонецЕсли;
	
	Для Счетчик = 0 По Получатели.Количество() - 1 Цикл
		Получатель = Получатели[Счетчик].Получатель;
		Адресат = Получатели[Счетчик].Адресат;
		Для Счетчик1 = Счетчик + 1 По Получатели.Количество() - 1 Цикл
			Получатель1 = Получатели[Счетчик1].Получатель;
			Адресат1 = Получатели[Счетчик1].Адресат;
			Если Получатель = Получатель1 И Адресат = Адресат1 Тогда
				
				Если ЗначениеЗаполнено(Адресат1) Тогда 
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Корреспондент %1 и контактное лицо %2 в списке получателей указаны дважды.'"),
						Строка(Получатель1), 
						Строка(Адресат1));
				Иначе 
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Корреспондент %1 в списке получателей указан дважды.'"),
						Строка(Получатель1));
				КонецЕсли;	
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект, 
					"Получатели["+Счетчик1+"].ПолучательТекст",
					,
					Отказ);
				Прервать;	
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	Если ЗначениеЗаполнено(РегистрационныйНомер) И ЗначениеЗаполнено(ДатаРегистрации) Тогда 
		Если Не Делопроизводство.РегистрационныйНомерУникален(ЭтотОбъект) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Регистрационный номер не уникален!'"),
				ЭтотОбъект,
				"РегистрационныйНомер",, 
				Отказ);
		КонецЕсли;	
	КонецЕсли;	
	
	Делопроизводство.ПроверитьЗаполнениеДела(ЭтотОбъект, Отказ);
	
	Если ЗначениеЗаполнено(Дело) Тогда 
		
		Если (Ссылка.Дело <> Дело Или Ссылка.ВидДокумента <> ВидДокумента)   
			И Не Делопроизводство.ДелоМожетСодержатьДокумент("ВидыДокументов", ВидДокумента, Дело) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело не может содержать документы с видом %1.'"),
					Строка(ВидДокумента)),
				,
				"ДелоТекст",, 
				Отказ);
		КонецЕсли;
		
		Для Каждого Строка Из Получатели Цикл
			Если (Ссылка.Дело <> Дело Или Ссылка.Получатели <> Получатели)
				И Не Делопроизводство.ДелоМожетСодержатьДокумент("Корреспонденты", Строка.Получатель, Дело) Тогда 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Дело не может содержать документы по корреспонденту %1.'"),
						Строка(Строка.Получатель)),
					ЭтотОбъект,
					"Дело",, 
					Отказ);
			КонецЕсли;
		КонецЦикла;	
		
		Если (Ссылка.Дело <> Дело Или Ссылка.ВопросДеятельности <> ВопросДеятельности)   
			И Не Делопроизводство.ДелоМожетСодержатьДокумент("ВопросыДеятельности", ВопросДеятельности, Дело) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Дело не может содержать документы по вопросу деятельности %1.'"),
					Строка(ВопросДеятельности)),
				ЭтотОбъект,
				"Дело",, 
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Делопроизводство.ПроверкаСвязейПриИзмененииВидаДокумента(ЭтотОбъект, Отказ);
	
	Если ВидДокумента.ВестиУчетПоНоменклатуреДел Тогда
		Делопроизводство.ПроверитьСоответствиеНоменклатурыДел(ЭтотОбъект, Отказ);
	КонецЕсли;	

	Если ЗначениеЗаполнено(ВидДокумента) Тогда 
		
		ОбязательноеУказаниеОтветственного = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДокумента, 
			"ОбязательноеУказаниеОтветственного");
			
		Если ОбязательноеУказаниеОтветственного И Не ЗначениеЗаполнено(Ответственный) Тогда
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'У документа вида ""%1"" должен быть обязательно указан ответственный.'"),
					Строка(ВидДокумента)),
				ЭтотОбъект,
				"Ответственный",, 
				Отказ);
				
		КонецЕсли;
			
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель)
		И ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущийРегистрационныйНомер = Неопределено;

	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
	Иначе
		ПредыдущийРегистрационныйНомер = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "РегистрационныйНомер");
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ПредыдущийРегистрационныйНомер", ПредыдущийРегистрационныйНомер);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписьПодписанногоОбъекта = Ложь;
	Если ДополнительныеСвойства.Свойство("ЗаписьПодписанногоОбъекта") Тогда
		ЗаписьПодписанногоОбъекта = ДополнительныеСвойства.ЗаписьПодписанногоОбъекта;
	КонецЕсли;	
	
	Если НЕ ПривилегированныйРежим() И ЗаписьПодписанногоОбъекта <> Истина Тогда
		
		Если ЗначениеЗаполнено(Ссылка) Тогда
			СсылкаПодписан = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ПодписанЭП");
			Если ПодписанЭП И СсылкаПодписан Тогда
				// тут проверяем ключевые поля - изменились ли
				МассивИмен = Справочники.ИсходящиеДокументы.ПолучитьИменаКлючевыхРеквизитов();
				РаботаСЭП.ПроверитьИзмененностьКлючевыхПолей(МассивИмен, ЭтотОбъект, Ссылка);
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;	
	
	// Заполним наименование
	Наименование = Делопроизводство.НаименованиеДокумента(ЭтотОбъект);
	
	// Заполним строковое представление получателей
	ПолучателиДляСписков = "";
	Для Каждого Строка Из Получатели Цикл
		ПолучателиДляСписков = ПолучателиДляСписков + Строка(Строка.Получатель) + ", ";
	КонецЦикла;	
	Если СтрДлина(ПолучателиДляСписков) > 0 Тогда 
		ПолучателиДляСписков = Лев(ПолучателиДляСписков, СтрДлина(ПолучателиДляСписков) - 2);
	КонецЕсли;	
	
	// Пометка на удаление приложенных файлов
	ПредыдущаяПометкаУдаления = Ложь;
	Если Не Ссылка.Пустая() Тогда
		ПредыдущаяПометкаУдаления = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ПометкаУдаления");
	КонецЕсли;
	ДополнительныеСвойства.Вставить("ПредыдущаяПометкаУдаления", ПредыдущаяПометкаУдаления);
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда 
		
		Если ПометкаУдаления Тогда
			ДополнительныеСвойства.Вставить("НужноПометитьНаУдалениеБизнесСобытия", Истина);
		КонецЕсли;
		
		РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Ссылка, ПометкаУдаления);
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Заполним дату начала дела, если не заполнена
	Если ЗначениеЗаполнено(Дело) И Не ЗначениеЗаполнено(Дело.ДатаНачала) И ЗначениеЗаполнено(ДатаРегистрации) Тогда 
		
		ДелоОбъект = Дело.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(ДелоОбъект.Ссылка);
		ДелоОбъект.ДатаНачала = ДатаРегистрации;
		ДелоОбъект.Записать();	
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоступаКПерсональнымДанным") Тогда
		ЭтотОбъект.ДополнительныеСвойства.Вставить(
			"ИзменилсяСписокПерсональныхДанных", ПерсональныеДанные.ИзменилсяСписокПерсональныхДанных(ЭтотОбъект));
	КонецЕсли;	
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
		Если Не Ссылка.Пустая() Тогда 
			СсылкаПроект = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Проект");
			ЭтотОбъект.ДополнительныеСвойства.Вставить("ИзменилсяПроект", СсылкаПроект <> Проект);
		КонецЕсли;	
	КонецЕсли;
	
	// Обработка рабочей группы
	СсылкаОбъекта = Ссылка;
	// Установка ссылки нового
	Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
		СсылкаОбъекта = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
			СсылкаНового = Справочники.ИсходящиеДокументы.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНового);
			СсылкаОбъекта = СсылкаНового;
		КонецЕсли;
	КонецЕсли;
	
	// Подготовка рабочей группы
	РабочаяГруппа = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(СсылкаОбъекта);
	
	// Добавление автоматических участников из самого объекта
	Если ПоОбъектуВедетсяАвтоматическоеЗаполнениеРабочейГруппы() Тогда
		
		ДобавитьУчастниковРабочейГруппыВНабор(РабочаяГруппа);
		
	КонецЕсли;
	
	// Добавление участников, переданных "снаружи", например из формы объекта
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаДобавить") Тогда
		
		Для каждого Эл Из ДополнительныеСвойства.РабочаяГруппаДобавить Цикл
			
			// Добавление участника в итоговую рабочую группу
			Строка = РабочаяГруппа.Добавить();
			Строка.Участник = Эл.Участник;
			Строка.ОсновнойОбъектАдресации = Эл.ОсновнойОбъектАдресации;
			Строка.ДополнительныйОбъектАдресации = Эл.ДополнительныйОбъектАдресации;
			
		КонецЦикла;	
			
	КонецЕсли;		
	
	// Удаление участников, переданных "снаружи", например из формы объекта
	Если ДополнительныеСвойства.Свойство("РабочаяГруппаУдалить") Тогда
		
		Для каждого Эл Из ДополнительныеСвойства.РабочаяГруппаУдалить Цикл
			
			// Поиск удаляемого участника в итоговой рабочей группе
			Для каждого Эл2 Из РабочаяГруппа Цикл
				
				Если Эл2.Участник = Эл.Участник 
					И Эл2.ОсновнойОбъектАдресации = Эл.ОсновнойОбъектАдресации
					И Эл2.ДополнительныйОбъектАдресации = Эл.ДополнительныйОбъектАдресации Тогда
					
					// Удаление участника из итоговой рабочей группы
					РабочаяГруппа.Удалить(Эл2);
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;	
				
		КонецЦикла;	
			
	КонецЕсли;		
	
	// Обработка обязательного заполнения рабочих групп 
	Если РабочаяГруппа.Количество() = 0 Тогда
	
		Если РаботаСРабочимиГруппами.ОбязательноеЗаполнениеРабочихГруппДокументов(ВидДокумента) Тогда
			Строка = РабочаяГруппа.Добавить();
			Строка.Участник = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
		
	КонецЕсли;		
	
	// Запись итоговой рабочей группы
	РаботаСРабочимиГруппами.ПерезаписатьРабочуюГруппуОбъекта(
		СсылкаОбъекта,
		РабочаяГруппа,
		Ложь); //ОбновитьПраваДоступа
	
	// Установка необходимости обновления прав доступа
	ДополнительныеСвойства.Вставить("ДополнительныеПравообразующиеЗначенияИзменены");
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	СтруктураПараметров = НумерацияКлиентСервер.ПолучитьПараметрыНумерации(ЭтотОбъект);
	Нумерация.ОсвободитьНомер(СтруктураПараметров);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель)
		И ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		Если ДополнительныеСвойства.Свойство("ЭтоНовый") И ДополнительныеСвойства.ЭтоНовый Тогда
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеИсходящегоДокумента);
		Иначе
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ИзменениеИсходящегоДокумента);
		КонецЕсли;	
	КонецЕсли;
		
	Если ДополнительныеСвойства.Свойство("НужноПометитьНаУдалениеБизнесСобытия") Тогда
		БизнесСобытияВызовСервера.ПометитьНаУдалениеСобытияПоИсточнику(Ссылка);
	КонецЕсли;	
		
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		Если ЗначениеЗаполнено(РегистрационныйНомер) И РегистрационныйНомер <> ДополнительныеСвойства.ПредыдущийРегистрационныйНомер Тогда
			Если ЗначениеЗаполнено(ДополнительныеСвойства.ПредыдущийРегистрационныйНомер) Тогда
				БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ПеререгистрацияИсходящегоДокумента);	
			Иначе	
				БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.РегистрацияИсходящегоДокумента);	
			КонецЕсли;			
		КонецЕсли;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если ДополнительныеСвойства.Свойство("ПредыдущаяПометкаУдаления") Тогда
		ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущаяПометкаУдаления;
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		ПротоколированиеРаботыПользователей.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтрихкоды")
		И ДополнительныеСвойства.Свойство("ЭтоНовый") 
		И ДополнительныеСвойства.ЭтоНовый Тогда
		
		Штрихкод = ШтрихкодированиеСервер.СформироватьШтрихКод();
		ШтрихкодированиеСервер.ПрисвоитьШтрихКод(Ссылка, Штрихкод);
		
	КонецЕсли;
	
	// Заполняем сведения о персональных данных во всех файлах
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоступаКПерсональнымДанным") Тогда
		
		Если Не ОбменДанными.Загрузка 
			И ЭтотОбъект.ДополнительныеСвойства.Свойство("ИзменилсяСписокПерсональныхДанных") 
			И ЭтотОбъект.ДополнительныеСвойства.ИзменилсяСписокПерсональныхДанных Тогда
			
			ПерсональныеДанные.ЗаполнитьПерсональныеДанныеФайлов(Ссылка);
			
		КонецЕсли;	
		
	КонецЕсли;
	
	// Заполнение проекта в файлах
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
		Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ИзменилсяПроект") 
		   И ЭтотОбъект.ДополнительныеСвойства.ИзменилсяПроект Тогда
			РаботаСПроектами.ЗаполнитьПроектПодчиненныхФайлов(Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	// обновить связи документа
	СвязиДокументов.ОбновитьСвязиДокумента(Ссылка);
	
	//1С-Минск +
	
	// При записи писем с видом ПисьмоОНеПодписанииДоговора или ПисьмоОРасторженииДоговора
	//  изменить состояние и реквизиты договора
	ВидИсхДок = ЭтотОбъект.ВидДокумента;	
	Если ВидИсхДок = Справочники.ВидыИсходящихДокументов.ПисьмоОНеПодписанииДоговора Тогда
		Договор = СвязиДокументов.ПолучитьСвязанныйДокумент(Ссылка, Справочники.ТипыСвязей.ПредметПереписки);
		Если ЗначениеЗаполнено(Договор) Тогда
			НеПодписан = Перечисления.мСостоянияДоговоров.НеПодписан;
			мРаботаСДоговорами.УстановитьСостояниеДоговора(Договор, НеПодписан);
			мРаботаСДоговорами.РасторгнутьДоговор(Договор, ТекущаяДата());
		КонецЕсли; 
		
	ИначеЕсли ВидИсхДок = Справочники.ВидыИсходящихДокументов.ПисьмоОРасторженииДоговора Тогда
		Договор = СвязиДокументов.ПолучитьСвязанныйДокумент(Ссылка, Справочники.ТипыСвязей.ПредметПереписки);
		Если ЗначениеЗаполнено(Договор) Тогда
			Расторгнут = Перечисления.мСостоянияДоговоров.Расторгнут;
			мРаботаСДоговорами.УстановитьСостояниеДоговора(Договор, Расторгнут);
			мРаботаСДоговорами.РасторгнутьДоговор(Договор, ТекущаяДата());
		КонецЕсли; 
	КонецЕсли; 
	//1С-Минск -
	
КонецПроцедуры

Процедура ДобавитьУчастниковРабочейГруппыВНабор(ТаблицаНабора)
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		ИсходныеРеквизиты = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Ссылка,
			"ВидДокумента, Ответственный, Зарегистрировал, Подготовил, Подписал");
			
		Если ИсходныеРеквизиты.ВидДокумента = ВидДокумента Тогда
			ДобавитьТолькоНовыхУчастниковРабочейГруппыВНабор(ТаблицаНабора, ИсходныеРеквизиты);
		Иначе
			ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора);
		КонецЕсли;	
		
	Иначе	
		
		ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьТолькоНовыхУчастниковРабочейГруппыВНабор(ТаблицаНабора, ИсходныеРеквизиты)
	
	// Добавление реквизита Ответственный
	Если ИсходныеРеквизиты.Ответственный <> Ответственный Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Ответственный);		
	КонецЕсли;				
	
	// Добавление реквизита Зарегистрировал
	Если ИсходныеРеквизиты.Зарегистрировал <> Зарегистрировал Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Зарегистрировал);		
	КонецЕсли;
	
	// Добавление реквизита Подготовил
	Если ИсходныеРеквизиты.Подготовил <> Подготовил Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подготовил);		
	КонецЕсли;
	
	// Добавление реквизита Подписал
	Если ИсходныеРеквизиты.Подписал <> Подписал Тогда
		РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подписал);		
	КонецЕсли;
	
КонецПроцедуры	

Процедура ДобавитьВсехУчастниковРабочейГруппыВНабор(ТаблицаНабора)
	
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Ответственный);
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Зарегистрировал);
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подготовил);
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, Подписал);
	
	// Добавление контролеров
	Контроль.ДобавитьКонтролеровВТаблицу(ТаблицаНабора, Ссылка);
	
КонецПроцедуры

Функция ПоОбъектуВедетсяАвтоматическоеЗаполнениеРабочейГруппы()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьВидыИсходящихДокументов") Тогда
		Возврат Ложь;
	КонецЕсли;		
	
	Если Не ЗначениеЗаполнено(ВидДокумента) Тогда
		Возврат Не ЗапретитьАвтоматическоеДобавлениеУчастниковРабочейГруппы;
	КонецЕсли;
	
	АвтоГруппа = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ВидДокумента, "АвтоматическиВестиСоставУчастниковРабочейГруппы");
	
	Возврат АвтоГруппа И Не ЗапретитьАвтоматическоеДобавлениеУчастниковРабочейГруппы;
	
КонецФункции	

#КонецЕсли
