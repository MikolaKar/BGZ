
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьВидимость();
	
	РеквизитыКарточки = Истина;
	ДопРеквизиты = Истина;
	ПриложенныеФайлы = Истина;
	ВерсииФайлов = Ложь;
	ЭП = Ложь;
	СвязанныеДокументы = Истина;
	ЖурналПередачи = Истина;
	Этапы = Истина;
	Согласование = Истина;
	Утверждение = Истина;
	Ознакомление = Истина;
	Поручения = Истина;
	Задачи = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("РеквизитыКарточки", РеквизитыКарточки);
	ПараметрыПечати.Вставить("ДопРеквизиты", ДопРеквизиты);
	ПараметрыПечати.Вставить("ПриложенныеФайлы", ПриложенныеФайлы);
	ПараметрыПечати.Вставить("ВерсииФайлов", ВерсииФайлов);
	ПараметрыПечати.Вставить("ЭП", ЭП);
	ПараметрыПечати.Вставить("СвязанныеДокументы", СвязанныеДокументы);
	ПараметрыПечати.Вставить("ЖурналПередачи", ЖурналПередачи);
	ПараметрыПечати.Вставить("Этапы", Этапы);
	
	ПараметрыПечати.Вставить("Согласование", Согласование);
	ПараметрыПечати.Вставить("Утверждение", Утверждение);
	ПараметрыПечати.Вставить("Ознакомление", Ознакомление);
	ПараметрыПечати.Вставить("Поручения", Поручения);
	ПараметрыПечати.Вставить("Задачи", Задачи);
	
	Закрыть();
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Справочник.ИсходящиеДокументы",
		"Карточка",
		Параметры.ПараметрКоманды,
		ВладелецФормы,
		ПараметрыПечати);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсеФлажки()
	
	УстановкаПометок(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеФлажки()
	
	УстановкаПометок(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаПометок(Значение)

	РеквизитыКарточки = Значение;
	ДопРеквизиты = Значение; 
	ЖурналПередачи = Значение;
	СвязанныеДокументы = Значение;
	ЭП = Значение;
	ВерсииФайлов = Значение;
	ПриложенныеФайлы = Значение;
	Этапы = Значение;
	Согласование = Значение;
	Утверждение = Значение;
	Ознакомление = Значение;
	Поручения = Значение;
	Задачи = Значение;

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	ИспользоватьЭтапы = Ложь;
	
	Для Каждого Параметр Из Параметры.ПараметрКоманды Цикл
		РеквизитыПараметра = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Параметр, 
			"ВидДокумента.ИспользоватьЭтапыОбработкиДокумента");
		
		Если РеквизитыПараметра.ВидДокументаИспользоватьЭтапыОбработкиДокумента Тогда
			ИспользоватьЭтапы = Истина;
		КонецЕсли;
	КонецЦикла;		
	
	Элементы.Этапы.Видимость = ИспользоватьЭтапы;
	
КонецПроцедуры	