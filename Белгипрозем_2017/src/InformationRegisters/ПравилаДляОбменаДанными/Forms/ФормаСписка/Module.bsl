
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьВсеТиповыеПравила(Команда)
	
	ОбновитьВсеТиповыеПравилаНаСервере();
	Элементы.Список.Обновить();
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Обновление правил успешно завершено.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьВсеТиповыеПравилаНаСервере()
	
	ОбменДаннымиСервер.ВыполнитьОбновлениеПравилДляОбменаДанными();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти
