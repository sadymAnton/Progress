﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Международный.Записывать	= Истина;

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственностиКорректировка.Документ,
		|	ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственностиКорректировка.СодержаниеОперации
		|ПОМЕСТИТЬ ВТСодержание
		|ИЗ
		|	Документ.ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственности.Корректировка КАК ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственностиКорректировка
		|ГДЕ
		|	ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственностиКорректировка.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственностиКорректировка.СодержаниеОперации,
		|	ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственностиКорректировка.Документ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МеждународныйДвиженияССубконто.СчетДт,
		|	МеждународныйДвиженияССубконто.СубконтоДт1,
		|	МеждународныйДвиженияССубконто.СубконтоДт2,
		|	МеждународныйДвиженияССубконто.СубконтоДт3,
		|	МеждународныйДвиженияССубконто.СчетКт,
		|	МеждународныйДвиженияССубконто.СубконтоКт1,
		|	МеждународныйДвиженияССубконто.СубконтоКт2,
		|	МеждународныйДвиженияССубконто.СубконтоКт3,
		|	МеждународныйДвиженияССубконто.Организация,
		|	МеждународныйДвиженияССубконто.ВалютаДт,
		|	МеждународныйДвиженияССубконто.ВалютаКт,
		|	МеждународныйДвиженияССубконто.Сумма,
		|	МеждународныйДвиженияССубконто.ВалютнаяСуммаДт,
		|	МеждународныйДвиженияССубконто.ВалютнаяСуммаКт,
		|	МеждународныйДвиженияССубконто.КоличествоДт,
		|	МеждународныйДвиженияССубконто.КоличествоКт,
		|	ВТСодержание.СодержаниеОперации КАК Содержание
		|ИЗ
		|	РегистрБухгалтерии.Международный.ДвиженияССубконто(, , ПервичныйДокумент В (&Регистратор), , ) КАК МеждународныйДвиженияССубконто
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСодержание КАК ВТСодержание
		|		ПО МеждународныйДвиженияССубконто.ПервичныйДокумент = ВТСодержание.Документ";

	Запрос.УстановитьПараметр("Регистратор", Корректировка.ВыгрузитьКолонку("Документ"));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Результат = Запрос.Выполнить();

	Выборка = Результат.Выбрать();

	Пока Выборка.Следующий() Цикл
		
		СформироватьПроводки(Выборка, Истина); 
		СформироватьПроводки(Выборка, Ложь); 

	КонецЦикла;   
	
КонецПроцедуры

Процедура СформироватьПроводки(Выборка, Сторно)
		
	Движение		= Движения.Международный.Добавить();
	Движение.Период = ?(Сторно = Истина, Дата, ДатаРеверсирования);
	ЗаполнитьЗначенияСвойств(Движение, Выборка);
	
	Если Сторно Тогда
		Движение.Сумма = -Выборка.Сумма;
	КонецЕсли;
	
	БухгалтерскийУчет.УстановитьСубконто(Выборка.СчетКт, Движение.СубконтоКт, 1, Выборка.СубконтоКт1);
	БухгалтерскийУчет.УстановитьСубконто(Выборка.СчетКт, Движение.СубконтоКт, 2, Выборка.СубконтоКт2);
	БухгалтерскийУчет.УстановитьСубконто(Выборка.СчетКт, Движение.СубконтоКт, 3, Выборка.СубконтоКт3);
	БухгалтерскийУчет.УстановитьСубконто(Выборка.СчетДт, Движение.СубконтоДт, 1, Выборка.СубконтоДт1);
	БухгалтерскийУчет.УстановитьСубконто(Выборка.СчетДт, Движение.СубконтоДт, 2, Выборка.СубконтоДт2);
	БухгалтерскийУчет.УстановитьСубконто(Выборка.СчетДт, Движение.СубконтоДт, 3, Выборка.СубконтоДт3);
	
КонецПроцедуры	

Процедура ПриЗаписи(Отказ)
	
	
	//Проверяем на дублируемость документов в табличной части
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственностиКорректировка.Документ КАК Документ
		|ИЗ
		|	Документ.ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственности.Корректировка КАК ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственностиКорректировка
		|ГДЕ
		|	ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственностиКорректировка.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственностиКорректировка.Документ
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(ДС_КорректировкаРасходовПоРеализацииПродукцииСНеПрошедшимПравомСобственностиКорректировка.Документ) > 1";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда 
		Сообщить("В табличной части дублируются документы !");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

