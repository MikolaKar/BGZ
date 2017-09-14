////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьБизнесПроцесс()
	
	ДеревоИсторияИсполнителя = РеквизитФормыВЗначение("ИсторияИсполнителя");
	Если ДеревоИсторияИсполнителя.Строки.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ЗадачаСсылка = Параметры.ЗадачаСсылка;
	БизнесПроцесс = ЗадачаСсылка.БизнесПроцесс;
	
	НачатьТранзакцию();
	Попытка
		
		БизнесПроцессОбъект = БизнесПроцесс.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(БизнесПроцессОбъект.Ссылка);
		
		СтарыеУчастникиПроцесса = БизнесПроцессыИЗадачиВызовСервера.ТекущиеУчастникиПроцесса(БизнесПроцессОбъект);
		
		СтрокиДерева = ДеревоИсторияИсполнителя.Строки[0].Строки;
		Для Каждого Строка Из СтрокиДерева Цикл
			Если Строка.Добавлена Тогда 
				Индекс = СтрокиДерева.Индекс(Строка);
				НоваяСтрока = БизнесПроцессОбъект.Исполнители.Вставить(Индекс);
				НоваяСтрока.Исполнитель = Строка.Исполнитель;
				НоваяСтрока.ОсновнойОбъектАдресации = Строка.ОсновнойОбъектАдресации;
				НоваяСтрока.ДополнительныйОбъектАдресации = Строка.ДополнительныйОбъектАдресации;
			КонецЕсли;
		КонецЦикла;
		
		БизнесПроцессОбъект.Записать();
		
		БизнесПроцессОбъект.ИзменитьРеквизитыНевыполненныхЗадач(СтарыеУчастникиПроцесса, Новый Структура);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтрокуУчастника()
	
	ЭлементыДерева = ИсторияИсполнителя.ПолучитьЭлементы();
	
	Если ЭлементыДерева.Количество() > 0 Тогда 
		СтрокаДерева = ЭлементыДерева[0];
		ЭлементыСтрокиДерева = СтрокаДерева.ПолучитьЭлементы();
		
		
		ВсеПройдены = Истина;
		Для Каждого Строка Из ЭлементыСтрокиДерева Цикл
			Если ЗначениеЗаполнено(Строка.ЗадачаИсполнителя) И Не Строка.Пройдена Тогда 
				ВсеПройдены = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;	
		
		Если ВсеПройдены Тогда 
			ТекстПредупреждения = НСтр("ru = 'Все исполнители завершили свои задачи, добавление строки невозможно!'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		НоваяСтрока = ЭлементыСтрокиДерева.Добавить();
		НоваяСтрока.Добавлена = Истина;
		
		Элементы.ИсторияИсполнителя.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		Элементы.ИсторияИсполнителя.ИзменитьСтроку();
	КонецЕсли;	
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессами.УстановитьФорматДаты(Элементы.ИсторияЦикловДатаИсполнения);
	РаботаСБизнесПроцессами.УстановитьФорматДаты(Элементы.ИсторияИсполнителяДатаИсполнения);
	
	ЗадачаСсылка = Параметры.ЗадачаСсылка;
	БизнесПроцесс = ЗадачаСсылка.БизнесПроцесс;
	
	// предметы
	ПредметыЗадачи = Мультипредметность.ПолучитьПредметыЗадачи(ЗадачаСсылка, Истина);
	Предметы.Загрузить(ПредметыЗадачи);
	Если Предметы.Количество() = 0 Тогда
		Элементы.ГруппаСтраницыПредметовИсторияЦиклов.Видимость = Ложь;
		Элементы.ГруппаСтраницыПредметовИсторияИсполнителя.Видимость = Ложь;
	ИначеЕсли Предметы.Количество() > 1 Тогда
		Элементы.ДекорацияЕщеИсторияИсполнителя.Видимость = Истина;
		Элементы.ДекорацияЕщеИсторияЦиклов.Видимость = Истина;
		
		ПрописьЧисла          = ЧислоПрописью(Предметы.Количество() - 1, "Л = ru_RU", НСтр("ru = ',,,,,,,,0'"));
		ПрописьЧислаИПредмета =
			ЧислоПрописью(Предметы.Количество() - 1, "Л = ru_RU", НСтр("ru = 'предмет,предмета,предметов,,,,,,0'"));
		ЧислоИПредмет = СтрЗаменить(ПрописьЧислаИПредмета, ПрописьЧисла, Формат(Предметы.Количество() - 1, "ЧГ=") + " ");
		
		Элементы.ДекорацияЕщеИсторияЦиклов.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Элементы.ДекорацияЕщеИсторияЦиклов.Заголовок,ЧислоИПредмет);
		Элементы.ДекорацияЕщеИсторияИсполнителя.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Элементы.ДекорацияЕщеИсторияИсполнителя.Заголовок,ЧислоИПредмет);
	КонецЕсли;
	
	Для Каждого СтрокаПредмета Из Предметы Цикл
		СтрокаПредмета.Картинка = МультипредметностьКлиентСервер.ИндексКартинкиРолиПредмета(
			СтрокаПредмета.РольПредмета, ?(СтрокаПредмета.Предмет = Неопределено, Ложь, СтрокаПредмета.Предмет.ПометкаУдаления));
		СтрокаПредмета.Описание = ОбщегоНазначенияДокументооборот.ПредметСтрокой(СтрокаПредмета.Предмет);
	КонецЦикла;
	
	Элементы.ПредметыИсторияЦиклов.ТекущаяСтрока = 0;
	Элементы.ПредметыИсторияИсполнителя.ТекущаяСтрока = 0;
	
	НомерИтерации = 0;
	Если ЗадачаСсылка.ТочкаМаршрута = БизнесПроцессы.Приглашение.ТочкиМаршрута.Ознакомиться Тогда 
		
		НайденнаяСтрока = БизнесПроцесс.РезультатыОзнакомлений.Найти(ЗадачаСсылка, "ЗадачаИсполнителя");
		Если НайденнаяСтрока <> Неопределено Тогда 
			НомерИтерации = НайденнаяСтрока.НомерИтерации;
		КонецЕсли;
		
		
		// заполнить дерево
		ДеревоИсторияЦиклов = РеквизитФормыВЗначение("ИсторияЦиклов");
		
		НомераИтераций = БизнесПроцесс.РезультатыПриглашения.Выгрузить(,"НомерИтерации");
		НомераИтераций.Свернуть("НомерИтерации",);
		НомераИтераций.Сортировать("НомерИтерации Убыв");
		
		Для Каждого СтрокаИтерации Из НомераИтераций Цикл
			Если СтрокаИтерации.НомерИтерации >= НомерИтерации Тогда 
				Продолжить;
			КонецЕсли;	
			
			СтрокаДереваЦикл = ДеревоИсторияЦиклов.Строки.Добавить();
			СтрокаДереваЦикл.Исполнитель = "Цикл " + СтрокаИтерации.НомерИтерации;
			СтрокаДереваЦикл.НомерИтерации = СтрокаИтерации.НомерИтерации;
			
			Для Каждого Строка Из БизнесПроцесс.РезультатыПриглашения Цикл
				Если СтрокаИтерации.НомерИтерации <> Строка.НомерИтерации Тогда 
					Продолжить;
				КонецЕсли;	
				
				СтрокаДереваИсполнитель = СтрокаДереваЦикл.Строки.Добавить();
				СтрокаДереваИсполнитель.ЗадачаИсполнителя = Строка.ЗадачаИсполнителя;
				СтрокаДереваИсполнитель.РезультатПриглашения = Строка.РезультатПриглашения;
				СтрокаДереваИсполнитель.ДатаИсполнения = Строка.ЗадачаИсполнителя.ДатаИсполнения;
				СтрокаДереваИсполнитель.РезультатВыполнения = Строка.ЗадачаИсполнителя.РезультатВыполнения;
				СтрокаДереваИсполнитель.НомерИтерации = Строка.НомерИтерации;
				
				Если ЗначениеЗаполнено(Строка.ЗадачаИсполнителя.Исполнитель) Тогда 
					СтрокаДереваИсполнитель.Исполнитель = Строка.ЗадачаИсполнителя.Исполнитель;
				Иначе
					СтрокаДереваИсполнитель.Исполнитель = Строка.ЗадачаИсполнителя.РольИсполнителя;
					СтрокаДереваИсполнитель.ОсновнойОбъектАдресации = Строка.ЗадачаИсполнителя.ОсновнойОбъектАдресации;
					СтрокаДереваИсполнитель.ДополнительныйОбъектАдресации = Строка.ЗадачаИсполнителя.ДополнительныйОбъектАдресации;
				КонецЕсли;	
				
			КонецЦикла;	
			
		КонецЦикла;	
		
		ЗначениеВРеквизитФормы(ДеревоИсторияЦиклов, "ИсторияЦиклов");
		
		
		Элементы.ГруппаИсторияЦиклов.Видимость = Истина;
		Элементы.ГруппаИсторияИсполнителя.Видимость = Ложь;
		Заголовок = НСтр("ru = 'История приглашения'");
		
	ИначеЕсли ЗадачаСсылка.ТочкаМаршрута = БизнесПроцессы.Приглашение.ТочкиМаршрута.Пригласить Тогда 
		  
		НайденнаяСтрока = БизнесПроцесс.РезультатыПриглашения.Найти(ЗадачаСсылка, "ЗадачаИсполнителя");
		Если НайденнаяСтрока <> Неопределено Тогда 
			НомерИтерации = НайденнаяСтрока.НомерИтерации;
		КонецЕсли;
		
		ДоступностьПоШаблону = ШаблоныБизнесПроцессов.ДоступностьПоШаблону(БизнесПроцесс);
		
		
		Если НомерИтерации <> БизнесПроцесс.НомерИтерации Или Не ДоступностьПоШаблону Тогда 
			Элементы.ДобавитьУчастника.Видимость = Ложь;
			
			Элементы.КонтекстноеМенюДобавитьУчастника.Видимость = Ложь;
			Элементы.КонтекстноеМенюУдалитьУчастника.Видимость = Ложь;
			
			Элементы.ИсторияИсполнителяИсполнитель.ТолькоПросмотр = Истина;
		КонецЕсли;	
		
		
		// заполнить дерево
		ДеревоИсторияИсполнителя = РеквизитФормыВЗначение("ИсторияИсполнителя");
		
		НомераИтераций = БизнесПроцесс.РезультатыПриглашения.Выгрузить(,"НомерИтерации");
		НомераИтераций.Свернуть("НомерИтерации",);
		НомераИтераций.Сортировать("НомерИтерации Убыв");
		
		Для Каждого СтрокаИтерации Из НомераИтераций Цикл
			Если СтрокаИтерации.НомерИтерации > НомерИтерации Тогда 
				Продолжить;
			КонецЕсли;	
			
			Если СтрокаИтерации.НомерИтерации = БизнесПроцесс.НомерИтерации Тогда 
				
				СтрокаДереваЦикл = ДеревоИсторияИсполнителя.Строки.Добавить();
				СтрокаДереваЦикл.Исполнитель = "Цикл " + СтрокаИтерации.НомерИтерации + "";
				СтрокаДереваЦикл.НомерИтерации = СтрокаИтерации.НомерИтерации;
				
				Для Каждого Строка Из БизнесПроцесс.Исполнители Цикл
					СтрокаДереваИсполнитель = СтрокаДереваЦикл.Строки.Добавить();
					СтрокаДереваИсполнитель.ЗадачаИсполнителя = Строка.ЗадачаИсполнителя;
					СтрокаДереваИсполнитель.НомерИтерации = БизнесПроцесс.НомерИтерации;
					
					Если ЗначениеЗаполнено(Строка.ЗадачаИсполнителя) Тогда 
						
						СтрокаДереваИсполнитель.ДатаИсполнения = Строка.ЗадачаИсполнителя.ДатаИсполнения;
						СтрокаДереваИсполнитель.РезультатВыполнения = Строка.ЗадачаИсполнителя.РезультатВыполнения;
						
						Если ЗначениеЗаполнено(Строка.ЗадачаИсполнителя.Исполнитель) Тогда 
							СтрокаДереваИсполнитель.Исполнитель = Строка.ЗадачаИсполнителя.Исполнитель;
						Иначе
							СтрокаДереваИсполнитель.Исполнитель = Строка.ЗадачаИсполнителя.РольИсполнителя;
							СтрокаДереваИсполнитель.ОсновнойОбъектАдресации = Строка.ЗадачаИсполнителя.ОсновнойОбъектАдресации;
							СтрокаДереваИсполнитель.ДополнительныйОбъектАдресации = Строка.ЗадачаИсполнителя.ДополнительныйОбъектАдресации;
						КонецЕсли;	
						
						НайденнаяСтрока = БизнесПроцесс.РезультатыПриглашения.Найти(Строка.ЗадачаИсполнителя, "ЗадачаИсполнителя");
						Если НайденнаяСтрока <> Неопределено Тогда 
							СтрокаДереваИсполнитель.РезультатПриглашения = НайденнаяСтрока.РезультатПриглашения;
						КонецЕсли;
						
					Иначе
						СтрокаДереваИсполнитель.Исполнитель = Строка.Исполнитель;
						СтрокаДереваИсполнитель.ОсновнойОбъектАдресации = Строка.ОсновнойОбъектАдресации;
						СтрокаДереваИсполнитель.ДополнительныйОбъектАдресации = Строка.ДополнительныйОбъектАдресации;
					КонецЕсли;	
				КонецЦикла;	
				
			Иначе
				
				СтрокаДереваЦикл = ДеревоИсторияИсполнителя.Строки.Добавить();
				СтрокаДереваЦикл.Исполнитель = "Цикл " + СтрокаИтерации.НомерИтерации;
				СтрокаДереваЦикл.НомерИтерации = СтрокаИтерации.НомерИтерации;
				
				Для Каждого Строка Из БизнесПроцесс.РезультатыПриглашения Цикл
					Если СтрокаИтерации.НомерИтерации <> Строка.НомерИтерации Тогда 
						Продолжить;
					КонецЕсли;	
					
					СтрокаДереваИсполнитель = СтрокаДереваЦикл.Строки.Добавить();
					СтрокаДереваИсполнитель.ЗадачаИсполнителя = Строка.ЗадачаИсполнителя;
					СтрокаДереваИсполнитель.РезультатПриглашения = Строка.РезультатПриглашения;
					СтрокаДереваИсполнитель.ДатаИсполнения = Строка.ЗадачаИсполнителя.ДатаИсполнения;
					СтрокаДереваИсполнитель.РезультатВыполнения = Строка.ЗадачаИсполнителя.РезультатВыполнения;
					СтрокаДереваИсполнитель.НомерИтерации = Строка.НомерИтерации;
					
					Если ЗначениеЗаполнено(Строка.ЗадачаИсполнителя.Исполнитель) Тогда 
						СтрокаДереваИсполнитель.Исполнитель = Строка.ЗадачаИсполнителя.Исполнитель;
					Иначе
						СтрокаДереваИсполнитель.Исполнитель = Строка.ЗадачаИсполнителя.РольИсполнителя;
						СтрокаДереваИсполнитель.ОсновнойОбъектАдресации = Строка.ЗадачаИсполнителя.ОсновнойОбъектАдресации;
						СтрокаДереваИсполнитель.ДополнительныйОбъектАдресации = Строка.ЗадачаИсполнителя.ДополнительныйОбъектАдресации;
					КонецЕсли;	
					
				КонецЦикла;	
				
			КонецЕсли;	
			
			
		КонецЦикла;	
		
		ЗначениеВРеквизитФормы(ДеревоИсторияИсполнителя, "ИсторияИсполнителя");
		
		Элементы.ГруппаИсторияЦиклов.Видимость = Ложь;
		Элементы.ГруппаИсторияИсполнителя.Видимость = Истина;
		Заголовок = НСтр("ru = 'Ход приглашения'");
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭлементыДерева = ИсторияИсполнителя.ПолучитьЭлементы();
	
	Если ЭлементыДерева.Количество() > 0 Тогда 
		ЭлементДерева = ЭлементыДерева[0];
		Элементы.ИсторияИсполнителя.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ИсторияИсполнителяИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(ТекущиеДанные.Исполнитель) = Тип("Строка") Тогда 
		Возврат;
	КонецЕсли;	
	
	РаботаСПользователямиКлиент.ВыбратьИсполнителя(Элемент, ТекущиеДанные.Исполнитель,,Истина,,,
		ТекущиеДанные.ОсновнойОбъектАдресации, ТекущиеДанные.ДополнительныйОбъектАдресации);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяИсполнительПриИзменении(Элемент)
	
	ТекущийДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьОбъектыАдресацииРоли(
		ТекущийДанные,
		"Исполнитель",
		"ОсновнойОбъектАдресации",
		"ДополнительныйОбъектАдресации",
		ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		
		ТекущийДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
		ТекущийДанные.Исполнитель = ВыбранноеЗначение.РольИсполнителя;
		ТекущийДанные.ОсновнойОбъектАдресации = ВыбранноеЗначение.ОсновнойОбъектАдресации;
		ТекущийДанные.ДополнительныйОбъектАдресации = ВыбранноеЗначение.ДополнительныйОбъектАдресации;
	Иначе  
		ТекущийДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
		ТекущийДанные.ОсновнойОбъектАдресации = Неопределено;
		ТекущийДанные.ДополнительныйОбъектАдресации = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Исполнитель) = Тип("Строка") Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Добавлена Тогда 
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗначениеЗаполнено(ТекущиеДанные.ЗадачаИсполнителя) Тогда  
		БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(ТекущиеДанные.ЗадачаИсполнителя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЭлементыДерева = ИсторияИсполнителя.ПолучитьЭлементы();
	ЭлементДерева = ИсторияИсполнителя.НайтиПоИдентификатору(ТекущиеДанные.ПолучитьИдентификатор());
	
	Если ЭлементДерева = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ЭлементыДерева.Индекс(ЭлементДерева) = 0 Тогда 
		ДобавитьСтрокуУчастника();
		Возврат;
	КонецЕсли;	
	
	РодительЭлементаДерева = ЭлементДерева.ПолучитьРодителя();
	Если ЭлементыДерева.Индекс(РодительЭлементаДерева) = 0 Тогда 
		ДобавитьСтрокуУчастника();
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Исполнитель) = Тип("Строка") Тогда 
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ТекущиеДанные.Добавлена Тогда 
		ТекстПредупреждения = НСтр("ru = 'Можно удалить только строки, созданные самостоятельно!'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Предметы[0];
	
	Если ТекущиеДанные <> Неопределено Тогда
		Если ТипЗнч(ТекущиеДанные.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
			БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(ТекущиеДанные.Предмет);
		Иначе	
			ПоказатьЗначение(, ТекущиеДанные.Предмет);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЕщеНажатие(Элемент)
	
	Элементы["ГруппаСтраницыПредметов" + СтрЗаменить(Элемент.Имя,"ДекорацияЕще","")].ТекущаяСтраница =
		Элементы["ГруппаПредметы"+ СтрЗаменить(Элемент.Имя,"ДекорацияЕще","")];
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	МультипредметностьКлиент.ПредметыВыбор(Предметы, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияЦикловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ИсторияЦиклов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ЗадачаИсполнителя) Тогда
		БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ТекущиеДанные.ЗадачаИсполнителя, Поле, СтандартнаяОбработка);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Исполнитель) = Тип("Строка") Тогда 
		СтандартнаяОбработка = Ложь;
		
		Если Элементы.ИсторияИсполнителя.Развернут(ТекущиеДанные.ПолучитьИдентификатор()) Тогда 
			Элементы.ИсторияИсполнителя.Свернуть(ТекущиеДанные.ПолучитьИдентификатор());
		Иначе
			Элементы.ИсторияИсполнителя.Развернуть(ТекущиеДанные.ПолучитьИдентификатор());
		КонецЕсли;	
		
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Добавлена Тогда 
		Возврат;
	КонецЕсли;	
		
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ТекущиеДанные.ЗадачаИсполнителя) Тогда  
		БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ТекущиеДанные.ЗадачаИсполнителя, Поле, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьУчастника(Команда)
	
	ДобавитьСтрокуУчастника();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Исполнитель) = Тип("Строка") Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ТекущиеДанные.Добавлена Тогда 
		ТекстПредупреждения = НСтр("ru = 'Можно передвинуть только строки созданные самостоятельно!'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ЭлементДерева = ИсторияИсполнителя.НайтиПоИдентификатору(ТекущиеДанные.ПолучитьИдентификатор());
	ЭлементРодитель = ТекущиеДанные.ПолучитьРодителя();
	
	Если ЭлементРодитель <> Неопределено Тогда 
		ЭлементыДерева = ЭлементРодитель.ПолучитьЭлементы();
		
		Индекс = ЭлементыДерева.Индекс(ЭлементДерева);
		Если Индекс = 0 Тогда 
			Возврат;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(ЭлементыДерева[Индекс-1].ЗадачаИсполнителя) Тогда 
			ТекстПредупреждения = НСтр("ru = 'Задача предыдущего исполнителя уже сформирована, изменение порядка строки невозможно!'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		ЭлементыДерева.Сдвинуть(Индекс, -1); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Исполнитель) = Тип("Строка") Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ТекущиеДанные.Добавлена Тогда 
		ТекстПредупреждения = НСтр("ru = 'Можно передвинуть только строки созданные самостоятельно!'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ЭлементДерева = ИсторияИсполнителя.НайтиПоИдентификатору(ТекущиеДанные.ПолучитьИдентификатор());
	ЭлементРодитель = ТекущиеДанные.ПолучитьРодителя();
	
	Если ЭлементРодитель <> Неопределено Тогда 
		ЭлементыДерева = ЭлементРодитель.ПолучитьЭлементы();
		Индекс = ЭлементыДерева.Индекс(ЭлементДерева);
		Если Индекс < ЭлементыДерева.Количество()-1 Тогда 
			ЭлементыДерева.Сдвинуть(Индекс, 1); 
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаИсторияЦиклов Тогда 
		Закрыть();
		Возврат;
	КонецЕсли;	
	
	ЭлементыДерева = ИсторияИсполнителя.ПолучитьЭлементы();
	Если ЭлементыДерева.Количество() = 0 Тогда 
		Закрыть();
		Возврат;
	КонецЕсли;	
	
	СтрокаДерева = ЭлементыДерева[0];
	ЭлементыСтрокиДерева = СтрокаДерева.ПолучитьЭлементы();
	
	ЕстьДобавленныеСтроки = Ложь;
	Для Каждого Строка Из ЭлементыСтрокиДерева Цикл
		Если Строка.Добавлена Тогда
			ЕстьДобавленныеСтроки = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;	
	
	Если Не ЕстьДобавленныеСтроки Тогда 
		Закрыть();
		Возврат;
	КонецЕсли;	
	
	// проверка заполнения
	ОчиститьСообщения();
	
	Для Каждого Строка Из ЭлементыСтрокиДерева Цикл
		Если Строка.Добавлена И Не ЗначениеЗаполнено(Строка.Исполнитель) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не заполнено поле ""Участник"" в строке %1 списка!'"), 
					ЭлементыСтрокиДерева.Индекс(Строка)+1);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, 
					"ИсторияИсполнителя",,);
			Возврат;		
		КонецЕсли;
	КонецЦикла;
	
	// проверка дублей
	КоличествоИсполнителей = ЭлементыСтрокиДерева.Количество();
	Для Инд1 = 0 По КоличествоИсполнителей-2 Цикл
		Строка1 = ЭлементыСтрокиДерева[Инд1];
		
		Для Инд2 = Инд1+1 По КоличествоИсполнителей-1 Цикл
			Строка2 = ЭлементыСтрокиДерева[Инд2];
			
			Если Строка1.Исполнитель = Строка2.Исполнитель И ТипЗнч(Строка1.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда 
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Участник ""%1"" указан дважды в списке участников!'"), 
					Строка(Строка1.Исполнитель));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,,
					"ИсторияИсполнителя",,);
					
				Возврат;	
				
			ИначеЕсли (Строка1.Исполнитель = Строка2.Исполнитель 
				И ТипЗнч(Строка1.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей")
				И Строка1.ОсновнойОбъектАдресации = Строка2.ОсновнойОбъектАдресации
				И Строка1.ДополнительныйОбъектАдресации = Строка2.ДополнительныйОбъектАдресации) Тогда 
				
				Если ЗначениеЗаполнено(Строка1.ОсновнойОбъектАдресации) И ЗначениеЗаполнено(Строка1.ДополнительныйОбъектАдресации) Тогда 	
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Участник ""%1 (%2, %3)"" указан дважды в списке участников!'"),
						Строка(Строка1.Исполнитель),
						Строка(Строка1.ОсновнойОбъектАдресации),
						Строка(Строка1.ДополнительныйОбъектАдресации));
					
				ИначеЕсли ЗначениеЗаполнено(Строка1.ОсновнойОбъектАдресации) Тогда 
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Участник ""%1 (%2)"" указан дважды в списке участников!'"),
						Строка(Строка1.Исполнитель),
						Строка(Строка1.ОсновнойОбъектАдресации));
					
				Иначе
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Участник ""%1"" указан дважды в списке участников!'"), 
						Строка(Строка1.Исполнитель));
					
				КонецЕсли;	
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,,
					"ИсторияИсполнителя",, );
					
				Возврат;	
				
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;	
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОКЗавершение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'В список участников были добавлены новые исполнители. Будет выполнено обновление процесса.
		|Продолжить?'");
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ОКЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	ОбновитьБизнесПроцесс();
	
	Оповестить("ИзмененСоставУчастников", БизнесПроцесс);
	Оповестить("ИзмененыРеквизитыНевыполненныхЗадач", БизнесПроцесс);
	
	ПоказатьОповещениеПользователя(
		"Изменение:", 
		ПолучитьНавигационнуюСсылку(БизнесПроцесс),
		Строка(БизнесПроцесс),
		БиблиотекаКартинок.Информация32);
	
	Закрыть();
	
КонецПроцедуры