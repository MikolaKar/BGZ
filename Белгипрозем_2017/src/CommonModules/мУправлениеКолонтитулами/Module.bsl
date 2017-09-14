////////////////////////////////////////////////////////////////////////////////
// УправлениеКолонтитулами: механизм настройки и вывода колонтитулов.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Получает сохраненные ранее настройки колонтитулов. Если настройки отсутствуют, то
// возвращается пустая структура настроек.
//
// Возвращаемое значение:
//   Структура - значения настроек колонтитулов.
Функция ПолучитьНастройкиКолонтитулов() Экспорт
	
	Настройки = Неопределено;
	
	Хранилище = Константы.мНастройкиКолонтитулов.Получить();
	Если ТипЗнч(Хранилище) = Тип("ХранилищеЗначения") Тогда
		Настройки = Хранилище.Получить();
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			Если Не Настройки.Свойство("ВерхнийКолонтитул") 
				ИЛИ Не Настройки.Свойство("НижнийКолонтитул") Тогда
				Настройки = Неопределено;
			Иначе
				ДополнитьНастройкиКолонтитула(Настройки.ВерхнийКолонтитул);
				ДополнитьНастройкиКолонтитула(Настройки.НижнийКолонтитул);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Настройки = Неопределено Тогда
		Настройки = ПолучитьСтруктуруНастроек();
	КонецЕсли;
	
	Возврат Настройки;
	
КонецФункции

// Сохраняет переданные в параметре настройки колонтитулов 
// для дальнейшего использования.
//
// Параметры
//  НастройкиКолонтитулов - Структура - значения настроек колонтитулов,
//                          	которые необходимо сохранить.
Процедура СохранитьНастройкиКолонтитулов(НастройкиКолонтитулов) Экспорт
	
	Константы.мНастройкиКолонтитулов.Установить(Новый ХранилищеЗначения(НастройкиКолонтитулов));
	
КонецПроцедуры

// Устанавливает колонтитулы в табличном документе.
//
// Параметры
//  ТабличныйДокумент - ТабличныйДокумент - документ, в котором надо установить колонтитулы.
//  НазваниеОтчета    - Строка - значение, которое будет подставлено в шаблон [&НазваниеОтчета].
//  Пользователь      - СправочникСсылка.Пользователи - значение, 
//                      	которое будет подставлено в шаблон [&Пользователь].
//
Процедура УстановитьКолонтитулы(ТабличныйДокумент, НазваниеОтчета = "", Пользователь = Неопределено) Экспорт
	
	НастройкиКолонтитулов = ПолучитьНастройкиКолонтитулов();
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	ЗначенияНастроек = ПолучитьЗначенияНастроекКолонтитулов(НастройкиКолонтитулов.ВерхнийКолонтитул, НазваниеОтчета, Пользователь);
	ЗаполнитьЗначенияСвойств(ТабличныйДокумент.ВерхнийКолонтитул, ЗначенияНастроек);
	
	ЗначенияНастроек = ПолучитьЗначенияНастроекКолонтитулов(НастройкиКолонтитулов.НижнийКолонтитул, НазваниеОтчета, Пользователь);
	ЗаполнитьЗначенияСвойств(ТабличныйДокумент.НижнийКолонтитул, ЗначенияНастроек);
	
КонецПроцедуры

