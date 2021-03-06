Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.мРеализация.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьУчетДоговоров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьРасчетыСПокупателями(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОстаткиПроизводства(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьУчетПроизводства(ДополнительныеСвойства, Движения, Отказ);

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
КонецПроцедуры

