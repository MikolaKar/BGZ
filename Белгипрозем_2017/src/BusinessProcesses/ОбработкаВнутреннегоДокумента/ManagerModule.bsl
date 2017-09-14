
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьОбзорПроцесса(HTMLТекст, Процесс) Экспорт
	
	Цвет_ЗакрытыеНеактуальныеЗаписи = ОбзорПроцессовВызовСервера.Цвет_ЗакрытыеНеактуальныеЗаписи();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбработкаВнутреннегоДокумента.ШаблонСогласования КАК ШаблонДействия,
		|	ОбработкаВнутреннегоДокумента.Ссылка КАК РодительскийПроцесс,
		|	1 КАК Порядок
		|ПОМЕСТИТЬ ШаблоныПроцессы
		|ИЗ
		|	БизнесПроцесс.ОбработкаВнутреннегоДокумента КАК ОбработкаВнутреннегоДокумента
		|ГДЕ
		|	ОбработкаВнутреннегоДокумента.Ссылка = &РодительскийПроцесс
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОбработкаВнутреннегоДокумента.ШаблонУтверждения,
		|	ОбработкаВнутреннегоДокумента.Ссылка,
		|	2
		|ИЗ
		|	БизнесПроцесс.ОбработкаВнутреннегоДокумента КАК ОбработкаВнутреннегоДокумента
		|ГДЕ
		|	ОбработкаВнутреннегоДокумента.Ссылка = &РодительскийПроцесс
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОбработкаВнутреннегоДокумента.ШаблонРегистрации,
		|	ОбработкаВнутреннегоДокумента.Ссылка,
		|	3
		|ИЗ
		|	БизнесПроцесс.ОбработкаВнутреннегоДокумента КАК ОбработкаВнутреннегоДокумента
		|ГДЕ
		|	ОбработкаВнутреннегоДокумента.Ссылка = &РодительскийПроцесс
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОбработкаВнутреннегоДокумента.ШаблонРассмотрения,
		|	ОбработкаВнутреннегоДокумента.Ссылка,
		|	4
		|ИЗ
		|	БизнесПроцесс.ОбработкаВнутреннегоДокумента КАК ОбработкаВнутреннегоДокумента
		|ГДЕ
		|	ОбработкаВнутреннегоДокумента.Ссылка = &РодительскийПроцесс
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОбработкаВнутреннегоДокумента.ШаблонИсполненияОзнакомления,
		|	ОбработкаВнутреннегоДокумента.Ссылка,
		|	5
		|ИЗ
		|	БизнесПроцесс.ОбработкаВнутреннегоДокумента КАК ОбработкаВнутреннегоДокумента
		|ГДЕ
		|	ОбработкаВнутреннегоДокумента.Ссылка = &РодительскийПроцесс
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОбработкаВнутреннегоДокумента.ШаблонПоручения,
		|	ОбработкаВнутреннегоДокумента.Ссылка,
		|	6
		|ИЗ
		|	БизнесПроцесс.ОбработкаВнутреннегоДокумента КАК ОбработкаВнутреннегоДокумента
		|ГДЕ
		|	ОбработкаВнутреннегоДокумента.Ссылка = &РодительскийПроцесс
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ШаблоныПроцессы.ШаблонДействия,
		|	ДочерниеБизнесПроцессы.ДочернийПроцесс КАК Действие,
		|	ДочерниеБизнесПроцессы.ДочернийПроцесс.Завершен КАК Завершено,
		|	ШаблоныПроцессы.Порядок КАК Порядок
		|ИЗ
		|	ШаблоныПроцессы КАК ШаблоныПроцессы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДочерниеБизнесПроцессы КАК ДочерниеБизнесПроцессы
		|		ПО ШаблоныПроцессы.ШаблонДействия = ДочерниеБизнесПроцессы.ДочернийПроцесс.Шаблон
		|			И ШаблоныПроцессы.РодительскийПроцесс = ДочерниеБизнесПроцессы.РодительскийПроцесс
		|ГДЕ
		|	НЕ ШаблоныПроцессы.ШаблонДействия ЕСТЬ NULL 
		|	И ШаблоныПроцессы.ШаблонДействия <> НЕОПРЕДЕЛЕНО
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок";
	Запрос.УстановитьПараметр("РодительскийПроцесс", Процесс);
	
	УстановитьПривилегированныйРежим(Истина);
	ДействияПроцесса = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбратныйИндекс = ДействияПроцесса.Количество() - 1;
	Пока ОбратныйИндекс >= 0 Цикл
		Если ДействияПроцесса[ОбратныйИндекс].ШаблонДействия.Пустая() Тогда
			ДействияПроцесса.Удалить(ДействияПроцесса[ОбратныйИндекс]);
		КонецЕсли;
		ОбратныйИндекс = ОбратныйИндекс - 1;
	КонецЦикла;
	
	Если ДействияПроцесса.Количество() > 0 Тогда
		
		HTMLТекст = HTMLТекст + "<p>";
		
		HTMLТекст = HTMLТекст + "<table class=""frame"">";
		
		//Формирование заголовка таблицы
		HTMLТекст = HTMLТекст + "<tr>";
		
		HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"">";
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Действие'"));
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "</tr>";
		
		Для Каждого СтрДействие Из ДействияПроцесса Цикл
			
			Если ЗначениеЗаполнено(СтрДействие.Действие) Тогда
				Действие = СтрДействие.Действие;
			Иначе
				Действие = СтрДействие.ШаблонДействия;
			КонецЕсли;
			
			ЦветТекста = "";
			Если СтрДействие.Завершено = Истина
				Или Не ЗначениеЗаполнено(СтрДействие.Действие) Тогда
				
				HTMLТекст = HTMLТекст + "<FONT color=""" + Цвет_ЗакрытыеНеактуальныеЗаписи + """>";
				ЦветТекста = Цвет_ЗакрытыеНеактуальныеЗаписи;
			КонецЕсли;
			
			HTMLТекст = HTMLТекст + "<tr>";
			HTMLТекст = HTMLТекст + "<td class=""frame"">";
			ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, Действие, ЦветТекста);
			HTMLТекст = HTMLТекст + "</td>";
			HTMLТекст = HTMLТекст + "</tr>";
			
		КонецЦикла;
		
		HTMLТекст = HTMLТекст + "</table>";
		
		// Формирование подписей под таблицей
		HTMLТекст = HTMLТекст + "<table cellpadding=""0"">";
		HTMLТекст = HTMLТекст + "<tr>";
		
		HTMLТекст = HTMLТекст + "<td align=""right"">";
		HTMLТекст = HTMLТекст + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<A href=v8doc:%1>%2</A>",
			"Подзадачи_" + Процесс.УникальныйИдентификатор() + "_ОбработкаВнутреннегоДокумента",
			НСтр("ru = 'Все задачи'"));
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "</tr>";
		HTMLТекст = HTMLТекст + "</table>";
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// УправлениеДоступом

// Возвращает Истина, указывая тем самым что этот объект сам заполняет права 
// доступа для файлов, владельцем которых является
Функция ЕстьМетодЗаполнитьПраваДоступаДляФайлов() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет параметр ПраваДоступа правами доступа к файлам, владельцем 
// которых является указанный Процесс
//
Процедура ЗаполнитьПраваДоступаДляФайлов(Процесс, ПраваДоступа) Экспорт
	
	БизнесПроцессыИЗадачиСервер.ЗаполнитьПраваДоступаДляФайловБизнесПроцессов(Процесс, ПраваДоступа);
	
КонецПроцедуры

// Возвращает признак наличия метода ДобавитьУчастниковВТаблицу у менеджера объекта
//
Функция ЕстьМетодДобавитьУчастниковВТаблицу() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Конец УправлениеДоступом

// Получить структуру с описанием формы выполнения задачи.
// Вызывается при открытии формы выполнения задачи.
//
// Параметры
//   ЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – задача 
//   ТочкаМаршрутаСсылка – точка маршрута 
//
// Возвращаемое значение:
//   Структура   – структуру с описанием формы выполнения задачи.
//                 Ключ "ИмяФормы" содержит имя формы, передаваемое в метод контекста ОткрытьФорму(). 
//                 Ключ "ПараметрыФормы" содержит параметры формы. 
//
Функция ФормаВыполненияЗадачи(ЗадачаСсылка, ТочкаМаршрутаСсылка) Экспорт
	
	ИмяФормы = "Задача.ЗадачаИсполнителя.Форма.ФормаВедущейЗадачи";
	
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыФормы", Новый Структура("Ключ", ЗадачаСсылка));
	Результат.Вставить("ИмяФормы", ИмяФормы);
	Возврат Результат;	
	
КонецФункции

Функция ПроверитьШаблон(СтруктураРеквизитов) Экспорт
	
	Ошибки = Новый СписокЗначений;
	
	Если Не ЗначениеЗаполнено(СтруктураРеквизитов["ШаблонСогласования"]) 
	   И Не ЗначениеЗаполнено(СтруктураРеквизитов["ШаблонУтверждения"]) 
	   И Не ЗначениеЗаполнено(СтруктураРеквизитов["ШаблонРегистрации"])
	   И Не ЗначениеЗаполнено(СтруктураРеквизитов["ШаблонРассмотрения"])
	   И Не ЗначениеЗаполнено(СтруктураРеквизитов["ШаблонИсполненияОзнакомления"])
	   И Не ЗначениеЗаполнено(СтруктураРеквизитов["ШаблонПоручения"]) Тогда
	   
		Ошибки.Добавить("", НСтр("ru = 'Не указано ни одного шаблона подчиненных процессов'"));
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураРеквизитов["ШаблонРассмотрения"])
	   И ЗначениеЗаполнено(СтруктураРеквизитов["ШаблонИсполненияОзнакомления"]) Тогда 
		Ошибки.Добавить("ШаблонИсполненияОзнакомления", НСтр("ru = 'Не требуется указывать шаблон исполнения (ознакомления), так как заполнен шаблон рассмотрения'"));
	КонецЕсли;
	
	Возврат Ошибки;
	
КонецФункции	

// Возвращает массив пользователей переданного бизнес-процесса,
// которые должны иметь иметь права на другие бизнес-процессы, 
// для которых данный бизнес-процесс является ведущим
Функция ПользователиВедущегоБизнесПроцесса(ВедущийБизнесПроцесс) Экспорт
	
	МассивПользователей = Новый Массив;
	Реквизиты = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ВедущийБизнесПроцесс, "Автор");
	Если ЗначениеЗаполнено(Реквизиты.Автор) Тогда
		МассивПользователей.Добавить(Реквизиты.Автор);
	КонецЕсли;
	
	Возврат МассивПользователей;
	
КонецФункции

// Возвращает тип шаблона бизнес-процесса, соответствующего данному процессу
Функция ТипШаблона() Экспорт
	
	Возврат "Справочник.ШаблоныСоставныхБизнесПроцессов";
	
КонецФункции

// Показывает, может ли процесс запускаться через привычные интерфейсы
Функция МожетЗапускатьсяИнтерактивно() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает текстовое описание назначения процесса
Функция ПолучитьОписаниеПроцесса() Экспорт
	
	Возврат НСтр("ru = 'Описывает процедуру обработки внутреннего документа по заранее определенным правилам.'");
	
КонецФункции

// Показывает, может ли процесс использоваться в качестве части комплексного процесса
Функция МожетИспользоватьсяВКомплексномПроцессе() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает текстовое представление срока выполнения процесса
Функция ПолучитьСтроковоеПредставлениеСрокаВыполнения(Ссылка) Экспорт
		
	Возврат НСтр("ru = 'Определяется настройками действия'");
	
КонецФункции

// Проверяет, что процесс завершился удачно
Функция ПроцессЗавершилсяУдачно(Ссылка) Экспорт
	
	Результат = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Завершен");
	Если Результат Тогда
		ЗадачиПроцесса = РаботаСБизнесПроцессами.ПолучитьМассивЗадачПоБизнесПроцессу(Ссылка, Истина);
		Для Каждого Задача Из ЗадачиПроцесса Цикл
			ПроцессыПоЗадаче = РаботаСБизнесПроцессами.ПолучитьПодчиненныеЗадачеБизнесПроцессы(Задача.Ссылка, "ВедущаяЗадача", Истина);
			Для Каждого Процесс Из ПроцессыПоЗадаче Цикл
				МенеджерПроцесса = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Процесс);
				Результат = Результат И МенеджерПроцесса.ПроцессЗавершилсяУдачно(Процесс);
				Если НЕ Результат Тогда
					Возврат Ложь;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак наличия метода РезультатВыполненияПроцесса
Функция ЕстьМетодРезультатВыполненияПроцесса() Экспорт
	Возврат Истина;
КонецФункции

// Возвращает результат выполнения - значение перечисления ВариантыВыполненияПроцессовИЗадач
Функция РезультатВыполненияПроцесса(Ссылка) Экспорт
	
	ЗавершилсяУдачно = ПроцессЗавершилсяУдачно(Ссылка);
	
	Если ЗавершилсяУдачно Тогда
		Возврат Перечисления.ВариантыВыполненияПроцессовИЗадач.Положительно;
	Иначе
		Возврат Перечисления.ВариантыВыполненияПроцессовИЗадач.Отрицательно;
	КонецЕсли;
	
КонецФункции

// Возвращает массив пользователей переданного бизнес-процесса,
// которые должны иметь иметь права на другие бизнес-процессы, 
// для которых данный бизнес-процесс является ведущим
Функция УчастникиПроцессаВлияющиеНаДоступКПодчиненнымОбъектам(Процесс) Экспорт
	
	МассивПользователей = Новый Массив;
	Реквизиты = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Процесс, "Автор, Проект");
	Если ЗначениеЗаполнено(Реквизиты.Автор) Тогда
		ДанныеУчастника = Новый Структура(
			"Участник, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации");
		ДанныеУчастника.Участник = Реквизиты.Автор;
		ДанныеУчастника.ОсновнойОбъектАдресации = Неопределено;
		ДанныеУчастника.ДополнительныйОбъектАдресации = Неопределено; 
		МассивПользователей.Добавить(ДанныеУчастника);
	КонецЕсли;	
	
	// Добавление руководителя проекта
	Если ЗначениеЗаполнено(Реквизиты.Проект) Тогда
		
		РуководительПроекта = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Реквизиты.Проект, "Руководитель");
		Если ЗначениеЗаполнено(РуководительПроекта) Тогда
			
			ДанныеУчастника = Новый Структура(
				"Участник, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации");
			ДанныеУчастника.Участник = РуководительПроекта;
			ДанныеУчастника.ОсновнойОбъектАдресации = Неопределено;
			ДанныеУчастника.ДополнительныйОбъектАдресации = Неопределено;
			
			МассивПользователей.Добавить(ДанныеУчастника);
			
		КонецЕсли;	
			
	КонецЕсли;	
			
	Возврат МассивПользователей;
	
КонецФункции

// Возвращает массив всех участников процесса 
Функция ВсеУчастникиПроцесса(ПроцессСсылка) Экспорт
	
	ВсеУчастники = Новый Массив;
	
	// Автор
	Автор = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ПроцессСсылка, "Автор");
	ДанныеУчастника = Новый Структура;
	ДанныеУчастника.Вставить("Участник", Автор);
	ДанныеУчастника.Вставить("ОсновнойОбъектАдресации", Неопределено);
	ДанныеУчастника.Вставить("ДополнительныйОбъектАдресации", Неопределено);
	ВсеУчастники.Добавить(ДанныеУчастника);

	Возврат ВсеУчастники;
	
КонецФункции

// Проверяет, подходит ли объект к шаблону бизнес-процесса
Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает массив структур, содержащих описания участников.
// Состав структуры:
//   ТабличнаяЧасть - имя ТЧ, в которой хранятся данные участников. Если данные хранятся в шапке, этот ключ отсутствует.
//   ИмяУчастника - имя реквизита шапки или ТЧ, в котором хранится ссылка на участника.
//   ИмяОсновногоОбъектаАдресации - имя реквизита шапки или ТЧ, в котором хранится ссылка на осн. объект адресации.
//   ИмяДополнительногоОбъектаАдресации - имя реквизита шапки или ТЧ, в котором хранится ссылка на доп. объект адресации.
//   ВлияетНаДоступКПодчиненнымОбъектам - признак, указывающий на необходимость пересчета прав 
//   задач и дочерних процессов при изменении данного участника.
//
Функция ЗаполнитьОписанияУчастников() Экспорт
	
	МассивОписанийУчастников = Новый Массив;
	
	// Автор
	МассивОписанийУчастников.Добавить(Новый Структура(
		"ИмяУчастника, ИмяОсновногоОбъектаАдресации, ИмяДополнительногоОбъектаАдресации,
		|ВлияетНаДоступКПодчиненнымОбъектам", 
		"Автор", Неопределено, Неопределено, 
		Истина));
		
	// Проект
	МассивОписанийУчастников.Добавить(Новый Структура(
		"ИмяУчастника, ИмяОсновногоОбъектаАдресации, ИмяДополнительногоОбъектаАдресации,
		|ВлияетНаДоступКПодчиненнымОбъектам",
		"Проект", Неопределено, Неопределено,
		Ложь));
		
	Возврат МассивОписанийУчастников;
		
КонецФункции

// Возвращает текст компенсации предмета, показываемый пользователю при прерывании
// бизнес-процесса.
//
Функция ТекстКомпенсацииПредмета(ПроцессСсылка) Экспорт
	
	Возврат "";

КонецФункции

// Возвращает доступные для процесса роли предметов
Функция ПолучитьДоступныеРолиПредметов() Экспорт
	
	РолиПредметов = Новый Массив;
	
	РолиПредметов.Добавить(Перечисления.РолиПредметов.Основной);
	РолиПредметов.Добавить(Перечисления.РолиПредметов.Вспомогательный);
	
	Возврат РолиПредметов;
	
КонецФункции

// Возвращает массив доступных типов основных предметов
Функция ПолучитьТипыОсновныхПредметов() Экспорт
	
	ТипыПредметов = Новый Массив;
	
	ТипыПредметов.Добавить(Тип("СправочникСсылка.ВнутренниеДокументы")); 
	
	Возврат ТипыПредметов;
	
КонецФункции

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	БизнесПроцессыИЗадачиСервер.ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	БизнесПроцессыИЗадачиСервер.ОбработкаПолученияПредставления(
		Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

//////////////////////////////////////////////////////////
// Вспомогательные функции для общей формы ЗадачиПоБизнесПроцессу

// Проверяет наличие функции СвойстваЭлементовФормыЗадачиПоБизнесПроцессу в
// текущем модуле.
//
Функция ЕстьМетодСвойстваЭлементовФормыЗадачиПоБизнесПроцессу() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает структуру свойств, для последующей обработки в форме
// ОбщаяФорма.ЗадачиПоБизнесПроцессу
//
// Возвращаемое значение:
//   - Структура - описывает элементы формы и их свойства.
//
Функция СвойстваЭлементовФормыЗадачиПоБизнесПроцессу() Экспорт
	
	НастройкиПолей = Новый Структура;
	
	НомерИтерации = Новый Структура;
	НомерИтерации.Вставить("Видимость", Ложь);
	НастройкиПолей.Вставить("НомерИтерации", НомерИтерации);
	
	Возврат НастройкиПолей;
	
КонецФункции

// Проверяет наличие процедуры ДополнитьТекстЗапросСпискаЗадач в
// текущем модуле.
//
Функция ЕстьМетодДополнитьТекстЗапросСпискаЗадач() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Дополняет текст запроса динамического списка. Процедуры используется
// только для общей формы ЗадачиПоБизнесПроцессу.
Процедура ДополнитьТекстЗапросСпискаЗадач(ТекстЗапроса) Экспорт
	
	// Изменение условия отбора задач
	ТекстУсловияОтбора = "ЗадачаЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс";
	ТекстЗаменыУсловияОтбора = "ДанныеБизнесПроцессов.ВедущаяЗадача.БизнесПроцесс = &БизнесПроцесс";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ТекстУсловияОтбора, ТекстЗаменыУсловияОтбора);
	
	ТекстТаблиц = "
		|	Задача.ЗадачаИсполнителя КАК ЗадачаЗадачаИсполнителя
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФлагиОбъектов КАК ФлагиОбъектов
		|		ПО (ФлагиОбъектов.Объект = ЗадачаЗадачаИсполнителя.Ссылка)
		|			И (ФлагиОбъектов.Пользователь = &ТекущийПользователь)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РезультатыВыполненияПроцессовИЗадач КАК РезультатыВыполненияПроцессовИЗадач
		|		ПО ЗадачаЗадачаИсполнителя.Ссылка = РезультатыВыполненияПроцессовИЗадач.Объект";
	ТекстЗаменыТаблиц = "
		|	Задача.ЗадачаИсполнителя КАК ЗадачаЗадачаИсполнителя
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФлагиОбъектов КАК ФлагиОбъектов
		|		ПО (ФлагиОбъектов.Объект = ЗадачаЗадачаИсполнителя.Ссылка)
		|			И (ФлагиОбъектов.Пользователь = &ТекущийПользователь)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РезультатыВыполненияПроцессовИЗадач КАК РезультатыВыполненияПроцессовИЗадач
		|		ПО ЗадачаЗадачаИсполнителя.Ссылка = РезультатыВыполненияПроцессовИЗадач.Объект
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
		|		ПО ЗадачаЗадачаИсполнителя.БизнесПроцесс = ДанныеБизнесПроцессов.БизнесПроцесс";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ТекстТаблиц, ТекстЗаменыТаблиц);
	
КонецПроцедуры
