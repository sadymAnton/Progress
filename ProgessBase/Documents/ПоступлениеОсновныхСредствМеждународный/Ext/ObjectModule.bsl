﻿Перем мУдалятьДвижения;

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
			Возврат;
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
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// is ЯннуровВФ нач 20141118 Контроль остатков по счету 08.03
	лЗапрос = Новый Запрос;
	лЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПоступлениеОсновныхСредствМеждународныйОсновныеСредства.КоррСчет КАК Счет,
	|	ПоступлениеОсновныхСредствМеждународныйОсновныеСредства.Субконто1Кт КАК Субконто1,
	|	СУММА(ПоступлениеОсновныхСредствМеждународныйОсновныеСредства.ПервоначальнаяСтоимость) КАК Сумма
	|ПОМЕСТИТЬ втПараметры
	|ИЗ
	|	Документ.ПоступлениеОсновныхСредствМеждународный.ОсновныеСредства КАК ПоступлениеОсновныхСредствМеждународныйОсновныеСредства
	|ГДЕ
	|	ПоступлениеОсновныхСредствМеждународныйОсновныеСредства.Ссылка = &Ссылка
	|	И ПоступлениеОсновныхСредствМеждународныйОсновныеСредства.КоррСчет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Международный.НезавершенноеСтроительство))
	|
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеОсновныхСредствМеждународныйОсновныеСредства.КоррСчет,
	|	ПоступлениеОсновныхСредствМеждународныйОсновныеСредства.Субконто1Кт
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет,
	|	Субконто1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МеждународныйОстатки.Счет КАК Счет,
	|	МеждународныйОстатки.Субконто1 КАК Субконто1,
	|	СУММА(МеждународныйОстатки.СуммаОстаток) КАК СуммаОстаток
	|ПОМЕСТИТЬ втОстатки
	|ИЗ
	|	РегистрБухгалтерии.Международный.Остатки(&ДатаСГраницей, Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Международный.НезавершенноеСтроительство)), , Организация = &Организация) КАК МеждународныйОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	МеждународныйОстатки.Счет,
	|	МеждународныйОстатки.Субконто1
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет,
	|	Субконто1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	втПараметры.Счет КАК Счет,
	|	втПараметры.Субконто1 КАК Субконто1,
	|	втПараметры.Сумма,
	|	ЕСТЬNULL(втОстатки.СуммаОстаток, 0) КАК СуммаОстаток
	|ИЗ
	|	втПараметры КАК втПараметры
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстатки КАК втОстатки
	|		ПО втПараметры.Счет = втОстатки.Счет
	|			И втПараметры.Субконто1 = втОстатки.Субконто1
	|ГДЕ
	|	втПараметры.Сумма > ЕСТЬNULL(втОстатки.СуммаОстаток, 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Счет,
	|	Субконто1
	|АВТОУПОРЯДОЧИВАНИЕ";
	лЗапрос.УстановитьПараметр("Ссылка", Ссылка);
	лЗапрос.УстановитьПараметр("Организация", Организация);
	лЗапрос.УстановитьПараметр("ДатаСГраницей", Новый Граница(КонецДня(Дата),ВидГраницы.Включая));
	лВыборка = лЗапрос.Выполнить().Выбрать();
	Пока лВыборка.Следующий() Цикл 
		Сообщить("Первоначальная стоимость больше остатка на счете "+лВыборка.Счет+" по <"+лВыборка.Субконто1+">: "+лВыборка.Сумма+"  > "+лВыборка.СуммаОстаток, СтатусСообщения.Внимание);
	КонецЦикла;
	// is ЯннуровВФ кон 20141118
	
	// is ЯннуровВФ нач 20140523 ЗР-0И-001239
	////начало изменений ДС МСФО 07.03.2014
	////добавим проверку, чтобы ОС не принимали к учету повторно
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	Док.ОсновноеСредство,
	//|	Док.НомерСтроки
	//|ИЗ
	//|	Документ.ПоступлениеОсновныхСредствМеждународный.ОсновныеСредства КАК Док
	//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСредстваМеждународныйУчет КАК РС
	//|		ПО Док.ОсновноеСредство = РС.ОсновноеСредство
	//|ГДЕ
	//|	Док.Ссылка = &Ссылка
	//|	И РС.Регистратор <> &Ссылка";
	//
	//Запрос.УстановитьПараметр("Ссылка", Ссылка);
	//Результат = Запрос.Выполнить();
	//
	//Выборка = Результат.Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	Сообщить("Основное средство [" + Выборка.ОсновноеСредство + "] (строка " + Выборка.НомерСтроки + ") уже принималось ранее к учету по МСФО!", СтатусСообщения.Внимание);
	//	Отказ = Истина;
	//КонецЦикла;
	////конец изменений ДС МСФО 07.03.2014 
	лЗапрос = Новый Запрос;
	лЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПоступлениеОсновныхСредствМеждународныйОсновныеСредства.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	Документ.ПоступлениеОсновныхСредствМеждународный.ОсновныеСредства КАК ПоступлениеОсновныхСредствМеждународныйОсновныеСредства
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(&Дата, Регистратор <> &Ссылка) КАК ОсновныеСредстваМеждународныйУчетСрезПоследних
	|		ПО ПоступлениеОсновныхСредствМеждународныйОсновныеСредства.ОсновноеСредство = ОсновныеСредстваМеждународныйУчетСрезПоследних.ОсновноеСредство
	|ГДЕ
	|	ПоступлениеОсновныхСредствМеждународныйОсновныеСредства.Ссылка = &Ссылка
	|	И ПоступлениеОсновныхСредствМеждународныйОсновныеСредства.ис_ПоПродлению = ЛОЖЬ
	|	И ВЫБОР
	|			КОГДА &Лизинг = ЛОЖЬ
	|				ТОГДА ОсновныеСредстваМеждународныйУчетСрезПоследних.ис_Лизинг = ЛОЖЬ
	|			КОГДА &Лизинг = ИСТИНА
	|				ТОГДА ПоступлениеОсновныхСредствМеждународныйОсновныеСредства.ис_ПоПродлению = ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОсновноеСредство
	|АВТОУПОРЯДОЧИВАНИЕ";
	лЗапрос.УстановитьПараметр("Ссылка", Ссылка);
	лЗапрос.УстановитьПараметр("Дата", Дата);
	лЗапрос.УстановитьПараметр("Лизинг", (ВидОперации=Перечисления.ДС_ВидыОперацийПоступлениеОС_МСФО.Лизинг));
	лВыборка = лЗапрос.Выполнить().Выбрать();
	Пока лВыборка.Следующий() Цикл 
		Отказ = Истина;
		Сообщить("Основное средство """+лВыборка.ОсновноеСредство+""" уже принималось ранее к учету по МСФО", СтатусСообщения.Внимание);
	КонецЦикла;
	// is ЯннуровВФ кон 20140523
	
	
	Для Каждого ТекСтрокаОсновныеСредства Из ОсновныеСредства Цикл
		Если ТекСтрокаОсновныеСредства.УчитыватьКакОС Тогда
			Если НЕ ЗначениеЗаполнено(ТекСтрокаОсновныеСредства.СчетСниженияСтоимости) Тогда
				Сообщить("Не заполнен реквизит: Счет снижения стоимости");
				Отказ = Истина;
			КонецЕсли;
			// регистр ОсновныеСредстваМеждународныйУчет 
			Движение = Движения.ОсновныеСредстваМеждународныйУчет.Добавить();
			// is ЯннуровВФ нач 20140610 ЗР-0И-001397
			Если ТекСтрокаОсновныеСредства.ис_ПоПродлению Тогда 
				Движение.Период = Дата;
			Иначе
				Движение.Период = ТекСтрокаОсновныеСредства.ДатаПринятияКУчету;
			КонецЕсли;
			// is ЯннуровВФ кон 20140610
			Движение.ОсновноеСредство = ТекСтрокаОсновныеСредства.ОсновноеСредство;
			Движение.Организация = Организация;
			// is ЯннуровВФ нач 20140610 ЗР-0И-001397
			Если ТекСтрокаОсновныеСредства.ис_ПоПродлению Тогда 
				Движение.ДатаПринятияКУчету = НачалоМесяца(Дата)-1;
			Иначе
			// is ЯннуровВФ кон 20140610
				Движение.ДатаПринятияКУчету = ТекСтрокаОсновныеСредства.ДатаПринятияКУчету;
			КонецЕсли;
			Движение.МестонахождениеОбъекта = ТекСтрокаОсновныеСредства.МестонахождениеОбъекта;
			Движение.МОЛ = ТекСтрокаОсновныеСредства.МОЛ;
			Если НЕ ЗначениеЗаполнено(ТекСтрокаОсновныеСредства.СчетУчетаНовый) Тогда
				Движение.СчетУчета = ТекСтрокаОсновныеСредства.СчетУчета;
			Иначе
				Движение.СчетУчета = ТекСтрокаОсновныеСредства.СчетУчетаНовый;
			КонецЕсли;
			Движение.СрокПолезногоИспользования = ТекСтрокаОсновныеСредства.СрокПолезногоИспользования;
			Движение.НачислятьАмортизацию = ТекСтрокаОсновныеСредства.НачислятьАмортизацию;
			Движение.МетодНачисленияАмортизации = ТекСтрокаОсновныеСредства.МетодНачисленияАмортизации;
			Движение.СчетНачисленияАмортизации = ТекСтрокаОсновныеСредства.СчетНачисленияАмортизации;
			Движение.ПервоначальнаяСтоимость = ТекСтрокаОсновныеСредства.ПервоначальнаяСтоимость;
			Движение.ЛиквидационнаяСтоимость = ТекСтрокаОсновныеСредства.ЛиквидационнаяСтоимость;
			Движение.СчетЗатрат = ТекСтрокаОсновныеСредства.СчетЗатрат;
			Движение.Субконто1 = ТекСтрокаОсновныеСредства.Субконто1;
			Движение.Субконто2 = ТекСтрокаОсновныеСредства.Субконто2;
			Движение.Субконто3 = ТекСтрокаОсновныеСредства.Субконто3;
			Движение.ПредполагаемыйОбъемПродукции = ТекСтрокаОсновныеСредства.ПредполагаемыйОбъемПродукции;
			Движение.СуммаНачисленнойАмортизации = ТекСтрокаОсновныеСредства.СуммаНачисленнойАмортизации;
			Движение.Состояние = Перечисления.ВидыСостоянийОС.ВведеноВЭксплуатацию;
			Движение.КоэффициентУскорения = ТекСтрокаОсновныеСредства.КоэффициентУскорения;
			Движение.СчетСниженияСтоимости = ТекСтрокаОсновныеСредства.СчетСниженияСтоимости;
			Движение.СправедливаяСтоимость = ТекСтрокаОсновныеСредства.ПервоначальнаяСтоимость;
			// is ЯннуровВФ нач 20140523 ЗР-0И-001239
			Движение.ис_Лизинг = (ВидОперации=Перечисления.ДС_ВидыОперацийПоступлениеОС_МСФО.Лизинг);
			// is ЯннуровВФ кон 20140523
		КонецЕсли;
		
		//начало изменений ДС МСФО 05.12.2013
		//Если (ТекСтрокаОсновныеСредства.Сумма <> 0) и (ТекСтрокаОсновныеСредства.СчетУчетаНовый <> ТекСтрокаОсновныеСредства.СчетУчета) и (ЗначениеЗаполнено(ТекСтрокаОсновныеСредства.СчетУчетаНовый)) и (ЗначениеЗаполнено(ТекСтрокаОсновныеСредства.СчетУчета)) и (ЗначениеЗаполнено(ТекСтрокаОсновныеСредства.КоррСчет)) Тогда // переводим на другой счет
		//	// регистр Международный 
		//	Движение = Движения.Международный.Добавить();
		//	Движение.Период = ТекСтрокаОсновныеСредства.ДатаПринятияКУчету;
		//	Движение.СчетДт = ТекСтрокаОсновныеСредства.СчетУчета;
		//	Движение.СчетКт = ТекСтрокаОсновныеСредства.КоррСчет;
		//	Движение.Организация = Организация;
		//	Движение.Сумма = -ТекСтрокаОсновныеСредства.Сумма;
		//	Движение.Содержание = "Сторно";
		//	Движение.НомерЖурнала = "Рег";
		//	
		//	Если не Движение.СчетДт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства,) = Неопределено Тогда
		//		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства] = ТекСтрокаОсновныеСредства.ОсновноеСредство;
		//	КонецЕсли;
		//	
		//	Для Ном = 1 по Движение.СчетКт.ВидыСубконто.Количество() Цикл
		//		Движение.СубконтоКт[Движение.СчетКт.ВидыСубконто[Ном-1].ВидСубконто] = ТекСтрокаОсновныеСредства["Субконто" + Ном + "Кт"];
		//	КонецЦикла;
		//конец изменений ДС МСФО 05.12.2013

			Движение = Движения.Международный.Добавить();
			Если ТекСтрокаОсновныеСредства.ис_ПоПродлению Тогда 
				Движение.Период = Дата;
			Иначе
				Движение.Период = ТекСтрокаОсновныеСредства.ДатаПринятияКУчету;
			КонецЕсли;
			//начало изменений ДС МСФО 05.12.2013
			//Движение.СчетДт = ТекСтрокаОсновныеСредства.СчетУчетаНовый;
			Движение.СчетДт = ТекСтрокаОсновныеСредства.СчетУчета;
			//конец изменений ДС МСФО 05.12.2013
			Движение.СчетКт = ТекСтрокаОсновныеСредства.КоррСчет;
			Движение.Организация = Организация;
			//начало изменений ДС МСФО 05.12.2013
			//Движение.Сумма = ТекСтрокаОсновныеСредства.Сумма;
			Движение.Сумма = ТекСтрокаОсновныеСредства.ПервоначальнаяСтоимость;
			//конец изменений ДС МСФО 05.12.2013
			Движение.Содержание = "Поступление";
			Движение.НомерЖурнала = "Рег";
			// is ЯннуровВФ нач 20140529
			Если Движение.СчетДт.Количественный Тогда 
				Движение.КоличествоДт = 1;
			КонецЕсли;
			Если Движение.СчетКт.Количественный Тогда 
				Движение.КоличествоКт = 1;
			КонецЕсли;
			// is ЯннуровВФ кон 20140529
			// is ЯнннуровВФ нач 20140611 ЗР-0И-001411
			Если Движение.СчетКт.Валютный Тогда 
				Движение.ВалютаКт = ТекСтрокаОсновныеСредства.ис_Валюта;
				Движение.ВалютнаяСуммаКт = ТекСтрокаОсновныеСредства.ис_ПервоначальнаяСтоимостьВал;
			КонецЕсли;
			// is ЯнннуровВФ кон 20140611
			
			//начало изменений ДС МСФО 05.12.2013
			//Для Ном = 1 по Движение.СчетДт.ВидыСубконто.Количество() Цикл
			//	Движение.СубконтоДт[Движение.СчетДт.ВидыСубконто[Ном-1].ВидСубконто] = ТекСтрокаОсновныеСредства["Субконто" + Ном + "Нов"];
			//КонецЦикла;
			Если не Движение.СчетДт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства,) = Неопределено Тогда
				Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства] = ТекСтрокаОсновныеСредства.ОсновноеСредство;
			КонецЕсли;
			//конец изменений ДС МСФО 05.12.2013
			
			Для Ном = 1 по Движение.СчетКт.ВидыСубконто.Количество() Цикл
				//>>190716 Степанов 52764 Движение.СубконтоКт[Движение.СчетКт.ВидыСубконто[Ном-1].ВидСубконто] = ТекСтрокаОсновныеСредства["Субконто" + Ном + "Кт"];
				БухгалтерскийУчет.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, Ном, ТекСтрокаОсновныеСредства["Субконто" + Ном + "Кт"]);
			КонецЦикла;
			
			// регистр Международный (СТАРЫЙ КОД - К УДАЛЕНИЮ)
			//Движение = Движения.Международный.Добавить();
			//Движение.Период = ТекСтрокаОсновныеСредства.ДатаПринятияКУчету;
			//Движение.СчетДт = ТекСтрокаОсновныеСредства.СчетУчетаНовый;
			//Движение.СчетКт = ТекСтрокаОсновныеСредства.СчетУчета;
			//Движение.Организация = Организация;
			//Движение.Сумма = ТекСтрокаОсновныеСредства.Сумма;
			//Движение.Содержание = "Поступление ОС";
			//Движение.НомерЖурнала = "Рег";
			//
			//Для Ном = 1 по Движение.СчетДт.ВидыСубконто.Количество() Цикл
			//	Движение.СубконтоДт[Движение.СчетДт.ВидыСубконто[Ном-1].ВидСубконто] = ТекСтрокаОсновныеСредства["Субконто" + Ном + "Нов"];
			//КонецЦикла;
			//
			//Если не Движение.СчетДт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства,) = Неопределено Тогда
			//	Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства] = ТекСтрокаОсновныеСредства.ОсновноеСредство;
			//КонецЕсли;
			//Если не Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства,) = Неопределено Тогда
			//	Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства] = ТекСтрокаОсновныеСредства.ОсновноеСредство;
			//КонецЕсли;
		//начало изменений ДС МСФО 05.12.2013
		//КонецЕсли;
		//конец изменений ДС МСФО 05.12.2013
		
		
		//+ДС 06.03.2014
		Если Не ТекСтрокаОсновныеСредства.СуммаНачисленнойАмортизации = 0 Тогда
			Движение = Движения.Международный.Добавить();
			Движение.Период = ТекСтрокаОсновныеСредства.ДатаПринятияКУчету;
			//начало изменений
			Если ПРГ_ВводНачальныхОстатков Тогда
				Движение.СчетДт = ПланыСчетов.Международный.Служебный;
			Иначе	
				Движение.СчетДт = ТекСтрокаОсновныеСредства.СчетЗатрат;
			КонецЕсли;	
			//конец изменений
			Движение.СчетКт = ТекСтрокаОсновныеСредства.СчетНачисленияАмортизации;
			Движение.Организация = Организация;
			Движение.Сумма = ТекСтрокаОсновныеСредства.СуммаНачисленнойАмортизации;
			Движение.Содержание = "Начисление амортизации";
			Движение.НомерЖурнала = "Рег";
			
			Для Ном = 1 по Движение.СчетДт.ВидыСубконто.Количество() Цикл
				Движение.СубконтоДт[Движение.СчетДт.ВидыСубконто[Ном-1].ВидСубконто] = ТекСтрокаОсновныеСредства["Субконто" + Ном];
			КонецЦикла;

			
			Если не Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства,) = Неопределено Тогда
				Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства] = ТекСтрокаОсновныеСредства.ОсновноеСредство;
			КонецЕсли;  
		КонецЕсли;	
		//-ДС
		
	КонецЦикла;
	
	// записываем движения регистров
	Движения.ОсновныеСредстваМеждународныйУчет.Записать();
	Движения.Международный.Записать();
	
	// is ЯннуровВФ нач 20140522 ЗР-0И-001219
	ИС_Международный.КонтрольОстатковОСМСФО(ОсновныеСредства.ВыгрузитьКолонку("ОсновноеСредство"));
	// is ЯннуровВФ кон 20140522
	
	// is ЯннуровВФ нач 20140610 ЗР-0И-001397
	Если ВидОперации = Перечисления.ДС_ВидыОперацийПоступлениеОС_МСФО.Лизинг Тогда 
		лЗапрос = Новый Запрос;
		лЗапрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДоговорыКонтрагентов.ДС_ОбъектДоговора КАК ОсновноеСредство,
		|	ДоговорыКонтрагентов.Владелец КАК Контрагент,
		|	ДоговорыКонтрагентов.Ссылка КАК Договор
		|ПОМЕСТИТЬ втДоговоры
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.ПометкаУдаления = ЛОЖЬ
		|	И ДоговорыКонтрагентов.Организация = &Организация
		|	И ДоговорыКонтрагентов.ис_Продлен = ИСТИНА
		|	И ДоговорыКонтрагентов.ис_ДатаПродления МЕЖДУ &НачалоПериода И &ОкончаниеПериода
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОсновныеСредстваМеждународныйУчетСрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
		|	втДоговоры.Контрагент КАК Контрагент,
		|	втДоговоры.Договор КАК Договор
		|ИЗ
		|	РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(&ОкончаниеПериода, ) КАК ОсновныеСредстваМеждународныйУчетСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДоговоры КАК втДоговоры
		|		ПО ОсновныеСредстваМеждународныйУчетСрезПоследних.ОсновноеСредство = втДоговоры.ОсновноеСредство
		|ГДЕ
		|	ОсновныеСредстваМеждународныйУчетСрезПоследних.Состояние <> ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.ВведеноВЭксплуатацию)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОсновноеСредство,
		|	Контрагент,
		|	Договор
		|АВТОУПОРЯДОЧИВАНИЕ";
		лЗапрос.УстановитьПараметр("Организация", Организация);
		лЗапрос.УстановитьПараметр("НачалоПериода", НачалоДня(ПериодНачало));
		лЗапрос.УстановитьПараметр("ОкончаниеПериода", КонецДня(ПериодКонец));
		лВыборка = лЗапрос.Выполнить().Выбрать();
		Если лВыборка.Количество() > 0 Тогда 
			Сообщить("Следующие основные средства имеют продленные договоры, но не введены в эксплутацию", СтатусСообщения.Информация);
			Пока лВыборка.Следующий() Цикл 
				Сообщить(Строка(лВыборка.ОсновноеСредство)+" - "+Строка(лВыборка.Контрагент)+" / "+Строка(лВыборка.Договор));
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	// is ЯннуровВФ кон 20140610
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

// is ЯннуровВФ 20141118
Процедура ПроверитьСчет0803(Период, Счет, Субконто1, Субконто2, Субконто3, Сумма)
	
	лЗапрос = Новый Запрос;
	лЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МеждународныйОстатки.Счет КАК Счет,
	|	МеждународныйОстатки.Субконто1 КАК Субконто1,
	|	СУММА(МеждународныйОстатки.СуммаОстаток) КАК СуммаОстаток
	|ИЗ
	|	РегистрБухгалтерии.Международный.Остатки(&ДатаСГраницей, Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Международный.НезавершенноеСтроительство)), , Организация = &Организация) КАК МеждународныйОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	МеждународныйОстатки.Счет,
	|	МеждународныйОстатки.Субконто1
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет,
	|	Субконто1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	втПараметры.Счет КАК Счет,
	|	втПараметры.Субконто1 КАК Субконто1,
	|	втПараметры.Сумма,
	|	ЕСТЬNULL(втОстатки.СуммаОстаток, 0) КАК СуммаОстаток
	|ИЗ
	|	втПараметры КАК втПараметры
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстатки КАК втОстатки
	|		ПО втПараметры.Счет = втОстатки.Счет
	|			И втПараметры.Субконто1 = втОстатки.Субконто1
	|ГДЕ
	|	втПараметры.Сумма > ЕСТЬNULL(втОстатки.СуммаОстаток, 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Счет,
	|	Субконто1
	|АВТОУПОРЯДОЧИВАНИЕ";
	лЗапрос.УстановитьПараметр("Ссылка", Ссылка);
	лЗапрос.УстановитьПараметр("Организация", Организация);
	лЗапрос.УстановитьПараметр("ДатаСГраницей", Новый Граница(Период,ВидГраницы.Включая));
	лВыборка = лЗапрос.Выполнить().Выбрать();
	Пока лВыборка.Следующий() Цикл 
		Сообщить("Первоначальная стоимость больше остатка на счете "+лВыборка.Счет+" по <"+лВыборка.Субконто1+">: "+лВыборка.Сумма+"  > "+лВыборка.СуммаОстаток, СтатусСообщения.Внимание);
	КонецЦикла;
	
КонецПроцедуры
