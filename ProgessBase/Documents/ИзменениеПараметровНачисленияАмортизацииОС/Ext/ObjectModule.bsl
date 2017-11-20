﻿Перем мУдалятьДвижения;

// Строки, хранят реквизиты имеющие смысл только для бух. учета и упр. соответственно
// в случае если документ не отражается в каком-то виде учета, делаются невидимыми

Перем мСтрокаРеквизитыБухУчета Экспорт; // (Регл)
Перем мСтрокаРеквизитыУпрУчета Экспорт; // (Упр)
Перем мСтрокаРеквизитыНалУчета Экспорт; // (Регл)

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

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для определенного вида учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета() Экспорт

	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр();
	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаРегл();

КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета()

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для управленческого учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр()

	мСтрокаРеквизитыУпрУчета =  "
								|ОС.СрокПолезногоИспользованияУУ,
								|ОС.СрокИспользованияДляВычисленияАмортизацииУУ,
								|ОС.ОбъемПродукцииРаботУУ,
								|ОС.ОбъемПродукцииРаботДляВычисленияАмортизацииУУ,
								|ОС.СтоимостьДляВычисленияАмортизацииУУ,
								|ОС.КоэффициентАмортизацииУУ,
								|ОС.КоэффициентУскоренияУУ
								|";

КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр()

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для регламентированного учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаРегл()

	мСтрокаРеквизитыБухУчета =  "
								|ОС.СрокПолезногоИспользованияБУ,
								|ОС.СрокИспользованияДляВычисленияАмортизацииБУ,
								|ОС.ОбъемПродукцииРаботБУ,
								|ОС.ОбъемПродукцииРаботДляВычисленияАмортизацииБУ,
								|ОС.СтоимостьДляВычисленияАмортизацииБУ,
								|ОС.КоэффициентАмортизацииБУ,
								|ОС.КоэффициентУскоренияБУ
								|";
	мСтрокаРеквизитыНалУчета =  "ОС.СрокПолезногоИспользованияНУ,
								|ОС.ИзменятьПараметрыНачисленияПоБазовойСтоимостиНУ,
								|ОС.НачислятьПоБазовойСтоимости,
								|ОС.НакопленнаяАмортизацияНУ,
								|ОС.НакопленныйФактическийСрокИспользованияНУ
								|";

КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаРегл()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА
// Проверяет правильность заполнения регл. реквизитов шапки
//
Процедура ПроверитьЗаполнениеШапкиРегл(СтруктураШапкиДокумента, Отказ, Заголовок)
	Если (НЕ СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете) И (НЕ СтруктураШапкиДокумента.ОтражатьВНалоговомУчете) Тогда
		Возврат;
	КонецЕсли;
	
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей 	= Новый Структура;
	СтруктураОбязательныхПолей.Вставить("Организация");
	СтруктураОбязательныхПолей.Вставить("СобытиеРегл");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
	// Проверим чем заполнено событие
	ПредставлениеРеквизита = ЭтотОбъект.Метаданные().Реквизиты.СобытиеРегл.Представление();
	УправлениеВнеоборотнымиАктивами.ПроверкаЗаполненияСобытий(СтруктураШапкиДокумента.СобытиеРегл.ВидСобытияОС,
							  Перечисления.ВидыСобытийОС.Прочее,
							  ПредставлениеРеквизита,Отказ);

КонецПроцедуры

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение, не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента,Отказ, Заголовок)
	
	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ОбщегоНазначения.ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок,Истина);
	
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей 	= Новый Структура;
	СтруктураОбязательныхПолей.Вставить("Событие");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
	ПроверитьЗаполнениеШапкиРегл(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Проверим чем заполнено событие
	ПредставлениеРеквизита = ЭтотОбъект.Метаданные().Реквизиты.Событие.Представление();
	УправлениеВнеоборотнымиАктивами.ПроверкаЗаполненияСобытий(СтруктураШапкиДокумента.Событие.ВидСобытияОС,
							  Перечисления.ВидыСобытийОС.Прочее,
							  ПредставлениеРеквизита,Отказ);
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - структура, содержащая реквизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиОС(Отказ, Заголовок)
	
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ОсновноеСредство");
	
	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ОС", СтруктураОбязательныхПолей, Отказ, Заголовок);
	
	Для Каждого СтрокаТЧ Из ОС Цикл
		Если ОтражатьВУправленческомУчете Тогда
			СтруктПараметров 	= УправлениеВнеоборотнымиАктивами.ПолучитьАтрибутыСостоянияОС(СтрокаТЧ.ОсновноеСредство,Перечисления.СостоянияОС.СнятоСУчета);
			Если НЕ (СтруктПараметров["Дата"] = Дата(1,1,1)) Тогда
				ОбщегоНазначения.СообщитьОбОшибке("Упр. учет: Основное средство """ + СтрокаТЧ.ОсновноеСредство + """ в строке № " + СтрокаТЧ.НомерСтроки + " снято с учета!", Отказ, Заголовок);
			КонецЕсли;
		КонецЕсли;
		Если ОтражатьВБухгалтерскомУчете Тогда
			СтруктПараметров = УправлениеВнеоборотнымиАктивами.ПолучитьАтрибутыСостоянияОС(СтрокаТЧ.ОсновноеСредство,Перечисления.СостоянияОС.СнятоСУчета,Ложь,Организация);
			Если НЕ (СтруктПараметров["Дата"] = Дата(1,1,1)) Тогда
				ОбщегоНазначения.СообщитьОбОшибке("Упр. учет: Основное средство """ + СтрокаТЧ.ОсновноеСредство + """ в строке № " + СтрокаТЧ.НомерСтроки + " снято с учета!", Отказ, Заголовок);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

Процедура ДвиженияПоРегистрамУпр(СтруктураШапкиДокумента, ТаблицаПоОС)
	
	ДатаДок = Дата;
	Если СтруктураШапкиДокумента.ОтражатьВУправленческомУчете Тогда
		
		АмортизацияУУ = Движения.ПараметрыАмортизацииОС;
		СобытиеОС     = Движения.СобытияОС;

		Для Каждого СтрокаТЧ из ТаблицаПоОС Цикл
			СтрокаДвижений = АмортизацияУУ.Добавить();
			
			СтрокаДвижений.Период           = ДатаДок;
			СтрокаДвижений.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
			
			СтрокаДвижений.СрокПолезногоИспользования                  = СтрокаТЧ.СрокПолезногоИспользованияУУ;
			СтрокаДвижений.ОбъемПродукцииРабот                         = СтрокаТЧ.ОбъемПродукцииРаботУУ;
			СтрокаДвижений.СрокИспользованияДляВычисленияАмортизации   = СтрокаТЧ.СрокИспользованияДляВычисленияАмортизацииУУ;
			СтрокаДвижений.СтоимостьДляВычисленияАмортизации           = СтрокаТЧ.СтоимостьДляВычисленияАмортизацииУУ;
			СтрокаДвижений.ОбъемПродукцииРаботДляВычисленияАмортизации = СтрокаТЧ.ОбъемПродукцииРаботДляВычисленияАмортизацииУУ;
			СтрокаДвижений.КоэффициентАмортизации                      = СтрокаТЧ.КоэффициентАмортизацииУУ;
			СтрокаДвижений.КоэффициентУскорения                        = СтрокаТЧ.КоэффициентУскоренияУУ;
			СтрокаДвижений.ПрименитьВТекущемМесяце                     = СтруктураШапкиДокумента.ПрименятьПараметрыВТекущемМесяце;
			
			Движение = СобытиеОС.Добавить();
			Движение.Период            = ДатаДок;
			Движение.ОсновноеСредство  = СтрокаТЧ.ОсновноеСредство;
			Движение.Событие           = СтруктураШапкиДокумента.Событие;
			Движение.НазваниеДокумента = Метаданные().Представление();
			Движение.НомерДокумента    = Номер;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрамУпр

Процедура ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, ТаблицаПоОС)
	
	ДатаДок = Дата;
	Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда
		АмортизацияБУ = Движения.ПараметрыАмортизацииОСБухгалтерскийУчет;
		СобытиеОСБух  = Движения.СобытияОСОрганизаций;

		Для Каждого СтрокаТЧ из ТаблицаПоОС Цикл
			СтрокаДвижений = АмортизацияБУ.Добавить();
			
			СтрокаДвижений.Период           = ДатаДок;
			СтрокаДвижений.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
			СтрокаДвижений.Организация      = СтруктураШапкиДокумента.Организация;
			
			СтрокаДвижений.СрокПолезногоИспользования                  = СтрокаТЧ.СрокПолезногоИспользованияБУ;
			СтрокаДвижений.ОбъемПродукцииРабот                         = СтрокаТЧ.ОбъемПродукцииРаботБУ;
			СтрокаДвижений.СрокИспользованияДляВычисленияАмортизации   = СтрокаТЧ.СрокИспользованияДляВычисленияАмортизацииБУ;
			СтрокаДвижений.СтоимостьДляВычисленияАмортизации            = СтрокаТЧ.СтоимостьДляВычисленияАмортизацииБУ;
			СтрокаДвижений.ОбъемПродукцииРаботДляВычисленияАмортизации = СтрокаТЧ.ОбъемПродукцииРаботДляВычисленияАмортизацииБУ;
			СтрокаДвижений.КоэффициентАмортизации                      = СтрокаТЧ.КоэффициентАмортизацииБУ;
			СтрокаДвижений.КоэффициентУскорения                        = СтрокаТЧ.КоэффициентУскоренияБУ;
			
			Движение = СобытиеОСБух.Добавить();
			
			Движение.Период             = ДатаДок;
			Движение.ОсновноеСредство   = СтрокаТЧ.ОсновноеСредство;
			Движение.Организация        = СтруктураШапкиДокумента.Организация;
			Движение.Событие            = СтруктураШапкиДокумента.Событие;
			Движение.НазваниеДокумента 	= Метаданные().Представление();
			Движение.НомерДокумента    	= Номер;

			
		КонецЦикла;
	КонецЕсли;
	
	
	Если СтруктураШапкиДокумента.ОтражатьВНалоговомУчете Тогда
		ПараметрыАмортизацииНУ = Движения.ПараметрыАмортизацииОСНалоговыйУчет;
		АмортизацияПоБС = Движения.НачислениеАмортизацииОСПоБазовойСтоимостиНалоговыйУчет;
		Для Каждого СтрокаТЧ из ТаблицаПоОС Цикл
			СтрокаДвижений = ПараметрыАмортизацииНУ.Добавить();
			СтрокаДвижений.Период           = ДатаДок;
			СтрокаДвижений.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
			СтрокаДвижений.Организация      = СтруктураШапкиДокумента.Организация;
			СтрокаДвижений.СрокПолезногоИспользования   = СтрокаТЧ.СрокПолезногоИспользованияНУ;
            СтрокаДвижений.ПРДляВычисленияАмортизации   = СтрокаТЧ.ПРДляВычисленияАмортизации;
			
			Если СтрокаТЧ.ИзменятьПараметрыНачисленияПоБазовойСтоимостиНУ тогда
				СтрокаДвижений = АмортизацияПоБС.Добавить();
				СтрокаДвижений.Период           = ДатаДок;
				СтрокаДвижений.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
				СтрокаДвижений.Организация      = СтруктураШапкиДокумента.Организация;
				
				СтрокаДвижений.ПризнакНачисленияПоБазовойСтоимости	= СтрокаТЧ.НачислятьПоБазовойСтоимости;
				СтрокаДвижений.СуммаНакопленнойАмортизации			= СтрокаТЧ.НакопленнаяАмортизацияНУ;
				СтрокаДвижений.ФактическийСрокПолезногоИспользования= СтрокаТЧ.НакопленныйФактическийСрокИспользованияНУ;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры // ДвиженияПоРегистрамРегл

// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС);
	
	ДвиженияПоРегистрамУпр(СтруктураШапкиДокумента, ТаблицаПоОС);
	ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, ТаблицаПоОС);
	
КонецПроцедуры // ДвиженияПоРегистрам

Процедура ДополнитьСтруктуруПолейТабличнойЧастиОСУпр(СтруктураШапкиДокумента, СтруктураПолей)
	Если СтруктураШапкиДокумента.ОтражатьВУправленческомУчете тогда
		СтруктураПолей.Вставить("СрокПолезногоИспользованияУУ"                 , "СрокПолезногоИспользованияУУ");
		СтруктураПолей.Вставить("СрокИспользованияДляВычисленияАмортизацииУУ"  , "СрокИспользованияДляВычисленияАмортизацииУУ");
		СтруктураПолей.Вставить("ОбъемПродукцииРаботУУ"                        , "ОбъемПродукцииРаботУУ");
		СтруктураПолей.Вставить("ОбъемПродукцииРаботДляВычисленияАмортизацииУУ", "ОбъемПродукцииРаботДляВычисленияАмортизацииУУ");
		СтруктураПолей.Вставить("СтоимостьДляВычисленияАмортизацииУУ"           , "СтоимостьДляВычисленияАмортизацииУУ");
		СтруктураПолей.Вставить("КоэффициентАмортизацииУУ"                     , "КоэффициентАмортизацииУУ");
		СтруктураПолей.Вставить("КоэффициентУскоренияУУ"                       , "КоэффициентУскоренияУУ");
	Конецесли;
КонецПроцедуры

Процедура ДополнитьСтруктуруПолейТабличнойЧастиОСРегл(СтруктураШапкиДокумента, СтруктураПолей)
	Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете тогда
		СтруктураПолей.Вставить("СрокПолезногоИспользованияБУ"                 , "СрокПолезногоИспользованияБУ");
		СтруктураПолей.Вставить("СрокИспользованияДляВычисленияАмортизацииБУ"  , "СрокИспользованияДляВычисленияАмортизацииБУ");
		СтруктураПолей.Вставить("ОбъемПродукцииРаботБУ"                        , "ОбъемПродукцииРаботБУ");
		СтруктураПолей.Вставить("ОбъемПродукцииРаботДляВычисленияАмортизацииБУ", "ОбъемПродукцииРаботДляВычисленияАмортизацииБУ");
		СтруктураПолей.Вставить("СтоимостьДляВычисленияАмортизацииБУ"           , "СтоимостьДляВычисленияАмортизацииБУ");
		СтруктураПолей.Вставить("КоэффициентАмортизацииБУ"                     , "КоэффициентАмортизацииБУ");
		СтруктураПолей.Вставить("КоэффициентУскоренияБУ"                       , "КоэффициентУскоренияБУ");
	Конецесли;
	Если СтруктураШапкиДокумента.ОтражатьВНалоговомУчете тогда
		СтруктураПолей.Вставить("СрокПолезногоИспользованияНУ"					,"СрокПолезногоИспользованияНУ");
		СтруктураПолей.Вставить("ИзменятьПараметрыНачисленияПоБазовойСтоимостиНУ", "ИзменятьПараметрыНачисленияПоБазовойСтоимостиНУ");
		СтруктураПолей.Вставить("НачислятьПоБазовойСтоимости"					, "НачислятьПоБазовойСтоимости");
		СтруктураПолей.Вставить("НакопленнаяАмортизацияНУ"						, "НакопленнаяАмортизацияНУ");
		СтруктураПолей.Вставить("НакопленныйФактическийСрокИспользованияНУ"		, "НакопленныйФактическийСрокИспользованияНУ");
		СтруктураПолей.Вставить("ПРДляВычисленияАмортизации"                    , "ПРДляВычисленияАмортизации");
	КонецЕсли;
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
// Процедура - обработчик события "Обработка проведения" 
//
Процедура ОбработкаПроведения(Отказ)
	
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	Заголовок = "";
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	//начало изменений БП 07 
	СтруктураШапкиДокумента.ОтражатьВУправленческомУчете = Не ПараметрыСеанса.НеведетсяУПРУчетВЧастиЗатратИОС и ОтражатьВУправленческомУчете;
	//конец изменений БП 07	 
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Сформируем структуру табличной части
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("ОсновноеСредство" , "ОсновноеСредство");
	
	ДополнитьСтруктуруПолейТабличнойЧастиОСУпр (СтруктураШапкиДокумента,СтруктураПолей);
	ДополнитьСтруктуруПолейТабличнойЧастиОСРегл(СтруктураШапкиДокумента,СтруктураПолей);
	
	РезультатЗапросаПоОС = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ОС", СтруктураПолей);
	ТаблицаПоОС          = РезультатЗапросаПоОС.Выгрузить();
	
	ПроверитьЗаполнениеТабличнойЧастиОС(Отказ, Заголовок);
	
	УправлениеВнеоборотнымиАктивами.ПроверитьДубли(ТаблицаПоОС, "Основные средства", "ОсновноеСредство", "Основное средство", Отказ, Заголовок);	
	
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
    //начало изменений БП 07 
	Если ПараметрыСеанса.НеведетсяУПРУчетВЧастиЗатратИОС Тогда
		Событие = СобытиеРегл;
	КонецЕсли;	
	//конец изменений БП 07	  
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью



