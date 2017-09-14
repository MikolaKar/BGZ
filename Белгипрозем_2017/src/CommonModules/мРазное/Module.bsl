// Заполняет договор в этапе договора
// Применяется во внешней обработке ЗаполнитьДоговорыВЭтапах 
//
// Параметры:
//  ТаблицаЭтапов>  - ТаблицаЗначений - 
//  ИндексНачала  - Число
//  РазмерПроции  - Число
//
&НаСервере
Процедура ЗаполнитьДоговорВЭтапеДоговора(ТаблицаЭтапов, ИндексНачала, РазмерПроции) Экспорт
	// заполняем догвор только для определенной части таблицы
	Для Сч = 1 По РазмерПроции Цикл
		Индекс = ?(Сч=1, ИндексНачала, Индекс+1);
		ЭтапОбъект = ТаблицаЭтапов[Индекс].Ссылка.ПолучитьОбъект();
		ЭтапОбъект.Договор = ТаблицаЭтапов[Индекс].Договор;		
		ЭтапОбъект.Записать();
	КонецЦикла;
КонецПроцедуры // ЗаполнитьДоговорВЭтапеДоговора()

&НаСервере
Функция ПолучитьКоличествоДелПоЭтапу(ЭтапСсылка) Экспорт
   
    Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ
        |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВнутренниеДокументы.Ссылка) КАК КоличествоДел
        |ИЗ
        |	Справочник.ВнутренниеДокументы КАК ВнутренниеДокументы
        |ГДЕ
        |	НЕ ВнутренниеДокументы.ПометкаУдаления
        |	И ВнутренниеДокументы.ЭтапДоговора = &ЭтапДоговора
        |	И ВнутренниеДокументы.ВидДокумента = &ВидДокумента";
    
    Запрос.УстановитьПараметр("ЭтапДоговора", ЭтапСсылка);
    Запрос.УстановитьПараметр("ВидДокумента", Справочники.ВидыВнутреннихДокументов.Дело);
    
    РезультатЗапроса = Запрос.Выполнить();
    
    Если РезультатЗапроса.Пустой() Тогда
        Возврат 0;
    Иначе
        Выборка = РезультатЗапроса.Выбрать();
        Выборка.Следующий();
        Возврат Выборка.КоличествоДел;
    КонецЕсли; 
    
КонецФункции

&НаСервере
Функция КоличествоДелПоДоговору(Договор) Экспорт
   
    Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ
        |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВнутренниеДокументы.Ссылка) КАК КоличествоДел
        |ИЗ
        |	Справочник.ВнутренниеДокументы КАК ВнутренниеДокументы
        |ГДЕ
        |	НЕ ВнутренниеДокументы.ПометкаУдаления
        |	И ВнутренниеДокументы.ЭтапДоговора.Владелец = &Договор
        |	И ВнутренниеДокументы.ВидДокумента = &ВидДокумента";
    
    Запрос.УстановитьПараметр("Договор", Договор);
    Запрос.УстановитьПараметр("ВидДокумента", Справочники.ВидыВнутреннихДокументов.Дело);
    
    РезультатЗапроса = Запрос.Выполнить();
    
    Если РезультатЗапроса.Пустой() Тогда
        Возврат 0;
    Иначе
        Выборка = РезультатЗапроса.Выбрать();
        Выборка.Следующий();
        Возврат Выборка.КоличествоДел;
    КонецЕсли; 
КонецФункции

&НаСервере
Функция ПолучитьКоличествоДелУслугиПоДоговору(ДоговорСсылка) Экспорт
   
    Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ
        |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВнутренниеДокументы.Ссылка) КАК КоличествоДел
        |ИЗ
        |	Справочник.ВнутренниеДокументы КАК ВнутренниеДокументы
        |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвязиДокументов КАК СвязиДокументов
        |		ПО СвязиДокументов.Документ = ВнутренниеДокументы.Ссылка
        |ГДЕ
        |	НЕ ВнутренниеДокументы.ПометкаУдаления
        |	И ВнутренниеДокументы.ВидДокумента = &ВидДокумента
        |	И СвязиДокументов.СвязанныйДокумент = &ДоговорСсылка";
    
    Запрос.УстановитьПараметр("ДоговорСсылка", ДоговорСсылка);
    Запрос.УстановитьПараметр("ВидДокумента", Справочники.ВидыВнутреннихДокументов.ДелоУслуги);
    
    Результат = Запрос.Выполнить();
    
    Если Результат.Пустой() Тогда
        Возврат 0;
    Иначе
        Выборка = Результат.Выбрать();
        Выборка.Следующий();
        Возврат Выборка.КоличествоДел;
    КонецЕсли; 
    
