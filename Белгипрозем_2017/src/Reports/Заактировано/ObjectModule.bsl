
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
    СтандартнаяОбработка = Ложь;
    
    // Вывод строки Организация
    мОтчетыВызовСервера.ВывестиНазваниеОрганизацииВОтчет(ДокументРезультат);
    
    мУправлениеКолонтитулами.УстановитьКолонтитулы(ДокументРезультат, "Заактировано");
    
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ДокументРезультат.АвтоМасштаб = Истина;
	ДокументРезультат.НижнийКолонтитул.Выводить = Истина;
	ДокументРезультат.НижнийКолонтитул.ТекстСправа = "Стр. [&НомерСтраницы] из [&СтраницВсего]";
	ДокументРезультат.НижнийКолонтитул.НачальнаяСтраница = 2;
    
    // Вывод Заголовка отчета
    мОтчетыВызовСервера.ВывестиЗаголовокВОтчет(КомпоновщикНастроек, ДокументРезультат);
        
    // Вывод Периода отчета
    мОтчетыВызовСервера.ВывестиПериодВОтчет(КомпоновщикНастроек, ДокументРезультат);
    
    // Вывод Параметров отчета
    СтруктураПараметровДляВывода = Новый Структура("СписокКорреспондентов");
    мОтчетыВызовСервера.ВывестиПараметрыВОтчет(КомпоновщикНастроек, СтруктураПараметровДляВывода, ДокументРезультат);
    
    // ПовторятьПриПечатиСтроки шапки
    НачСтрока = ДокументРезультат.ВысотаТаблицы+1;
    КонСтрока = НачСтрока + 3;
	ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область(НачСтрока,,КонСтрока,);
    
    // Програмный вывод СКД
    мОтчетыВызовСервера.ВывестиТелоОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДанныеРасшифровки, ДокументРезультат);
    
    // Вывод Подписи
    мОтчетыВызовСервера.ВывестиПодписиВОтчет(КомпоновщикНастроек, ДокументРезультат);
    
КонецПроцедуры
