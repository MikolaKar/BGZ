
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Делает запись в регистр.
//
// Параметры:
//  Объект - задача/письмо для которой необходимо установить флаг
//  Пользователь - СправочникСсылка.Пользователи - пользователь, установивший флаг
//  Флаг - ПеречислениеСсылка.ФлагиОбъектов - флаг
//
Процедура УстановитьФлаг(Объект, Пользователь, Флаг) Экспорт
	
	Запись = РегистрыСведений.ФлагиОбъектов.СоздатьМенеджерЗаписи();
	Запись.Объект = Объект;
	Запись.Пользователь = Пользователь;
	Запись.Флаг = Флаг;
	Запись.Записать(Истина);
	
КонецПроцедуры

// Очищает запись.
//
// Параметры:
//  Объект - задача/письмо для которой необходимо очисть флаг
//  Пользователь - СправочникСсылка.Пользователи - пользователь, установивший флаг
//
Процедура ОчиститьФлаг(Объект, Пользователь) Экспорт
	
	Запись = РегистрыСведений.ФлагиОбъектов.СоздатьМенеджерЗаписи();
	Запись.Объект = Объект;
	Запись.Пользователь = Пользователь;
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		Запись.Удалить();
	КонецЕсли;
	
КонецПроцедуры

// Получает значение флага объекта установленного пользователем.
//
// Параметры:
//   Объект - задача/письмо для которой необходимо получить значение флага
//   Пользователь - СправочникСсылка.Пользователи - пользователь, установивший флаг
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ФлагиОбъектов
//
Функция ПолучитьФлаг(Объект, Пользователь) Экспорт
	
	Флаг = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ФлагиОбъектов.Флаг
		|ИЗ
		|	РегистрСведений.ФлагиОбъектов КАК ФлагиОбъектов
		|ГДЕ
		|	ФлагиОбъектов.Объект = &Объект
		|	И ФлагиОбъектов.Пользователь = &Пользователь";
		
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Объект", Объект);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Флаг = Выборка.Флаг;
	КонецЕсли;
	
	Возврат Флаг;
	
КонецФункции

// Если у Объекта установлен флаг то очищает его,
// иначе устанавливает.
//
// Параметры:
//  Объект - задача/письмо для которой необходимо переключить флаг
//  Пользователь - СправочникСсылка.Пользователи - пользователь, установивший флаг
//  Флаг - ПеречислениеСсылка.ФлагиОбъектов - новое значение флага, на которое следует
//         заменить текущее.
//
Процедура ПереключитьФлаг(Объект, Пользователь, Флаг) Экспорт
	
	Запись = РегистрыСведений.ФлагиОбъектов.СоздатьМенеджерЗаписи();
	Запись.Объект = Объект;
	Запись.Пользователь = Пользователь;
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		Запись.Удалить();
	Иначе
		Запись.Объект = Объект;
		Запись.Пользователь = Пользователь;
		Запись.Флаг = Флаг;
		Запись.Записать(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий
//Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//Код процедур и функций
#КонецОбласти

#КонецЕсли
