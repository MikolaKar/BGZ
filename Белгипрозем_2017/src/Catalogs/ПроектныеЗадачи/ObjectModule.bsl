
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ТипОграничения = Перечисления.ТипыОграниченийПроектныхЗадач.НачалоНеПозднее 
	 Или ТипОграничения = Перечисления.ТипыОграниченийПроектныхЗадач.НачалоНеРанее
	 Или ТипОграничения = Перечисления.ТипыОграниченийПроектныхЗадач.ОкончаниеНеПозднее
	 Или ТипОграничения = Перечисления.ТипыОграниченийПроектныхЗадач.ОкончаниеНеРанее 
	 Или ТипОграничения = Перечисления.ТипыОграниченийПроектныхЗадач.ФиксированноеНачало
	 Или ТипОграничения = Перечисления.ТипыОграниченийПроектныхЗадач.ФиксированноеОкончание Тогда 
		ПроверяемыеРеквизиты.Добавить("ДатаОграничения");
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
	КонецЕсли;
	
	РеквизитыСсылки = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Ссылка,
		"ПометкаУдаления,
		|Родитель");
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если Не Ссылка.Пустая() Тогда
		ПредыдущаяПометкаУдаления = РеквизитыСсылки.ПометкаУдаления;
		
		Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда 
			Если ПометкаУдаления Тогда
				ДополнительныеСвойства.Вставить("НужноПометитьНаУдалениеБизнесСобытия", Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ТекущийРодитель = РеквизитыСсылки.Родитель;
	ДополнительныеСвойства.Вставить("ТекущийРодитель", ТекущийРодитель);
	ДополнительныеСвойства.Вставить(
		"ПометкаУдаления", 
		?(Ссылка.Пустая(), Ложь, Ссылка.ПометкаУдаления));
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ДополнительныеСвойства.Свойство("ПроверитьПредшественников") И ДополнительныеСвойства.ПроверитьПредшественников Тогда
		РаботаСПроектами.ПроверитьПредшественников(Ссылка);
	КонецЕсли;	
		
	// Возможно, выполнена явная регистрация событий при загрузке объекта.
	Если Не ДополнительныеСвойства.Свойство("НеРегистрироватьБизнесСобытия") Тогда
		Если ДополнительныеСвойства.Свойство("ЭтоНовый") И ДополнительныеСвойства.ЭтоНовый Тогда
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.СозданиеПроектнойЗадачи);	
		Иначе
			БизнесСобытияВызовСервера.ЗарегистрироватьСобытие(Ссылка, Справочники.ВидыБизнесСобытий.ИзменениеПроектнойЗадачи);
		КонецЕсли;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("НужноПометитьНаУдалениеБизнесСобытия") Тогда
		БизнесСобытияВызовСервера.ПометитьНаУдалениеСобытияПоИсточнику(Ссылка);
	КонецЕсли;	

	// установка признака суммарной задачи у родителя
	ТекущийРодитель = ДополнительныеСвойства.ТекущийРодитель;
	Если Родитель <> ТекущийРодитель Тогда 
		
		Если ЗначениеЗаполнено(ТекущийРодитель) Тогда 
			ЭтоСуммарнаяЗадача = РаботаСПроектами.ЭтоСуммарнаяЗадача(ТекущийРодитель);
			Если ЭтоСуммарнаяЗадача <> ТекущийРодитель.СуммарнаяЗадача Тогда 
				РодительОбъект = ТекущийРодитель.ПолучитьОбъект();
				ЗаблокироватьДанныеДляРедактирования(РодительОбъект.Ссылка);
				РодительОбъект.СуммарнаяЗадача = ЭтоСуммарнаяЗадача;
				РодительОбъект.Записать();
			КонецЕсли;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(Родитель) Тогда 
			ЭтоСуммарнаяЗадача = РаботаСПроектами.ЭтоСуммарнаяЗадача(Родитель);
			Если ЭтоСуммарнаяЗадача <> Родитель.СуммарнаяЗадача Тогда 
				РодительОбъект = Родитель.ПолучитьОбъект();
				ЗаблокироватьДанныеДляРедактирования(РодительОбъект.Ссылка);
				РодительОбъект.СуммарнаяЗадача = ЭтоСуммарнаяЗадача;
				РодительОбъект.Записать();
			КонецЕсли;
		КонецЕсли;	
		
	КонецЕсли;	
	
	Если ПометкаУдаления <> ДополнительныеСвойства.ПометкаУдаления Тогда
		РаботаСПроектами.ЗаполнитьКодыСДРПроектныхЗадач(Владелец.Ссылка);
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(ДанныеЗаполнения) Тогда
		Предмет = ДанныеЗаполнения;
		Наименование = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ДанныеЗаполнения, "Тема");
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СуммарнаяЗадача = Ложь;
	КодСДР = "";
	НомерЗадачиВУровне = 0;
	НачалоФакт = '00010101';
	ОкончаниеФакт = '00010101';
	ДлительностьФакт = 0;

КонецПроцедуры