КонецФункции

&НаСервере
Функция ПолучитьКоличествоСправокПроверкиПоДоговору(ДоговорСсылка) Экспорт
   
    Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ
        |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ мСправкиПроверки.Ссылка) КАК КоличествоСправок
        |ИЗ
        |	Справочник.мСправкиПроверки КАК мСправкиПроверки
        |ГДЕ
        |	НЕ мСправкиПроверки.ПометкаУдаления
        |	И мСправкиПроверки.Договор = &ДоговорСсылка";
    
    Запрос.УстановитьПараметр("ДоговорСсылка", ДоговорСсылка);
    
    Результат = Запрос.Выполнить();
    
    Если Результат.Пустой() Тогда
        Возврат 0;
    Иначе
        Выборка = Результат.Выбрать();
        Выборка.Следующий();
        Возврат Выборка.КоличествоСправок;
    КонецЕсли; 
    
КонецФункции

&НаСервере
Функция ПолучитьКоличествоСправокПроверкиПоДелу(ДелоСсылка, ВидПроверки) Экспорт
   
    Запрос = Новый Запрос;
    Запрос.Текст = 
        "ВЫБРАТЬ
        |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ мСправкиПроверки.Ссылка) КАК КоличествоСправок
        |ИЗ
        |	Справочник.мСправкиПроверки КАК мСправкиПроверки
        |ГДЕ
        |	НЕ мСправкиПроверки.ПометкаУдаления
        |	И мСправкиПроверки.Владелец = &ДелоСсылка
        |	И мСправкиПроверки.ВидПроверкиКачества = &ВидПроверки";
    
		Запрос.УстановитьПараметр("ДелоСсылка", ДелоСсылка);
		Запрос.УстановитьПараметр("ВидПроверки", ВидПроверки);
   
    Результат = Запрос.Выполнить();
    
    Если Результат.Пустой() Тогда
        Возврат 0;
    Иначе
        Выборка = Результат.Выбрать();
        Выборка.Следующий();
        Возврат Выборка.КоличествоСправок;
    КонецЕсли; 
    
КонецФункции

// Функция ЭтоДелегат(Кого)
//
// Параметры:
//  ОтКого  - <Пользователь> - тот кто делегирует права
// Возвращаемое значение:
//   Булево   - истина, если текущему пользователю делегированы права
//
&НаСервере
Функция ПравДелегированы(ОтКого) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЕстьЗаписи
	|ИЗ
	|	Справочник.ДелегированиеПрав КАК ДелегированиеПрав
	|ГДЕ
	|	ДелегированиеПрав.Кому = &Пользователь
	|	И (ДелегированиеПрав.ДатаНачалаДействия = ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ ДелегированиеПрав.ДатаНачалаДействия <= &ТекущаяДата)
	|	И (ДелегированиеПрав.ДатаОкончанияДействия = ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ ДелегированиеПрав.ДатаОкончанияДействия >= &ТекущаяДата)
	|	И НЕ ДелегированиеПрав.ПометкаУдаления
	|	И ДелегированиеПрав.ОтКого = &ОтКого");
	
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
	Запрос.УстановитьПараметр("ОтКого", ОтКого);
	
	ЭтоДелегат = Не Запрос.Выполнить().Пустой();
	
	Возврат ЭтоДелегат;

КонецФункции // ПравДелегированы()

