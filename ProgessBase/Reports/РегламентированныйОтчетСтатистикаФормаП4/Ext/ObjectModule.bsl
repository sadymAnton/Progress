﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит таблицу значений - состав показателей отчета.
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

Перем мПериодичность Экспорт;

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

Перем мФормыИФорматы Экспорт;
Перем мВерсияОтчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ ОПРЕДЕЛЕНИЯ ДЕРЕВА ФОРМ И ФОРМАТОВ

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

////////////////////////////////////////////////////////////////////////////////
// ОПРЕДЕЛЕНИЕ ДЕРЕВА ФОРМ И ФОРМАТОВ ОТЧЕТА

мФормыИФорматы = РегламентированнаяОтчетность.НовоеДеревоФормИФорматов();

// определение форм
Форма20050101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "606010", '20040727', "34",		"ФормаОтчета2005Кв1");
Форма20060101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "606010", '20050801', "52",		"ФормаОтчета2006Кв1");
Форма20070101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "606010", '20060628', "28",		"ФормаОтчета2007Кв1");
Форма20080101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "606010", '20070808', "62",		"ФормаОтчета2008Кв1");
Форма20090101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "606010", '20080818', "193",	"ФормаОтчета2009Кв1");
Форма20090301 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "606010", '20090313', "42",		"ФормаОтчета2009Кв2");
Форма20100101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "606010", '20090826', "184",	"ФормаОтчета2010Кв1");
Форма20110101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "606010", '20100720', "256",	"ФормаОтчета2011Кв1");
Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "606010", '20110819', "367",	"ФормаОтчета2012Кв1");
Форма20130101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "606010", '20120724', "407",	"ФормаОтчета2013Кв1");
Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "606010", '20140924', "580",	"ФормаОтчета2014Кв1");
РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20140101, "07-06-2016");
Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "606010", '20160802', "379",	"ФормаОтчета2017Кв1");
РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20140101, "27-02-2017");

ОписаниеТиповСтрока = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(0);

МассивТипов = Новый Массив;
МассивТипов.Добавить(Тип("Дата"));
ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));

мТаблицаФормОтчета = Новый ТаблицаЗначений;
мТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
мТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
мТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
мТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2005Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена постановлением Федеральной службы государственной статистики от 27.07.2004 № 34";
НоваяФорма.ДатаНачалоДействия = '20050101';
НоваяФорма.ДатаКонецДействия  = '20051231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2006Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена постановлением Росстата от 01.08.2005 № 52";
НоваяФорма.ДатаНачалоДействия = '20060101';
НоваяФорма.ДатаКонецДействия  = '20061231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2007Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена постановлением Росстата от 28.06.2006 № 28";
НоваяФорма.ДатаНачалоДействия = '20070101';
НоваяФорма.ДатаКонецДействия  = '20071231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2008Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена постановлением Росстата от 09.06.2007 № 46 (в редакции постановления Росстата от 08.08.2007 № 62)";
НоваяФорма.ДатаНачалоДействия = '20080101';
НоваяФорма.ДатаКонецДействия  = '20081231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Росстата от 18.08.2008 № 193";
НоваяФорма.ДатаНачалоДействия = '20090101';
НоваяФорма.ДатаКонецДействия  = '20090228';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв2";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Росстата от 18.08.2008 № 193 (в редакции Приказа Росстата от 13.03.2009 г. № 42)";
НоваяФорма.ДатаНачалоДействия = '20090301';
НоваяФорма.ДатаКонецДействия  = '20091231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2010Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Росстата от 26.08.2009 № 184";
НоваяФорма.ДатаНачалоДействия = '20100101';
НоваяФорма.ДатаКонецДействия  = '20101231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Росстата от 20.07.2010 № 256";
НоваяФорма.ДатаНачалоДействия = '20110101';
НоваяФорма.ДатаКонецДействия  = '20111231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Росстата от 19.08.2011 № 367";
НоваяФорма.ДатаНачалоДействия = '20120101';
НоваяФорма.ДатаКонецДействия  = '20121231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Росстата от 24.07.2012 № 407";
НоваяФорма.ДатаНачалоДействия = '20130101';
НоваяФорма.ДатаКонецДействия  = '20141231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Росстата от 24.09.2014 № 580";
НоваяФорма.ДатаНачалоДействия = '20150101';
НоваяФорма.ДатаКонецДействия  = '20161231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Росстата от 02.08.2016 № 379";
НоваяФорма.ДатаНачалоДействия = '20170101';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
