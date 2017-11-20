﻿&НаСервере
Перем ОбработкаОбъект;


&НаСервере
Функция МодульОбъекта()

	Если ОбработкаОбъект=Неопределено Тогда
		
		Если Параметры.КэшироватьМодульОбъекта Тогда
			Если Параметры.АдресХранилища<>"" Тогда
				_Структура = ПолучитьИзВременногоХранилища(Параметры.АдресХранилища);
				Если ТипЗнч(_Структура) = Тип("Структура") Тогда
					_Структура.Свойство("ОбработкаОбъект",ОбработкаОбъект);
				КонецЕсли;
			КонецЕсли;
			
			Если ОбработкаОбъект=Неопределено Тогда
				ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
				ОбработкаОбъект.ИнициализироватьПодключаемыеМодули();
				Параметры.АдресХранилища = ПоместитьВоВременноеХранилище(Новый Структура("ОбработкаОбъект",ОбработкаОбъект),УникальныйИдентификатор);
				ОбработкаОбъект.IDОсновнойФормы = Параметры.IDОсновнойФормы;
			КонецЕсли;
		Иначе
			ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
			ОбработкаОбъект.ИнициализироватьПодключаемыеМодули();
			ОбработкаОбъект.IDОсновнойФормы = Параметры.IDОсновнойФормы;
		КонецЕсли;
		
	КонецЕсли;	
	
	Возврат ОбработкаОбъект;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуОбъектаМодально(ИмяФормы, ПараметрыФормы = Неопределено, ИмяОбработчика = Неопределено, ПараметрыОбработчика = Неопределено, ВладелецОбработчика = Неопределено,РежимБлокирования = Неопределено)
	//отказ от модальности
	Если РежимБлокирования = Неопределено Тогда
		РежимБлокирования=	РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	Если ВладелецОбработчика = Неопределено Тогда
		ВладелецОбработчика=	ЭтаФорма;
	КонецЕсли;
	
	Если ИмяОбработчика = Неопределено Тогда
		ОписаниеОбработчика=	Неопределено;
	Иначе	
		Выполнить("ОписаниеОбработчика=	Новый ОписаниеОповещения(ИмяОбработчика, ВладелецОбработчика, ПараметрыОбработчика)");
	КонецЕсли;
	
	Выполнить("ОткрытьФорму(ИмяФормы, ПараметрыФормы, ВладелецОбработчика, , , ,  ОписаниеОбработчика, РежимБлокирования)");
	
КонецПроцедуры

&НаКлиенте
Процедура Принять(Команда)
	
	ПриНажатииКнопки(Команда.Имя);
	
	Если НужноПеревыставитьЗаказ Тогда
		
		ПеревыставитьЗаказОтразивИзменения(Заказ)		
		
	Иначе
		
		ПеренестиНовоеКоличествоВДокумент(Заказ);
		УстановитьСтатусУточнен(Заказ);
		
	КонецЕсли;
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтатусУточнен(Документ)

	МодульОбъекта().УстановитьСтатусДокумента(Документ,"ЗаказУточненПринят","Заказ");

КонецПроцедуры // УстановитьСтатусУточнен()

&НаСервере
Процедура ПеревыставитьЗаказОтразивИзменения(Заказ)
	НачатьТранзакцию();
	
	ПеренестиНовоеКоличествоВДокумент(Заказ);
	ПараметрыОтправки = Новый Структура();
	
	СтарыйИсходящийЗаказСсылка = МодульОбъекта().НайтиСообщениеДокумента(Параметры.Документ,"ORDERS","Исходящее");
	Если СтарыйИсходящийЗаказСсылка<>Неопределено Тогда
		СтарыйИсходящийЗаказ=СтарыйИсходящийЗаказСсылка.ПолучитьОбъект();	
		СтарыйИсходящийЗаказ.ТипСообщения="#"+СтарыйИсходящийЗаказ.ТипСообщения;
		СтарыйИсходящийЗаказ.Записать();
	КонецЕсли;
	
	МодульОбъекта().ОтправитьСообщение("ORDERS",Заказ,ПараметрыОтправки);	
	
	//пометить # ordrsp (т.е. удалить)
	ПолученныйORDRSPОбъект=Параметры.СообщениеСсылка.ПолучитьОбъект();
	ПолученныйORDRSPОбъект.ТипСообщения="#"+ПолученныйORDRSPОбъект.ТипСообщения;
	ПолученныйORDRSPОбъект.Записать();
	
	ЗафиксироватьТранзакцию();
КонецПроцедуры


&НаСервере
Процедура ПеренестиНовоеКоличествоВДокумент(Документ) //перенесем из колонки "Количество"
	
	Если НЕ НеобходимоИзменитьДокумент=Истина тогда
		Возврат;
	КонецЕсли;
	
	ИмяКонфигурации1С=МодульОбъекта().ИмяКонфигурации1С;
	
	Если ИмяКонфигурации1С = "УФ_УТ" Тогда
		//обойдем строки таблички этой формы - для каждой найдем такую(ие) же в документе - и обработаем	
		ДокументОбъект   = Документ.ПолучитьОбъект();
		ТабЧастьЗаказ = ДокументОбъект.Товары;
		Для Каждого СтрокаСравнения Из ТаблицаСравнения Цикл
			Если Не (СтрокаСравнения.КоличествоЗаказали = СтрокаСравнения.КоличествоПодтвердили) Тогда
				
				ОтборСтрок= Новый СТруктура("Отменено, Номенклатура",Ложь,СтрокаСравнения.Номенклатура);
				//СтрокаТабЧастиЗаказа = ТабЧастьЗаказ.Найти(СтрокаСравнения.Номенклатура,"Номенклатура");
				СтрокиЗаказа=ТабЧастьЗаказ.НайтиСтроки(ОтборСтрок);
				
				//ищем такие строки и в случае уменшения количества - разбиваем строку и вычеркиваем, а в случае 
				//увеличения количества - изменяем количество упаковок
				ОбработатьСтрокиЗаказа_УТ11(СтрокиЗаказа,ТабЧастьЗаказ,СтрокаСравнения,Документ);
				
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ИмяКонфигурации1С = "УФ_БП" Тогда
		
		ДокументОбъект   = Документ.ПолучитьОбъект();
		ТабЧастьЗаказ = ДокументОбъект.Товары;
		
		Для Каждого СтрокаСравнения Из ТаблицаСравнения Цикл
			Если Не (СтрокаСравнения.КоличествоЗаказали = СтрокаСравнения.КоличествоПодтвердили) Тогда
				
				ОтборСтрок= Новый СТруктура("Номенклатура",СтрокаСравнения.Номенклатура);
				//СтрокаТабЧастиЗаказа = ТабЧастьЗаказ.Найти(СтрокаСравнения.Номенклатура,"Номенклатура");
				СтрокиЗаказа=ТабЧастьЗаказ.НайтиСтроки(ОтборСтрок);
				
				//ищем такие строки и в случае уменшения количества - разбиваем строку и вычеркиваем, а в случае 
				//увеличения количества - изменяем количество упаковок
				ОбработатьСтрокиЗаказа_БП30(СтрокиЗаказа,ТабЧастьЗаказ,СтрокаСравнения,Документ);
				
			КонецЕсли;
		КонецЦикла;
		//удалить строки с 0 количеством
		КоличествоСтрок= ТабЧастьЗаказ.Количество();
		Для й=1 по КоличествоСтрок Цикл
			ТекСтр=ТабЧастьЗаказ[КоличествоСтрок-й];
			Если ТекСтр.Количество = 0 Тогда 
				ТабЧастьЗаказ.Удалить(КоличествоСтрок-й);
			КонецЕсли;
		КонецЦикла;
		
		//пересчитать итоги документа!
		Выполнить("ДокументОбъект.СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ДокументОбъект)");
		
	КонецЕсли;
	
	Попытка
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ДокументОбъект.Записать();
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ОбработатьСтрокиЗаказа_УТ11(СтрокиЗаказа,ТабЧастьЗаказ,СтрокаСравнения,ДокументЗаказа)
	
	ОсталосьРаспределить=СтрокаСравнения.Количество;
	ВсегоСтрок=СтрокиЗаказа.количество();
	сч=0;
	Для каждого СтрокаДокументаЗаказ Из СтрокиЗаказа Цикл
		сч=сч+1;
		Если ОсталосьРаспределить > СтрокаДокументаЗаказ.КоличествоУпаковок Тогда 
			Если сч=ВсегоСтрок Тогда  
				//решено заказать больше чем раньше и не осталось иных строк
				СтрокаДокументаЗаказ.КоличествоУпаковок=ОсталосьРаспределить;
				ПересчитатьКоличествоВСтроке(СтрокаДокументаЗаказ,ДокументЗаказа);
			Иначе//остались еще строки, а эта строка уже под завязку
				ОсталосьРаспределить=СтрокаСравнения.Количество - СтрокаДокументаЗаказ.КоличествоУпаковок;	
			КонецЕсли;
		ИначеЕсли ОсталосьРаспределить = СтрокаДокументаЗаказ.КоличествоУпаковок Тогда
			ОсталосьРаспределить=0;
			//видимо уже обработано
			//не будем ничего делать, остальные строки отменим
		ИначеЕсли ОсталосьРаспределить=0 Тогда
			ОтменитьСтроку(СтрокаДокументаЗаказ);
		Иначе //СтрокаСравнения.Количество < СтрокаДокументаЗаказ.КоличествоУпаковок и есть что распределять 
			//разобьем строку на 2 и отменим вторую
			НоваяСтрока=ТабЧастьЗаказ.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаДокументаЗаказ,,"Количество, КоличествоУпаковок");
			НоваяСтрока.КоличествоУпаковок=СтрокаДокументаЗаказ.КоличествоУпаковок-ОсталосьРаспределить;
			СтрокаДокументаЗаказ.КоличествоУпаковок=ОсталосьРаспределить;
			ОтменитьСтроку(НоваяСтрока);
			ПересчитатьКоличествоВСтроке(СтрокаДокументаЗаказ,ДокументЗаказа);
			ПересчитатьКоличествоВСтроке(НоваяСтрока,ДокументЗаказа);
			ОсталосьРаспределить=0;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьСтрокиЗаказа_БП30(СтрокиЗаказа,ТабЧастьЗаказ,СтрокаСравнения,ДокументЗаказа)
	
	ОсталосьРаспределить=СтрокаСравнения.Количество;
	ВсегоСтрок=СтрокиЗаказа.Количество();
	сч=0;
	Для каждого СтрокаДокументаЗаказ Из СтрокиЗаказа Цикл
		сч=сч+1;
		Если ОсталосьРаспределить > СтрокаДокументаЗаказ.Количество Тогда 
			Если сч=ВсегоСтрок Тогда  
				//решено заказать больше чем раньше и не осталось иных строк
				СтрокаДокументаЗаказ.Количество=ОсталосьРаспределить;
				ПересчитатьКоличествоВСтроке(СтрокаДокументаЗаказ,ДокументЗаказа);
			Иначе//остались еще строки, а эта строка уже под завязку
				ОсталосьРаспределить=СтрокаСравнения.Количество - СтрокаДокументаЗаказ.Количество;	
			КонецЕсли;
		ИначеЕсли ОсталосьРаспределить = СтрокаДокументаЗаказ.Количество Тогда
			ОсталосьРаспределить=0;
			//видимо уже обработано
			//не будем ничего делать, остальные строки отменим
		ИначеЕсли ОсталосьРаспределить=0 Тогда
			ОтменитьСтроку(СтрокаДокументаЗаказ);
		Иначе //СтрокаСравнения.Количество < СтрокаДокументаЗаказ.Количество и есть что распределять 
			//в этой строчке зануляем количество
			СтрокаДокументаЗаказ.Количество=ОсталосьРаспределить;
			ПересчитатьКоличествоВСтроке(СтрокаДокументаЗаказ,ДокументЗаказа);
			ОсталосьРаспределить=0;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьСтроку(СтрокаЗаказаПоставщику)
	Если МодульОбъекта().ИмяКонфигурации1С = "УФ_УТ" Тогда 
		СтрокаЗаказаПоставщику.Отменено = истина;
		СтрокаЗаказаПоставщику.ПричинаОтмены = МодульОбъекта().ПолучитьКонстантуEDI("ПричинаОтменыЗаказаПоставщикуПоУмолчанию");
	Иначе //для других конфигураций
		СтрокаЗаказаПоставщику.Количество=0;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПересчитатьКоличествоВСтроке(СтрокаЗаказаПоставщику,Документ)
	
	Если МодульОбъекта().ИмяКонфигурации1С = "УФ_УТ" Тогда 
		Если Не ЗначениеЗаполнено(СтрокаЗаказаПоставщику.Упаковка) Тогда 
			СтрокаЗаказаПоставщику.Количество			= СтрокаЗаказаПоставщику.КоличествоУпаковок;//базовая единица
		иначе
			СтрокаЗаказаПоставщику.Количество			= СтрокаЗаказаПоставщику.КоличествоУпаковок*СтрокаЗаказаПоставщику.Упаковка.Коэффициент;//в упаковках
		КонецЕсли;
		флСуммаВключаетНДС=Документ.ЦенаВключаетНДС;
		Выполнить("СтрокаЗаказаПоставщику.СуммаНДС = Ценообразование.РассчитатьСуммуНДС(СтрокаЗаказаПоставщику.Сумма, СтрокаЗаказаПоставщику.СтавкаНДС, флСуммаВключаетНДС)");
		Выполнить("Ценообразование.ПересчитатьСуммыВСтроке(СтрокаЗаказаПоставщику,ложь,ложь,ложь,флСуммаВключаетНДС)");
		
		
	ИначеЕсли МодульОбъекта().ИмяКонфигурации1С = "УФ_БП" Тогда	
		МодульОбъекта().ПересчитатьСтрокуДокумента(СтрокаЗаказаПоставщику,Документ);
	иначе
		//пересчет для других конфигураций
	КонецЕсли;
КонецПроцедуры // ПересчитатьКоличествоУТ11()

&НаКлиенте
Процедура Отклонить(Команда)
	
	ТекстВопроса ="Заказ будет отменен целиком, продолжить?";
	КнопкиВопроса=новый СписокЗначений;
	КнопкиВопроса.Добавить("Отправить отмену заказа!");
	КнопкиВопроса.Добавить("Я еще подумаю");
	ДопПараметрДляПередачиВОбработчик=Неопределено;
	РезультатВопроса = Неопределено;
	
	Если Параметры.МодальностьЗапрещена Тогда
		Выполнить("ПоказатьВопрос(Новый ОписаниеОповещения(""ОбработчикСогласияПолнойОтменыЗаказа"", ЭтаФорма, ДопПараметрДляПередачиВОбработчик), ТекстВопроса, КнопкиВопроса,,,""Контур.EDI"")");
	Иначе
		РезультатВопроса = Вопрос(ТекстВопроса, КнопкиВопроса,,,"Контур.EDI");
		ОбработчикСогласияПолнойОтменыЗаказа(РезультатВопроса,ДопПараметрДляПередачиВОбработчик);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриНажатииКнопки(ИмяКоманды)
	
	ПараметрыСравнения = Новый Структура();
	ПараметрыСравнения.Вставить("Заказ",Заказ);
	ПараметрыСравнения.Вставить("ТаблицаСравнения",РеквизитФормыВЗначение("ТаблицаСравнения"));
	ПараметрыСравнения.Вставить("НеобходимоИзменитьДокумент",НеобходимоИзменитьДокумент);
	
	МодульОбъекта().ОбработкаСобытияПодключаемогоМодуля("ПриНажатииКнопки",, Новый Структура("ИмяФормы,ИмяКнопки,Параметры", "ФормаСервис_ОбработкаУточненногоЗаказа", ИмяКоманды, ПараметрыСравнения));

КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСогласияПолнойОтменыЗаказа(РешениеПользователя,ДопПараметр=Неопределено) Экспорт
	
	Если РешениеПользователя="Отправить отмену заказа!" Тогда
		РезультатОтмены = ОтменитьЗаказСервер();
		ЭтаФорма.Закрыть();
	КонецЕсли;
	
КонецПроцедуры // ОбработчикСогласияПолнойОтменыЗаказа()

&НаСервере
Функция ОтменитьЗаказСервер()
	
	ПриНажатииКнопки(Элементы.ФормаОтклонить);
	
	ПараметрыПодготовкиСообщения = Новый Структура();
	ПараметрыПодготовкиСообщения.Вставить("Статус","Отменить");
	Сообщение = МодульОбъекта().ПодготовитьИсходящееСообщение("ORDERS", Заказ, ПараметрыПодготовкиСообщения);
	
	//не хватает ссылки на исходное сообщение
	//пока протяем ее из НайтиСообщениеДокумента
	СуществующееСообщение = МодульОбъекта().НайтиСообщениеДокумента(Заказ,"ORDERS","Исходящее");
	
	Сообщение.Вставить("ПереотправляемоеСообщениеСсылка",СуществующееСообщение);
	ПараметрыОтправки = Новый Структура("ОтправитьСообщениеИзФормы,Сообщение",Истина,Сообщение);
	
	МодульОбъекта().ОтправитьСообщение("ORDERS",Заказ,ПараметрыОтправки);
	
	//а что в этот момент происходит с ORDRSP от поставщика? По идее его надо аннулировать.
	//ВходящийORDRSPСсылка	= МодульОбъекта().НайтиСообщениеДокумента(Заказ,"ORDRSP","Входящее");
	ОбъектСообщенияORDRSP	= МодульОбъекта().ПолучитьОбъектСообщения(Параметры.СообщениеСсылка);
	ОбъектСообщенияORDRSP.ТипСообщения = "#ORDRSP";
	ОбъектСообщенияORDRSP.Архив = истина;
	МодульОбъекта().СохранитьОбъектСообщения(ОбъектСообщенияORDRSP);//или флаг "Отклонен"?
	
	Возврат Истина;
	
