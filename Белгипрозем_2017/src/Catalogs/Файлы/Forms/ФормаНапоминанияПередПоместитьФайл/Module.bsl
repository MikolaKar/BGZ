&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БольшеНеПоказывать = Ложь;
	
	ТекстНапоминания = 
	НСтр("ru = 'Сейчас вам будет предложено выбрать файл для того, чтобы поместить его в информационную базу и закончить редактирование.
	           |Найдите нужный файл в том каталоге, который вы указывали ранее при начале редактирования.'");
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Закрыть(БольшеНеПоказывать);
КонецПроцедуры
