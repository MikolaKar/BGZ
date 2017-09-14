#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции

Процедура ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ВопросДеятельности = ОбъектДоступа.Ссылка;
	
КонецПроцедуры

Функция ПолучитьСтруктуруВопросаДеятельности() Экспорт
	
	ПараметрыВопросаДеятельности = Новый Структура;
	ПараметрыВопросаДеятельности.Вставить("Наименование");
	
	Возврат ПараметрыВопросаДеятельности;
	
КонецФункции

Функция СоздатьВопросДеятельности(СтруктураВопросаДеятельности) Экспорт
	
	НовыйЭлемент = СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовыйЭлемент, СтруктураВопросаДеятельности);
	НовыйЭлемент.Записать();
	
	Возврат НовыйЭлемент.Ссылка;
	
КонецФункции

#КонецОбласти

#КонецЕсли
