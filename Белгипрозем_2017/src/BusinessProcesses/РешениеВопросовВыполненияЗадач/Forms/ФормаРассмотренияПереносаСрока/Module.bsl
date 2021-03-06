
///////////////////////////////////////
//// Служебные процедуры и функции ////
///////////////////////////////////////

&НаСервере
Процедура РассмотреноНаСервере()
	
	Если ТребуетсяРучноеИзменениеСрока Тогда
		Возврат;
	КонецЕсли;
				
	// Вставка дополнительных свойств в бизнес-процесс для сохранения события переноса срока
	ДанныеДляЗаписиСобытияПереносаСрока = Новый Структура;
	ДанныеДляЗаписиСобытияПереносаСрока.Вставить("БизнесПроцессПереноса", Объект.БизнесПроцесс);
	ДанныеДляЗаписиСобытияПереносаСрока.Вставить("КомментарийАвтора", Объект.РезультатВыполнения);
	ДанныеДляЗаписиСобытияПереносаСрока.Вставить("Пользователь", ТекущийПользователь);
	ДанныеДляЗаписиСобытияПереносаСрока.Вставить("СтарыйСрок", СтарыйСрок);
	ДанныеДляЗаписиСобытияПереносаСрока.Вставить("НовыйСрок", НовыйСрок);
	ДанныеДляЗаписиСобытияПереносаСрока.Вставить("Предмет", ПредметРассмотрения);
	ДанныеДляЗаписиСобытияПереносаСрока.Вставить("ПереносСрока", Истина);
	
	// Обновление срока в процессе задачи-предмета рассмотрения
	ЗаблокироватьДанныеДляРедактирования(БизнесПроцессПредметаРассмотрения);
	БизнесПроцессОбъект = БизнесПроцессПредметаРассмотрения.ПолучитьОбъект();
	Если ТипЗнч(БизнесПроцессОбъект.Ссылка) = Тип("БизнесПроцессСсылка.Исполнение") Тогда
		// Если запрос произошел в процессе Исполнение, то срок устанавливается персонально у задачи
		Для каждого Исполнитель Из БизнесПроцессОбъект.Исполнители Цикл
			Если Исполнитель.ЗадачаИсполнителя = ПредметРассмотрения Тогда
				Исполнитель.СрокИсполнения = НовыйСрок;
				Прервать;
			КонецЕсли;
		КонецЦикла; 
		Если БизнесПроцессОбъект.СрокИсполнения < НовыйСрок
			И ЗначениеЗаполнено(БизнесПроцессОбъект.СрокИсполнения) Тогда
			БизнесПроцессОбъект.СрокИсполнения = НовыйСрок;	
			// Запись события переноса срока процесса
		КонецЕсли;
		ПереносСроковВыполненияЗадач.СделатьЗаписьОПереносеСрока(
				БизнесПроцессОбъект, 
				ДанныеДляЗаписиСобытияПереносаСрока);
	Иначе
		БизнесПроцессОбъект.СрокИсполнения = НовыйСрок;
			
		// Запись события переноса срока процесса
		ПереносСроковВыполненияЗадач.СделатьЗаписьОПереносеСрока(
			БизнесПроцессОбъект, 
			ДанныеДляЗаписиСобытияПереносаСрока);
	КонецЕсли;		
		
	// Запись измененного процесса
	БизнесПроцессОбъект.Записать();
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(БизнесПроцессПредметаРассмотрения);
	
	// Обновление невыполненных задач
	СтарыеУчастникиПроцесса = БизнесПроцессыИЗадачиВызовСервера.ТекущиеУчастникиПроцесса(БизнесПроцессОбъект);
	БизнесПроцессОбъект.ИзменитьРеквизитыНевыполненныхЗадач(
		СтарыеУчастникиПроцесса, 
		ДанныеДляЗаписиСобытияПереносаСрока);
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьХронометражСервер() Экспорт
	
	УчетВремени.ОтключитьХронометражСервер(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		Объект.Ссылка,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьХронометражСервер(ПараметрыОповещения) Экспорт
	
	УчетВремени.ПереключитьХронометражСервер(
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		Объект.Ссылка,
		ВидыРабот,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтчетИОбновитьФорму(ПараметрыОтчета, ПараметрыОповещения) Экспорт
	
	УчетВремени.ДобавитьВОтчетИОбновитьФорму(
	    ПараметрыОтчета, 
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокАктивныхЗадач(БизнесПроцессСсылка) 
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ЗадачаИсполнителя.Ссылка,
		|	ЗадачаИсполнителя.Выполнена,
		|	ЗадачаИсполнителя.БизнесПроцесс
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.Выполнена = ЛОЖЬ
		|	И ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс";
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцессСсылка);	
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОпределитьОбязательностьТолькоРучногоИзмененияСроков()
	
	МенеджерПроцесса = ОбщегоНазначения.МенеджерОбъектаПоСсылке(БизнесПроцессПредметаРассмотрения);
	ТребуетсяРучноеИзменениеСрока = 
		НЕ МенеджерПроцесса.ВозможноАвтоматическоеИзменениеОбщегоСрока(БизнесПроцессПредметаРассмотрения);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСамыйВерхнийКомплексныйПроцесс()
	
	ПредыдущийКомплексныйПроцесс = Неопределено;
	КомплексныйБизнесПроцесс = БизнесПроцессПредметаРассмотрения.ВедущаяЗадача.БизнесПроцесс;
	Пока ЗначениеЗаполнено(КомплексныйБизнесПроцесс) Цикл
		ПредыдущийКомплексныйПроцесс = КомплексныйБизнесПроцесс;
		КомплексныйБизнесПроцесс = КомплексныйБизнесПроцесс.ВедущаяЗадача.БизнесПроцесс;
	КонецЦикла;
	Возврат ПредыдущийКомплексныйПроцесс;
	
КонецФункции

&НаСервереБезКонтекста
Функция КоличествоПереносовПоЗадаче(ЗадачаСсылка, ЗаявкаСсылка)
	
	Возврат ПереносСроковВыполненияЗадач.КоличествоПереносовСрокаПоЗадачеИЗаявкеНаПеренос(
		ЗадачаСсылка, 
		ЗаявкаСсылка);
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииНовогоСрока(ИзмененаДата)
	
	// Если в поле "Новый срок" вводится только время, то в дату проставляется текущая дата.
	// При вводе только времени дата автоматически принимает значение 01.01.0001 <Время>. Это значение исправляется.
	Если ЗначениеЗаполнено(НовыйСрок) и НовыйСрок < Дата(1,1,2) Тогда
		ДатаНачалаДня = НачалоДня(ТекущаяДата());
		ГодНачалаДня = Год(ДатаНачалаДня);
		МесяцНачалаДня = Месяц(ДатаНачалаДня);
		ДеньНачалаДня = День(ДатаНачалаДня);
		ЧасДаты = Час(НовыйСрок);
		МинутаДаты = Минута(НовыйСрок);
		СекундаДаты = Секунда(НовыйСрок);
		НовыйСрок = Дата(
			ГодНачалаДня,
			МесяцНачалаДня,
			ДеньНачалаДня,
			ЧасДаты,
			МинутаДаты,
			СекундаДаты);	
	КонецЕсли;
	Если ИзмененаДата И НовыйСрок < КонецДня(НовыйСрок)
		ИЛИ НЕ ИспользоватьВремяВСрокахЗадач Тогда
		НовыйСрок = КонецДня(НовыйСрок);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НовыйСрок) Тогда
		ДлительностьПереноса = 
			ПереносСроковВыполненияЗадач.ПолучитьПодписьДлительностьПереноса(
				ТекущийПользователь, 
				СтарыйСрок, 
				НовыйСрок);	
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтарыйСрок) Тогда
		ДлительностьПереноса = "";
	КонецЕсли;	
	
КонецПроцедуры

///////////////////////////////////////
////   Обработка событий формы     ////
///////////////////////////////////////

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	РаботаСФлагамиОбъектовСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Запись истории по данной задаче
	БизнесПроцессыИЗадачиВызовСервера.ЗаписатьСобытиеОткрытаКарточкаИОбращениеКОбъекту(Объект.Ссылка);
	
	ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка);
	Если Не ПраваПоОбъекту.Изменение Тогда
		ТолькоПросмотр = Истина;
		Элементы.КомандаРассмотрено.Доступность = Ложь;
		Элементы.КомандаНеПереносить.Доступность = Ложь;
		Элементы.ФормаПринятьКИсполнению.Доступность = Ложь;
		Элементы.ФормаОтменитьПринятиеКИсполнению.Доступность = Ложь;
	КонецЕсли;	
	
	// Общие действия при создании карточки задачи
	РаботаСБизнесПроцессами.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
		Элементы.СрокИсполнения, Элементы.ДатаИсполнения);
	
	// Инициализация учета времени
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		Объект.Ссылка,
		ВидыРабот,
		СпособУказанияВремени,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		ЭтаФорма.Элементы.УказатьТрудозатраты);
	
	// Инициализация реквизитов карточки
	ИспользоватьВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.НовыйСрокВремя.Видимость = ИспользоватьВремяВСрокахЗадач;
	Если ИспользоватьВремяВСрокахЗадач Тогда
		Элементы.СтарыйСрок.Формат = "ДФ='dd.MM.yyyy ЧЧ:мм'";
	КонецЕсли;
	ПредметРассмотрения = Объект.БизнесПроцесс.ПредметРассмотрения;
	БизнесПроцессПредметаРассмотрения = Объект.БизнесПроцесс.ПредметРассмотрения.БизнесПроцесс;
	НаименованиеБизнесПроцессаГиперссылка = БизнесПроцессПредметаРассмотрения.Наименование;
	
	СтарыйСрок = Объект.БизнесПроцесс.ПредметРассмотрения.СрокИсполнения;
	НовыйСрок = Объект.БизнесПроцесс.НовыйСрок;	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ДлительностьПереноса = 
		ПереносСроковВыполненияЗадач.ПолучитьПодписьДлительностьПереноса(
			БизнесПроцессПредметаРассмотрения.Автор,
			СтарыйСрок,
			НовыйСрок);
	ОпределитьОбязательностьТолькоРучногоИзмененияСроков();
	
	Если ТребуетсяРучноеИзменениеСрока Тогда
		// Если изменение срока процесса необходимо выполнять вручную, то
		//	показывается информационное сообщение с подсказкой 
		Если ТипЗнч(БизнесПроцессПредметаРассмотрения.ВедущаяЗадача.БизнесПроцесс) = 
			Тип("БизнесПроцессСсылка.КомплексныйПроцесс") Тогда
			Элементы.ГруппаКомментарийИнфСообщение.ТекущаяСтраница = Элементы.ГруппаИнфСообщениеПроКомплексный;
			Элементы.ДекорацияЗнакВниманиеРучной.Видимость = Ложь;
			ВерхнийКомплексныйПроцесс = ПолучитьСамыйВерхнийКомплексныйПроцесс();
			ВерхнийКомплексныйПроцессНаименованиеГиперссылка = БизнесПроцессПредметаРассмотрения.Наименование;
			ИмяФормыДляОткрытияКарточкиПроцесса = "БизнесПроцесс."
				+ БизнесПроцессПредметаРассмотрения.Метаданные().Имя
				+ ".ФормаОбъекта";
		Иначе
			Элементы.ГруппаКомментарийИнфСообщение.ТекущаяСтраница = Элементы.ГруппаИнфСообщениеПроРучнойПеренос;
			ИмяФормыДляОткрытияКарточкиПроцесса = "БизнесПроцесс."
				+ БизнесПроцессПредметаРассмотрения.Метаданные().Имя
				+ ".ФормаОбъекта";
		КонецЕсли;	
		Элементы.НовыйСрокДата.ТолькоПросмотр = Истина;
		Элементы.НовыйСрокВремя.ТолькоПросмотр = Истина;
		Элементы.КомандаРассмотрено.Заголовок = НСтр("ru = 'Срок перенесен'");
	Иначе
		Элементы.ДекорацияЗнакВниманиеРучной.Видимость = Ложь;
		Элементы.КомандаРассмотрено.Заголовок = НСтр("ru = 'Перенести срок'");
		ИмяФормыДляОткрытияКарточкиПроцесса = "БизнесПроцесс."
				+ БизнесПроцессПредметаРассмотрения.Метаданные().Имя
				+ ".ФормаОбъекта";
	КонецЕсли;
	
	// Инициализация списка файлов
	Файлы.Параметры.УстановитьЗначениеПараметра("ВладелецФайла", Объект.БизнесПроцесс.Ссылка);
	Файлы.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());
	РаботаСФайламиВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Файлы);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗадачаИзменена", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

