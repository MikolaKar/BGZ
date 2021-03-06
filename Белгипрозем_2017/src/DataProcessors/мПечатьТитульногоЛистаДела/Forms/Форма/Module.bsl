
&НаКлиенте
Перем Док;

&НаКлиенте
Перем WordApp;

&НаКлиенте
Перем Селекция, Поиск;

&НаКлиенте
Функция СформироватьНастройку(Имя, Значение, ИдентификаторКлиента)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиПечатиДел/" + НаименованиеВидаРаботы +"/"+ВидКорреспондентаСтрокой+"/" + Имя);
	Элемент.Вставить("Настройка", ИдентификаторКлиента);
	Элемент.Вставить("Значение", Значение);
	Возврат Элемент;
	
КонецФункции	

&НаКлиенте
Процедура СохранитьНастройку()
	МассивСтруктур = Новый Массив;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	МассивСтруктур.Добавить (СформироватьНастройку("Подписал1", Подписал1, ИдентификаторКлиента));
	МассивСтруктур.Добавить (СформироватьНастройку("Подписал2", Подписал2, ИдентификаторКлиента));
	Если Элементы.Подписал3.Видимость Тогда
		МассивСтруктур.Добавить (СформироватьНастройку("Подписал3", Подписал3, ИдентификаторКлиента));
	Иначе
		МассивСтруктур.Добавить (СформироватьНастройку("Подписал3", Неопределено, ИдентификаторКлиента));
	КонецЕсли; 	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
КонецПроцедуры // СохранитьНастройку()

&НаСервере
Процедура ВосстановитьНастройку()
	ИдентификаторКлиента = Параметры.ИдентификаторКлиента;
	
	ОбщееИмяНастройки = "НастройкиПечатиДел/" + НаименованиеВидаРаботы + "/" + ВидКорреспондентаСтрокой + "/";
	Подписал1 = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ОбщееИмяНастройки+"Подписал1", ИдентификаторКлиента);
	Подписал2 = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ОбщееИмяНастройки+"Подписал2", ИдентификаторКлиента);
	Подписал3 = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ОбщееИмяНастройки+"Подписал3", ИдентификаторКлиента);
	
КонецПроцедуры // ВосстановитьНастройку()

&НаКлиенте
Процедура ПечатьА4(Команда)
	
	СохранитьНастройку();
	
	ЗаписатьПодписавшегоДело(Подписал1);
	
	ИнициализироватьДокументWord("А4");
	
	ПечатьДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьА3(Команда)
	
	СохранитьНастройку();
	
	ЗаписатьПодписавшегоДело(Подписал1);
	
	ИнициализироватьДокументWord("А3");
	
	ПечатьДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьДокумента()
	
	// Заполнение Листа
	НашеНаименование = ПолучитьНашеНаименование(Дело);
	
	Док.Bookmarks("НашеНаименование").Range.Text = НашеНаименование; 
	Док.Bookmarks("Заголовок").Range.Text = ЗаголовокДела; 
	Док.Bookmarks("Подзаголовок").Range.Text = Подзаголовок; 
	//Док.Bookmarks("Содержание").Range.Text = Содержание;
	Содержание = СокрЛП(Содержание);
	ТекстСодержания = НРЕг(Лев(Содержание, 1))+Сред(Содержание, 2);
	мРазноеКлиент.Заменить(Поиск, "Содержание", ТекстСодержания); 
	мРазноеКлиент.Заменить(Поиск, "НомерДела", ПолучитьНомерДела(Дело));
	
	Должность1 = РаботаСПользователями.ПолучитьДолжность(Подписал1);
	Если ЗначениеЗаполнено(Должность1) Тогда
		Док.Bookmarks("Должность1").Range.Text = ПолучитьНаименованиеДолжности(Должность1); 
	Иначе
		Док.Bookmarks("Должность1").Range.Text = ""; 
	КонецЕсли;
	
	Должность2 = РаботаСПользователями.ПолучитьДолжность(Подписал2);
	Если ЗначениеЗаполнено(Должность2) Тогда
		Док.Bookmarks("Должность2").Range.Text = ПолучитьНаименованиеДолжности(Должность2); 
	Иначе
		Док.Bookmarks("Должность2").Range.Text = ""; 
	КонецЕсли; 

	Док.Bookmarks("Подписал1").Range.Text = мРазное.ИнициалыФамилияПользователя(Подписал1); 
	Док.Bookmarks("Подписал2").Range.Text = мРазное.ИнициалыФамилияПользователя(Подписал2); 
	Если ЗначениеЗаполнено(Подписал3) Тогда
		Должность3 = РаботаСПользователями.ПолучитьДолжность(Подписал3);
		Док.Bookmarks("Должность3").Range.Text = ПолучитьНаименованиеДолжности(Должность3); 
		Док.Bookmarks("Подписал3").Range.Text = мРазное.ИнициалыФамилияПользователя(Подписал3); 
	Иначе
		Док.Bookmarks("Должность3").Range.Text = ""; 
		Док.Bookmarks("Подписал3").Range.Text = ""; 
	КонецЕсли; 
	
	Док.Bookmarks("Город").Range.Text = Город; 
	//Док.Bookmarks("Город").Range.Text = мРазное.ПолучитьГородБазы(); 
	Док.Bookmarks("Год").Range.Text = "2017"; 
	
	//Штрихкод
	ДанныеОШтрихкоде = ШтрихкодированиеСервер.ПолучитьДанныеДляВставкиШтрихкодаВОбъект(Дело, Ложь, Истина);
	Если ДанныеОШтрихкоде <> Неопределено
		И ДанныеОШтрихкоде.Свойство("ДвоичныеДанныеИзображения") Тогда
		
		// Запись картинки штрихкода во временный файл
		ВременныйФайлКартинки = ПолучитьИмяВременногоФайла("png");
		ДанныеОШтрихкоде.ДвоичныеДанныеИзображения.Записать(ВременныйФайлКартинки);
		
		Док.Bookmarks("Штрихкод").Range.Select();
		Селекция = WordApp.Selection; // активная (выделенная) область 
		Рисунок = Селекция.InlineShapes.AddPicture(ВременныйФайлКартинки, Ложь, Истина);
		
		// Чтобы установить обтекание текста, конвертируем рисунок в фигуру
		Shape = Рисунок.ConvertToShape();
		Shape.WrapFormat.Type = 0; // по контуру...
		
		УдалитьФайлы(ВременныйФайлКартинки);
	КонецЕсли;
	
	// Вывод на печать или в файл
	ВывестиДокумент();
	
КонецПроцедуры // ПечатьДокумента()
 

&НаСервереБезКонтекста
Функция ПолучитьНаименованиеДолжности(Должность)
    Возврат Должность.Наименование;
