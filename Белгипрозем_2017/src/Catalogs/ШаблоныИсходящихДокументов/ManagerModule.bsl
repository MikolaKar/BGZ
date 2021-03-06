#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей Шаблона исходящих документов
//
// Возвращаемое значение:
//   Структура
//
Функция ПолучитьСтруктуруШаблона() Экспорт
	
	ПараметрыШаблона = Новый Структура;
	ПараметрыШаблона.Вставить("Наименование");
	ПараметрыШаблона.Вставить("ВидДокумента");
	ПараметрыШаблона.Вставить("ВопросДеятельности");
	ПараметрыШаблона.Вставить("НоменклатураДел");
	ПараметрыШаблона.Вставить("Автор");
	ПараметрыШаблона.Вставить("Организация");
	ПараметрыШаблона.Вставить("Проект");
	
	ПрикрепленныеФайлы = Новый ТаблицаЗначений;
	ПрикрепленныеФайлы.Колонки.Добавить("ФайлСсылка");
	ПараметрыШаблона.Вставить("ПрикрепленныеФайлы", ПрикрепленныеФайлы);
	
	РабочаяГруппаДокумента = Новый ТаблицаЗначений;
	РабочаяГруппаДокумента.Колонки.Добавить("Участник");
	ПараметрыШаблона.Вставить("РабочаяГруппаДокумента", РабочаяГруппаДокумента);
	
	Возврат ПараметрыШаблона;
	
КонецФункции

// Создает и записывает в БД шаблон исходящих документов
//
// Параметры:
//   СтруктураШаблона - Структура - структура полей шаблона ис документов.
//
Функция СоздатьШаблон(СтруктураШаблона) Экспорт
	
	НовыйШаблон = Справочники.ШаблоныИсходящихДокументов.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовыйШаблон, СтруктураШаблона);
	Для Каждого Строка Из СтруктураШаблона.ПрикрепленныеФайлы Цикл
		НоваяСтрока = НовыйШаблон.ПрикрепленныеФайлы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	Для Каждого Строка Из СтруктураШаблона.РабочаяГруппаДокумента Цикл
		НоваяСтрока = НовыйШаблон.РабочаяГруппаДокумента.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	НовыйШаблон.Записать();
	
	Возврат НовыйШаблон.Ссылка;
	
КонецФункции

Функция ПодготовитьСводкуПоШаблону(ШаблонСсылка) Экспорт
	
	ДанныеДокумента = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ШаблонСсылка, 
		"Заголовок,КомментарийКДокументу,ВидДокумента,ГрифДоступа,ДлительностьИсполнения,Организация,Подразделение");
		
	РабочаяГруппа = "";
	Для Каждого УчастникГруппы Из ШаблонСсылка.РабочаяГруппаДокумента Цикл
		Если ТипЗнч(УчастникГруппы.Участник) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
			РабочаяГруппа = РабочаяГруппа
				+ Строка(УчастникГруппы.Участник)
				+ " (" 
				+ ?(ЗначениеЗаполнено(УчастникГруппы.ОсновнойОбъектАдресации),
						Строка(УчастникГруппы.ОсновнойОбъектАдресации) + ",", "")
				+ ?(ЗначениеЗаполнено(УчастникГруппы.ДополнительныйОбъектАдресации),
						Строка(УчастникГруппы.ДополнительныйОбъектАдресации), "")
				+ ")";
		Иначе
			РабочаяГруппа = РабочаяГруппа + Строка(УчастникГруппы.Участник);
		КонецЕсли;
		РабочаяГруппа = РабочаяГруппа + ", ";
	КонецЦикла;
	Если ЗначениеЗаполнено(РабочаяГруппа) Тогда
		РабочаяГруппа = Лев(РабочаяГруппа, СтрДлина(РабочаяГруппа) - 2);
		ДанныеДокумента.Вставить("РабочаяГруппа", РабочаяГруппа);
	КонецЕсли;
	
	Получатели = "";
	Для Каждого Получатель Из ШаблонСсылка.Получатели Цикл
		Получатели = Получатели + Получатель.Получатель	+ ", ";
	КонецЦикла;
	Если ЗначениеЗаполнено(Получатели) Тогда
		Получатели = Лев(Получатели, СтрДлина(Получатели) - 2);
		ДанныеДокумента.Вставить("Получатели", Получатели);
	КонецЕсли;
	
	ДанныеДокумента.Вставить("Метаданные", ШаблонСсылка.Метаданные());
	
	Возврат ДанныеДокумента;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат 
		"ВидДокумента,
		|ВопросДеятельности,
		|ГрифДоступа,
		|Организация,
		|Получатели,
		|Автор,
		|Ссылка";
	
