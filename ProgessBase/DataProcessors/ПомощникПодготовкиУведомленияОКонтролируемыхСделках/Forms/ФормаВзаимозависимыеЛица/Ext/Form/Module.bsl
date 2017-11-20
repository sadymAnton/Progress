﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура УстановитьОтборВзаимозависимыхЛиц()
	
	ЭлементОтбораДанных = ВзаимозависимыеЛица.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
	ЭлементОтбораДанных.Использование = Истина;
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбораДанных.ПравоеЗначение = Объект.Организация; 	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	УстановитьОтборВзаимозависимыхЛиц();
	
КонецПроцедуры
