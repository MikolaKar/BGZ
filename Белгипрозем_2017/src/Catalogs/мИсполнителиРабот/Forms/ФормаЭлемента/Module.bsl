&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	Объект.Наименование = ПолучитьПредставлениеПользователя(Объект.Пользователь);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПредставлениеПользователя(Пользователь)
    Возврат Пользователь.ПредставлениеВДокументах;	
КонецФункции


