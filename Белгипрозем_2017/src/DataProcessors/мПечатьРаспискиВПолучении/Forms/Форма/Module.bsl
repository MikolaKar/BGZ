
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    Для каждого Док Из Параметры.МассивОбъектов Цикл
    	СписокДокументов.Добавить(Док);
    КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    Закрыть();
	ПараметрыПечати = Новый Структура;
    
    МассивДокументов = СписокДокументов.ВыгрузитьЗначения();
	
	Город = мРазное.ПолучитьГородБазы();
	ИмяМакетаРасписки = "Расписка" + Город;
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
	"Обработка.мПечатьРаспискиВПолучении",
	ИмяМакетаРасписки,
	МассивДокументов,
	ВладелецФормы,
	ПараметрыПечати);	
	
КонецПроцедуры


