﻿// Соответствия, содержащая назначения свойств и категорий именам
Перем мСоответствиеНазначений Экспорт;

Перем мСтруктураДляОтбораПоКатегориям Экспорт; // предназначена для связи отборов Построителя с категориями из соединяемых таблиц

Перем мНазваниеОтчета Экспорт; // название отчета

Перем мВалютаУправленческогоУчета Экспорт;

Перем ЕстьХарактеристика;

#Если Клиент Тогда

// Процедура заполняет начальные настройки построителя отчетов.
//
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	СтруктураПредставлениеПолей = Новый Структура;
	МассивОтбора = Новый Массив;
	мСоответствиеНазначений = Новый Соответствие;
	мСтруктураДляОтбораПоКатегориям = Новый Структура;
	
	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ТоварКод = "Артикул";
	Иначе
		ТоварКод = "Код";
	КонецЕсли;

	Текст = " 
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЛимитыОтпускаМатериалов.Подразделение.Представление 	КАК ПодразделениеПредставление,
	|	ЛимитыОтпускаМатериалов.Склад.Представление 			КАК СкладПредставление,
	|	ЛимитыОтпускаМатериалов.Номенклатура." + ТоварКод + "   КАК НоменклатурныйНомер,
	|	ВЫРАЗИТЬ(ЛимитыОтпускаМатериалов.Номенклатура.НаименованиеПолное КАК Строка(1000)) КАК НоменклатураНаименование,
	|	ЛимитыОтпускаМатериалов.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаИзмерения,
	|	ЛимитыОтпускаМатериалов.Номенклатура.ЕдиницаХраненияОстатков.ЕдиницаПоКлассификатору.Код КАК ЕдиницаИзмеренияКод,
	|
	|	ЛимитыОтпускаМатериалов.Номенклатура 					КАК Номенклатура,
	|	NULL 													КАК Серия,
	|	ЛимитноЗаборныеКарты.Регистратор						КАК Регистратор,
	|	СУММА(ЛимитыОтпускаМатериалов.ЛимитОтпуска) 			КАК Лимит,
	|	СУММА(	ВЫБОР КОГДА ЛимитноЗаборныеКарты.ОтпущеноОборот ЕСТЬ NULL ТОГДА
	|				0
	|			ИНАЧЕ
	|				ЛимитноЗаборныеКарты.ОтпущеноОборот
	|			КОНЕЦ
	|		) КАК Отпущено,
	|	СУММА(	ВЫБОР КОГДА ЛимитноЗаборныеКарты.ОтпущеноСверхЛимитаОборот ЕСТЬ NULL ТОГДА
	|				0
	|			ИНАЧЕ
	|				ЛимитноЗаборныеКарты.ОтпущеноСверхЛимитаОборот
	|			КОНЕЦ
	|		) КАК ОтпущеноСверхЛимита,
	|	СУММА(	ВЫБОР КОГДА ЛимитноЗаборныеКарты.ВозвращеноОборот ЕСТЬ NULL ТОГДА
	|				0
	|			ИНАЧЕ
	|				ЛимитноЗаборныеКарты.ВозвращеноОборот
	|			КОНЕЦ
	|		) КАК Возвращено,
	|	СУММА(	(ВЫБОР КОГДА ЛимитноЗаборныеКарты.ОтпущеноОборот ЕСТЬ NULL ТОГДА
	|				0
	|			ИНАЧЕ
	|				ЛимитноЗаборныеКарты.ОтпущеноОборот
	|			КОНЕЦ -
	|			ВЫБОР КОГДА ЛимитноЗаборныеКарты.ВозвращеноОборот ЕСТЬ NULL ТОГДА
	|				0
	|			ИНАЧЕ
	|				ЛимитноЗаборныеКарты.ВозвращеноОборот
	|			КОНЕЦ) *
	|			ВЫБОР КОГДА ПартииТоваровНаСкладах.Стоимость ЕСТЬ NULL ТОГДА
	|				0
	|			ИНАЧЕ
	|				ПартииТоваровНаСкладах.Стоимость
	|			КОНЕЦ /
	|			ВЫБОР КОГДА ПартииТоваровНаСкладах.Количество ЕСТЬ NULL ТОГДА
	|				1
	|			ИНАЧЕ
	|				ПартииТоваровНаСкладах.Количество
	|			КОНЕЦ
	|		) КАК ОтпущеноСтоимость
	|{ВЫБРАТЬ
	|	ЛимитыОтпускаМатериалов.Подразделение.* 				КАК Подразделение,
	|	ЛимитыОтпускаМатериалов.Склад.* 						КАК Склад,
	|	ЛимитыОтпускаМатериалов.Номенклатура.* 					КАК Номенклатура,
	|	ЛимитыОтпускаМатериалов.ХарактеристикаНоменклатуры.* 	КАК Характеристика
	|	//СВОЙСТВА
	|}
	|ИЗ
	|	РегистрСведений.ЛимитыОтпускаМатериалов.СрезПоследних(&ДатаКонца, Периодичность = &Периодичность
	|													{
	|													Подразделение.* 			КАК Подразделение,
	|													Склад.* 					КАК Склад,
	|													Номенклатура.* 				КАК Номенклатура,	
	|													ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	|													КонтролироватьЛимит.* 		КАК КонтролироватьЛимит
	|													}
	|												) КАК ЛимитыОтпускаМатериалов
	|	//СОЕДИНЕНИЯ
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ЛимитноЗаборныеКарты.Обороты(&ДатаНачала, &ДатаКонца, Регистратор,
	|													{
	|													Подразделение.* 			КАК Подразделение,
	|													Склад.* 					КАК Склад,
	|													Номенклатура.* 				КАК Номенклатура,
	|													ХарактеристикаНоменклатуры.* КАК Характеристика
	|													}
	|												) КАК ЛимитноЗаборныеКарты
	|	ПО
	|		ЛимитноЗаборныеКарты.Подразделение 					= ЛимитыОтпускаМатериалов.Подразделение
	|		И ЛимитноЗаборныеКарты.Склад 						= ЛимитыОтпускаМатериалов.Склад
	|		И ЛимитноЗаборныеКарты.Номенклатура 				= ЛимитыОтпускаМатериалов.Номенклатура
	|		И ЛимитноЗаборныеКарты.ХарактеристикаНоменклатуры	= ЛимитыОтпускаМатериалов.ХарактеристикаНоменклатуры
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ (
	|		ВЫБРАТЬ
	|			ПартииТоваровНаСкладах.Номенклатура КАК Номенклатура,
	|			ПартииТоваровНаСкладах.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|			ПартииТоваровНаСкладах.Регистратор КАК Регистратор,
	|			СУММА(ПартииТоваровНаСкладах.СтоимостьРасход) КАК Стоимость,
	|			СУММА(ПартииТоваровНаСкладах.КоличествоРасход) КАК Количество
	| 		ИЗ
	|       	РегистрНакопления.ПартииТоваровНаСкладах.Обороты(&ДатаНачала, &ДатаКонца, Регистратор,
	|													{
	|													Номенклатура.* 				КАК Номенклатура,
	|													ХарактеристикаНоменклатуры.* КАК Характеристика
	|													}
	|												) КАК ПартииТоваровНаСкладах
	|		СГРУППИРОВАТЬ ПО
	|			ПартииТоваровНаСкладах.Номенклатура,
	|			ПартииТоваровНаСкладах.ХарактеристикаНоменклатуры,
	|			ПартииТоваровНаСкладах.Регистратор
	|
	|		) КАК ПартииТоваровНаСкладах
	|	ПО
	|		ЛимитноЗаборныеКарты.Номенклатура 					= ПартииТоваровНаСкладах.Номенклатура
	|		И ЛимитноЗаборныеКарты.ХарактеристикаНоменклатуры	= ПартииТоваровНаСкладах.ХарактеристикаНоменклатуры
	|		И ЛимитноЗаборныеКарты.Регистратор					= ПартииТоваровНаСкладах.Регистратор
	|
	|{ГДЕ
	|	ЛимитыОтпускаМатериалов.Подразделение.* 				КАК Подразделение,
	|	ЛимитыОтпускаМатериалов.Склад.* 						КАК Склад,
	|	ЛимитыОтпускаМатериалов.Номенклатура.* 					КАК Номенклатура,
	|	ЛимитыОтпускаМатериалов.ХарактеристикаНоменклатуры.* 	КАК Характеристика,
	|	ЛимитыОтпускаМатериалов.КонтролироватьЛимит 			КАК КонтролироватьЛимит
	|	//СВОЙСТВА
	|	//КАТЕГОРИИ
	|}
	|СГРУППИРОВАТЬ ПО
	|	ЛимитыОтпускаМатериалов.Подразделение,
	|	ЛимитыОтпускаМатериалов.Склад,
	|	ЛимитыОтпускаМатериалов.Номенклатура,
	|	ЛимитыОтпускаМатериалов.ХарактеристикаНоменклатуры,
	|	ЛимитноЗаборныеКарты.Регистратор
	|	//СГРУППИРОВАТЬ ПО
	|УПОРЯДОЧИТЬ ПО
	|	ЛимитноЗаборныеКарты.Регистратор.Дата
	|{УПОРЯДОЧИТЬ ПО 
	|	ЛимитыОтпускаМатериалов.Подразделение.* 				КАК Подразделение,
	|	ЛимитыОтпускаМатериалов.Склад.* 						КАК Склад,
	|	ЛимитыОтпускаМатериалов.Номенклатура.* 					КАК Номенклатура,
	|	ЛимитыОтпускаМатериалов.ХарактеристикаНоменклатуры.* 	КАК Характеристика
	|	//СВОЙСТВА
	|}
	|{ИТОГИ ПО
	|	ЛимитыОтпускаМатериалов.Подразделение.* 				КАК Подразделение,
	|	ЛимитыОтпускаМатериалов.Склад.* 						КАК Склад,
	|	ЛимитыОтпускаМатериалов.Номенклатура.* 					КАК Номенклатура,
	|	ЛимитыОтпускаМатериалов.ХарактеристикаНоменклатуры.*	КАК Характеристика
	|	//СВОЙСТВА
	|}
	|ИТОГИ СУММА(Лимит), СУММА(Отпущено), СУММА(ОтпущеноСверхЛимита), СУММА(Возвращено), СУММА(ОтпущеноСтоимость)
	|ПО 
	|	ЛимитыОтпускаМатериалов.Подразделение,
	|	ЛимитыОтпускаМатериалов.Номенклатура
	|";
	
	// Соответствие имен полей в запросе и их представлений в отчете.
	СтруктураПредставлениеПолей = Новый Структура;
	СтруктураПредставлениеПолей.Вставить("Подразделение",   			"Подразделение");
	СтруктураПредставлениеПолей.Вставить("Склад",        				"Склад");
	СтруктураПредставлениеПолей.Вставить("Номенклатура", 				"Номенклатура");
	СтруктураПредставлениеПолей.Вставить("Характеристика", 				"Характеристика номенклатуры");
	СтруктураПредставлениеПолей.Вставить("КонтролироватьЛимит",			"Контролировать лимит");
	
	Если ИспользоватьСвойстваИКатегории = Истина Тогда
		
		ТаблицаПолей = Новый ТаблицаЗначений;
		ТаблицаПолей.Колонки.Добавить("ПутьКДанным");  // описание поля запроса поля, для которого добавляются свойства и
		                                               // категории. Используется в условии соединения с регистром сведений,
		                                               // хранящим значения свойств или категорий
		ТаблицаПолей.Колонки.Добавить("Представление");// представление поля, для которого добавляются свойства и категории. 
		ТаблицаПолей.Колонки.Добавить("Назначение");   // назначение свойств/категорий объектов для данного поля
		ТаблицаПолей.Колонки.Добавить("НетКатегорий"); // признак НЕиспользования категорий для объекта
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ЛимитыОтпускаМатериалов.Номенклатура";
		СтрокаТаблицы.Представление = "Номенклатура";
		СтрокаТаблицы.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ЛимитыОтпускаМатериалов.ХарактеристикаНоменклатуры";
		СтрокаТаблицы.Представление = "Характеристика номенклатуры";
		СтрокаТаблицы.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ХарактеристикиНоменклатуры;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ЛимитыОтпускаМатериалов.Склад";
		СтрокаТаблицы.Представление = "Склад";
		СтрокаТаблицы.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Склады;
		
		
		ТекстПоляКатегорий = "";
		ТекстПоляСвойств = "";

		УправлениеОтчетами.ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, Текст, СтруктураПредставлениеПолей, 
				мСоответствиеНазначений, ПостроительОтчета.Параметры
				,, ТекстПоляКатегорий, ТекстПоляСвойств,,,,,,мСтруктураДляОтбораПоКатегориям);

	КонецЕсли;
	
	МассивОтбора = Новый Массив;
	МассивОтбора.Добавить("Подразделение");
	МассивОтбора.Добавить("Склад");
	МассивОтбора.Добавить("Номенклатура");
	МассивОтбора.Добавить("КонтролироватьЛимит");
	
	ПостроительОтчета.Текст = Текст;
	
	Если ИспользоватьСвойстваИКатегории = Истина Тогда
		УправлениеОтчетами.УстановитьТипыЗначенийСвойствИКатегорийДляОтбора(ПостроительОтчета, ТекстПоляКатегорий, ТекстПоляСвойств, мСоответствиеНазначений, СтруктураПредставлениеПолей);
	КонецЕсли;
	
	УправлениеОтчетами.ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	УправлениеОтчетами.ОчиститьДополнительныеПоляПостроителя(ПостроительОтчета);
	УправлениеОтчетами.ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	
	ПостроительОтчета.Отбор["КонтролироватьЛимит"].Использование = Истина;
	ПостроительОтчета.Отбор["КонтролироватьЛимит"].Значение = Истина;
	
	ПостроительОтчета.ИзмеренияКолонки.Очистить();
	
	мНазваниеОтчета = "Лимитно - заборная карта (управленческий учет)";
	
КонецПроцедуры // ЗаполнитьНачальныеНастройки()

// Процедура выводит лимитно заборную карту для одной номенклатуры.
//
Процедура СформироватьЛимитноЗаборнуюКарту(ДокументРезультат, ОбходПоГруппировке)
	
	Макет = ПолучитьОбщийМакет("М8");

	ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакетаШапка.Параметры.Заголовок = "Лимитно - заборная карта № ____";
	
	ОбластьМакетаЗаголовок 	= Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьМакетаПодвал 	= Макет.ПолучитьОбласть("Подвал");
	ОбластьМакета 			= Макет.ПолучитьОбласть("Строка");
	
	// массив с двумя строками - для разбиения на страницы
    ВыводимыеОбласти = Новый Массив();
	ВыводимыеОбласти.Добавить(ОбластьМакета);
	
	ШапкаВыведена = Ложь;
	
	ВысотаЗаголовка = ДокументРезультат.ВысотаТаблицы;
	Если ВысотаЗаголовка <> 0 Тогда
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	
	СведенияОбОрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Организация, ДатаКон);
	
	Обход = ОбходПоГруппировке.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВсегоСтрокДокумента = Обход.Количество();
	ВыведеноСтрок = 0;
	ПоследняяОперация = "";
	НачальнаяСтрока = 0;
	Пока Обход.Следующий() Цикл
		
		Если Не ШапкаВыведена Тогда
			
			ОбластьМакетаШапка.Параметры.Заполнить(Обход);
			ОбластьМакетаШапка.Параметры.ДатаСоставления = ДатаКон;
			ОбластьМакетаШапка.Параметры.ОрганизацияПредставление = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование");
			ОбластьМакетаШапка.Параметры.КодОКПО = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "КодПоОКПО");
			ОбластьМакетаШапка.Параметры.ТекстЦена = "Цена (" + мВалютаУправленческогоУчета + ")";
			ОбластьМакетаШапка.Параметры.ТекстСумма = "Сумма (" + мВалютаУправленческогоУчета + ")";
			
			ОбластьМакетаШапка.Параметры.МатериалНаименование = СокрЛП(Обход.НоменклатураНаименование) + ?(ЕстьХарактеристика, ФормированиеПечатныхФорм.ПредставлениеСерий(Обход), "");
			
			ВсегоОтпущено = ОбходПоГруппировке.Отпущено - ОбходПоГруппировке.Возвращено;
			ОбластьМакетаШапка.Параметры.ВсегоОтпущено = ВсегоОтпущено;
			ОбластьМакетаШапка.Параметры.Сумма = ОбходПоГруппировке.ОтпущеноСтоимость;
			ОбластьМакетаШапка.Параметры.Цена = ?(ВсегоОтпущено <> 0, Окр(ОбходПоГруппировке.ОтпущеноСтоимость / ВсегоОтпущено, 2, 1), 0);
			
			ДокументРезультат.Вывести(ОбластьМакетаШапка);
			ДокументРезультат.Вывести(ОбластьМакетаЗаголовок);
			ШапкаВыведена = Истина;
			
			ОстатокЛимита = Обход.Лимит;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Обход.Регистратор) Тогда
			ОбластьМакета.Параметры.Дата = Обход.Регистратор.Дата;
			Если Обход.Отпущено <> 0 Тогда
				ТекущаяОперация = "Отпущено";
				ОбластьМакета.Параметры.Количество = Обход.Отпущено;
				ОстатокЛимита = ОстатокЛимита - Обход.Отпущено;
			Иначе
				ТекущаяОперация = "Возвращено";
				ОбластьМакета.Параметры.Количество = Обход.Возвращено;
				ОстатокЛимита = ОстатокЛимита + Обход.Возвращено;
			КонецЕсли;
			
			Если СокрЛП(ТекущаяОперация) <> СокрЛП(ПоследняяОперация) Тогда
				ОбластьМакета.Параметры.ОтпущеноВозвращено = ТекущаяОперация;
				ПоследняяОперация = ТекущаяОперация;
				НоваяОперация = Истина;
			Иначе
				ОбластьМакета.Параметры.ОтпущеноВозвращено = "";
			КонецЕсли;
			ОбластьМакета.Параметры.ОстатокЛимита = ОстатокЛимита;
			
			ВыведеноСтрок = ВыведеноСтрок + 1;
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу
			ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ДокументРезультат, ВыводимыеОбласти);
			Если Не ВывестиПодвалЛиста И ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
				ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ДокументРезультат, ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				ДокументРезультат.Вывести(ОбластьМакетаЗаголовок);
				ПоследняяОперация = "";
			КонецЕсли;
			
			ОбластьСтрока = ДокументРезультат.Вывести(ОбластьМакета);
			Если НоваяОперация Тогда
				ДокументРезультат.Область(ОбластьСтрока.Верх,2).ГраницаСверху = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
				НоваяОперация = Ложь;
			КонецЕсли;
			Если ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ДокументРезультат.Область(ОбластьСтрока.Верх,2).ГраницаСнизу = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ДокументРезультат.Вывести(ОбластьМакетаПодвал);
	
КонецПроцедуры // СформироватьЛимитноЗаборнуюКарту()

// Процедура формирует отчет.
//
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок = Ложь) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДатаКон) Тогда
		ДатаКонца = ОбщегоНазначения.ПолучитьРабочуюДату();
	Иначе
		ДатаКонца = КонецДня(ДатаКон);
	КонецЕсли;
	
	Если Периодичность = Перечисления.Периодичность.День Тогда
		ДатаНачала = НачалоДня(ДатаКонца);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя Тогда
		ДатаНачала = НачалоНедели(ДатаКонца);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		ДатаНачала = НачалоМесяца(ДатаКонца);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		ДатаНачала = НачалоКвартала(ДатаКонца);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Год Тогда
		ДатаНачала = НачалоГода(ДатаКонца);
	Иначе
		ДатаНачала = НачалоМесяца(ДатаКонца);
	КонецЕсли;
	
	ПостроительОтчета.Параметры.Вставить("ДатаНачала", ДатаНачала);
	ПостроительОтчета.Параметры.Вставить("ДатаКонца", ДатаКонца);
	ПостроительОтчета.Параметры.Вставить("Периодичность", Периодичность);

	// Проверка на пустые значения
	Если ПустаяСтрока(ПостроительОтчета.Текст) Тогда
		
		Предупреждение("Не определен запрос!");
		
		ЕстьОшибки = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ УправлениеОтчетами.ЗадатьПараметрыОтбораПоКатегориям(ПостроительОтчета, мСтруктураДляОтбораПоКатегориям) Тогда
		Предупреждение("По одной категории нельзя устанавливать несколько отборов");
		ЕстьОшибки = Истина;
		Возврат;
	КонецЕсли;

	Если УправлениеОтчетами.ПроверитьПовторыИзмеренийПостроителя(ПостроительОтчета) = Ложь Тогда
		ЕстьОшибки = Истина;
		возврат;
	КонецЕсли;
	
	// Зададим параметры макета
	ДокументРезультат.ПолеСверху              = 5;
	ДокументРезультат.ПолеСлева               = 5;
	ДокументРезультат.ПолеСнизу               = 5;
	ДокументРезультат.ПолеСправа              = 5;
	ДокументРезультат.РазмерКолонтитулаСверху = 0;
	ДокументРезультат.РазмерКолонтитулаСнизу  = 0;
	ДокументРезультат.ОриентацияСтраницы      = ОриентацияСтраницы.Портрет;
	
	ПостроительОтчета.Выполнить();
	
	КоличествоГруппировок = ПостроительОтчета.ИзмеренияСтроки.Количество();
	
	РезультатЗапроса = ПостроительОтчета.Результат;
	
	ЕстьХарактеристика = (РезультатЗапроса.Колонки.Найти("Характеристика") <> Неопределено);
	
	ДокументРезультат.Очистить();
	
	ОбходПоГруппировке1 = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ОбходПоГруппировке1.Следующий() Цикл
		
		Если КоличествоГруппировок = 1 Тогда
			СформироватьЛимитноЗаборнуюКарту(ДокументРезультат, ОбходПоГруппировке1);
			Продолжить;
		КонецЕсли;
		
		ОбходПоГруппировке2 = ОбходПоГруппировке1.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ОбходПоГруппировке2.Следующий() Цикл
			
			Если КоличествоГруппировок = 2 Тогда
				СформироватьЛимитноЗаборнуюКарту(ДокументРезультат, ОбходПоГруппировке2);
				Продолжить;
			КонецЕсли;
			
			ОбходПоГруппировке3 = ОбходПоГруппировке2.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ОбходПоГруппировке3.Следующий() Цикл
				
				Если КоличествоГруппировок = 3 Тогда
					СформироватьЛимитноЗаборнуюКарту(ДокументРезультат, ОбходПоГруппировке3);
					Продолжить;
				КонецЕсли;
				
				ОбходПоГруппировке4 = ОбходПоГруппировке3.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ОбходПоГруппировке4.Следующий() Цикл
					
					Если КоличествоГруппировок = 4 Тогда
						СформироватьЛимитноЗаборнуюКарту(ДокументРезультат, ОбходПоГруппировке4);
						Продолжить;
					КонецЕсли;
					
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПРоцедуры // СформироватьОтчет()

// Возвращает форму настройки 
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	
//
Функция ПолучитьФормуНастройки() Экспорт
	
	ФормаНастройки = ПолучитьФорму("ФормаНастройка");
	Возврат ФормаНастройки;
	
КонецФункции // ПолучитьФормуНастройки()

// Процедура обработки расшифровки
//
// Параметры:
//	Нет.
//
Процедура ОбработкаРасшифровки(РасшифровкаСтроки, ПолеТД, ВысотаЗаголовка, СтандартнаяОбработка) Экспорт
	
	// Добавление расшифровки из колонки
	Если ТипЗнч(РасшифровкаСтроки) = Тип("Структура") Тогда
		
		// Расшифровка колонки находится в заголовке колонки
		РасшифровкаКолонки = ПолеТД.Область(ВысотаЗаголовка+2, ПолеТД.ТекущаяОбласть.Лево).Расшифровка;

		Расшифровка = Новый Структура;

		Для каждого Элемент Из РасшифровкаСтроки Цикл
			Расшифровка.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;

		Если ТипЗнч(РасшифровкаКолонки) = Тип("Структура") Тогда

			Для каждого Элемент Из РасшифровкаКолонки Цикл
				Расшифровка.Вставить(Элемент.Ключ, Элемент.Значение);
			КонецЦикла;

		КонецЕсли; 

	КонецЕсли;
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру, в которую складываются настройки
//
Функция СформироватьСтруктуруДляСохраненияНастроек(ПоказыватьЗаголовок) Экспорт
	
	СтруктураНастроек = Новый Структура;
	
	СтруктураНастроек.Вставить("НастройкиПостроителя", ПостроительОтчета.ПолучитьНастройки());
	СтруктураНастроек.Вставить("ИспользоватьСвойстваИКатегории", ИспользоватьСвойстваИКатегории);
	СтруктураНастроек.Вставить("Периодичность", Периодичность);
	
	Возврат СтруктураНастроек;
	
КонецФункции // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки из структуры - кроме состояния панели "Отбор"
//
Процедура ВосстановитьНастройкиИзСтруктуры(СохраненныеНастройки, ПоказыватьЗаголовок, Отчет = Неопределено) Экспорт

	Если ТипЗнч(СохраненныеНастройки) = Тип("Структура") Тогда
		
		ПостроительОтчета.УстановитьНастройки(СохраненныеНастройки.НастройкиПостроителя);
		СохраненныеНастройки.Свойство("ИспользоватьСвойстваИКатегории", ИспользоватьСвойстваИКатегории);
		СохраненныеНастройки.Свойство("Периодичность", Периодичность);
		
	КонецЕсли;
	
КонецПроцедуры // ВосстановитьНастройкиИзСтруктуры()
#КонецЕсли

мВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();