КонецФункции // ОтменитьЗаказСервер()


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НужноПеревыставитьЗаказ = Ложь;
    ЕстьДобавленныеСтроки = Ложь;

	Параметры.МодальностьЗапрещена=МодульОбъекта().МодальностьЗапрещена();
    Заказ = Параметры.Документ;
	ОтклонятьОтветыНаЗаказСДобавленнымТоваром = МодульОбъекта().ПолучитьКонстантуEDI("ОтклонятьОтветыНаЗаказСДобавленнымТоваром");


	ИсходящийЗаказ			= МодульОбъекта().ПрочитатьСообщение(,Параметры.Документ,"ORDERS","Исходящее");
	ВходящийОтветНаЗаказ	= МодульОбъекта().ПрочитатьСообщение(,Параметры.Документ,"ORDRSP","Входящее");
	МодульОбъекта().КонвертироватьТабличнуюЧастьСообщенияEDIв1С(ВходящийОтветНаЗаказ,	"Товары");
		
	СтруктураТаблицы1 = МодульОбъекта().ПолучитьСтруктуруТаблицыТоваров();
	СтруктураТаблицы1.Вид			= "Сообщение";
	СтруктураТаблицы1.ТипСообщения	= "ORDERS";
	СтруктураТаблицы1.Товары		= ИсходящийЗаказ.Товары;
	
	СтруктураТаблицы2 = МодульОбъекта().ПолучитьСтруктуруТаблицыТоваров();
	СтруктураТаблицы2.Вид			= "Сообщение";
	СтруктураТаблицы2.ТипСообщения	= "ORDRSP";
	СтруктураТаблицы2.Товары		= ВходящийОтветНаЗаказ.Товары;
	
	СравниваемыеПоля = Новый СписокЗначений;
	СравниваемыеПоля.Добавить("Количество");
	СравниваемыеПоля.Добавить("ЦенаБезНДС");
	СравниваемыеПоля.Добавить("ЦенаСНДС");
	
	РезультатСравнения = МодульОбъекта().СравнитьТаблицыТоваров(СтруктураТаблицы1,СтруктураТаблицы2,СравниваемыеПоля);
		
	Для Каждого Стр Из РезультатСравнения.ТаблицаСравнения Цикл
		
		НоваяСтрока = ТаблицаСравнения.Добавить();
		
		НоваяСтрока.Номенклатура			= Стр.Номенклатура;
		НоваяСтрока.КоличествоЗаказали		= Стр.Количество1;
		НоваяСтрока.КоличествоПодтвердили	= Стр.Количество2;
		НоваяСтрока.ЦенаБезНДСЗаказали		= Стр.ЦенаБезНДС1;
		НоваяСтрока.ЦенаБезНДСПодтвердили	= Стр.ЦенаБезНДС2;
		НоваяСтрока.ЦенаСНДСЗаказали		= Стр.ЦенаСНДС1;
		НоваяСтрока.ЦенаСНДСПодтвердили		= Стр.ЦенаСНДС2;
		
		НоваяСтрока.Количество = Стр.Количество2;
		
	КонецЦикла;
	
	//проверим добавление
	Для каждого Стр Из ТаблицаСравнения Цикл
		Если (Стр.КоличествоЗаказали = 0) ИЛИ (Стр.КоличествоПодтвердили > Стр.КоличествоЗаказали) Тогда
			ЕстьДобавленныеСтроки = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если ОтклонятьОтветыНаЗаказСДобавленнымТоваром = Истина И ЕстьДобавленныеСтроки Тогда
		Элементы.ФормаПринять.КнопкаПоУмолчанию = Ложь;
		Элементы.ФормаПринять.Доступность = Ложь;
		Элементы.ФормаОтклонить.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	//скрываем видимость надписей и таблицу сравнения полей шапки сообщений
    Если ТаблицаСравненияШапкаСообщения.Итог("ЕстьРасхождения") = 0 Тогда
		Элементы.ТаблицаСравненияШапкаСообщения.Видимость 	= Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(Параметры.ПараметрыАвтотестирования) Тогда
		ПодключитьОбработчикОжидания("ЗапуститьАвтотесты",0.1,Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСравненияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСравненияПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСравненияКоличествоПриИзменении(Элемент)
	
	НужноПеревыставитьЗаказ = Ложь;
	
	Для каждого Стр ИЗ ТаблицаСравнения Цикл
		Если НЕ Стр.Количество = Стр.КоличествоПодтвердили Тогда
			
			НужноПеревыставитьЗаказ = Истина;
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
	КнопкаПринять = Элементы.ФормаПринять;
	
	Если НужноПеревыставитьЗаказ Тогда
		КнопкаПринять.Заголовок = "Перевыставить заказ";
	Иначе
		КнопкаПринять.Заголовок = "Принять уточнение заказа";
	КонецЕсли;
	
КонецПроцедуры
