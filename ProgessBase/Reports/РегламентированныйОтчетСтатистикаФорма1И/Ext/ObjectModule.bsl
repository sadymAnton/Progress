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

// Следующие переменные хранят границы
// периода построения отчета
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;
Перем мПериодичность Экспорт;

Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Перем мЗаписьЗапрещена Экспорт;

Перем мИнтервалАвтосохранения Экспорт;

Перем мТаблицаФормОтчета Экспорт;

Перем мРезультатПоиска Экспорт;// таблица с результатами поиска
Перем мСчетчикиСтраницПриПоиске Экспорт;

Перем мЗаписываетсяНовыйДокумент Экспорт;
Перем мВариант Экспорт;

Перем мФормыИФорматы Экспорт;
Перем мВерсияОтчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ ОПРЕДЕЛЕНИЯ ДЕРЕВА ФОРМ И ФОРМАТОВ

Функция СоздатьДеревоФормИФорматов()
	
	мФормыИФорматы = Новый ДеревоЗначений;
	мФормыИФорматы.Колонки.Добавить("Код");
	мФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	мФормыИФорматы.Колонки.Добавить("НомерПриказа");
	мФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	мФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	мФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	мФормыИФорматы.Колонки.Добавить("Описание");
	Возврат мФормыИФорматы;
	
КонецФункции

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

мФормыИФорматы = СоздатьДеревоФормИФорматов();

// определение форм
Форма20040709 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "617001", '20040709', "25",		"ФормаОтчета2004Кв3");
Форма20060101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "617001", '20050801', "54",		"ФормаОтчета2006Кв1");
Форма20080101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "617001", '20071002', "70",		"ФормаОтчета2008Кв1");
Форма20090101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "617001", '20080807', "184",	"ФормаОтчета2009Кв1");
Форма20100101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "617001", '20090716', "139",	"ФормаОтчета2010Кв1");
Форма20100101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "617001", '20120727', "423",	"ФормаОтчета2013Кв1");

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
НоваяФорма.ФормаОтчета        = "ФормаОтчета2004Кв3";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена постановлением Федеральной службы государственной статистики от 09.07.2004 № 25";
НоваяФорма.ДатаНачалоДействия = '20040709';
НоваяФорма.ДатаКонецДействия  = '20051231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2006Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена постановлением Росстата от 01.08.2005 № 54";
НоваяФорма.ДатаНачалоДействия = '20060101';
НоваяФорма.ДатаКонецДействия  = '20071231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2008Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена постановлением Росстата от  02.10.2007 № 70";
НоваяФорма.ДатаНачалоДействия = '20080101';
НоваяФорма.ДатаКонецДействия  = '20081231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от  07.08.2008 № 184";
НоваяФорма.ДатаНачалоДействия = '20090101';
НоваяФорма.ДатаКонецДействия  = '20091231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2010Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от  16.07.2009 № 139";
НоваяФорма.ДатаНачалоДействия = '20100101';
НоваяФорма.ДатаКонецДействия  = '20121231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от  27.07.2012 № 423";
НоваяФорма.ДатаНачалоДействия = '20130101';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
