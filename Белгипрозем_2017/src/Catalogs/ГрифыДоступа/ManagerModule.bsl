// Заполняет переданный дескриптор доступа 

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции

Процедура ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ГрифДоступа = ОбъектДоступа.Ссылка;
	
КонецПроцедуры