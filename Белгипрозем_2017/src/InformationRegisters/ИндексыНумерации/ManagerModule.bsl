
// Устанавливает значение индекса для переданного объекта.
//
Процедура ЗаписатьИндексНумерации(Объект, Индекс) Экспорт
	
	Запись = РегистрыСведений.ИндексыНумерации.СоздатьМенеджерЗаписи();
	Запись.Объект = Объект;
	Запись.Прочитать();
	
	Запись.Объект = Объект;
	Запись.Индекс = Индекс;
	Запись.Записать(Истина);
	
КонецПроцедуры