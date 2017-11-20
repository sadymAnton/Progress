﻿Перем мСвойстваФайлов Экспорт;

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	Если КонтекстЭДО <> Неопределено Тогда
		КонтекстЭДО.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ);
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	Если КонтекстЭДО <> Неопределено Тогда
		КонтекстЭДО.ПриЗаписиОбъекта(ЭтотОбъект, Отказ);
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(СообщениеОснование)
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	Если КонтекстЭДО <> Неопределено Тогда
		КонтекстЭДО.ОбработкаЗаполненияОбъекта(ЭтотОбъект, СообщениеОснование);
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры
