#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей Процесса
//
// Возвращаемое значение:
//   Структура
//     Наименование
//     Описание
//     СрокИсполнения
//     Важность
//     Автор
//     Исполнители
//     Предметы
//
Функция ПолучитьСтруктуруПроцесса() Экспорт
	
	ПараметрыПроцесса = Новый Структура;
	ПараметрыПроцесса.Вставить("Наименование");
	ПараметрыПроцесса.Вставить("Описание");
	ПараметрыПроцесса.Вставить("СрокИсполнения");
	ПараметрыПроцесса.Вставить("Важность");
	ПараметрыПроцесса.Вставить("Автор");
	
	Исполнители = Новый ТаблицаЗначений;
	Исполнители.Колонки.Добавить("Исполнитель");
	Исполнители.Колонки.Добавить("ОсновнойОбъектАдресации");
	Исполнители.Колонки.Добавить("ДополнительныйОбъектАдресации");
	ПараметрыПроцесса.Вставить("Исполнители", Исполнители);
	
	Предметы = Новый ТаблицаЗначений;
	Предметы.Колонки.Добавить("РольПредмета");
	Предметы.Колонки.Добавить("Предмет");
	
	ПараметрыПроцесса.Вставить("Предметы", Предметы);
	
	Возврат ПараметрыПроцесса;
	
КонецФункции

// Создает, записывает, при необходимости стартует бизнес процесс.
//
// Параметры:
//   СтруктураПроцесса - Структура - структура полей процесса.
//
Процедура СоздатьПроцесс(СтруктураПроцесса, ЗапуститьПроцесс = Ложь) Экспорт
	
	НачатьТранзакцию();
	
	НовыйПроцесс = СоздатьБизнесПроцесс();
	НовыйПроцесс.Заполнить(Новый Структура);
	ЗаполнитьЗначенияСвойств(НовыйПроцесс, СтруктураПроцесса,, "Предметы, Исполнители");
	
	Предметы = Новый ТаблицаЗначений;
	Предметы.Колонки.Добавить("РольПредмета");
	Предметы.Колонки.Добавить("ИмяПредмета");
	Предметы.Колонки.Добавить("ИмяПредметаОснование");
	Предметы.Колонки.Добавить("Предмет");
	Предметы.Колонки.Добавить("ШаблонОснование");
	Предметы.Колонки.Добавить("ТипОпределен");
	
	Для Каждого Предмет Из СтруктураПроцесса.Предметы Цикл
		
		НоваяСтрокаПредмет = Предметы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаПредмет, Предмет);
		НоваяСтрокаПредмет.ИмяПредмета = МультипредметностьВызовСервера.
			ПолучитьСсылкуНаИмяПредметаПоСсылкеНаПредмет(НоваяСтрокаПредмет.Предмет);
		
	КонецЦикла;
	
	Мультипредметность.ПередатьПредметыПроцессу(НовыйПроцесс, Предметы);
	
	Для Каждого Исполнитель Из СтруктураПроцесса.Исполнители Цикл
		
		НоваяСтрокаИсполнителей = НовыйПроцесс.Исполнители.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаИсполнителей, Исполнитель);
		
	КонецЦикла;
	
	НовыйПроцесс.Записать();
	
	Если ЗапуститьПроцесс Тогда
		
		Если НЕ НовыйПроцесс.ПроверитьЗаполнение() Тогда
			
			ВызватьИсключение НСтр("ru = 'Не удалось запустить процесс.'");
			
		КонецЕсли;
		
		НовыйПроцесс.Старт();
		
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ЗаполнитьОбзорПроцесса(HTMLТекст, Процесс) Экспорт
	
	РеквизитыПроцесса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Процесс,
		"СрокИсполнения,
		|Исполнители");
		
	СрокИсполнения = РеквизитыПроцесса.СрокИсполнения;
	Исполнители = РеквизитыПроцесса.Исполнители.Выгрузить();
	
	Цвет_ЗакрытыеНеактуальныеЗаписи = ОбзорПроцессовВызовСервера.Цвет_ЗакрытыеНеактуальныеЗаписи();
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
		ФорматСрока = "ДФ='dd.MM.yyyy HH:mm'";
	Иначе
		ФорматСрока = "ДФ='dd.MM.yyyy'";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СрокИсполнения) Тогда
		HTMLТекст = HTMLТекст + "<p>";
		ОбзорОбъектовКлиентСервер.ДобавитьРеквизит(
			HTMLТекст, НСтр("ru = 'Срок:'"), Формат(СрокИсполнения, ФорматСрока), "");
	КонецЕсли;
	
	// Формирование строк таблицы
	Если Исполнители.Количество() > 0 Тогда
		
		HTMLТекст = HTMLТекст + "<p>";
		
		HTMLТекст = HTMLТекст + "<table class=""frame"">";
		
		//Формирование заголовка таблицы
		HTMLТекст = HTMLТекст + "<tr>";
		
		HTMLТекст = HTMLТекст + "<td align=""center"" class=""frame"">";
		ОбзорОбъектовКлиентСервер.ДобавитьПодпись(HTMLТекст, НСтр("ru = 'Исполнитель'"));
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "</tr>";
		
		//Заполнение таблицы исполнителями
		Для Каждого Исполнитель Из Исполнители Цикл
			HTMLТекст = HTMLТекст + "<tr>";
			
			HTMLТекст = HTMLТекст + "<td class=""frame"">";
			
			ЦветТекста = "";
			Если Исполнитель.Пройден
				Или Не ЗначениеЗаполнено(Исполнитель.ЗадачаИсполнителя) Тогда
				
				HTMLТекст = HTMLТекст + "<FONT color=""" + Цвет_ЗакрытыеНеактуальныеЗаписи + """>";
				ЦветТекста = Цвет_ЗакрытыеНеактуальныеЗаписи;
			КонецЕсли;
			
			ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, Исполнитель.Исполнитель, ЦветТекста);
			
			Если ЗначениеЗаполнено(Исполнитель.ОсновнойОбъектАдресации) Тогда
				HTMLТекст = HTMLТекст + ", ";
				ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, Исполнитель.ОсновнойОбъектАдресации, ЦветТекста);
			КонецЕсли;
			Если ЗначениеЗаполнено(Исполнитель.ДополнительныйОбъектАдресации) Тогда
				HTMLТекст = HTMLТекст + ", ";
				ОбзорОбъектовКлиентСервер.ДобавитьЗначение(HTMLТекст, Исполнитель.ДополнительныйОбъектАдресации, ЦветТекста);
			КонецЕсли;
			
			Если Исполнитель.Пройден 
				Или Не ЗначениеЗаполнено(Исполнитель.ЗадачаИсполнителя) Тогда
				
				HTMLТекст = HTMLТекст + "</FONT>";
			КонецЕсли;
			
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
			"Подзадачи_" + Процесс.УникальныйИдентификатор() + "_Ознакомление",
			НСтр("ru = 'Все задачи'"));
		HTMLТекст = HTMLТекст + "</td>";
		
		HTMLТекст = HTMLТекст + "</tr>";
		HTMLТекст = HTMLТекст + "</table>";
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	БизнесПроцессыИЗадачиСервер.ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	БизнесПроцессыИЗадачиСервер.ОбработкаПолученияПредставления(
		Данные, Представление, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_УправлениеДоступом

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ДляОбщейФормы_ЗадачиПоБизнесПроцессу

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
	
	Наименование = Новый Структура;
	Наименование.Вставить("Видимость", Ложь);
	НастройкиПолей.Вставить("Наименование", Наименование);
	
	Возврат НастройкиПолей;
	
КонецФункции

// Проверяет наличие процедуры ДополнитьТекстЗапросСпискаЗадач в
// текущем модуле.
//
Функция ЕстьМетодДополнитьТекстЗапросСпискаЗадач() Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

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
	
	Если ТочкаМаршрутаСсылка = БизнесПроцессы.Ознакомление.ТочкиМаршрута.Ознакомиться Тогда 
		ИмяФормы = "БизнесПроцесс.Ознакомление.Форма.ФормаЗадачиИсполнителя";
		
	КонецЕсли;	
		
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыФормы", Новый Структура("Ключ", ЗадачаСсылка));
	Результат.Вставить("ИмяФормы", ИмяФормы);
	Возврат Результат;	
	
КонецФункции

// Вызывается при выполнении задачи из формы списка.
//
// Параметры
//   ЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – задача 
//   ТочкаМаршрутаСсылка – точка маршрута 
//
Процедура ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка, БизнесПроцессСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	
КонецПроцедуры	

// Вызывается при выполнении задачи из формы списка Мои задачи.
//
// Параметры
//   ЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – задача 
//   ТочкаМаршрутаСсылка – точка маршрута 
//
Процедура ОбработкаВыполнения(ЗадачаСсылка, БизнесПроцессСсылка, ТочкаМаршрутаБизнесПроцесса, ПараметрыВыполнения) Экспорт
	
КонецПроцедуры

// Вызывается при перенаправлении задачи.
//
// Параметры
//   ЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – перенаправляемая задача.
//   НоваяЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Реквизиты = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ЗадачаСсылка, 
		"ТочкаМаршрута, БизнесПроцесс, Исполнитель, РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации");
		
	ТочкаМаршрута = Реквизиты.ТочкаМаршрута;
	БизнесПроцесс = Реквизиты.БизнесПроцесс;
	
	Если ТочкаМаршрута = ТочкиМаршрута.Ознакомиться Тогда 
	 
	    БизнесПроцессОбъект = БизнесПроцесс.ПолучитьОбъект();
		БизнесПроцессОбъект.Заблокировать();
		
		СтруктураПоиска = Новый Структура("ЗадачаИсполнителя", ЗадачаСсылка);
		НайденныеСтроки = БизнесПроцессОбъект.Исполнители.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСтроки.Количество() > 0 Тогда 
			НайденнаяСтрока = НайденныеСтроки[0];
			
			Если ЗначениеЗаполнено(Реквизиты.Исполнитель) Тогда 
				НайденнаяСтрока.Исполнитель = Реквизиты.Исполнитель;
				НайденнаяСтрока.ОсновнойОбъектАдресации = Неопределено;
				НайденнаяСтрока.ДополнительныйОбъектАдресации = Неопределено;
			Иначе
				НайденнаяСтрока.Исполнитель = Реквизиты.РольИсполнителя;
				НайденнаяСтрока.ОсновнойОбъектАдресации = Реквизиты.ОсновнойОбъектАдресации;
				НайденнаяСтрока.ДополнительныйОбъектАдресации = Реквизиты.ДополнительныйОбъектАдресации;
			КонецЕсли;
			
			// проверка дублей
			Исполнители = БизнесПроцессОбъект.Исполнители.Выгрузить();
			Исполнители.Свернуть("Исполнитель,ОсновнойОбъектАдресации,ДополнительныйОбъектАдресации");
			Если Исполнители.Количество() < БизнесПроцессОбъект.Исполнители.Количество() Тогда 
				ВызватьИсключение  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Исполнитель ""%1"" уже находится в списке исполнителей процесса!'"),
					Строка(Реквизиты.Исполнитель));
			КонецЕсли;	
			
			БизнесПроцессОбъект.Записать();
		КонецЕсли;	
	 
 	КонецЕсли;
	
КонецПроцедуры

// Возвращает признак наличия метода объекта ПриПеренаправленииЗадачи
// 
Функция ЕстьМетодПриПеренаправленииЗадачи() Экспорт
	Возврат Истина;
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

// Возвращает признак наличия метода ДобавитьУчастниковВТаблицу у менеджера объекта
//
Функция ЕстьМетодДобавитьУчастниковВТаблицу() Экспорт
	Возврат Истина;
КонецФункции

// Добавляет участников бизнес-процесса в переданную таблицу
//
Процедура ДобавитьУчастниковВТаблицу(ТаблицаНабора, БизнесПроцесс) Экспорт
	
	Если ТипЗнч(БизнесПроцесс) = Тип("БизнесПроцессСсылка.Ознакомление") Тогда
		
		БизнесПроцессРеквизиты = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(БизнесПроцесс, "Автор");
		
	Иначе
		
		БизнесПроцессРеквизиты = Новый Структура;
		БизнесПроцессРеквизиты.Вставить(
			"Автор", Неопределено);
		
		ЗаполнитьЗначенияСвойств(БизнесПроцессРеквизиты, БизнесПроцесс);
		
	КонецЕсли;
	
	РаботаСРабочимиГруппами.ДобавитьУчастникаВТаблицуНабора(ТаблицаНабора, БизнесПроцессРеквизиты.Автор);
	
	РаботаСРабочимиГруппами.ДобавитьУчастниковПоТабличнойЧастиБизнесПроцесса(ТаблицаНабора, БизнесПроцесс, "Исполнители");
	
	// Добавление контролеров
	Контроль.ДобавитьКонтролеровВТаблицу(ТаблицаНабора, БизнесПроцесс.Ссылка);
	
КонецПроцедуры

// Возвращает тип шаблона бизнес-процесса, соответствующего данному процессу
Функция ТипШаблона() Экспорт
	
	Возврат "Справочник.ШаблоныОзнакомления";
	
КонецФункции

// Показывает, может ли процесс запускаться через привычные интерфейсы
Функция МожетЗапускатьсяИнтерактивно() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает текстовое описание назначения процесса
Функция ПолучитьОписаниеПроцесса() Экспорт
	
	Возврат НСтр("ru = 'Используется для отправки материалов одному или нескольким коллегам на ознакомление, при этом автор не получит результата ознакомления.
		|
		|Если автору необходимо получить результат ознакомления, рекомендуется использовать процесс ""Исполнение"" или ""Рассмотрение"".'");
	
КонецФункции

// Показывает, может ли процесс использоваться в качестве части комплексного процесса
Функция МожетИспользоватьсяВКомплексномПроцессе() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает текстовое представление срока выполнения процесса
Функция ПолучитьСтроковоеПредставлениеСрокаВыполнения(Ссылка) Экспорт
	
	ИспользоватьВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	СрокИсполнения = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "СрокИсполнения");
	
	СтрокаФормата = "ДФ=dd.MM.yyyy";
	Если ИспользоватьВремяВСрокахЗадач Тогда
		СтрокаФормата = "ДФ='dd.MM.yyyy ЧЧ:мм'";	
	КонецЕсли;
	Если ЗначениеЗаполнено(СрокИсполнения) Тогда
		Возврат Формат(СрокИсполнения, СтрокаФормата);
	КонецЕсли;
	
	Возврат НСтр("ru = 'Срок не указан'");
	
КонецФункции

// Возвращает флаг, сигнализирующий о том, возможен ли для процессов данного типа
//	автоматический перенос сроков при согласовании заявки на перенос автором (истина),
//	или для переноса срока автору процесса необходимо будет зайти в карточку процесса (ложь)
Функция ВозможноАвтоматическоеИзменениеОбщегоСрока(Ссылка) Экспорт
	
	РеквизитыПроцесса = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Ссылка, "ГлавнаяЗадача, ВедущаяЗадача");
	ПроцессВедущейЗадачи = ОбщегоНазначения.ПолучитьЗначениеРеквизита(РеквизитыПроцесса.ВедущаяЗадача, "БизнесПроцесс");
	ЭтотПроцессВложенВКомплексный = Ложь;
	
	// Если это процесс в рамках комплексного, то изменение его срока должно вестись из карточки процесса вручную.
	Если ТипЗнч(ПроцессВедущейЗадачи) = Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
	
КонецФункции

// Проверяет, что процесс завершился удачно
Функция ПроцессЗавершилсяУдачно(Ссылка) Экспорт
	
	Возврат ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Завершен");
	
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

	// Исполнители
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОзнакомлениеИсполнители.Исполнитель,
		|	ОзнакомлениеИсполнители.ОсновнойОбъектАдресации,
		|	ОзнакомлениеИсполнители.ДополнительныйОбъектАдресации
		|ИЗ
		|	БизнесПроцесс.Ознакомление.Исполнители КАК ОзнакомлениеИсполнители
		|ГДЕ
		|	ОзнакомлениеИсполнители.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", ПроцессСсылка);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();

	Пока Выборка.Следующий() Цикл
		ДанныеУчастника = Новый Структура;
		ДанныеУчастника.Вставить("Участник", Выборка.Исполнитель);
		ДанныеУчастника.Вставить("ОсновнойОбъектАдресации", Выборка.ОсновнойОбъектАдресации);
		ДанныеУчастника.Вставить("ДополнительныйОбъектАдресации", Выборка.ДополнительныйОбъектАдресации);
		ВсеУчастники.Добавить(ДанныеУчастника);
	КонецЦикла;

	Возврат ВсеУчастники;
	
КонецФункции

// Проверяет, подходит ли объект к шаблону бизнес-процесса
Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает признак наличия метода ДополнительныеДанныеПоЗадаче
Функция ЕстьМетодДополнительныеДанныеПоЗадаче() Экспорт
	Возврат Истина;
КонецФункции

// Возвращает структуру дополнительных данных переданной задачи:
//	РезультатВыполнения - результат выполнения задачи
//  ОписаниеСобытия - описание события выполненной задачи для истории
Функция ДополнительныеДанныеПоЗадаче(Задача) Экспорт
	
	СтруктураВозврата = Новый Структура("РезультатВыполнения, ОписаниеСобытияДляИстории");
		
	Если Не Задача.Выполнена Тогда
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	РезультатВыполнения = Неопределено;
	
	ОписаниеСобытияФормат = "%1, %2. ";
	ОписаниеСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						ОписаниеСобытияФормат,
						Формат(Задача.ДатаИсполнения, "ДФ='dd.MM.yyyy HH:mm'"),
						Строка(Задача.Исполнитель));
	
	ТочкаМаршрута = Задача.ТочкаМаршрута;
	ТочкиМаршрутаПроцесса = БизнесПроцессы.Ознакомление.ТочкиМаршрута;
	
	Действие = "";
	ТекстРезультатаВыполнения = Задача.РезультатВыполнения;
	
	Если ТочкаМаршрута = ТочкиМаршрутаПроцесса.Ознакомиться Тогда
		Действие = НСтр("ru = 'Ознакомлен(а)'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Действие) Тогда
		ОписаниеСобытия = ОписаниеСобытия + Действие
						  + ?(ЗначениеЗаполнено(ТекстРезультатаВыполнения), ": " + Символы.ПС, ".")
						  + ТекстРезультатаВыполнения;
	Иначе
		ОписаниеСобытия = "";
	КонецЕсли;
	
	СтруктураВозврата.РезультатВыполнения = РезультатВыполнения;
	СтруктураВозврата.ОписаниеСобытияДляИстории = ОписаниеСобытия;
	
	Возврат СтруктураВозврата;
	
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
	
	// Исполнители
	МассивОписанийУчастников.Добавить(Новый Структура(
		"ТабличнаяЧасть, ИмяУчастника, ИмяОсновногоОбъектаАдресации, ИмяДополнительногоОбъектаАдресации,
		|ВлияетНаДоступКПодчиненнымОбъектам", 
		"Исполнители", "Исполнитель", "ОсновнойОбъектАдресации", "ДополнительныйОбъектАдресации", 
		Ложь));
		
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
	
	Результат = "";
	
	Предметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(ПроцессСсылка, , Истина);

	Если Не ЗначениеЗаполнено(Предметы) Тогда
		Возврат "";
	КонецЕсли;

	ПредметыСИзмененнымСостоянием = Новый Массив();
	
	Для каждого Предмет Из Предметы Цикл
		Если ДелопроизводствоКлиентСервер.ЭтоСсылкаНаДокумент(Предмет) Тогда
			СостоянияДокумента = Делопроизводство.ПолучитьСостоянияДокумента(Предмет, ПроцессСсылка);
			Если ЗначениеЗаполнено(СостоянияДокумента) Тогда
				ПредметыСИзмененнымСостоянием.Добавить(Предмет);
			КонецЕсли;

		КонецЕсли;
	КонецЦикла;
	
	КоличествоИзмененныхПредметов = ПредметыСИзмененнымСостоянием.Количество();
	Если КоличествоИзмененныхПредметов = 0 Тогда
		Возврат "";
	КонецЕсли;

	Если КоличествоИзмененныхПредметов = 1 Тогда
		НаименованиеПредмета = ОбщегоНазначения.ПолучитьЗначениеРеквизита(
			ПредметыСИзмененнымСостоянием[0], 
			"Наименование");
			
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'У документа ""%1"" будет очищено состояние ознакомления.'"),
			НаименованиеПредмета);
	Иначе
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'У документов (%1) будет очищено состояние ознакомления.'"),
			КоличествоИзмененныхПредметов);
	КонецЕсли;

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
	
	ТипыПредметов = Метаданные.БизнесПроцессы.Ознакомление.ТабличныеЧасти.Предметы.Реквизиты.Предмет.Тип.Типы();
	
	Возврат ТипыПредметов;
	
КонецФункции

// Возвращает структуру с вариантами ответов для формирования уведомлений
// с возможностью исполнения задач по почте. Варианты ответов определяются в
// зависимости от точки маршрута.
//
// Параметры:
//	 - ЗадачаСсылка - ЗадачаСсылка.ЗадачаИсполнителя - задача для которой определяются
//					  варинаты ответов.
//	 - БизнесПроцессСсылка - БизнесПроцессСсылка.Ознакомление - бизнес процесс по которому
//							 назначена задача.
//	 - ТочкаМаршрута - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута в которой находится
//					   бизнес-процесс.
//
// Возвращаемые параметры:
//	 - Структура
//		 - СписокВариантовОтветов - СписокЗначений - список значений типа
//									ПеречисленияСсылка.ВариантыВыполненияПроцессовИЗадач,
//									с заполненным представлением; в нем содержатся варианты
//									ответов.
//		 - ИспользоватьКомментарий - Булево - Принимает значение Истина, если для текущей задачи
//									 ввод комментария обязателен.
//
Функция ВариантыОтветовДляВыполненияЗадачиПоПочте(
	ЗадачаСсылка,
	БизнесПроцессСсылка,
	ТочкаМаршрута) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СписокВариантовОтветов", Новый СписокЗначений);
	Результат.Вставить("ИспользоватьКомментарий", Ложь);
	
	Если ТочкаМаршрута = ТочкиМаршрута.Ознакомиться Тогда
		Результат.СписокВариантовОтветов.Добавить(
			Перечисления.ВариантыВыполненияПроцессовИЗадач.Положительно,
			НСтр("ru = 'Ознакомился'"));
		Результат.ИспользоватьКомментарий = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает текущих участников процесса в виде структуры
//
// Параметры:
//   Процесс
//      БизнесПроцессОбъект
//      БизнесПроцессСсылка
//
// Возвращаемое значение:
//   Структура
//
Функция ТекущиеУчастникиПроцесса(Процесс) Экспорт
	
	Участники = Новый Структура(
		"Автор,
		|Исполнители");
		
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Процесс)) Тогда
		РеквизитыПроцессаПоСсылке = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Процесс,
			"Автор, Исполнители");
		ЗаполнитьЗначенияСвойств(Участники, РеквизитыПроцессаПоСсылке,, "Исполнители");
		Участники.Исполнители = РеквизитыПроцессаПоСсылке.Исполнители.Выгрузить();
	Иначе
		ЗаполнитьЗначенияСвойств(Участники, Процесс,, "Исполнители");
		Участники.Исполнители = Процесс.Исполнители.Выгрузить();
	КонецЕсли;
	
	Возврат Участники;
	
КонецФункции

#КонецЕсли
