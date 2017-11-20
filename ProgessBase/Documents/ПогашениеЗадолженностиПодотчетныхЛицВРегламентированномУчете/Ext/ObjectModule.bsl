﻿Перем мВалютаРегламентированногоУчета Экспорт;
Перем мВалютаУправленческогоУчета Экспорт;

Перем мУдалятьДвижения;

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

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ 

// По строке выборок из результатов запроса по документу формируем движения по регистру
//
// Параметры: 
//  ВыборкаПоСтрокамДокумента				- спозиционированная на определеной строке выборка 
//				  							  из результата запроса к ТЧ документа, 
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуНачислений(ВыборкаПоСтрокамДокумента, ВыборкаПоШапкеДокумента, НаборЗаписей, УчетнаяПолитикаПоПерсоналуОрганизации)
	
	Движение = НаборЗаписей.Добавить();

	// Свойства
	Движение.ПериодРегистрации			= ВыборкаПоСтрокамДокумента.ДатаРегистрации;
	Движение.БазовыйПериодНачало		= ВыборкаПоШапкеДокумента.ПериодРегистрации;
	Движение.БазовыйПериодКонец			= ВыборкаПоШапкеДокумента.ПериодРегистрации;
	Движение.ВидРасчета					= ПланыВидовРасчета.ДополнительныеНачисленияОрганизаций.КомпенсацияПодотчетныхДС;

	// Измерения
	Движение.Сотрудник					= ВыборкаПоСтрокамДокумента.Сотрудник;
	Движение.ФизЛицо					= ВыборкаПоСтрокамДокумента.ФизЛицо;
	Движение.Организация				= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;

	// Ресурсы
	Движение.Результат					= ВыборкаПоСтрокамДокумента.Результат;

	// Реквизиты
	Движение.ПодразделениеОрганизации	= ВыборкаПоСтрокамДокумента.ПодразделениеОрганизации;
	Движение.ОбособленноеПодразделение	= ВыборкаПоШапкеДокумента.ОбособленноеПодразделение;
	Движение.Показатель1				= ВыборкаПоСтрокамДокумента.Результат;

КонецПроцедуры // ДобавитьСтрокуДопНачислений

// По строке выборок из результатов запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоСтрокамДокумента				- спозиционированная на определеной строке выборка 
//				  							  из результата запроса к ТЧ документа, 
//	НаборЗаписей							- набор записей для УдержанияРаботниковОрганизации 
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуУдержаний(ВыборкаПоСтрокамДокумента, ВыборкаПоШапкеДокумента, НаборЗаписей)

	Движение = НаборЗаписей.Добавить();

	// Свойства
	Движение.ПериодРегистрации			= ВыборкаПоШапкеДокумента.ПериодРегистрации;
	Движение.БазовыйПериодНачало		= ВыборкаПоШапкеДокумента.ПериодРегистрации;
	Движение.БазовыйПериодКонец			= ВыборкаПоШапкеДокумента.ПериодРегистрации;
	Движение.ВидРасчета					= ПланыВидовРасчета.УдержанияОрганизаций.УдержаниеПодотчетныхДС;

	// Измерения
	Движение.ФизЛицо					= ВыборкаПоСтрокамДокумента.ФизЛицо;
	Движение.Организация				= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;

	// Ресурсы
	Движение.Результат					= ВыборкаПоСтрокамДокумента.Результат;

	// Реквизиты
	Движение.Показатель1				= ВыборкаПоСтрокамДокумента.Результат;
	Движение.ОбособленноеПодразделение	= ВыборкаПоШапкеДокумента.ОбособленноеПодразделение;

КонецПроцедуры // ДобавитьСтрокуУдержаний

// По строке выборок из результатов запроса по документу формируем движения по регистру накопления
// "Зарплата к выплате организаций".
//
// Параметры
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка
//								  из результата запроса к ТЧ документа, 
//  ВыборкаПоШапкеДокумента		-  выборка запроса - выборка по реквизитам шапки документа
//  Режим 						- Строка, режим записи в регистр
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВРегистрЗарплатаЗаМесяцОрганизаций(ВыборкаПоСтрокамДокумента, ВыборкаПоШапкеДокумента, Режим)

	Если Режим = "Приход" Тогда
		Движение =  Движения.ЗарплатаЗаМесяцОрганизаций.ДобавитьПриход();
	Иначе
		Движение =  Движения.ЗарплатаЗаМесяцОрганизаций.ДобавитьРасход();
	КонецЕсли; 
			
	// свойства
	Движение.Период					= КонецМесяца(ВыборкаПоШапкеДокумента.ПериодРегистрации);
	
	// измерения
	Движение.Физлицо				= ВыборкаПоСтрокамДокумента.Физлицо;
	Движение.Организация			= ВыборкаПоШапкеДокумента.Организация;
	Движение.ПериодВзаиморасчетов	= ВыборкаПоШапкеДокумента.ПериодРегистрации;
	
	// ресурсы
	Движение.СуммаВзаиморасчетов	= ВыборкаПоСтрокамДокумента.Результат;
	
	
КонецПроцедуры // ДобавитьСтрокуВРегистрЗарплатаЗаМесяцОрганизаций()

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
	Запрос.УстановитьПараметр("ДокументСсылка",         Ссылка);
	Запрос.УстановитьПараметр("парамПустаяОрганизация", Справочники.Организации.ПустаяСсылка());

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДокументПогашениеЗадолженности.Дата,
	|	ДокументПогашениеЗадолженности.ПериодРегистрации,
	|	ДокументПогашениеЗадолженности.Организация,
	|	ВЫБОР
	|		КОГДА ДокументПогашениеЗадолженности.Организация.ГоловнаяОрганизация = &парамПустаяОрганизация
	|		ТОГДА ДокументПогашениеЗадолженности.Организация
	|		ИНАЧЕ ДокументПогашениеЗадолженности.Организация.ГоловнаяОрганизация
	|	КОНЕЦ КАК ГоловнаяОрганизация,
	|	ДокументПогашениеЗадолженности.Организация КАК ОбособленноеПодразделение,
	|	ДокументПогашениеЗадолженности.Ссылка
	|ИЗ
	|	Документ.ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете КАК ДокументПогашениеЗадолженности
	|
	|ГДЕ
	|	ДокументПогашениеЗадолженности.Ссылка = &ДокументСсылка
	|";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "Начисления" документа
//
// Параметры: 
//	нет
//
// Возвращаемое значение:
//  Результат запроса.
//
Функция СформироватьЗапросПоНачисления(ВыборкаПоШапкеДокумента)

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",				Ссылка);
	Запрос.УстановитьПараметр("НачалоПериодаРегистрации",	ПериодРегистрации);
	Запрос.УстановитьПараметр("КонецПериодаРегистрации",	КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("ДатаРегистрации",			?(Дата > КонецМесяца(ПериодРегистрации),КонецМесяца(ПериодРегистрации),?(Дата < ПериодРегистрации,ПериодРегистрации,Дата)));
	Запрос.УстановитьПараметр("ГоловнаяОрганизация",		ВыборкаПоШапкеДокумента.ГоловнаяОрганизация);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтрокиНачисления.НомерСтроки КАК НомерСтроки,
	|	СтрокиНачисления.Результат КАК Результат,
	|	СтрокиНачисления.Сотрудник КАК Сотрудник,
	|	СтрокиНачисления.Сотрудник.ФизЛицо КАК ФизЛицо,
	|	СтрокиНачисления.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	ВЫБОР
	|		КОГДА ДанныеПоРаботникуДоРегистрации.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|			ТОГДА ВЫБОР
	|					КОГДА ДОБАВИТЬКДАТЕ(ДанныеПоРаботникуДоРегистрации.Период, ДЕНЬ, -1) < &НачалоПериодаРегистрации
	|						ТОГДА &ДатаРегистрации
	|					ИНАЧЕ ДОБАВИТЬКДАТЕ(ДанныеПоРаботникуДоРегистрации.Период, ДЕНЬ, -1)
	|				КОНЕЦ
	|		КОГДА ДанныеПоРаботникуПослеРегистрации.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу)
	|			ТОГДА ВЫБОР
	|					КОГДА ДанныеПоРаботникуПослеРегистрации.Период > &КонецПериодаРегистрации
	|						ТОГДА &ДатаРегистрации
	|					ИНАЧЕ ДанныеПоРаботникуПослеРегистрации.Период
	|				КОНЕЦ
	|		ИНАЧЕ &ДатаРегистрации
	|	КОНЕЦ КАК ДатаРегистрации
	|ИЗ
	|	Документ.ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Начисления КАК СтрокиНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|		&ДатаРегистрации,
	|		Организация = &ГоловнаяОрганизация
	|		    И Сотрудник В
	|		        (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		            ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Сотрудник
	|		        ИЗ
	|		            Документ.ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Начисления КАК ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете
	|		        ГДЕ
	|		            ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Ссылка = &ДокументСсылка)) КАК ДанныеПоРаботникуДоРегистрации
	|		ПО ДанныеПоРаботникуДоРегистрации.Сотрудник = СтрокиНачисления.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций.СрезПервых(
	|		&ДатаРегистрации,
	|		Организация = &ГоловнаяОрганизация
	|		    И Сотрудник В
	|		        (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		            ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Сотрудник
	|		        ИЗ
	|		            Документ.ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Начисления КАК ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете
	|		        ГДЕ
	|		            ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Ссылка = &ДокументСсылка)) КАК ДанныеПоРаботникуПослеРегистрации
	|		ПО ДанныеПоРаботникуПослеРегистрации.Сотрудник = СтрокиНачисления.Сотрудник
	|ГДЕ
	|	СтрокиНачисления.Ссылка = &ДокументСсылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоНачисления()

// Формирует запрос по таблице "Удержания" документа
//
// Параметры: 
//	нет
//
// Возвращаемое значение:
//  Результат запроса.
//
Функция СформироватьЗапросПоУдержания()

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтрокиУдержания.НомерСтроки КАК НомерСтроки,
	|	СтрокиУдержания.Физлицо КАК ФизЛицо,
	|	СтрокиУдержания.Результат КАК Результат
	|ИЗ
	|	Документ.ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Удержания КАК СтрокиУдержания
	|ГДЕ
	|	СтрокиУдержания.Ссылка = &ДокументСсылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоУдержания()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение, не заполнен или
// заполнен некорректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок = "")

	// Организация
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указана организация, по которой выполняются начисления!", Отказ, Заголовок);
	КонецЕсли;

	// ПериодРегистрации
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ПериодРегистрации) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан месяц, в котором выполняются начисления!", Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// получает доходы НДФЛ по табличным частям с доходами
// Параметры:
//		ВыборкаПоШапкеДокумента - спозиционированная выборка по шапке документа
//		
Функция СформироватьДоходыПоКодамНДФЛ(ВыборкаПоШапкеДокумента, НаборЗаписей)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",		Ссылка);
	Запрос.УстановитьПараметр("КодДохода",			ПланыВидовРасчета.ДополнительныеНачисленияОрганизаций.КомпенсацияПодотчетныхДС.КодДоходаНДФЛ);
	Запрос.УстановитьПараметр("ПустойКодДохода" ,	Справочники.ДоходыНДФЛ.ПустаяСсылка());

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтрокиНачисления.Физлицо КАК ФизЛицо,
	|	&КодДохода КАК КодДохода,
	|	НАЧАЛОПЕРИОДА(СтрокиНачисления.Ссылка.ПериодРегистрации, МЕСЯЦ) КАК Период,
	|	СУММА(СтрокиНачисления.Результат) КАК СуммаДохода
	|ИЗ
	|	Документ.ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Начисления КАК СтрокиНачисления
	|ГДЕ
	|	СтрокиНачисления.Ссылка = &ДокументСсылка
	|	И СтрокиНачисления.Результат <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	СтрокиНачисления.Физлицо,
	|	НАЧАЛОПЕРИОДА(СтрокиНачисления.Ссылка.ПериодРегистрации, МЕСЯЦ)";

	ДоходыПоКодам = Запрос.Выполнить().Выбрать();

	// сформируем движения НДФЛСведенияОДоходах
	Пока ДоходыПоКодам.Следующий() Цикл

		Движение = НаборЗаписей.Добавить();

		// свойства
		Движение.Период						= ДоходыПоКодам.Период;

		// измерения 
		Движение.Организация				= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
		Движение.Физлицо					= ДоходыПоКодам.Физлицо;
		Движение.КодДохода					= ДоходыПоКодам.КодДохода;
		Движение.ПериодРегистрации			= НачалоМесяца(ПериодРегистрации);

		// ресурсы
		Движение.СуммаДохода				= ДоходыПоКодам.СуммаДохода;

		// реквизиты
		Движение.ОбособленноеПодразделение	= ВыборкаПоШапкеДокумента.ОбособленноеПодразделение;

	КонецЦикла;

КонецФункции  // СформироватьДоходыПоКодамНДФЛ

// Вычисляет разницу между начислениями и удержаниями работника и формирует
// движения по взаиморасчетам с работниками
//
// Параметры:
//		ВыборкаПоШапкеДокумента - спозиционированная выборка по шапке документа
//		НаборЗаписей - набор записей 
//
// Возвращаемое значение:
//  Нет.
//		
Процедура СформироватьВзаиморасчетыСРаботниками(ВыборкаПоШапкеДокумента, НаборЗаписей)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);

	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Доходы.Физлицо,
	|	СУММА(Доходы.СуммаДохода) КАК СуммаДохода
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗплНачисления.Сотрудник.Физлицо   КАК Физлицо,
	|		ЗплНачисления.Результат КАК СуммаДохода
	|	ИЗ
	|		Документ.ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Начисления КАК ЗплНачисления
	|
	|	ГДЕ
	|		ЗплНачисления.Ссылка = &ДокументСсылка И
	|		(ЗплНачисления.Результат <> 0)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ЗплУдержания.Физлицо,
	|		-(ЗплУдержания.Результат)
	|	ИЗ
	|		Документ.ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Удержания КАК ЗплУдержания
	|
	|	ГДЕ
	|		ЗплУдержания.Ссылка = &ДокументСсылка И
	|		(ЗплУдержания.Результат <> 0)) КАК Доходы
	|
	|СГРУППИРОВАТЬ ПО
	|	Доходы.Физлицо";

	Доходы = Запрос.Выполнить().Выбрать();

	// Cформируем движения ВзаиморасчетыСРаботникамиОрганизаций
	Пока Доходы.Следующий() Цикл
		Движение = НаборЗаписей.Добавить();

		// свойства
		Движение.Период               = КонецМесяца(ВыборкаПоШапкеДокумента.ПериодРегистрации);
		Движение.ВидДвижения          = ВидДвиженияНакопления.Приход;

		// измерения 
		Движение.Физлицо              = Доходы.ФизЛицо;
		Движение.Организация          = ВыборкаПоШапкеДокумента.Организация;
		Движение.ПериодВзаиморасчетов = ПериодРегистрации;

		// ресурсы
		Движение.СуммаВзаиморасчетов  = Доходы.СуммаДохода;

	КонецЦикла;

КонецПроцедуры // СформироватьВзаиморасчетыСРаботниками

// Формирует таблицу значений по табличным части дркумента "Начисления"
//
// Параметры: 
//  КурсВалютыУпрУчета      - курс валюты упр. учета,
//  КратностьВалютыУпрУчета - кратность валюты упр. учета.
//
// Возвращаемое значение:
//  Результат запроса.
//
Функция СформироватьТаблицуНачисленийУпр(КурсВалютыУпрУчета, КратностьВалютыУпрУчета)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("Курс",           КурсВалютыУпрУчета);
	Запрос.УстановитьПараметр("Кратность",      КратностьВалютыУпрУчета);

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СтрокиНачисления.РасчетныйДокумент.Организация КАК Организация,
	|	СтрокиНачисления.Сотрудник.Физлицо    КАК Физлицо,
	|	(СтрокиНачисления.СуммаВзаиморасчетов * СтрокиНачисления.КурсВзаиморасчетов * &Кратность) / (&Курс * СтрокиНачисления.КратностьВзаиморасчетов) КАК СуммаУпр,
	|	СтрокиНачисления.РасчетныйДокумент    КАК РасчетныйДокумент,
	|	СтрокиНачисления.ВалютаВзаиморасчетов КАК Валюта,
	|	СтрокиНачисления.СуммаВзаиморасчетов  КАК СуммаВзаиморасчетов
	|
	|ИЗ
	|	Документ.ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Начисления КАК СтрокиНачисления
	|
	|ГДЕ
	|	СтрокиНачисления.Ссылка = &ДокументСсылка
	|";

	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции // СформироватьТаблицуНачисленийУпр()

// Формирует таблицу значений по табличным части документа "Удержания"
//
// Параметры: 
//  КурсВалютыУпрУчета      - курс валюты упр. учета,
//  КратностьВалютыУпрУчета - кратность валюты упр. учета.
//
// Возвращаемое значение:
//  Результат запроса.
//
Функция СформироватьТаблицуУдержанийУпр(КурсВалютыУпрУчета, КратностьВалютыУпрУчета)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("Курс",           КурсВалютыУпрУчета);
	Запрос.УстановитьПараметр("Кратность",      КратностьВалютыУпрУчета);

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СтрокиУдержания.РасчетныйДокумент.Организация КАК Организация,
	|	СтрокиУдержания.Физлицо              КАК ФизЛицо,
	|	(СтрокиУдержания.СуммаВзаиморасчетов * СтрокиУдержания.КурсВзаиморасчетов * &Кратность) / (&Курс * СтрокиУдержания.КратностьВзаиморасчетов) КАК СуммаУпр,
	|	СтрокиУдержания.РасчетныйДокумент    КАК РасчетныйДокумент,
	|	СтрокиУдержания.ВалютаВзаиморасчетов КАК Валюта,
	|	СтрокиУдержания.СуммаВзаиморасчетов  КАК СуммаВзаиморасчетов
	|
	|ИЗ
	|	Документ.ПогашениеЗадолженностиПодотчетныхЛицВРегламентированномУчете.Удержания КАК СтрокиУдержания
	|
	|ГДЕ
	|	СтрокиУдержания.Ссылка = &ДокументСсылка
	|";

	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции // СформироватьТаблицуУдержанийУпр()

// Добавляет движения в регистр "ВзаиморасчетыСПодотчетнымиЛицами"
// движения по взаиморасчетам с работниками
//
// Параметры: 
//	НаборЗаписей      - набор записей,
//	ТаблицаНачисления - таблица значений,
//	ТаблицаУдержания  - таблица значений
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьВзаиморасчетыСПодотчетнымиЛицами(НаборЗаписей)

	СтруктураКурса          = МодульВалютногоУчета.ПолучитьКурсВалюты(мВалютаУправленческогоУчета, Дата);
	КурсВалютыУпрУчета      = СтруктураКурса.Курс;
	КратностьВалютыУпрУчета = СтруктураКурса.Кратность;

	// Взаиморасчеты с подотчетными лицами
	ТаблицаНачисления = СформироватьТаблицуНачисленийУпр(КурсВалютыУпрУчета, КратностьВалютыУпрУчета);
	ТаблицаУдержания  = СформироватьТаблицуУдержанийУпр( КурсВалютыУпрУчета, КратностьВалютыУпрУчета);

	ТаблицаДвижений = НаборЗаписей.Выгрузить();

	ТаблицаДвижений.Очистить();

	ТаблицаДвиженийНачисления = ТаблицаДвижений.Скопировать();
	ТаблицаДвиженийУдержания  = ТаблицаДвижений.Скопировать();

	// Начисления
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаНачисления, ТаблицаДвиженийНачисления);

	НаборЗаписей.мПериод          = Дата;
	НаборЗаписей.мТаблицаДвижений = ТаблицаДвиженийНачисления;

	Движения.ВзаиморасчетыСПодотчетнымиЛицами.ВыполнитьПриход();

	// Удержания
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаУдержания, ТаблицаДвиженийУдержания);

	НаборЗаписей.мПериод          = Дата;
	НаборЗаписей.мТаблицаДвижений = ТаблицаДвиженийУдержания;

	Движения.ВзаиморасчетыСПодотчетнымиЛицами.ВыполнитьРасход();

КонецПроцедуры // ДобавитьВзаиморасчетыСПодотчетнымиЛицами()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения"
//
Процедура ОбработкаПроведения(Отказ, Режим)

	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	УчетнаяПолитикаПоПерсоналуОрганизации = глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации");
	
	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапке().Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Проверим заполнение табличной части "Начисления" и "Удержания"
		СтруктураОбязательныхПолей = Новый Структура("Сотрудник, ПодразделениеОрганизации, РасчетныйДокумент, ВалютаВзаиморасчетов, СуммаВзаиморасчетов");
		ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Начисления", СтруктураОбязательныхПолей, Отказ, Заголовок);
		СтруктураОбязательныхПолей = Новый Структура("Физлицо, ПодразделениеОрганизации, РасчетныйДокумент, ВалютаВзаиморасчетов, СуммаВзаиморасчетов");
		ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Удержания",  СтруктураОбязательныхПолей, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда

			// Начисления
			//
			// получим реквизиты табличной части
			ВыборкаПоНачислениям = СформироватьЗапросПоНачисления(ВыборкаПоШапкеДокумента).Выбрать();
			
			// Заполним записи в наборах записей регистров
			Пока ВыборкаПоНачислениям.Следующий() Цикл 
				ДобавитьСтрокуНачислений(ВыборкаПоНачислениям, ВыборкаПоШапкеДокумента, Движения.ДополнительныеНачисленияРаботниковОрганизаций, УчетнаяПолитикаПоПерсоналуОрганизации);
				ДобавитьСтрокуВРегистрЗарплатаЗаМесяцОрганизаций(ВыборкаПоНачислениям,ВыборкаПоШапкеДокумента,"Приход");
			КонецЦикла;

			// Удержания
			//
			// получим реквизиты табличной части
			ВыборкаПоУдержаниям = СформироватьЗапросПоУдержания().Выбрать();

			// Заполним записи в наборах записей регистров
			Пока ВыборкаПоУдержаниям.Следующий() Цикл 
				ДобавитьСтрокуУдержаний(ВыборкаПоУдержаниям, ВыборкаПоШапкеДокумента, Движения.УдержанияРаботниковОрганизаций);
				ДобавитьСтрокуВРегистрЗарплатаЗаМесяцОрганизаций(ВыборкаПоУдержаниям,ВыборкаПоШапкеДокумента,"Расход");
			КонецЦикла;

			// Доходы НДФЛ
			//
			// Если у ВР установлен код дохода по НДФЛ, тогда сформируем доходы НДФЛ по начислениям документа
			Если НЕ ПланыВидовРасчета.ДополнительныеНачисленияОрганизаций.КомпенсацияПодотчетныхДС.КодДоходаНДФЛ.Пустая() Тогда
				СформироватьДоходыПоКодамНДФЛ(ВыборкаПоШапкеДокумента, Движения.НДФЛСведенияОДоходах);
			КонецЕсли;

			// Взаиморасчеты с работниками
			//
			// сформируем начисления к выплате по начислениям документа
			СформироватьВзаиморасчетыСРаботниками(ВыборкаПоШапкеДокумента, Движения.ВзаиморасчетыСРаботникамиОрганизаций);

			// Сформируем движения по взаиморасчетам с подотчетными лицами
			ДобавитьВзаиморасчетыСПодотчетнымиЛицами(Движения.ВзаиморасчетыСПодотчетнымиЛицами);

		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события "ОбработкаУдаленияПроведения"
//
Процедура ОбработкаУдаленияПроведения(Отказ)

	ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);

КонецПроцедуры // ОбработкаУдаленияПроведения

// Процедура - обработчик события "ПередЗаписью"
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры


мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
мВалютаУправленческогоУчета     = глЗначениеПеременной("ВалютаУправленческогоУчета");

