﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//начало изменений ДС МСФО 11.12.2013
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
	//конец изменений ДС МСФО 11.12.2013
КонецПроцедуры //ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ, Режим)
	// регистр ДС_РасчетАмортизацииОСПропорциональноОбъемуВыпуска
	Движения.ДС_РасчетАмортизацииОСПропорциональноОбъемуВыпуска.Записывать = Истина;
	Движения.ДС_РасчетАмортизацииОСПропорциональноОбъемуВыпуска.Очистить();
	Для Каждого ТекСтрокаОсновныеСредства Из ОбъемПродукции Цикл
		Движение = Движения.ДС_РасчетАмортизацииОСПропорциональноОбъемуВыпуска.Добавить();
		Движение.Период = Дата;
		Движение.ОсновноеСредство 				= ОсновноеСредство;
		Движение.ПериодАмортизации 				= ТекСтрокаОсновныеСредства.ПериодАмортизации;
		Движение.КоличествоВыпущеннойПродукции 	= ТекСтрокаОсновныеСредства.КоличествоВыпущеннойПродукции;
		Движение.СуммаАмортизации 				= ТекСтрокаОсновныеСредства.СуммаАмортизации;
	КонецЦикла;
КонецПроцедуры //ОбработкаПроведения()
