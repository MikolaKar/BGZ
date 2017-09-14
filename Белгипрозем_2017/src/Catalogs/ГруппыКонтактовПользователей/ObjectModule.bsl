
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;


	// Обработка рабочей группы
	СсылкаОбъекта = Ссылка;
	// Установка ссылки нового
	Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
		СсылкаОбъекта = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
			СсылкаНового = Справочники.ГруппыКонтактовПользователей.ПолучитьСсылку();
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
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НомерСтроки = ЭтотОбъект.Контакты.Количество() - 1;
	
	Пока НЕ Отказ И НомерСтроки >= 0 Цикл
		
		ТекущаяСтрока = ЭтотОбъект.Контакты.Получить(НомерСтроки);
		
		// Проверка заполнения значения.
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Контакт)
			И НЕ ЗначениеЗаполнено(ТекущаяСтрока.КонтактнаяИнформация) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнен адресат.'"),
			                                                  ЭтотОбъект,
			                                                  "Контакты[" + Формат(НомерСтроки, "ЧГ=0") + "].Контакт",
			                                                  ,
			                                                  Отказ);
			Возврат;
		КонецЕсли;
		
		// Проверка наличия повторяющихся значений.
		
		ЧислоНайденных = 0;
		Для Каждого СтрокаСписка Из ЭтотОбъект.Контакты Цикл
			Если СтрокаСписка.Контакт = ТекущаяСтрока.Контакт
				И СтрокаСписка.КонтактнаяИнформация = ТекущаяСтрока.КонтактнаяИнформация Тогда
				ЧислоНайденных = ЧислоНайденных + 1;
			КонецЕсли;	
		КонецЦикла;	
		
		Если ЧислоНайденных > 1 Тогда
			
			СтрокаОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Адресат ""%1"" повторяется.'"), ТекущаяСтрока.Контакт);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаОшибки,
			                                                  ЭтотОбъект,
			                                                  "Контакты[" + Формат(НомерСтроки, "ЧГ=0") + "].Контакт",
			                                                  ,
			                                                  Отказ);
			Возврат;
		КонецЕсли;
			
		НомерСтроки = НомерСтроки - 1;
	КонецЦикла;
	
	
КонецПроцедуры
