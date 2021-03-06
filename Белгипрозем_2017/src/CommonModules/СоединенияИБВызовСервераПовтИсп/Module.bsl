////////////////////////////////////////////////////////////////////////////////
// Подсистема "Завершение работы пользователей".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру с параметрами для принудительного отключения сеансов.
//
Функция ПараметрыОтключенияСеансов() Экспорт
	
	ТипПлатформыСервера = ОбщегоНазначенияПовтИсп.ТипПлатформыСервера();
	
	Возврат Новый Структура("НомерСеансаИнформационнойБазы,WindowsПлатформаНаСервере",
		НомерСеансаИнформационнойБазы(),
		ТипПлатформыСервера = ТипПлатформы.Windows_x86
			Или ТипПлатформыСервера = ТипПлатформы.Windows_x86_64);
	
КонецФункции

#КонецОбласти
