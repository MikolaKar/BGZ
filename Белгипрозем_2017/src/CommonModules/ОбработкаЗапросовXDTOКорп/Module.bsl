////////////////////////////////////////////////////////////////////////////////
// Обработка запросов XDTO, редакция КОРП
// Реализует дополнительный функционал веб-сервиса DMService редакции КОРП
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Дополнительная обработка сообщения XDTO
// Вызывается из ОбработкаЗапросовXDTOПереопределяемый.ОбработатьУниверсальноеСообщение
//
// Параметры:
//   Сообщение - ОбъектXDTO, потомок DMRequest
//
// Возвращаемое значение:
//   ОбъектXDTO, потомок DMResponse - если сообщение считается обработанным, или
//   Неопределено - если сообщение требует дальнейшей обработки
// 
Функция ОбработатьУниверсальноеСообщение(Сообщение) Экспорт
	
	Попытка
		
		Если ОбработкаЗапросовXDTO.ПроверитьТип(Сообщение, "DMAcceptTasksRequest") Тогда
			Возврат ПринятьЗадачиКИсполнению(Сообщение);
			
		ИначеЕсли ОбработкаЗапросовXDTO.ПроверитьТип(Сообщение, "DMGetCorrespondenceTreeRequest") Тогда
			Возврат ОбработкаЗапросовXDTOПочта.ПолучитьДеревоПисем(Сообщение);
			
		ИначеЕсли ОбработкаЗапросовXDTO.ПроверитьТип(Сообщение, "DMGetNewEMailRequest") Тогда
			Возврат ОбработкаЗапросовXDTOПочта.ПолучитьНовоеПисьмо(Сообщение);
			
		ИначеЕсли ОбработкаЗапросовXDTO.ПроверитьТип(Сообщение, "DMGetIncomingEMailAnswerRequest") Тогда
			Возврат ОбработкаЗапросовXDTOПочта.ПолучитьОтветНаВходящееПисьмо(Сообщение);
			
		ИначеЕсли ОбработкаЗапросовXDTO.ПроверитьТип(Сообщение, "DMGetOutgoingEMailForwardRequest") Тогда
			Возврат ОбработкаЗапросовXDTOПочта.ПолучитьИсходящееПисьмоДляПересылки(Сообщение);
			
		ИначеЕсли ОбработкаЗапросовXDTO.ПроверитьТип(Сообщение, "DMGetAddressBookRequest") Тогда
			Возврат ОбработкаЗапросовXDTOПочта.ПолучитьАдреснуюКнигу(Сообщение);
			
		ИначеЕсли ОбработкаЗапросовXDTO.ПроверитьТип(Сообщение, "DMGetRecipientsListByNameRequest") Тогда
			Возврат ОбработкаЗапросовXDTOПочта.ПолучитьСписокПолучателейПоИмени(Сообщение);
			
		ИначеЕсли ОбработкаЗапросовXDTO.ПроверитьТип(Сообщение, "DMRetrieveBarcodesRequest") Тогда
			Возврат ПрочитатьШтрихкодыОбъекта(Сообщение);
			
		ИначеЕсли ОбработкаЗапросовXDTO.ПроверитьТип(Сообщение, "DMUpdateBarcodesRequest") Тогда
			Возврат ЗаписатьШтрихкодыОбъекта(Сообщение);
			
		ИначеЕсли ОбработкаЗапросовXDTO.ПроверитьТип(Сообщение, "DMFindByBarcodeRequest") Тогда
			Возврат НайтиОбъектПоШтрихкоду(Сообщение);
			
		Иначе
			Возврат Неопределено;
			
		КонецЕсли;
		
	Исключение
		
		Ошибка = ОбработкаЗапросовXDTO.СоздатьОбъект("DMError");
		Ошибка.subject = НСтр("ru = 'Ошибка при обработке сообщения'");
		Инфо = ИнформацияОбОшибке();
		Ошибка.description = ОбработкаЗапросовXDTO.ПолучитьОписаниеОшибки(Инфо);
		
		Возврат Ошибка;
		
	КонецПопытки;
	
КонецФункции

// Получает заполненный объект XDTO по бизнес-процессу Исполнение Документооборота
// Вызывается из ОбработкаЗапросовXDTOПереопределяемый.ПолучитьБизнесПроцесс
//
// Параметры:
//   СсылкаНаБизнесПроцесс - БизнесПроцессОбъект.Приглашение, источник данных заполнения
//
// Возвращаемое значение:
//   ОбъектXDTO типа DMBusinessProcessInvitation
//
Функция ПолучитьБППриглашение(СсылкаНаБизнесПроцесс) Экспорт
	
	Ответ = ОбработкаЗапросовXDTO.СоздатьОбъект("DMBusinessProcessInvitation");
	Ответ.objectId = ОбработкаЗапросовXDTO.ПолучитьObjectIDпоСсылке(СсылкаНаБизнесПроцесс.Ссылка);
	Ответ.name = СсылкаНаБизнесПроцесс.Наименование;
	
	// Общая шапка бизнес-процесса.
	ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.ПередатьОбщиеРеквизитыБизнесПроцесса(СсылкаНаБизнесПроцесс, Ответ);
	
	// Особенная шапка Приглашения.
	Ответ.activityBegin = СсылкаНаБизнесПроцесс.ДатаНачалаМероприятия;
	Ответ.activityEnd = СсылкаНаБизнесПроцесс.ДатаОкончанияМероприятия;
	Ответ.activityVenue = СсылкаНаБизнесПроцесс.МестоПроведения;
	
	// Результат приглашения.
	Ответ.invitationResult = ОбработкаЗапросовXDTO.СоздатьОбъект("DMGeneralInvitationResult");
	Ответ.invitationResult.name = Строка(СсылкаНаБизнесПроцесс.РезультатПриглашения);
	ответ.invitationResult.objectId = ОбработкаЗапросовXDTO.ПолучитьObjectIDПоСсылке(СсылкаНаБизнесПроцесс.РезультатПриглашения);
	
	// Исполнители.
	Для Каждого Исполнитель Из СсылкаНаБизнесПроцесс.Исполнители Цикл
		performer = ОбработкаЗапросовXDTO.СоздатьОбъект("DMBusinessProcessInvitationParticipant");
		basePerformer = ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.СоздатьОбъектDMBusinessProcessTaskExecutor(
			Исполнитель, Исполнитель.Исполнитель, Исполнитель.Исполнитель, "ОсновнойОбъектАдресации", "ДополнительныйОбъектАдресации");
		Для Каждого Свойство Из basePerformer.Свойства() Цикл
			Если basePerformer.Установлено(Свойство.Имя) Тогда
				performer[Свойство.Имя] = basePerformer[Свойство.Имя];
			КонецЕсли;
		КонецЦикла;                                  
		performer.attendanceCompulsory = Исполнитель.ЯвкаОбязательна;
		Ответ.performers.Добавить(performer);
	КонецЦикла;
	
	Возврат Ответ;
	
КонецФункции

// Получает заполненный объект XDTO по бизнес-процессу "Комплексный процесс" Документооборота 
// Вызывается из ОбработкаЗапросовXDTOПереопределяемый.ПолучитьБизнесПроцесс
//
// Параметры:
//   СсылкаНаБизнесПроцесс - БизнесПроцессОбъект.КомплексныйПроцесс, источник данных заполнения
//
// Возвращаемое значение:
//   ОбъектXDTO типа DMComplexBusinessProcess
//
Функция ПолучитьБПКомплексныйПроцесс(Узел, СсылкаНаБизнесПроцесс) Экспорт
	
	Ответ = ОбработкаЗапросовXDTO.СоздатьОбъект("DMComplexBusinessProcess");
	Ответ.objectId = ОбработкаЗапросовXDTO.ПолучитьObjectIDпоСсылке(СсылкаНаБизнесПроцесс.Ссылка);
	Ответ.name = СсылкаНаБизнесПроцесс.Наименование;
	
	// Общая шапка бизнес-процесса.
	ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.ПередатьОбщиеРеквизитыБизнесПроцесса(СсылкаНаБизнесПроцесс, Ответ);
	ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.ПередатьЗначениеКонтролера(СсылкаНаБизнесПроцесс, Ответ);
	
	// Особенности комплексных процессов.
	Ответ.routingType = ОбработкаЗапросовXDTO.СоздатьОбъект("DMBusinessProcessRoutingType");
	Ответ.routingType.name = Строка(СсылкаНаБизнесПроцесс.ВариантМаршрутизации);
	Ответ.routingType.objectId = ОбработкаЗапросовXDTO.ПолучитьObjectIDПоСсылке(СсылкаНаБизнесПроцесс.ВариантМаршрутизации);
	
	УстановитьПривилегированныйРежим(Истина);
	Для каждого Этап из СсылкаНаБизнесПроцесс.Этапы Цикл
		ЭтапXDTO = ОбработкаЗапросовXDTO.СоздатьОбъект("DMComplexBusinessProcessStage");
		ЭтапXDTO.stageID = Строка(Этап.ИдентификаторЭтапа);
		ЭтапXDTO.participants = Этап.ИсполнителиЭтапаСтрокой;
		ЭтапXDTO.stagePredecessors = Этап.ПредшественникиЭтапаСтрокой;
		ЭтапXDTO.executed = Этап.ЗадачаВыполнена;
		Если ЗначениеЗаполнено(Этап.ЗапущенныйБизнесПроцесс) Тогда
			ЭтапXDTO.businessProcess = ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.ПолучитьБизнесПроцесс(
				Узел, ОбработкаЗапросовXDTO.ПолучитьObjectIDПоСсылке(Этап.ЗапущенныйБизнесПроцесс));
		КонецЕсли;
		ЭтапXDTO.predecessorsUseOption = Этап.ПредшественникиВариантИспользования;
		ЭтапXDTO.unconditionalPassageExecuted = Этап.БезусловныйПереходКСледующемуБылВыполнен;
		Если ЗначениеЗаполнено(Этап.ШаблонБизнесПроцесса) Тогда
			ШаблонXDTO = ОбработкаЗапросовXDTO.СоздатьОбъект("DMObject");
			ШаблонXDTO.name = Этап.ШаблонБизнесПроцесса.Наименование;
			ШаблонXDTO.objectID = ОбработкаЗапросовXDTO.ПолучитьObjectIDПоСсылке(Этап.ШаблонБизнесПроцесса);
			ЭтапXDTO.template = ШаблонXDTO;
			ЭтапXDTO.duration = Этап.ШаблонБизнесПроцесса.ПолучитьОбъект().ПолучитьСтроковоеПредставлениеСрокаВыполнения();
		КонецЕсли;
		Ответ.stages.Добавить(ЭтапXDTO);
	КонецЦикла;
	
	Для каждого Предшественник из СсылкаНаБизнесПроцесс.ПредшественникиЭтапов Цикл
		ПредшественникXDTO = ОбработкаЗапросовXDTO.СоздатьОбъект("DMComplexBusinessProcessStagePredecessor");
		ПредшественникXDTO.followerID = Строка(Предшественник.ИдентификаторПоследователя);
		Если ЗначениеЗаполнено(Предшественник.ИдентификаторПредшественника) Тогда
			ПредшественникXDTO.predecessorID = Строка(Предшественник.ИдентификаторПредшественника);
		КонецЕсли;
		Если ЗначениеЗаполнено(Предшественник.УсловиеПерехода) Тогда
			УсловиеПереходаXDTO = ОбработкаЗапросовXDTO.СоздатьОбъект("DMRoutingCondition");
			УсловиеПереходаXDTO.name = Строка(Предшественник.УсловиеПерехода);
			УсловиеПереходаXDTO.objectId = ОбработкаЗапросовXDTO.ПолучитьObjectIDПоСсылке(Предшественник.УсловиеПерехода);
			ПредшественникXDTO.passageCondition = УсловиеПереходаXDTO;
		КонецЕсли;
		ПредшественникXDTO.passageExecuted = Предшественник.УсловныйПереходБылВыполнен;
		Если ЗначениеЗаполнено(Предшественник.УсловиеРассмотрения) Тогда
			УсловиеРассмотренияXDTO = ОбработкаЗапросовXDTO.СоздатьОбъект("DMPredecessorsStageConsiderationCondition");
			УсловиеРассмотренияXDTO.name = Строка(Предшественник.УсловиеРассмотрения);
			УсловиеРассмотренияXDTO.objectId = ОбработкаЗапросовXDTO.ПолучитьObjectIDПоСсылке(Предшественник.УсловиеРассмотрения);
			ПредшественникXDTO.considerationCondition = УсловиеРассмотренияXDTO;
		КонецЕсли;
		Ответ.predecessors.Добавить(ПредшественникXDTO);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Ответ;
	
КонецФункции

// Записывает процесс "Приглашение" Документооборота по объекту XDTO DMBusinessProcessInvitation
// Вызывается из ОбработкаЗапросовXDTOБизнесПереопределяемый.ЗаписатьБизнесПроцесс
// 
// Параметры:
//   Объект - ОбъектXDTO типа DMBusinessProcessInvitation
//
// Возвращаемое значение:
//   БизнесПроцессСсылка.Приглашение - ссылка на записанный бизнес-процесс
//
Функция ЗаписатьБППриглашение(Объект, СоздатьНовый) Экспорт
	
	БПОбъект = ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.ПолучитьОбъектБизнесПроцесс("Приглашение", Объект, СоздатьНовый);
	
	// Запись шапки.
	ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.УстановитьШапкуБизнесПроцесса(БПОбъект, Объект);
	
	БПОбъект.ДатаНачалаМероприятия = Объект.activityBegin;
	БПОбъект.ДатаОкончанияМероприятия = Объект.activityEnd;
	БПОбъект.МестоПроведения = Объект.activityVenue;
	
	// Исполнители.
	БПОбъект.Исполнители.Очистить();
	Для Каждого Исполнитель Из Объект.performers Цикл
		НоваяСтрока = БПОбъект.Исполнители.Добавить();
		// Общие данные исполнителя.
		ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.УстановитьЗначениеИсполнителяВСпискеИсполнителей(НоваяСтрока, Исполнитель);
		// Специфика исполнителя в Приглашении.
		НоваяСтрока.ЯвкаОбязательна = Исполнитель.attendanceCompulsory;
	КонецЦикла;
	
	// Запись объекта.
	ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.ЗаписатьБПОбъект(БПОбъект);
	
	Возврат БПОбъект.Ссылка;
	
КонецФункции

// Записывает комплексный процесс Документооборота по объекту XDTO DMComplexBusinessProcess
// Вызывается из ОбработкаЗапросовXDTOБизнесПереопределяемый.ЗаписатьБизнесПроцесс
// 
// Параметры:
//   Объект - ОбъектXDTO типа DMComplexBusinessProcess
//
// Возвращаемое значение:
//   БизнесПроцессСсылка.КомплексныйПроцесс - ссылка на записанный бизнес-процесс
//
Функция ЗаписатьБПКомплексныйПроцесс(Объект, СоздатьНовый) Экспорт
	
	БПОбъект = ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.ПолучитьОбъектБизнесПроцесс("КомплексныйПроцесс", Объект, СоздатьНовый);
	
	// Запись шапки.
	ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.УстановитьШапкуБизнесПроцесса(БПОбъект, Объект);
	
	// Контролер.
	ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.УстановитьЗначениеКонтролера(БПОбъект, Объект);
	
	БПОбъект.ВариантМаршрутизации = ОбработкаЗапросовXDTO.ПолучитьСсылкуПоObjectID(Объект.routingType.objectId);
	
	// Этапы.
	БПОбъект.Этапы.Очистить();
	Для каждого ЭтапXDTO из Объект.stages Цикл
		Этап = БПОбъект.Этапы.Добавить();
		Этап.ИдентификаторЭтапа = Новый УникальныйИдентификатор(ЭтапXDTO.stageID);
		Этап.ИсполнителиЭтапаСтрокой = ЭтапXDTO.participants;
		Этап.ПредшественникиЭтапаСтрокой = ЭтапXDTO.stagePredecessors;
		Если ЭтапXDTO.Установлено("businessProcess") Тогда
			Этап.ЗапущенныйБизнесПроцесс = ОбработкаЗапросовXDTO.ПолучитьСсылкуПоObjectID(ЭтапXDTO.businessProcess.objectId);
		КонецЕсли;
		Если ЭтапXDTO.Установлено("template") Тогда
			Этап.ШаблонБизнесПроцесса = ОбработкаЗапросовXDTO.ПолучитьСсылкуПоObjectID(ЭтапXDTO.template.objectID);
		КонецЕсли;
		Если ЭтапXDTO.Установлено("predecessorsUseOption") Тогда
			Этап.ПредшественникиВариантИспользования = ЭтапXDTO.predecessorsUseOption;
		КонецЕсли;
		Если ЭтапXDTO.Установлено("unconditionalPassageExecuted") Тогда
			Этап.БезусловныйПереходКСледующемуБылВыполнен = ЭтапXDTO.unconditionalPassageExecuted;
		КонецЕсли;	
		Этап.ЗадачаВыполнена = ЭтапXDTO.executed;
		
	КонецЦикла;
	
	// Предшественники.
	БПОбъект.ПредшественникиЭтапов.Очистить();
	Для каждого ПредшественникXDTO из Объект.predecessors Цикл
		Предшественник =  БПОбъект.ПредшественникиЭтапов.Добавить();
        Предшественник.ИдентификаторПоследователя = Новый УникальныйИдентификатор(ПредшественникXDTO.followerID);
		Если ПредшественникXDTO.Установлено("predecessorID") Тогда
			Предшественник.ИдентификаторПредшественника = Новый УникальныйИдентификатор(ПредшественникXDTO.predecessorID);
		КонецЕсли;
		Если БПОбъект.Предметы.Количество() > 0 Тогда
			Если ПредшественникXDTO.Установлено("passageCondition") Тогда
				Предшественник.УсловиеПерехода = ОбработкаЗапросовXDTO.ПолучитьСсылкуПоObjectID(ПредшественникXDTO.passageCondition.objectID);
				Предшественник.ИмяПредметаУсловия = БПОбъект.Предметы[0].ИмяПредмета;
			КонецЕсли;
		КонецЕсли;
		Предшественник.УсловныйПереходБылВыполнен = ПредшественникXDTO.passageExecuted;
		Если ПредшественникXDTO.Установлено("considerationCondition") Тогда
			Предшественник.УсловиеРассмотрения =  ОбработкаЗапросовXDTO.ПолучитьСсылкуПоObjectID(ПредшественникXDTO.considerationCondition.objectID);
		КонецЕсли;
	КонецЦикла;
	
	// Предметы задач.
	Если СоздатьНовый Тогда
		ИсходныеПредметы = БПОбъект.Предметы.Выгрузить();
		БПОбъект.Предметы.Очистить();
		Мультипредметность.ПередатьПредметыПроцессу(БПОбъект, ИсходныеПредметы);
	КонецЕсли;
	
	// Запись объекта.
	ОбработкаЗапросовXDTOБизнесПроцессыИЗадачи.ЗаписатьБПОбъект(БПОбъект);
	
	Возврат БПОбъект.Ссылка;
	
КонецФункции

// Принимает переданные задачи к исполнению
//
// Параметры:
//   Сообщение - ОбъектXDTO типа DMAcceptTasksRequest
// 
// Возвращаемое значение:
//   ОбъектXDTO типа DMOK или DMError
//
Функция ПринятьЗадачиКИсполнению(Сообщение) Экспорт
	
	мЗадачи = Новый Массив;
	
	Попытка
		
		Для каждого ЗадачаXDTO из Сообщение.tasks Цикл
			Ссылка = ОбработкаЗапросовXDTO.ПолучитьСсылкуПоObjectID(ЗадачаXDTO.objectId);
			мЗадачи.Добавить(Ссылка.Ссылка);
		КонецЦикла;
		
		БизнесПроцессыИЗадачиСервер.ПринятьЗадачиКИсполнению(мЗадачи);
		
		Ответ = ОбработкаЗапросовXDTO.СоздатьОбъект("DMOK");
		
		Возврат Ответ;
		
	Исключение
		
		Ошибка = ОбработкаЗапросовXDTO.СоздатьОбъект("DMError");
		Ошибка.subject = НСтр("ru = 'Ошибка при принятии задачи к исполнению'");
	    Инфо = ИнформацияОбОшибке();
	    Ошибка.description = ОбработкаЗапросовXDTO.ПолучитьОписаниеОшибки(Инфо);
		
		Возврат Ошибка;
		
	КонецПопытки;

КонецФункции

// Дополнительная обработка получения шаблона процесса
// Вызывается из ОбработкаЗапросовXDTOПереопределяемый.ПолучитьШаблоныБизнесПроцесса
//
// Параметры:
//   Сообщение - ОбъектXDTO типа DMGetBusinessProcessTemplatesRequest
// Возвращаемое значение:
//   ОбъектXDTO типа DMGetBusinessProcessTemplatesResponse
// 
Функция ПолучитьШаблоныБизнесПроцесса(Сообщение) Экспорт

	Ответ = ОбработкаЗапросовXDTO.СоздатьОбъект("DMGetBusinessProcessTemplatesResponse");
	
	Тип = Сообщение.businessProcessType;
	
	Предмет = Неопределено;
	Если Сообщение.Установлено("businessProcessTargetId") Тогда
		Предмет = ОбработкаЗапросовXDTO.ПолучитьСсылкуПоObjectID(Сообщение.businessProcessTargetId);
	КонецЕсли;
	
	МассивШаблонов = Новый Массив;
	
	Если Тип = "DMComplexBusinessProcess" Тогда
		БПОбъект = БизнесПроцессы.КомплексныйПроцесс.СоздатьБизнесПроцесс();
		Если ЗначениеЗаполнено(Предмет) Тогда
			Мультипредметность.ПередатьПредметыПроцессу(БПОбъект, Предмет);
		КонецЕсли;
		МассивШаблонов = ШаблоныБизнесПроцессов.ПолучитьШаблоныПоДокументу(Предмет, "ШаблоныКомплексныхБизнесПроцессов", Ложь);
			
	ИначеЕсли Тип = "DMBusinessProcessInvitation" Тогда
		БПОбъект = БизнесПроцессы.Приглашение.СоздатьБизнесПроцесс();
		Если ЗначениеЗаполнено(Предмет) Тогда
			Мультипредметность.ПередатьПредметыПроцессу(БПОбъект, Предмет);
		КонецЕсли;
		МассивШаблонов = ШаблоныБизнесПроцессов.ПолучитьШаблоныПоДокументу(Предмет, "ШаблоныПриглашения", Ложь);
		
	КонецЕсли;
		
		
	Для Каждого Шаблон Из МассивШаблонов Цикл
		ОбъектШаблонXDTO = ОбработкаЗапросовXDTO.СоздатьОбъект("DMBusinessProcessTemplate");
		ОбъектШаблонXDTO.name = Шаблон.Наименование;
		ОбъектШаблонXDTO.objectId = ОбработкаЗапросовXDTO.ПолучитьObjectIDПоСсылке(Шаблон.Ссылка);
		Ответ.BusinessProcessTemplates.Добавить(ОбъектШаблонXDTO);
	КонецЦикла;
	
	Возврат Ответ;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Читает штрихкоды объекта по запросу DMRetrieveBarcodesRequest
// 
// Параметры:
//   Сообщение - ОбъектXDTO типа DMRetrieveBarcodesRequest
//
// Возвращаемое значение:
//   ОбъектXDTO типа DMRetrieveBarcodesResponse
//
Функция ПрочитатьШтрихкодыОбъекта(Сообщение)
	
	Если Сообщение.objectId.type = "DMIncomingDocument" Тогда
		Менеджер = Справочники.ВходящиеДокументы;
	ИначеЕсли Сообщение.objectId.type = "DMInternalDocument" Тогда
		Менеджер = Справочники.ВнутренниеДокументы;
	ИначеЕсли Сообщение.objectId.type = "DMOutgoingDocument" Тогда
		Менеджер = Справочники.ИсходящиеДокументы;
	ИначеЕсли Сообщение.objectId.type = "DMFile" Тогда
		Менеджер = Справочники.Файлы;
	Иначе
		Ошибка = ОбработкаЗапросовXDTO.СоздатьОбъект("DMError");
		Ошибка.subject = Сообщение.objectId.type;
		Ошибка.description = НСтр("ru = 'Штрихкоды для объектов этого типа не поддерживаются'");
		Возврат Ошибка;
	КонецЕсли;
	Попытка
		Владелец = Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(Сообщение.objectId.id));
	Исключение
		Ошибка = ОбработкаЗапросовXDTO.СоздатьОбъект("DMError");
		Ошибка.subject = Сообщение.objectId.id;
		Ошибка.description = НСтр("ru = 'Неверен формат идентификатора объекта'");
		Возврат Ошибка;
	КонецПопытки;
	
	Ответ = ОбработкаЗапросовXDTO.СоздатьОбъект("DMRetrieveBarcodesResponse");
	ШтрихкодыОбъекта = ОбработкаЗапросовXDTO.СоздатьОбъект("DMObjectBarcodes");
	ШтрихкодыОбъекта.objectId = Сообщение.objectId;
	
	ЗапросШтрихкоды = Новый Запрос(
		"ВЫБРАТЬ
		|	Штрихкоды.ВнутреннийШтрихкод,
		|	Штрихкоды.Код
		|ИЗ
		|	РегистрСведений.Штрихкоды КАК Штрихкоды
		|ГДЕ
		|	Штрихкоды.Владелец = &Владелец");
	ЗапросШтрихкоды.УстановитьПараметр("Владелец", Владелец);		
	ВыборкаШтрихкоды = ЗапросШтрихкоды.Выполнить().Выбрать();
	Пока ВыборкаШтрихкоды.Следующий() Цикл
		Штрихкод = ОбработкаЗапросовXDTO.СоздатьОбъект("DMBarcode");
		Штрихкод.internal = ВыборкаШтрихкоды.ВнутреннийШтрихкод;
		Штрихкод.barcodeData = ВыборкаШтрихкоды.Код;
		ШтрихкодыОбъекта.barcodes.Добавить(Штрихкод);
	КонецЦикла;
	
	Ответ.objectBarcodes = ШтрихкодыОбъекта;
	Возврат Ответ;
	
КонецФункции

// Записывает штрихкоды объекта по запросу DMUpdateBarcodesRequest
// 
// Параметры:
//   Сообщение - ОбъектXDTO типа DMUpdateBarcodesRequest
//
// Возвращаемое значение:
//   ОбъектXDTO типа DMUpdateBarcodesResponse
//
Функция ЗаписатьШтрихкодыОбъекта(Сообщение)
	
	ШтрихкодыОбъекта = Сообщение.objectBarcodes;
	Если ШтрихкодыОбъекта.objectId.type = "DMIncomingDocument" Тогда
		Менеджер = Справочники.ВходящиеДокументы;
	ИначеЕсли ШтрихкодыОбъекта.objectId.type = "DMInternalDocument" Тогда
		Менеджер = Справочники.ВнутренниеДокументы;
	ИначеЕсли ШтрихкодыОбъекта.objectId.type = "DMOutgoingDocument" Тогда
		Менеджер = Справочники.ИсходящиеДокументы;
	ИначеЕсли ШтрихкодыОбъекта.objectId.type = "DMFile" Тогда
		Менеджер = Справочники.Файлы;
	Иначе
		Ошибка = ОбработкаЗапросовXDTO.СоздатьОбъект("DMError");
		Ошибка.subject = ШтрихкодыОбъекта.objectId.type;
		Ошибка.description = НСтр("ru = 'Штрихкоды для объектов этого типа не поддерживаются'");
		Возврат Ошибка;
	КонецЕсли;
	Попытка
		Владелец = Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(ШтрихкодыОбъекта.objectId.id));
	Исключение
		Ошибка = ОбработкаЗапросовXDTO.СоздатьОбъект("DMError");
		Ошибка.subject = ШтрихкодыОбъекта.objectId.id;
		Ошибка.description = НСтр("ru = 'Неверен формат идентификатора объекта'");
		Возврат Ошибка;
	КонецПопытки;
	
	// Штрихкоды, которые следует добавить к уже существующим в базе.
	ШтрихкодыКДобавлению = Новый ТаблицаЗначений;
	ШтрихкодыКДобавлению.Колонки.Добавить("ВнутреннийШтрихкод");
	ШтрихкодыКДобавлению.Колонки.Добавить("Код");
	Для каждого Штрихкод из ШтрихкодыОбъекта.barcodes Цикл
		ШтрихкодКДобавлению = ШтрихкодыКДобавлению.Добавить();
		ШтрихкодКДобавлению.ВнутреннийШтрихкод = Штрихкод.internal;
		ШтрихкодКДобавлению.Код = Штрихкод.barcodeData;
	КонецЦикла;
	
	НачатьТранзакцию();
	Попытка
		
		// Выберем уже существующие штрихкоды и удалим лишнее.
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Штрихкоды.ВнутреннийШтрихкод,
			|	Штрихкоды.Код
			|ИЗ
			|	РегистрСведений.Штрихкоды КАК Штрихкоды
			|ГДЕ
			|	Штрихкоды.Владелец = &Владелец");
		Запрос.УстановитьПараметр("Владелец", Владелец);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураПоиска = Новый Структура("ВнутреннийШтрихкод, Код", Выборка.ВнутреннийШтрихкод, Выборка.Код);
			НайденныеСтроки = ШтрихкодыКДобавлению.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() = 0 Тогда
				Запись = РегистрыСведений.Штрихкоды.СоздатьМенеджерЗаписи();
				Запись.Владелец = Владелец;
				Запись.ВнутреннийШтрихкод = Выборка.ВнутреннийШтрихкод;
				Запись.Код = Выборка.Код;
				Запись.Удалить();
			Иначе
				Для каждого НайденнаяСтрока из НайденныеСтроки Цикл
					ШтрихкодыКДобавлению.Удалить(НайденнаяСтрока);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
		Для каждого ШтрихкодКДобавлению из ШтрихкодыКДобавлению Цикл
			Запись = РегистрыСведений.Штрихкоды.СоздатьМенеджерЗаписи();
			Запись.Владелец = Владелец;
			Запись.ВнутреннийШтрихкод = ШтрихкодКДобавлению.ВнутреннийШтрихкод;
			Запись.Код = ШтрихкодКДобавлению.Код;
			Запись.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		Ответ = ОбработкаЗапросовXDTO.СоздатьОбъект("DMUpdateBarcodesResponse");
		Возврат Ответ;
		
	Исключение
		
		ОтменитьТранзакцию();
		Ошибка = ОбработкаЗапросовXDTO.СоздатьОбъект("DMError");
		Ошибка.subject = НСтр("ru = 'Ошибка при записи штрихкодов'");
		Инфо = ИнформацияОбОшибке();
		Ошибка.description = ОбработкаЗапросовXDTO.ПолучитьОписаниеОшибки(Инфо);
		Возврат Ошибка;
		
	КонецПопытки;
	
КонецФункции

// Ищет объект по штрихкоду по запросу DMFindByBarcodeRequest
// 
// Параметры:
//   Сообщение - ОбъектXDTO типа DMFindByBarcodeRequest
//
// Возвращаемое значение:
//   ОбъектXDTO типа DMFindByBarcodeResponse
//
Функция НайтиОбъектПоШтрихкоду(Сообщение)
	
	Ответ = ОбработкаЗапросовXDTO.СоздатьОбъект("DMFindByBarcodeResponse");
	
	ЗапросВладелец = Новый Запрос(
		"ВЫБРАТЬ
		|	Штрихкоды.Владелец
		|ИЗ
		|	РегистрСведений.Штрихкоды КАК Штрихкоды
		|ГДЕ
		|	Штрихкоды.Код = &Код");
	ЗапросВладелец.УстановитьПараметр("Код", Сообщение.barcodeData);
	ВыборкаВладелец = ЗапросВладелец.Выполнить().Выбрать();
	Пока ВыборкаВладелец.Следующий() Цикл
		
		Владелец = ОбработкаЗапросовXDTO.СоздатьОбъект("DMObjectID");
		Владелец.id = Строка(ВыборкаВладелец.Владелец.УникальныйИдентификатор());
		Если ТипЗнч(ВыборкаВладелец.Владелец) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
			Владелец.type = "DMIncomingDocument";
		ИначеЕсли ТипЗнч(ВыборкаВладелец.Владелец) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
			Владелец.type = "DMInternalDocument";
		ИначеЕсли ТипЗнч(ВыборкаВладелец.Владелец) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
			Владелец.type = "DMOutgoingDocument";
		ИначеЕсли ТипЗнч(ВыборкаВладелец.Владелец) = Тип("СправочникСсылка.Файлы") Тогда
			Владелец.type = "DMFile";
		Иначе 
			Владелец.type = "";
		КонецЕсли;
		
		Ответ.objects.Добавить(Владелец);
		
	КонецЦикла;
	
	Возврат Ответ;
	
КонецФункции

#КонецОбласти