&НаСервере
Функция УПользователяЕстьРоль(Пользователь, ИмяРоли) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
        |   ГруппыПользователейСостав.Ссылка КАК ГруппаПользователей
        |ПОМЕСТИТЬ ГруппыПользователей
        |ИЗ
        |   Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
        |ГДЕ
        |   ГруппыПользователейСостав.Пользователь = &Пользователь
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |   ПрофилиГруппДоступаРоли.Ссылка КАК Профиль
        |ПОМЕСТИТЬ Профили
        |ИЗ
        |   Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступаРоли
        |ГДЕ
        |   ПрофилиГруппДоступаРоли.Роль.Имя = &ИмяРоли
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |   ГруппыДоступаПользователи.Ссылка.Ссылка КАК Ссылка
        |ИЗ
        |   Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
        |ГДЕ
        |   (ГруппыДоступаПользователи.Пользователь = &Пользователь
        |           ИЛИ ГруппыДоступаПользователи.Пользователь В
        |               (ВЫБРАТЬ
        |                   ГруппыПользователей.ГруппаПользователей
        |               ИЗ
        |                   ГруппыПользователей КАК ГруппыПользователей))
        |   И ГруппыДоступаПользователи.Ссылка.Профиль В
        |           (ВЫБРАТЬ
        |               Профили.Профиль
        |           ИЗ
        |               Профили КАК Профили)";
	
	Запрос.УстановитьПараметр("ИмяРоли", ИмяРоли);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
КонецФункции	

// Возвращает настройки сканирования дел
&НаСервере
Функция ПолучитьНастройкиСканированияДел(ИдентификаторКлиента) Экспорт
	СохранятьВАрхив = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканированияДел/СохранятьВАрхив", ИдентификаторКлиента);
	Если СохранятьВАрхив = Неопределено Тогда
		СохранятьВАрхив = Ложь;
		ХранилищеОбщихНастроек.Сохранить("НастройкиСканированияДел/СохранятьВАрхив", ИдентификаторКлиента, СохранятьВАрхив);
	КонецЕсли;
	
	КаталогНаДиске = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканированияДел/КаталогНаДиске", ИдентификаторКлиента);
	Если КаталогНаДиске = Неопределено Тогда
		КаталогНаДиске = "";
		ХранилищеОбщихНастроек.Сохранить("НастройкиСканированияДел/КаталогНаДиске", ИдентификаторКлиента, КаталогНаДиске);
	КонецЕсли;
	
	ПутьКАрхивуФайлов = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканированияДел/ПутьКАрхивуФайлов", ИдентификаторКлиента);
	Если ПутьКАрхивуФайлов = Неопределено Тогда
		ПутьКАрхивуФайлов = "";
		ХранилищеОбщихНастроек.Сохранить("НастройкиСканированияДел/ПутьКАрхивуФайлов", ИдентификаторКлиента, ПутьКАрхивуФайлов);
	КонецЕсли;
	
	РайонПоУмолчаниюДляСкановДел = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканированияДел/РайонПоУмолчаниюДляСкановДел", ИдентификаторКлиента);
	Если РайонПоУмолчаниюДляСкановДел = Неопределено Тогда
		РайонПоУмолчаниюДляСкановДел = "";
		ХранилищеОбщихНастроек.Сохранить("НастройкиСканированияДел/РайонПоУмолчаниюДляСкановДел", ИдентификаторКлиента, РайонПоУмолчаниюДляСкановДел);
	КонецЕсли;
	
	НастройкиСканированияДел = Новый Структура;
	НастройкиСканированияДел.Вставить("КаталогНаДиске", КаталогНаДиске);
	НастройкиСканированияДел.Вставить("СохранятьВАрхив", СохранятьВАрхив);
	НастройкиСканированияДел.Вставить("ПутьКАрхивуФайлов", ПутьКАрхивуФайлов);
	НастройкиСканированияДел.Вставить("РайонПоУмолчаниюДляСкановДел", РайонПоУмолчаниюДляСкановДел);
	Возврат НастройкиСканированияДел;
КонецФункции // ПолучитьНастройкиСканированияДел()

