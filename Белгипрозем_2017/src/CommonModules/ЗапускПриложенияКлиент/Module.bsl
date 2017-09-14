
Функция ИмяАдминистратораПоУмолчанию() Экспорт
	Возврат "Admin";
КонецФункции

// Запускает предприятие с параметрами текущего сенса
//
// Параметры
//  Пользователь - Строка - Имя пользователя под которым будет запущен новый сеанс
//  СтрокаЗапука - Строка - Параметр запуска обработки xUnitFor1C, первым параметром ожидается путь к обработке
//
Процедура ЗапуститьСистемуПовторно(Пользователь, СтрокаЗапуска = "") Экспорт
	
	ДополнительныеПараметрыЗапуска = "/N" + Пользователь;
	ЗапуститьСистему(ДополнительныеПараметрыЗапуска);
	
КонецПроцедуры
