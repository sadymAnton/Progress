﻿Перем мУдалятьДвижения;

Перем мВалютаРегламентированногоУчета Экспорт;

//Определение периода движений документа
Перем ДатаДвижений;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()


// Формирует движения по регистрам
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//  Режим 					  - режим проведения документа
//
Процедура ДвиженияПоРегистрам(РежимПроведения, Отказ, Заголовок, СтруктураКурсыВалют)

	СуммаУпр  =МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СуммаДокумента, СтруктураКурсыВалют.ВалютаДокумента,
					СтруктураКурсыВалют.ВалютаУпрУчета, 
					СтруктураКурсыВалют.ВалютаДокументаКурс,
					СтруктураКурсыВалют.ВалютаУпрУчетаКурс, 
					СтруктураКурсыВалют.ВалютаДокументаКратность,
					СтруктураКурсыВалют.ВалютаУпрУчетаКратность);
	
	Если Оплачено Тогда
		
		// По регистру "Денежные средства"
		НаборДвижений = Движения.ДенежныеСредства;	
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		
		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.БанковскийСчетКасса           	= СчетОрганизации;
		СтрокаДвижений.Организация 		   				= Организация;
		СтрокаДвижений.ВидДенежныхСредств 				= Перечисления.ВидыДенежныхСредств.Безналичные;
		СтрокаДвижений.Сумма                			= СуммаДокумента;
		СтрокаДвижений.СуммаУпр=СуммаУпр;
		
		НаборДвижений.мПериод            = ДатаДвижений;
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
		Движения.ДенежныеСредства.ВыполнитьРасход();
		
		// По регистру "Денежные средства к списанию"
		НаборДвижений = Движения.ДенежныеСредстваКСписанию;
		ТаблицаДвижений = НаборДвижений.Выгрузить();

		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.БанковскийСчетКасса           	= СчетОрганизации;
		СтрокаДвижений.Организация 		   				= Организация;
		СтрокаДвижений.ВидДенежныхСредств 				= Перечисления.ВидыДенежныхСредств.Безналичные;
		СтрокаДвижений.Сумма                			= СуммаДокумента;
		СтрокаДвижений.ДокументСписания                 = Ссылка;
		СтрокаДвижений.СтатьяДвиженияДенежныхСредств	= СтатьяДвиженияДенежныхСредств;
		
		НаборДвижений.мПериод            = ДатаДвижений;
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
		
		Движения.ДенежныеСредстваКСписанию.ВыполнитьРасход();
		
		// По регистру "Движения денежных средств"
		НаборДвижений = Движения.ДвиженияДенежныхСредств;
		
		// Получим таблицу значений, совпадающую со структурой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();
		
		СтрокаДДС=ТаблицаДвижений.Добавить();
		СтрокаДДС.ВидДенежныхСредств=Перечисления.ВидыДенежныхСредств.Безналичные;
		СтрокаДДС.ПриходРасход=Перечисления.ВидыДвиженийПриходРасход.Расход;
		СтрокаДДС.БанковскийСчетКасса=СчетОрганизации;
		СтрокаДДС.Организация=Организация;
		СтрокаДДС.ДокументДвижения=Ссылка;
		СтрокаДДС.СтатьяДвиженияДенежныхСредств=СтатьяДвиженияДенежныхСредств;
		
		СтрокаДДС.Сумма=СуммаДокумента;
		СтрокаДДС.СуммаУпр=СуммаУпр;
				
		НаборДвижений.мПериод            = ДатаДвижений;
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
		
		Движения.ДвиженияДенежныхСредств.ВыполнитьДвижения();
			
	КонецЕсли;	
	
	// По регистру "Денежные средства к списанию"
	НаборДвижений = Движения.ДенежныеСредстваКСписанию;
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();
	
	СтрокаДвижений = ТаблицаДвижений.Добавить();
	СтрокаДвижений.БанковскийСчетКасса           	= СчетОрганизации;
	СтрокаДвижений.Организация 		   				= Организация;
	СтрокаДвижений.ВидДенежныхСредств 				= Перечисления.ВидыДенежныхСредств.Безналичные;
	СтрокаДвижений.Сумма                			= СуммаДокумента;
	СтрокаДвижений.ДокументСписания                 = Ссылка;
	СтрокаДвижений.СтатьяДвиженияДенежныхСредств	= СтатьяДвиженияДенежныхСредств;
	
	НаборДвижений.мПериод            = ?(Оплачено,Мин(ДатаДвижений,Дата),Дата);
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
	
	Движения.ДенежныеСредстваКСписанию.ВыполнитьПриход();
	
	// По регистру "Денежные средства к получению"
	НаборДвижений = Движения.ДенежныеСредстваКПолучению;
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();
	
	СтрокаДвижений = ТаблицаДвижений.Добавить();
	СтрокаДвижений.БанковскийСчетКасса           	= Касса;
	СтрокаДвижений.Организация 		   				= Организация;
	СтрокаДвижений.ВидДенежныхСредств 				= Перечисления.ВидыДенежныхСредств.Наличные;
	СтрокаДвижений.Сумма                			= СуммаДокумента;
	СтрокаДвижений.СуммаУпр    						= СуммаУпр;
	СтрокаДвижений.ДокументПолучения	            = Ссылка;
	СтрокаДвижений.СтатьяДвиженияДенежныхСредств	= СтатьяДвиженияДенежныхСредств;
	
	НаборДвижений.мПериод            = Дата;
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
	
	Движения.ДенежныеСредстваКПолучению.ВыполнитьПриход();
	 	
КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ОбработкаПроведения(Отказ, Режим)
			
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	СтруктураОбязательныхПолейШапка=Новый Структура("Организация,СчетОрганизации,Касса,СуммаДокумента");
	
	Если Оплачено Тогда
		СтруктураОбязательныхПолейШапка.Вставить("ДатаОплаты","Не указана дата оплаты");
	КонецЕсли;
				
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейШапка, Отказ, Заголовок);
	
	Если ВыплатаЗаработнойПлаты.Итог("СуммаКВыплате") > СуммаДокумента Тогда
		
		 Сообщить("Сумма средств на выплату заработной платы превышает общую сумму по чеку!");
		 Отказ=Истина;
		 
	 КонецЕсли;
	 
	СтруктураГруппаВалют = Новый Структура;
	СтруктураГруппаВалют.Вставить("ВалютаУпрУчета",глЗначениеПеременной("ВалютаУправленческогоУчета").Код);
	СтруктураГруппаВалют.Вставить("ВалютаДокумента",ВалютаДокумента.Код);
	
	ДатаДвижений=?(Оплачено,УправлениеДенежнымиСредствами.ПолучитьДатуДвижений(Дата,ДатаОплаты),Дата);
	СтруктураКурсыВалют=УправлениеДенежнымиСредствами.ПолучитьКурсыДляГруппыВалют(СтруктураГруппаВалют,ДатаДвижений);
					
	// Движения по документу
	Если Не Отказ Тогда
		
		ДвиженияПоРегистрам(Режим, Отказ, Заголовок, СтруктураКурсыВалют);
		
	КонецЕсли; 
	
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры




мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

