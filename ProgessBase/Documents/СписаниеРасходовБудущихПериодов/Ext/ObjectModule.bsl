﻿Перем мУдалятьДвижения;
Перем мВалютаРегламентированногоУчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

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
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Организация, ПериодРегистрации");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, Отказ)
	
	мПроводкиБУ   = Движения.Хозрасчетный;
	мПроводкиНУ   = Движения.Налоговый;

	Массив = Новый Массив;
	Массив.Добавить(Перечисления.ВидыРБП.Прочие);
	Массив.Добавить(Перечисления.ВидыРБП.ОсвоениеПриродныхРесурсов);
	Массив.Добавить(Перечисления.ВидыРБП.ОтрицательныйРезультатОтРеализацииАмортизируемогоИмущества);
	
	ЗаписьРасчетаРБП = Движения.РасчетСписанияРБП.Выгрузить();
	ЗаписьРасчетаРБП.Очистить();
	
	Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда
		БухгалтерскийУчет.РасчетИСписаниеРБП(СтруктураШапкиДокумента, Отказ, Массив, "БУ", мПроводкиБУ, ЗаписьРасчетаРБП);
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.ОтражатьВНалоговомУчете Тогда
		БухгалтерскийУчет.РасчетИСписаниеРБП(СтруктураШапкиДокумента, Отказ, Массив, "НУ", мПроводкиНУ, ЗаписьРасчетаРБП);
	КонецЕсли;
	

	Если СтруктураШапкиДокумента.ОтражатьВНалоговомУчетеУСН Тогда

		НалоговыйУчетУСН.ОтразитьВУСН(Ссылка, "СписаниеРБП",,0);
			
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрам()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	мНачДата = НачалоМесяца(ПериодРегистрации);
	мКонДата  = КонецМесяца(ПериодРегистрации);
	
	мНачГраница = Новый Граница(мНачДата, ВидГраницы.Включая);
	мКонГраница = Новый Граница(мКонДата, ВидГраницы.Включая);
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = УправлениеЗапасами.СформироватьДеревоПолейЗапросаПоШапке();
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы", "ВалютаРегламентированногоУчета", "ВалютаДокумента");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);
	мПрименениеУСН = НалоговыйУчетУСН.ПрименениеУСН(СтруктураШапкиДокумента.Организация, мКонДата);
	
	СтруктураШапкиДокумента.Вставить("мНачДата",    мНачДата);
	СтруктураШапкиДокумента.Вставить("мКонДата",    мКонДата);
	СтруктураШапкиДокумента.Вставить("мНачГраница", мНачГраница);
	СтруктураШапкиДокумента.Вставить("мКонГраница", мКонГраница);
	СтруктураШапкиДокумента.Вставить("мПрименениеУСН",мПрименениеУСН);
	
	Заголовок = "";
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, Отказ);
	КонецЕсли;
		

КонецПроцедуры // ОбработкаПроведения()

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
	
	БухгалтерскийУчет.ПечатьСправкиРасчета(Отчеты.СправкаРасчетСписаниеРБП, Новый Структура("Организация,Дата", Организация, Дата));
	
КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа.
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
 Возврат Новый Структура("РБП","Справка-расчет");
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли


мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