// Возвращает Булево - настройки сканирования дел заполнены или нет
&НаСервере
Функция НастройкиСканированияДелНеЗаполнены(Настройки) Экспорт
	ЕстьОшибки = Ложь;
	КаталогНаДиске = Неопределено;
	СохранятьВАрхив = Неопределено;
	ПутьКАрхивуФайлов = Неопределено;
	РайонПоУмолчаниюДляСкановДел = Неопределено;
	
	Если Настройки.Свойство("КаталогНаДиске") Тогда
		КаталогНаДиске = Настройки.КаталогНаДиске;
	КонецЕсли; 
	
	Если Настройки.Свойство("СохранятьВАрхив") Тогда
		СохранятьВАрхив = Настройки.СохранятьВАрхив;
	КонецЕсли; 
	
	Если Настройки.Свойство("ПутьКАрхивуФайлов") Тогда
		ПутьКАрхивуФайлов = Настройки.ПутьКАрхивуФайлов;
	КонецЕсли; 
	
	Если Настройки.Свойство("РайонПоУмолчаниюДляСкановДел") Тогда
		РайонПоУмолчаниюДляСкановДел = Настройки.РайонПоУмолчаниюДляСкановДел;
	КонецЕсли; 
	
	Если КаталогНаДиске = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбран каталог для загрузки в настройке сканирования дел!'"), , "КаталогНаДиске");
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	Если СохранятьВАрхив = Неопределено Тогда
		// остальные можно не анализировать	
	Иначе
		Если ПутьКАрхивуФайлов = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан путь к архиву файлов в настройке сканирования дел!'"), , "ПутьКАрхивуФайлов");
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если РайонПоУмолчаниюДляСкановДел = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан район по умолчанию в настройке сканирования дел!'"), , "РайонПоУмолчаниюДляСкановДел");
			ЕстьОшибки = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЕстьОшибки;
КонецФункции // НастройкиСканированияДелНеЗаполнены()

&НаСервере
Функция ПолучитьКомиссию(Комиссия) Экспорт
	РеквизитыКомиссии = Новый Структура("НомерПриказа, ДатаПриказа, Председатель, ЧленКомиссии1, ЧленКомиссии2, ЧленКомиссии3, ЧленКомиссии4,
		| ДолжностьПредседателя, Должность1, Должность2, Должность3, Должность4");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мКомиссии.НомерПриказа,
		|	мКомиссии.ДатаПриказа,
		|	мКомиссии.Председатель,
		|	мКомиссии.ЧленКомиссии1,
		|	мКомиссии.ЧленКомиссии2,
		|	мКомиссии.ЧленКомиссии3,
		|	мКомиссии.ЧленКомиссии4,
		|	ВЫБОР
		|		КОГДА СведенияОПользователях.Пользователь = мКомиссии.Председатель
		|			ТОГДА СведенияОПользователях.Должность
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК ДолжностьПредседателя,
		|	ВЫБОР
		|		КОГДА СведенияОПользователях.Пользователь = мКомиссии.ЧленКомиссии1
		|			ТОГДА СведенияОПользователях.Должность
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК Должность1,
		|	ВЫБОР
		|		КОГДА СведенияОПользователях.Пользователь = мКомиссии.ЧленКомиссии2
		|			ТОГДА СведенияОПользователях.Должность
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК Должность2,
		|	ВЫБОР
		|		КОГДА СведенияОПользователях.Пользователь = мКомиссии.ЧленКомиссии3
		|			ТОГДА СведенияОПользователях.Должность
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК Должность3,
		|	ВЫБОР
		|		КОГДА СведенияОПользователях.Пользователь = мКомиссии.ЧленКомиссии4
		|			ТОГДА СведенияОПользователях.Должность
		|		ИНАЧЕ """"
		|	КОНЕЦ КАК Должность4
		|ИЗ
		|	Справочник.мКомиссии КАК мКомиссии,
		|	РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
		|ГДЕ
		|	мКомиссии.Ссылка = &Комиссия
		|	И НЕ мКомиссии.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Комиссия", Комиссия);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(РеквизитыКомиссии, Выборка); 
	КонецЕсли;   
	
	Возврат РеквизитыКомиссии;	

КонецФункции // ПолучитьКомиссию()

&НаСервере
Функция ПолучитьГородБазы() Экспорт
	Если Константы.М_Брест.Получить() Тогда
		Возврат "Брест";
	ИначеЕсли Константы.М_Минск.Получить() Тогда
		Возврат "Минск";
	ИначеЕсли Константы.М_Гродно.Получить() Тогда
		Возврат "Гродно";
	ИначеЕсли Константы.М_Прилуки.Получить() Тогда
		Возврат "Прилуки";
	ИначеЕсли Константы.М_Витебск.Получить() Тогда
		Возврат "Витебск";
	ИначеЕсли Константы.М_Гомель.Получить() Тогда
		Возврат "Гомель";
	ИначеЕсли Константы.М_Могилев.Получить() Тогда
		Возврат "Могилев";
	КонецЕсли; 
	Возврат "";
КонецФункции // ПолучитьГородБазы()

// Если Источник - Пользователь, то возвращает город из подразделения пользователя
// Если Источник - Подразделение, то возвращает город из подразделения
// Если в подразделении не указан город, то возвращается город из Констант
// Если Источник не указан, то возвращает город из подразделения текущего пользователя 
&НаСервере
Функция ПолучитьГородПодразделения(Источник = "") Экспорт
	ГородПодразделения = "";
	
	Если ЗначениеЗаполнено(Источник) Тогда
		Если ТипЗнч(Источник) = Тип("СправочникСсылка.Пользователи") Тогда
			ТекущееПодразделение = РаботаСПользователями.ПолучитьПодразделение(Источник);
			ГородПодразделения	= ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекущееПодразделение, "Город");
		ИначеЕсли ТипЗнч(Источник) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
			ГородПодразделения	= ОбщегоНазначения.ПолучитьЗначениеРеквизита(Источник, "Город");
		КонецЕсли; 
	Иначе
		ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
		ТекущееПодразделение = РаботаСПользователями.ПолучитьПодразделение(ТекущийПользователь);
		ГородПодразделения	= ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекущееПодразделение, "Город");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ГородПодразделения) Тогда
		ГородПодразделения = мРазное.ПолучитьГородБазы();
	КонецЕсли; 
	
	Возврат ГородПодразделения;
КонецФункции // ПолучитьГородПодразделения()

&НаСервере
Функция НашГород(СтруктураНашихРеквизитов = "") Экспорт
	Город = "";
	
	ГородБазы = мРазное.ПолучитьГородБазы();
	Если ГородБазы = "Брест" Тогда
		// Город получаем из подразделения исполнителя
		Город = мРазное.ПолучитьГородПодразделения();
	
	ИначеЕсли ГородБазы = "Минск" Тогда
		Если СтруктураНашихРеквизитов <> "" И 
			СтруктураНашихРеквизитов.Свойство("НашГород") Тогда
			Город = СтруктураНашихРеквизитов.НашГород;
		Иначе	
			Город = мРазное.ПолучитьГородБазы();
		КонецЕсли; 
		
	ИначеЕсли ГородБазы = "Прилуки" Тогда
		Если СтруктураНашихРеквизитов <> "" И 
			СтруктураНашихРеквизитов.Свойство("НашГород") Тогда
			Город = СтруктураНашихРеквизитов.НашГород;
		Иначе	
			Город = ГородБазы;
		КонецЕсли; 
		
	ИначеЕсли ГородБазы = "Гродно" Тогда
		Город = мРазное.ПолучитьГородБазы();
	КонецЕсли; 
	
	Возврат Город;
КонецФункции 
 
// Формирует инициалы и фамилию либо по наименованию элемента справочника ФизическиеЛица,
// либо по переданным строкам, либо по наименованию элемента справочника Пользователи.
// Если передан Объект, то извлеченная из него строка считается совокупностью 
// Фамилия + Имя + Отчество, разделенными пробелами.
//
// Параметры
//  ОбъектИлиСтрока - строка, ссылка или объект элемента справочника ФизическиеЛица, Ссылка на Пользователя.
//  Фамилия		    - фамилия физического лица.
//  Имя		        - имя физического лица.
//  Отчество	    - отчество физического лица.
//
// Возвращаемое значение 
//  Строка - инициалы и фамилия одной строкой. 
//  В параметрах Фамилия, Имя и Отчество записываются вычисленные части.
//
// Пример:
//  Результат = ФамилияИнициалыФизЛица("Иванов Иван Иванович"); // Результат = "Иванов И. И."
//
&НаСервере
Функция ИнициалыФамилияПользователя(ОбъектИлиСтрока = "", Фамилия = " ", Имя = " ", Отчество = " ") Экспорт

	ТипОбъекта = ТипЗнч(ОбъектИлиСтрока);
	Если ТипОбъекта = Тип("Строка") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(ОбъектИлиСтрока), " ");
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ФизическиеЛица") Или ТипОбъекта = Тип("СправочникОбъект.ФизическиеЛица") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(ОбъектИлиСтрока.Наименование), " ");
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.Пользователи") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(ОбъектИлиСтрока.Наименование), " ");
	Иначе
		// используем возможно переданные отдельные строки
		Возврат 
		?(Не ПустаяСтрока(Фамилия), 
		          ?(Не ПустаяСтрока(Имя), " " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество,1) + ".", ""), "")+ Фамилия,
		          "")
	КонецЕсли;
	
	КоличествоПодстрок = ФИО.Количество();
	Фамилия            = ?(КоличествоПодстрок > 0, ФИО[0], "");
	Имя                = ?(КоличествоПодстрок > 1, ФИО[1], "");
	Отчество           = ?(КоличествоПодстрок > 2, ФИО[2], "");
	
	Возврат ?(Не ПустаяСтрока(Фамилия), 
	          ?(Не ПустаяСтрока(Имя), " " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество, 1) + ".", ""), "") + Фамилия,
	          "");
КонецФункции

&НаСервере
Функция ПолучитьОперациюСканераШтрихкода(ИдентификаторКлиента) Экспорт
	Операция = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкаОперацииСканераШтрихкода", ИдентификаторКлиента);
	Возврат Операция;		
КонецФункции

// Возвращает в зависимости от даты количество разрядов для округления
&НаСервере
Функция ЗнакОкр(Дата) Экспорт
	Если Дата < Дата(2016, 7, 1) Тогда
		Возврат 0;
	Иначе	
	    Возврат 2;
	КонецЕсли; 
КонецФункции // ЗнакОкр()

&НаСервере
Функция ПолучитьНашГород(СтруктураНашихРеквизитов = "") Экспорт
	Город = "";
	
	ГородБазы = мРазное.ПолучитьГородБазы();
	Если ГородБазы = "Брест" Тогда
		// Город получаем из подразделения исполнителя
		Город = мРазное.ПолучитьГородПодразделения();
	
	ИначеЕсли ГородБазы = "Минск" Тогда
		Если СтруктураНашихРеквизитов.Свойство("НашГород") Тогда
			Город = СтруктураНашихРеквизитов.НашГород;
		Иначе	
			Город = мРазное.ПолучитьГородБазы();
		КонецЕсли; 
		
	ИначеЕсли ГородБазы = "Прилуки" Тогда
		Если СтруктураНашихРеквизитов.Свойство("НашГород") Тогда
			Город = СтруктураНашихРеквизитов.НашГород;
		Иначе	
			Город = ГородБазы;
		КонецЕсли; 
		
	ИначеЕсли ГородБазы = "Гродно" Тогда
		Город = мРазное.ПолучитьГородБазы();
	КонецЕсли; 
	
	Возврат Город;
КонецФункции // ПолучитьНашГород()

&НаСервере
Функция ПолучитьИспользоватьОтборПоПодразделениям() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.м_ИспользоватьОтборПоПодразделениям.Получить();
	
КонецФункции	

Функция ЭтоТестирование() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ЭтоТестирование = Константы.мТестирование.Получить();
	Возврат ЭтоТестирование;	

КонецФункции 
 