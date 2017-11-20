﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ МЕХАНИЗМА ОСТАТКОВ ОТПУСКОВ

Функция ГрафикОтпусков_ЦветПлана() Экспорт
	
	Возврат WebЦвета.ТусклоОливковый;
	
КонецФункции

Функция ГрафикОтпусков_ЦветПланаНеУтвержденного() Экспорт
	
	Возврат WebЦвета.НейтральноСерый;
	
КонецФункции

Функция ГрафикОтпусков_ЦветФакта() Экспорт
	
	Возврат WebЦвета.ГолубойСоСтальнымОттенком;
	
КонецФункции

Функция ГрафикОтпусков_ЦветМероприятий() Экспорт
	
	Возврат WebЦвета.БледноМиндальный;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПОДГОТОВКИ ИНФОРМАЦИИ В ФОРМЕ

// Процедура возвращает паспортные данные физлица в виде строки
//
// Параметры: 
//  Валюта                         - Валюта, курс которой необходимо отобразить
//  Курс                           - курс, которой необходимо отобразить
//  Кратность                      - кратность, которую необходимо отобразить
//  ВалютаРегламентированногоУчета - валюта регламентированного учета
//  СформироватьСкобки             - признак необходимости скобок
//
// Возвращаемое значение:
//  Строка с данными о курсе и кратности валюты
//
Функция ПолучитьИнформациюКурсаВалютыСтрокой(Валюта, Курс, Кратность, ВалютаРегламентированногоУчета, СформироватьСкобки = Ложь) Экспорт

	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Возврат "";
		
	Иначе
		Возврат ?(СформироватьСкобки, "   ( ", "") + Кратность + " "
		      + СокрЛП(Валюта)
		      + " = "
		      + Курс + " " 
		      + СокрЛП(ВалютаРегламентированногоУчета)
		      + ?(СформироватьСкобки, " )", "");
	КонецЕсли;

КонецФункции // ПолучитьИнформациюКурсаВалютыСтрокой()

