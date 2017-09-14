
// Процедура обновления ИБ для справочника видов контактной информации.
Процедура КонтактнаяИнформацияОбновлениеИБ() Экспорт
	
	// Справочник "Контактные лица"
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.ТелефонКонтактногоЛица,
		Перечисления.ТипыКонтактнойИнформации.Телефон,
		НСтр("ru='Рабочий телефон контактного лица'"),
		Истина, Ложь, Ложь, 1, Истина);
	
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.МобильныйТелефонКонтактногоЛица,
		Перечисления.ТипыКонтактнойИнформации.Телефон,
		НСтр("ru='Мобильный телефон контактного лица'"),
		Истина, Ложь, Ложь, 2, Истина);
		
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
		НСтр("ru='Email контактного лица'"),
		Истина, Ложь, Ложь, 3, Истина);
		
	// Справочник "Корреспонденты"
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.ФактическийАдресКорреспондента,
		Перечисления.ТипыКонтактнойИнформации.Адрес,
		НСтр("ru='Фактический адрес корреспондента'"),
		Истина, Ложь, Ложь, 1, Ложь);
	
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.ЮридическийАдресКорреспондента,
		Перечисления.ТипыКонтактнойИнформации.Адрес,
		НСтр("ru='Юридический адрес корреспондента'"),
		Истина, Ложь, Ложь, 2, Ложь);
	
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКорреспондента,
		Перечисления.ТипыКонтактнойИнформации.Адрес,
		НСтр("ru='Почтовый адрес корреспондента'"),
		Истина, Ложь, Ложь, 3, Ложь);
		
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.ТелефонКорреспондента,
		Перечисления.ТипыКонтактнойИнформации.Телефон,
		НСтр("ru='Телефон корреспондента'"),
		Истина, Ложь, Ложь, 4, Истина);
		
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.ФаксКорреспондента,
		Перечисления.ТипыКонтактнойИнформации.Факс,
		НСтр("ru='Факс корреспондента'"),
		Истина, Ложь, Ложь, 5, Истина);
		
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.EmailКорреспондента,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
		НСтр("ru='Email корреспондента'"),
		Истина, Ложь, Ложь, 6, Истина);
		
	// Справочник "Физические лица"
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.ДомашнийАдресФизическогоЛица,
		Перечисления.ТипыКонтактнойИнформации.Адрес,
		НСтр("ru='Домашний адрес физ. лица'"),
		Истина, Ложь, Ложь, 1, Ложь);
	
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.ДомашнийТелефонФизическогоЛица,
		Перечисления.ТипыКонтактнойИнформации.Телефон,
		НСтр("ru='Домашний телефон физ. лица'"),
		Истина, Ложь, Ложь, 2, Истина);
	
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.МобильныйТелефонФизическогоЛица,
		Перечисления.ТипыКонтактнойИнформации.Телефон,
		НСтр("ru='Мобильный телефон физ. лица'"),
		Истина, Ложь, Ложь, 3, Истина);
		
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.EmailФизическогоЛица,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
		НСтр("ru='Email физ. лица'"),
		Истина, Ложь, Ложь, 4, Истина);
		
	// Справочник "Личные адресаты"
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.EmailАдресата,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
		НСтр("ru='Email адресата'"),
		Истина, Ложь, Ложь, 1, Истина);
		
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.РабочийТелефонАдресата,
		Перечисления.ТипыКонтактнойИнформации.Телефон,
		НСтр("ru='Рабочий телефон адресата'"),
		Истина, Ложь, Ложь, 2, Истина);
		
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.ФаксАдресата,
		Перечисления.ТипыКонтактнойИнформации.Факс,
		НСтр("ru='Факс адресата'"),
		Истина, Ложь, Ложь, 3, Истина);
		
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресАдресата,
		Перечисления.ТипыКонтактнойИнформации.Адрес,
		НСтр("ru='Почтовый адрес адресата'"),
		Истина, Ложь, Ложь, 4, Истина);
		
	// Справочник "РолиИсполнителей"
	УправлениеКонтактнойИнформацией.ОбновитьВидКонтактнойИнформации(
		Справочники.ВидыКонтактнойИнформации.EmailРоли,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
		НСтр("ru='Email роли исполнителей'"),
		Истина, Ложь, Ложь, 1, Истина);
		
КонецПроцедуры