КонецФункции // ()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Дело = Неопределено;
	Если Параметры.Свойство("Дело") Тогда
		Дело = Параметры.Дело;
	КонецЕсли; 
	
	// Контроль вида внутреннего документа
	Если ЗначениеЗаполнено(Дело) 
		И Дело.ВидДокумента <> Справочники.ВидыВнутреннихДокументов.Дело Тогда
		Сообщить("Печать предусмотрена только для вида документа ""Дело""!");
		Отказ = Истина;
	//Иначе
	//	// Дела нет
	//	Отказ = Истина;
	//	Возврат;
	КонецЕсли; 
	
	Организация = Дело.Организация;
	//Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
	Город = Организация.мГород;
	
	ЗаполнитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура ДелоПриИзменении(Элемент)
	ЗаполнитьФорму();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФорму()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	мНастройкаПечатиТитульныхЛистовДел.Заголовок КАК Заголовок,
		|	мНастройкаПечатиТитульныхЛистовДел.Подзаголовок КАК Подзаголовок,
		|	мНастройкаПечатиТитульныхЛистовДел.Подписал1 КАК Подписал1,
		|	мНастройкаПечатиТитульныхЛистовДел.Подписал2 КАК Подписал2,
		|	мНастройкаПечатиТитульныхЛистовДел.Подписал3 КАК Подписал3,
		|	1 КАК Приоритет
		|ИЗ
		|	РегистрСведений.мНастройкаПечатиТитульныхЛистовДел КАК мНастройкаПечатиТитульныхЛистовДел
		|ГДЕ
		|	мНастройкаПечатиТитульныхЛистовДел.ВидРабот = &ВидРабот
		|	И мНастройкаПечатиТитульныхЛистовДел.ВидЛица = &ВидЛица
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	мНастройкаПечатиТитульныхЛистовДел.Заголовок,
		|	мНастройкаПечатиТитульныхЛистовДел.Подзаголовок,
		|	мНастройкаПечатиТитульныхЛистовДел.Подписал1,
		|	мНастройкаПечатиТитульныхЛистовДел.Подписал2,
		|	мНастройкаПечатиТитульныхЛистовДел.Подписал3,
		|	2
		|ИЗ
		|	РегистрСведений.мНастройкаПечатиТитульныхЛистовДел КАК мНастройкаПечатиТитульныхЛистовДел
		|ГДЕ
		|	мНастройкаПечатиТитульныхЛистовДел.ВидРабот = &ВидРабот
		|
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет";
	
	Запрос.УстановитьПараметр("ВидЛица", Дело.Корреспондент.ЮрФизЛицо);
	ВидРабот = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Дело.ЭтапДоговора.ВидРабот, "ВидРаботПоДоговорам");
	Запрос.УстановитьПараметр("ВидРабот", ВидРабот);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		Содержание = Дело.Содержание;
		ЗаголовокДела = Выборка.Заголовок;	
		ПодЗаголовок = Выборка.Подзаголовок;
		
		Элементы.Найти("Подписал2").Видимость = Выборка.Подписал2;
		Элементы.Найти("Подписал3").Видимость = Выборка.Подписал3;
		Элементы.ФормаПечать.Доступность = Истина;
	Иначе	
		Сообщить("Для вида работ: " + Дело.ЭтапДоговора.ВидРабот.Наименование + ", вид Заказчика: " + Дело.Корреспондент.ЮрФизЛицо + " не предусмотрена печать титульного листа!");
		Элементы.ФормаПечать.Доступность = Ложь;
	КонецЕсли; 
	
	
	//МакетШаблонов = Обработки.мПечатьТитульногоЛистаДела.ПолучитьМакет("ТекстыШаблонов");
	//ВидРабот = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Дело.ЭтапДоговора.ВидРабот, "ВидРаботПоДоговорам");
	//НаименованиеВидаРаботы = ВидРабот.Наименование;
	////НаименованиеВидаРаботы = Дело.ЭтапДоговора.ВидРабот.ВидРаботПоДоговорам.Наименование;
	//ВидКорреспондента = Дело.Корреспондент.ЮрФизЛицо;
	//Содержание = Дело.Содержание;
	//Если ВидКорреспондентаСтрокой = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
	//	ВидКорреспондентаСтрокой = "ФизЛицо";
	//Иначе
	//	ВидКорреспондентаСтрокой = "ЮрЛицо";
	//КонецЕсли; 
	//
	//СтрокаНайдена = Ложь;
	//Для й=2 По МакетШаблонов.ВысотаТаблицы Цикл
	//	Если НаименованиеВидаРаботы <> МакетШаблонов.Область(й,1).Текст Тогда
	//		Продолжить;
	//	КонецЕсли; 
	//	ВидЛица = МакетШаблонов.Область(й,7).Текст;
	//	Если ЗначениеЗаполнено(ВидЛица) Тогда
	//		Если ВидЛица <> ВидКорреспондентаСтрокой Тогда
	//			Продолжить;
	//		КонецЕсли; 
	//	КонецЕсли; 
	//    СтрокаНайдена = Истина;
	//	Прервать;
	//КонецЦикла; 
	//
	//Если СтрокаНайдена Тогда
	//	ЗаголовокДела = МакетШаблонов.Область(й,2).Текст;	
	//	ПодЗаголовок = МакетШаблонов.Область(й,3).Текст;
	//	
	//	Если МакетШаблонов.Область(й,6).Текст = "Да" Тогда
	//		Элементы.Найти("Подписал3").Видимость = Истина;
	//	Иначе	
	//		Элементы.Найти("Подписал3").Видимость = Ложь;
	//		Подписал3 = "";
	//	КонецЕсли;
	//	Элементы.ФормаПечать.Доступность = Истина;
	//Иначе
	//	Сообщить("Для вида работ: " + Дело.ЭтапДоговора.ВидРабот.Наименование + ", вид Заказчика: " + ВидКорреспондентаСтрокой + " не предусмотрена печать титульного листа!");
	//	Элементы.ФормаПечать.Доступность = Ложь;
	//КонецЕсли; 
	
	ВосстановитьНастройку();
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьДокументWord(ФорматЛиста) 
	ПутьКФайлуНаДиске = ПолучитьИмяВременногоФайла("docx");
	ГородБазы = мРазное.НашГород();
	
	Если ГородБазы = "Прилуки" Тогда
		Макет = ПолучитьМакетСервер("ТитульныйЛист"+ФорматЛиста+"_Прилуки");
	Иначе
		Макет = ПолучитьМакетСервер("ТитульныйЛист"+ФорматЛиста);
	КонецЕсли; 
	
	Макет.Записать(ПутьКФайлуНаДиске);
	
	WordApp = Новый COMОбъект("Word.Application");
	Док = WordApp.Documents.ADD(ПутьКФайлуНаДиске);
	
	Селекция = WordApp.Selection;
	
	Поиск = Док.Content.Find;
	Поиск.ClearFormatting();
	Поиск.Replacement.ClearFormatting();
КонецПроцедуры 

&НаСервере
Функция ПолучитьМакетСервер(ИмяМакета)
	Возврат РеквизитФормыВЗначение("Объект").ПолучитьМакет(ИмяМакета);
КонецФункции

&НаКлиенте
Процедура ВывестиДокумент() 

	Док.SaveAs(ПутьКФайлуНаДиске);//(ПутьКФайлуНаДиске)                        
	Док.Saved = Истина;
	Док.Close(); 
	WordApp.Quit();	
	WordApp = Неопределено;
	
	ЗапуститьПриложение(ПутьКФайлуНаДиске,, , ); 
КонецПроцедуры 

&НаСервереБезКонтекста
Функция ПолучитьНомерДела(Дело)
	Возврат Дело.РегистрационныйНомер;;
КонецФункции 

// Запись в дело Подписал1 => Утвердил
// Запись в дело ТекущийПользователь => Подготовил
&НаСервере
Процедура ЗаписатьПодписавшегоДело(Подписал)
	
	Если Дело.Утвердил <> Подписал Тогда
		ОбъектДело = Дело.ПолучитьОбъект();
		ОбъектДело.Содержание = Содержание;
		ОбъектДело.Утвердил = Подписал;
		ОбъектДело.Подготовил = Пользователи.ТекущийПользователь();
		ОбъектДело.ОбменДанными.Загрузка = Истина;
		Попытка
			ОбъектДело.Записать();
		Исключение
		
		КонецПопытки; 
	КонецЕсли; 

КонецПроцедуры 

&НаСервереБезКонтекста
Функция ПолучитьНашеНаименование(Дело)
	УстановитьПривилегированныйРежим(Истина);
	НашеНаименование = Дело.Организация.ПолноеНаименование;
	Если Дело.Организация = Справочники.Организации.БорисовскийФилиал Тогда
		ОргБГЗ = Справочники.Организации.НайтиПоКоду("00-000001"); 	
		НашеНаименование = ОргБГЗ.ПолноеНаименование + Символы.ВК + " Борисовский филиал";
	КонецЕсли; 
	Позиция = СтрНайти(НашеНаименование, " ", НаправлениеПоиска.СНачала, 1, 3);
	НашеНаименование = Лев(НашеНаименование, Позиция-1) + Символы.ВК + Сред(НашеНаименование, Позиция+1);
	
	Возврат НашеНаименование;
КонецФункции 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Отказ = Не ЗначениеЗаполнено(Дело);
КонецПроцедуры
 
