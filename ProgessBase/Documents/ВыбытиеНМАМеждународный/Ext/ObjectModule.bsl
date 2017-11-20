﻿Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

Процедура ОбработкаПроведения(Отказ)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	Для Каждого ТекСтрокаНематериальныеАктивы Из НематериальныеАктивы Цикл
		
		/// Кунов О.В., 08.11.2016 - 58622
		ТипНМА = ТипЗнч(ТекСтрокаНематериальныеАктивы.НематериальныйАктив);
		
		Если ТипНМА = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
			ДвижениеПоНематериальнымАктивам(ТекСтрокаНематериальныеАктивы);
		ИначеЕсли ТипНМА = Тип("СправочникСсылка.РасходыБудущихПериодов") Тогда
			ДвижениеПоРБП(ТекСтрокаНематериальныеАктивы);
		КонецЕсли;
		///
		
	КонецЦикла;

	// записываем движения регистров
	Движения.НематериальныеАктивыМеждународныйУчет.Записать();
	Движения.Международный.Записать();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

/// Кунов О.В., 08.11.2016 - 58622
Процедура ДвижениеПоНематериальнымАктивам(ТекСтрокаНематериальныеАктивы)

	СрезСведенийМежд = РегистрыСведений.НематериальныеАктивыМеждународныйУчет.ПолучитьПоследнее(Дата, Новый Структура("НематериальныйАктив", ТекСтрокаНематериальныеАктивы.НематериальныйАктив));

	// регистр НематериальныеАктивыМеждународныйУчет 
	Движение = Движения.НематериальныеАктивыМеждународныйУчет.Добавить();
	Движение.Период = Дата;
	Движение.НематериальныйАктив = ТекСтрокаНематериальныеАктивы.НематериальныйАктив;
	Движение.СчетУчета = СрезСведенийМежд.СчетУчета;
	Движение.СрокПолезногоИспользования = СрезСведенийМежд.СрокПолезногоИспользования;
	Движение.МетодНачисленияАмортизации = СрезСведенийМежд.МетодНачисленияАмортизации;
	Движение.СчетНачисленияАмортизации = СрезСведенийМежд.СчетНачисленияАмортизации;
	Движение.СчетЗатрат = СрезСведенийМежд.СчетЗатрат;
	Движение.Субконто1 = СрезСведенийМежд.Субконто1;
	Движение.Субконто2 = СрезСведенийМежд.Субконто2;
	Движение.Субконто3 = СрезСведенийМежд.Субконто3;
	Движение.ПредполагаемыйОбъемПродукции = СрезСведенийМежд.ПредполагаемыйОбъемПродукции;
	Движение.ФактическийОбъемПродукции = СрезСведенийМежд.ФактическийОбъемПродукции;
	Движение.СуммаНачисленнойАмортизации = СрезСведенийМежд.СуммаНачисленнойАмортизации;
	Движение.ПервоначальнаяСтоимость = СрезСведенийМежд.ПервоначальнаяСтоимость;
	Движение.СправедливаяСтоимость = СрезСведенийМежд.СправедливаяСтоимость;
	Движение.ЛиквидационнаяСтоимость = СрезСведенийМежд.ЛиквидационнаяСтоимость;
	Движение.ДатаПринятияКУчету = СрезСведенийМежд.ДатаПринятияКУчету;
	Движение.СчетСниженияСтоимости = СрезСведенийМежд.СчетСниженияСтоимости;
	Движение.НачислятьАмортизацию = Ложь;

	// Проверка "хвостов" по "СчетУчета" и "СчетНачисленияАмортизации"
	МассивСчетов = Новый Массив(); // массив счетов учета
	МассивСчетов.Добавить(СрезСведенийМежд.СчетУчета);
	МассивСчетов.Добавить(СрезСведенийМежд.СчетНачисленияАмортизации);
	МассивСчетов.Добавить(СрезСведенийМежд.СчетСниженияСтоимости);
	
	КорСчет = Новый Массив(); // массив счетов исключений по Дт
	КорСчет.Добавить(СрезСведенийМежд.СчетУчета);
	КорСчет.Добавить(СрезСведенийМежд.СчетНачисленияАмортизации);
	КорСчет.Добавить(СрезСведенийМежд.СчетСниженияСтоимости);
	// is ЯннуровВФ нач 20140707 0И-001480		
	//КорСчет.Добавить(ПланыСчетов.Международный.РезервыНаПереоценкуНМА);
	// is ЯннуровВФ кон 20140707

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	МеждународныйОбороты.Субконто1 КАК НМА,
	               |	СУММА(МеждународныйОбороты.СуммаОборотКт) КАК СуммаОборотКт,
	               |	МеждународныйОбороты.КорСчет,
	               |	МеждународныйОбороты.Счет
	               |ИЗ
	               |	РегистрБухгалтерии.Международный.Обороты(&НачалоПериода, &КонецПериода, Период, Счет В ИЕРАРХИИ (&Счет), &НМА, Организация = &Организация, НЕ(КорСчет В ИЕРАРХИИ (&КорСчет)), ) КАК МеждународныйОбороты
	               |
	               |ГДЕ
	               |	МеждународныйОбороты.Субконто1 = &НематериальныйАктив
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	МеждународныйОбороты.Субконто1,
	               |	МеждународныйОбороты.КорСчет,
	               |	МеждународныйОбороты.Счет";
	
	Запрос.УстановитьПараметр("НачалоПериода", ПериодНачало);
	Запрос.УстановитьПараметр("КонецПериода", ПериодКонец);
	Запрос.УстановитьПараметр("Счет", МассивСчетов);
	Запрос.УстановитьПараметр("НМА", ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НематериальныйАктив", ТекСтрокаНематериальныеАктивы.НематериальныйАктив);
	Запрос.УстановитьПараметр("КорСчет", КорСчет);

	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда // Если были операции, связанные с выбытием.
		СЗЗакрытия = Новый СписокЗначений();
		СЗЗакрытия.Добавить(Выборка.Счет);
		Если (ЗначениеЗаполнено(СрезСведенийМежд.СчетУчета)) и (СЗЗакрытия.НайтиПоЗначению(СрезСведенийМежд.СчетУчета)=Неопределено) Тогда
			СЗЗакрытия.Добавить(СрезСведенийМежд.СчетУчета);
		КонецЕсли;
		Если (ЗначениеЗаполнено(СрезСведенийМежд.СчетНачисленияАмортизации)) и (СЗЗакрытия.НайтиПоЗначению(СрезСведенийМежд.СчетНачисленияАмортизации)=Неопределено) Тогда
			СЗЗакрытия.Добавить(СрезСведенийМежд.СчетНачисленияАмортизации);
		КонецЕсли;
		Если (ЗначениеЗаполнено(СрезСведенийМежд.СчетСниженияСтоимости)) и (СЗЗакрытия.НайтиПоЗначению(СрезСведенийМежд.СчетСниженияСтоимости)=Неопределено) Тогда
			СЗЗакрытия.Добавить(СрезСведенийМежд.СчетСниженияСтоимости);
		КонецЕсли;
		
		Для каждого Сч из СЗЗакрытия Цикл
			БухИтоги = Обработки.БухгалтерскиеИтоги.Создать();
			БухИтоги.РассчитатьИтоги("Международный", "КонечныйОстатокДт,КонечныйОстатокКт", "Сумма", "Счет,Субконто1", Дата, Дата, , Сч.Значение, ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы, , ,"Организация", Организация);
			СуммаДт = БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокДт", "Счет,Субконто1", Сч.Значение, ТекСтрокаНематериальныеАктивы.НематериальныйАктив) - БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокКт", "Счет,Субконто1", Сч.Значение, ТекСтрокаНематериальныеАктивы.НематериальныйАктив);
			Если СуммаДт <> 0 Тогда // Если есть остаток, то списываем его
				Движение = Движения.Международный.Добавить();
				Движение.Период = Дата;
				Движение.СчетДт = Выборка.КорСчет;
				Движение.СчетКт = Сч.Значение;
				Движение.Организация = Организация;
				Движение.Сумма = СуммаДт;
				Движение.Содержание = "Выбытие НМА";
				Движение.НомерЖурнала = "Рег";
				
				Если не Движение.СчетДт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы,) = Неопределено Тогда
					Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы] = ТекСтрокаНематериальныеАктивы.НематериальныйАктив;
				КонецЕсли;
				
				Если не Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы,) = Неопределено Тогда
					Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы] = ТекСтрокаНематериальныеАктивы.НематериальныйАктив;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Сообщить("За указанный период выбытия объекта НМА "+ТекСтрокаНематериальныеАктивы.НематериальныйАктив+" в базе не зарегистрировано.");
		Сообщить("Корректирующие проводки по списанию объекта не сформированы.");
	КонецЕсли;

	// is ЯннуровВФ нач 20140707 0И-001480
	//// Проверяем, был ли резерв переоценки по данному НМА
	//БухИтоги = Обработки.БухгалтерскиеИтоги.Создать();
	//БухИтоги.РассчитатьИтоги("Международный", "КонечныйОстатокДт,КонечныйОстатокКт", "Сумма", "Счет,Субконто1", Дата, Дата, , ПланыСчетов.Международный.РезервыНаПереоценкуНМА, ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы, , ,"Организация", Организация);
	//СуммаКт = БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокКт", "Счет,Субконто1", ПланыСчетов.Международный.РезервыНаПереоценкуНМА, ТекСтрокаНематериальныеАктивы.НематериальныйАктив) - БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокДт", "Счет,Субконто1", ПланыСчетов.Международный.РезервыНаПереоценкуНМА, ТекСтрокаНематериальныеАктивы.НематериальныйАктив);
	//
	//Если СуммаКт <> 0 Тогда
	//	Движение = Движения.Международный.Добавить();
	//	Движение.Период = Дата;
	//	Движение.СчетДт = ПланыСчетов.Международный.РезервыНаПереоценкуНМА;
	//	Движение.СчетКт = ПланыСчетов.Международный.НераспределеннаяПрибыль;
	//	Движение.Организация = Организация;
	//	Движение.Сумма = СуммаКт;
	//	Движение.Содержание = "Закрытие резерва переоценки НМА";
	//	Движение.НомерЖурнала = "Рег";
	//	
	//	Если не Движение.СчетДт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы,) = Неопределено Тогда
	//		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы] = ТекСтрокаНематериальныеАктивы.НематериальныйАктив;
	//	КонецЕсли;
	//	
	//	Если не Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы,) = Неопределено Тогда
	//		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы] = ТекСтрокаНематериальныеАктивы.НематериальныйАктив;
	//	КонецЕсли;
	//КонецЕсли;
	// is ЯннуровВФ кон 20140707
	
КонецПроцедуры

Процедура ДвижениеПоРБП(ТекСтрокаНематериальныеАктивы)
	
	Актив = ТекСтрокаНематериальныеАктивы.НематериальныйАктив;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МеждународныйОстатки04.Счет КАК Счет04,
	|	МеждународныйОстатки04.Субконто1,
	|	МеждународныйОстатки04.СуммаОстатокДт КАК ПервоначальнаяСтоимость,
	|	МеждународныйОстатки05.Счет КАК Счет05,
	|	ЕСТЬNULL(МеждународныйОстатки05.СуммаОстатокКт, 0) КАК Амортизация
	|ИЗ
	|	РегистрБухгалтерии.Международный.Остатки(&ДатаОстатков, Счет В (&СписокСчетовРБП), &СубконтоРБП, Субконто1 = &РБП) КАК МеждународныйОстатки04
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(&ДатаОстатков, Счет В (&СписокСчетовАмортизация), &СубконтоРБП, Субконто1 = &РБП) КАК МеждународныйОстатки05
	|		ПО МеждународныйОстатки04.Субконто1 = МеждународныйОстатки05.Субконто1");
	
	СписокСчетовРБП = Новый Массив;
	СписокСчетовРБП.Добавить(ПланыСчетов.Международный.ПрограммноеОбеспечениеНетто);
	СписокСчетовАмортизация = Новый Массив;
	СписокСчетовАмортизация.Добавить(ПланыСчетов.Международный.АмортизацияПрограммногоОбеспечения);
	
	РБП = ПланыВидовХарактеристик.ВидыСубконтоМеждународные.РасходыБудущихПериодов;
	
	Запрос.УстановитьПараметр("ДатаОстатков", 				Дата);
	Запрос.УстановитьПараметр("СписокСчетовРБП", 			СписокСчетовРБП);
	Запрос.УстановитьПараметр("СписокСчетовАмортизация", 	СписокСчетовАмортизация);
	Запрос.УстановитьПараметр("СубконтоРБП", 				РБП);
	Запрос.УстановитьПараметр("РБП", 						Актив);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СчетПрочихРасходов 	= ПланыСчетов.Международный.ПрочиеВнереализационныеРасходы;
		СчетПрочихДоходов	= ПланыСчетов.Международный.ПрочиеВнереализационныеДоходы;
		
		Движение = Движения.Международный.Добавить();
		Движение.Период 		= Дата;
		Движение.Организация 	= Организация;
		
		Движение.СчетДт 		= СчетПрочихРасходов;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ПрочиеДоходыИРасходы] = СтатьяПрочихДоходовРасходов;
		
		Движение.СчетКт 		= Выборка.Счет04;
		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.РасходыБудущихПериодов] = Выборка.Субконто1;
		
		Если СчетПрочихРасходов.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Подразделения) <> Неопределено Тогда
			Если ТипЗнч(Актив.СубконтоБУ1) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
				Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Подразделения] = Актив.СубконтоБУ1;
			ИначеЕсли ТипЗнч(Актив.СубконтоБУ2) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
				Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Подразделения] = Актив.СубконтоБУ2;
			ИначеЕсли ТипЗнч(Актив.СубконтоБУ3) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
				Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Подразделения] = Актив.СубконтоБУ3;
			ИначеЕсли ТипЗнч(Актив.ПодразделениеОрганизации) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
				Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Подразделения] = Актив.ПодразделениеОрганизации;
			КонецЕсли;
		КонецЕсли;
		
		Движение.Содержание = "Списана балансовая стоимость";
		Движение.Сумма = Выборка.ПервоначальнаяСтоимость;
		
		Если ЗначениеЗаполнено(Выборка.Счет05) Тогда
			
			Движение = Движения.Международный.Добавить();
			Движение.Период 		= Дата;
			Движение.Организация 	= Организация;
			
			Движение.СчетДт 		= Выборка.Счет05;
			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.РасходыБудущихПериодов] = Выборка.Субконто1;
			
			Движение.СчетКт			= СчетПрочихДоходов;
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ПрочиеДоходыИРасходы] = СтатьяПрочихДоходовРасходов;
			
			Если СчетПрочихДоходов.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Подразделения) <> Неопределено Тогда
				Если ТипЗнч(Актив.СубконтоБУ1) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
					Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Подразделения] = Актив.СубконтоБУ1;
				ИначеЕсли ТипЗнч(Актив.СубконтоБУ2) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
					Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Подразделения] = Актив.СубконтоБУ2;
				ИначеЕсли ТипЗнч(Актив.СубконтоБУ3) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
					Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Подразделения] = Актив.СубконтоБУ3;
				ИначеЕсли ТипЗнч(Актив.ПодразделениеОрганизации) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
					Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Подразделения] = Актив.ПодразделениеОрганизации;
				КонецЕсли;
			КонецЕсли;
			
			Движение.Содержание = "Списана амортизация";
			Движение.Сумма = Выборка.Амортизация;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
///

