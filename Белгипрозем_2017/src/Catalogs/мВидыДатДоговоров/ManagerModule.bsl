
// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ПолучитьЗначенияРеквизитов()
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции
// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ВладелецОбъекта = ОбъектДоступа.Ссылка;
	ДескрипторДоступа.ВидОбъекта = ОбъектДоступа.Ссылка;
	
КонецПроцедуры	
