﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	

	//Делаем движения
	Движения.ДС_ФактическиеПлатежи.Записывать = Истина;
	Для каждого Стр Из ФактическиеПлатежиОборудование Цикл 
		Движение = Движения.ДС_ФактическиеПлатежи.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, Стр);
		Движение.ПериодПлатежа = Стр.Период;
		// is ЯннуровВФ нач 20140725
		Движение.LeasePaymentПлан = - Стр.LeasePaymentПлан;
		// is ЯннуровВФ кон 20140725
		Движение.LeasePaymentActual = - Стр.LeasePaymentActual;
		Движение.CurrentBalanceClosing = Стр.CurrentBalanceClosingLT + Стр.CurrentBalanceClosingST;
		Если Стр.Договор.ДС_РаспределятьАванс Тогда
			Движение.LeasePaymentActualRaspred = - Стр.LeasePaymentActualRaspred;
		КонецЕсли;	
	КонецЦикла;	
	
	Для Каждого Стр из ФактическиеПлатежиМашины Цикл
		Движение = Движения.ДС_ФактическиеПлатежи.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, Стр);
		Движение.ПериодПлатежа = Стр.Период;
		// is ЯннуровВФ нач 20140725
		Движение.LeasePaymentПлан = - Стр.LeasePaymentПлан;
		// is ЯннуровВФ кон 20140725
		Движение.LeasePaymentActual = - Стр.LeasePaymentActual;
		Движение.CurrentBalanceClosing = Стр.CurrentBalanceClosingLT + Стр.CurrentBalanceClosingST;
		Если Стр.Договор.ДС_РаспределятьАванс Тогда
			Движение.LeasePaymentActualRaspred = - Стр.LeasePaymentActualRaspred;
		КонецЕсли;	
	КонецЦикла;
	
	// is ЯннуровВФ нач 20140618 0И-001401
	Движения.ДС_ФактическиеПлатежи.Записать();
	
	Движения.Международный.Записывать = Истина;
	
	лВалютаУчета = Константы.ВалютаМеждународногоУчета.Получить();
	
	лЗапрос = Новый Запрос;
	лЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиОборудование.Договор КАК Договор,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиОборудование.Договор.ДС_ОбъектДоговора КАК ОсновноеСредство,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиОборудование.ДатаПлатежа КАК ДатаПлатежа,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиОборудование.ВидПлатежа КАК ВидПлатежа,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиОборудование.FinanceCostПлан КАК FinanceCostПлан,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиОборудование.FinanceCost КАК FinanceCost,
	|	-ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиОборудование.LeasePaymentActual КАК LeasePaymentActual,
	|	-ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиОборудование.LeasePaymentActualRaspred КАК LeasePaymentActualRaspred,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиОборудование.ис_СчетОтнесенияПроцентов,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиОборудование.ис_СчетРасчетов
	|ПОМЕСТИТЬ втФакт
	|ИЗ
	|	Документ.ДС_РасчетФактическогоПлатежаМСФО.ФактическиеПлатежиОборудование КАК ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиОборудование
	|ГДЕ
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиОборудование.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиМашины.Договор,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиМашины.Договор.ДС_ОбъектДоговора,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиМашины.ДатаПлатежа,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиМашины.ВидПлатежа,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиМашины.FinanceCostПлан,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиМашины.FinanceCost,
	|	-ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиМашины.LeasePaymentActual,
	|	-ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиМашины.LeasePaymentActualRaspred КАК LeasePaymentActualRaspred,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиМашины.ис_СчетОтнесенияПроцентов,
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиМашины.ис_СчетРасчетов
	|ИЗ
	|	Документ.ДС_РасчетФактическогоПлатежаМСФО.ФактическиеПлатежиМашины КАК ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиМашины
	|ГДЕ
	|	ДС_РасчетФактическогоПлатежаМСФОФактическиеПлатежиМашины.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Договор,
	|	ДатаПлатежа,
	|	ВидПлатежа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	втФакт.Договор КАК Договор,
	|	втФакт.ОсновноеСредство,
	|	НЕ ОсновныеСредстваМеждународныйУчетСрезПоследних.НачислятьАмортизацию КАК Консервация
	|ПОМЕСТИТЬ втДанныеОсновныхСредств
	|ИЗ
	|	втФакт КАК втФакт
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних КАК ОсновныеСредстваМеждународныйУчетСрезПоследних
	|		ПО втФакт.ОсновноеСредство = ОсновныеСредстваМеждународныйУчетСрезПоследних.ОсновноеСредство
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Договор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	втФакт.Договор.Владелец КАК Контрагент,
	|	втФакт.Договор КАК Договор,
	|	втФакт.Договор.ДС_РаспределятьАванс КАК ДС_РаспределятьАванс,
	|	втФакт.ОсновноеСредство,
	|	втФакт.ис_СчетОтнесенияПроцентов,
	|	втФакт.ис_СчетРасчетов,
	|	втФакт.FinanceCostПлан КАК FinanceCostПлан,
	|	втФакт.FinanceCost КАК FinanceCostФакт,
	|	втФакт.LeasePaymentActual КАК LeasePaymentФакт,
	|	втФакт.LeasePaymentActualRaspred КАК LeasePaymentРаспр,
	|	ЕСТЬNULL(ДС_ГрафикПлатежей.LeasePaymentProvided, 0) КАК LeasePaymentПлан,
	|	ЕСТЬNULL(втДанныеОсновныхСредств.Консервация, ЛОЖЬ) КАК Консервация
	|ИЗ
	|	втФакт КАК втФакт
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДС_ГрафикПлатежей КАК ДС_ГрафикПлатежей
	|		ПО втФакт.Договор = ДС_ГрафикПлатежей.Договор
	|			И втФакт.Договор.ис_Продлен = ДС_ГрафикПлатежей.Регистратор.ис_Продлен
	|			И втФакт.ДатаПлатежа = ДС_ГрафикПлатежей.ДатаПлатежа
	|			И втФакт.ВидПлатежа = ДС_ГрафикПлатежей.ВидПлатежа
	|		ЛЕВОЕ СОЕДИНЕНИЕ втДанныеОсновныхСредств КАК втДанныеОсновныхСредств
	|		ПО втФакт.Договор = втДанныеОсновныхСредств.Договор";
	лЗапрос.УстановитьПараметр("Ссылка", Ссылка);
	лВыборка = лЗапрос.Выполнить().Выбрать();
	Пока лВыборка.Следующий() Цикл 
		
		лКурсВалюты = МодульВалютногоУчета.ПолучитьКурсВалюты(лВыборка.Договор.ВалютаВзаиморасчетов, Дата);
		
		// is ЯннуровВФ нач 20140919
		Если Не ис_ВводНачальныхОстатков Тогда 
		// is ЯннуровВФ кон 20140919
			// Отнесение процентов		
			лПроводка = Движения.Международный.Добавить();
			лПроводка.Период = Дата;
			лПроводка.Организация = Организация;
			//Если лВыборка.LeasePaymentПлан - лВыборка.LeasePaymentФакт > 0
			// И Не лВыборка.Консервация Тогда 
			Если лВыборка.FinanceCostПлан < 0
			 И Не лВыборка.Консервация Тогда 
				лПроводка.СчетДт = ПланыСчетов.Международный.ПрочиеВнереализационныеДоходы;
			Иначе
				лПроводка.СчетДт = ПланыСчетов.Международный.ПрочиеВнереализационныеРасходы;
			КонецЕсли;
			БухгалтерскийУчет.УстановитьСубконто(лПроводка.СчетДт, лПроводка.СубконтоДт, 1, ис_СтатьяПрочихДоходовИРасходов);
			лПроводка.СчетКт = лВыборка.ис_СчетОтнесенияПроцентов;
			БухгалтерскийУчет.УстановитьСубконто(лПроводка.СчетКт, лПроводка.СубконтоКт, 1, лВыборка.Контрагент);
			БухгалтерскийУчет.УстановитьСубконто(лПроводка.СчетКт, лПроводка.СубконтоКт, 2, лВыборка.Договор);
			лПроводка.Сумма = лВыборка.FinanceCostПлан * лКурсВалюты.Курс * лКурсВалюты.Кратность;
			Если лПроводка.СчетКт.Валютный Тогда 
				лПроводка.ВалютаКт = лВыборка.Договор.ВалютаВзаиморасчетов;
				лПроводка.ВалютнаяСуммаКт = лВыборка.FinanceCostПлан;
			КонецЕсли;
			лПроводка.Содержание = "Проценты по фактическому платежу лизинга";
		КонецЕсли;
		
		// is ЯннуровВФ нач 20140623 Перенесено в начисление курсовой разницы
		//// Платеж
		//лПроводка = Движения.Международный.Добавить();
		//лПроводка.Период = Дата;
		//лПроводка.Организация = Организация;
		//лПроводка.СчетДт = ПланыСчетов.Международный.ПрочиеВнереализационныеРасходы;
		//БухгалтерскийУчет.УстановитьСубконто(лПроводка.СчетДт, лПроводка.СубконтоДт, 1, ис_СтатьяПрочихДоходовИРасходов);
		//лПроводка.СчетКт = лВыборка.ис_СчетРасчетов;
		//БухгалтерскийУчет.УстановитьСубконто(лПроводка.СчетКт, лПроводка.СубконтоКт, 1, лВыборка.Контрагент);
		//БухгалтерскийУчет.УстановитьСубконто(лПроводка.СчетКт, лПроводка.СубконтоКт, 2, лВыборка.Договор);
		//лПроводка.Сумма = лВыборка.LeasePaymentФакт * лКурсВалюты.Курс * лКурсВалюты.Кратность;
		//Если лПроводка.СчетКт.Валютный Тогда 
		//	лПроводка.ВалютаКт = лВыборка.Договор.ВалютаВзаиморасчетов;
		//	лПроводка.ВалютнаяСуммаКт = лВыборка.LeasePaymentФакт;
		//КонецЕсли;
		//лПроводка.Содержание = "Фактический платеж лизинга";
		// is ЯннуровВФ кон 20140623
		
		// is ЯннуровВФ нач 20140725
		// Распределение авансов
		// is ЯннуровВФ нач 20140919
		Если Не ис_ВводНачальныхОстатков Тогда 
		// is ЯннуровВФ кон 20140919
			Если лВыборка.ДС_РаспределятьАванс Тогда
				лПроводка = Движения.Международный.Добавить();
				лПроводка.Период = Дата;
				лПроводка.Организация = Организация;
				лПроводка.СчетДт = лВыборка.ис_СчетОтнесенияПроцентов; // счет долгосрочной задолженности
				БухгалтерскийУчет.УстановитьСубконто(лПроводка.СчетДт, лПроводка.СубконтоДт, 1, лВыборка.Контрагент);
				БухгалтерскийУчет.УстановитьСубконто(лПроводка.СчетДт, лПроводка.СубконтоДт, 2, лВыборка.Договор);
				лПроводка.СчетКт = лВыборка.ис_СчетРасчетов; // счет авансов
				БухгалтерскийУчет.УстановитьСубконто(лПроводка.СчетКт, лПроводка.СубконтоКт, 1, лВыборка.Контрагент);
				БухгалтерскийУчет.УстановитьСубконто(лПроводка.СчетКт, лПроводка.СубконтоКт, 2, лВыборка.Договор);
				лПроводка.Сумма = лВыборка.LeasePaymentРаспр * лКурсВалюты.Курс * лКурсВалюты.Кратность;
				Если лПроводка.СчетКт.Валютный Тогда 
					лПроводка.ВалютаКт = лВыборка.Договор.ВалютаВзаиморасчетов;
					лПроводка.ВалютнаяСуммаКт = лВыборка.LeasePaymentРаспр;
				КонецЕсли;
				лПроводка.Содержание = "Авансы по фактическому платежу лизинга";
			КонецЕсли;
		КонецЕсли;
		// is ЯннуровВФ кон 20140725
		
	КонецЦикла;
	// is ЯннуровВФ кон 20140618
	
КонецПроцедуры
