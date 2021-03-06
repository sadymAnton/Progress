﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если не ЗначениеЗаполнено(Параметры.GUID) Тогда Отказ = Истина; Возврат; КонецЕсли;
	
	Наименование 	= Параметры.Наименование;
	Артикул 		= Параметры.Артикул;
	ГОСТ 			= Параметры.ГОСТ;
	СоответствиеГОСТ = Параметры.СоответствуетГОСТ;
	ProductItemGUID = Параметры.GUID;
	ProductItemUUID = Параметры.UUID;
	ВидПродукции	= Параметры.ВходныеДанные;//ПолучитьПредставлениеsubProductGUID(ВходныеДанные.subProductGUID);
	
	Активен			= Параметры.Активен;
	ProductItemUUIDновый = Параметры.НоваяВерсияUUID;
	
	Если не Активен Тогда 
		Элементы.Активен.ЦветТекстаЗаголовка = WebЦвета.Красный;
		//Элементы.Активен.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Одинарная, 1);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ProductItemUUIDновый) Тогда 
		Элементы.НадписьProductItemUUIDНовая.ЦветТекста = WebЦвета.Красный;
		//Элементы.НадписьProductItemUUIDНовая.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Одинарная, 1);
	КонецЕсли;


КонецПроцедуры
