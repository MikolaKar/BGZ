// Заполняет переданный дескриптор доступа

// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ПолучитьЗначенияРеквизитов()
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции

Процедура ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	Строка = ДескрипторДоступа.Корреспонденты.Добавить();
	Строка.ГруппаДоступа = ОбъектДоступа.Ссылка;
	
КонецПроцедуры
