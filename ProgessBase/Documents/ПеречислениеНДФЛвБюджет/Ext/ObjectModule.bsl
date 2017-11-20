﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура Автозаполнение(ФизическиеЛица = Неопределено) Экспорт

	Если Сумма = 0 Тогда
		Возврат 
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛОстатки.ФизЛицо,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛОстатки.ИсчисленоПоДивидендам,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛОстатки.ВключатьВДекларациюПоНалогуНаПрибыль,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛОстатки.СуммаОстаток КАК Сумма
	|ПОМЕСТИТЬ ВТОстатки
	|ИЗ
	|	РегистрНакопления.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Остатки(
	|			&ДатаОперации,
	|			Организация = &Организация
	|				И Ставка = &Ставка
	|				И (ФизЛицо В (&ФизическиеЛица)
	|					ИЛИ &НеОтбирать)
	|				И МесяцНалоговогоПериода = &МесяцНалоговогоПериода
	|				И ОКАТО_КПП = &ОКАТО_КПП) КАК РасчетыНалоговыхАгентовСБюджетомПоНДФЛОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ФизЛицо,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ИсчисленоПоДивидендам,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ВключатьВДекларациюПоНалогуНаПрибыль,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Сумма
	|ИЗ
	|	РегистрНакопления.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ КАК РасчетыНалоговыхАгентовСБюджетомПоНДФЛ
	|ГДЕ
	|	&УчитыватьДвиженияРегистратора
	|	И РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Регистратор = &Регистратор
	|	И (РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ФизЛицо В (&ФизическиеЛица)
	|			ИЛИ &НеОтбирать)
	|	И РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Организация = &Организация
	|	И РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Ставка = &Ставка
	|	И РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.МесяцНалоговогоПериода = &МесяцНалоговогоПериода
	|	И РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ОКАТО_КПП = &ОКАТО_КПП
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Остатки.ФизЛицо,
	|	СУММА(Остатки.Сумма) КАК Сумма,
	|	Остатки.ФизЛицо.Наименование КАК ФизЛицоНаименование,
	|	Остатки.ИсчисленоПоДивидендам,
	|	Остатки.ВключатьВДекларациюПоНалогуНаПрибыль
	|ИЗ
	|	ВТОстатки КАК Остатки
	|
	|СГРУППИРОВАТЬ ПО
	|	Остатки.ФизЛицо,
	|	Остатки.ФизЛицо.Наименование,
	|	Остатки.ИсчисленоПоДивидендам,
	|	Остатки.ВключатьВДекларациюПоНалогуНаПрибыль
	|
	|ИМЕЮЩИЕ
	|	СУММА(Остатки.Сумма) > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизЛицоНаименование";
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаОперации", КонецДня(ДатаПлатежа));
	Запрос.УстановитьПараметр("МесяцНалоговогоПериода", МесяцНалоговогоПериода);
	Запрос.УстановитьПараметр("Ставка", Ставка);
	Запрос.УстановитьПараметр("ОКАТО_КПП", ОКАТО_КПП);
	Запрос.УстановитьПараметр("ОКТМО_КПП", ОКТМО_КПП);
	Запрос.УстановитьПараметр("НеОтбирать", Не ЗначениеЗаполнено(ФизическиеЛица));
	Запрос.УстановитьПараметр("ФизическиеЛица", ФизическиеЛица);
	Запрос.УстановитьПараметр("УчитыватьДвиженияРегистратора", Проведен И Модифицированность() И ДатаПлатежа > ОбщегоНазначенияЗК.ПолучитьЗначениеРеквизита(Ссылка,"ДатаПлатежа"));
	Если ?(ЗначениеЗаполнено(ДатаПлатежа),ДатаПлатежа, Дата) >= ПроведениеРасчетов.ДатаПереходаНаКодыОКТМО() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ОКАТО_КПП = &ОКАТО_КПП", "ОКТМО_КПП = &ОКТМО_КПП")
	КонецЕсли;
	
	Результат = Запрос.Выполнить().Выгрузить();
	КоэффициентыРаспределения = ПроведениеРасчетов.ВыделитьКоэффициентыРаспределенияИзКоллекцииСтрок(Результат,"Сумма");
	РезультатРаспределения = ОбщегоНазначенияЗК.РаспределитьПропорционально(Сумма, КоэффициентыРаспределения, 0);
	Если РезультатРаспределения = Неопределено Тогда
		Для каждого СтрокаТЧ Из СотрудникиОрганизации Цикл
			СтрокаТЧ.Сумма = 0
		КонецЦикла;
		Возврат 
	Иначе
		Если ЗначениеЗаполнено(ФизическиеЛица) Тогда
			Для каждого СтрокаТЧ Из СотрудникиОрганизации Цикл
				СтрокаТЧ.Сумма = 0
			КонецЦикла;
			Индекс = 0;
			Для каждого СтрокаТЗ Из Результат Цикл
				НоваяСтрока = СотрудникиОрганизации.Найти(СтрокаТЗ.ФизЛицо,"ФизЛицо");
				Если НоваяСтрока <> Неопределено Тогда
					НоваяСтрока.Сумма = РезультатРаспределения[Индекс];
				КонецЕсли;
				Индекс = Индекс + 1;
			КонецЦикла;
		Иначе
			Индекс = 0;
			Для каждого СтрокаТЗ Из Результат Цикл
				НоваяСтрока = СотрудникиОрганизации.Добавить();
				НоваяСтрока.ФизЛицо = СтрокаТЗ.ФизЛицо;
				НоваяСтрока.Сумма = РезультатРаспределения[Индекс];
				Индекс = Индекс + 1;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение Тогда

// Формирует запрос по документу
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросДляПечати(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",	Ссылка);
	Запрос.УстановитьПараметр("ДатаДокумента",	Дата);

	Если Режим = "ПоРеквизитамДокумента" Тогда

		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("СтруктурнаяЕдиница",Организация);
		
		Запрос.Текст = ФормированиеПечатныхФормЗК.ПолучитьТекстЗапросаПоОтветственнымЛицам(
			"ДатаДокумента",
			"ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер)
			|И СтруктурнаяЕдиница = &СтруктурнаяЕдиница");
		Запрос.Выполнить();
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПеречислениеНДФЛвБюджет.Организация.НаименованиеПолное КАК НазваниеОрганизации,
		|	ОтветственныеЛицаОрганизаций.НаименованиеОтветственногоЛица КАК ФИОГлБуха,
		|	ПеречислениеНДФЛвБюджет.ОКАТО_КПП,
		|	ПеречислениеНДФЛвБюджет.Организация.ИНН КАК ИНН,
		|	ПеречислениеНДФЛвБюджет.Сумма,
		|	ПеречислениеНДФЛвБюджет.Ставка,
		|	ПеречислениеНДФЛвБюджет.МесяцНалоговогоПериода,
		|	ПеречислениеНДФЛвБюджет.ПлатежноеПоручениеНомер,
		|	ПеречислениеНДФЛвБюджет.ПлатежноеПоручениеДата,
		|	ПеречислениеНДФЛвБюджет.ОКТМО_КПП,
		|	ПеречислениеНДФЛвБюджет.ДатаПлатежа
		|ИЗ
		|	Документ.ПеречислениеНДФЛвБюджет КАК ПеречислениеНДФЛвБюджет
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеОбОтветственномЛице КАК ОтветственныеЛицаОрганизаций
		|		ПО ПеречислениеНДФЛвБюджет.Организация = ОтветственныеЛицаОрганизаций.СтруктурнаяЕдиница
		|ГДЕ
		|	ПеречислениеНДФЛвБюджет.Ссылка = &ДокументСсылка";

	ИначеЕсли Режим = "ПоТабличнойЧастиДокумента" Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПеречислениеНДФЛвБюджетСотрудникиОрганизации.Ссылка,
		|	ПеречислениеНДФЛвБюджетСотрудникиОрганизации.НомерСтроки,
		|	ПеречислениеНДФЛвБюджетСотрудникиОрганизации.ФизЛицо,
		|	ПеречислениеНДФЛвБюджетСотрудникиОрганизации.Сумма
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	Документ.ПеречислениеНДФЛвБюджет.СотрудникиОрганизации КАК ПеречислениеНДФЛвБюджетСотрудникиОрганизации
		|ГДЕ
		|	ПеречислениеНДФЛвБюджетСотрудникиОрганизации.Ссылка = &ДокументСсылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕСТЬNULL(ФИОФизЛицСрезПоследних.Фамилия + "" "" + ФИОФизЛицСрезПоследних.Имя + "" "" + ФИОФизЛицСрезПоследних.Отчество, Сотрудники.ФизЛицо.Наименование) КАК Работник,
		|	Сотрудники.НомерСтроки КАК НомерСтроки,
		|	Сотрудники.Сумма,
		|	Сотрудники.ФизЛицо
		|ИЗ
		|	ВТСотрудники КАК Сотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(
		|				&ДатаДокумента,
		|				ФизЛицо В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						Сотрудники.ФизЛицо
		|					ИЗ
		|						ВТСотрудники КАК Сотрудники)) КАК ФИОФизЛицСрезПоследних
		|		ПО Сотрудники.ФизЛицо = ФИОФизЛицСрезПоследних.ФизЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";

	Иначе
		Возврат Неопределено;
		
	КонецЕсли;

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросДляПечати()

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Функция Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
	
	// Получить экземпляр документа на печать
	Если ИмяМакета = "Реестр" Тогда
		
		ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
		ОбработкаКомментариев.УдалитьСообщения();
		
		// Заголовок для сообщений об ошибках проведения.
		Заголовок = "Печать документа: " + СокрЛП(ЭтотОбъект);
		
		Отказ = Ложь;
		
		ПроверитьЗаполнениеШапки(Отказ, Заголовок);
		
		ТабДокумент = Новый ТабличныйДокумент;
		ТабДокумент.ПолеСлева = 0;
		ТабДокумент.ПолеСправа = 0;
		ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПеречислениеНДФЛвБюджет_Реестр";
		
		// получаем данные для печати
		ВыборкаДляШапки = СформироватьЗапросДляПечати("ПоРеквизитамДокумента").Выбрать();
		ВыборкаРаботники = СформироватьЗапросДляПечати("ПоТабличнойЧастиДокумента").Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		// подсчитываем количество страниц документа - для корректного разбиения на страницы
		ВсегоСтрокДокумента = СотрудникиОрганизации.Количество();
		
		// запоминаем области макета
		Макет = ПолучитьМакет(ИмяМакета);
		ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка"); // Шапка документа.
		ПовторятьПриПечатиСтроки = Макет.ПолучитьОбласть("ПовторятьПриПечати"); // повторяющаяся шапка страницы
		ОбластьМакетаПодвал = Макет.ПолучитьОбласть("Подвал");// Подвал документа
		ОбластьМакета = Макет.ПолучитьОбласть("Строка"); // строка работника
		
		// массив с двумя строками - для разбиения на страницы
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакета);
		
		// выводим данные о руководителях организации
		Если ВыборкаДляШапки.Следующий() Тогда
			ОбластьМакетаШапка.Параметры.Заполнить(ВыборкаДляШапки); // Шапка документа.
			ОбластьМакетаШапка.Параметры.НазваниеОрганизации = СокрЛП(ОбластьМакетаШапка.Параметры.НазваниеОрганизации);
			Если ВыборкаДляШапки.ДатаПлатежа < ПроведениеРасчетов.ДатаПереходаНаКодыОКТМО() Тогда
				ОбластьМакетаШапка.Параметры.ОКАТО = СправкиПоНДФЛ.КодОКАТОизСуммыОКАТОиКПП(ВыборкаДляШапки.ОКАТО_КПП);
				ОбластьМакетаШапка.Параметры.ИмяКода = "ОКАТО";
				ОбластьМакетаШапка.Параметры.КПП = СправкиПоНДФЛ.КППизСуммыОКАТОиКПП(ВыборкаДляШапки.ОКАТО_КПП);
			Иначе
				ОбластьМакетаШапка.Параметры.ОКАТО = СправкиПоНДФЛ.КодОКАТОизСуммыОКАТОиКПП(ВыборкаДляШапки.ОКТМО_КПП);
				ОбластьМакетаШапка.Параметры.ИмяКода = "ОКТМО";
				ОбластьМакетаШапка.Параметры.КПП = СправкиПоНДФЛ.КППизСуммыОКАТОиКПП(ВыборкаДляШапки.ОКТМО_КПП);
			КонецЕсли;
			ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаДляШапки); // Для подвала.
		КонецЕсли;
		
		// Начинаем формировать выходной документ
		ТабДокумент.Вывести(ОбластьМакетаШапка); // Шапка документа.
		Если ВсегоСтрокДокумента = 0 Тогда
			
			// если не было ни одного работника - выводим пустой бланк
			ВыводимыеОбласти = Новый Массив();
			ВыводимыеОбласти.Добавить(ОбластьМакета);
			ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
			Для Сч = 1 По ОбластьМакета.Параметры.Количество() Цикл
				ОбластьМакета.Параметры.Установить(Сч - 1,""); 
			КонецЦикла;
			ОбластьМакета.Параметры.Работник = " " + Символы.ПС + " ";
			Пока ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти, Ложь) Цикл
				ТабДокумент.Вывести(ОбластьМакета);
			КонецЦикла;
			
		Иначе
			
			ВыведеноСтрок = 0;
			// выводим строки по работникам
			Пока ВыборкаРаботники.Следующий() Цикл
				
				НачалоСообщения = "В строке № """ + СокрЛП(ВыборкаРаботники.НомерСтроки) +
											""" табл. части ""Сотрудники организации"": ";
										
				Если Не ЗначениеЗаполнено(ВыборкаРаботники.ФизЛицо) Тогда
					ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(НачалоСообщения + "не указано физическое лицо!", Отказ, Заголовок);	
				КонецЕсли;
				
				Если Отказ Тогда
					Продолжить;
				КонецЕсли;
				
				// Данные по работнику.
				ОбластьМакета.Параметры.Заполнить(ВыборкаРаботники);
				
				// разбиение на страницы
				ВыведеноСтрок = ВыведеноСтрок + 1;
				
				// Проверим, уместится ли строка на странице или надо открывать новую страницу
				ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти);
				Если Не ВывестиПодвалЛиста и ВыведеноСтрок = ВсегоСтрокДокумента Тогда
					ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
					ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти);
				КонецЕсли;
				Если ВывестиПодвалЛиста Тогда
					ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ТабДокумент.Вывести(ПовторятьПриПечатиСтроки);
				КонецЕсли;
				
				ТабДокумент.Вывести(ОбластьМакета);
				
			КонецЦикла;
		КонецЕсли;
		
		// выводим предварительно подготовленный Подвал документа.
		ТабДокумент.Вывести(ОбластьМакетаПодвал);
		
		Если Отказ Тогда
			ОбработкаКомментариев.ПоказатьСообщения();
			Возврат Неопределено;
		КонецЕсли;
		
	КонецЕсли;

	Возврат УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначенияЗК.СформироватьЗаголовокДокумента(ЭтотОбъект,"Реестр перечисленных сумм "));

КонецФункции // Печать()

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	СтруктураПечатныхФорм = Новый Структура;
	СтруктураПечатныхФорм.Вставить("Реестр", "Реестр перечисленных сумм");
	
	Возврат СтруктураПечатныхФорм;
	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//	ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//	Отказ					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(Отказ, Заголовок = "")

	Если Не ЗначениеЗаполнено(Организация) Тогда
		СтрокаСообщения = ОбщегоНазначенияЗК.ПреобразоватьСтрокуИнтерфейса("Не указана организация!");
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаСообщения, Отказ, Заголовок);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(МесяцНалоговогоПериода) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указан месяц налогового периода, за который производится уплата!", Отказ, Заголовок);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ставка) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указана ставка налога!", Отказ, Заголовок);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаПлатежа) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указана дата платежа!", Отказ, Заголовок);
	ИначеЕсли ДатаПлатежа < ПроведениеРасчетов.ДатаПереходаНаКодыОКТМО() Тогда
		Если НЕ ЗначениеЗаполнено(СтрЗаменить(ОКАТО_КПП, "/","")) Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указан код по ОКАТО, по которому производится уплата!", Отказ, Заголовок);
		Иначе
			
			Если СтрДлина(СправкиПоНДФЛ.КодОКАТОизСуммыОКАТОиКПП(ОКАТО_КПП)) <> 11 Тогда
				ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Неверно указан код по ОКАТО!", Отказ, Заголовок);
			КонецЕсли;
			Если ОбщегоНазначенияЗКПереопределяемый.ЭтоЮрЛицо(Организация) Тогда
				КПП = СправкиПоНДФЛ.КППизСуммыОКАТОиКПП(ОКАТО_КПП);
				Если НЕ ЗначениеЗаполнено(КПП) Тогда
					ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указан КПП!", Отказ, Заголовок);
				ИначеЕсли СтрДлина(СокрЛП(КПП)) <> 9 Тогда
					ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Неверно указан КПП!", Отказ, Заголовок);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
	Иначе
		Если НЕ ЗначениеЗаполнено(СтрЗаменить(ОКТМО_КПП, "/","")) Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указан код по ОКТМО, по которому производится уплата!", Отказ, Заголовок);
		Иначе
			
			Если СтрДлина(СправкиПоНДФЛ.КодОКАТОизСуммыОКАТОиКПП(ОКТМО_КПП)) < 8 Тогда
				ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Неверно указан код по ОКТМО!", Отказ, Заголовок);
			КонецЕсли;
			Если ОбщегоНазначенияЗКПереопределяемый.ЭтоЮрЛицо(Организация) Тогда
				КПП = СправкиПоНДФЛ.КППизСуммыОКАТОиКПП(ОКТМО_КПП);
				Если НЕ ЗначениеЗаполнено(КПП) Тогда
					ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указан КПП!", Отказ, Заголовок);
				ИначеЕсли СтрДлина(СокрЛП(КПП)) <> 9 Тогда
					ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Неверно указан КПП!", Отказ, Заголовок);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Сумма) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указана сумма платежа!", Отказ, Заголовок);
	ИначеЕсли Сумма <> СотрудникиОрганизации.Итог("Сумма") Тогда	
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Указанная сумма платежа неверно распределена по сотрудникам!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияЗК.ПредставлениеДокументаПриПроведении(Ссылка);
	
	ПроверитьЗаполнениеШапки(Отказ, Заголовок);
	
	Если Отказ Тогда
		ОбработкаКомментариев.ПоказатьСообщения();
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаТЧ Из СотрудникиОрганизации Цикл
		
		НачалоСообщения = "В строке № """ + СокрЛП(СтрокаТЧ.НомерСтроки) +
									""" табл. части ""Сотрудники организации"": ";
										
		Если Не ЗначениеЗаполнено(СтрокаТЧ.ФизЛицо) Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(НачалоСообщения + "не указано физическое лицо!", Отказ, Заголовок);
		КонецЕсли;
		
		Если Не Отказ Тогда
			Движение = Движения.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ДобавитьРасход();
			ЗаполнитьЗначенияСвойств(Движение, ЭтотОбъект, "Организация, МесяцНалоговогоПериода, Ставка, ОКАТО_КПП, ОКТМО_КПП");
			Движение.Период = ДатаПлатежа;
			ЗаполнитьЗначенияСвойств(Движение, СтрокаТЧ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(СотрудникиОрганизации);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ, "ФизЛицо");
	
	КодТерритории = ?(?(ЗначениеЗаполнено(ДатаПлатежа),ДатаПлатежа, Дата) < ПроведениеРасчетов.ДатаПереходаНаКодыОКТМО(), ОКАТО_КПП, ОКТМО_КПП);
	
КонецПроцедуры

