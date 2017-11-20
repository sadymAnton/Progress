﻿// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст ошибки)
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя области в которой был выведен объект)
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Накладная", "Накладная на оприходование материалов", ПечатьОприходованияМатериалов(МассивОбъектов, ОбъектыПечати, "Накладная"));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НакладнаяУпр") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "НакладнаяУпр", "Накладная на оприходование материалов (упр.)", ПечатьОприходованияМатериалов(МассивОбъектов, ОбъектыПечати, "НакладнаяУпр"));
	КонецЕсли;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НакладнаяРегл") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "НакладнаяРегл", "Накладная на оприходование материалов (регл.)", ПечатьОприходованияМатериалов(МассивОбъектов, ОбъектыПечати, "НакладнаяРегл"));
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М4") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М4", "М-4 (Приходный ордер)", ПечатьМ4(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М11") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М11", "M-11 (Требование-накладная)", ПечатьМ11(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;

КонецПроцедуры

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьОприходованияМатериалов(МассивОбъектов, ОбъектыПечати, ИмяМакета = "Накладная")
    мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	мВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();

	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ВыводитьКоды    = Истина;
		Колонка         = "Артикул";
		ТекстКодАртикул = "Артикул";
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		ВыводитьКоды    = Истина;
		Колонка         = "Код";
		ТекстКодАртикул = "Код";
	Иначе
		ВыводитьКоды    = Ложь;
		Колонка         = "";
		ТекстКодАртикул = "Код";
	КонецЕсли;

	Если ВыводитьКоды Тогда
		ОбластьШапки  = "ШапкаСКодом";
		ОбластьСтроки = "СтрокаСКодом";
	Иначе
		ОбластьШапки  = "ШапкаТаблицы";
		ОбластьСтроки = "Строка";
	Конецесли;
	
	ТекстЗапроса = 
 	"ВЫБРАТЬ
	|	Док.Номер,
	|	Док.Дата,
	|	Док.Организация,
	|	Док.Подразделение.Представление КАК Подразделение,
	|	Док.Склад.Представление КАК Склад,
	|	Док.Материалы.(
	|		НомерСтроки,
	|		Номенклатура,
	|		Номенклатура."+ ТекстКодАртикул + " КАК КодАртикул,
	|		Номенклатура.НаименованиеПолное КАК Товар,
	|		КоличествоМест,
	|		Количество,
	|		ЕдиницаИзмерения.Представление КАК ЕдиницаИзмерения,
	|		ЕдиницаИзмеренияМест.Представление КАК ЕдиницаИзмеренияМест,
	|		Цена,
	|		Сумма,
	|		ХарактеристикаНоменклатуры КАК Характеристика,
	|		СерияНоменклатуры КАК Серия,
	|		СуммаРегл,
	|		ТипСтоимости
	|	)
	|ИЗ
	|	Документ.ОприходованиеМатериаловИзПроизводства КАК Док
	|ГДЕ
	|	Док.Ссылка = &ТекущийДокумент
	|	
	|УПОРЯДОЧИТЬ ПО
	|	Док.Материалы.НомерСтроки";

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОприходованиеМатериаловИзПроизводства_Накладная";
	Макет       = ПолучитьМакет("Накладная");
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;

		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		
		Запрос.Текст = ТекстЗапроса;

		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		ВыборкаСтрокТовары = Шапка.Материалы.Выбрать();

		// Выводим шапку накладной
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "Оприходование материалов");
		ТабДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ПредставлениеОрганизации = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата), "ПолноеНаименование,");
		ОбластьМакета.Параметры.ПредставлениеПолучателя    = ПредставлениеОрганизации;
		ОбластьМакета.Параметры.Получатель                 = Шапка.Организация;
		ОбластьМакета.Параметры.ПредставлениеСклада        = Шапка.Склад;
		ОбластьМакета.Параметры.ПредставлениеПодразделения = Шапка.Подразделение;
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести табличную часть
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);
		Если ВыводитьКоды Тогда
			ОбластьМакета.Параметры.Колонка = Колонка;
		КонецЕсли;

		ТабДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьСтроки);
		ВсегоСумма = 0;

		СуммыУпр = Ложь;
		Пока ВыборкаСтрокТовары.Следующий() Цикл

			Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
				Продолжить;
			КонецЕсли;

			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьМакета.Параметры.Материал = ВыборкаСтрокТовары.Товар + ФормированиеПечатныхФормСервер.ПредставлениеСерий(ВыборкаСтрокТовары);

			Если ВыводитьКоды Тогда
				ОбластьМакета.Параметры.КодАртикул = ВыборкаСтрокТовары.КодАртикул;
			КонецЕсли;
			
			СуммыУпр    = Истина;
			СуммаОтчета = 0;
			Если ВыборкаСтрокТовары.ТипСтоимости = Перечисления.ВидыНормативнойСтоимостиПроизводства.Фиксированная Тогда
				Если ИмяМакета = "Накладная" И Ссылка.ОтражатьВУправленческомУчете ИЛИ ИмяМакета = "НакладнаяУпр" Тогда
					// Суммы в валюте упр. учета
					СуммаОтчета = ВыборкаСтрокТовары.Сумма;
				ИначеЕсли ИмяМакета = "Накладная" И Ссылка.ОтражатьВБухгалтерскомУчете ИЛИ ИмяМакета = "НакладнаяРегл" Тогда
					// Суммы в валюте регл. учета
					СуммаОтчета = ВыборкаСтрокТовары.СуммаРегл;
					СуммыУпр = Ложь;
					Если Ссылка.ОтражатьВУправленческомУчете Тогда
						ОбластьМакета.Параметры.Цена = ?( ВыборкаСтрокТовары.Количество = 0, СуммаОтчета, Окр(СуммаОтчета / ВыборкаСтрокТовары.Количество, 2, 1));
					Иначе
						ОбластьМакета.Параметры.Цена = ВыборкаСтрокТовары.Цена;
					КонецЕсли;
				КонецЕсли;
				ОбластьМакета.Параметры.Сумма = СуммаОтчета;
			Иначе
				ОбластьМакета.Параметры.Сумма = "";
				ОбластьМакета.Параметры.Цена  = "";
			КонецЕсли;

			ТабДокумент.Вывести(ОбластьМакета);
			ВсегоСумма = ВсегоСумма + СуммаОтчета;
		КонецЦикла;

		// Вывести Итого
		ОбластьМакета                 = Макет.ПолучитьОбласть("Итого");
		ОбластьМакета.Параметры.Всего = ОбщегоНазначения.ФорматСумм(ВсегоСумма);
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести Сумму прописью
		ОбластьМакета                          = Макет.ПолучитьОбласть("СуммаПрописью");
		Если СуммыУпр Тогда
			ОбластьМакета.Параметры.ИтоговаяСтрока = "Всего наименований " + ВыборкаСтрокТовары.Количество()
			                                       + ", на сумму " + ОбщегоНазначения.ФорматСумм(ВсегоСумма, мВалютаУправленческогоУчета);
			ОбластьМакета.Параметры.СуммаПрописью  = ОбщегоНазначения.СформироватьСуммуПрописью(ВсегоСумма, мВалютаУправленческогоУчета);
		Иначе
			ОбластьМакета.Параметры.ИтоговаяСтрока = "Всего наименований " + ВыборкаСтрокТовары.Количество()
			                                       + ", на сумму " + ОбщегоНазначения.ФорматСумм(ВсегоСумма, мВалютаРегламентированногоУчета);
			ОбластьМакета.Параметры.СуммаПрописью  = ОбщегоНазначения.СформироватьСуммуПрописью(ВсегоСумма, мВалютаРегламентированногоУчета);
		КонецЕсли;
		ТабДокумент.Вывести(ОбластьМакета);

		// Вывести подписи
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(ОбластьМакета);
		
		МестВсего = Шапка.Материалы.Выгрузить().Итог("КоличествоМест");
	    Если МестВсего = 0 Тогда
			УниверсальныеМеханизмы.СкрытьКолонкиВТабличномДокументе(ТабДокумент, "Мест",6, ОбластьШапки);
	    КонецЕсли;
        УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла; 

	Возврат ТабДокумент;

КонецФункции // ПечатьОприходованияМатериалов()

// Функция формирует табличный документ унифицированной формы М-4
//
// Параметры: 
//  Нет.
//
// Возвращаемое значение:
//  Табличный документ по форме М-4 (приходный ордер).
//
Функция ПечатьМ4(МассивОбъектов, ОбъектыПечати)
	
	мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	мВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	
    ТекстЗапросаШапка = "
	|ВЫБРАТЬ
	|	Ссылка.Номер КАК Номер,
	|	Ссылка.Дата  КАК ДатаСоставления,
	|	Ссылка.Организация,
	|	Ссылка.Организация         КАК ЮрФизЛицо,
	|	Ссылка.Склад               КАК МестоПриемки,
	|	Ссылка.Склад.Представление КАК СкладНаименование,
	|	Ссылка.Подразделение,
	|	Ссылка.Подразделение  КАК ПредставлениеПодразделения
	|//ПОЛЕ_КорСчет	,ВЫБОР КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СчетЗатрат) = 1 ТОГДА
	|//ПОЛЕ_КорСчет		МИНИМУМ(СчетЗатрат) 
	|//ПОЛЕ_КорСчет	ИНАЧЕ """" КОНЕЦ КАК СубСчет
	|ИЗ
	|	Документ.ОприходованиеМатериаловИзПроизводства КАК ОприходованиеМатериаловИзПроизводства
	|ГДЕ
	|	ОприходованиеМатериаловИзПроизводства.Ссылка = &ТекущийДокумент
	|//ПОЛЕ_КорСчет СГРУППИРОВАТЬ ПО Ссылка";

	ТекстЗапросаТовары = "ВЫБРАТЬ
	|	ВложенныйЗапрос.Номенклатура,
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КАК ТоварНаименование,
	|	ВложенныйЗапрос.Номенклатура.Код КАК ТоварКод,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.ЕдиницаПоКлассификатору.Код КАК ЕдиницаИзмеренияКод,
	|	ВложенныйЗапрос.КоличествоПринято,
	|	ВложенныйЗапрос.Характеристика,
	|	ВложенныйЗапрос.Серия,
	|	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки,
	|	ВложенныйЗапрос.Метка КАК Метка,
	|	ВложенныйЗапрос.Цена,
	|	ВложенныйЗапрос.Сумма,
	|	ВложенныйЗапрос.СуммаРегл,
	|	ВложенныйЗапрос.ТипСтоимости
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОприходованиеМатериаловИзПроизводства.Номенклатура КАК Номенклатура,
	|		ОприходованиеМатериаловИзПроизводства.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		СУММА(ОприходованиеМатериаловИзПроизводства.Количество) КАК КоличествоПринято,
	|		ОприходованиеМатериаловИзПроизводства.ХарактеристикаНоменклатуры КАК Характеристика,
	|		ОприходованиеМатериаловИзПроизводства.СерияНоменклатуры КАК Серия,
	|		МИНИМУМ(ОприходованиеМатериаловИзПроизводства.НомерСтроки) КАК НомерСтроки,
	|		0 КАК Метка,
	|		ОприходованиеМатериаловИзПроизводства.Цена КАК Цена,
	|		ОприходованиеМатериаловИзПроизводства.Сумма КАК Сумма,
	|		ОприходованиеМатериаловИзПроизводства.СуммаРегл КАК СуммаРегл,
	|		ОприходованиеМатериаловИзПроизводства.ТипСтоимости КАК ТипСтоимости
	|	ИЗ
	|		Документ.ОприходованиеМатериаловИзПроизводства.Материалы КАК ОприходованиеМатериаловИзПроизводства
	|	ГДЕ
	|		ОприходованиеМатериаловИзПроизводства.Ссылка = &ТекущийДокумент
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ОприходованиеМатериаловИзПроизводства.Номенклатура,
	|		ОприходованиеМатериаловИзПроизводства.ЕдиницаИзмерения,
	|		ОприходованиеМатериаловИзПроизводства.ХарактеристикаНоменклатуры,
	|		ОприходованиеМатериаловИзПроизводства.СерияНоменклатуры,
	|		ОприходованиеМатериаловИзПроизводства.Цена,
	|		ОприходованиеМатериаловИзПроизводства.Сумма,
	|		ОприходованиеМатериаловИзПроизводства.СуммаРегл,
	|		ОприходованиеМатериаловИзПроизводства.ТипСтоимости) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	Метка,
	|	НомерСтроки";
	
	Макет = ПолучитьОбщийМакет("М4");
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// Зададим параметры печатной формы по умолчанию
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	// Восстановим установленные пользователем параметры печатной формы
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОприходованиеМатериаловИзПроизводства_М4";
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл
		
		Если НЕ ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;

		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент",     Ссылка);

		Запрос.Текст = ТекстЗапросаШапка;	
		Если Ссылка.ОтражатьВБухгалтерскомУчете Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "Документ.ОприходованиеМатериаловИзПроизводства", "Документ.ОприходованиеМатериаловИзПроизводства.Материалы");
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "//ПОЛЕ_КорСчет", "");
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст,"Ссылка.", "");
		КонецЕсли;

		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();

		ЗапросПоТоварам = Новый Запрос();
		ЗапросПоТоварам.УстановитьПараметр("ТекущийДокумент", Ссылка);
		ЗапросПоТоварам.Текст = ТекстЗапросаТовары;
		ВыборкаСтрокТовары = ЗапросПоТоварам.Выполнить().Выбрать();
		
		// Выводим общие реквизиты шапки
		СведенияОПокупателе = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.ЮрФизЛицо, Шапка.ДатаСоставления);

		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОПокупателе);
		ОбластьМакета.Параметры.ОрганизацияПоОКПО        = СведенияОПокупателе.КодПоОКПО;
		ОбластьМакета.Параметры.НомерДокумента           = ОбщегоНазначения.ПолучитьНомерНаПечать(Шапка);
		ТабДокумент.Вывести(ОбластьМакета);

		// Выводим заголовок докмента
		ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокДокумента");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ДатаСоставления = Шапка.ДатаСоставления;
		ПредставлениеКонтрагента = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаСоставления), "ПолноеНаименование,");
		ОбластьМакета.Параметры.ПоставщикНаименование = ПредставлениеКонтрагента;
		ТабДокумент.Вывести(ОбластьМакета);
		
		// Выводим заголовок таблицы
		ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ТабДокумент.Вывести(ЗаголовокТаблицы);

		НомерСтраницы   = 1;

		КоличествоСтрок = ВыборкаСтрокТовары.Количество();

		// Инициализация итогов в документе
		ИтогоКоличествоПринято = 0;
		ИтогоВсегоСНДС         = 0;
		Ном = 0;

		// Создаем массив для проверки вывода
		МассивВыводимыхОбластей = Новый Массив;	

		// Выводим многострочную часть докмента
		ОбластьМакета           = Макет.ПолучитьОбласть("Строка");
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ПодвалСтрок");
		ОбластьПодвала          = Макет.ПолучитьОбласть("Подвал");
		Пока ВыборкаСтрокТовары.Следующий() Цикл

			Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
				Продолжить;
			КонецЕсли;

			Ном = Ном + 1;

			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);

			КоличествоПринято = ВыборкаСтрокТовары.КоличествоПринято;

			Если ВыборкаСтрокТовары.ТипСтоимости = Перечисления.ВидыНормативнойСтоимостиПроизводства.Фиксированная Тогда
				Если Ссылка.ОтражатьВБухгалтерскомУчете Тогда
					ОбластьМакета.Параметры.ВсегоСНДС   = ВыборкаСтрокТовары.СуммаРегл;
					ОбластьМакета.Параметры.СуммаБезНДС = ВыборкаСтрокТовары.СуммаРегл;
					Если Ссылка.ОтражатьВУправленческомУчете Тогда // Цена в упр.валюте
						ОбластьМакета.Параметры.Цена    = ?( КоличествоПринято = 0, ВыборкаСтрокТовары.СуммаРегл, Окр( ВыборкаСтрокТовары.СуммаРегл / КоличествоПринято, 2, 1));
					Иначе
						ОбластьМакета.Параметры.Цена    = ВыборкаСтрокТовары.Цена;
					КонецЕсли;
				Иначе
					ОбластьМакета.Параметры.Цена        = ВыборкаСтрокТовары.Цена;
					ОбластьМакета.Параметры.ВсегоСНДС   = ВыборкаСтрокТовары.Сумма;
					ОбластьМакета.Параметры.СуммаБезНДС = ВыборкаСтрокТовары.Сумма;
				КонецЕсли;
			Иначе
				ОбластьМакета.Параметры.Цена          = "";
				ОбластьМакета.Параметры.ВсегоСНДС     = "";
				ОбластьМакета.Параметры.СуммаБезНДС   = "";
			КонецЕсли;
			ОбластьМакета.Параметры.КоличествоПринято = КоличествоПринято;
			ОбластьМакета.Параметры.ТоварНаименование = СокрЛП(ВыборкаСтрокТовары.ТоварНаименование)
			                                          + ФормированиеПечатныхФормСервер.ПредставлениеСерий(ВыборкаСтрокТовары)
			                                          + ?(ВыборкаСтрокТовары.Метка = 2, " (возвратная тара)", "");
													  
			МассивВыводимыхОбластей.Очистить();
			МассивВыводимыхОбластей.Добавить(ОбластьМакета);
			МассивВыводимыхОбластей.Добавить(ОбластьИтоговПоСтранице);
			Если Ном = КоличествоСтрок Тогда
				МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
			КонецЕсли;

			Если НЕ ФормированиеПечатныхФормСервер.ПроверитьВыводТабличногоДокумента(ТабДокумент, МассивВыводимыхОбластей) Тогда

				НомерСтраницы = НомерСтраницы + 1;
				ПодвалСтрок   = Макет.ПолучитьОбласть("ПодвалСтрок");
				ТабДокумент.Вывести(ПодвалСтрок);
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы;
				ТабДокумент.Вывести(ЗаголовокТаблицы);
			КонецЕсли;												  
													  
			ТабДокумент.Вывести(ОбластьМакета);

			ИтогоКоличествоПринято = ИтогоКоличествоПринято + КоличествоПринято;
			Если ВыборкаСтрокТовары.ТипСтоимости = Перечисления.ВидыНормативнойСтоимостиПроизводства.Фиксированная Тогда
				Если Ссылка.ОтражатьВБухгалтерскомУчете Тогда
					ИтогоВсегоСНДС = ИтогоВсегоСНДС + ВыборкаСтрокТовары.СуммаРегл;
				Иначе
					ИтогоВсегоСНДС = ИтогоВсегоСНДС + ВыборкаСтрокТовары.Сумма;
				КонецЕсли;
			КонецЕсли;

		КонецЦикла;

		// Выводим итоги по документу
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");

		ОбластьМакета.Параметры.ИтогоКоличествоПринято = ИтогоКоличествоПринято;
		ОбластьМакета.Параметры.ИтогоВсегоСНДС         = ИтогоВсегоСНДС;
		ОбластьМакета.Параметры.ИтогоСуммаБезНДС       = ИтогоВсегоСНДС;
		ТабДокумент.Вывести(ОбластьМакета);

		// Выводим итоги по документу
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла; 
	
	Возврат ТабДокумент;
	
КонецФункции // ПечатьМ4()

// Функция формирует печатную форму М-11
//
Функция ПечатьМ11(МассивОбъектов, ОбъектыПечати)

	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ТоварКод = "Артикул";
	Иначе
		ТоварКод = "Код";
	КонецЕсли;
	ТекстЗапросаШапка = 
		"ВЫБРАТЬ
	|	Ссылка.Номер 	КАК НомерДокумента,
	|	Ссылка.Дата	КАК ДатаДокумента,
	|	Ссылка.Дата	КАК ДатаСоставления,
	|	Ссылка.Организация,
	|	Ссылка.Подразделение КАК Склад,
	|	Ссылка.Склад         КАК Подразделение
	|//ПОЛЕ_КорСчет	,ВЫБОР КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СчетЗатрат) = 1 ТОГДА
	|//ПОЛЕ_КорСчет		МИНИМУМ(СчетЗатрат) 
	|//ПОЛЕ_КорСчет	ИНАЧЕ """" КОНЕЦ КАК КоррСчет
	|ИЗ
	|	Документ.ОприходованиеМатериаловИзПроизводства КАК ОприходованиеМатериаловИзПроизводства
	|
	|ГДЕ
	|	ОприходованиеМатериаловИзПроизводства.Ссылка = &ТекущийДокумент
	|//ПОЛЕ_КорСчет СГРУППИРОВАТЬ ПО Ссылка";
	
	ТекстЗапросаТовары = "ВЫБРАТЬ
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КАК МатериалНаименование,
	|	ВложенныйЗапрос.Номенклатура." + ТоварКод + "                 КАК НоменклатурныйНомер,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.ЕдиницаПоКлассификатору.Код КАК ЕдиницаИзмеренияКод,
	|	ВложенныйЗапрос.Характеристика КАК Характеристика,
	|	ВложенныйЗапрос.Серия КАК Серия,
	|	ВложенныйЗапрос.Количество КАК Количество,
	|	ВложенныйЗапрос.Счет КАК Счет,
	|	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки,
	|	ВложенныйЗапрос.Цена,
	|	ВложенныйЗапрос.Сумма,
	|	ВложенныйЗапрос.СуммаРегл,
	|	ВложенныйЗапрос.ТипСтоимости
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОприходованиеМатериаловИзПроизводства.Номенклатура КАК Номенклатура,
	|		ОприходованиеМатериаловИзПроизводства.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ОприходованиеМатериаловИзПроизводства.Счет КАК Счет,
	|		ОприходованиеМатериаловИзПроизводства.ХарактеристикаНоменклатуры КАК Характеристика,
	|		ОприходованиеМатериаловИзПроизводства.СерияНоменклатуры КАК Серия,
	|		СУММА(ОприходованиеМатериаловИзПроизводства.Количество) КАК Количество,
	|		МИНИМУМ(ОприходованиеМатериаловИзПроизводства.НомерСтроки) КАК НомерСтроки,
	|		ОприходованиеМатериаловИзПроизводства.Цена КАК Цена,
	|		ОприходованиеМатериаловИзПроизводства.Сумма КАК Сумма,
	|		ОприходованиеМатериаловИзПроизводства.ТипСтоимости КАК ТипСтоимости,
	|		ОприходованиеМатериаловИзПроизводства.СуммаРегл КАК СуммаРегл
	|	ИЗ
	|		Документ.ОприходованиеМатериаловИзПроизводства.Материалы КАК ОприходованиеМатериаловИзПроизводства
	|	ГДЕ
	|		ОприходованиеМатериаловИзПроизводства.Ссылка = &ТекущийДокумент
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ОприходованиеМатериаловИзПроизводства.Номенклатура,
	|		ОприходованиеМатериаловИзПроизводства.ЕдиницаИзмерения,
	|		ОприходованиеМатериаловИзПроизводства.ХарактеристикаНоменклатуры,
	|		ОприходованиеМатериаловИзПроизводства.СерияНоменклатуры,
	|		ОприходованиеМатериаловИзПроизводства.Счет,
	|		ОприходованиеМатериаловИзПроизводства.Цена,
	|		ОприходованиеМатериаловИзПроизводства.Сумма,
	|		ОприходованиеМатериаловИзПроизводства.ТипСтоимости,
	|		ОприходованиеМатериаловИзПроизводства.СуммаРегл) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОприходованиеМатериаловИзПроизводства_М11";
	
	Макет = ПолучитьОбщийМакет("М11");

	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;

		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		Запрос.Текст = ТекстЗапросаШапка;
		Если Ссылка.ОтражатьВБухгалтерскомУчете Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "Документ.ОприходованиеМатериаловИзПроизводства", "Документ.ОприходованиеМатериаловИзПроизводства.Материалы");
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "//ПОЛЕ_КорСчет", "");
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст,"Ссылка.", "");
		КонецЕсли;

		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);

		Запрос.Текст = ТекстЗапросаТовары;
		ЗапросПоНоменклатуре = Запрос.Выполнить();
		
		Область = Макет.ПолучитьОбласть("Шапка");
		Область.Параметры.Заголовок     = "ТРЕБОВАНИЕ-НАКЛАДНАЯ № " + Строка(Шапка.НомерДокумента);
		Область.Параметры.Заполнить(Шапка);
		
		СведенияОбОрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);

		Область.Параметры.ПредставлениеОрганизации   = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОбОрганизации);
		Область.Параметры.ПредставлениеПодразделения = Шапка.Подразделение;
		Область.Параметры.КодОКПО                    = СведенияОбОрганизации.КодПоОКПО;
		
		ТабДокумент.Вывести(Область);
		
		ВыборкаПоСтрокам = ЗапросПоНоменклатуре.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоСтрокам.Следующий() Цикл

			Область = Макет.ПолучитьОбласть("Строка");
			Область.Параметры.Заполнить(ВыборкаПоСтрокам);
			Область.Параметры.МатериалНаименование = СокрЛП(ВыборкаПоСтрокам.МатериалНаименование) + ФормированиеПечатныхФормСервер.ПредставлениеСерий(ВыборкаПоСтрокам);
			
			Если ВыборкаПоСтрокам.ТипСтоимости = Перечисления.ВидыНормативнойСтоимостиПроизводства.Фиксированная Тогда
				Если Ссылка.ОтражатьВБухгалтерскомУчете Тогда
					Область.Параметры.Сумма = ВыборкаПоСтрокам.СуммаРегл;
					Если Ссылка.ОтражатьВУправленческомУчете Тогда
						Область.Параметры.Цена = ?(ВыборкаПоСтрокам.Количество = 0, ВыборкаПоСтрокам.СуммаРегл, Окр(ВыборкаПоСтрокам.СуммаРегл / ВыборкаПоСтрокам.Количество, 2, 1));
					Иначе
						Область.Параметры.Цена = ВыборкаПоСтрокам.Цена;
					КонецЕсли;
				Иначе
					Область.Параметры.Сумма = ВыборкаПоСтрокам.Сумма;
				КонецЕсли;
			Иначе
				Область.Параметры.Цена  = "";
				Область.Параметры.Сумма = "";
			КонецЕсли;
			
			ТабДокумент.Вывести(Область);

		КонецЦикла;
		
		Область = Макет.ПолучитьОбласть("Подвал");
		ТабДокумент.Вывести(Область);
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка);
	КонецЦикла; 

	Возврат ТабДокумент;
	
КонецФункции // ПечатьМ11()

// В функции описано, какие данные следует сохранять в шаблоне
Функция СтруктураДополнительныхДанныхФормы() Экспорт
	
	Возврат ХранилищаНастроек.ДанныеФорм.СформироватьСтруктуруДополнительныхДанных("Материалы");
	
КонецФункции
