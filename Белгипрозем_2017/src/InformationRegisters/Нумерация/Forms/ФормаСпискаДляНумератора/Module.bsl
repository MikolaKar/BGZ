
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Нумератор", Параметры.Нумератор);
	
	Элементы.ПериодНумерации.Видимость = 
		(Параметры.Нумератор.Периодичность <> Перечисления.ПериодичностьНумераторов.Непериодический);
	
	Элементы.Организация.Видимость = 
		Параметры.Нумератор.НезависимаяНумерацияПоОрганизациям;
	
	Элементы.СвязанныйДокумент.Видимость = 
		Параметры.Нумератор.НезависимаяНумерацияПоСвязанномуДокументу;
	
КонецПроцедуры
