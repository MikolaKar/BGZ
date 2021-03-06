
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПраваПоДескриптору.Параметры.УстановитьЗначениеПараметра("Дескриптор", Объект.Ссылка);
	УникальныйИдентификаторДескриптора = Объект.Ссылка.УникальныйИдентификатор();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОбновитьПрава(Команда)
	
	ОбновитьПраваНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПраваНаСервере()
	
	Протокол = Новый Массив;
	Справочники.ДескрипторыДоступаРегистров.ОбновитьПрава(Объект.Ссылка,, Истина);
	РегистрыСведений.ОчередьОбновленияПравДоступа.Удалить(Объект.Ссылка);
	
	Элементы.ПраваПоДескриптору.Обновить();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦ ФОРМЫ

&НаКлиенте
Процедура ПраваПоДескрипторуВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

