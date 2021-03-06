﻿Перем мУдалятьДвижения;


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;  
	
	Если Ответственный.Пустая() Тогда
		Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
		 
	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	Движения.ОсновныеСредстваМеждународныйУчет.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Срез.ОсновноеСредство,
	|	Срез.Организация,
	|	Срез.ДатаПринятияКУчету,
	|	Срез.МестонахождениеОбъекта,
	|	Срез.МОЛ,
	|	Срез.Состояние,
	|	Срез.СчетУчета,
	|	Срез.СрокПолезногоИспользования,
	|	Срез.НачислятьАмортизацию,
	|	Срез.МетодНачисленияАмортизации,
	|	Срез.СчетНачисленияАмортизации,
	|	Срез.ПервоначальнаяСтоимость + Реклассификация.СуммаЗатрат КАК ПервоначальнаяСтоимость,
	|	Срез.СправедливаяСтоимость,
	|	Срез.ЛиквидационнаяСтоимость,
	|	Срез.СчетЗатрат,
	|	Срез.Субконто1,
	|	Срез.Субконто2,
	|	Срез.Субконто3,
	|	Срез.ПредполагаемыйОбъемПродукции,
	|	Срез.СуммаНачисленнойАмортизации,
	|	Срез.УбытокОтОбесценения,
	|	Срез.КоэффициентУскорения,
	|	Срез.СчетСниженияСтоимости,
	|	Срез.ис_Лизинг,
	|	Реклассификация.ОсновноеСредство КАК ОС,
	|	&Дата КАК Период,
	|	&Ссылка КАК Регистратор
	|ИЗ
	|	Документ.ДС_РекласификацияРасходовОСМСФО.Реклассификация КАК Реклассификация
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСредстваМеждународныйУчет.СрезПоследних(&Дата, ) КАК Срез
	|		ПО Реклассификация.ОсновноеСредство = Срез.ОсновноеСредство
	|ГДЕ
	|	Реклассификация.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Дата", 	Дата);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ОсновноеСредство = NULL Тогда
			Сообщить("По основному средству [" + Выборка.ОС + "] нет данных в регистре ""Основные средства (международный учет)""!", СтатусСообщения.Внимание);
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла; 
	
	Движения.ОсновныеСредстваМеждународныйУчет.Загрузить(Результат.Выгрузить());
	
	// is ЯннуровВФ нач 20140611 ЗР-0И-001232
	Движения.НезавершенноеПроизводствоМеждународныйУчет.Записывать = Истина;
	Движения.ЗатратыМеждународныйУчет.Записывать = Истина;
	// is ЯннуровВФ кон 20140611
	
	Движения.Международный.Записывать = Истина;
	Движения.Международный.Очистить();
	Для Каждого ТекСтрокаРеклассификация Из Реклассификация Цикл
		
		// is ЯннуровВФ нач 20140611 ЗР-0И-001232
		лПодразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		лНоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ПустаяСсылка();
		лСтатьяЗатрат = Справочники.СтатьиЗатрат.ПустаяСсылка();
		Для лНомер=1 По 3 Цикл 
			лЗначениеСубконто = ТекСтрокаРеклассификация["СубконтоЗатрат"+лНомер];
			Если ТипЗнч(лЗначениеСубконто) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда 
				лПодразделение = лЗначениеСубконто;
			ИначеЕсли ТипЗнч(лЗначениеСубконто) = Тип("СправочникСсылка.НоменклатурныеГруппы") Тогда 
				лНоменклатурнаяГруппа = лЗначениеСубконто;
			ИначеЕсли ТипЗнч(лЗначениеСубконто) = Тип("СправочникСсылка.СтатьиЗатрат") Тогда 
				лСтатьяЗатрат = лЗначениеСубконто;
			КонецЕсли;
		КонецЦикла;
		
		лРегистрЗатрат = ис_Международный.ПолучитьРегистрПоСчетуЗатрат(ТекСтрокаРеклассификация.СчетЗатрат);
		Если лРегистрЗатрат = "НезавершенноеПроизводствоМеждународныйУчет" Тогда 
			лДвижение = Движения.НезавершенноеПроизводствоМеждународныйУчет.Добавить();
			лДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
			лДвижение.Период = Дата;
			лДвижение.Организация = Организация;
			лДвижение.Подразделение = лПодразделение;
			лДвижение.СчетУчета = ТекСтрокаРеклассификация.СчетЗатрат;
			лДвижение.СтатьяЗатрат = лСтатьяЗатрат;
			лДвижение.НоменклатурнаяГруппа = лНоменклатурнаяГруппа;
			лДвижение.Заказ = Неопределено;
			лДвижение.Затрата = Неопределено;
			лДвижение.ХарактеристикаЗатраты = Неопределено;
			лДвижение.СерияЗатраты = Неопределено;
			лДвижение.Количество = 0;
			лДвижение.Стоимость = -ТекСтрокаРеклассификация.СуммаЗатрат; 
			лДвижение.КодОперации = Перечисления.КодыОперацийНезавершенноеПроизводство.ПустаяСсылка();
			лДвижение.СписаниеПартий = Ложь;
			лДвижение.НомерПередела = 0
		ИначеЕсли лРегистрЗатрат = "ЗатратыМеждународныйУчет" Тогда 
			лДвижение = Движения.ЗатратыМеждународныйУчет.Добавить();
			лДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
			лДвижение.Период = Дата;
			лДвижение.Организация = Организация;
			лДвижение.Подразделение = лПодразделение;
			лДвижение.СчетУчета = ТекСтрокаРеклассификация.СчетЗатрат;
			лДвижение.СтатьяЗатрат = лСтатьяЗатрат;
			лДвижение.НоменклатурнаяГруппа = лНоменклатурнаяГруппа;
			лДвижение.Заказ = Неопределено;
			лДвижение.Сумма = -ТекСтрокаРеклассификация.СуммаЗатрат; 
			лДвижение.СписаниеПартий = Ложь;
			лДвижение.КодОперации = Перечисления.КодыОперацийНезавершенноеПроизводство.ПустаяСсылка();
		КонецЕсли;
		// is ЯннуровВФ кон 20140611
		
		ПроводкаМСФО = Движения.Международный.Добавить();
		ПроводкаМСФО.Период = Дата;
		ПроводкаМСФО.СчетДт = ТекСтрокаРеклассификация.СчетЗатрат;
		ПроводкаМСФО.СчетКт = ТекСтрокаРеклассификация.СчетВзаиморасчетов;
		ПроводкаМСФО.Организация = Организация;
		ПроводкаМСФО.Сумма = -ТекСтрокаРеклассификация.СуммаЗатрат;
		ПроводкаМСФО.Содержание = "Реклассификация расходов";
		БухгалтерскийУчет.УстановитьСубконто(ПроводкаМСФО.СчетДт, ПроводкаМСФО.СубконтоДт, 1, ТекСтрокаРеклассификация.СубконтоЗатрат1);
		БухгалтерскийУчет.УстановитьСубконто(ПроводкаМСФО.СчетДт, ПроводкаМСФО.СубконтоДт, 2, ТекСтрокаРеклассификация.СубконтоЗатрат2);
		БухгалтерскийУчет.УстановитьСубконто(ПроводкаМСФО.СчетДт, ПроводкаМСФО.СубконтоДт, 3, ТекСтрокаРеклассификация.СубконтоЗатрат3);
		БухгалтерскийУчет.УстановитьСубконто(ПроводкаМСФО.СчетКт, ПроводкаМСФО.СубконтоКт, 1, ТекСтрокаРеклассификация.СубконтоВзаиморасчетов1);
		БухгалтерскийУчет.УстановитьСубконто(ПроводкаМСФО.СчетКт, ПроводкаМСФО.СубконтоКт, 2, ТекСтрокаРеклассификация.СубконтоВзаиморасчетов2);
		БухгалтерскийУчет.УстановитьСубконто(ПроводкаМСФО.СчетКт, ПроводкаМСФО.СубконтоКт, 3, ТекСтрокаРеклассификация.СубконтоВзаиморасчетов3);
		// is ЯннуровВФ нач 20140623 0И-001232
		Если ТекСтрокаРеклассификация.СчетВзаиморасчетов.Валютный Тогда 
			ПроводкаМСФО.ВалютаКт = ТекСтрокаРеклассификация.ис_ВалютаВзаиморасчетов;
			ПроводкаМСФО.ВалютнаяСуммаКт = ТекСтрокаРеклассификация.ис_ВалютнаяСуммаВзаиморасчетов;
		КонецЕсли;
		// is ЯннуровВФ кон 20140623
        		
		// is ЯннуровВФ нач 20140602 ЗР-0И-001232 Раскомментировал
		//начало изменений ДС МСФО 09.01.2014
		ПроводкаМСФО = Движения.Международный.Добавить();
		ПроводкаМСФО.Период = Дата;
		ПроводкаМСФО.СчетДт = ТекСтрокаРеклассификация.СчетУчетаОС;
		ПроводкаМСФО.СчетКт = ТекСтрокаРеклассификация.СчетВзаиморасчетов;
		ПроводкаМСФО.Организация = Организация;
		ПроводкаМСФО.Сумма = ТекСтрокаРеклассификация.СуммаЗатрат;
		ПроводкаМСФО.Содержание = "Реклассификация расходов";
		БухгалтерскийУчет.УстановитьСубконто(ПроводкаМСФО.СчетДт, ПроводкаМСФО.СубконтоДт, 1, ТекСтрокаРеклассификация.ОсновноеСредство);
		БухгалтерскийУчет.УстановитьСубконто(ПроводкаМСФО.СчетКт, ПроводкаМСФО.СубконтоКт, 1, ТекСтрокаРеклассификация.СубконтоВзаиморасчетов1);
		БухгалтерскийУчет.УстановитьСубконто(ПроводкаМСФО.СчетКт, ПроводкаМСФО.СубконтоКт, 2, ТекСтрокаРеклассификация.СубконтоВзаиморасчетов2);
		БухгалтерскийУчет.УстановитьСубконто(ПроводкаМСФО.СчетКт, ПроводкаМСФО.СубконтоКт, 3, ТекСтрокаРеклассификация.СубконтоВзаиморасчетов3);
		//конец изменений ДС МСФО 09.01.2014
		// is ЯннуровВФ кон 20140602
		// is ЯннуровВФ нач 20140623 0И-001232
		Если ТекСтрокаРеклассификация.СчетВзаиморасчетов.Валютный Тогда 
			ПроводкаМСФО.ВалютаКт = ТекСтрокаРеклассификация.ис_ВалютаВзаиморасчетов;
			ПроводкаМСФО.ВалютнаяСуммаКт = ТекСтрокаРеклассификация.ис_ВалютнаяСуммаВзаиморасчетов;
		КонецЕсли;
		// is ЯннуровВФ кон 20140623
	КонецЦикла;
	
	// is ЯннуровВФ нач 20140523 ЗР-0И-001232
	Движения.Международный.Записать();
	лЗапрос = Новый Запрос;
	лЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДС_РекласификацияРасходовОСМСФОРеклассификация.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	Документ.ДС_РекласификацияРасходовОСМСФО.Реклассификация КАК ДС_РекласификацияРасходовОСМСФОРеклассификация
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(
	|				,
	|				Счет В (&Счета),
	|				,
	|				(Субконто1, Субконто2, Субконто3) В
	|					(ВЫБРАТЬ
	|						ДС_РекласификацияРасходовОСМСФОРеклассификация.СубконтоВзаиморасчетов1,
	|						ДС_РекласификацияРасходовОСМСФОРеклассификация.СубконтоВзаиморасчетов2,
	|						ДС_РекласификацияРасходовОСМСФОРеклассификация.СубконтоВзаиморасчетов3
	|					ИЗ
	|						Документ.ДС_РекласификацияРасходовОСМСФО.Реклассификация КАК ДС_РекласификацияРасходовОСМСФОРеклассификация
	|					ГДЕ
	|						ДС_РекласификацияРасходовОСМСФОРеклассификация.Ссылка = &Ссылка)) КАК МеждународныйОстатки
	|		ПО ДС_РекласификацияРасходовОСМСФОРеклассификация.СчетВзаиморасчетов = МеждународныйОстатки.Счет
	|			И ДС_РекласификацияРасходовОСМСФОРеклассификация.СубконтоВзаиморасчетов1 = МеждународныйОстатки.Субконто1
	|			И ДС_РекласификацияРасходовОСМСФОРеклассификация.СубконтоВзаиморасчетов2 = МеждународныйОстатки.Субконто2
	|			И ДС_РекласификацияРасходовОСМСФОРеклассификация.СубконтоВзаиморасчетов3 = МеждународныйОстатки.Субконто3
	|ГДЕ
	|	ДС_РекласификацияРасходовОСМСФОРеклассификация.Ссылка = &Ссылка
	|	И МеждународныйОстатки.СуммаОстаток < 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОсновноеСредство
	|АВТОУПОРЯДОЧИВАНИЕ";
	лЗапрос.УстановитьПараметр("Ссылка", Ссылка);
	лЗапрос.УстановитьПараметр("Счета", Реклассификация.ВыгрузитьКолонку("СчетВзаиморасчетов"));
	лВыборка = лЗапрос.Выполнить().Выбрать();
	Пока лВыборка.Следующий() Цикл 
		Отказ = Истина;
		Сообщить("Актив """+лВыборка.ОсновноеСредство+""" имеет отрицательный остаток на счете взаиморасчетов");
	КонецЦикла;
	// is ЯннуровВФ кон 20140523
	
	// is ЯннуровВФ нач 20140610 ЗР-0И-001232
	лЗапрос = Новый Запрос;
	лЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДС_РекласификацияРасходовОСМСФОРеклассификация.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	Документ.ДС_РекласификацияРасходовОСМСФО.Реклассификация КАК ДС_РекласификацияРасходовОСМСФОРеклассификация
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Международный.Остатки(
	|				,
	|				Счет В (&Счета),
	|				,
	|				(Субконто1, Субконто2) В
	|					(ВЫБРАТЬ
	|						ДС_РекласификацияРасходовОСМСФОРеклассификация.СубконтоЗатрат1,
	|						ДС_РекласификацияРасходовОСМСФОРеклассификация.СубконтоЗатрат2
	|					ИЗ
	|						Документ.ДС_РекласификацияРасходовОСМСФО.Реклассификация КАК ДС_РекласификацияРасходовОСМСФОРеклассификация
	|					ГДЕ
	|						ДС_РекласификацияРасходовОСМСФОРеклассификация.Ссылка = &Ссылка)) КАК МеждународныйОстатки
	|		ПО ДС_РекласификацияРасходовОСМСФОРеклассификация.СчетЗатрат = МеждународныйОстатки.Счет
	|			И ДС_РекласификацияРасходовОСМСФОРеклассификация.СубконтоЗатрат1 = МеждународныйОстатки.Субконто1
	|			И ДС_РекласификацияРасходовОСМСФОРеклассификация.СубконтоЗатрат2 = МеждународныйОстатки.Субконто2
	|			И (ДС_РекласификацияРасходовОСМСФОРеклассификация.СубконтоЗатрат3 = МеждународныйОстатки.Субконто3
	|				ИЛИ МеждународныйОстатки.Счет.ВидыСубконто.НомерСтроки = 3
	|					И МеждународныйОстатки.Счет.ВидыСубконто.ТолькоОбороты = ИСТИНА)
	|ГДЕ
	|	ДС_РекласификацияРасходовОСМСФОРеклассификация.Ссылка = &Ссылка
	|	И МеждународныйОстатки.СуммаОстаток < 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОсновноеСредство
	|АВТОУПОРЯДОЧИВАНИЕ";
	лЗапрос.УстановитьПараметр("Ссылка", Ссылка);
	лЗапрос.УстановитьПараметр("Счета", Реклассификация.ВыгрузитьКолонку("СчетЗатрат"));
	лВыборка = лЗапрос.Выполнить().Выбрать();
	Пока лВыборка.Следующий() Цикл 
		Отказ = Истина;
		Сообщить("Актив """+лВыборка.ОсновноеСредство+""" имеет отрицательный остаток на счете затрат");
	КонецЦикла;
	// is ЯннуровВФ кон 20140610
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//начало изменений ДС МСФО 11.12.2013
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект);
	//конец изменений ДС МСФО 11.12.2013
КонецПроцедуры //ОбработкаЗаполнения()


