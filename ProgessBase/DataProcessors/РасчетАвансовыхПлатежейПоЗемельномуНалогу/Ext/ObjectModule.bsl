﻿
Процедура СформироватьОтчет() Экспорт
	
	ДокументРезультат = Новый ТабличныйДокумент;
	
	Макет      = ПолучитьМакет("СправкаРасчетТН");
	МакетОбщий = ПолучитьОбщийМакет("СправкаРасчет");
	
	ЗаголовокОтчета         = МакетОбщий.ПолучитьОбласть("Заголовок");
	ОбластьШапка            = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока           = Макет.ПолучитьОбласть("Строка");
	ОбластьИтого            = Макет.ПолучитьОбласть("Итого");
	ОбластьОкончаниеТаблицы = Макет.ПолучитьОбласть("ОкончаниеТаблицы");
	ОбластьПодвал           = МакетОбщий.ПолучитьОбласть("Подвал");
	
	ЗаголовокОтчета.Параметры.Период = "" + ПредставлениеПериода(НачалоКвартала(Период), КонецКвартала(Период), "ФП = Истина");
	СведенияОбОрганизации = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Организация, Период);
#Если Клиент Тогда
	НазваниеОрганизации = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование");
	ЗаголовокОтчета.Параметры.НазваниеОрганизации = НазваниеОрганизации;
#КонецЕсли
	ЗаголовокОтчета.Параметры.ДатаСоставления     = КонецКвартала(Период);
	ЗаголовокОтчета.Параметры.НазваниеОтчета      = "Авансовый платеж по земельному налогу";
	ДокументРезультат.Вывести(ЗаголовокОтчета,1);
	
	ВысотаЗаголовка = ДокументРезультат.ВысотаТаблицы;
	ДокументРезультат.Вывести(ОбластьШапка,1);
	
	ТаблицаДляПечати = ЗемельныеУчастки.Выгрузить();
	ТаблицаДляПечати.Сортировать("КодПоОКАТО, НомерСтроки");
	ТекущийОКАТО = ?(ТаблицаДляПечати.Количество() > 0, ТаблицаДляПечати[0].КодПоОКАТО, "");
	НС = 1;
	Для Каждого Строка Из ТаблицаДляПечати Цикл
		Если ТекущийОКАТО <> Строка.КодПоОКАТО Тогда
			СтрокаПоОКАТО = АвансовыеПлатежи.Найти(ТекущийОКАТО, "КодПоОКАТО");
			ОбластьИтого.Параметры.КодПоОКАТО = ТекущийОКАТО;
			ОбластьИтого.Параметры.СуммаНалогаПоОКАТО = ?(ЗначениеЗаполнено(СтрокаПоОКАТО), СтрокаПоОКАТО.Сумма, 0);
			ДокументРезультат.Вывести(ОбластьИтого,1);
			ТекущийОКАТО = Строка.КодПоОКАТО;
		КонецЕсли;
		ОбластьСтрока.Параметры.Заполнить(Строка);
		Если Строка.ОбщаяСобственность Тогда
			ОбластьСтрока.Параметры.Доля = Строка(Строка.ДоляВПравеОбщейСобственностиЧислитель) + "/" + Строка(Строка.ДоляВПравеОбщейСобственностиЗнаменатель);
		Иначе
			ОбластьСтрока.Параметры.Доля = "1";
		КонецЕсли;
		ОбластьСтрока.Параметры.НомерСтроки = НС;
		ДокументРезультат.Вывести(ОбластьСтрока,1);
		НС = НС + 1;
	КонецЦикла;
	
	СтрокаПоОКАТО = АвансовыеПлатежи.Найти(ТекущийОКАТО, "КодПоОКАТО");
	ОбластьИтого.Параметры.КодПоОКАТО = ТекущийОКАТО;
	ОбластьИтого.Параметры.СуммаНалогаПоОКАТО = ?(ЗначениеЗаполнено(СтрокаПоОКАТО), СтрокаПоОКАТО.Сумма, 0);
	ДокументРезультат.Вывести(ОбластьИтого,1);
	
	ДокументРезультат.Вывести(ОбластьОкончаниеТаблицы,1);
			
	ДокументРезультат.Вывести(ОбластьПодвал,1);
	
	// Зафиксируем заголовок отчета
	ДокументРезультат.ФиксацияСверху=9;
	
	ДокументРезультат.Показать();
	
	// Присвоим имя для сохранения параметров печати табличного документа
	ДокументРезультат.ИмяПараметровПечати = "Пересчет стоимости отложенных налоговых активов и обязательств";
	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(ДокументРезультат, ЗаголовокОтчета, Строка(глЗначениеПеременной("глТекущийПользователь")));
	
КонецПроцедуры
