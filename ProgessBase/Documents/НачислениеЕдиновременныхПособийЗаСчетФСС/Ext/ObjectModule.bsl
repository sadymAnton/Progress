﻿////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Заполняет документ по перерассчитываемому документу
// ИсходныйДокумент - тип ДокументОбъект.НачислениеОтпускаРаботникамОрганизаций
//
Процедура ЗаполнитьПоПерерассчитываемомуДокументу(ИсходныйДокумент, Физлица = Неопределено) Экспорт
	
	ПерерассчитываемыйДокумент = ИсходныйДокумент.Ссылка;
 	ЗаполнитьЗначенияСвойств(ЭтотОбъект,ИсходныйДокумент,,
		"Проведен, Номер, Дата, ПометкаУдаления, ПерерассчитываемыйДокумент, ПериодРегистрации, Комментарий, Ответственный"); // кроме указанных
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ПерерассчитываемыйДокумент", ПерерассчитываемыйДокумент);
	Запрос.УстановитьПараметр("Физлица", Физлица);
	Запрос.УстановитьПараметр("ПоВсемСотрудникам", Физлица = Неопределено);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Физлицо,
	|	-НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Результат КАК Результат,
	|	ИСТИНА КАК Сторно,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.ВидПособия,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.ДатаСобытия,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Документ.НачислениеЕдиновременныхПособийЗаСчетФСС.Начисления КАК НачислениеЕдиновременныхПособийЗаСчетФССНачисления
	|ГДЕ
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Ссылка = &ПерерассчитываемыйДокумент
	|	И (НЕ НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Сторно)
	|	И НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Ссылка.Проведен
	|	И (&ПоВсемСотрудникам
	|			ИЛИ НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Физлицо В (&Физлица))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Физлицо,
	|	0,
	|	ЛОЖЬ,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.ВидПособия,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.ДатаСобытия,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.НомерСтроки
	|ИЗ
	|	Документ.НачислениеЕдиновременныхПособийЗаСчетФСС.Начисления КАК НачислениеЕдиновременныхПособийЗаСчетФССНачисления
	|ГДЕ
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Ссылка = &ПерерассчитываемыйДокумент
	|	И (НЕ НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Сторно)
	|	И (&ПоВсемСотрудникам
	|			ИЛИ НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Физлицо В (&Физлица))
	|	И НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Ссылка.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сторно УБЫВ,
	|	НомерСтроки";
	
	Начисления.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры // ЗаполнитьПоПерерассчитываемомуДокументу()

Процедура Рассчитать() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
   	Запрос.УстановитьПараметр("ДатаНачисления", Дата);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ОбщегоНазначенияЗК.ГоловнаяОрганизация(Организация));

	Запрос.Текст =
	"ВЫБРАТЬ
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.НомерСтроки КАК НомерСтроки,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.Физлицо КАК Физлицо,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.ВидПособия КАК ВидПособия,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.ДатаСобытия КАК ДатаСобытия,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(НачислениеЕдиновременныхПособийЗаСчетФСС.Ссылка.Организация.РайонныйКоэффициентРФ, 0) < 1
	|			ТОГДА 1
	|		ИНАЧЕ НачислениеЕдиновременныхПособийЗаСчетФСС.Ссылка.Организация.РайонныйКоэффициентРФ
	|	КОНЕЦ КАК РайонныйКоэффициентРФ,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.Сторно,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.Результат
	|ПОМЕСТИТЬ ВТСписокФизлиц
	|ИЗ
	|	Документ.НачислениеЕдиновременныхПособийЗаСчетФСС.Начисления КАК НачислениеЕдиновременныхПособийЗаСчетФСС
	|ГДЕ
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.Ссылка = &ДокументСсылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследниеДаты.НомерСтроки,
	|	РаботникиОрганизаций.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТСписокСотрудников
	|ИЗ
	|	(ВЫБРАТЬ
	|		&ГоловнаяОрганизация КАК Организация,
	|		НачислениеЕдиновременныхПособийЗаСчетФСС.НомерСтроки КАК НомерСтроки,
	|		НачислениеЕдиновременныхПособийЗаСчетФСС.Физлицо КАК Физлицо,
	|		МАКСИМУМ(РаботникиОрганизаций.Период) КАК Период
	|	ИЗ
	|		ВТСписокФизлиц КАК НачислениеЕдиновременныхПособийЗаСчетФСС
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
	|			ПО (РаботникиОрганизаций.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу))
	|				И (РаботникиОрганизаций.Организация = &ГоловнаяОрганизация)
	|				И (РаботникиОрганизаций.Период <= &ДатаНачисления)
	|				И (РаботникиОрганизаций.Сотрудник.ВидЗанятости <> ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство))
	|				И НачислениеЕдиновременныхПособийЗаСчетФСС.Физлицо = РаботникиОрганизаций.Сотрудник.Физлицо
	|	ГДЕ
	|		НЕ НачислениеЕдиновременныхПособийЗаСчетФСС.Сторно
	|	
	|	СГРУППИРОВАТЬ ПО
	|		НачислениеЕдиновременныхПособийЗаСчетФСС.Физлицо,
	|		НачислениеЕдиновременныхПособийЗаСчетФСС.НомерСтроки) КАК ПоследниеДаты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
	|		ПО ПоследниеДаты.Период = РаботникиОрганизаций.Период
	|			И ПоследниеДаты.Организация = РаботникиОрганизаций.Организация
	|			И (РаботникиОрганизаций.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу))
	|			И (РаботникиОрганизаций.Сотрудник.ВидЗанятости <> ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство))
	|			И ПоследниеДаты.Физлицо = РаботникиОрганизаций.Сотрудник.Физлицо
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.НомерСтроки КАК НомерСтроки,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.Физлицо,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.ВидПособия,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.ДатаСобытия,
	|	ВЫБОР
	|		КОГДА НачислениеЕдиновременныхПособийЗаСчетФСС.Сторно
	|			ТОГДА НачислениеЕдиновременныхПособийЗаСчетФСС.Результат
	|		ИНАЧЕ ГосударственныеПособия.Размер * ВЫБОР
	|				КОГДА РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизации.КодПоОКТМО <> """"
	|						ИЛИ РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизации.КодПоОКАТО <> """"
	|					ТОГДА ВЫБОР
	|							КОГДА РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизации.РайонныйКоэффициентРФ > 1
	|								ТОГДА РаботникиОрганизацииСрезПоследних.ПодразделениеОрганизации.РайонныйКоэффициентРФ
	|							ИНАЧЕ 1
	|						КОНЕЦ
	|				ИНАЧЕ НачислениеЕдиновременныхПособийЗаСчетФСС.РайонныйКоэффициентРФ
	|			КОНЕЦ
	|	КОНЕЦ КАК Результат,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.Сторно
	|ИЗ
	|	ВТСписокФизлиц КАК НачислениеЕдиновременныхПособийЗаСчетФСС
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			Сотрудники.НомерСтроки КАК НомерСтроки,
	|			ВЫБОР
	|				КОГДА РаботникиОрганизацийСрезПоследних.ПериодЗавершения <= &ДатаНачисления
	|						И РаботникиОрганизацийСрезПоследних.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|					ТОГДА РаботникиОрганизацийСрезПоследних.ПодразделениеОрганизацииЗавершения
	|				ИНАЧЕ РаботникиОрганизацийСрезПоследних.ПодразделениеОрганизации
	|			КОНЕЦ КАК ПодразделениеОрганизации
	|		ИЗ
	|			ВТСписокСотрудников КАК Сотрудники
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|						&ДатаНачисления,
	|						Организация = &ГоловнаяОрганизация
	|							И Сотрудник В
	|								(ВЫБРАТЬ
	|									Сотрудники.Сотрудник
	|								ИЗ
	|									ВТСписокСотрудников КАК Сотрудники)) КАК РаботникиОрганизацийСрезПоследних
	|				ПО Сотрудники.Сотрудник = РаботникиОрганизацийСрезПоследних.Сотрудник) КАК РаботникиОрганизацииСрезПоследних
	|		ПО НачислениеЕдиновременныхПособийЗаСчетФСС.НомерСтроки = РаботникиОрганизацииСрезПоследних.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(ГосударственныеПособия.Период) КАК Период,
	|			НачислениеЕдиновременныхПособийЗаСчетФССНачисления.НомерСтроки КАК НомерСтроки,
	|			НачислениеЕдиновременныхПособийЗаСчетФССНачисления.ВидПособия КАК ВидПособия
	|		ИЗ
	|			ВТСписокФизлиц КАК НачислениеЕдиновременныхПособийЗаСчетФССНачисления
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГосударственныеПособия КАК ГосударственныеПособия
	|				ПО НачислениеЕдиновременныхПособийЗаСчетФССНачисления.ВидПособия = ГосударственныеПособия.ВидПособия
	|					И НачислениеЕдиновременныхПособийЗаСчетФССНачисления.ДатаСобытия >= ГосударственныеПособия.Период
	|		
	|		СГРУППИРОВАТЬ ПО
	|			НачислениеЕдиновременныхПособийЗаСчетФССНачисления.НомерСтроки,
	|			НачислениеЕдиновременныхПособийЗаСчетФССНачисления.ВидПособия) КАК ДатыПособий
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГосударственныеПособия КАК ГосударственныеПособия
	|			ПО ДатыПособий.Период = ГосударственныеПособия.Период
	|				И ДатыПособий.ВидПособия = ГосударственныеПособия.ВидПособия
	|		ПО НачислениеЕдиновременныхПособийЗаСчетФСС.НомерСтроки = ДатыПособий.НомерСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Начисления.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке()

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.Дата,
	|	ВЫБОР
	|		КОГДА НачислениеЕдиновременныхПособийЗаСчетФСС.Организация.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА НачислениеЕдиновременныхПособийЗаСчетФСС.Организация
	|		ИНАЧЕ НачислениеЕдиновременныхПособийЗаСчетФСС.Организация.ГоловнаяОрганизация
	|	КОНЕЦ КАК Организация,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.Организация КАК ОбособленноеПодразделение,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.Ссылка,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.ПерерассчитываемыйДокумент.ПериодРегистрации КАК ПериодПерерасчета,
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.ПерерассчитываемыйДокумент.Организация КАК ОрганизацияПерерасчета,
	|	ВЫБОР
	|		КОГДА НачислениеЕдиновременныхПособийЗаСчетФСС.Дата < НачислениеЕдиновременныхПособийЗаСчетФСС.ПериодРегистрации
	|			ТОГДА НачислениеЕдиновременныхПособийЗаСчетФСС.ПериодРегистрации
	|		КОГДА НачислениеЕдиновременныхПособийЗаСчетФСС.Дата > КОНЕЦПЕРИОДА(НачислениеЕдиновременныхПособийЗаСчетФСС.ПериодРегистрации, МЕСЯЦ)
	|			ТОГДА КОНЕЦПЕРИОДА(НачислениеЕдиновременныхПособийЗаСчетФСС.ПериодРегистрации, МЕСЯЦ)
	|		ИНАЧЕ НачислениеЕдиновременныхПособийЗаСчетФСС.Дата
	|	КОНЕЦ КАК ПериодРегистрации,
	|	ВЫБОР
	|		КОГДА НачислениеЕдиновременныхПособийЗаСчетФСС.Дата < НачислениеЕдиновременныхПособийЗаСчетФСС.ПериодРегистрации
	|			ТОГДА НачислениеЕдиновременныхПособийЗаСчетФСС.ПериодРегистрации
	|		КОГДА НачислениеЕдиновременныхПособийЗаСчетФСС.Дата > КОНЕЦПЕРИОДА(НачислениеЕдиновременныхПособийЗаСчетФСС.ПериодРегистрации, МЕСЯЦ)
	|			ТОГДА КОНЕЦПЕРИОДА(НачислениеЕдиновременныхПособийЗаСчетФСС.ПериодРегистрации, МЕСЯЦ)
	|		ИНАЧЕ НачислениеЕдиновременныхПособийЗаСчетФСС.Дата
	|	КОНЕЦ КАК ДатаРегистрации
	|ИЗ
	|	Документ.НачислениеЕдиновременныхПособийЗаСчетФСС КАК НачислениеЕдиновременныхПособийЗаСчетФСС
	|ГДЕ
	|	НачислениеЕдиновременныхПособийЗаСчетФСС.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "Начисления" документа
//
// Параметры: 
//  Режим        - режим проведения.
//
// Возвращаемое значение:
//  Результат запроса.
//
Функция СформироватьЗапросПоНачисления(ВыборкаПоШапкеДокумента)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
   	Запрос.УстановитьПараметр("ДатаНачисления", ВыборкаПоШапкеДокумента.Дата);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация",ВыборкаПоШапкеДокумента.Организация);

    // Описание текста запроса:
    // 1. Выборка "НачислениеЕдиновременныхПособийЗаСчетФССНачисления": 
	//		Выбираются строки документа.  
	// 2. Выборка "РаботникиОрганизаций": 
	//		Из регистра сведений о работниках выбираем информацию о подразделении работника организации
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.НомерСтроки КАК НомерСтроки,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Физлицо КАК ФизЛицо,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Физлицо.Наименование КАК ФизЛицоНаименование,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Результат,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.ВидПособия,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.ДатаСобытия,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.ДатаСобытия КАК ДатаНачалаСобытия,
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Сторно,
	|	ВЫБОР
	|		КОГДА НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Сторно
	|			ТОГДА НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Ссылка.ПерерассчитываемыйДокумент
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК СторнируемыйДокумент,
	|	РаботникиОрганизаций.Сотрудник,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизаций.Сотрудник ЕСТЬ НЕ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации,
	|	ВЫБОР
	|		КОГДА РаботникиОрганизаций.ПериодЗавершения <= &ДатаНачисления
	|				И РаботникиОрганизаций.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА РаботникиОрганизаций.ПодразделениеОрганизацииЗавершения
	|		ИНАЧЕ РаботникиОрганизаций.ПодразделениеОрганизации
	|	КОНЕЦ КАК ПодразделениеОрганизации
	|ИЗ
	|	Документ.НачислениеЕдиновременныхПособийЗаСчетФСС.Начисления КАК НачислениеЕдиновременныхПособийЗаСчетФССНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|				&ДатаНачисления,
	|				Организация = &ГоловнаяОрганизация
	|					И Сотрудник.ВидЗанятости <> ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство)
	|					И Сотрудник.ФизЛицо В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							НачислениеЕдиновременныхПособийЗаСчетФСС.Физлицо
	|						ИЗ
	|							Документ.НачислениеЕдиновременныхПособийЗаСчетФСС.Начисления КАК НачислениеЕдиновременныхПособийЗаСчетФСС
	|						ГДЕ
	|							НачислениеЕдиновременныхПособийЗаСчетФСС.Ссылка = &ДокументСсылка)) КАК РаботникиОрганизаций
	|		ПО НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Физлицо = РаботникиОрганизаций.Сотрудник.Физлицо
	|ГДЕ
	|	НачислениеЕдиновременныхПособийЗаСчетФССНачисления.Ссылка = &ДокументСсылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки,
	|	РаботникиОрганизаций.Период УБЫВ,
	|	РаботникиОрганизаций.Сотрудник.ДатаНачала УБЫВ";

	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоНачисления()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ОбособленноеПодразделение) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ОбщегоНазначенияЗК.ПреобразоватьСтрокуИнтерфейса("Не указана организация!"), Отказ, Заголовок);
	КонецЕсли;
	
	// соответствие периодов документа и перерассчитываемого документа
	Если ВыборкаПоШапкеДокумента.ПериодПерерасчета <> null 
		и ВыборкаПоШапкеДокумента.ПериодРегистрации <= ВыборкаПоШапкеДокумента.ПериодПерерасчета Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Период документа должен быть больше периода исправляемого документа!", Отказ, Заголовок);
	КонецЕсли;
	
	// соответствие организаций документа и перерассчитываемого документа
	Если ВыборкаПоШапкеДокумента.ОрганизацияПерерасчета <> null 
		и ВыборкаПоШапкеДокумента.ОбособленноеПодразделение <> ВыборкаПоШапкеДокумента.ОрганизацияПерерасчета Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ОбщегоНазначенияЗК.ПреобразоватьСтрокуИнтерфейса("Организация, заданная для документа, должна совпадать с организацией исправляемого документа!"), Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//  							  из результата запроса по товарам документа, 
//  Отказ 						- флаг отказа в проведении.
//	Заголовок					- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)
	
	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
	""" табл. части ""Начисления"": ";

	// ФизЛицо
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ФизЛицо) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указан сотрудник!", Отказ, Заголовок);
	КонецЕсли;
	
	// Организация сотрудника должна совпадать с организацией документа
	Если ВыборкаПоСтрокамДокумента.ОшибкаНеСоответствиеСотрудникаИОрганизации Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + ОбщегоНазначенияЗК.ПреобразоватьСтрокуИнтерфейса("указанный сотрудник оформлен на другую организацию!"), Отказ, Заголовок);
	КонецЕсли;
	
	// ВидПособия
	Если Не ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ВидПособия) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указан вид пособия!", Отказ, Заголовок);
	ИначеЕсли ПроведениеРасчетов.ПособияПоОбязательномуСтрахованиюВыплачиваетФСС(ПериодРегистрации, Организация) И ВыборкаПоСтрокамДокумента.ВидПособия <> Перечисления.РазмерыГосударственныхПособий.ВСвязиСоСмертью Тогда	
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "у страхователей, участвующих в пилотном проекте ФСС, пособие " + НРег(ВыборкаПоСтрокамДокумента.ВидПособия) + " не начисляется!", Отказ, Заголовок);
	КонецЕсли;
	
	// ДатаСобытия
	Если Не ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаСобытия) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана дата события!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры

// По строке выборок из результатов запроса по документу формируем движения по регистру
//
// Параметры: 
//  ВыборкаПоСтрокамДокумента				- спозиционированная на определенной строке выборка 
//				  							  из результата запроса к ТЧ документа, 
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуДополнительныхНачислений(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента)
	
	Движение = Движения.ДополнительныеНачисленияРаботниковОрганизаций.Добавить();
	
	СтрокаСвойствИзДокумента = "Организация,ОбособленноеПодразделение";
	СтрокаСвойствИзСтрокиДокумента = "ФизЛицо,Результат,ДатаНачалаСобытия,Сотрудник,ПодразделениеОрганизации,Сторно,СторнируемыйДокумент"; 
	
	ЗаполнитьЗначенияСвойств(Движение,ВыборкаПоШапкеДокумента,СтрокаСвойствИзДокумента);
	ЗаполнитьЗначенияСвойств(Движение,ВыборкаПоСтрокамДокумента,СтрокаСвойствИзСтрокиДокумента);
	
	// Свойства
	
	// вид расчета однозначно соответствует виду пособия
	Если ВыборкаПоСтрокамДокумента.ВидПособия = Перечисления.РазмерыГосударственныхПособий.ВСвязиСоСмертью Тогда
		ВидРасчета = ПланыВидовРасчета.ДополнительныеНачисленияОрганизаций.ВСвязиСоСмертью;
	ИначеЕсли ВыборкаПоСтрокамДокумента.ВидПособия = Перечисления.РазмерыГосударственныхПособий.ПриПостановкеНаУчетВРанниеСрокиБеременности Тогда
		ВидРасчета = ПланыВидовРасчета.ДополнительныеНачисленияОрганизаций.ПриПостановкеНаУчетВРанниеСрокиБеременности
	ИначеЕсли ВыборкаПоСтрокамДокумента.ВидПособия = Перечисления.РазмерыГосударственныхПособий.ПриРожденииРебенка Тогда
		ВидРасчета = ПланыВидовРасчета.ДополнительныеНачисленияОрганизаций.ПриРожденииРебенка
	Иначе
		ВидРасчета = ПланыВидовРасчета.ДополнительныеНачисленияОрганизаций.ПриУсыновленииРебенка
	КонецЕсли;
	
	Движение.ВидРасчета			= ВидРасчета;
	Движение.ПериодРегистрации  = ВыборкаПоШапкеДокумента.ПериодРегистрации;
	
	
КонецПроцедуры // ДобавитьСтрокуДополнительныхНачислений

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                  - выборка из результата запроса по шапке документа
//  СтруктураПроведенияПоРегистрамНакопления - структура, содержащая имена регистров 
//                                             накопления по которым надо проводить документ
//  СтруктураПараметров                      - структура параметров проведения.
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, ВыборкаПоТЧ)
	
	Движение = Движения.ВзаиморасчетыСРаботникамиОрганизаций.Добавить();
	
	// Свойства
	Движение.Период                 = КонецМесяца(ПериодРегистрации);
	Движение.ВидДвижения			= ВидДвиженияНакопления.Приход;
	
	// Измерения
	Движение.Организация			= ВыборкаПоШапкеДокумента.ОбособленноеПодразделение;
	Движение.ФизЛицо                = ВыборкаПоТЧ.ФизЛицо;
	Движение.ПериодВзаиморасчетов	= ПериодРегистрации;
	
	// Ресурсы
	Движение.СуммаВзаиморасчетов	= ВыборкаПоТЧ.Результат; 
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамНакопления

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	//структура, содержащая имена регистров сведений по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамНакопления;

	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияЗК.ПредставлениеДокументаПриПроведении(Ссылка);
	
	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке();

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда

			// получим реквизиты табличной части
			ВыборкаПоНачислениям = СформироватьЗапросПоНачисления(ВыборкаПоШапкеДокумента).Выбрать();

			Пока ВыборкаПоНачислениям.СледующийПоЗначениюПоля("НомерСтроки") Цикл 

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоНачислениям, Отказ, Заголовок);

				Если НЕ Отказ Тогда

					ДобавитьСтрокуДополнительныхНачислений(ВыборкаПоШапкеДокумента, ВыборкаПоНачислениям);
					ДобавитьСтрокуВДвиженияПоРегистрамНакопления(ВыборкаПоШапкеДокумента, ВыборкаПоНачислениям);
					
				КонецЕсли;

			КонецЦикла;
			
		КонецЕсли;

	КонецЕсли;

	ОбработкаКомментариев.ПоказатьСообщения();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(Начисления);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ, "Физлицо");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
