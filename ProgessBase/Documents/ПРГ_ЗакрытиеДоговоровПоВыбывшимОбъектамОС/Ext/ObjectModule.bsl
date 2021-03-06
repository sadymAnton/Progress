﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры


Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Счет91_02 = ПланыСчетов.Международный.ПрочиеВнереализационныеРасходы;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОСМСФО.МестонахождениеОбъекта КАК ПодразделениеОрганизации
	|ИЗ
	|	РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(&Дата, ОсновноеСредство = &ОсновноеСредство) КАК ОСМСФО");
	
	Движения.Международный.Записывать = Истина;
	
	Для Каждого СтрокаТЧ Из Договоры Цикл
		
		Если СтрокаТЧ.СальдоКонечноеРуб = 0 И СтрокаТЧ.СальдоКонечноеВал = 0 Тогда
			Продолжить;
		КонецЕсли;
	
		Запрос.УстановитьПараметр("Дата", СтрокаТЧ.ДатаВыбытия);
		Запрос.УстановитьПараметр("ОсновноеСредство", СтрокаТЧ.Договор.ДС_ОбъектДоговора);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Подразделение = Выборка.ПодразделениеОрганизации;
		КонецЕсли;
		
		Проводка = Движения.Международный.Добавить();
		Проводка.Период = Дата;
		Проводка.Организация = Организация;
		
		Если СтрокаТЧ.СальдоКонечноеРуб < 0 Тогда // дебетовое
			
			Проводка.Сумма 	= - СтрокаТЧ.СальдоКонечноеРуб;
			
			Проводка.СчетДт	= Счет91_02;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтатьяПрочихДоходовРасходов);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, Подразделение);
			
			Проводка.СчетКт = СтрокаТЧ.Счет;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, СтрокаТЧ.Договор.Владелец);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, СтрокаТЧ.Договор);
			Если Проводка.СчетКт.Валютный Тогда 
				Проводка.ВалютаКт = СтрокаТЧ.Договор.ВалютаВзаиморасчетов;
				Проводка.ВалютнаяСуммаКт = - СтрокаТЧ.СальдоКонечноеВал;
			КонецЕсли;
			
		Иначе
			
			Проводка.Сумма 	= - СтрокаТЧ.СальдоКонечноеРуб;
			
			Проводка.СчетКт = СтрокаТЧ.Счет;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, СтрокаТЧ.Договор.Владелец);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, СтрокаТЧ.Договор);
			Если Проводка.СчетКт.Валютный Тогда 
				Проводка.ВалютаКт = СтрокаТЧ.Договор.ВалютаВзаиморасчетов;
				Проводка.ВалютнаяСуммаКт = - СтрокаТЧ.СальдоКонечноеВал;
			КонецЕсли;
			
			Проводка.СчетДт	= Счет91_02;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтатьяПрочихДоходовРасходов);
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, Подразделение);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
