
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
    СтандартнаяОбработка = Ложь;
    
    // Вывод строки Организация
    мОтчетыВызовСервера.ВывестиНазваниеОрганизацииВОтчет(ДокументРезультат);
    
    мУправлениеКолонтитулами.УстановитьКолонтитулы(ДокументРезультат, "мОтправленоНоНеЗаактировано");
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ДокументРезультат.АвтоМасштаб = Истина;
	ДокументРезультат.НижнийКолонтитул.Выводить = Истина;
	ДокументРезультат.НижнийКолонтитул.ТекстСправа = "Стр. [&НомерСтраницы] из [&СтраницВсего]";
	ДокументРезультат.НижнийКолонтитул.НачальнаяСтраница = 2;
  	ДокументРезультат.КлючПараметровПечати = "мОтправленоНоНеЗаактировано";
    
    // Вывод Заголовка отчета
    мОтчетыВызовСервера.ВывестиЗаголовокВОтчет(КомпоновщикНастроек, ДокументРезультат);
        
    // Вывод Периода отчета
    мОтчетыВызовСервера.ВывестиПериодВОтчет(КомпоновщикНастроек, ДокументРезультат);
    
    // Вывод Параметров отчета
    СтруктураПараметровДляВывода = Новый Структура("Подразделение");
    мОтчетыВызовСервера.ВывестиПараметрыВОтчет(КомпоновщикНастроек, СтруктураПараметровДляВывода, ДокументРезультат);
    
    // Програмный вывод СКД
    мОтчетыВызовСервера.ВывестиТелоОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДанныеРасшифровки, ДокументРезультат);
    
    // Вывод Подпись ответственного
    мОтчетыВызовСервера.ВывестиПодписьВОтчет(ДокументРезультат);

КонецПроцедуры
