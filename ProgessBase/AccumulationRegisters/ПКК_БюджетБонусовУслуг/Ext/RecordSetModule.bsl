﻿Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

// Выполняет движения по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижения() Экспорт

	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);

КонецПроцедуры // ВыполнитьДвижения()

Процедура КонтрольОстатков(ДокументОбъект, СтруктураШапкиДокумента, ТаблицаДвижений, Отказ, Заголовок, РежимПроведения) Экспорт

	Если Отказ ИЛИ ПараметрыСеанса.ПроведениеДокументов Тогда
		Возврат;	
	КонецЕсли; 

	ТаблицаДвижений.Свернуть("Период,Вывеска,Дивизион,СтатьяДДС","Сумма");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПКК_БюджетБонусовУслуг.Дивизион,
		|	ПКК_БюджетБонусовУслуг.Вывеска,
		|	ПКК_БюджетБонусовУслуг.СтатьяДДС,
		|	ПКК_БюджетБонусовУслуг.Сумма,
		|	ПКК_БюджетБонусовУслуг.Период
		|ПОМЕСТИТЬ втДвиженияДокументаРасход
		|ИЗ
		|	&ТаблицаДвижений КАК ПКК_БюджетБонусовУслуг
		|ГДЕ
		|	ПКК_БюджетБонусовУслуг.Сумма < 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.Дивизион,
		|	ВложенныйЗапрос.Вывеска,
		|	ВложенныйЗапрос.СтатьяДДС,
		|	СУММА(ВложенныйЗапрос.Сумма) КАК Сумма,
		|	ВложенныйЗапрос.ПериодБюджета
		|ПОМЕСТИТЬ втОстаткиНеРаспределенныхБюджетов
		|ИЗ
		|	(ВЫБРАТЬ
		|		ПКК_БюджетБонусовУслуг.Дивизион КАК Дивизион,
		|		ПКК_БюджетБонусовУслуг.Вывеска КАК Вывеска,
		|		ПКК_БюджетБонусовУслуг.СтатьяДДС КАК СтатьяДДС,
		|		СУММА(ПКК_БюджетБонусовУслуг.Сумма) КАК Сумма,
		|		НАЧАЛОПЕРИОДА(ПКК_БюджетБонусовУслуг.Период, ГОД) КАК ПериодБюджета
		|	ИЗ
		|		РегистрНакопления.ПКК_БюджетБонусовУслуг КАК ПКК_БюджетБонусовУслуг
		|	ГДЕ
		|		ПКК_БюджетБонусовУслуг.Активность
		|		И ПКК_БюджетБонусовУслуг.Вывеска = ЗНАЧЕНИЕ(Справочник.НСИ_Вывески.ПустаяСсылка)
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ПКК_БюджетБонусовУслуг.Вывеска,
		|		ПКК_БюджетБонусовУслуг.СтатьяДДС,
		|		ПКК_БюджетБонусовУслуг.Дивизион,
		|		НАЧАЛОПЕРИОДА(ПКК_БюджетБонусовУслуг.Период, ГОД)
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ПКК_РаспределенныйБюджетБонусовУслуг.Контрагент.Дивизион,
		|		ЗНАЧЕНИЕ(Справочник.НСИ_Вывески.ПустаяСсылка),
		|		ПКК_РаспределенныйБюджетБонусовУслуг.СтатьяДДС,
		|		СУММА(ВЫБОР
		|				КОГДА ПКК_РаспределенныйБюджетБонусовУслуг.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|					ТОГДА -ПКК_РаспределенныйБюджетБонусовУслуг.Сумма
		|				ИНАЧЕ 0
		|			КОНЕЦ),
		|		НАЧАЛОПЕРИОДА(ПКК_РаспределенныйБюджетБонусовУслуг.Дата, ГОД)
		|	ИЗ
		|		РегистрНакопления.ПКК_РаспределенныйБюджетБонусовУслуг КАК ПКК_РаспределенныйБюджетБонусовУслуг
		|	ГДЕ
		|		ПКК_РаспределенныйБюджетБонусовУслуг.Контрагент.НСИ_Вывеска = ЗНАЧЕНИЕ(Справочник.НСИ_Вывески.ПустаяСсылка)
		|		И ПКК_РаспределенныйБюджетБонусовУслуг.Активность
		|		И ПКК_РаспределенныйБюджетБонусовУслуг.МоментВремени < &МоментВремени
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ПКК_РаспределенныйБюджетБонусовУслуг.Контрагент.Дивизион,
		|		ПКК_РаспределенныйБюджетБонусовУслуг.СтатьяДДС,
		|		НАЧАЛОПЕРИОДА(ПКК_РаспределенныйБюджетБонусовУслуг.Дата, ГОД)) КАК ВложенныйЗапрос
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.Вывеска,
		|	ВложенныйЗапрос.СтатьяДДС,
		|	ВложенныйЗапрос.Дивизион,
		|	ВложенныйЗапрос.ПериодБюджета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втДвиженияДокументаРасход.Дивизион,
		|	втДвиженияДокументаРасход.Вывеска,
		|	втДвиженияДокументаРасход.СтатьяДДС,
		|	втДвиженияДокументаРасход.Сумма * -1 КАК Сумма,
		|	ЕСТЬNULL(втОстаткиНеРаспределенныхБюджетов.Сумма, 0) КАК ОстатокБюджета,
		|	втДвиженияДокументаРасход.Период
		|ИЗ
		|	втДвиженияДокументаРасход КАК втДвиженияДокументаРасход
		|		ЛЕВОЕ СОЕДИНЕНИЕ втОстаткиНеРаспределенныхБюджетов КАК втОстаткиНеРаспределенныхБюджетов
		|		ПО втДвиженияДокументаРасход.Дивизион = втОстаткиНеРаспределенныхБюджетов.Дивизион
		|			И втДвиженияДокументаРасход.СтатьяДДС = втОстаткиНеРаспределенныхБюджетов.СтатьяДДС
		|			И втДвиженияДокументаРасход.Период = втОстаткиНеРаспределенныхБюджетов.ПериодБюджета
		|
		|СГРУППИРОВАТЬ ПО
		|	втДвиженияДокументаРасход.Вывеска,
		|	втДвиженияДокументаРасход.Дивизион,
		|	втДвиженияДокументаРасход.СтатьяДДС,
		|	втДвиженияДокументаРасход.Сумма * -1,
		|	втДвиженияДокументаРасход.Период,
		|	ЕСТЬNULL(втОстаткиНеРаспределенныхБюджетов.Сумма, 0)
		|
		|ИМЕЮЩИЕ
		|	СУММА(ЕСТЬNULL(втОстаткиНеРаспределенныхБюджетов.Сумма, 0) - втДвиженияДокументаРасход.Сумма * -1) < 0";

	Запрос.УстановитьПараметр("ТаблицаДвижений", ТаблицаДвижений);
    Запрос.УстановитьПараметр("МоментВремени", ДокументОбъект.МоментВремени());
	//Запрос.УстановитьПараметр("КонецПериода", СтруктураШапкиДокумента.Дата);
	
	Результат = Запрос.Выполнить();
	//Отказ = НЕ Результат.Пустой();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл

		СтрокаСообщения = "Остатка по бюджета "+Формат(Выборка.Период,"ДФ=yyyy")+" года для "+ Выборка.Дивизион + " по статье "+ Выборка.СтатьяДДС +
		" недостаточно.";
		СвободныйОстаток = Выборка.ОстатокБюджета;

		УправлениеЗапасами.ОшибкаНетОстатка(
			СтрокаСообщения, 
			СвободныйОстаток, 
			Выборка.Сумма,
			"Руб.", 
			?(РольДоступна(Метаданные.ОсновнаяРоль.Имя) ИЛИ РольДоступна("ПКК_РуководительОКК") ИЛИ НачалоДня(ТекущаяДата()) < '20151201',Ложь,Отказ), 
			Заголовок);
	
	КонецЦикла; 
	
КонецПроцедуры
 