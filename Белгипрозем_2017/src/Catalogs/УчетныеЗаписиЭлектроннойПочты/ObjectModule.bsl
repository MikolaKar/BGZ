Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьОбъектЗначениямиПоУмолчанию();
	
КонецПроцедуры

// Инициализирует новую учетную запись значениями по умолчанию
//
Процедура ЗаполнитьОбъектЗначениямиПоУмолчанию() Экспорт
	
	ИмяПользователя = "1С:Предприятие";
	SMTPАутентификация = Перечисления.ВариантыSMTPАутентификации.НеЗадано;
	ОставлятьКопииСообщенийНаСервере = Ложь;
	ПериодХраненияСообщенийНаСервере = 0;
	ВремяОжидания = 30;
	SMTPАутентификация = Перечисления.ВариантыSMTPАутентификации.НеЗадано;
	СпособSMTPАутентификации = Перечисления.СпособыSMTPАутентификации.БезАутентификации;
	СпособPOP3Аутентификации = Перечисления.СпособыPOP3Аутентификации.Обычная;
	ПользовательSMTP = "";
	ПарольSMTP = "";
	ПортPOP3 = 110;
	ПортSMTP = 25;
	
	ИспользоватьДляОтправки = Истина;
	ИспользоватьДляПолучения = Истина;
	ВариантИспользования = Перечисления.ВариантыИспользованияПочты.Легкая;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущийВариантИспользования = Неопределено;
	Если Не ЭтоНовый() Тогда
		ПредыдущийВариантИспользования = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ВариантИспользования");
	КонецЕсли;
	
	СтараяПометкаУдаления = Ложь;
	Если Не ЭтоНовый() Тогда
		СтараяПометкаУдаления = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ПометкаУдаления");
	КонецЕсли;
	ДополнительныеСвойства.Вставить("СтараяПометкаУдаления", СтараяПометкаУдаления);
	
	// Обработка рабочей группы
	СсылкаОбъекта = Ссылка;
	// Установка ссылки нового
	Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
		СсылкаОбъекта = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
			СсылкаНового = Справочники.УчетныеЗаписиЭлектроннойПочты.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНового);
			СсылкаОбъекта = СсылкаНового;
		КонецЕсли;
	КонецЕсли;
	
	// Подготовка рабочей группы
	РабочаяГруппа = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(СсылкаОбъекта);
	
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
	
	// Запись итоговой рабочей группы
	РаботаСРабочимиГруппами.ПерезаписатьРабочуюГруппуОбъекта(
		СсылкаОбъекта,
		РабочаяГруппа,
		Ложь); //ОбновитьПраваДоступа
	
	// Установка необходимости обновления прав доступа
	ДополнительныеСвойства.Вставить("ДополнительныеПравообразующиеЗначенияИзменены");
	
	СтарыйАдресЭлектроннойПочты = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "АдресЭлектроннойПочты");
	ДополнительныеСвойства.Вставить("СтарыйАдресЭлектроннойПочты", СтарыйАдресЭлектроннойПочты);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресЭлектроннойПочты) Тогда
		
		Если ДополнительныеСвойства.Свойство("ПапкаВходящие")
			И ЗначениеЗаполнено(ДополнительныеСвойства.ПапкаВходящие) Тогда
			РегистрыСведений.ПапкиУчетныхЗаписей.УстановитьПапку(
				Ссылка,
				Перечисления.ВидыПапокПисем.Входящие,
				ДополнительныеСвойства.ПапкаВходящие);
		КонецЕсли;
		
		Если ДополнительныеСвойства.Свойство("ПапкаИсходящие")
			И ЗначениеЗаполнено(ДополнительныеСвойства.ПапкаИсходящие) Тогда
			РегистрыСведений.ПапкиУчетныхЗаписей.УстановитьПапку(
				Ссылка,
				Перечисления.ВидыПапокПисем.Исходящие,
				ДополнительныеСвойства.ПапкаИсходящие);
		КонецЕсли;
		
		Если ДополнительныеСвойства.Свойство("ПапкаОтправленные")
			И ЗначениеЗаполнено(ДополнительныеСвойства.ПапкаОтправленные) Тогда
			РегистрыСведений.ПапкиУчетныхЗаписей.УстановитьПапку(
				Ссылка,
				Перечисления.ВидыПапокПисем.Отправленные,
				ДополнительныеСвойства.ПапкаОтправленные);
		КонецЕсли;
		
		Если ДополнительныеСвойства.Свойство("ПапкаЧерновики")
			И ЗначениеЗаполнено(ДополнительныеСвойства.ПапкаЧерновики) Тогда
			РегистрыСведений.ПапкиУчетныхЗаписей.УстановитьПапку(
				Ссылка,
				Перечисления.ВидыПапокПисем.Черновики,
				ДополнительныеСвойства.ПапкаЧерновики);
		КонецЕсли;
		
		Если ДополнительныеСвойства.Свойство("ПапкаКорзина")
			И ЗначениеЗаполнено(ДополнительныеСвойства.ПапкаКорзина) Тогда
			РегистрыСведений.ПапкиУчетныхЗаписей.УстановитьПапку(
				Ссылка,
				Перечисления.ВидыПапокПисем.Корзина,
				ДополнительныеСвойства.ПапкаКорзина);
		КонецЕсли;
		
	КонецЕсли;
	
	// обновление адресатов
	Если ДополнительныеСвойства.Свойство("СтарыйАдресЭлектроннойПочты") 
		И ЗначениеЗаполнено(ДополнительныеСвойства.СтарыйАдресЭлектроннойПочты)
		И ДополнительныеСвойства.СтарыйАдресЭлектроннойПочты <> АдресЭлектроннойПочты Тогда 
		
		СтарыйАдресЭлектроннойПочты = ДополнительныеСвойства.СтарыйАдресЭлектроннойПочты;
		ОбновитьАдресатовПриИзмененииУчетнойЗаписи(СтарыйАдресЭлектроннойПочты);
	КонецЕсли;	
	ОбновитьАдресатовПриИзмененииУчетнойЗаписи(АдресЭлектроннойПочты);
	
	// удаление записей в рег ПисьмаВПроцессеОтправкиПоВнутреннейМаршрутизации
	Если ДополнительныеСвойства.Свойство("СтараяПометкаУдаления")
		И Не ДополнительныеСвойства.СтараяПометкаУдаления
		И ПометкаУдаления Тогда 
		УдалитьЗаписиПисемВПроцессеОтправки();
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбновитьАдресатовПриИзмененииУчетнойЗаписи(Адрес)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АдресатыПочтовыхСообщений.Ссылка
	|ИЗ
	|	Справочник.АдресатыПочтовыхСообщений КАК АдресатыПочтовыхСообщений
	|ГДЕ
	|	АдресатыПочтовыхСообщений.Адрес = &Адрес";
	
	Запрос.УстановитьПараметр("Адрес", Адрес);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ВыборкаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ВыборкаОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры	

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(Ссылка)
		И ВариантИспользования = Перечисления.ВариантыИспользованияПочты.Легкая Тогда
		
		ПредыдущийВариантИспользования = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ВариантИспользования");
		
		Если ПредыдущийВариантИспользования = Перечисления.ВариантыИспользованияПочты.Встроенная Тогда
			
			Если ВстроеннаяПочтаСервер.ЕстьПисьмаУчетнойЗаписи(Ссылка) Тогда
				
				Отказ = Истина;
				
				ВызватьИсключение НСтр(
					"ru = 'Нельзя изменять вариант использования на легкую почту. По учетной записи есть письма.'");
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВариантИспользования = Перечисления.ВариантыИспользованияПочты.Встроенная Тогда
		
		// Запрет установки "Использовать для встроенной почты" для системной учетной записи.
		СистемнаяУчетнаяЗаписьЭлектроннойПочты = 
			Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
		Если Ссылка = СистемнаяУчетнаяЗаписьЭлектроннойПочты Тогда
			ТекстСообщения = НСтр(
				"ru = 'Для системной учетной записи не предусмотрено использование для встроенной почты'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,, "Объект.ВариантИспользования",, Отказ);
		КонецЕсли;
			
		Если ИспользоватьДляПолучения И Не ЗначениеЗаполнено(СерверВходящейПочтыPOP3) Тогда
			
			ТекстСообщения = НСтр("ru = 'Укажите имя узла (POP3)'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,, "Объект.СерверВходящейПочтыPOP3",, Отказ);
			
		КонецЕсли;
		
		Если ИспользоватьДляОтправки И Не ЗначениеЗаполнено(СерверИсходящейПочтыSMTP) Тогда
			
			ТекстСообщения = НСтр("ru = 'Укажите имя узла (SMTP)'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,, "Объект.СерверИсходящейПочтыSMTP",, Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИспользоватьДляОтправки Или ИспользоватьДляПолучения Тогда
		
		Если Не РаботаСоСтроками.ЭтоАдресЭлектроннойПочты(АдресЭлектроннойПочты) Тогда
			
			ТекстСообщения = НСтр("ru = 'Укажите правильный адрес электронной почты'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,, "Объект.АдресЭлектроннойПочты",, Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЕстьУчетнаяЗаписьСТакимАдресом(АдресЭлектроннойПочты, ВариантИспользования, Ссылка) Тогда
	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Адрес электронной почты не уникален.'"),
			, "Объект.АдресЭлектроннойПочты",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Функция ЕстьУчетнаяЗаписьСТакимАдресом(АдресЭлектроннойПочты, ВариантИспользования, СсылкаНаСуществующуюЗапись)
	
	Если Не ЗначениеЗаполнено(АдресЭлектроннойПочты) Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(УчетныеЗаписиЭлектроннойПочты.Ссылка) КАК Количество
	               |ИЗ
	               |	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	               |ГДЕ
	               |	УчетныеЗаписиЭлектроннойПочты.АдресЭлектроннойПочты = &АдресЭлектроннойПочты
	               |	И УчетныеЗаписиЭлектроннойПочты.Ссылка <> &Ссылка
	               |	И УчетныеЗаписиЭлектроннойПочты.ВариантИспользования = &ВариантИспользования
	               |	И УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = Ложь";
	
	Запрос.Параметры.Вставить("АдресЭлектроннойПочты", АдресЭлектроннойПочты);
	Запрос.Параметры.Вставить("ВариантИспользования", ВариантИспользования);
	Запрос.Параметры.Вставить("Ссылка", СсылкаНаСуществующуюЗапись);
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если Выборка.Количество = 0 Тогда
			Возврат Ложь;
		Иначе
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура УдалитьЗаписиПисемВПроцессеОтправки()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПисьмаВПроцессеОтправкиПоВнутреннейМаршрутизации.Адресат,
	|	ПисьмаВПроцессеОтправкиПоВнутреннейМаршрутизации.Письмо
	|ИЗ
	|	РегистрСведений.ПисьмаВПроцессеОтправкиПоВнутреннейМаршрутизации КАК ПисьмаВПроцессеОтправкиПоВнутреннейМаршрутизации
	|ГДЕ
	|	ПисьмаВПроцессеОтправкиПоВнутреннейМаршрутизации.Адресат.Адрес = &Адрес";
	
	Запрос.УстановитьПараметр("Адрес", АдресЭлектроннойПочты);
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;	
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПисьмаВПроцессеОтправкиПоВнутреннейМаршрутизации");
	ЭлементБлокировки.ИсточникДанных = Результат;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Адресат", "Адресат");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Письмо", "Письмо");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	
	Для Каждого Строка Из Результат Цикл
		МенеджерЗаписи = РегистрыСведений.ПисьмаВПроцессеОтправкиПоВнутреннейМаршрутизации.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Строка);
		МенеджерЗаписи.Удалить();
	КонецЦикла;	
	
КонецПроцедуры	