КонецФункции

// Заполняет переданный дескриптор доступа
Процедура ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа) Экспорт
		
	ДескрипторДоступа.ВидОбъекта = ОбъектДоступа.ВидДокумента;
	ДескрипторДоступа.ВопросДеятельности = ОбъектДоступа.ВопросДеятельности;
	ДескрипторДоступа.ГрифДоступа = ОбъектДоступа.ГрифДоступа;
	ДескрипторДоступа.Организация = ОбъектДоступа.Организация;
	
	// Корреспонденты
	Если ТипЗнч(ОбъектДоступа) = Тип("Структура") Тогда
		Выборка = ОбъектДоступа.Получатели.Выбрать();
		Пока Выборка.Следующий() Цикл
			Строка = ДескрипторДоступа.Корреспонденты.Добавить();
			Строка.ГруппаДоступа = ОбщегоНазначения.ПолучитьЗначениеРеквизита(
				Выборка.Получатель,
				"ГруппаДоступа");
		КонецЦикла;
	Иначе
		Для Каждого СтрокаТаблЧасти Из ОбъектДоступа.Получатели Цикл
			Строка = ДескрипторДоступа.Корреспонденты.Добавить();
			Строка.ГруппаДоступа = ОбщегоНазначения.ПолучитьЗначениеРеквизита(
				СтрокаТаблЧасти.Получатель,
				"ГруппаДоступа");
		КонецЦикла;
	КонецЕсли;

	// Пользователи
	Если ЗначениеЗаполнено(ОбъектДоступа.Автор) Тогда
		Строка = ДескрипторДоступа.Пользователи.Добавить();
		Строка.Ключ = "Автор";
		Строка.Пользователь = ОбъектДоступа.Автор;
	КонецЕсли;
	
	// Рабочая группа 
	РабочаяГруппа = РаботаСРабочимиГруппами.ПолучитьРабочуюГруппуДокумента(ОбъектДоступа.Ссылка);
	Для каждого Эл Из РабочаяГруппа Цикл
		Строка = ДескрипторДоступа.РабочаяГруппа.Добавить();
		Строка.Участник = Эл.Участник;
		Строка.ОсновнойОбъектАдресации = Эл.ОсновнойОбъектАдресации;
		Строка.ДополнительныйОбъектАдресации = Эл.ДополнительныйОбъектАдресации;
	КонецЦикла;	
	
КонецПроцедуры

// Возвращает Истина, указывая тем самы что этот объект сам заполняет свои права 
Функция ЕстьМетодЗаполнитьПраваДоступа() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет параметр ПраваДоступа правами доступа, вычисляя их на 
// основании переданного дескриптора доступа.
// Если указан параметр ПротоколРасчетаПрав, то в него 
// заносится список данных, которые были использованы для расчета прав.
Процедура ЗаполнитьПраваДоступа(ДескрипторДоступа, ПраваДоступа, ПротоколРасчетаПрав) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Справочники.ДескрипторыДоступаОбъектов.ЗаполнитьПраваДоступаСтандартно(
		ДескрипторДоступа, 
		ПраваДоступа, 
		ПротоколРасчетаПрав);
				
	// Рабочая группа
	Если ДескрипторДоступа.РабочаяГруппа.Количество() > 0 Тогда
		
		// Добавление рабочей группы в протокол расчета прав
		Если ПротоколРасчетаПрав <> Неопределено Тогда
			ПротоколРасчетаПрав.Добавить(НСтр("ru = 'Рабочая группа'"));
		КонецЕсли;	
		
		НовыеПраваДоступа = Новый Соответствие;
		
		Для каждого Эл Из ДескрипторДоступа.РабочаяГруппа Цикл
			
			Если ТипЗнч(Эл.Участник) = Тип("СправочникСсылка.Пользователи") Тогда
				
				НайденныйЭлемент = ПраваДоступа.Получить(Эл.Участник);
				Если НайденныйЭлемент <> Неопределено Тогда
					
					ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами",
													Истина, Ложь, Ложь, Ложь, Ложь);
					
					НовыеПраваДоступа.Вставить(Эл.Участник, ПраваПользователя);
					
				КонецЕсли;
					
			ИначеЕсли ТипЗнч(Эл.Участник) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
					
				// Обходим всех пользователей группы
				СоставГруппы = ДокументооборотПраваДоступаПовтИсп.ПолучитьСоставГруппыПользователей(Эл.Участник);
				Для каждого ЭлГруппы Из СоставГруппы Цикл
					
					НайденныйЭлемент = ПраваДоступа.Получить(ЭлГруппы.Пользователь);
					Если НайденныйЭлемент <> Неопределено Тогда
						
						ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами", 
														Истина, Ложь, Ложь, Ложь, Ложь);
					
						НовыеПраваДоступа.Вставить(ЭлГруппы.Пользователь, ПраваПользователя);
						
					КонецЕсли;
					
				КонецЦикла;	
				
			ИначеЕсли ТипЗнч(Эл.Участник) = Тип("СправочникСсылка.РолиИсполнителей") Тогда	
					
				// Обходим всех исполнителей роли
				ИсполнителиРоли = РегистрыСведений.ИсполнителиЗадач.ПолучитьИсполнителейРоли(Эл.Участник, Эл.ОсновнойОбъектАдресации, Эл.ДополнительныйОбъектАдресации);
				Для каждого ИсполнительРоли Из ИсполнителиРоли Цикл
					
					НайденныйЭлемент = ПраваДоступа.Получить(ИсполнительРоли.Исполнитель);
					Если НайденныйЭлемент <> Неопределено Тогда
						
						ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами", 
														Истина, Ложь, Ложь, Ложь, Ложь);
					
						НовыеПраваДоступа.Вставить(ИсполнительРоли.Исполнитель, ПраваПользователя);
						
					КонецЕсли;
					
				КонецЦикла;				
			КонецЕсли;	
		КонецЦикла;	
		
		ПраваДоступа = НовыеПраваДоступа;
		
	Иначе
				
		НовыеПраваДоступа = Новый Соответствие;
		Для каждого Эл Из ПраваДоступа Цикл
			
			ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами", 
												Истина, Ложь, Ложь, Ложь, Ложь);
												
			НовыеПраваДоступа.Вставить(Эл.Ключ, ПраваПользователя);
			
		КонецЦикла;
		
		ПраваДоступа = НовыеПраваДоступа;
		
	КонецЕсли;
	
	// Пользователи
	АвторДобавлен = Ложь;
	Для каждого Эл Из ДескрипторДоступа.Пользователи Цикл
		Если Эл.Ключ = "Автор" Тогда
			
			АвторДобавлен = Истина;
			
			ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами",
											Истина, Истина, Истина, Истина, Ложь);
			
			ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
				ПраваДоступа,
				Эл.Пользователь,
				Эл.ОсновнойОбъектАдресации,
				Эл.ДополнительныйОбъектАдресации,
				ПраваПользователя);
			
		Иначе
				
			ВызватьИсключение(НСтр("ru = 'Неизвестный ключ пользователя.'"));
			
		КонецЕсли;
	КонецЦикла;
	
	Если АвторДобавлен Тогда
		Если ПротоколРасчетаПрав <> Неопределено Тогда
			ПротоколРасчетаПрав.Добавить(НСтр("ru = 'Автор шаблона'"));
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
