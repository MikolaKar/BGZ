////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Серверные процедуры и функции общего назначения:
// - Поддержка работы с включенными профилями безопасности
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Функции-конструкторы разрешений
//

// Возвращает внутреннее описание разрешения на использование каталога файловой системы.
//
// Параметры:
//  Адрес - Строка - адрес ресурса файловой системы,
//  ЧтениеДанных - Булево - флаг, указывающий необходимость предоставления разрешения
//    на чтение данных из данного каталога файловой системы,
//  ЗаписьДанных - Булево - флаг, указывающий необходимость предоставления разрешения
//    на запись данных в указанный каталог файловой системы,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеКаталогаФайловойСистемы(Знач Адрес, Знач ЧтениеДанных = Ложь, Знач ЗаписьДанных = Ложь, Знач Описание = "") Экспорт
	
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет(), "FileSystemAccess"));
	Результат.Description = Описание;
	
	Если Прав(Адрес, 1) = "\" Или Прав(Адрес, 1) = "/" Тогда
		Адрес = Лев(Адрес, СтрДлина(Адрес) - 1);
	КонецЕсли;
	
	Результат.Path = Адрес;
	Результат.AllowedRead = ЧтениеДанных;
	Результат.AllowedWrite = ЗаписьДанных;
	
	Возврат Результат;
	
КонецФункции

// Возвращает внутреннее описание разрешения на использование каталога временных файлов.
//
// Параметры:
//  ЧтениеДанных - Булево - флаг, указывающий необходимость предоставления разрешения
//    на чтение данных из каталога временных файлов,
//  ЗаписьДанных - Булево - флаг, указывающий необходимость предоставления разрешения
//    на запись данных в каталог временных файлов,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеКаталогаВременныхФайлов(Знач ЧтениеДанных = Ложь, Знач ЗаписьДанных = Ложь, Знач Описание = "") Экспорт
	
	Возврат РазрешениеНаИспользованиеКаталогаФайловойСистемы(ПсевдонимКаталогаВременныхФайлов(), ЧтениеДанных, ЗаписьДанных);
	
КонецФункции

// Возвращает внутреннее описание разрешения на использование каталога программы.
//
// Параметры:
//  ЧтениеДанных - Булево - флаг, указывающий необходимость предоставления разрешения
//    на чтение данных из каталога программы,
//  ЗаписьДанных - Булево - флаг, указывающий необходимость предоставления разрешения
//    на запись данных в каталог программы,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеКаталогаПрограммы(Знач ЧтениеДанных = Ложь, Знач ЗаписьДанных = Ложь, Знач Описание = "") Экспорт
	
	Возврат РазрешениеНаИспользованиеКаталогаФайловойСистемы(ПсевдонимКаталогаПрограммы(), ЧтениеДанных, ЗаписьДанных);
	
КонецФункции

// Возвращает внутреннее описание разрешения на использование COM-класса.
//
// Параметры:
//  ProgID - Строка - ProgID класса COM, с которым он зарегистрирован в системе.
//    Например, "Excel.Application",
//  CLSID - Строка - CLSID класса COM, с которым он зарегистрирован в системе.
//  ИмяКомпьютера - Строка - имя компьютера, на котором надо создать указанный объект.
//    Если параметр опущен - объект будет создан на компьютере, на котором выполняется
//    текущий рабочий процесс,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаСозданиеCOMКласса(Знач ProgID, Знач CLSID, Знач ИмяКомпьютера = "", Знач Описание = "") Экспорт
	
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет(), "CreateComObject"));
	Результат.Description = Описание;
	
	Результат.ProgId = ProgID;
	Результат.CLSID = Строка(CLSID);
	Результат.ComputerName = ИмяКомпьютера;
	
	Возврат Результат;
	
КонецФункции

// Возвращает внутренее описание разрешения на использование внешней компоненты, поставляемой
//  в общем макете конфигурации.
//
// Параметры:
//  ИмяМакета - Строка - имя общего макета в конфигурации, в котором поставляется внешняя
//    компонента,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеВнешнейКомпоненты(Знач ИмяМакета, Знач Описание = "") Экспорт
	
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет(), "AttachAddin"));
	Результат.Description = Описание;
	
	Результат.TemplateName = ИмяМакета;
	
	Возврат Результат;
	
КонецФункции

// Возвращает внутренее описание разрешения на использование приложения операционной системы.
//
// Параметры:
//  ШаблонСтрокиЗапуска - Строка - шаблон строки запуска приложения. Подробнее см. документацию
//    к платформе,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеПриложенияОперационнойСистемы(Знач ШаблонСтрокиЗапуска, Знач Описание = "") Экспорт
	
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет(), "RunApplication"));
	Результат.Description = Описание;
	
	Результат.CommandMask = ШаблонСтрокиЗапуска;
	
	Возврат Результат;
	
КонецФункции

// Возвращает внутренее описание разрешения на использование интернет-ресурса.
//
// Параметры:
//  Протокол: Строка - протокол, по которому выполняется взаимодействие с ресурсом. Допустимые
//    значения:
//      IMAP,
//      POP3,
//      SMTP,
//      HTTP,
//      HTTPS,
//      FTP,
//      FTPS,
//  Адрес - Строка - адрес ресурса без указания протокола,
//  Порт - Число - номер порта через который выполняется взаимодействие с ресурсом,
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение:
//  ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеИнтернетРесурса(Знач Протокол, Знач Адрес, Знач Порт = Неопределено, Знач Описание = "") Экспорт
	
	Если Порт = Неопределено Тогда
		СтандартныеПорты = СтандартныеПортыИнтернетПротоколов();
		Если СтандартныеПорты.Свойство(ВРег(Протокол)) <> Неопределено Тогда
			Порт = СтандартныеПорты[ВРег(Протокол)];
		КонецЕсли;
	КонецЕсли;
	
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет(), "InternetResourceAccess"));
	Результат.Description = Описание;
	
	Результат.Protocol = Протокол;
	Результат.Host = Адрес;
	Результат.Port = Порт;
	
	Возврат Результат;
	
КонецФункции

// Возвращает внутренее описание разрешения на расширенную работу с данными (включая установку
// привилегированного режима) для внешних модулей.
//
// Параметры:
//  Описание - Строка - описание причины, по которой требуется предоставление разрешения.
//
// Возвращаемое значение: ОбъектXDTO - внутреннее описание запрашиваемого разрешения.
//  Предназначен только для передачи в качестве параметра в функции
//  РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(),
//  РаботаВБезопасномРежиме.ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов() и
//  РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов().
//
Функция РазрешениеНаИспользованиеПривилегированногоРежима(Знач Описание = "") Экспорт
	
	Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(Пакет(), "ExternalModulePrivilegedModeAllowed"));
	Результат.Description = Описание;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции создания запросов на использование внешних ресурсов
//

// Создает запрос на использование внешних ресурсов.
//
// Параметры:
//  НовыеРазрешения - Массив(ОбъектXDTO) - массив ОбъектовXDTO, соответствующих внутренним описаниям
//    запрашиваемых разрешений на доступ к внешним ресурсам. Предполагается, что все ОбъектыXDTO, передаваемые
//    в качестве параметра, сформированы с помощью вызова функций РаботаВБезопасномРежиме.Разрешение*().
//  Владелец - ЛюбаяСсылка - ссылка на объект информационной базы, с которой логически связаны запрашиваемые
//    разрешения. Например, все разрешения на доступ к каталогам томов хранения файлов логически связаны
//    с соответствующими элементами справочника ТомаХраненияФайлов, все разрешения на доступ к каталогам
//    обмена данными (или к другим ресурсам в зависимости от используемого транспорта обмена) логически
//    связаны с соответствующими узлами планов обмена и т.д. В том случае, если разрешение является логически
//    обособленным (например, предоставление разрешения регулируется значением константы с типом Булево) -
//    рекомендуется использовать ссылку на элемент справочника ИдентификаторыОбъектовМетаданных,
//  РежимЗамещения - Булево - определяет режим замещения ранее выданных разрешений для данного владельца. При
//    значении параметра равным Истина, помимо предоставления запрошенных разрешений в запрос будет добавлена
//    очистка всех разрешений, ранее запрошенных для этого же владельца.
//
// Возвращаемое значение:
//  УникальныйИдентификатор, ссылка на записанный в ИБ запрос разрешений. После создания
//  всех запросов на изменение разрешений требуется применить запрошенные изменения с помощью вызова процедуры
//  РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов().
//
Функция ЗапросНаИспользованиеВнешнихРесурсов(Знач НовыеРазрешения, Знач Владелец = Неопределено, Знач РежимЗамещения = Истина) Экспорт
	
	Возврат РаботаВБезопасномРежимеСлужебный.ЗапросНаИзменениеРазрешенийИспользованияВнешнихРесурсов(
		Владелец,
		РежимЗамещения,
		НовыеРазрешения);
	
КонецФункции

// Создает запрос на отмену разрешений использования внешних ресурсов.
//
// Параметры:
//  Владелец - ЛюбаяСсылка - ссылка на объект информационной базы, с которой логически связаны отменяемые
//    разрешения. Например, все разрешения на доступ к каталогам томов хранения файлов логически связаны
//    с соответствующими элементами справочника ТомаХраненияФайлов, все разрешения на доступ к каталогам
//    обмена данными (или к другим ресурсам в зависимости от используемого транспорта обмена) логически
//    связаны с соответствующими узлами планов обмена и т.д. В том случае, если разрешение является логически
//    обособленным (например, отменяемые разрешения регулируется значением константы с типом Булево) -
//    рекомендуется использовать ссылку на элемент справочника ИдентификаторыОбъектовМетаданных,
//  ОтменяемыеРазрешения - Массив(ОбъектXDTO) - массив ОбъектовXDTO, соответствующих внутренним описаниям
//    отменяемых разрешений на доступ к внешним ресурсам. Предполагается, что все ОбъектыXDTO, передаваемые
//    в качестве параметра, сформированы с помощью вызова функций РаботаВБезопасномРежиме.Разрешение*().
//
// Возвращаемое значение:
//  УникальныйИдентификатор, ссылка на записанный в ИБ запрос разрешений. После создания
//  всех запросов на изменение разрешений требуется применить запрошенные изменения с помощью вызова процедуры
//  РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов().
//
Функция ЗапросНаОтменуРазрешенийИспользованияВнешнихРесурсов(Знач Владелец, Знач ОтменяемыеРазрешения) Экспорт
	
	Возврат РаботаВБезопасномРежимеСлужебный.ЗапросНаИзменениеРазрешенийИспользованияВнешнихРесурсов(
		Владелец,
		Ложь,
		,
		ОтменяемыеРазрешения);
	
КонецФункции

// Создает запрос на отмену всех разрешений использования внешних ресурсов, связанных в владельцем.
//
// Параметры:
//  Владелец - ЛюбаяСсылка - ссылка на объект информационной базы, с которой логически связаны отменяемые
//    разрешения. Например, все разрешения на доступ к каталогам томов хранения файлов логически связаны
//    с соответствующими элементами справочника ТомаХраненияФайлов, все разрешения на доступ к каталогам
//    обмена данными (или к другим ресурсам в зависимости от используемого транспорта обмена) логически
//    связаны с соответствующими узлами планов обмена и т.д. В том случае, если разрешение является логически
//    обособленным (например, отменяемые разрешения регулируется значением константы с типом Булево) -
//    рекомендуется использовать ссылку на элемент справочника ИдентификаторыОбъектовМетаданных.
//
// Возвращаемое значение:
//  УникальныйИдентификатор, ссылка на записанный в ИБ запрос разрешений. После создания
//  всех запросов на изменение разрешений требуется применить запрошенные изменения с помощью вызова процедуры
//  РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов().
//
Функция ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(Знач Владелец) Экспорт
	
	Возврат РаботаВБезопасномРежимеСлужебный.ЗапросНаИзменениеРазрешенийИспользованияВнешнихРесурсов(
		Владелец,
		Истина);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функции для поддержки работы конфигурации с профилем безопасности, в котором
// запрещено подключение внешних модулей без установки безопасного режима
//

// Проверят установленность безопасного режима, игнорируя безопасный режим профиля безопасности,
//  использующегося в качестве профиля безопасности с уровнем привилегий конфигурации.
//
// Возвращаемое значение: Булево.
//
Функция УстановленБезопасныйРежим() Экспорт
	
	ТекущийБезопасныйРежим = БезопасныйРежим();
	
	Если ТипЗнч(ТекущийБезопасныйРежим) = Тип("Строка") Тогда
		
		Если Не ДоступенПереходВПривилегированныйРежим() Тогда
			Возврат Истина; // В небезопасном режиме переход в привилегированный режим всегда доступен.
		КонецЕсли;
		
		Попытка
			ПрофильКонфигурации = ПрофильСПривилегиямиКонфигурации();
		Исключение
			Возврат Истина;
		КонецПопытки;
		
		Возврат (ТекущийБезопасныйРежим <> ПрофильКонфигурации);
		
	ИначеЕсли ТипЗнч(ТекущийБезопасныйРежим) = Тип("Булево") Тогда
		
		Возврат ТекущийБезопасныйРежим;
		
	КонецЕсли;
	
КонецФункции

// Вычисляет переданное выражение, предварительно устанавливая безопасный режим выполнения кода
//  и безопасный режим разделения данных для всех разделителей, присутствующих в составе конфигурации.
//  В результате при вычислении выражения:
//   - игнорируются попытки установки привилегированного режима,
//   - запрещаются все внешние (по отношению к платформе 1С:Предприятие) действия (COM,
//       загрузка внешних компонент, запуск внешних приложений и команд операционной системы,
//       доступ к файловой системе и Интернет-ресурсам),
//   - запрещается отключение использования разделителей сеанса,
//   - запрещается изменение значений разделителей сеанса (если разделение данным разделителем не
//       является условно выключенным),
//   - запрещается изменение объектов, которые управляют состоянием условного разделения.
//
// Параметры:
//  Выражение - Строка - выражение, которое требуется вычислить,
//  Параметры - Произвольный - в качестве значения данного параметра может быть передано значение,
//    которое требуется для вычисления выражения (при этом в тексте выражения обращение к данному
//    значению должно осуществляться как к имени переменной Параметры).
//
// Возвращаемое значение: Произвольный - результат вычисления выражения.
//
Функция ВычислитьВБезопасномРежиме(Знач Выражение, Знач Параметры = Неопределено) Экспорт
	
	УстановитьБезопасныйРежим(Истина);
	
	МассивРазделителей = РаботаВБезопасномРежимеСлужебныйПовтИсп.МассивРазделителей();
	
	Для Каждого ИмяРазделителя Из МассивРазделителей Цикл
		
		УстановитьБезопасныйРежимРазделенияДанных(ИмяРазделителя, Истина);
		
	КонецЦикла;
	
	Возврат Вычислить(Выражение);
	
КонецФункции

// Выполняет произвольный алгоритм на встроенном языке 1С:Предприятия, предварительно устанавливая
//  безопасный режим выполнения кода и безопасный режим разделения данных для всех разделителей,
//  присутствующих в составе конфигурации. В результате при выполнении алгоритма:
//   - игнорируются попытки установки привилегированного режима,
//   - запрещаются все внешние (по отношению к платформе 1С:Предприятие) действия (COM,
//       загрузка внешних компонент, запуск внешних приложений и команд операционной системы,
//       доступ к файловой системе и Интернет-ресурсам),
//   - запрещается отключение использования разделителей сеанса,
//   - запрещается изменение значений разделителей сеанса (если разделение данным разделителем не
//       является условно выключенным),
//   - запрещается изменение объектов, которые управляют состоянием условного разделения.
//
// Параметры:
//  Алгоритм - Строка - содержащая произвольный алгоритм на встроенном языке 1С:Предприятия.
//  Параметры - Произвольный - в качестве значения данного параметра может быть передано значение,
//    которое требуется для выполнения алгоритма (при этом в тексте алгоритма обращение к данному
//    значению должно осуществляться как к имени переменной Параметры).
//
Процедура ВыполнитьВБезопасномРежиме(Знач Алгоритм, Знач Параметры = Неопределено) Экспорт
	
	УстановитьБезопасныйРежим(Истина);
	
	МассивРазделителей = РаботаВБезопасномРежимеСлужебныйПовтИсп.МассивРазделителей();
	
	Для Каждого ИмяРазделителя Из МассивРазделителей Цикл
		
		УстановитьБезопасныйРежимРазделенияДанных(ИмяРазделителя, Истина);
		
	КонецЦикла;
	
	Выполнить Алгоритм;
	
КонецПроцедуры

// Выполнить экспортную процедуру по имени с уровнем привилегий конфигурации.
// При включении профилей безопасности для вызова оператора Выполнить() используется
// переход в безопасный режим с профилем безопасности, используемом для самой конфигурации
// (если выше по стеку не был установлен другой безопасный режим).
//
// Параметры
//  ИмяЭкспортнойПроцедуры – Строка – имя экспортной процедуры в формате 
//                                    <имя объекта>.<имя процедуры>, где <имя объекта> - это
//                                    общий модуль или модуль менеджера объекта.
// Параметры               - Массив - параметры передаются в процедуру <ИмяЭкспортнойПроцедуры>
//                                    в порядке расположения элементов массива.
// 
// Пример:
//  Параметры = Новый Массив();
//  Параметры.Добавить("1");
//  РаботаВБезопасномРежиме.ВыполнитьМетодКонфигурации("МойОбщийМодуль.МояПроцедура", Параметры);
//
Процедура ВыполнитьМетодКонфигурации(Знач ИмяЭкспортнойПроцедуры, Знач Параметры = Неопределено) Экспорт
	
	ПроверитьИмяМетодаКонфигурации(ИмяЭкспортнойПроцедуры);
	
	Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") И Не УстановленБезопасныйРежим() Тогда
		
		ПрофильКонфигурации = ПрофильСПривилегиямиКонфигурации();
		
		Если ЗначениеЗаполнено(ПрофильКонфигурации) Тогда
			
			УстановитьБезопасныйРежим(ПрофильКонфигурации);
			Если БезопасныйРежим() = Истина Тогда
				УстановитьБезопасныйРежим(Ложь);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыСтрока = "";
	Если Параметры <> Неопределено И Параметры.Количество() > 0 Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + "Параметры[" + Индекс + "],";
		КонецЦикла;
		ПараметрыСтрока = Сред(ПараметрыСтрока, 1, СтрДлина(ПараметрыСтрока) - 1);
	КонецЕсли;
	
	Выполнить ИмяЭкспортнойПроцедуры + "(" + ПараметрыСтрока + ")";
	
КонецПроцедуры

// Выполнить экспортную процедуру обработки (в составе конфигурации) по имени с уровнем привилегий конфигурации.
// При включении профилей безопасности для вызова оператора Выполнить() используется
// переход в безопасный режим с профилем безопасности, используемом для самой конфигурации
// (если выше по стеку не был установлен другой безопасный режим).
//
// Параметры:
//  Обработка - ОбработкаОбъект - объект обработки, встроенной в состав конфигурации,
//  ИмяПроцедуры – Строка – имя экспортной процедуры модуля объекта обработки.
// Параметры - Массив - параметры передаются в процедуру <ИмяПроцедуры>
//  в порядке расположения элементов массива.
//
Процедура ВыполнитьМетодОбъекта(Обработка, Знач ИмяПроцедуры, Знач Параметры = Неопределено) Экспорт
	
	// Проверка имени метода на корректность
	Попытка
		Тест = Новый Структура(ИмяПроцедуры, ИмяПроцедуры);
	Исключение
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Некорректное значение параметра ИмяПроцедуры (%1)'"),
			ИмяПроцедуры);
	КонецПопытки;
	
	Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") И Не УстановленБезопасныйРежим() Тогда
		
		ПрофильКонфигурации = ПрофильСПривилегиямиКонфигурации();
		
		Если ЗначениеЗаполнено(ПрофильКонфигурации) Тогда
			
			УстановитьБезопасныйРежим(ПрофильКонфигурации);
			Если БезопасныйРежим() = Истина Тогда
				УстановитьБезопасныйРежим(Ложь);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыСтрока = "";
	Если Параметры <> Неопределено И Параметры.Количество() > 0 Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + "Параметры[" + Индекс + "],";
		КонецЦикла;
		ПараметрыСтрока = Сред(ПараметрыСтрока, 1, СтрДлина(ПараметрыСтрока) - 1);
	КонецЕсли;
	
	Выполнить "Обработка." + ИмяПроцедуры + "(" + ПараметрыСтрока + ")";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПроверитьИмяМетодаКонфигурации(Знач ИмяЭкспортнойПроцедуры) Экспорт
	
	// Проверка предусловий на формат ИмяЭкспортнойПроцедуры.
	ЧастиИмени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяЭкспортнойПроцедуры, ".");
	Если ЧастиИмени.Количество() <> 2 И ЧастиИмени.Количество() <> 3 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Неправильный формат параметра ИмяЭкспортнойПроцедуры (%1)'"),
			ИмяЭкспортнойПроцедуры);
	КонецЕсли;
	
	ИмяОбъекта = ЧастиИмени[0];
	Если ЧастиИмени.Количество() = 2 И Метаданные.ОбщиеМодули.Найти(ИмяОбъекта) = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Неправильный формат параметра ИмяЭкспортнойПроцедуры (%1):
			         |Не найден общий модуль ""%2"".'"),
			ИмяЭкспортнойПроцедуры,
			ИмяОбъекта);
	КонецЕсли;
	
	Если ЧастиИмени.Количество() = 3 Тогда
		ДопустимыеИменаТипов = Новый Массив;
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаКонстанты()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаРегистрыСведений()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаРегистрыНакопления()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаРегистрыБухгалтерии()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаРегистрыРасчета()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаСправочники()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаДокументы()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаОтчеты()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаОбработки()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаБизнесПроцессы()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаЖурналыДокументов()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаЗадачи()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаПланыСчетов()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаПланыОбмена()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаПланыВидовХарактеристик()));
		ДопустимыеИменаТипов.Добавить(ВРег(ОбщегоНазначения.ИмяТипаПланыВидовРасчета()));
		ИмяТипа = ВРег(ЧастиИмени[0]);
		Если ДопустимыеИменаТипов.Найти(ИмяТипа) = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Неправильный формат параметра ИмяЭкспортнойПроцедуры (%1):
				         |Не найдена коллекция объектов метаданных ""%2"",
				         |или для этой коллекции не поддерживается безопасное выполнение.'"),
				ИмяЭкспортнойПроцедуры,
				ИмяОбъекта);
		КонецЕсли;
	КонецЕсли;
	
	ИмяМетода = ЧастиИмени[ЧастиИмени.ВГраница()];
	ВременнаяСтруктура = Новый Структура;
	Попытка
		// Проверка на то, что ИмяМетода является допустимым идентификатором.
		// Например: МояПроцедура
		ВременнаяСтруктура.Вставить(ИмяМетода);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Безопасное выполнение метода'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Неправильный формат параметра ИмяЭкспортнойПроцедуры (%1):
			         |Имя метода ""%2"" не соответствует требованиям образования имен переменных.'"),
			ИмяЭкспортнойПроцедуры,
			ИмяМетода);
	КонецПопытки;
	
КонецПроцедуры

Процедура ПроверитьВозможностьВыполненияОбработчиковУстановкиПараметровСеанса() Экспорт
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая(СтрокаСоединенияИнформационнойБазы()) Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ДоступенПривилегированныйРежим = Вычислить("ДоступенПереходВПривилегированныйРежим()");
	Исключение
		
		Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") Тогда
			
			Профиль = ПрофильСПривилегиямиКонфигурации();
			УстановитьБезопасныйРежим(Профиль);
			Если БезопасныйРежим() = Истина Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Невозможно выполнение обработчиков установки параметров сеанса по причине: профиль безопасности %1 не найден.
                          |
                          |Возможно, он был удален через консоль кластера.
                          |В этом случае требуется отключить использование профиля безопасности через консоль кластера и
                          |заново включить его с помощью интерфейса конфигурации (соответствующие команды находятся в разделе настроек программы).'"),
					Профиль
				);
			КонецЕсли;
			ДоступенПривилегированныйРежим = Вычислить("ДоступенПереходВПривилегированныйРежим()");
			УстановитьБезопасныйРежим(Ложь);
			Если Не ДоступенПривилегированныйРежим Тогда
				НСтр("ru = 'Невозможно выполнение обработчиков установки параметров сеанса по причине: профиль безопасности %1 не содержит разрешения на использование привилегированного режима.
                      |
                      |Возможно, он был отредактирован через консоль кластера.
                      |В этом случае требуется отключить использование профиля безопасности через консоль кластера и
                      |заново включить его с помощью интерфейса конфигурации (соответствующие команды находятся в разделе настроек программы).'",
					Профиль
				);
			КонецЕсли;
			
		Иначе
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно выполнение обработчиков установки параметров сеанса по причине: %1.
                      |
                      |Возможно, для информационной базы через консоль кластера был установлен профиль безопасности,
                      |не допускающий выполнения внешних модулей без установки безопасного режима.
                      |В этом случае требуется отключить использование профиля безопасности через консоль кластера
                      | и включить его с помощью интерфейса конфигурации (соответствующие команды находятся в разделе
                      |настроек программы). При этом программа будет автоматически корректно настроена на использование
                      |совместно с включенными профилями безопасности.'"),
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке())
			);
			
		КонецЕсли;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДоступенПереходВПривилегированныйРежим()
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ПривилегированныйРежим();
	
КонецФункции

Функция ПрофильСПривилегиямиКонфигурации()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.ПрофильБезопасностиИнформационнойБазы.Получить();
	
КонецФункции

// Возвращает "предопределенный" псевдоним (alias) для каталога программы.
//
// Возвращаемое значение: Строка.
//
Функция ПсевдонимКаталогаПрограммы()
	
	Возврат "/bin";
	
КонецФункции

// Возвращает "предопределенный" псевдоним (alias) для каталога временных файлов.
//
Функция ПсевдонимКаталогаВременныхФайлов()
	
	Возврат "/temp";
	
КонецФункции

Функция Пакет()
	
	Возврат РаботаВБезопасномРежимеСлужебный.ПакетXDTOПредставленийРазрешений();
	
КонецФункции

Функция СтандартныеПортыИнтернетПротоколов()
	
	Результат = Новый Структура();
	
	Результат.Вставить("IMAP",  143);
	Результат.Вставить("POP3",  110);
	Результат.Вставить("SMTP",  25);
	Результат.Вставить("HTTP",  80);
	Результат.Вставить("HTTPS", 443);
	Результат.Вставить("FTP",   21);
	Результат.Вставить("FTPS",  21);
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

#КонецОбласти

