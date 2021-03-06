﻿Перем мУдалятьДвижения Экспорт;

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
		Предупреждение(НСтр("ru = 'Документ можно распечатать только после его записи'"));
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение(НСтр("ru = Недостаточно полномочий для печати непроведенного документа!'"));
		Возврат;
	КонецЕсли;
	
	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Получить экземпляр документа на печать
	Если ИмяМакета = "Приказ" Тогда
		//ТабДокумент = ПечатьПриказа(); //breakpoint Островерхий, 15.11.2016 11:40:51  
	ИначеЕсли ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда
		
		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
	КонецЕсли;
	
	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);
	
КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	СтруктПечатныхФорм = Новый Структура;
	
	Возврат СтруктПечатныхФорм;
	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	ПроверкаРеквизитов(Отказ, Заголовок, СтруктураШапкиДокумента);
	
	СтруктураТаблицДвижений = ПолучитьСтруктуруТаблицДвиженийРегистров(СтруктураШапкиДокумента);
	
	// Добавим дополнительные поля в структуру шапки документа.
	ПодготовитьСтруктуруШапкиДокумента(
		СтруктураШапкиДокумента,
		Отказ, 
		Заголовок
		);
		
	СформироватьТаблицыДвижений(СтруктураШапкиДокумента,СтруктураТаблицДвижений);	
		
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, СтруктураТаблицДвижений, Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры

// Функция формирует структуру таблиц движений регистров.
//
// Параметры
//  СтруктураШапкиДокумента – Структура - Реквизиты документа "Расчет себестоимости"
//
// Возвращаемое значение:
//   Структура – Структура таблиц движений регистров
//
Функция ПолучитьСтруктуруТаблицДвиженийРегистров(
	СтруктураШапкиДокумента
	)
	
	ПЦ_ИсключенияУсловииДополнительногоИзмененияЦены	  		 = Движения.ПЦ_ИсключенияУсловииДополнительногоИзмененияЦены;
	
	
	СтруктураТаблицДвижений = Новый Структура;
	СтруктураТаблицДвижений.Вставить("ТаблицаДвиженийИсключений",    ПЦ_ИсключенияУсловииДополнительногоИзмененияЦены.Выгрузить());
	
	Возврат СтруктураТаблицДвижений;
	
КонецФункции // ПолучитьСтруктуруТаблицДвиженийРегистров()

Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, СтруктураТаблицДвижений, Отказ, Заголовок)

	ПЦ_ИсключенияУсловииДополнительногоИзмененияЦены(РежимПроведения, СтруктураШапкиДокумента, СтруктураТаблицДвижений, Отказ);	
	
КонецПроцедуры

Процедура ПЦ_ИсключенияУсловииДополнительногоИзмененияЦены(РежимПроведения, СтруктураШапкиДокумента, СтруктураТаблицДвижений, Отказ)

	Если СтруктураТаблицДвижений.ТаблицаДвиженийИсключений.Количество()=0 Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		// регистр ПЦ_ИсключенияУсловииДополнительногоИзмененияЦены
		Движения.ПЦ_ИсключенияУсловииДополнительногоИзмененияЦены.Записывать = Истина;
		Движения.ПЦ_ИсключенияУсловииДополнительногоИзмененияЦены.Очистить();
		
		Для Каждого ТекСтрокаИсключений Из СтруктураТаблицДвижений.ТаблицаДвиженийИсключений Цикл
			Движение = Движения.ПЦ_ИсключенияУсловииДополнительногоИзмененияЦены.Добавить();
			ЗаполнитьЗначенияСвойств(Движение,ТекСтрокаИсключений);
		КонецЦикла;
		
	КонецЕсли;		

КонецПроцедуры

Процедура ПроверкаРеквизитов(Отказ, Заголовок, СтруктураШапкиДокумента) Экспорт
	
			
КонецПроцедуры // ПроверкаРеквизитов()

// Процедура формирует структуру шапки документа и дополнительных полей.
//
// Параметры
//  СтруктураШапкиДокумента – Структура - Реквизиты документа "Расчет себестоимости"
//	Отказ - Булево - Признак отказа от проведения документа
//	Заголовок - Строка - Текст представления документа 
//
//
Процедура ПодготовитьСтруктуруШапкиДокумента(
	СтруктураШапкиДокумента, 
	Отказ, 
	Заголовок
	)  Экспорт
	
	СтруктураШапкиДокумента.ПериодДействияПо = КонецДня(СтруктураШапкиДокумента.ПериодДействияПо);
	
КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента()

Процедура СформироватьТаблицыДвижений(СтруктураШапкиДокумента, СтруктураТаблицДвижений)

	//Условия
	Для Каждого ТекСтрока Из Условия Цикл
		тНоваяСтрока = СтруктураТаблицДвижений.ТаблицаДвиженийИсключений.Добавить();
		ЗаполнитьЗначенияСвойств(тНоваяСтрока,ТекСтрока);
	КонецЦикла;
	
	СтруктураТаблицДвижений.ТаблицаДвиженийИсключений.ЗаполнитьЗначения(СтруктураШапкиДокумента.ПериодДействияС, "ПериодДействияС"); 
	СтруктураТаблицДвижений.ТаблицаДвиженийИсключений.ЗаполнитьЗначения(СтруктураШапкиДокумента.ПериодДействияПо, "ПериодДействияПо"); 
	СтруктураТаблицДвижений.ТаблицаДвиженийИсключений.ЗаполнитьЗначения(СтруктураШапкиДокумента.Контрагент, "Контрагент"); 
	СтруктураТаблицДвижений.ТаблицаДвиженийИсключений.ЗаполнитьЗначения(Истина, "Активность");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("ПериодДействияС");
	ПроверяемыеРеквизиты.Добавить("ПериодДействияПо");
	ПроверяемыеРеквизиты.Добавить("Контрагент");

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	 
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПЦ_УстановкаУсловийДополнительногоИзмененияЦены") Тогда
		// Заполнение шапки
		Комментарий = ДанныеЗаполнения.Комментарий;
		Контрагент = ДанныеЗаполнения.Контрагент;
		Ответственный = ДанныеЗаполнения.Ответственный;
		ПериодДействияПо = ДанныеЗаполнения.ПериодДействияПо;
		ПериодДействияС = ДанныеЗаполнения.ПериодДействияС;
		Для Каждого ТекСтрокаУсловия Из ДанныеЗаполнения.Условия Цикл
			НоваяСтрока = Условия.Добавить();
			НоваяСтрока.АдресПоставки = ТекСтрокаУсловия.АдресПоставки;
			НоваяСтрока.Брендообъем = ТекСтрокаУсловия.Брендообъем;
			НоваяСтрока.ПроектГП = ТекСтрокаУсловия.ПроектГП;
			НоваяСтрока.ТоварнаяКатегория = ТекСтрокаУсловия.ТоварнаяКатегория;
			НоваяСтрока.Условие = ТекСтрокаУсловия.Условие;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры
