// Процедура вызывается из модуля формы документов при обработке оповещения
//
// Параметры:
//   Форма - Управляемая форма, для которой производится обработка оповещения
//   ДокументСсылка - ссылка на документ формы
//   ИмяСобытия - имя обрабатываемого события
//   Параметр - параметр, переданный в обработку оповещения
//   Источник - источник, переданный в обработку оповещения
Процедура ОбработкаОповещенияФормыДокумента(Форма, ДокументСсылка, ИмяСобытия, Параметр, Источник) Экспорт
	Если ИмяСобытия = "ИзмененФлагРучнаяКорректировка" Тогда
		Если ДокументСсылка = Параметр.ДокументСсылка Тогда 
			Форма.Прочитать();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры	

// Процедура активизирует элемент формы.
// Если это - табличная часть, то тогда анализируется,
// может табличная часть на закладке и если так,
// то закладка становится текущей, но табличная часть не активизируется
//
// Параметры:
//  Форма            - Управляемая форма
//  ИмяЭлементаФормы - Строка - имя элемента, который необходимо активизировать
//
Процедура АктивизироватьЭлементФормы(Форма, ИмяЭлементаФормы) Экспорт

	Если НЕ ПустаяСтрока(ИмяЭлементаФормы) Тогда
		НайденныйЭлементФормы = Форма.Элементы.Найти(ИмяЭлементаФормы);
		Если НайденныйЭлементФормы <> Неопределено Тогда
			Если ТипЗнч(НайденныйЭлементФормы) = Тип("ТаблицаФормы") Тогда
				// Для таблицы определить - если она находится на закладке, то не активизировать элемент,
				// а сделать активной страницу, на которой находится эта табличная часть
				Страница = НайденныйЭлементФормы.Родитель;
				Если (Страница <> Неопределено) И (Страница.Вид = ВидГруппыФормы.Страница) Тогда
					// Определим владельца этой страницы и активизируем эту страницу
					ПанельСтраниц = Страница.Родитель;
					Если (ПанельСтраниц <> Неопределено) И (ПанельСтраниц.Вид = ВидГруппыФормы.Страницы) Тогда
						ПанельСтраниц.ТекущаяСтраница = Страница;
					Иначе
						Форма.ТекущийЭлемент = НайденныйЭлементФормы;
					КонецЕсли;
				Иначе
					Форма.ТекущийЭлемент = НайденныйЭлементФормы;
				КонецЕсли;
			Иначе
				Форма.ТекущийЭлемент = НайденныйЭлементФормы;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура показывает переданное сообщение в отдельной форме
// также в форме может быть отражена гиперссылка
//
// Параметры:
//  ПараметрыСообщения - Структура
//     - поля структуры:
//        - Заголовок            - Строка - текст заголовка формы
//        - Сообщение            - Строка - текст сообщения
//        - ГиперссылкаТекст     - Строка - (необязательный) представление объекта
//        - ГиперссылкаНавигация - Строка - (необязательный) навигационная ссылка объекта
//        - ГиперссылкаИмяФормы  - Строка - (необязательный) имя формы по гиперссылке
//        - ГиперссылкаПараметры - Строка - (необязательный) параметры формы по гиперссылке
//        - КлючОбъектаБольшеНеПоказывать  - Строка - (необязательный) ключ объекта для хранения значения "Больше не показывать"
//        - КлючНастроекБольшеНеПоказывать - Строка - (необязательный) ключ настроек для хранения значения "Больше не показывать"
//
Процедура ПоказатьСообщениеВФорме(ПараметрыСообщения, РежимОткрытия = "", ВладелецФормы = Неопределено) Экспорт
	
	Если РежимОткрытия = "Модально" Тогда
		ОткрытьФормуМодально("ОбщаяФорма.ФормаСообщение", ПараметрыСообщения, ВладелецФормы);
	Иначе
		ОткрытьФорму("ОбщаяФорма.ФормаСообщение", ПараметрыСообщения, ВладелецФормы);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьПредупреждениеОбИзменениях(КлючНастроек, ВладелецФормы = Неопределено, 
			НастройкаПредупреждений = Неопределено) Экспорт
	
	// Проверим на клиенте, нужно ли показывать предупреждения
	Если ТипЗнч(НастройкаПредупреждений) = Тип("Структура") Тогда
		Если НастройкаПредупреждений.Свойство(КлючНастроек) Тогда
			Если НастройкаПредупреждений[КлючНастроек] = Ложь Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
			
	ПараметрыСообщения	= Новый Структура;
	ПараметрыСообщения.Вставить("КлючНастроек",КлючНастроек);
	
	ОткрытьФорму("Обработка.ПредупреждениеОбИзменениях.Форма", ПараметрыСообщения, ВладелецФормы);
	
КонецПроцедуры

// Функция возвращает Истина, если при изменении даты документа требуется перечитать 
// настройки из базы данных на сервере.
//
Функция ТребуетсяВызовСервераПриИзмененииДатыДокумента(НоваяДата, ПредыдущаяДата,
			ВалютаДокумента = Неопределено, ВалютаРегламентированногоУчета = Неопределено) Экспорт

	Результат = Ложь;
	
	Если НачалоДня(НоваяДата) = НачалоДня(ПредыдущаяДата) Тогда
		// Ничего не изменилось либо изменилось только время, от которого ничего не зависит
		Возврат Ложь;
	КонецЕсли;
	
	Если НачалоМесяца(НоваяДата) <> НачалоМесяца(ПредыдущаяДата) Тогда
		// Учетная политика задается с периодичностью до месяца,
		// поэтому в пределах месяца изменения даты не учитываем.
		Результат = Истина;
	КонецЕсли;
	
	Если НЕ Результат
		И ЗначениеЗаполнено(ВалютаДокумента) 
		И ЗначениеЗаполнено(ВалютаРегламентированногоУчета) Тогда
		
		Если ВалютаРегламентированногоУчета <> ВалютаДокумента Тогда
			// Для валютных документов необходимо получение курсов валют на новую дату
			Результат = Истина;
		КонецЕсли;

	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет, надо ли записать данные формы до выполнения над ними каких-либо команд.
Функция НадоЗаписать(Форма) Экспорт
	
	Возврат НЕ ЗначениеЗаполнено(Форма.Параметры.Ключ) ИЛИ Форма.Модифицированность;
	
КонецФункции
////////////////////////////////////////////////////////////////////////////////
// ОБОЗРЕВАТЕЛЬ
//

Процедура ОткрытьВебСтраницу(Знач АдресСтраницы, Знач Заголовок = "") Экспорт
	
	ОткрытьФорму("ОбщаяФорма.Обозреватель", 
		Новый Структура("АдресСтраницы,Заголовок", АдресСтраницы, Заголовок));

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС ПОЛЯ ВЫБОРА ОРГАНИЗАЦИИ С ОБОСОБЛЕННЫМИ ПОДРАЗДЕЛЕНИЯМИ
//

Процедура ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация, Организация, ВключатьОбособленныеПодразделения) Экспорт
	
	Если Не ЗначениеЗаполнено(ПолеОрганизация) Тогда 
		Организация                       = Неопределено;
		ВключатьОбособленныеПодразделения = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, СоответствиеОрганизаций,
	Организация, ВключатьОбособленныеПодразделения) Экспорт 
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Значение = СоответствиеОрганизаций[ВыбранноеЗначение];
		Если ТипЗнч(Значение) = Тип("Структура") Тогда 
			Организация = Значение.Организация;
			ВключатьОбособленныеПодразделения = Значение.ВключатьОбособленныеПодразделения;
		Иначе
			Организация = Неопределено;
			ВключатьОбособленныеПодразделения = Неопределено;
		КонецЕсли;
	Иначе
		Организация = Неопределено;
		ВключатьОбособленныеПодразделения = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка, ПолеОрганизация, СоответствиеОрганизаций) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ПолеОрганизация) Тогда
		Если СоответствиеОрганизаций.Свойство(ПолеОрганизация) Тогда
			Значение = СоответствиеОрганизаций[ПолеОрганизация];
			Если ТипЗнч(Значение) = Тип("Структура") Тогда				
				ОткрытьЗначение(Значение.Организация);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проверка основного интерфейса
//
////////////////////////////////////////////////////////////////////////////////
// Проверка наличия доступных организаций для пользователя с ограниченными правами
////////////////////////////////////////////////////////////////////////////////
// Процедуры для команд печати
Функция ПолучитьЗаголовокПечатнойФормы(ПараметрКоманды) Экспорт 
	
	Если Тип(ПараметрКоманды) = Тип("Массив") И ПараметрКоманды.Количество() = 1 Тогда 
		Возврат Новый Структура("ЗаголовокФормы", ПараметрКоманды[0]);
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции
