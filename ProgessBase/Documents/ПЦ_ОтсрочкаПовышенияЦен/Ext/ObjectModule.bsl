﻿Перем мУдалятьДвижения;

Перем мВалютаРегламентированногоУчета;

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
		Предупреждение(НСтр("ru = 'Документ можно распечатать только после его записи'"));
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение(НСтр("ru = Недостаточно полномочий для печати непроведенного документа!'"));
		Возврат;
	КонецЕсли;
	
	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Получить экземпляр документа на печать
	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда
		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли;
	КонецЕсли; 
	
	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект,, Ссылка));
		
КонецПроцедуры // Печать
	
// Возвращает доступные варианты печати документа
	//
	// Возвращаемое значение:
	//  Структура, каждая строка которой соответствует одному из вариантов печати
	//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
		
	Возврат Новый Структура();
		
КонецФункции // ПолучитьСтруктуруПечатныхФорм()
#КонецЕсли

// Процедура - обработчик события "ОбработкаПроведения"
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	мУдалятьДвижения = НЕ ЭтоНовый();
	
	Если НЕ ЭтоНовый() И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
	
		Результат = ПЦ_Ценообразование.ПолучимПоследниеДанныеПоДокументу_ОтсрочкаПовышенияЦен(Ссылка);	
		
		Если НЕ Результат.Количество() = 0 Тогда
			
			Если НЕ Результат[0].ДокРегистратор = Ссылка Тогда
			
				ОбщегоНазначения.СообщитьОбОшибке("Данный документ нельзя отменить, т.к. на основание введен документ: " + СокрЛП(Результат[0].ДокРегистратор), Отказ);				
			
			КонецЕсли; 
			
		КонецЕсли;
	
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик события "ПриЗаписи"
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = НСтр("ru = 'Проведение документа """ + СокрЛП(Ссылка) + """: '");
	
	//УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы"      ,      "ВалютаУправленческогоУчета",       "ВалютаУправленческогоУчета");
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, УправлениеЗапасами.СформироватьДеревоПолейЗапросаПоШапке(),
	ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект), мВалютаРегламентированногоУчета);
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("Номенклатура"				, "Номенклатура");
	СтруктураПолей.Вставить("ХарактеристикаНоменклатуры", "ХарактеристикаНоменклатуры");
	СтруктураПолей.Вставить("ОтсрочкаПовышенияЦен"		, "Ссылка");
	СтруктураПолей.Вставить("ДатаЦены"					, "ДатаЦены");
	СтруктураПолей.Вставить("ПЦ_Брендообъем"			, "ПЦ_Брендообъем");
	СтруктураПолей.Вставить("ПЦ_ТоварнаяКатегория"		, "ПЦ_ТоварнаяКатегория");
	СтруктураПолей.Вставить("Проект"					, "Проект");
	СтруктураПолей.Вставить("НСИ_Вывеска"				, "Ссылка.НСИ_Вывеска");
	СтруктураПолей.Вставить("НСИ_Регион"				, "Ссылка.НСИ_Регион");
	СтруктураПолей.Вставить("Контрагент"				, "Ссылка.Контрагент");
	СтруктураПолей.Вставить("НСИ_КаналПродаж"			, "Ссылка.НСИ_КаналПродаж");
	СтруктураПолей.Вставить("Дивизион"					, "Ссылка.Дивизион");
	СтруктураПолей.Вставить("ДатаНачала"				, "Ссылка.ДатаНачала");
	СтруктураПолей.Вставить("ДатаОкончания"				, "Ссылка.ДатаОкончания");
	СтруктураПолей.Вставить("Период"					, "Ссылка.Дата");
    //{18.11.2015 Островерхий заявка №45043 
	СтруктураПолей.Вставить("Грузополучатель"			, "Грузополучатель"); 
	//18.11.2015 Островерхий} 
	
	ТаблицаДвижений = ПодготовитьТаблицуДвижений(УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураПолей), СтруктураШапкиДокумента, Отказ);
	
	Если НЕ Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаДвижений);
	КонецЕсли;
	
	//Сделаем переменные доступными из подписок на события
	ДополнительныеСвойства.Вставить("СтруктураШапкиДокумента", СтруктураШапкиДокумента);
	ДополнительныеСвойства.Вставить("СтруктураТабличныхЧастей", Новый Структура("ТаблицаДвижений", ТаблицаДвижений));
	
КонецПроцедуры

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблица значений.
//
Функция ПодготовитьТаблицуДвижений(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента, Отказ)
	
	ТаблицаДвижений = РезультатЗапросаПоТоварам.Выгрузить();
	
	//>>140915 Степанов 42317
	//////Запрос = Новый Запрос;
	//////Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//////			   |	ПЦ_ОтсрочкаПовышенияЦен.ОтсрочкаПовышенияЦен
	//////			   |ИЗ
	//////			   |	РегистрСведений.ПЦ_ОтсрочкаПовышенияЦен КАК ПЦ_ОтсрочкаПовышенияЦен
	//////			   |ГДЕ
	//////			   |	ПЦ_ОтсрочкаПовышенияЦен.ДатаНачала <= &ДатаОкончания
	//////			   |	И ПЦ_ОтсрочкаПовышенияЦен.ДатаОкончания >= &ДатаНачала
	//////			   |	И (ПЦ_ОтсрочкаПовышенияЦен.Дивизион = &Дивизион
	//////			   |			ИЛИ ПЦ_ОтсрочкаПовышенияЦен.Дивизион = &ПустойДивизион)
	//////			   |	И (ПЦ_ОтсрочкаПовышенияЦен.НСИ_КаналПродаж = &НСИ_КаналПродаж
	//////			   |			ИЛИ ПЦ_ОтсрочкаПовышенияЦен.НСИ_КаналПродаж = &ПустойНСИ_КаналПродаж)
	//////			   |	И (ПЦ_ОтсрочкаПовышенияЦен.Контрагент = &Контрагент
	//////			   |			ИЛИ ПЦ_ОтсрочкаПовышенияЦен.Контрагент = &ПустойКонтрагент)
	//////			   |	И (ПЦ_ОтсрочкаПовышенияЦен.НСИ_Регион = &НСИ_Регион
	//////			   |			ИЛИ ПЦ_ОтсрочкаПовышенияЦен.НСИ_Регион = &ПустойНСИ_Регион)
	//////			   |	И (ПЦ_ОтсрочкаПовышенияЦен.НСИ_Вывеска = &НСИ_Вывеска
	//////			   |			ИЛИ ПЦ_ОтсрочкаПовышенияЦен.НСИ_Вывеска = &ПустойНСИ_Вывеска)
	//////			   |	И (ПЦ_ОтсрочкаПовышенияЦен.Проект = &Проект
	//////			   |			ИЛИ ПЦ_ОтсрочкаПовышенияЦен.Проект = &ПустойПроект)
	//////			   |	И (ПЦ_ОтсрочкаПовышенияЦен.ПЦ_ТоварнаяКатегория = &ПЦ_ТоварнаяКатегория
	//////			   |			ИЛИ ПЦ_ОтсрочкаПовышенияЦен.ПЦ_ТоварнаяКатегория = &ПустойПЦ_ТоварнаяКатегория)
	//////			   |	И (ПЦ_ОтсрочкаПовышенияЦен.ПЦ_Брендообъем = &ПЦ_Брендообъем
	//////			   |			ИЛИ ПЦ_ОтсрочкаПовышенияЦен.ПЦ_Брендообъем = &ПустойПЦ_Брендообъем)
	//////			   |	И (ПЦ_ОтсрочкаПовышенияЦен.Номенклатура = &Номенклатура
	//////			   |			ИЛИ ПЦ_ОтсрочкаПовышенияЦен.Номенклатура = &ПустойНоменклатура)
	//////			   |	И (ПЦ_ОтсрочкаПовышенияЦен.ХарактеристикаНоменклатуры = &ХарактеристикаНоменклатуры
	//////			   |			ИЛИ ПЦ_ОтсрочкаПовышенияЦен.ХарактеристикаНоменклатуры = &ПустойХарактеристикаНоменклатуры)
	//////			   //|	И ПЦ_ОтсрочкаПовышенияЦен.ДатаЦены = &ДатаЦены
	//////			   |	И НЕ ПЦ_ОтсрочкаПовышенияЦен.ОтсрочкаПовышенияЦен = &ОтсрочкаПовышенияЦен
	//////			   |
	//////			   |СГРУППИРОВАТЬ ПО
	//////			   |	ПЦ_ОтсрочкаПовышенияЦен.ОтсрочкаПовышенияЦен";
	//////			   
	//////Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	//////Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	//////Запрос.УстановитьПараметр("Дивизион", Дивизион);
	//////Запрос.УстановитьПараметр("НСИ_КаналПродаж", НСИ_КаналПродаж);
	//////Запрос.УстановитьПараметр("Контрагент", Контрагент);
	//////Запрос.УстановитьПараметр("НСИ_Регион", НСИ_Регион);
	//////Запрос.УстановитьПараметр("НСИ_Вывеска", НСИ_Вывеска);
	//////Запрос.УстановитьПараметр("ОтсрочкаПовышенияЦен", Ссылка);
	//////
	//////Запрос.УстановитьПараметр("ПустойДивизион", Справочники.ПРГДивизионы.ПустаяСсылка());
	//////Запрос.УстановитьПараметр("ПустойНСИ_КаналПродаж", Справочники.НСИ_КаналыПродаж.ПустаяСсылка());
	//////Запрос.УстановитьПараметр("ПустойКонтрагент", Справочники.Контрагенты.ПустаяСсылка());
	//////Запрос.УстановитьПараметр("ПустойНСИ_Регион", Справочники.Регионы.ПустаяСсылка());
	//////Запрос.УстановитьПараметр("ПустойНСИ_Вывеска", Справочники.НСИ_Вывески.ПустаяСсылка());
	//////
	//////Запрос.УстановитьПараметр("ПустойПроект", Справочники.ПРГ_ПроектыГП.ПустаяСсылка());
	//////Запрос.УстановитьПараметр("ПустойПЦ_ТоварнаяКатегория", Справочники.НСИ_ТоварныеКатегории.ПустаяСсылка());
	//////Запрос.УстановитьПараметр("ПустойПЦ_Брендообъем", Справочники.НСИ_Брендообъемы.ПустаяСсылка());
	//////Запрос.УстановитьПараметр("ПустойНоменклатура", Справочники.Номенклатура.ПустаяСсылка());
	//////Запрос.УстановитьПараметр("ПустойХарактеристикаНоменклатуры", Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	//////
	//////мТовары = Товары.Выгрузить();
	//////
	//////Для каждого мСтрока Из Товары Цикл
	//////	Для каждого мПараметр Из мТовары.Колонки Цикл
	//////		Запрос.УстановитьПараметр(СокрЛП(мПараметр.Имя), мСтрока[мПараметр.Имя]);
	//////	КонецЦикла; 
	//////	Результат = Запрос.Выполнить().Выбрать();
	//////	Если НЕ Результат.Количество() = 0 Тогда
	//////		ОбщегоНазначения.СообщитьОбОшибке("Аналитика указанная в строке №" + СокрЛП(мСтрока.НомерСтроки) + " пересекается с аналитикой указанной в документе:");
	//////		Отказ = Истина;
	//////	КонецЕсли; 
	//////	Пока Результат.Следующий() Цикл
	//////		ОбщегоНазначения.СообщитьОбОшибке(СокрЛП(Результат.ОтсрочкаПовышенияЦен)); 
	//////	КонецЦикла; 
	//////КонецЦикла;
	//<<140915
	
	Возврат ТаблицаДвижений;
	
КонецФункции

Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаДвижений)
	
	//Движения по регистру накопления "КП_ИмпортированныеЗаказы"
	Движения.ПЦ_ОтсрочкаПовышенияЦен.Записывать = Истина;
	Движения.ПЦ_ОтсрочкаПовышенияЦен.Очистить();
	Движения.ПЦ_ОтсрочкаПовышенияЦен.Загрузить(ТаблицаДвижений);	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ПроверяемыеРеквизиты.Добавить("Товары.ДатаЦены");
	ПроверяемыеРеквизиты.Добавить("ДатаНачала");
	ПроверяемыеРеквизиты.Добавить("ДатаОкончания");
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;	
	
КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
