// УправлениеДоступом

// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ПолучитьЗначенияРеквизитов()
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "";
	
КонецФункции

// Заполняет переданный дескриптор доступа
//
Процедура ЗаполнитьДескрипторДоступа(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
		
КонецПроцедуры

// Возвращает Истина, указывая тем самы что этот объект сам заполняет права 
// доступа для файлов, владельцем которых является
Функция ЕстьМетодЗаполнитьПраваДоступаДляФайлов() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет параметр ПраваДоступа правами доступа к файлам, владелец 
// которых имеет указанный дескриптор
Процедура ЗаполнитьПраваДоступаДляФайлов(ДескрипторОбъектаДоступа, ПраваДоступа) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Права на изменение
	Таблица = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ВходящееСообщениеСВД");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПраваГруппДоступаНаТаблицы.ГруппаДоступа
		|ПОМЕСТИТЬ ГруппыДоступа
		|ИЗ
		|	РегистрСведений.ПраваГруппДоступаНаТаблицы КАК ПраваГруппДоступаНаТаблицы
		|ГДЕ
		|	ПраваГруппДоступаНаТаблицы.Таблица = &Таблица
		|	И ПраваГруппДоступаНаТаблицы.Изменение = ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ГруппыДоступаПользователи.Пользователь КАК Пользователь
		|ИЗ
		|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ГруппыДоступа КАК ГруппыДоступа
		|		ПО ГруппыДоступаПользователи.Ссылка = ГруппыДоступа.ГруппаДоступа";
	
	Запрос.УстановитьПараметр("Таблица", Таблица);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПраваПользователя = Новый Структура("Чтение, Добавление, Изменение, Удаление, УправлениеПравами",
										Истина, Истина, Истина, Истина, Ложь);
		
		ДокументооборотПраваДоступа.ДобавитьПользователяВСоответствиеПрав(
			ПраваДоступа,
			Выборка.Пользователь,
			Неопределено,
			Неопределено,
			ПраваПользователя);
		
	КонецЦикла;	
			
КонецПроцедуры

// Конец УправлениеДоступом