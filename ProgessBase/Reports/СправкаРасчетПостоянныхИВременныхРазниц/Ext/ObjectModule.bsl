﻿#Если Клиент Тогда
	
	Перем НП Экспорт;
	Перем ОбластьОкончаниеТаблицы;
	Перем мСтавкаНалогаНаПрибыль;
	Перем ОграниченияПоПостроителюОтчета;
	Перем ТаблицаАктивовИОбязательств;
	Перем ТаблицаВидовАктивовИОбязательств;
	Перем ОборотыВременныхРазниц;
	
Функция СформироватьТекстЗапроса(КоличествоОбъектовАналитики)
		 
		Текст	= "ВЫБРАТЬ
		     	  |	НалоговыйОбороты.Счет,
		     	  |	НалоговыйОбороты.Субконто1 КАК Субконто1,
		     	  |	НалоговыйОбороты.Субконто2 КАК Субконто2,
		     	  |	НалоговыйОбороты.Субконто3 КАК Субконто3,
		     	  |	ВЫБОР
		     	  |		КОГДА НЕ НалоговыйОбороты.КорСчет В ИЕРАРХИИ (&СчетЕН)
		     	  |				И НЕ(НалоговыйОбороты.КорСчет В ИЕРАРХИИ (&Счет90)
		     	  |						И НалоговыйОбороты.ВидУчетаКор = &ВидУчета)
		     	  |			ТОГДА ВЫБОР
		     	  |					КОГДА НалоговыйОбороты.Счет.Вид = &Пассивный
		     	  |						ТОГДА -НалоговыйОбороты.СуммаОборотКт + ВЫБОР
		     	  |								КОГДА НалоговыйОбороты.СуммаОборотДт < 0
		     	  |									ТОГДА НалоговыйОбороты.СуммаОборотДт
		     	  |								ИНАЧЕ 0
		     	  |							КОНЕЦ
		     	  |					ИНАЧЕ НалоговыйОбороты.СуммаОборотДт - ВЫБОР
		     	  |							КОГДА НалоговыйОбороты.СуммаОборотКт < 0
		     	  |								ТОГДА НалоговыйОбороты.СуммаОборотКт
		     	  |							ИНАЧЕ 0
		     	  |						КОНЕЦ
		     	  |				КОНЕЦ
		     	  |		ИНАЧЕ 0
		     	  |	КОНЕЦ КАК Признано,
		     	  |	ВЫБОР
		     	  |		КОГДА НЕ НалоговыйОбороты.КорСчет В ИЕРАРХИИ (&СчетЕН)
		     	  |				И НЕ НалоговыйОбороты.КорСчет В ИЕРАРХИИ (&Счет90)
		     	  |			ТОГДА ВЫБОР
		     	  |					КОГДА НалоговыйОбороты.Счет.Вид = &Пассивный
		     	  |						ТОГДА ВЫБОР
		     	  |								КОГДА НалоговыйОбороты.СуммаОборотДт > 0
		     	  |									ТОГДА НалоговыйОбороты.СуммаОборотДт
		     	  |								ИНАЧЕ 0
		     	  |							КОНЕЦ
		     	  |					ИНАЧЕ ВЫБОР
		     	  |							КОГДА НалоговыйОбороты.СуммаОборотКт > 0
		     	  |								ТОГДА НалоговыйОбороты.СуммаОборотКт
		     	  |							ИНАЧЕ 0
		     	  |						КОНЕЦ
		     	  |				КОНЕЦ
		     	  |		ИНАЧЕ 0
		     	  |	КОНЕЦ КАК Перенесено,
		     	  |	ВЫБОР
		     	  |		КОГДА НалоговыйОбороты.КорСчет В ИЕРАРХИИ (&СчетЕН)
		     	  |				И НалоговыйОбороты.ВидУчетаКор = &ВидУчета
		     	  |			ТОГДА ВЫБОР
		     	  |					КОГДА НалоговыйОбороты.Счет.Вид = &Пассивный
		     	  |						ТОГДА НалоговыйОбороты.СуммаОборотДт - НалоговыйОбороты.СуммаОборотКт
		     	  |					ИНАЧЕ НалоговыйОбороты.СуммаОборотКт - НалоговыйОбороты.СуммаОборотДт
		     	  |				КОНЕЦ
		     	  |		ИНАЧЕ 0
		     	  |	КОНЕЦ КАК СписаноНеННП,
		     	  |	ВЫБОР
		     	  |		КОГДА НалоговыйОбороты.КорСчет В ИЕРАРХИИ (&Счет90)
		     	  |				И НалоговыйОбороты.ВидУчетаКор = &ВидУчета
		     	  |			ТОГДА ВЫБОР
		     	  |					КОГДА НалоговыйОбороты.Счет.Вид = &Пассивный
		     	  |						ТОГДА НалоговыйОбороты.СуммаОборотДт - НалоговыйОбороты.СуммаОборотКт
		     	  |					ИНАЧЕ НалоговыйОбороты.СуммаОборотКт - НалоговыйОбороты.СуммаОборотДт
		     	  |				КОНЕЦ
		     	  |		ИНАЧЕ ВЫБОР
		     	  |				КОГДА НалоговыйОбороты.КорСчет В ИЕРАРХИИ (&Счет91_2)
		     	  |				И НалоговыйОбороты.ВидУчетаКор = &ВидУчета
		     	  |					ТОГДА ВЫБОР
		     	  |							КОГДА НалоговыйОбороты.Счет.Вид = &Пассивный
		     	  |								ТОГДА -НалоговыйОбороты.СуммаОборотДт + НалоговыйОбороты.СуммаОборотКт
		     	  |							ИНАЧЕ -НалоговыйОбороты.СуммаОборотКт + НалоговыйОбороты.СуммаОборотДт
		     	  |						КОНЕЦ
		     	  |				ИНАЧЕ ВЫБОР
		     	  |						КОГДА НалоговыйОбороты.Счет В ИЕРАРХИИ (&Счет91_2)
		     	  |							ТОГДА ВЫБОР
		     	  |									КОГДА НалоговыйОбороты.ВидУчетаКор = НалоговыйОбороты.ВидУчета
		     	  |										ТОГДА 0
		     	  |									ИНАЧЕ -НалоговыйОбороты.СуммаОборотКт + НалоговыйОбороты.СуммаОборотДт
		     	  |								КОНЕЦ
		     	  |						ИНАЧЕ ВЫБОР
		     	  |								КОГДА НалоговыйОбороты.Счет В ИЕРАРХИИ (&Счет91_1)
		     	  |									ТОГДА НалоговыйОбороты.СуммаОборотКт - НалоговыйОбороты.СуммаОборотДт
		     	  |								ИНАЧЕ 0
		     	  |							КОНЕЦ
		     	  |					КОНЕЦ
		     	  |			КОНЕЦ
		     	  |	КОНЕЦ КАК СписаноНаННП,
		     	  |	0 КАК ПризнаноРанее,
		     	  |	0 КАК Остаток
		     	  |ИЗ
		     	  |	РегистрБухгалтерии.Налоговый.Обороты(
		     	  |			&НачалоПериода,
		     	  |			&КонецПериода,
		     	  |			Месяц,
		     	  |			Счет В ИЕРАРХИИ (&Счет),
		     	  |			&ВидСубконто,
		     	  |			Организация = &Организация
		     	  |				И ВидУчета = &ВидУчета,
		     	  |			,
		     	  |			) КАК НалоговыйОбороты
		     	  |
		     	  |ОБЪЕДИНИТЬ ВСЕ
		     	  |
		     	  |ВЫБРАТЬ
		     	  |	НалоговыйОстатки.Счет,
		     	  |	НалоговыйОстатки.Субконто1,
		     	  |	НалоговыйОстатки.Субконто2,
		     	  |	НалоговыйОстатки.Субконто3,
		     	  |	0,
		     	  |	0,
		     	  |	0,
		     	  |	0,
		     	  |	ВЫБОР
		     	  |		КОГДА НалоговыйОстатки.Счет.Вид = &Пассивный
		     	  |			ТОГДА -НалоговыйОстатки.СуммаОстатокКт
		     	  |		ИНАЧЕ НалоговыйОстатки.СуммаОстатокДт
		     	  |	КОНЕЦ,
		     	  |	0
		     	  |ИЗ
		     	  |	РегистрБухгалтерии.Налоговый.Остатки(
		     	  |			&КонецПрошлогоПериода,
		     	  |			Счет В ИЕРАРХИИ (&Счет),
		     	  |			&ВидСубконто,
		     	  |			Организация = &Организация
		     	  |				И ВидУчета = &ВидУчета) КАК НалоговыйОстатки
		     	  |
		     	  |ОБЪЕДИНИТЬ ВСЕ
		     	  |
		     	  |ВЫБРАТЬ
		     	  |	НалоговыйОстатки.Счет,
		     	  |	НалоговыйОстатки.Субконто1,
		     	  |	НалоговыйОстатки.Субконто2,
		     	  |	НалоговыйОстатки.Субконто3,
		     	  |	0,
		     	  |	0,
		     	  |	0,
		     	  |	0,
		     	  |	0,
		     	  |	ВЫБОР
		     	  |		КОГДА НалоговыйОстатки.Счет.Вид = &Пассивный
		     	  |			ТОГДА -НалоговыйОстатки.СуммаОстатокКт
		     	  |		ИНАЧЕ НалоговыйОстатки.СуммаОстатокДт
		     	  |	КОНЕЦ
		     	  |ИЗ
		     	  |	РегистрБухгалтерии.Налоговый.Остатки(
		     	  |			&КонецПериода,
		     	  |			Счет В ИЕРАРХИИ (&Счет),
		     	  |			&ВидСубконто,
		     	  |			Организация = &Организация
		     	  |				И ВидУчета = &ВидУчета) КАК НалоговыйОстатки
		     	  |
		     	  |УПОРЯДОЧИТЬ ПО
		     	  |	НалоговыйОбороты.Счет,
		     	  |	Субконто1,
		     	  |	Субконто2,
		     	  |	Субконто3
		     	  |ИТОГИ
		     	  |	СУММА(Признано),
		     	  |	СУММА(Перенесено),
		     	  |	СУММА(СписаноНеННП),
		     	  |	СУММА(СписаноНаННП),
		     	  |	СУММА(ПризнаноРанее),
		     	  |	СУММА(Остаток)
		     	  |ПО
		     	  |	ОБЩИЕ,
		     	  |	Субконто1,
		     	  |	Субконто2,
		     	  |	Субконто3";
		
		Если КоличествоОбъектовАналитики < 3 Тогда
			Текст = СтрЗаменить(Текст, "НалоговыйОбороты.Субконто3 КАК Субконто3,", "");
			Текст = СтрЗаменить(Текст, "НалоговыйОстатки.Субконто3,", "");
			Текст = СтрЗаменить(Текст, ",
			|	Субконто3", "");
		КонецЕсли;
		
		Если КоличествоОбъектовАналитики < 2 Тогда
			Текст = СтрЗаменить(Текст, "НалоговыйОбороты.Субконто2 КАК Субконто2,", "");
			Текст = СтрЗаменить(Текст, "НалоговыйОстатки.Субконто2,", "");
			Текст = СтрЗаменить(Текст, ",
			|	Субконто2", "");
		КонецЕсли;
        
		Если КоличествоОбъектовАналитики < 1 Тогда
			Текст = СтрЗаменить(Текст, "НалоговыйОбороты.Субконто1 КАК Субконто1,", "");
			Текст = СтрЗаменить(Текст, "НалоговыйОстатки.Субконто1,", "");
			Текст = СтрЗаменить(Текст, ",
			|	Субконто1", "");
		КонецЕсли;
        
		Если Не ОграниченияПоПостроителюОтчета = "" Тогда
			Текст  = СтрЗаменить(Текст, "Счет В ИЕРАРХИИ (&Счет)","Счет В ИЕРАРХИИ (&Счет) И " + ОграниченияПоПостроителюОтчета);
		КонецЕсли;
		
		Возврат Текст;
		
		
КонецФункции
	
	// Выполняет запрос и формирует табличный документ-результат отчета
	// в соответствии с настройками, заданными значениями реквизитов отчета.
	//
	// Параметры:
	//	ДокументРезультат - табличный документ, формируемый отчетом
	//	ПоказыватьЗаголовок - признак видимости строк с заголовком отчета
	//	ВысотаЗаголовка - параметр, через который возвращается высота заголовка в строках 
	//
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок = Ложь, НачалоПодписи, ПоказыватьПодписи) Экспорт
	
       Если ПериодРегистрации = '00010101000000' Тогда
            Возврат;
        КонецЕсли;
        
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат;
	КонецЕсли;
	
		ИДКонфигурации = РегламентированнаяОтчетность.ИДКонфигурации();
		
		ЭтоУПП = ((ИДКонфигурации = "УПП") ИЛИ (ИДКонфигурации = "КА"));
	
		Если ЭтоУПП Тогда
			
			мУчетнаяПолитикаРегл = ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиРегл(ПериодРегистрации, Организация, Истина);
			Если НЕ ЗначениеЗаполнено(мУчетнаяПолитикаРегл) Тогда
				Отказ = Истина;
				Возврат;
			КонецЕсли; 
			
		Иначе
			мУчетнаяПолитикаРегл = ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитики(ПериодРегистрации, Ложь, Организация, , Истина);
			Если НЕ ЗначениеЗаполнено(мУчетнаяПолитикаРегл) Тогда
				Отказ = Истина;
				Возврат;
			КонецЕсли; 
	   КонецЕсли; 

		ДатаНач = НачалоМесяца(ПериодРегистрации);
		ДатаКон  = КонецМесяца(ПериодРегистрации);
		
		НачалоПериода = Новый Граница(НачалоДня(ДатаНач), ВидГраницы.Включая);
		КонецПериода  = Новый Граница(КонецДня(ДатаКон), ВидГраницы.Включая);
		КонецПрошлогоПериода  = Новый Граница((НачалоДня(ДатаНач) - 1), ВидГраницы.Включая);
		
		ДокументРезультат.Очистить();
		
		Макет      = ПолучитьМакет("Отчет"+ ?(ВариантОтчета = 1, "ПР", "ВР"));
		МакетОбщий = ПолучитьОбщийМакет("СправкаРасчет");
		
		ЗаголовокОтчета = МакетОбщий.ПолучитьОбласть("Заголовок");
		ЗаголовокОтбор  = МакетОбщий.ПолучитьОбласть("СтрокаОтбор");
		ШапкаОтчета     = Макет.ПолучитьОбласть("Шапка");
		
		// Когда нужен только заголовок:
		Если ТолькоЗаголовок Тогда
			Возврат;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВысотаЗаголовка) Тогда
			ДокументРезультат.Область("R1:R" + ВысотаЗаголовка).Видимость = ПоказыватьЗаголовок;
		КонецЕсли;
		
		ТаблицаАктивовИОбязательств = Новый ТаблицаЗначений;
		ТаблицаАктивовИОбязательств.Колонки.Добавить("Показатель");
		ТаблицаАктивовИОбязательств.Колонки.Добавить("ОбластьСтрока");
		ТаблицаАктивовИОбязательств.Колонки.Добавить("Субконто1");
		ТаблицаАктивовИОбязательств.Колонки.Добавить("Субконто2");
		ТаблицаАктивовИОбязательств.Колонки.Добавить("Субконто3");
    	ТаблицаАктивовИОбязательств.Колонки.Добавить("ЭтоИтог",  Новый ОписаниеТипов("Булево"));
		ТаблицаАктивовИОбязательств.Колонки.Добавить("ПризнаноРанее", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 2)));
		ТаблицаАктивовИОбязательств.Колонки.Добавить("Признано", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 2)));
		ТаблицаАктивовИОбязательств.Колонки.Добавить("Перенесено", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 2)));
		ТаблицаАктивовИОбязательств.Колонки.Добавить("СписаноНаННП", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 2)));
		ТаблицаАктивовИОбязательств.Колонки.Добавить("СписаноНеННП", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 2)));
		ТаблицаАктивовИОбязательств.Колонки.Добавить("Обязательства", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 2)));
		ТаблицаАктивовИОбязательств.Колонки.Добавить("Активы", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 2)));
		ТаблицаАктивовИОбязательств.Колонки.Добавить("Обязательства99", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 2)));
		ТаблицаАктивовИОбязательств.Колонки.Добавить("Активы99", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 2)));
		ТаблицаАктивовИОбязательств.Колонки.Добавить("ПризнаноОбязательства", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 2)));
		ТаблицаАктивовИОбязательств.Колонки.Добавить("ПризнаноАктивы", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 2)));
		ТаблицаАктивовИОбязательств.Колонки.Добавить("Остаток", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 2)));
		
		ТаблицаВидовАктивовИОбязательств = НалоговыйУчет.ПолучитьТаблицуВидовАктивовИОбязательств();
		Если ВариантОтчета = 1 Тогда
			ДополнитьТаблицуВидовАктивовИОбязательств(ТаблицаВидовАктивовИОбязательств);
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НачалоПериода",        НачалоПериода);
		Запрос.УстановитьПараметр("КонецПериода",         КонецПериода);
		Запрос.УстановитьПараметр("КонецПрошлогоПериода", КонецПрошлогоПериода);
		Запрос.УстановитьПараметр("Организация", Организация);
			Счета09 = Новый Массив;
			Счета09.Добавить(ПланыСчетов.Налоговый.ВыбытиеОС);
			Счета09.Добавить(ПланыСчетов.Налоговый.ВыбытиеМЦ);
	        Запрос.УстановитьПараметр("Счет09",    Счета09);
			
		// Основная деятельность, облагаемая налогом на прибыль
		Если ВариантОтчета = 2 Тогда
			Запрос.УстановитьПараметр("ВидУчета", Перечисления.ВидыУчетаПоПБУ18.ВР);
		Иначе
			Запрос.УстановитьПараметр("ВидУчета", Перечисления.ВидыУчетаПоПБУ18.ПР);
		КонецЕсли;
		
		Массив = Новый Массив;
		Массив.Добавить(ПланыСчетов.Налоговый.Продажи);
		Запрос.УстановитьПараметр("Счет90", Массив);
		Запрос.УстановитьПараметр("Счет91_1", ПланыСчетов.Налоговый.ПрочиеДоходы);
		Запрос.УстановитьПараметр("Счет91_2", ПланыСчетов.Налоговый.ПрочиеРасходы);
		Запрос.УстановитьПараметр("Пассивный", ВидСчета.Пассивный);
		
		Массив = Новый Массив;
		Массив.Добавить(ПланыСчетов.Налоговый.РасходыПоДеятельностиЕНВД);
		Запрос.УстановитьПараметр("СчетЕН",Массив);
		Текст = "";
		ОграниченияПоПостроителюОтчета = ПолучитьТекстОграничений(ПостроительОтчета, Запрос, Текст);
		
		ОбластьШапка            = Макет.ПолучитьОбласть("Шапка");
		ОбластьСтрока           = Макет.ПолучитьОбласть("Строка");
		ОбластьСтрока1          = Макет.ПолучитьОбласть("Строка1");
		ОбластьСтрока2          = Макет.ПолучитьОбласть("Строка2");
		ОбластьСтрока3          = Макет.ПолучитьОбласть("Строка3");
		
		Если ВариантОтчета = 2 Тогда
		ОбластьФормулы          = Макет.ПолучитьОбласть("Формулы");
		КонецЕсли;
		
		ОбластьИтог             = Макет.ПолучитьОбласть("СтрокаИтого");
		ОбластьОкончаниеТаблицы = Макет.ПолучитьОбласть("ОкончаниеТаблицы");
		
		ОбластьПодвал             = МакетОбщий.ПолучитьОбласть("Подвал");
		
		Всего = 0;
		Заголовок      = ?(ВариантОтчета = 2, "Отложенные","Постоянные") + " налоговые активы и обязательства";
		
		ЗаголовокОтчета.Параметры.Период              = "" + ПредставлениеПериода(НачалоМесяца(ДатаНач), КонецМесяца(ДатаКон), "ФП = Истина");
		ЗаголовокОтчета.Параметры.НазваниеОрганизации = "" + Организация.НаименованиеПолное;
		ЗаголовокОтчета.Параметры.ДатаСоставления     = КонецМесяца(ДатаКон);
		ЗаголовокОтчета.Параметры.НазваниеОтчета      = Заголовок;
		ДокументРезультат.Вывести(ЗаголовокОтчета);
		
		ЗаголовокОтбор.Параметры.ТекстПроОтбор		  = Текст;			
		ДокументРезультат.Вывести(ЗаголовокОтбор);
		
	    КоэффициентЕНВД = НалоговыйУчет.КоэффициентРаспределенияРасходовПоВидамДеятельности(Организация, ДатаНач, ДатаКон, "НУ");
		
		мСтавкаНалогаНаПрибыль = НалоговыйУчет.ПолучитьСтавкуНалогаНаПрибыль(Новый Структура("Организация,Дата",Организация,ДатаКон));
		
		Если ВариантОтчета = 2 Тогда
			ОбластьФормулы.Параметры.Текст377 = "(1): Если гр.2 и 7 больше 0 и гр.2 меньше или равна гр.7, то (гр.7 - гр.2) * " + мСтавкаНалогаНаПрибыль * 100 + "%.";
			ОбластьФормулы.Параметры.Текст477 = "(2): Если гр.2 и 7 больше 0 и гр.2 больше гр.7, то (гр.2 - гр.7) * " + мСтавкаНалогаНаПрибыль * 100 + "%";
			ОбластьФормулы.Параметры.Текст309 = "(3): Если гр.2 и 7 меньше или равна 0 и гр.2 меньше или равна гр.7, то (гр.7 - гр.2) * " + мСтавкаНалогаНаПрибыль * 100 + "%.";
			ОбластьФормулы.Параметры.Текст409 = "(4): Если гр.2 и 7 меньше или равна 0 и гр.2 больше гр.7, то (гр.2 - гр.7) * " + мСтавкаНалогаНаПрибыль * 100 + "%.";
			ОбластьФормулы.Параметры.Текст577 = "       Если гр.2 меньше или равна 0 и гр.7 больше 0, то   гр.7 * " + мСтавкаНалогаНаПрибыль * 100 + "%.";
			ОбластьФормулы.Параметры.Текст677 = "       Если гр.2 больше 0 и гр.7 меньше или равна 0, то   гр.2 * " + мСтавкаНалогаНаПрибыль * 100 + "%";
			ОбластьФормулы.Параметры.Текст509 = "       Если гр.2 меньше 0 и гр.7 больше или равна 0, то - гр.2 * " + мСтавкаНалогаНаПрибыль * 100 + "%.";
			ОбластьФормулы.Параметры.Текст609 = "       Если гр.2 больше или равна 0 и гр.7 меньше 0, то - гр.7 * " + мСтавкаНалогаНаПрибыль * 100 + "%.";
			ОбластьФормулы.Параметры.Текст709 = "       Признание убытков прошлых периодов";
			ОбластьФормулы.Параметры.Текст809 = "       Списание убытков прошлых периодов";
		Иначе
			ОбластьШапка.Параметры.Текст6 = "Для активов и расходов гр.5 * " + мСтавкаНалогаНаПрибыль * 100 + "%";
			ОбластьШапка.Параметры.Текст7 = "Для обязательств и доходов гр.5 * " + мСтавкаНалогаНаПрибыль * 100 + "%";
		КонецЕсли;
		// Параметр для показа заголовка
		ВысотаЗаголовка = 7;
		ДокументРезультат.Вывести(ОбластьШапка);
		
        Для Каждого ВидАктивовИОбязательств Из ТаблицаВидовАктивовИОбязательств Цикл
            
			Если ВидАктивовИОбязательств.ВидАктивовОбязательств = Перечисления.ВидыАктивовИОбязательств.УбытокТекущегоПериода Тогда
				Продолжить;
            КонецЕсли;
            
			КоличествоОбъектовАналитики = ВидАктивовИОбязательств.Субконто.Количество();
			
			Запрос.УстановитьПараметр("ВидСубконто", ВидАктивовИОбязательств.Субконто);
	        Запрос.УстановитьПараметр("Счет",        ВидАктивовИОбязательств.Счета);
			Запрос.Текст = СформироватьТекстЗапроса(КоличествоОбъектовАналитики);
			Результат = Запрос.Выполнить();
			
			ПассивныеСчета = (ВидАктивовИОбязательств.Счета[0].Вид = ВидСчета.Пассивный);
			
			ВыборкаСчет = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ОБЩИЕ");
			ВыборкаСчет.Следующий();
			Если ВыборкаСчет.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			Если ВыборкаСчет.ПризнаноРанее = 0 И
				 ВыборкаСчет.Признано = 0 И
				 ВыборкаСчет.Перенесено = 0 И
				 ВыборкаСчет.СписаноНеННП = 0 И
				 ВыборкаСчет.СписаноНаННП = 0 Тогда
				Продолжить;
			КонецЕсли;
			Если ВариантОтчета = 2 Тогда
				ОборотыВременныхРазниц = НалоговыйУчет.ОборотыВременныхРазницПоВидуАктивовОбязательств(ВидАктивовИОбязательств, Новый Структура("НачГраница,КонГраница,Организация, КоэффициентЕНВД",ДатаНач,ДатаКон,Организация, КоэффициентЕНВД), Истина);
			КонецЕсли;
			ВидАктивовИОбязательств = ВидАктивовИОбязательств.ВидАктивовОбязательств;
			СформироватьСтроку(ВидАктивовИОбязательств, ВидАктивовИОбязательств, ВыборкаСчет, ОбластьСтрока, Неопределено, 0, ПассивныеСчета, КоличествоОбъектовАналитики = 0);
			Выборка1 = ВыборкаСчет.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока Выборка1.Следующий() Цикл
				Если КоличествоОбъектовАналитики >= 1 Тогда
					СформироватьСтроку(ВидАктивовИОбязательств, Выборка1.Субконто1, Выборка1, ОбластьСтрока1, Новый Структура("Субконто1", Выборка1.Субконто1), КоличествоОбъектовАналитики, ПассивныеСчета, КоличествоОбъектовАналитики = 1);
					Если КоличествоОбъектовАналитики = 1 Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
					Выборка2 = Выборка1.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока Выборка2.Следующий() Цикл
						Если КоличествоОбъектовАналитики >= 2 Тогда
							СформироватьСтроку(ВидАктивовИОбязательств, Выборка2.Субконто2, Выборка2, ОбластьСтрока2, Новый Структура("Субконто1,Субконто2", Выборка1.Субконто1, Выборка2.Субконто2), КоличествоОбъектовАналитики, ПассивныеСчета, КоличествоОбъектовАналитики = 2);
							Если КоличествоОбъектовАналитики = 2 Тогда
								Продолжить;
							КонецЕсли;
						КонецЕсли;
						Выборка3 = Выборка2.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
						Пока Выборка3.Следующий() Цикл
							Если КоличествоОбъектовАналитики = 3 Тогда
									СформироватьСтроку(ВидАктивовИОбязательств, Выборка3.Субконто3, Выборка3, ОбластьСтрока3, Новый Структура("Субконто1,Субконто2, Субконто3", Выборка1.Субконто1, Выборка2.Субконто2, Выборка3.Субконто3), КоличествоОбъектовАналитики, ПассивныеСчета, КоличествоОбъектовАналитики = 3);
								КонецЕсли;
								
							КонецЦикла;
					КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
		
		Итоги = ТаблицаАктивовИОбязательств.НайтиСтроки(Новый Структура("ЭтоИтог", Истина));
		ОтрицательныеОбязательства = (ВариантОтчета = 1 И НайтиИтог(Итоги, "Обязательства") < 0);
		ОтрицательныеАктивы = (ВариантОтчета = 1 И НайтиИтог(Итоги, "Активы") < 0);
		
		Для Каждого Строка Из ТаблицаАктивовИОбязательств Цикл
			ОбработатьОтрицательныеАктивыИОбязательства(Строка, ОтрицательныеОбязательства, ОтрицательныеАктивы);
			ВывестиСтроку(Строка, ДокументРезультат);
			
		КонецЦикла;
		
		Итоги = ТаблицаАктивовИОбязательств.НайтиСтроки(Новый Структура("ЭтоИтог", Истина));
		ОбластьИтог.Параметры.Обязательства = НайтиИтог(Итоги, "Обязательства");
		ОбластьИтог.Параметры.Активы = НайтиИтог(Итоги, "Активы");
		
		Если ВариантОтчета = 2 Тогда
			ОбластьИтог.Параметры.Обязательства99 = НайтиИтог(Итоги, "Обязательства99");
			ОбластьИтог.Параметры.Активы99 = НайтиИтог(Итоги, "Активы99");
			ОбластьИтог.Параметры.ПризнаноОбязательства   = НайтиИтог(Итоги, "ПризнаноОбязательства");
			ОбластьИтог.Параметры.ПризнаноАктивы          = НайтиИтог(Итоги, "ПризнаноАктивы");
		КонецЕсли;
		
		ДокументРезультат.Вывести(ОбластьИтог);
		ДокументРезультат.Вывести(ОбластьОкончаниеТаблицы);
		Если ВариантОтчета = 2 Тогда
			ДокументРезультат.Вывести(ОбластьФормулы);
		КонецЕсли;
		
		ДокументРезультат.Вывести(ОбластьПодвал);
		
		ВысотаПодписи = ДокументРезультат.Области.Подвал.Низ - ДокументРезультат.Области.Подвал.Верх;
		
		ДокументРезультат.Области.Подвал.Видимость = ПоказыватьПодписи;
		
		// Присвоим имя для сохранения параметров печати табличного документа
		ДокументРезультат.ИмяПараметровПечати = Заголовок;
		
		УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(ДокументРезультат, ЗаголовокОтчета, Строка(глЗначениеПеременной("глТекущийПользователь")));
		
	КонецПроцедуры // СформироватьОтчет
	
Процедура  СформироватьСтроку(ВидАктивовИОбязательств, Показатель, Выборка, ОбластьСтрока, ПараметрыОтбора, КоличествоСубконто, ПассивныеСчета, ЭтоИтог = Ложь)
		
		Строка = ТаблицаАктивовИОбязательств.Добавить();
		Строка.Показатель   = Показатель;
		Строка.ОбластьСтрока= ОбластьСтрока;
		Строка.Субконто1    = ?(КоличествоСубконто > 0, Выборка.Субконто1, Неопределено);
		Строка.Субконто2    = ?(КоличествоСубконто > 1, Выборка.Субконто2, Неопределено);
		Строка.Субконто3    = ?(КоличествоСубконто > 2, Выборка.Субконто3, Неопределено);
		Строка.ПризнаноРанее= Выборка.ПризнаноРанее;
		Строка.Признано     = Выборка.Признано;
		Строка.Перенесено   = Выборка.Перенесено;
		Строка.СписаноНаННП = Выборка.СписаноНаННП;
		Строка.СписаноНеННП = Выборка.СписаноНеННП;
		Строка.Остаток =      Выборка.Остаток;
	    Строка.ЭтоИтог =      ЭтоИтог;
		
		Если ВариантОтчета = 1 Тогда   // постоянные разницы
			Если Не ПассивныеСчета Тогда
				Строка.Обязательства = Окр(мСтавкаНалогаНаПрибыль * Строка.СписаноНаННП, 2);
				Строка.Активы = 0;
				
			Иначе
				Строка.Обязательства = 0;
				Строка.Активы = Окр(мСтавкаНалогаНаПрибыль * Строка.СписаноНаННП, 2);
			КонецЕсли;
			
			Если ВидАктивовИОбязательств = "Прочие расходы" Тогда
				Строка.Обязательства = Окр(мСтавкаНалогаНаПрибыль * Строка.СписаноНаННП, 2);
				Строка.Активы = 0;
			КонецЕсли;
			Если ВидАктивовИОбязательств = "Прочие доходы" Тогда
				Строка.Обязательства = 0;
				Строка.Активы = Окр(мСтавкаНалогаНаПрибыль * Строка.СписаноНаННП, 2);
			КонецЕсли;
			
			Если Строка.Активы < 0 Тогда 
				Строка.Обязательства   = - Строка.Активы;
				Строка.Активы          = 0;
			КонецЕсли;
			Если Строка.Обязательства < 0 Тогда 
				Строка.Активы        = - Строка.Обязательства;
				Строка.Обязательства = 0;
			КонецЕсли;
			
		Иначе   // временные разницы
			
			Если ПараметрыОтбора = Неопределено Тогда
				ОНА_ОНО = ОборотыВременныхРазниц;
			Иначе
				ОНА_ОНО = ОборотыВременныхРазниц.НайтиСтроки(ПараметрыОтбора); 
			КонецЕсли;    
			
			СуммаЕНВД = мСтавкаНалогаНаПрибыль * НайтиИтог(ОНА_ОНО, "СуммаЕНВД");
			Сумма99 = 0;
			
			ПризнаноАктивы          = мСтавкаНалогаНаПрибыль * НайтиИтог(ОНА_ОНО, "СуммаДт09");
			ОпределитьСумму99(ПризнаноАктивы, СуммаЕНВД, Сумма99);
			Строка.ПризнаноАктивы   = ПризнаноАктивы;
			Строка.Активы99 = Сумма99;
			
			Активы                = мСтавкаНалогаНаПрибыль * НайтиИтог(ОНА_ОНО, "СуммаКт09");
			ОпределитьСумму99(Активы, СуммаЕНВД, Сумма99);
			Строка.Активы         = Активы;
			Строка.Активы99 = Строка.Активы99 - Сумма99;
			
			ПризнаноОбязательства = мСтавкаНалогаНаПрибыль * НайтиИтог(ОНА_ОНО, "СуммаКт77");
			ОпределитьСумму99(ПризнаноОбязательства, СуммаЕНВД, Сумма99);
			Строка.ПризнаноОбязательства = ПризнаноОбязательства;
			Строка.Обязательства99 = Сумма99;
			
			Обязательства         = мСтавкаНалогаНаПрибыль * НайтиИтог(ОНА_ОНО, "СуммаДт77");
			ОпределитьСумму99(Обязательства, СуммаЕНВД, Сумма99);
			Строка.Обязательства = Обязательства;
			Строка.Обязательства99 = Строка.Обязательства99 - Сумма99;
			
		КонецЕсли;
	КонецПроцедуры
	
Процедура ОпределитьСумму99(СуммаНалога,СуммаЕНВД,Сумма99)
	
	ТекСуммаЕНВД = ?(СуммаЕНВД > 0, СуммаЕНВД, -СуммаЕНВД);
	
	Если Не СуммаЕНВД = 0 Тогда
		Если БольшеПоМодулюИлиРавно(СуммаНалога, ТекСуммаЕНВД) Тогда
			СуммаНалога = СуммаНалога - ТекСуммаЕНВД;
			Сумма99 = ТекСуммаЕНВД;
			СуммаЕНВД = 0;
		Иначе
			Сумма99 = СуммаНалога;
			СуммаНалога = 0;
			СуммаЕНВД = ТекСуммаЕНВД - Сумма99;
		КонецЕсли;
	Иначе
		Сумма99 = 0;
	КонецЕсли;
	
	
КонецПроцедуры


Функция  БольшеПоМодулюИлиРавно(Число1, Число2)
	МодульЧисло1 = ?(Число1 > 0, Число1, - Число1);
	МодульЧисло2 = ?(Число2 > 0, Число2, - Число2);
	
	Возврат (МодульЧисло1 - МодульЧисло2 >= 0);
КонецФункции

Процедура ОбработатьОтрицательныеАктивыИОбязательства(Строка, ОтрицательныеОбязательства, ОтрицательныеАктивы)
	
	Активы = Строка.Активы;
	Обязательства = Строка.Обязательства;
	
	// отрицательные обязательства преобразуются в активы
	Если ОтрицательныеОбязательства Тогда
		Строка.Обязательства = Строка.Обязательства - Обязательства;
		Строка.Активы = Строка.Активы - Обязательства;
	КонецЕсли;
	
	// отрицательные активы преобразуются в обязательства
	Если ОтрицательныеАктивы Тогда
		Строка.Обязательства = Строка.Обязательства - Активы;
		Строка.Активы = Строка.Активы - Активы;
	КонецЕсли;
	
	// приводим к одному знаку суммы, повлиявшие на доходы,расходы, и активы-обязательства
	
	Если (Строка.СписаноНаННП + Строка.СписаноНеННП) * (Строка.Активы + Строка.Обязательства) < 0 Тогда
		Строка.СписаноНаННП = - Строка.СписаноНаННП;
		Строка.СписаноНеННП = - Строка.СписаноНеННП;
		Строка.Признано = Строка.СписаноНаННП + Строка.СписаноНеННП + Строка.Перенесено - Строка.ПризнаноРанее;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьТаблицуВидовАктивовИОбязательств(ТаблицаВидовАктивовИОбязательств)
	
	НоваяСтрока = ТаблицаВидовАктивовИОбязательств.Добавить();
	НоваяСтрока.ВидАктивовОбязательств = "Прочие доходы";
	НоваяСтрока.Счета.Добавить(ПланыСчетов.Налоговый.ПрочиеДоходы);
	НоваяСтрока.Субконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы);
	
	НоваяСтрока = ТаблицаВидовАктивовИОбязательств.Добавить();
	НоваяСтрока.ВидАктивовОбязательств = "Прочие расходы";
	НоваяСтрока.Счета.Добавить(ПланыСчетов.Налоговый.ПрочиеРасходы);
	НоваяСтрока.Субконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы);
	
КонецПроцедуры
	
Процедура  ВывестиСтроку(Строка, ДокументРезультат)
	
		
		ОбластьСтрока = Строка.ОбластьСтрока;
		ОбластьСтрока.Параметры.Показатель      = Строка.Показатель;
		ОбластьСтрока.Параметры.Признано        = Строка.Признано;
		ОбластьСтрока.Параметры.Перенесено      = Строка.Перенесено;
		ОбластьСтрока.Параметры.СписаноНаННП    = Строка.СписаноНаННП;
		ОбластьСтрока.Параметры.СписаноНеННП    = Строка.СписаноНеННП;
		ОбластьСтрока.Параметры.Активы          = Строка.Активы;
		ОбластьСтрока.Параметры.Обязательства   = Строка.Обязательства;
		ОбластьСтрока.Параметры.ПризнаноРанее   = Строка.ПризнаноРанее;
		
		Если ВариантОтчета = 2 Тогда
			ОбластьСтрока.Параметры.ПризнаноАктивы          = Строка.ПризнаноАктивы;
			ОбластьСтрока.Параметры.ПризнаноОбязательства   = Строка.ПризнаноОбязательства;
			ОбластьСтрока.Параметры.Активы99        = Строка.Активы99;
			ОбластьСтрока.Параметры.Обязательства99 = Строка.Обязательства99;
			ОбластьСтрока.Параметры.Остаток = Строка.Остаток;
		КонецЕсли;
		ДокументРезультат.Вывести(ОбластьСтрока);
		
	КонецПроцедуры
	
Функция НайтиИтог(Массив, НазваниеЗначения)
		Сумма = 0;
		Для Каждого ЭлементМассива Из Массив Цикл
			Сумма = Сумма + ЭлементМассива[НазваниеЗначения];
		КонецЦикла;
		
		Возврат Сумма;
	КонецФункции
	
Функция ПолучитьТекстОграничений(ПостроительОтчета, Запрос, Текст) 
	
	ТекстФильтра = "";
	Текст = "";
	Индекс = 0;
	Для Каждого СтрокаОтбора Из ПостроительОтчета.Отбор Цикл
		
		Индекс = Индекс + 1;
		Если Не СтрокаОтбора.Использование 
			ИЛИ ПустаяСтрока(СтрокаОтбора.ПутьКДанным) Тогда
			
			Продолжить;
			
		КонецЕсли;
		Если Не (СтрокаОтбора.ВидСравнения = ВидСравнения.ВСписке Или СтрокаОтбора.ВидСравнения = ВидСравнения.НеВСписке
			Или СтрокаОтбора.ВидСравнения = ВидСравнения.ВИерархии Или СтрокаОтбора.ВидСравнения = ВидСравнения.НеВИерархии
			Или СтрокаОтбора.ВидСравнения = ВидСравнения.НеРавно Или СтрокаОтбора.ВидСравнения = ВидСравнения.Равно) Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаОтбора.ВидСравнения = ВидСравнения.ВСписке Или СтрокаОтбора.ВидСравнения = ВидСравнения.НеВСписке Тогда
			Счета = Новый СписокЗначений;
			Для Номер = 0 По СтрокаОтбора.Значение.Количество() - 1 Цикл
				Строка = ТаблицаВидовАктивовИОбязательств.Найти(СтрокаОтбора.Значение.Получить(Номер), "ВидАктивовОбязательств");
				Если Не Строка = Неопределено Тогда
					Счета.Добавить(Строка.Счета);
				КонецЕсли;
			КонецЦикла;
			
		Иначе
			Строки = ТаблицаВидовАктивовИОбязательств.НайтиСтроки(Новый Структура("ВидАктивовОбязательств", СтрокаОтбора.Значение));
			Счета = Новый Массив;

			Для Каждого Строка Из Строки Цикл
				Если Не Строка = Неопределено Тогда
					Для Каждого СтрокаАктивов Из Строка.Счета Цикл
						Счета.Добавить(СтрокаАктивов)
					КонецЦикла;
					
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Запрос.УстановитьПараметр("Значение" + Индекс, Счета);
		
		Если СтрокаОтбора.ВидСравнения = ВидСравнения.ВСписке 
			Или СтрокаОтбора.ВидСравнения = ВидСравнения.Равно 
			Или СтрокаОтбора.ВидСравнения = ВидСравнения.ВИерархии Тогда
			ТекущийВидСравнения = ВидСравнения.ВИерархии;
		ИначеЕсли СтрокаОтбора.ВидСравнения = ВидСравнения.НеВСписке
			Или СтрокаОтбора.ВидСравнения = ВидСравнения.НеРавно 
			Или СтрокаОтбора.ВидСравнения = ВидСравнения.НеВИерархии Тогда
			ТекущийВидСравнения = ВидСравнения.НеВИерархии;
		КонецЕсли;
			
		ТекстФильтра = ТекстФильтра + " И " + УправлениеОтчетами.ПолучитьСтрокуОтбора(ТекущийВидСравнения, "&Значение" + Индекс, "Счет");
		Текст = Текст + СтрокаОтбора.Представление + " " + СтрокаОтбора.ВидСравнения + " " + СтрокаОтбора.Значение;		
	КонецЦикла;
	
	Возврат Сред(ТекстФильтра, 3);
	
КонецФункции

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	
	СтарыеНастройки = УправлениеОтчетами.ПолучитьКопиюОтбораВТЗ(ПостроительОтчета.Отбор);
	
	СоотвСубконто = Новый Соответствие;
	
	Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	        |	ХозрасчетныйОбороты.СуммаОборот КАК СуммаОборот
	        |{ВЫБРАТЬ
	        |	ХозрасчетныйОбороты.Субконто1 КАК Субконто1}
	        |ИЗ
	        |	РегистрБухгалтерии.Хозрасчетный.Обороты(, , Месяц, Счет В ИЕРАРХИИ (&Счет), , {(Субконто1).*}, , ) КАК ХозрасчетныйОбороты
	        |ИТОГИ
	        |	СУММА(СуммаОборот)
	        |ПО
	        |	ОБЩИЕ
	        |{ИТОГИ ПО
	        |	ХозрасчетныйОбороты.Субконто1.*}";

Массив = Новый Массив;
Массив.Добавить(ПланыСчетов.Хозрасчетный.ОтложенныеНалоговыеАктивы);
Массив.Добавить(ПланыСчетов.Хозрасчетный.ОтложенныеНалоговыеОбязательства);
ПостроительОтчета.Параметры.Вставить("Счет", Массив);
ПостроительОтчета.Параметры.Вставить("ПустаяОрганизация", Справочники.Организации.ПустаяСсылка());
	
ПостроительОтчета.Текст = Текст;

СоотвСубконто = Новый Соответствие;
СоотвСубконто.Вставить("Субконто1", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ВидыАктивовИОбязательств);

Сч = 0;
	Для каждого Элемент Из СоотвСубконто Цикл
		Сч = Сч+1;
		Поле = ПостроительОтчета.ДоступныеПоля.Найти(Элемент.Ключ);
		Поле.ТипЗначения = Элемент.Значение.ТипЗначения;
		Поле.Представление = Элемент.Значение.Наименование;
		ПостроительОтчета.Отбор.Добавить(Элемент.Ключ);
	КонецЦикла;

УправлениеОтчетами.УстановитьОтборИзТаблицы(ПостроительОтчета.Отбор, СтарыеНастройки);

КонецПроцедуры

	////////////////////////////////////////////////////////////////////////////////
	// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
	// 
	
	НП = Новый НастройкаПериода;
	
#КонецЕсли