// Формирует представление переданного способа отражения с "предметной" точки зрения
//
// Параметры
//  СпособОтраженияВБухучете - СправочникСсылка.СпособыОтраженияЗарплатыВРеглУчете - описываемый 
//                 способ отражения
//  НетБазовыхРасчетов - булево - указывает на наличие/отсутствие у в.р. расчетной базы
//
// Возвращаемое значение:
//   строка - сформированное представление
//
Функция ПолучитьПредставлениеСпособаОтраженияНачисленияВУчетах(СпособОтраженияВБухучете, НетБазовыхРасчетов) Экспорт
	
	Если СпособОтраженияВБухучете.Пустая() Тогда
		РасшифровкаТекст = "Способ отражения определяется по данным о работнике и его плановых начислениях";
	ИначеЕсли СпособОтраженияВБухучете = Справочники.СпособыОтраженияЗарплатыВРеглУчете.НеОтражатьВБухучете Тогда
		РасшифровкаТекст = "Начисление не отражается в бухгалтерском и налоговом учете, а также в учете для УСН";
	ИначеЕсли СпособОтраженияВБухучете = Справочники.СпособыОтраженияЗарплатыВРеглУчете.РаспределятьПоБазовымНачислениям Тогда
		РасшифровкаТекст = "Отражение начисления в бухгалтерском и налоговом учете определяется по базовым начислениям";
	Иначе
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка",СпособОтраженияВБухучете);
		Запрос.УстановитьПараметр("Подразделения",ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Подразделения);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(СпособыОтраженияЗарплатыВРеглУчете.СчетДт.Код, """") КАК СчетДт,
		|	ПРЕДСТАВЛЕНИЕ(СпособыОтраженияЗарплатыВРеглУчете.СубконтоДт1) КАК СубконтоДт1Представление,
		|	ПРЕДСТАВЛЕНИЕ(СпособыОтраженияЗарплатыВРеглУчете.СубконтоДт2) КАК СубконтоДт2Представление,
		|	ПРЕДСТАВЛЕНИЕ(СпособыОтраженияЗарплатыВРеглУчете.СубконтоДт3) КАК СубконтоДт3Представление,
		|	ЕСТЬNULL(СпособыОтраженияЗарплатыВРеглУчете.СчетКт.Код, """") КАК СчетКт,
		|	ЕСТЬNULL(СпособыОтраженияЗарплатыВРеглУчете.СчетДтНУ.Код, """") КАК СчетДтНУ,
		|	ПРЕДСТАВЛЕНИЕ(СпособыОтраженияЗарплатыВРеглУчете.СубконтоДтНУ1) КАК СубконтоДтНУ1Представление,
		|	ПРЕДСТАВЛЕНИЕ(СпособыОтраженияЗарплатыВРеглУчете.СубконтоДтНУ2) КАК СубконтоДтНУ2Представление,
		|	ПРЕДСТАВЛЕНИЕ(СпособыОтраженияЗарплатыВРеглУчете.СубконтоДтНУ3) КАК СубконтоДтНУ3Представление,
		|	ЕСТЬNULL(СпособыОтраженияЗарплатыВРеглУчете.СчетКтНУ.Код, """") КАК СчетКтНУ,
		|	СпособыОтраженияЗарплатыВРеглУчете.ОтражениеВУСН,
		|	ЕСТЬNULL(ХозрасчетныйВидыСубконто.КоличествоСк, 0) КАК КоличествоСкБУ,
		|	ЕСТЬNULL(НалоговыйВидыСубконто.КоличествоСк, 0) КАК КоличествоСкНУ,
		|	ЕСТЬNULL(ВидСубконтоБУПодразделения.НомерСтроки, 0) КАК НомерСкПодразделенияБУ,
		|	ЕСТЬNULL(ВидСубконтоНУПодразделения.НомерСтроки, 0) КАК НомерСкПодразделенияНУ
		|ИЗ
		|	(ВЫБРАТЬ
		|		СпособыОтраженияЗарплатыВРеглУчете.Ссылка КАК Ссылка,
		|		СпособыОтраженияЗарплатыВРеглУчете.СчетДт КАК СчетДт,
		|		СпособыОтраженияЗарплатыВРеглУчете.СубконтоДт1 КАК СубконтоДт1,
		|		СпособыОтраженияЗарплатыВРеглУчете.СубконтоДт2 КАК СубконтоДт2,
		|		СпособыОтраженияЗарплатыВРеглУчете.СубконтоДт3 КАК СубконтоДт3,
		|		СпособыОтраженияЗарплатыВРеглУчете.СчетКт КАК СчетКт,
		|		СпособыОтраженияЗарплатыВРеглУчете.СубконтоКт1 КАК СубконтоКт1,
		|		СпособыОтраженияЗарплатыВРеглУчете.СубконтоКт2 КАК СубконтоКт2,
		|		СпособыОтраженияЗарплатыВРеглУчете.СубконтоКт3 КАК СубконтоКт3,
		|		СпособыОтраженияЗарплатыВРеглУчете.СчетДтНУ КАК СчетДтНУ,
		|		СпособыОтраженияЗарплатыВРеглУчете.СубконтоДтНУ1 КАК СубконтоДтНУ1,
		|		СпособыОтраженияЗарплатыВРеглУчете.СубконтоДтНУ2 КАК СубконтоДтНУ2,
		|		СпособыОтраженияЗарплатыВРеглУчете.СубконтоДтНУ3 КАК СубконтоДтНУ3,
		|		СпособыОтраженияЗарплатыВРеглУчете.СчетКтНУ КАК СчетКтНУ,
		|		СпособыОтраженияЗарплатыВРеглУчете.СубконтоКтНУ1 КАК СубконтоКтНУ1,
		|		СпособыОтраженияЗарплатыВРеглУчете.СубконтоКтНУ2 КАК СубконтоКтНУ2,
		|		СпособыОтраженияЗарплатыВРеглУчете.СубконтоКтНУ3 КАК СубконтоКтНУ3,
		|		СпособыОтраженияЗарплатыВРеглУчете.ОтражениеВУСН КАК ОтражениеВУСН
		|	ИЗ
		|		Справочник.СпособыОтраженияЗарплатыВРеглУчете КАК СпособыОтраженияЗарплатыВРеглУчете
		|	ГДЕ
		|		СпособыОтраженияЗарплатыВРеглУчете.Ссылка = &Ссылка) КАК СпособыОтраженияЗарплатыВРеглУчете
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			КОЛИЧЕСТВО(ХозрасчетныйВидыСубконто.ВидСубконто) КАК КоличествоСк,
		|			ХозрасчетныйВидыСубконто.Ссылка КАК Ссылка
		|		ИЗ
		|			ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ХозрасчетныйВидыСубконто.Ссылка) КАК ХозрасчетныйВидыСубконто
		|		ПО СпособыОтраженияЗарплатыВРеглУчете.СчетДт = ХозрасчетныйВидыСубконто.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ХозрасчетныйВидыСубконто.НомерСтроки КАК НомерСтроки,
		|			ХозрасчетныйВидыСубконто.Ссылка КАК СчетДт
		|		ИЗ
		|			ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
		|		ГДЕ
		|			ХозрасчетныйВидыСубконто.ВидСубконто = &Подразделения) КАК ВидСубконтоБУПодразделения
		|		ПО ВидСубконтоБУПодразделения.СчетДт = ХозрасчетныйВидыСубконто.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			КОЛИЧЕСТВО(НалоговыйВидыСубконто.ВидСубконто) КАК КоличествоСк,
		|			НалоговыйВидыСубконто.Ссылка КАК Ссылка
		|		ИЗ
		|			ПланСчетов.Налоговый.ВидыСубконто КАК НалоговыйВидыСубконто
		|		
		|		СГРУППИРОВАТЬ ПО
		|			НалоговыйВидыСубконто.Ссылка) КАК НалоговыйВидыСубконто
		|		ПО СпособыОтраженияЗарплатыВРеглУчете.СчетДтНУ = НалоговыйВидыСубконто.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			НалоговыйВидыСубконто.НомерСтроки КАК НомерСтроки,
		|			НалоговыйВидыСубконто.Ссылка КАК СчетДт
		|		ИЗ
		|			ПланСчетов.Налоговый.ВидыСубконто КАК НалоговыйВидыСубконто
		|		ГДЕ
		|			НалоговыйВидыСубконто.ВидСубконто = &Подразделения) КАК ВидСубконтоНУПодразделения
		|		ПО ВидСубконтоНУПодразделения.СчетДт = ХозрасчетныйВидыСубконто.Ссылка";
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		РасшифровкаТекст = "Бухгалтерский учет: ";
		Если ЗначениеЗаполнено(Выборка.СчетДт) Тогда
			РасшифровкаТекст = РасшифровкаТекст + "Дт " + Выборка.СчетДт;
			Для СчСк = 1 По Выборка.КоличествоСкБУ Цикл
				Если Выборка["СубконтоДт" + СчСк + "Представление"] = Null Тогда
					Если СчСк = Выборка.НомерСкПодразделенияБУ Тогда
						РасшифровкаТекст = РасшифровкаТекст + ", <подбирается автоматически>";
					Иначе
						РасшифровкаТекст = РасшифровкаТекст + ", <не указано>";
					КонецЕсли;
				Иначе
					РасшифровкаТекст = РасшифровкаТекст + ", " + Выборка["СубконтоДт" + СчСк + "Представление"];
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли НетБазовыхРасчетов Тогда
			РасшифровкаТекст = РасшифровкаТекст + "Дт <не указано>";
		Иначе
			РасшифровкаТекст = РасшифровкаТекст + "счет дебета определяется по расчетной базе";
		КонецЕсли;
		Если ЗначениеЗаполнено(Выборка.СчетКт) Тогда
			РасшифровкаТекст = РасшифровкаТекст + " Кт " + Выборка.СчетКт;
		ИначеЕсли НетБазовыхРасчетов Тогда
			РасшифровкаТекст = РасшифровкаТекст + " Кт <не указано>";
		Иначе
			РасшифровкаТекст = РасшифровкаТекст + "; счет кредита определяется по расчетной базе";
		КонецЕсли;
		РасшифровкаТекст = РасшифровкаТекст + ";" + Символы.ПС + "Налоговый учет: ";
		Если ЗначениеЗаполнено(Выборка.СчетДтНУ) Тогда
			РасшифровкаТекст = РасшифровкаТекст + "Дт " + Выборка.СчетДтНУ;
			Для СчСк = 1 По Выборка.КоличествоСкНУ Цикл
				Если Выборка["СубконтоДтНУ" + СчСк + "Представление"] = Null Тогда
					Если СчСк = Выборка.НомерСкПодразделенияНУ Тогда
						РасшифровкаТекст = РасшифровкаТекст + ", <подбирается автоматически>";
					Иначе
						РасшифровкаТекст = РасшифровкаТекст + ", <не указано>";
					КонецЕсли;
				Иначе
					РасшифровкаТекст = РасшифровкаТекст + ", " + Выборка["СубконтоДтНУ" + СчСк + "Представление"];
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли НетБазовыхРасчетов Тогда
			РасшифровкаТекст = РасшифровкаТекст + "Дт <не указано>";
		Иначе
			РасшифровкаТекст = РасшифровкаТекст + "счет дебета определяется по расчетной базе";
		КонецЕсли;
		Если ЗначениеЗаполнено(Выборка.СчетКтНУ) Тогда
			РасшифровкаТекст = РасшифровкаТекст + " Кт " + Выборка.СчетКтНУ;
		ИначеЕсли НетБазовыхРасчетов Тогда
			РасшифровкаТекст = РасшифровкаТекст + " Кт <не указано>";
		Иначе
			РасшифровкаТекст = РасшифровкаТекст + "; счет кредита определяется по расчетной базе";
		КонецЕсли;
		РасшифровкаТекст = РасшифровкаТекст + ";" + Символы.ПС + "Учет для УСН: ";
		Если ПустаяСтрока(Выборка.СчетКт) и Выборка.ОтражениеВУСН.Пустая() Тогда
			РасшифровкаТекст = РасшифровкаТекст + "определяется по расчетной базе";
		Иначе
			РасшифровкаТекст = РасшифровкаТекст + ?(Выборка.ОтражениеВУСН = Перечисления.ОтражениеВУСН.Принимаются,"","не ") + "принимается как расходы";
		КонецЕсли;
	КонецЕсли;
	
	Возврат РасшифровкаТекст	
	
КонецФункции // ПолучитьПредставлениеСпособаОтраженияНачисленияВУчетах()

Функция РасшифровкаЕжегодныйОтпускДляРезервов(ЕжегодныйОтпускДляРезервов) Экспорт
	
	РасшифровкаТекст = "";
	
	Если ЕжегодныйОтпускДляРезервов Тогда
		РасшифровкаТекст = "Если в организации формируются оценочные обязательства и указано оценочное обязательство по ежегодным отпускам, это начисление будет отражаться в учете по дебету счета 96" 
	Иначе
		РасшифровкаТекст = "Это начисление не выплачивается за счет оценочных обязательств и резервов";
	КонецЕсли;
	
	Возврат РасшифровкаТекст;
	
КонецФункции




////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОФОРМЛЕНИЯ ФОРМЫ

Процедура УстановитьВидимостьПереключателяВидаУчета(Форма) Экспорт
	
	ИспользоватьУправленческийУчетЗарплаты = глЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты");
	
	Форма.ЭлементыФормы.ВидУчета.Видимость = ИспользоватьУправленческийУчетЗарплаты;
	
КонецПроцедуры

Процедура УстановитьВидимостьКолонкиУпрУчета(Список) Экспорт
	
	ИспользоватьУправленческийУчетЗарплаты = глЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты");
	
	Список.Колонки.ОтражатьВУправленческомУчете.Видимость	= ИспользоватьУправленческийУчетЗарплаты;
	Список.Колонки.ОтражатьВБухгалтерскомУчете.Видимость	= ИспользоватьУправленческийУчетЗарплаты;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ И ОБРАБОТКИ МЕНЮ

// Процедура установки типа и доступности субконто в зависимости от  выбранного счета
//
//     Параметры:
//          Счет - выбранный счет
//          Форма - форма(или табличное поле) на которой расположены счет и субконто
//          Префикс - префекс наименования субконто. к префиксу добавляется номер субконто на счете
//                    для подписи с наименованием субконто предполагается имя
//                    вида "Надпись" + Префикс + НомерСубконто
//                    в случае если форма - это таб.поле, то надписи не устанавливаются
//
Процедура ПриВыбореСчета(Счет, Субконто1, НадписьСубконто1, Субконто2, НадписьСубконто2, Субконто3, НадписьСубконто3, ПолеСчет = НЕОПРЕДЕЛЕНО, ТолькоПросмотр = ЛОЖЬ) Экспорт
	
	ЭлементыСубконто = Новый Структура("Субконто1,НадписьСубконто1,Субконто2,НадписьСубконто2,Субконто3,НадписьСубконто3", Субконто1, НадписьСубконто1, Субконто2, НадписьСубконто2, Субконто3, НадписьСубконто3);
	
	ЧислоАктивныхСубконто = Счет.ВидыСубконто.Количество();
	
	Для Сч = 1 По ЧислоАктивныхСубконто Цикл
		
		ТипСубк = Счет.ВидыСубконто[Сч - 1].ВидСубконто.ТипЗначения;
		
		ЭлементыСубконто["Субконто" + Сч].Видимость = НЕ ТолькоПросмотр;
		ЭлементыСубконто["Субконто" + Сч].ВыбиратьТип = Ложь;
		
		// Чтобы не устанавливался флаг модифицированности при открытии формы
		Если ТипСубк.ПривестиЗначение(ЭлементыСубконто["Субконто" + Сч].Значение) <> ЭлементыСубконто["Субконто" + Сч].Значение Тогда
			ЭлементыСубконто["Субконто" + Сч].Значение = ТипСубк.ПривестиЗначение(ЭлементыСубконто["Субконто" + Сч].Значение);
		КонецЕсли;

		ЭлементыСубконто["НадписьСубконто" + Сч].Заголовок = Счет.ВидыСубконто[Сч - 1].ВидСубконто.Наименование + ":";
		ЭлементыСубконто["НадписьСубконто" + Сч].Видимость = НЕ ТолькоПросмотр;
		
	КонецЦикла;
	
	Для Сч = (ЧислоАктивныхСубконто + 1) По 3 Цикл
		
		Если Не ЭлементыСубконто["Субконто" + Сч].Значение = Неопределено Тогда
			ЭлементыСубконто["Субконто" + Сч].Значение = Неопределено;
		КонецЕсли;
		
		ЭлементыСубконто["Субконто" + Сч].Видимость = Ложь;
		ЭлементыСубконто["НадписьСубконто" + Сч].Видимость = Ложь;
		
	КонецЦикла;
	
	Если ПолеСчет <> НЕОПРЕДЕЛЕНО Тогда
		ПолеСчет.ТолькоПросмотр = ТолькоПросмотр;
	КонецЕсли;
	
КонецПроцедуры // ПриВыбореСчета()

// Процедура инициирует диалог выбора времени.
//
// Параметры
//  Форма - Форма, в которой производится выбор
//  ДатаВремен - дата для выбора времени
//  ТекЭлемент - элемент формы
//  ПолныйГод - булево, показывать год 4-мя цифрами или 2-мя
//
// Возвращаемое значение:
//  НЕТ
//
Процедура ВыбратьВремяДня(Форма, ДатаВремен, ТекЭлемент, Пользователь, ПоГрафику = Истина, ПолныйГод = Истина, ВыбиратьТолькоВремя = Ложь, ДатаНачала = Неопределено) Экспорт

	ДлинаЧаса = 3600;
	
	Если ПоГрафику Тогда
		СтруктураРабочегоВремени = УправлениеКонтактами.ОпределитьНачалоИОкончаниеРабочегоДняПользователя(Пользователь, ДатаВремен);
		
		НачалоРабочегоДняКонстанта    = СтруктураРабочегоВремени.ДатаНачала;
		ОкончаниеРабочегоДняКонстанта = СтруктураРабочегоВремени.ДатаОкончания;
	Иначе
		НачалоРабочегоДняКонстанта      = '00010101000000';
		ОкончаниеРабочегоДняКонстанта   = '00010101235959';
	КонецЕсли;
		
	СписокВремен = Новый СписокЗначений;
	НачалоРабочегоДня = НачалоЧаса(НачалоДня(ДатаВремен) + Час(НачалоРабочегоДняКонстанта) * ДлинаЧаса + Минута(НачалоРабочегоДняКонстанта)*60);
	ОкончаниеРабочегоДня = КонецЧаса(НачалоДня(ДатаВремен) + Час(ОкончаниеРабочегоДняКонстанта) * ДлинаЧаса + Минута(ОкончаниеРабочегоДняКонстанта)*60) - ДлинаЧаса;

	// Если в процедуру дата начала не передана, список начнется с даты начала рабочего дня
	// В противном случае, необходимо взять из даты начала время, а саму дату взять из ДатаВремен
	ВремяНачала = ?(ДатаНачала = Неопределено, НачалоРабочегоДня, НачалоДня(ДатаВремен) + (ДатаНачала - НачалоДня(ДатаНачала)));
	ВремяСписка = ВремяНачала;
	Пока НачалоЧаса(ВремяСписка) <= НачалоЧаса(ОкончаниеРабочегоДня) Цикл
		Если НЕ ЗначениеЗаполнено(ВремяСписка) И ВыбиратьТолькоВремя Тогда
			ПредставлениеВремени = "00:00";
			
		Иначе
			Если ВыбиратьТолькоВремя Тогда
				ПредставлениеВремени = Формат(ВремяСписка,"ДФ=ЧЧ:мм");
				
			Иначе
				ПредставлениеВремени = Формат(ВремяСписка,"ДФ='дд.ММ.гг" + ?(ПолныйГод,"гг","") + " ЧЧ:мм'");
				
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДатаНачала) Тогда
			РазностьДат = (ВремяСписка - ВремяНачала) / ДлинаЧаса;
			
			Если РазностьДат = 0 Тогда
				ПредставлениеВремени = ПредставлениеВремени + " (0 мин.)";
				
			ИначеЕсли РазностьДат = 0.5 Тогда
				ПредставлениеВремени = ПредставлениеВремени + " (30 мин.)";
				
			Иначе
				ПредставлениеВремени = ПредставлениеВремени + " (" + РазностьДат + " час.)";
				
			КонецЕсли;
		КонецЕсли;
		
		СписокВремен.Добавить(ВремяСписка, ПредставлениеВремени);
		
		ВремяСписка = ВремяСписка + ДлинаЧаса / 2; // по полчаса
	КонецЦикла;

	НачальноеЗначение = СписокВремен.НайтиПоЗначению(ДатаВремен);
	Если НачальноеЗначение = Неопределено Тогда
		ВыбранноеВремя = Форма.ВыбратьИзСписка(СписокВремен, ТекЭлемент);
	Иначе
		ВыбранноеВремя = Форма.ВыбратьИзСписка(СписокВремен, ТекЭлемент, НачальноеЗначение);
	КонецЕсли;

	Если ВыбранноеВремя <> Неопределено Тогда
		ДатаВремен = ВыбранноеВремя.Значение;
	КонецЕсли;
	
КонецПроцедуры // ВыбратьВремя()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБРАБОТКИ КОМАНД ГЛАВНОГО МЕНЮ И РАБОЧЕГО СТОЛА

Процедура ПереключитьПолныйИнтерфейс() Экспорт
	
	ИспользоватьУправленческийУчетЗарплаты = глЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты");
	
	Если ИспользоватьУправленческийУчетЗарплаты Тогда
    	ГлавныйИнтерфейс.ПереключитьИнтерфейс("Полный");
	Иначе
		ГлавныйИнтерфейс.ПереключитьИнтерфейс("РегламентированныйУчет");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьВариантыАлгоритмовРасчета() Экспорт

	ПроцедурыУправленияПерсоналом.ОткрытьФормуНастройкаПараметровУчета("АлгоритмыРасчетов");	

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ УПРАВЛЕНИЯ СПИСКАМИ ЖУРНАЛОВ ДОКУМЕНТОВ

Процедура УстановитьРежимРаботыЖурналаУправленческихДокументов(Форма, ЖурналДокументов) Экспорт
	
	ВосстановленноеЗначение = ВосстановитьЗначение(Метаданные.НайтиПоТипу(Тип(ЖурналДокументов)).Имя + "ПоказыватьПоОрганизациям");
	ПоказыватьПоОрганизациям = ?(ВосстановленноеЗначение = Неопределено, Истина, ВосстановленноеЗначение);
	Форма.ПоказыватьПоОрганизациям = ПоказыватьПоОрганизациям;
	
	// колонка Организация есть во всех журналах
	Форма.ВидимостьРегламентированныхКолонок.Вставить("Организация");
	
	Для каждого ВидимостьРегламентированнойКолонки Из Форма.ВидимостьРегламентированныхКолонок Цикл
		Форма.ВидимостьРегламентированныхКолонок[ВидимостьРегламентированнойКолонки.Ключ] = ПоказыватьПоОрганизациям И Форма.ЭлементыФормы.ЖурналДокументовСписок.Колонки[ВидимостьРегламентированнойКолонки.Ключ].Видимость;
	КонецЦикла;
	
	УстановитьОтборПоУправленческимДокументам(Форма, ЖурналДокументов);
	
КонецПроцедуры

Процедура СохранитьРежимРаботыЖурналаУправленческихДокументов(Форма, ЖурналДокументов) Экспорт
	
	СохранитьЗначение(Метаданные.НайтиПоТипу(Тип(ЖурналДокументов)).Имя + "ПоказыватьПоОрганизациям", Форма.ПоказыватьПоОрганизациям);
	
КонецПроцедуры

Процедура УстановитьОтборПоУправленческимДокументам(Форма, ЖурналДокументовСписок) Экспорт
	
	ПоказыватьПоОрганизациям  = Форма.ПоказыватьПоОрганизациям;
	
	Если НЕ ПоказыватьПоОрганизациям Тогда
		
		// определяем список ответственных из управленческих документов
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ДокументыЖурнала.УпрОтветственный
		|ИЗ
		|	ЖурналДокументов." + Метаданные.НайтиПоТипу(Тип(ЖурналДокументовСписок)).Имя + " КАК ДокументыЖурнала";
		
		Выборка = Запрос.Выполнить().Выбрать(); 
		
		ПолныйСписокУпрОтветственных = Новый СписокЗначений;
		Пока Выборка.Следующий() Цикл
			ПолныйСписокУпрОтветственных.Добавить(Выборка.УпрОтветственный);
		КонецЦикла;
		
		// устанавливаем отбор по списку ответственных
		ЖурналДокументовСписок.Отбор.УпрОтветственный.ВидСравнения 	= ВидСравнения.ВСписке;
		ЖурналДокументовСписок.Отбор.УпрОтветственный.Значение 		= ПолныйСписокУпрОтветственных;
		ЖурналДокументовСписок.Отбор.УпрОтветственный.Использование = Истина;
		
	Иначе
		
		ЖурналДокументовСписок.Отбор.УпрОтветственный.Использование = Ложь;
		
	КонецЕсли;	
	
	
	// определяем видимость регламентированных колонок
	Для каждого ВидимостьРегламентированнойКолонки Из Форма.ВидимостьРегламентированныхКолонок Цикл
		
		РегламентированнаяКолонка = Форма.ЭлементыФормы.ЖурналДокументовСписок.Колонки[ВидимостьРегламентированнойКолонки.Ключ];
		Если ПоказыватьПоОрганизациям Тогда
			РегламентированнаяКолонка.Видимость = ВидимостьРегламентированнойКолонки.Значение;
		Иначе	
			Форма.ВидимостьРегламентированныхКолонок[ВидимостьРегламентированнойКолонки.Ключ] = РегламентированнаяКолонка.Видимость;
			РегламентированнаяКолонка.Видимость = Ложь;
		КонецЕсли;
		
		// видимостью колонок пользователь может управлять только в режиме "Данные по организациям"
		РегламентированнаяКолонка.ИзменятьВидимость = ПоказыватьПоОрганизациям;
		
	КонецЦикла;
	
	// устанавливаем пометку на кнопке
	Форма.ЭлементыФормы.ДействияФормы.Кнопки.ПоказыватьПоОрганизациям.Пометка = ПоказыватьПоОрганизациям;
	
КонецПроцедуры

// Процедура "расширяет" значение отбора значением из вновь записанного документа
//
Процедура ПересмотретьОтборУправленческихДокументов(ЖурналДокументов, Ответственный, ДокументСсылка) Экспорт
	
	Если Метаданные.НайтиПоТипу(Тип(ЖурналДокументов)).РегистрируемыеДокументы.Содержит(ДокументСсылка.Метаданные()) Тогда
		СписокУпрОтветственных = ЖурналДокументов.Отбор.УпрОтветственный.Значение;
		Если СписокУпрОтветственных.НайтиПоЗначению(Ответственный) = Неопределено Тогда
			ЖурналДокументов.Отбор.УпрОтветственный.Использование = Ложь;
			СписокУпрОтветственных.Добавить(Ответственный);
			ЖурналДокументов.Отбор.УпрОтветственный.Значение = СписокУпрОтветственных;
			ЖурналДокументов.Отбор.УпрОтветственный.Использование = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьОтборСпискаДокументаСуществующегоВДвухУчетах(Форма) Экспорт
	
	ПараметрТекущаяСтрока = Форма.ПараметрТекущаяСтрока;
	Если ПараметрТекущаяСтрока <> Неопределено И ОбщегоНазначенияЗК.ПолучитьЗначениеРеквизита(ПараметрТекущаяСтрока, "ОтражатьВУправленческомУчете") Тогда
		// список открывается "по просьбе" управленческого документа, отбор по организации не нужен
		ЭлементыФормы = Форма.ЭлементыФормы;
		ЭлементыФормы.ДокументСписок.Колонки.Организация.Видимость = Ложь;
		ЭлементыФормы.ПанельОтборПоОрганизации.Свертка = РежимСверткиЭлементаУправления.Верх;
		Форма.ДокументСписок.Отбор.ОтражатьВУправленческомУчете.Установить(Истина);
	Иначе
		РаботаСДиалогамиЗК.НастроитьОтборПоОрганизации(Форма, "ДокументСписок");
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////

// Процедура устанавливает видимость реквизитов в зависимости от типа учета
//
//		Параметры:
//
//
Процедура ВидимостьРеквизитовПоТипуУчета(ДокументОбъект, ФормаДокумента, Знач РеквизитыУпрУчета, Знач РеквизитыБухУчета, Знач РеквизитыНалУчета = "") Экспорт

	СтрРеквУпр = СтрЗаменить(РеквизитыУпрУчета, " ", "");
	СтрРеквУпр = СтрЗаменить(СтрРеквУпр, Символы.ПС,  "");
	СтрРеквУпр = СтрЗаменить(СтрРеквУпр, Символы.Таб, "");
	
	Пока Не ПустаяСтрока(СтрРеквУпр) Цикл
		
		Поз = Найти(СтрРеквУпр, ",");
		Если Поз = 0 Тогда
			ИмяРекв    = СтрРеквУпр;
			СтрРеквУпр = "";
		Иначе
			ИмяРекв    = Лев (СтрРеквУпр, Поз - 1);
			СтрРеквУпр = Сред(СтрРеквУпр, Поз + 1);
		КонецЕсли;
		Если ПустаяСтрока(ИмяРекв) Тогда
			Продолжить;
		КонецЕсли;
		
		Поз = Найти(ИмяРекв, ".");
		Если Поз = 0 Тогда
			ФормаДокумента.ЭлементыФормы[ИмяРекв].Видимость = ДокументОбъект.ОтражатьВУправленческомУчете;
		Иначе
			ФормаДокумента.ЭлементыФормы[Лев(ИмяРекв, Поз - 1)].Колонки[Сред(ИмяРекв, Поз + 1)].Видимость = ДокументОбъект.ОтражатьВУправленческомУчете;
		КонецЕсли;
		
	КонецЦикла;
	
	СтрРеквБух = СтрЗаменить(РеквизитыБухУчета, " ", "");
	СтрРеквБух = СтрЗаменить(СтрРеквБух, Символы.ПС,  "");
	СтрРеквБух = СтрЗаменить(СтрРеквБух, Символы.Таб, "");
	Пока Не ПустаяСтрока(СтрРеквБух) Цикл
		
		Поз = Найти(СтрРеквБух, ",");
		Если Поз = 0 Тогда
			ИмяРекв    = СтрРеквБух;
			СтрРеквБух = "";
		Иначе
			ИмяРекв    = Лев (СтрРеквБух, Поз - 1);
			СтрРеквБух = Сред(СтрРеквБух, Поз + 1);
		КонецЕсли;
		Если ПустаяСтрока(ИмяРекв) Тогда
			Продолжить;
		КонецЕсли;
		
		Поз = Найти(ИмяРекв, ".");
		Если Поз = 0 Тогда
			ФормаДокумента.ЭлементыФормы[ИмяРекв].Видимость = ДокументОбъект.ОтражатьВБухгалтерскомУчете;
		Иначе
			ФормаДокумента.ЭлементыФормы[Лев(ИмяРекв, Поз - 1)].Колонки[Сред(ИмяРекв, Поз + 1)].Видимость = ДокументОбъект.ОтражатьВБухгалтерскомУчете;
		КонецЕсли;
		
	КонецЦикла;
	
	СтрРеквНал = СтрЗаменить(РеквизитыНалУчета, " ", "");
	СтрРеквНал = СтрЗаменить(СтрРеквНал, Символы.ПС,  "");
	СтрРеквНал = СтрЗаменить(СтрРеквНал, Символы.Таб, "");
	Пока Не ПустаяСтрока(СтрРеквНал) Цикл
		
		Поз = Найти(СтрРеквНал, ",");
		Если Поз = 0 Тогда
			ИмяРекв    = СтрРеквНал;
			СтрРеквНал = "";
		Иначе
			ИмяРекв    = Лев (СтрРеквНал, Поз - 1);
			СтрРеквНал = Сред(СтрРеквНал, Поз + 1);
		КонецЕсли;
		Если ПустаяСтрока(ИмяРекв) Тогда
			Продолжить;
		КонецЕсли;
		
		Поз = Найти(ИмяРекв, ".");
		Если Поз = 0 Тогда
			ФормаДокумента.ЭлементыФормы[ИмяРекв].Видимость = ДокументОбъект.ОтражатьВНалоговомУчете;
		Иначе
			ФормаДокумента.ЭлементыФормы[Лев(ИмяРекв, Поз - 1)].Колонки[Сред(ИмяРекв, Поз + 1)].Видимость = ДокументОбъект.ОтражатьВНалоговомУчете;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ВидимостьРеквизитовПоТипуУчета()


// Формирует представление переданного способа отражения с "предметной" точки зрения
//
// Параметры
//  СпособОтраженияВУпручете -	СправочникСсылка.СпособыОтраженияЗарплатыВУпрУчете - описываемый
//								способ отражения
//
// Возвращаемое значение:
//   строка - сформированное представление
//
Функция ПолучитьПредставлениеСпособаОтраженияНачисленияВУпрУчете(СпособОтраженияВУпручете) Экспорт
	
	Если СпособОтраженияВУпручете.Пустая() Тогда
		РасшифровкаТекст = "Способ отражения определяется по данным о работнике и его плановых начислениях";
	ИначеЕсли СпособОтраженияВУпручете = Справочники.СпособыОтраженияЗарплатыВУпрУчете.НеОтражатьВУпручете Тогда
		РасшифровкаТекст = "Начисление не отражается в управленческом учете";
	Иначе
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка",	СпособОтраженияВУпручете);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СпособыОтраженияЗарплатыВУпрУчете.СтатьяЗатрат,
		|	СпособыОтраженияЗарплатыВУпрУчете.НоменклатурнаяГруппа,
		|	СпособыОтраженияЗарплатыВУпрУчете.ОбъектСтроительства
		|ИЗ
		|	Справочник.СпособыОтраженияЗарплатыВУпрУчете КАК СпособыОтраженияЗарплатыВУпрУчете
		|ГДЕ
		|	СпособыОтраженияЗарплатыВУпрУчете.Ссылка = &Ссылка";
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		РасшифровкаТекст = "Управленческий учет: ";
		Если Выборка.СтатьяЗатрат.Пустая() Тогда
			РасшифровкаТекст = РасшифровкаТекст + "статья затрат <не указана>";
		Иначе
			РасшифровкаТекст = РасшифровкаТекст + "статья затрат " + Выборка.СтатьяЗатрат;
		КонецЕсли;
		Если Выборка.НоменклатурнаяГруппа.Пустая() Тогда
			РасшифровкаТекст = РасшифровкаТекст + "; номенклатурная группа <не указана>";
		Иначе
			РасшифровкаТекст = РасшифровкаТекст + "; номенклатурная группа " + Выборка.НоменклатурнаяГруппа;
		КонецЕсли;
		Если Выборка.ОбъектСтроительства.Пустая() Тогда
			РасшифровкаТекст = РасшифровкаТекст + "; объект строительства <не указан>";
		Иначе
			РасшифровкаТекст = РасшифровкаТекст + "; объект строительства " + Выборка.ОбъектСтроительства;
		КонецЕсли;
	КонецЕсли;
	
	Возврат РасшифровкаТекст;
	
КонецФункции // ПолучитьПредставлениеСпособаОтраженияНачисленияВУчетах()

// Функция определеяте, по статье затрат, относится способ отражения к ЕНВД или нет
//
// Параметры
//  <СпособОтраженияВБухучете>  – <СправочникСсылка.СпособыОтраженияЗарплатыВРеглУчете> – способ отражения который проверяем
// Возвращаемое значение:
//   Истина   – когда статья затрат относится к ЕНВД
//   Ложь     - когда статья затрат не относится у ЕНВД
//   Неопределено - когда способ отражения не содержит субконто - Статьи затрат
//   NULL     - когда у способа отражения пустой счет Дт или Кт
//
Функция СтатьяЗатратСпособаОтраженияОтноситсяКЕНВД(СпособОтраженияВБухучете) Экспорт

	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА СчетаУчетаПоДеятельностиЕНВД.Счет ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЭтоЕНВД
	|ИЗ
	|	Справочник.СпособыОтраженияЗарплатыВРеглУчете КАК СпособыОтраженияЗарплатыВРеглУчете
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаУчетаПоДеятельностиЕНВД КАК СчетаУчетаПоДеятельностиЕНВД
	|		ПО СпособыОтраженияЗарплатыВРеглУчете.СчетДт = СчетаУчетаПоДеятельностиЕНВД.Счет
	|ГДЕ
	|	СпособыОтраженияЗарплатыВРеглУчете.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",СпособОтраженияВБухучете);
	Запрос.Текст = ТекстЗапроса;
	ВыборкаИзЗапроса = Запрос.Выполнить().Выбрать();
	ВыборкаИзЗапроса.Следующий();
	
	Возврат ВыборкаИзЗапроса.ЭтоЕНВД;
	

КонецФункции // ПроверитьСтатьюЗатаратСпособаОтражения()

////////////////////////////////////////////////////////////////////////////////
// управление доступностью ввода на основании в документе Планирование отпуска
	
Процедура УстановитьДоступностьВводаНаОснованииДокументаПланированиеОтпуска(ЭлементыФормы) Экспорт
	
	ДоступностьКоманд = Новый Соответствие;
	ДоступностьКоманд.Вставить("ГрафикОтпусковОрганизацийВводНаОсновании", ПравоДоступа("Использование", Метаданные.Обработки.ВводРегламентированныхКадровыхДокументовНаОсновании));
	ДоступностьКоманд.Вставить("ОтсутствиеНаРабочемМесте", ПравоДоступа("ИнтерактивноеДобавление", Метаданные.Документы.ОтсутствияНаРабочемМесте));
	
	КоллекцииКнопок = Новый Массив;
	КоллекцииКнопок.Добавить(ЭлементыФормы.ДействияФормы.Кнопки.ПодменюВводНаОсновании.Кнопки);
	КоллекцииКнопок.Добавить(ЭлементыФормы.ДействияФормы.Кнопки.ПодменюДействия.Кнопки.ПодменюВводНаОсновании.Кнопки);
	
	Для Каждого Кнопки Из КоллекцииКнопок Цикл
		Для Каждого ДоступностьКоманды Из ДоступностьКоманд Цикл
			Если Кнопки.Найти(ДоступностьКоманды.Ключ) <> Неопределено Тогда
				Кнопки[ДоступностьКоманды.Ключ].Доступность = ДоступностьКоманды.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

// Открытие кассовых и банковских документов с отбором по операциям функциональности ЗУП
Функция УстановитьФормуДокументаСОтбором(ЭлементИмя)
	
	ИмяОбъектаМетаданных = РабочийСтол.ОтсечьЦифры(ЭлементИмя);
	Форма = Документы[ИмяОбъектаМетаданных].ПолучитьФормуСписка();
	
	Форма.Отбор.ВидОперации.Использование = Истина;
	Форма.Отбор.ВидОперации.ВидСравнения = ВидСравнения.ВСписке;
	СписокЗначенийОтбора = Новый СписокЗначений;
	Если ИмяОбъектаМетаданных = "РасходныйКассовыйОрдер" Тогда
	
		СписокЗначенийОтбора.Добавить(Перечисления.ВидыОперацийРКО.ВыплатаЗаработнойПлатыПоВедомостям);
		СписокЗначенийОтбора.Добавить(Перечисления.ВидыОперацийРКО.ВыплатаЗаработнойПлатыРаботнику);
		СписокЗначенийОтбора.Добавить(Перечисления.ВидыОперацийРКО.ВыплатаДепонентов);
	
	ИначеЕсли  ИмяОбъектаМетаданных = "ПриходныйКассовыйОрдер" Тогда
		СписокЗначенийОтбора.Добавить(Перечисления.ВидыОперацийПКО.РасчетыПоКредитамИЗаймамСРаботниками);
		СписокЗначенийОтбора.Добавить(Перечисления.ВидыОперацийПКО.ВозвратДенежныхСредствРаботником);
	ИначеЕсли  ИмяОбъектаМетаданных = "ПлатежноеПоручениеИсходящее" Тогда
		СписокЗначенийОтбора.Добавить(Перечисления.ВидыОперацийППИсходящее.ПеречислениеЗП);
	ИначеЕсли  ИмяОбъектаМетаданных = "ПлатежныйОрдерСписаниеДенежныхСредств" Тогда
		СписокЗначенийОтбора.Добавить(Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПеречислениеЗП);
	КонецЕсли; 
	Форма.Отбор.ВидОперации.Значение = СписокЗначенийОтбора;
	
	Возврат Форма
	
КонецФункции

// Регл учет
Процедура РКОРеглОткрытьСписокДокументов() Экспорт

	ОткрытьКассовыйДокументРеглУчете("РасходныйКассовыйОрдер")	

КонецПроцедуры // РКОРеглОткрытьСписокДокументов()

Процедура ПКОРеглОткрытьСписокДокументов() Экспорт

	ОткрытьКассовыйДокументРеглУчете("ПриходныйКассовыйОрдер")	

КонецПроцедуры // ПКОРеглОткрытьСписокДокументов()

Процедура ПлатежноеПоручениеИсходящееОткрытьСписокДокументов() Экспорт

	ОткрытьДокументПоБанку("ПлатежноеПоручениеИсходящее")	

КонецПроцедуры // ПлатежноеПоручениеИсходящееОткрытьСписокДокументов()

Процедура ПлатежныйОрдерСписаниеДенежныхСредствОткрытьСписокДокументов() Экспорт

	ОткрытьДокументПоБанку("ПлатежныйОрдерСписаниеДенежныхСредств")	

КонецПроцедуры // ПлатежныйОрдерСписаниеДенежныхСредствОткрытьСписокДокументов()

Процедура ОткрытьКассовыйДокументРеглУчете(ЭлементИмя)Экспорт
	
	Форма = УстановитьФормуДокументаСОтбором(ЭлементИмя);
	Форма.Отбор.ОтражатьВБухгалтерскомУчете.Установить(Истина);
	
	Форма.Открыть();
	
КонецПроцедуры // ОткрытьКассовыйДокументРеглУчете()

// Упр учет

Процедура РКОУпрОткрытьСписокДокументов() Экспорт

	ОткрытьКассовыйДокументУпрУчете("РасходныйКассовыйОрдер")	

КонецПроцедуры // РКОУпрОткрытьСписокДокументов()

Процедура ПКОУпрОткрытьСписокДокументов() Экспорт

	ОткрытьКассовыйДокументУпрУчете("ПриходныйКассовыйОрдер")	

КонецПроцедуры // ПКОУпрОткрытьСписокДокументов()

Процедура ОткрытьКассовыйДокументУпрУчете(ЭлементИмя) Экспорт
	
	Форма = УстановитьФормуДокументаСОтбором(ЭлементИмя);
	Форма.Отбор.ОтражатьВУправленческомУчете.Установить(Истина);
	
	Форма.Открыть();
	
КонецПроцедуры // ОткрытьКассовыйДокументУпрУчете()

Процедура ОткрытьДокументПоБанку(ЭлементИмя)Экспорт
	
	Форма = УстановитьФормуДокументаСОтбором(ЭлементИмя);
	
	Форма.Открыть();
	
КонецПроцедуры // ОткрытьДокументПоБанку()
