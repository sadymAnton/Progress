﻿Перем ОшибкаЗаполнения Экспорт;

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

Процедура ОбработкаПроверкиЗаполнения (Отказ, ПроверяемыеРеквизиты)
	// формируем соответствие для колучения кода вида документа
	КодПоВидуДокумента = ПолучитьСоответствиеКодПоВидуДокумента();
	КодДок = КодПоВидуДокумента[ВидДокумента];
	
	Если КодДок <> "0924" И КодДок <> "1665" И КодДок <> "2181" 
	   И КодДок <> "2330" И КодДок <> "2234" И КодДок <> "2745"
	   И КодДок <> "2766" И КодДок <> "2772" Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ДатаДокумента")); 
	КонецЕсли; 
	
	Если КодДок <> "0924" И КодДок <> "1665" И КодДок <> "2215" 
	   И КодДок <> "2216" И КодДок <> "2330" И КодДок <> "2745"
	   И КодДок <> "2766" И КодДок <> "2772" Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("НомерДокумента")); 
	КонецЕсли;
	
	//Если КодДок <> "0924" И КодДок <> "1665" И КодДок <> "2181" 
	//   И КодДок <> "2330" И КодДок <> "2234" И КодДок <> "2772" Тогда
	//	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("СуммаВсего")); 
	//КонецЕсли;
	//
	//Если КодДок <> "0924" Тогда
	//	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("СуммаНалога")); 
	//КонецЕсли;

	Если КодДок <> "1665" И КодДок <> "2181" И КодДок <> "2216" 
	   И КодДок <> "2330" И КодДок <> "2745" И КодДок <> "2772" Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("НомерОснования")); 
	КонецЕсли;
	
	Если КодДок <> "1665" И КодДок <> "2181" И КодДок <> "2330" 
	   И КодДок <> "2745" И КодДок <> "2772" Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ДатаОснования")); 
	КонецЕсли;
	
	Если КодДок <> "2745" И КодДок <> "2330" И КодДок <> "2766" Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ПредметДокумента")); 
	КонецЕсли; 
	
	Если КодДок <> "0924" И КодДок <> "1665" И КодДок <> "2181" 
	   И КодДок <> "2330" И КодДок <> "2234" И КодДок <> "2745"
	   И КодДок <> "2766" И КодДок <> "2772" Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("РеквизитыУчастников")); 
	КонецЕсли;

	// Обходим строки и проверяем заполнение реквизита
   Для Индекс = 1 по РеквизитыУчастников.Количество() Цикл
	   Индекс0 = Индекс - 1;
	   РеквизитыУчастника = РеквизитыУчастников.Получить(Индекс0);
	   
	   Если РеквизитыУчастника.ЯвляетсяЮрЛицом Тогда
		   //для юридического лица
		   
		   Если Не ЗначениеЗаполнено(РеквизитыУчастника.ЮрЛицоНаименование) Тогда
			   Сообщение = Новый СообщениеПользователю();
			   Сообщение.Текст = "В строке " + Индекс + " таблицы ""Реквизиты участников сделки"" не заполнено значение ""Полное наименование организации""";
			   Сообщение.Поле = "РеквизитыУчастников[" + Индекс0 + "].ЮрЛицоНаименование";
			   Сообщение.УстановитьДанные(ЭтотОбъект);
			   Сообщение.Сообщить();
			   Отказ = Истина;
		   КонецЕсли;
		   
		   Если КодДок = "2181" ИЛИ КодДок = "2330" ИЛИ КодДок = "2745" ИЛИ КодДок = "2766" Тогда
			   
			   Если Не ЗначениеЗаполнено(РеквизитыУчастника.ЮрЛицоИНН) Тогда
				   Сообщение = Новый СообщениеПользователю();
				   Сообщение.Текст = "В строке " + Индекс + " таблицы ""Реквизиты участников сделки"" не заполнено значение ""ИНН организации""";
				   Сообщение.Поле = "РеквизитыУчастников[" + Индекс0 + "].ЮрЛицоИНН";
				   Сообщение.УстановитьДанные(ЭтотОбъект);
				   Сообщение.Сообщить();
				   Отказ = Истина;
			   КонецЕсли;
			   
		   КонецЕсли;
		   
	   Иначе
		   //для физического лица
		   
		   //отменяем проверку для физ лица - в случае отсутствия ИНН выгружаем 12 нулей
		   // Если КодДок = "2181" ИЛИ КодДок = "2330" ИЛИ КодДок = "2745" ИЛИ КодДок = "2766" Тогда
		   //	
		   //	Если Не ЗначениеЗаполнено(РеквизитыУчастника.ФизЛицоИНН) Тогда
		   // 	   Сообщение = Новый СообщениеПользователю();
		   // 	   Сообщение.Текст = "В строке " + Индекс + " таблицы ""Реквизиты участников сделки"" не заполнено значение ""ИНН физического лица""";
		   // 	   Сообщение.Поле = "РеквизитыУчастников[" + Индекс0 + "].ФизЛицоИНН";
		   // 	   Сообщение.УстановитьДанные(ЭтотОбъект);
		   // 	   Сообщение.Сообщить();
		   // 	   Отказ = Истина;
		   //	КонецЕсли;
		   //	
		   //КонецЕсли;
		   
	   КонецЕсли;
	   
   КонецЦикла;

КонецПроцедуры

//вспомогательная для ОбработкаПроверкиЗаполнения 
Функция ПолучитьСоответствиеКодПоВидуДокумента()
	
	Соответствие = Новый Соответствие;
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.СчетФактура,								"0924");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.КнигаПокупок, 								"0925");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.КнигаПродаж, 								"0926");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.ЖурналПолученныхИВыставленныхСчетовФактур, 	"1004");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.ТоварноТранспортнаяНакладная, 				"1665");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.АктПриемкиСдачиРабот, 						"2181");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.ГрузоваяТаможеннаяДекларация, 				"2215");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.ДобавочныйЛистГрузовойТаможеннойДекларации, "2216");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.ДополнительныйЛистКнигиПокупок, 			"2232");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.ДополнительныйЛистКнигиПродаж, 				"2233");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.ТоварнаяНакладнаяТОРГ12, 					"2234");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.СпецификацияЦены, 							"2330");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.ДополнениеКДоговору, 						"2745");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.Договор, 									"2766");
	Соответствие.Вставить(Перечисления.ВидыПредставляемыхДокументов.КорректировочныйСчетФактура,				"2772");
	
	Возврат Соответствие;
	
КонецФункции
