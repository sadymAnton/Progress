﻿Перем ВремТабл;    

Функция ПолучитьОборотыПоЗаявке(ЗаявкаДокумент, Контрагент = Неопределено, Договор = Неопределено, СтатьяДДС = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкиНаРасходованиеСредствОстаткиИОбороты.ЗаявкаНаРасходование КАК Заявка,
	|	ЗаявкиНаРасходованиеСредствОстаткиИОбороты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ЗаявкиНаРасходованиеСредствОстаткиИОбороты.СтатьяДвиженияДенежныхСредств КАК СтатьяДДС,
	|	ЗаявкиНаРасходованиеСредствОстаткиИОбороты.Организация,
	|	ЗаявкиНаРасходованиеСредствОстаткиИОбороты.Контрагент КАК Контрагент,
	|	ЗаявкиНаРасходованиеСредствОстаткиИОбороты.СуммаУпрКонечныйОстаток КАК ОстатокПоЗаявке,
	|	ЗаявкиНаРасходованиеСредствОстаткиИОбороты.СуммаУпрПриход КАК СуммаЗаявки,
	|	ЗаявкиНаРасходованиеСредствОстаткиИОбороты.СуммаУпрКонечныйОстаток КАК СуммаПлатежа,
	|	ВЫБОР
	|		КОГДА ЗаявкиНаРасходованиеСредствОстаткиИОбороты.ДоговорКонтрагента.РасчетыВУсловныхЕдиницах
	|			ТОГДА &ВалютаРубли
	|		ИНАЧЕ ЗаявкиНаРасходованиеСредствОстаткиИОбороты.ЗаявкаНаРасходование.ВалютаДокумента
	|	КОНЕЦ КАК ВалютаДокумента,
	|	ЗаявкиНаРасходованиеСредствОстаткиИОбороты.ЗаявкаНаРасходование.ЦФО КАК Подразделение,
	|	ЗаявкиНаРасходованиеСредствОстаткиИОбороты.ЗаявкаНаРасходование.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента,
	|	&Счет6001 КАК СчетУчетаРасчетовСКонтрагентом,
	|	&Счет6002 КАК СчетУчетаРасчетовПоАвансам,
	|	ЕСТЬNULL(ЗаявкиНаРасходованиеСредствОстаткиИОбороты.ЗаявкаНаРасходование.БанковскийСчетКасса, ""<Не распределено>"") КАК БанковскийСчет
	|ИЗ
	|	РегистрНакопления.ЗаявкиНаРасходованиеСредств.ОстаткиИОбороты(
	|			,
	|			,
	|			,
	|			,
	|			Контрагент = &Контрагент
	|				И ДоговорКонтрагента = &Договор
	|				И ЗаявкаНаРасходование = &ЗаявкаДокумент
	|				И СтатьяДвиженияДенежныхСредств = &СтатьяДДС) КАК ЗаявкиНаРасходованиеСредствОстаткиИОбороты
	|ГДЕ
	|	ЗаявкиНаРасходованиеСредствОстаткиИОбороты.СуммаУпрКонечныйОстаток > 0";
	Запрос.УстановитьПараметр("ЗаявкаДокумент", ЗаявкаДокумент);
	Запрос.УстановитьПараметр("Договор", Договор);               
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("СтатьяДДС", СтатьяДДС);
	Запрос.УстановитьПараметр("Счет6001", ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.01"));
	Запрос.УстановитьПараметр("Счет6002", ПланыСчетов.Хозрасчетный.НайтиПоКоду("60.02"));
	Запрос.УстановитьПараметр("ВалютаРубли", Справочники.Валюты.НайтиПоКоду("643"));
	ТЗ = Запрос.Выполнить().Выгрузить();
	Возврат ?(ТЗ.Количество()>0, ТЗ[0], Неопределено);
	
КонецФункции

Процедура ЗаполнитьИнформациюПоЗаявке(Заявка)
	
	
	
КонецПроцедуры	

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	//Для Каждого Строка Из Основная Цикл
	//	
	//	Документ = Строка.Заявка.ПолучитьОбъект();
	//	Документ.БанковскийСчетКасса = Строка.БанковскийСчет;
	//	Документ.Записать(РежимЗаписиДокумента.Проведение);
	//	
	//КонецЦикла;
	
	
КонецПроцедуры