Функция ПолучитьЗначенияНастроекКолонтитулов(НастройкиКолонтитула, НазваниеОтчета, Пользователь) Экспорт
	
	ЗначенияНастроек = Новый Структура;
	Если ЗначениеЗаполнено(НастройкиКолонтитула.ТекстСлева)
		ИЛИ ЗначениеЗаполнено(НастройкиКолонтитула.ТекстВЦентре)
		ИЛИ ЗначениеЗаполнено(НастройкиКолонтитула.ТекстСправа) Тогда
		ЗначенияНастроек.Вставить("Выводить"             , Истина);
		ЗначенияНастроек.Вставить("НачальнаяСтраница"    , НастройкиКолонтитула.НачальнаяСтраница);
		ЗначенияНастроек.Вставить("ВертикальноеПоложение", НастройкиКолонтитула.ВертикальноеПоложение);
		ЗначенияНастроек.Вставить("ТекстСлева"           , ЗаполнитьШаблон(НастройкиКолонтитула.ТекстСлева, НазваниеОтчета, Пользователь));
		ЗначенияНастроек.Вставить("ТекстВЦентре"         , ЗаполнитьШаблон(НастройкиКолонтитула.ТекстВЦентре, НазваниеОтчета, Пользователь));
		ЗначенияНастроек.Вставить("ТекстСправа"          , ЗаполнитьШаблон(НастройкиКолонтитула.ТекстСправа, НазваниеОтчета, Пользователь));
		Если НастройкиКолонтитула.Свойство("Шрифт") И НастройкиКолонтитула.Шрифт <> Неопределено Тогда
			ЗначенияНастроек.Вставить("Шрифт", НастройкиКолонтитула.Шрифт);
		Иначе
			ЗначенияНастроек.Вставить("Шрифт", Новый Шрифт);
		КонецЕсли;
	Иначе
		ЗначенияНастроек.Вставить("Выводить", Ложь);
	КонецЕсли;
	
	Возврат ЗначенияНастроек;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ЗаполнитьШаблон(Шаблон, НазваниеОтчета, Пользователь)
	
	Результат = СтрЗаменить(Шаблон   , "[&НазваниеОтчета]", СокрЛП(НазваниеОтчета));
	Результат = СтрЗаменить(Результат, "[&Пользователь]"  , СокрЛП(Пользователь));
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСтруктуруНастроек()
	
	ВерхнийКолонтитул = Новый Структура("ТекстСлева,ТекстВЦентре,ТекстСправа,Шрифт,ВертикальноеПоложение,НачальнаяСтраница",
										"", "", "", Новый Шрифт, ВертикальноеПоложение.Низ, 0);
										
	НижнийКолонтитул = Новый Структура("ТекстСлева,ТекстВЦентре,ТекстСправа,Шрифт,ВертикальноеПоложение,НачальнаяСтраница",
										"", "", "", Новый Шрифт, ВертикальноеПоложение.Верх, 0);
										
	Настройки = Новый Структура("ВерхнийКолонтитул,НижнийКолонтитул", ВерхнийКолонтитул, НижнийКолонтитул);
	
	Возврат Настройки;
	
КонецФункции

Процедура ДополнитьНастройкиКолонтитула(НастройкиКолонтитула)
	
	Если Не НастройкиКолонтитула.Свойство("ТекстСлева")
		ИЛИ ТипЗнч(НастройкиКолонтитула.ТекстСлева) <> Тип("Строка") Тогда
		НастройкиКолонтитула.Вставить("ТекстСлева", "");
	КонецЕсли;
	Если Не НастройкиКолонтитула.Свойство("ТекстВЦентре")
		ИЛИ ТипЗнч(НастройкиКолонтитула.ТекстВЦентре) <> Тип("Строка") Тогда
		НастройкиКолонтитула.Вставить("ТекстВЦентре", "");
	КонецЕсли;
	Если Не НастройкиКолонтитула.Свойство("ТекстСправа")
		ИЛИ ТипЗнч(НастройкиКолонтитула.ТекстСправа) <> Тип("Строка") Тогда
		НастройкиКолонтитула.Вставить("ТекстСправа", "");
	КонецЕсли;
	Если Не НастройкиКолонтитула.Свойство("Шрифт")
		ИЛИ ТипЗнч(НастройкиКолонтитула.Шрифт) <> Тип("Шрифт") Тогда
		НастройкиКолонтитула.Вставить("Шрифт", Новый Шрифт);
	КонецЕсли;
	Если Не НастройкиКолонтитула.Свойство("ВертикальноеПоложение")
		ИЛИ ТипЗнч(НастройкиКолонтитула.ВертикальноеПоложение) <> Тип("ВертикальноеПоложение") Тогда
		НастройкиКолонтитула.Вставить("ВертикальноеПоложение", ВертикальноеПоложение.Центр);
	КонецЕсли;
	Если Не НастройкиКолонтитула.Свойство("НачальнаяСтраница")
		ИЛИ ТипЗнч(НастройкиКолонтитула.НачальнаяСтраница) <> Тип("Число")
		ИЛИ НастройкиКолонтитула.НачальнаяСтраница < 0 Тогда
		НастройкиКолонтитула.Вставить("НачальнаяСтраница", 0);
	КонецЕсли;	
	
КонецПроцедуры
