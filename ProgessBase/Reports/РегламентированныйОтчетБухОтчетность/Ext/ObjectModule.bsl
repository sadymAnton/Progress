﻿// Хранит таблицу значений - состав показателей отчета.
Перем мТаблицаСоставПоказателей Экспорт;

// Хранит структуру - состав показателей отчета,
// значение которых автоматически заполняется по учетным данным.
Перем мСтруктураВариантыЗаполнения Экспорт;

// Хранит структуру многостраничных разделов.
Перем мСтруктураМногостраничныхРазделов Экспорт;

// Хранит дерево значений - структуру листов отчета.
Перем мДеревоСтраницОтчета Экспорт;

// Хранит признак выбора печатных листов.
Перем мЕстьВыбранные Экспорт;

// Хранит имя выбранной формы отчета
Перем мВыбраннаяФорма Экспорт;

// Хранит признак скопированной формы.
Перем мСкопированаФорма Экспорт;

// Хранит ссылку на документ, хранящий данные отчета
Перем мСохраненныйДок Экспорт;

// Следующие переменные хранят границы
// периода построения отчета
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;

Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Перем мЗаписьЗапрещена Экспорт;

Перем мИнтервалАвтосохранения Экспорт;

Перем мРезультатПоиска Экспорт;// таблица с результатами поиска
Перем мСчетчикиСтраницПриПоиске Экспорт;// таблица со счетчиками номеров листов при поиске
Перем мТаблицаФормОтчета Экспорт;

Перем мЗаписываетсяНовыйДокумент Экспорт;
Перем мВариант Экспорт;

Перем мГруппаОрганизаций Экспорт;

Перем мФормыИФорматы Экспорт;
Перем мВерсияОтчета Экспорт;

Перем мПечатьБезШтрихкодаРазрешена Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Если ТолстыйКлиентОбычноеПриложение Тогда

Процедура УведомитьИП() Экспорт
	
	ТекстПредупреждения = "Отчет не может быть выгружен.
		|Выгрузить этот отчет могут только организации.
		|Для индивидуальных предпринимателей выгрузка не предусмотрена форматом ФНС.
		|Это связано с тем, что индивидуальные предприниматели не обязаны сдавать бухгалтерскую отчетность (пп. 5 п. 1 ст. 23 НК РФ)";
	
	Предупреждение(ТекстПредупреждения);
	
КонецПроцедуры

#КонецЕсли

Функция РазложитьФИО(Знач ФИОСтр) Экспорт
	
	ФИОСтр = СокрЛП(ФИОСтр);
	ФИО = Новый Структура("Фамилия, Имя, Отчество", "", "", "");
	
	ПервыйПробел = Найти(ФИОСтр, " ");
	Если ПервыйПробел = 0 Тогда
		ФИО.Фамилия = ФИОСтр;
		Возврат ФИО;
	КонецЕсли;
	ФИО.Фамилия = СокрЛП(Лев(ФИОСтр, ПервыйПробел - 1));
	ФИОСтр = СокрЛП(Сред(ФИОСтр, ПервыйПробел + 1));
	
	ВторойПробел = Найти(ФИОСтр, " ");
	Если ВторойПробел = 0 Тогда
		ФИО.Имя = ФИОСтр;
		Возврат ФИО;
	КонецЕсли;
	ФИО.Имя = СокрЛП(Лев(ФИОСтр, ВторойПробел - 1));
	
	ФИО.Отчество = СокрЛП(Сред(ФиоСтр, ВторойПробел + 1));
	
	Возврат ФИО;
	
КонецФункции

Функция ОписаниеПериода(ДатаНачалаПериода, ДатаКонцаПериода) Экспорт
	
	Если НачалоМесяца(ДатаНачалаПериода) = НачалоМесяца(ДатаКонцаПериода) Тогда
		// Период в пределах месяца.
		СтрокаОписанияПериода = Формат(ДатаНачалаПериода, "ДФ='ММММ гггг'") + " г." ;
	ИначеЕсли НачалоГода(ДатаНачалаПериода) = НачалоГода(ДатаКонцаПериода) Тогда
		// Период в пределах года.
		СтрокаОписанияПериода = Формат(ДатаНачалаПериода, "ДФ='ММММ'") + " - " + Формат(ДатаКонцаПериода, "ДФ='ММММ гггг'") + " г." ;
	Иначе
		// Период, покрывающий более 1 года.
		СтрокаОписанияПериода = Формат(ДатаНачалаПериода, "ДФ='ММММ гггг'") + " - " + Формат(ДатаКонцаПериода, "ДФ='ММММ гггг'") + " г." ;
	КонецЕсли;
	
	Возврат СтрокаОписанияПериода;
	
КонецФункции

Процедура ЗаполнитьОбласть(ПолеТабличногоДокумента, ИмяОбласти, ЗначениеЗаполнения) Экспорт
	
	ЗаполняемаяОбласть = ПолеТабличногоДокумента.Области.Найти(ИмяОбласти);
	
	Если ЗаполняемаяОбласть <> Неопределено Тогда
		Если ЗаполняемаяОбласть.СодержитЗначение = Истина Тогда // возможны 3 состояния
			ЗаполняемаяОбласть.Значение = ЗначениеЗаполнения;
		Иначе
			ЗаполняемаяОбласть.Текст = ЗначениеЗаполнения;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
	                                         ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция СтрокаЧГ0(ИсходноеЧисло) Экспорт // враппер
	
	Возврат РегламентированнаяОтчетность.СтрокаЧГ0(ИсходноеЧисло);
	
КонецФункции

мФормыИФорматы = РегламентированнаяОтчетность.НовоеДеревоФормИФорматов();

Форма20110101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "710001", '2010-07-02', "66н", "ФормаОтчета2011Кв1");
ОпределитьФорматВДеревеФормИФорматов(Форма20110101, "5.01");

Форма20110901 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "710001", '2010-07-02', "66н", "ФормаОтчета2011Кв3");
ОпределитьФорматВДеревеФормИФорматов(Форма20110901, "5.01");

Форма20111201 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "710099", '2011-10-05', "124н", "ФормаОтчета2011Кв4");
ОпределитьФорматВДеревеФормИФорматов(Форма20111201, "5.02");

Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "710099", '2011-10-05', "124н", "ФормаОтчета2011Кв4");
ОпределитьФорматВДеревеФормИФорматов(Форма20120101, "5.03");
ОпределитьФорматВДеревеФормИФорматов(Форма20120101, "5.04");

ФормаОтчета2011Кв4_3 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "710099", '2015-04-06', "57н", "ФормаОтчета2011Кв4");
ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2011Кв4_3, "5.06");

мГруппаОрганизаций = Новый СписокЗначений;

ОписаниеТиповСтрока254 = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(254);
ОписаниеТиповСтрока15  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(15);

МассивТипов = Новый Массив;
МассивТипов.Добавить(Тип("Дата"));
ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));

мТаблицаСоставПоказателей = Новый ТаблицаЗначений;
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента", ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу", ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме", ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ПризнМногострочности", ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя", ОписаниеТиповСтрока15);

мСтруктураВариантыЗаполнения = Новый Структура;

мТаблицаФормОтчета = Новый ТаблицаЗначений;
мТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета", ОписаниеТиповСтрока254);
мТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета", ОписаниеТиповСтрока254, "Утверждена",  20);
мТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата, "Действует с", 5);
мТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия", ОписаниеТиповДата, "         по", 5);

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина России от 02.07.2010 г. №66н";
НоваяФорма.ДатаНачалоДействия = '2011-01-01';
НоваяФорма.ДатаКонецДействия  = '2011-08-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв3";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина России от 02.07.2010 г. №66н";
НоваяФорма.ДатаНачалоДействия = '2011-09-01';
НоваяФорма.ДатаКонецДействия  = '2011-11-30';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв4";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина России от 02.07.2010 г. №66н, в ред. приказа Минфина России от 05.10.2011 № 124н";
НоваяФорма.ДатаНачалоДействия = '2011-12-01';
НоваяФорма.ДатаКонецДействия  = '2014-12-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв4";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина России от 02.07.2010 г. №66н, в ред. приказа Минфина России от 06.04.2015 № 57н";
НоваяФорма.ДатаНачалоДействия = '2015-01-01';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
