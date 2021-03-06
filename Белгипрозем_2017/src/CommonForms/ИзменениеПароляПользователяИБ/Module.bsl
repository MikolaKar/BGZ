
&НаКлиенте
Процедура СоздатьПароль(Команда)
	
	ЗаглавныеБуквы = "QWERTYUOPASDFGHJKLZXCVBNM"; // Без буквы I
	СтрочныеБуквы = "qwertyuiopasdfghjkzxcvbnm"; // Без буквы l
	Цифры = "1234567890";
	СпецСимволы = "@#$%^&*-=_";
	
	Пароль = "";
	
	Генератор = Новый ГенераторСлучайныхЧисел;
	
	Пока СтрДлина(Пароль) < 8 Цикл
		
		Число = Генератор.СлучайноеЧисло(1, 6);
		
		Если Число = 1 Или Число = 2 Тогда
			
			Индекс = Генератор.СлучайноеЧисло(1, СтрДлина(ЗаглавныеБуквы));
			Пароль = Пароль + Сред(ЗаглавныеБуквы, Индекс, 1);
			
		ИначеЕсли Число = 3 Или Число = 4 Тогда
			
			Индекс = Генератор.СлучайноеЧисло(1, СтрДлина(СтрочныеБуквы));
			Пароль = Пароль + Сред(СтрочныеБуквы, Индекс, 1);
			
		ИначеЕсли Число = 5 Тогда
			
			Индекс = Генератор.СлучайноеЧисло(1, СтрДлина(Цифры));
			Пароль = Пароль + Сред(Цифры, Индекс, 1);
			
		Иначе
			
			Индекс = Генератор.СлучайноеЧисло(1, СтрДлина(СпецСимволы));
			Пароль = Пароль + Сред(СпецСимволы, Индекс, 1);
			
		КонецЕсли;
		
	КонецЦикла;

	ПоказатьПароль = Истина;
	УстановитьВидимостьПолейПароля();
	
КонецПроцедуры

// Обработчик события "ПриСозданииНаСервере" формы.
// Считываются настройки пользователя ИБ
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ХранилищеСистемныхНастроек.Удалить("ОбщаяФорма.ИзменениеПароляПользователяИБ/НастройкиОкна", "", ИмяПользователя());
	
	ОбязательнаяУстановкаПароля = Параметры.Свойство("ОбязательнаяУстановкаПароля") 
								И Параметры.ОбязательнаяУстановкаПароля;
								
	Элементы.НадписьЗапретВхода.Видимость = ОбязательнаяУстановкаПароля;
	Заголовок = ?(ОбязательнаяУстановкаПароля, НСтр("ru='Установка пароля'"), НСтр("ru='Изменение пароля'"));
		
	ИзменениеПароляДоступно = ПроверитьДоступностьСменыПароляПользователю();
	
КонецПроцедуры

// Обработчик события формы "ПриОткрытии".
// Если при формировании данных возникли ошибки, то необходимо
// сообщить о них пользователю.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ИзменениеПароляДоступно = Ложь Тогда
		
		ПоказатьПредупреждение(, ТекстЗапретаИзмененияПароля,, НСтр("ru = 'Смена пароля'"));
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	УстановитьВидимостьПолейПароля();
	
КонецПроцедуры

// Функция проверяет флаг ЗапрещеноИзменятьПароль у текущего
// пользователя ИБ.
//
// Возвращаемое значение
// Истина        - смена пароля доступна
// Ложь          - смена пароля недоступна (либо потому что пользователю запрещено
//                 изменять пароль, либо потому что не установлена стандартая
//                 аутентификация)
//
&НаСервере
Функция ПроверитьДоступностьСменыПароляПользователю()
	
	ИзменениеПароляДоступно = Истина;
	
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	
	Если НЕ ЗначениеЗаполнено(ПользовательИБ.Имя) Тогда
		ТекстЗапретаИзмененияПароля = 
			НСтр("ru = 'Текущий пользователь не определен. Изменение пароля невозможно. 
			|Обратитесь к администратору.'");
		ИзменениеПароляДоступно = Ложь;
	ИначеЕсли НЕ ПользовательИБ.АутентификацияСтандартная Тогда
		ТекстЗапретаИзмененияПароля = 
			НСтр("ru = 'Изменение пароля не требуется, т.к. используется аутентификация операционной системы.'");
		ИзменениеПароляДоступно = Ложь;
	ИначеЕсли ПользовательИБ.ЗапрещеноИзменятьПароль Тогда
		ТекстЗапретаИзмененияПароля = 
			НСтр("ru = 'Изменение пароля запрещено. Обратитесь к администратору.'");
		ИзменениеПароляДоступно = Ложь;
	КонецЕсли;
	
	Возврат ИзменениеПароляДоступно;
	
КонецФункции

// Обработчик события нажатия на кнопку "Сменить пароль".
//
&НаКлиенте
Процедура СменитьПарольВыполнить()
	
	ОчиститьСообщения();
	
	Если ОбязательнаяУстановкаПароля И Пароль = "" Тогда
		ТекстОшибки = НСтр("ru = 'Не заполнен пароль'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Пароль");
		Возврат
	КонецЕсли;
	
	Если Не ПоказатьПароль И Пароль <> ПодтверждениеПароля Тогда
		ТекстОшибки = НСтр("ru = 'Подтверждение не совпадает с паролем'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "ПодтверждениеПароля");
		Возврат
	КонецЕсли;
	
	СменитьПарольПользователяИБ(Пароль);

	Закрыть(Истина);
	
КонецПроцедуры

// Функция меняет пароль пользователя ИБ.
// При невозможности записать пользоателя вызывается исключение
// с описанием ошибки.
//
// Возвращаемое значение
// Истина - пароль был изменен
// Ложь   - пароль не был изменен (произошла ошибка записи)
//
&НаСервереБезКонтекста
Процедура СменитьПарольПользователяИБ(Пароль)
	
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	ПользовательИБ.Пароль = Пароль;
	ПользовательИБ.Записать();
	
КонецПроцедуры

// Обработчик события ПриИзменении флажка ПоказатьПароль
&НаКлиенте
Процедура ПоказатьПарольПриИзменении(Элемент)
	
	УстановитьВидимостьПолейПароля();
	
	Если ПоказатьПароль Тогда
		ПодтверждениеПароля = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьПолейПароля()
	
	Элементы.СтраницаОткрытыйПароль.Видимость = ПоказатьПароль;
	Элементы.СтраницаСкрытыйПароль.Видимость = Не ПоказатьПароль;
	
КонецПроцедуры