///////////////////////////////////////
////    Обработка команд формы     ////
///////////////////////////////////////

&НаКлиенте
Процедура ДекорацияПричинаПрерыванияНажатие(Элемент)
		
	КомандыРаботыСБизнесПроцессамиКлиент.ПоказатьПричинуПрерывания(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйСрокДатаПриИзменении(Элемент)
	
	ПриИзмененииНовогоСрока(Истина);

КонецПроцедуры

&НаКлиенте
Процедура НовыйСрокВремяПриИзменении(Элемент)
	
	ПриИзмененииНовогоСрока(Ложь);

КонецПроцедуры
		
&НаКлиенте
Процедура БизнесПроцессПредметаРассмотренияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", БизнесПроцессПредметаРассмотрения);
	ПараметрыФормы.Вставить("ЗаявкаНаПеренос", Объект.БизнесПроцесс);
	ОткрытьФорму(ИмяФормыДляОткрытияКарточкиПроцесса, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПринятьЗадачуКИсполнению(ЭтаФорма, ТекущийПользователь);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОтменитьПринятиеЗадачиКИсполнению(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПеренести(Команда)
	
	ОчиститьСообщения();
	НеобходимоИзменитьСрокАвтоматически = Ложь;
	
	Если Элементы.ГруппаКомментарийИнфСообщение.ТекущаяСтраница = 
		Элементы.ГруппаКомментарий Тогда
		// Проверка заполнения обязательных полей
		Отказ = Ложь;
		Если НЕ ЗначениеЗаполнено(НовыйСрок) Тогда
			Текст = НСтр("ru = 'Не указан новый срок исполнения.'");	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				,
				"НовыйСрок",
				,
				Отказ);
		КонецЕсли;
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		Если ТипЗнч(БизнесПроцессПредметаРассмотрения) <> Тип("БизнесПроцессСсылка.Исполнение") Тогда
		    // Получение списка текущих активных задач, срок исполнения которых будет изменен
			СписокЗадач = ПолучитьСписокАктивныхЗадач(БизнесПроцессПредметаРассмотрения);
			Если СписокЗадач.Количество() > 1 Тогда
				// Если количество задач, которых затрагивает перенос срока, больше 1, 
				//	то выводится информационное окно.
				ПараметрыФормы = Новый Структура();
				ПараметрыФормы.Вставить("Задача", ПредметРассмотрения);
				ПараметрыФормы.Вставить("МассивЗадач", СписокЗадач);
				ПараметрыФормы.Вставить("НовыйСрок", НовыйСрок);
				ПараметрыФормы.Вставить("Процесс", БизнесПроцессПредметаРассмотрения);
				ПараметрыФормы.Вставить("СтарыйСрок", СтарыйСрок);
				
				ОписаниеОповещения = Новый ОписаниеОповещения(
					"КомандаПеренестиПослеЗакрытияИнформацииОЗатрагиваемыхЗадачах", ЭтотОбъект,
					Истина);
				
				ОткрытьФорму(
					"БизнесПроцесс.РешениеВопросовВыполненияЗадач.Форма.ИнформацияОЗатрагиваемыхЗадачах", 
					ПараметрыФормы, 
					ЭтаФорма,,,,ОписаниеОповещения,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
					
				Возврат;
				
			КонецЕсли;
		КонецЕсли;
		
		НеобходимоИзменитьСрокАвтоматически = Истина;
		//
	ИначеЕсли Элементы.ГруппаКомментарийИнфСообщение.ТекущаяСтраница = Элементы.ГруппаИнфСообщениеПроКомплексный
		И КоличествоПереносовПоЗадаче(ПредметРассмотрения, Объект.БизнесПроцесс) = 0 Тогда
		Отказ = Ложь;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо вручную изменить срок на карточке процесса'"),
			,
			"ВерхнийКомплексныйПроцессНаименованиеГиперссылка",
			,
			Отказ);
		Если Отказ Тогда
			Возврат;		
		КонецЕсли;
	ИначеЕсли Элементы.ГруппаКомментарийИнфСообщение.ТекущаяСтраница = Элементы.ГруппаИнфСообщениеПроРучнойПеренос 
		И КоличествоПереносовПоЗадаче(ПредметРассмотрения, Объект.БизнесПроцесс) = 0 Тогда
		Отказ = Ложь;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо вручную изменить срок на карточке процесса'"),
			,
			"НаименованиеБизнесПроцессаГиперссылка",
			,
			Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"КомандаПеренестиПослеЗакрытияИнформацииОЗатрагиваемыхЗадачах", ЭтотОбъект,
		НеобходимоИзменитьСрокАвтоматически);
		
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПеренестиПослеЗакрытияИнформацииОЗатрагиваемыхЗадачах(
	Результат, НеобходимоИзменитьСрокАвтоматически) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ВыполнитьЗадачу", Истина);
	ПараметрыЗаписи.Вставить("НеобходимоИзменитьСрокАвтоматически", НеобходимоИзменитьСрокАвтоматически);
	Объект.РезультатВыполнения = НСтр("ru = 'Согласовано'");
	Если Не ЗаписатьНаСервере(ПараметрыЗаписи) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеВводаВремени",
		ЭтотОбъект);
	
	УчетВремениКлиент.ДобавитьВОтчетПослеВыполненияЗадачи(ОпцияИспользоватьУчетВремени,
		Объект.ДатаИсполнения, Объект.Ссылка, ВключенХронометраж, 
		ДатаНачалаХронометража, ДатаКонцаХронометража,
		ВидыРабот, СпособУказанияВремени, ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьНаСервере(ПараметрыЗаписи)
	
	НачатьТранзакцию();
	
	Если ПараметрыЗаписи.Свойство("НеобходимоИзменитьСрокАвтоматически")
		И ПараметрыЗаписи.НеобходимоИзменитьСрокАвтоматически Тогда
		РассмотреноНаСервере();
	КонецЕсли;
	
	Если НЕ Записать(ПараметрыЗаписи) Тогда
		
		ОтменитьТранзакцию();
		Возврат Ложь;
		
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура КомандаНеПереносить(Команда)
	
	// Проверка на заполнение обязательного комментария при отказе перенести срок
	Если НЕ ЗначениеЗаполнено(Объект.РезультатВыполнения) Тогда
		ОчиститьСообщения();
		Текст = НСтр("ru = 'Не заполнено поле ""Комментарий"".'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			,
			"Объект.РезультатВыполнения");
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ВыполнитьЗадачу", Истина);
	Если НЕ Записать(ПараметрыЗаписи) Тогда 
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеВводаВремени",
		ЭтотОбъект);
		
	УчетВремениКлиент.ДобавитьВОтчетПослеВыполненияЗадачи(ОпцияИспользоватьУчетВремени,
		Объект.ДатаИсполнения, Объект.Ссылка, ВключенХронометраж, 
		ДатаНачалаХронометража, ДатаКонцаХронометража,
		ВидыРабот, СпособУказанияВремени, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеВводаВремени(Результат, Параметры) Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Выполнение:'"),
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		Строка(Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("ЗадачаВыполнена", Объект.Ссылка);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить(Команда)
	
	Если Записать() Тогда
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ОчиститьСообщения();
	Если Записать() Тогда
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		
		Закрыть();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьХронометраж(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПереключитьХронометраж(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьТрудозатраты(Команда)
	
	ДатаОтчета = ТекущаяДата();
	Если Объект.Выполнена Тогда
		ДатаОтчета = Объект.ДатаИсполнения;
	КонецЕсли;	
	
	УчетВремениКлиент.ДобавитьВОтчетКлиент(
		ДатаОтчета,
		ВключенХронометраж, 
		ДатаНачалаХронометража, 
		ДатаКонцаХронометража, 
		ВидыРабот, 
		Объект.Ссылка,
		СпособУказанияВремени,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		Объект.Выполнена,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметРассмотренияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(ПредметРассмотрения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		// Подсистема "Свойства"
		ОбновитьЭлементыДополнительныхРеквизитов();
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		Элементы.Файлы.Обновить();
		Если ТипЗнч(Параметр) = Тип("Структура") Тогда
			Элементы.Файлы.ТекущаяСтрока = Параметр.Файл;
		КонецЕсли;	
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		ВладелецФайла = Неопределено;
		Если ТипЗнч(Параметр) = Тип("Структура") И Параметр.Свойство("Владелец") Тогда
			ВладелецФайла = Параметр.Владелец;
		Иначе	
			ВладелецФайла = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Источник, "ВладелецФайла");
		КонецЕсли;	
		Если ВладелецФайла = Объект.Ссылка Тогда
			Элементы.Файлы.Обновить();
			ОбновитьДоступностьКомандСпискаФайлов();
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИзменилсяФлаг"
		И Источник <> ЭтаФорма
		И Параметр.Найти(Объект.Ссылка) <> Неопределено Тогда
		
		РаботаСФлагамиОбъектовКлиентСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "ЗадачаИзменена" И Источник <> ЭтаФорма Тогда
		
		ПрочитатьДанныеЗадачиВФорму = Ложь;
		
		Если ТипЗнч(Параметр) = Тип("Массив") Тогда
			ПрочитатьДанныеЗадачиВФорму = Параметр.Найти(Объект.Ссылка) <> Неопределено;
		Иначе
			ПрочитатьДанныеЗадачиВФорму = (Параметр = Объект.Ссылка);
		КонецЕсли;
		
		Если ПрочитатьДанныеЗадачиВФорму Тогда
			Прочитать();
		КонецЕсли;
		
		КомандыРаботыСБизнесПроцессамиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	
	ПоказатьЗначение(, Объект.БизнесПроцесс);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьКомандСпискаФайлов(Результат = Неопределено, ПараметрыВыполнения = Неопределено) Экспорт
	
	УстановитьДоступностьКоманд(Элементы.Файлы.ТекущиеДанные);
	
КонецПроцедуры	

&НаКлиенте
Процедура УстановитьДоступностьКоманды(Команда, Доступность)
	
	Команда.Доступность = Доступность;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда 
		УстановитьДоступностьКоманды(Элементы.ФайлыМенюОткрытьФайл, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыМенюРедактировать, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыМенюЗакончитьРедактирование, Ложь);
		
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОткрытьФайл, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРедактировать, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗакончитьРедактирование, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗанять, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьИзменения, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьКак, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОсвободить, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОбновитьИзФайлаНаДиске, Ложь);	
	Иначе	
		РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;
		Редактирует = ТекущиеДанные.Редактирует;
		
		УстановитьДоступностьКоманды(Элементы.ФайлыМенюОткрытьФайл, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыМенюРедактировать, НЕ ТекущиеДанные.ПодписанЭП);
		УстановитьДоступностьКоманды(Элементы.ФайлыМенюЗакончитьРедактирование, РедактируетТекущийПользователь);
		
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОткрытьФайл, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРедактировать, НЕ ТекущиеДанные.ПодписанЭП);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗакончитьРедактирование, РедактируетТекущийПользователь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗанять, Редактирует.Пустая());
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьИзменения, РедактируетТекущийПользователь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьКак, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОсвободить, Не Редактирует.Пустая());
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОбновитьИзФайлаНаДиске, Истина);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КакОткрывать = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПоказатьЗначение(, ВыбраннаяСтрока);
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
	ВыбраннаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДанныеФайла", ДанныеФайла);
	Обработчик = Новый ОписаниеОповещения("СписокВыборПослеВыбораРежимаРедактирования", ЭтотОбъект, ПараметрыОбработчика);
	
	РаботаСФайламиКлиент.ВыбратьРежимИРедактироватьФайл(Обработчик, ДанныеФайла, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборПослеВыбораРежимаРедактирования(Результат, ПараметрыВыполнения) Экспорт
	
	РезультатОткрыть = "Открыть";
	РезультатРедактировать = "Редактировать";
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект, ПараметрыВыполнения);
	
	Если Результат = РезультатРедактировать Тогда
		РаботаСФайламиКлиент.РедактироватьФайл(Обработчик, ПараметрыВыполнения.ДанныеФайла);
	ИначеЕсли Результат = РезультатОткрыть Тогда
		РаботаСФайламиКлиент.ОткрытьФайлСОповещением(Неопределено, ПараметрыВыполнения.ДанныеФайла, УникальныйИдентификатор); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПриАктивизацииСтроки(Элемент)
	ОбновитьДоступностьКомандСпискаФайлов();
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			"Создание:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ВладелецФайла = Объект.БизнесПроцесс;
	ФайлОснование = Элементы.Файлы.ТекущаяСтрока;
	
	Если Не Копирование Тогда
		Попытка
			РежимСоздания = 1;
			РаботаСФайламиКлиент.ДобавитьФайл(Неопределено, ВладелецФайла, ЭтаФорма, РежимСоздания, Истина);
		Исключение
			Инфо = ИнформацияОбОшибке();
			ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка создания нового файла: %1'"),
				КраткоеПредставлениеОшибки(Инфо)));
		КонецПопытки;
	Иначе
		РаботаСФайламиКлиент.СкопироватьФайл(ВладелецФайла, ФайлОснование);
	КонецЕсли;
	Элементы.Файлы.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Файлы.ТолькоПросмотр Тогда 
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			"Создание:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ВладелецФайлаСписка = Объект.БизнесПроцесс;
	НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;	
	РаботаСФайламиКлиент.ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыПеретаскивания, ВладелецФайлаСписка, ЭтаФорма, НеОткрыватьКарточкуПослеСозданияИзФайла);
	Элементы.Файлы.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(Элементы.Файлы.ТекущаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляСохранения(Элементы.Файлы.ТекущаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(Элементы.Файлы.ТекущаяСтрока);
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	РаботаСФайламиКлиент.ОбновитьИзФайлаНаДискеСОповещением(
		Обработчик,
		ДанныеФайла, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	Если Объект.Ссылка.Пустая()
		И Элементы.ФайлыДобавленные.ТекущаяСтрока <> Неопределено Тогда
		Если ЭтоАдресВременногоХранилища(Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть) Тогда 
			ТекущийФайлВСпискеДобавленных = ПолучитьИзВременногоХранилища(Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть).Ссылка;
			Записать();
		Иначе			
			РаботаСФайламиКлиент.ЗапуститьПриложениеПоИмениФайла(
				Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть);
		КонецЕсли;	
	Иначе
		Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
		РаботаСФайламиКлиент.РедактироватьСОповещением(Обработчик, Элементы.Файлы.ТекущаяСтрока);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	РаботаСФайламиКлиент.ЗакончитьРедактированиеСОповещением(
		Обработчик,
		Элементы.Файлы.ТекущаяСтрока,
		ЭтаФорма.УникальныйИдентификатор,
		Элементы.Файлы.ТекущиеДанные.ХранитьВерсии,
		Элементы.Файлы.ТекущиеДанные.РедактируетТекущийПользователь,
		Элементы.Файлы.ТекущиеДанные.Редактирует);
	
КонецПроцедуры

&НаКлиенте
Процедура Занять(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	РаботаСФайламиКлиент.ЗанятьСОповещением(Обработчик, Элементы.Файлы.ТекущаяСтрока);	
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	
	РаботаСФайламиКлиент.ОсвободитьФайлСОповещением(
		Обработчик,
		Элементы.Файлы.ТекущаяСтрока,
		Элементы.Файлы.ТекущиеДанные.ХранитьВерсии,
		Элементы.Файлы.ТекущиеДанные.РедактируетТекущийПользователь,
		Элементы.Файлы.ТекущиеДанные.Редактирует);	
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбновитьДоступностьКомандСпискаФайлов", ЭтотОбъект);
	
	РаботаСФайламиКлиент.ОпубликоватьФайлСОповещением(
		Обработчик,
		Элементы.Файлы.ТекущаяСтрока, 
		ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗначениеПараметра = Файлы.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВладелецФайла"));
	Если Не ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда 
		Файлы.Параметры.УстановитьЗначениеПараметра("ВладелецФайла", Объект.Ссылка);
	КонецЕсли;
	
	// Обновление нового срока в процессе-заявке на перенос срока
	Если Элементы.ГруппаКомментарийИнфСообщение.ТекущаяСтраница = Элементы.ГруппаКомментарий 
		И ТекущийОбъект.Ссылка.БизнесПроцесс.НовыйСрок <> НовыйСрок Тогда	
		ЗаблокироватьДанныеДляРедактирования(ТекущийОбъект.Ссылка.БизнесПроцесс);
		ПроцессОбъект = ТекущийОбъект.Ссылка.БизнесПроцесс.ПолучитьОбъект();
		ПроцессОбъект.НовыйСрок = НовыйСрок;
		ПроцессОбъект.Записать();
	КонецЕсли;
	
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСФлагамиОбъектовСервер.СохранитьФлагОбъектаИзФормы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Оповестить("ОбновитьСписокПоследних");
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Команда)
	
	ВыполнениеЗадачПоПочтеКлиент.СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ФЛАГОМ

&НаКлиенте
Процедура КрасныйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Красный"),
		БиблиотекаКартинок.КрасныйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура СинийФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Синий"),
		БиблиотекаКартинок.СинийФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЖелтыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Желтый"),
		БиблиотекаКартинок.ЖелтыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗеленыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Зеленый"),
		БиблиотекаКартинок.ЗеленыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОранжевыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Оранжевый"),
		БиблиотекаКартинок.ОранжевыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиловыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Лиловый"),
		БиблиотекаКартинок.ЛиловыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.ПустаяСсылка"),
		БиблиотекаКартинок.ПустойФлаг);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ СВОЙСТВ

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма,
	РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры



