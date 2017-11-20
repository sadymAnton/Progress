﻿
Функция ТипыПоказателейСОграничениемВида()
	
	ТипыПоказателей = Новый Массив;
	
	ПоказателиСхемМотивацииПереопределяемый.ДополнитьТипыПоказателейСОграничениемВида(ТипыПоказателей);
	
	Возврат ТипыПоказателей;
	
КонецФункции // ТипыПоказателейСОграничениемВида

Функция ТипыПоказателейСОграничениемВозможностиИзменения()
	
	ТипыПоказателей = Новый Массив;
	
	ТипыПоказателей.Добавить(Перечисления.ТипыПоказателейСхемМотивации.ТарифныйРазряд);
	
	ПоказателиСхемМотивацииПереопределяемый.ДополнитьТипыПоказателейСОграничениемВозможностиИзменения(ТипыПоказателей);
	
	Возврат ТипыПоказателей;
	
КонецФункции // ТипыПоказателейСОграничениемВозможностиИзменения

Функция ПоказателиУчетаВремени() Экспорт
	
	Показатели = Новый Массив;
	
	Показатели.Добавить(Справочники.ПоказателиСхемМотивации.ВремяВДнях);
	Показатели.Добавить(Справочники.ПоказателиСхемМотивации.ВремяВКалендарныхДнях);
	Показатели.Добавить(Справочники.ПоказателиСхемМотивации.ВремяВЧасах);
	Показатели.Добавить(Справочники.ПоказателиСхемМотивации.КалендарныхДнейВмесяце);
	Показатели.Добавить(Справочники.ПоказателиСхемМотивации.НормаВремениВДнях);
	Показатели.Добавить(Справочники.ПоказателиСхемМотивации.НормаВремениВЧасах);
	Показатели.Добавить(Справочники.ПоказателиСхемМотивации.ОтработаноВремениВДнях);
	Показатели.Добавить(Справочники.ПоказателиСхемМотивации.ОтработаноВремениВЧасах);
	
	ПоказателиСхемМотивацииПереопределяемый.ДополнитьПоказателиУчетаВремени(Показатели);
	
	Возврат Показатели;
	
КонецФункции // ПоказателиУчетаВремени

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы элемента

Функция ПроверкаНаДублированиеИдентификатора(Отказ, ЭтотОбъект)

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПоказателиСхемМотивации.Идентификатор
	|ИЗ
	|	Справочник.ПоказателиСхемМотивации КАК ПоказателиСхемМотивации
	|ГДЕ
	|	ПоказателиСхемМотивации.Идентификатор = &Идентификатор
	|	И ПоказателиСхемМотивации.Ссылка <> &Ссылка");
	
	Запрос.УстановитьПараметр("Идентификатор", ЭтотОбъект.Идентификатор);
	Запрос.УстановитьПараметр("Ссылка", ЭтотОбъект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Отказ = Выборка.Количество()>0;
	
	Если Отказ Тогда
		ОбщегоНазначенияЗК.СообщитьОбОшибке("Показатель с таким идентификатором уже существует!", Отказ);
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

Процедура ПроверитьЗаполнениеПоказателя(Отказ, ЭтаФорма)
	
	Идентификатор 		= ЭтаФорма.Идентификатор;
	Предопределенный	= ЭтаФорма.Предопределенный;
	ТипПоказателя		= ЭтаФорма.ТипПоказателя;
	ВозможностьИзменения= ЭтаФорма.ВозможностьИзменения;
	ВидПоказателя		= ЭтаФорма.ВидПоказателя;
	
	Если НЕ ЗначениеЗаполнено(ЭтаФорма.Наименование) Тогда
		Отказ = Истина;
		ОбщегоНазначенияЗК.СообщитьОбОшибке("Необходимо задать наименование показателя!", Отказ);
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(Идентификатор) Тогда
		Отказ = Истина;
		ОбщегоНазначенияЗК.СообщитьОбОшибке("Необходимо задать идентификатор показателя!", Отказ);
	Иначе
		Разделители	= " .,+,-,/,*,?,=,<,>,(,)%!@#$%&*""№:;{}[]?()\|/`~'^_";
		Для НомСимвола = 1 По СтрДлина(Идентификатор) Цикл
			Символ = Сред(Идентификатор,НомСимвола,1);
			НомерСимвола = Найти(Разделители, Символ);
			Если НомерСимвола <> 0 Тогда
				Отказ = Истина;
				ОбщегоНазначенияЗК.СообщитьОбОшибке("Идентификатор показателя не должен содержать символ: """+Сред(Разделители,НомерСимвола,1) + """", Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не Предопределенный Тогда
		
		Если НЕ ЗначениеЗаполнено(ТипПоказателя) Тогда
			Отказ = Истина;
			ОбщегоНазначенияЗК.СообщитьОбОшибке("Необходимо задать тип показателя!", Отказ);
		КонецЕсли;
		
		Если ТипПоказателя <> Перечисления.ТипыПоказателейСхемМотивации.Стаж И НЕ ЗначениеЗаполнено(ВозможностьИзменения) И НЕ (ПоказателиСхемМотивацииПереопределяемый.ДопустимыйТипПоказателя(ТипПоказателя)) Тогда
			Отказ = Истина;
			ОбщегоНазначенияЗК.СообщитьОбОшибке("Необходимо задать порядок ввода показателя!", Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ВидПоказателя) Тогда
			Отказ = Истина;
			ОбщегоНазначенияЗК.СообщитьОбОшибке("Необходимо задать назначение показателя!", Отказ);
		КонецЕсли;
		
		ПоказателиСхемМотивацииПереопределяемый.ВыполнитьДополнительныеПроверки(Отказ, ЭтаФорма);
		
	КонецЕсли;
	
	
КонецПроцедуры //ПроверитьЗаполнениеПоказателя

Процедура ПолучитьИдентификатор(СтрНаименование, Идентификатор)
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Разделители	=  " .,+,-,/,*,?,=,<,>,(,)%!@#$%&*""№:;{}[]?()\|/`~'^_";
		
		Идентификатор = "";
		БылСпецСимвол = Ложь;
		Для НомСимвола = 1 По СтрДлина(СтрНаименование) Цикл
			Символ = Сред(СтрНаименование,НомСимвола,1);
			Если Найти(Разделители, Символ) <> 0 Тогда
				БылСпецСимвол = Истина;
			ИначеЕсли БылСпецСимвол Тогда
				БылСпецСимвол = Ложь;
				Идентификатор = Идентификатор + ВРег(Символ);
			Иначе
				Идентификатор = Идентификатор + Символ;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры //ПолучитьИдентификатор

Процедура УстановитьДоступныеДляВводаНазначения(ЭтаФорма)
	
	// Доступные значения реквизита "ВозможностьИзменения"
	СписокВозможностейИзменения = Новый СписокЗначений;
	
	ПоказателиСхемМотивацииПереопределяемый.ДополнитьСписокВозможностейИзменения(СписокВозможностейИзменения, ЭтаФорма);
	
	Если ЭтаФорма.ВидПоказателя <> Перечисления.ВидыПоказателейСхемМотивации.Индивидуальный Тогда
		СписокВозможностейИзменения.Добавить(Перечисления.ИзменениеПоказателейСхемМотивации.Периодически);
	Иначе
		СписокВозможностейИзменения.Добавить(Перечисления.ИзменениеПоказателейСхемМотивации.НеИзменяется);
	КонецЕсли;
	
	ЭтаФорма.ЭлементыФормы.ВозможностьИзменения.ДоступныеЗначения = СписокВозможностейИзменения;

КонецПроцедуры

Функция ЭтоШкала(ТипПоказателя) Экспорт
	
	Возврат ТипПоказателя = Перечисления.ТипыПоказателейСхемМотивации.ОценочнаяШкалаЧисловая Или ТипПоказателя = Перечисления.ТипыПоказателейСхемМотивации.ОценочнаяШкалаПроцентная;
	
КонецФункции

Процедура ПроверкаТарифнойСтавки(ТипПоказателя, ВозможностьИзменения, ТарифнаяСтавка) Экспорт
	
	ПоказательЭтоШкала = ЭтоШкала(ТипПоказателя);
	
	Если ТарифнаяСтавка И ВозможностьИзменения <> Перечисления.ИзменениеПоказателейСхемМотивации.НеИзменяется ИЛИ ПоказательЭтоШкала Или ТипПоказателя = Перечисления.ТипыПоказателейСхемМотивации.Процентный Тогда
		ТарифнаяСтавка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаЭлементаУстановитьДоступностьЭУ(ЭтаФорма) Экспорт
	
	ЭлементыФормы 		= ЭтаФорма.ЭлементыФормы;	
	Предопределенный	= ЭтаФорма.Предопределенный;
 	ТипПоказателя		= ЭтаФорма.ТипПоказателя;
 	ВозможностьИзменения= ЭтаФорма.ВозможностьИзменения;
	ВидПоказателя		= ЭтаФорма.ВидПоказателя;
	
	ПоказательЭтоШкала = ЭтоШкала(ТипПоказателя);
	
	ЭлементыФормы.ТипПоказателя.ТолькоПросмотр				= Предопределенный;
	ЭлементыФормы.ТипПоказателя.АвтоОтметкаНезаполненного	= Не (Предопределенный Или ЗначениеЗаполнено(ТипПоказателя));
	ЭлементыФормы.ТипПоказателя.ОтметкаНезаполненного		= Не (Предопределенный Или ЗначениеЗаполнено(ТипПоказателя));
	
	ЭлементыФормы.ВидПоказателя.ТолькоПросмотр				= Предопределенный Или ПоказательЭтоШкала Или ТипыПоказателейСОграничениемВида().Найти(ТипПоказателя) <> Неопределено;
	ЭлементыФормы.ВидПоказателя.АвтоОтметкаНезаполненного	= Не ПоказательЭтоШкала;	
	ЭлементыФормы.ВидПоказателя.ОтметкаНезаполненного		= Не (ПоказательЭтоШкала Или ЗначениеЗаполнено(ВидПоказателя) Или Предопределенный);
	
	ЭлементыФормы.ВозможностьИзменения.ТолькоПросмотр			= Предопределенный Или ПоказательЭтоШкала Или ТипыПоказателейСОграничениемВозможностиИзменения().Найти(ТипПоказателя) <> Неопределено;
	ЭлементыФормы.ВозможностьИзменения.АвтоОтметкаНезаполненного= Не ПоказательЭтоШкала;
	ЭлементыФормы.ВозможностьИзменения.ОтметкаНезаполненного	= Не (ПоказательЭтоШкала Или ЗначениеЗаполнено(ВозможностьИзменения) Или Предопределенный);
	
	ЭлементыФормы.ТарифнаяСтавка.Доступность = Не Предопределенный;
	
	ЭлементыФормы.ПанельДанных.Страницы.ШкалаОценки.Видимость = ПоказательЭтоШкала;

КонецПроцедуры

Процедура ФормаЭлементаУстановитьВозможностьИзменения(Значение, ЭтаФорма) Экспорт
	
	ВозможностьИзменения= ЭтаФорма.ВозможностьИзменения;
	
	Если (Значение = Перечисления.ВидыПоказателейСхемМотивации.Общий Или Значение = Перечисления.ВидыПоказателейСхемМотивации.ПоПодразделению) И
	ВозможностьИзменения <> Перечисления.ИзменениеПоказателейСхемМотивации.Ежемесячно Тогда
		ВозможностьИзменения = Перечисления.ИзменениеПоказателейСхемМотивации.Ежемесячно;
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаЭлементаПриОткрытии(ЭтаФорма) Экспорт
	
	СоставШкалы 	= ЭтаФорма.СоставШкалы;
	ЭлементыФормы 	= ЭтаФорма.ЭлементыФормы;
	
	СоставШкалы.Отбор.ШкалаОценкиПоказателя.Значение = ЭтаФорма.Ссылка;
	СоставШкалы.Отбор.ШкалаОценкиПоказателя.Использование = Истина;	
	СоставШкалы.Прочитать();
	
	Если ЭтаФорма.ТарифнаяСтавка Тогда
		Расшифровка = "Однажды введенное в кадровом документе значение такого показателя может быть использовано несколькими плановыми начислениями (удержаниями) работника"
	ИначеЕсли Не ЭтаФорма.Предопределенный Тогда 
		Расшифровка = "Если в начислении (удержании) для данного показателя указано, что его нужно запрашивать при вводе, то значение показателя используется только тем начислением (удержанием), для которого оно установлено кадровым документом." + Символы.ПС + "Если же в начислении (удержании) для данного показателя указано, что его не нужно запрашивать при вводе, то показатель будет браться из тех кадровых документов, в которых есть начисление, где данный показатель запрашивается";		
	Иначе
		Расшифровка = "Значение показателя рассчитывается автоматически для каждой строки начислений (удержаний)"
	КонецЕсли;
    ЭлементыФормы.НадписьРасшифровкаТарифнаяСтавка.Заголовок = Расшифровка;
	ЭлементыФормы.НадписьРасшифровкаТарифнаяСтавкаВалюта.Заголовок = Расшифровка;
	
	Если ЭтаФорма.Ссылка = Справочники.ПоказателиСхемМотивации.Стаж Тогда
		ЭлементыФормы.НадписьРасшифровкаСтажа.Заголовок = "Значением данного показателя будет являться количество месяцев с момента приема на работу сотрудника по месяц расчета заработной платы.";
	Иначе
		ЭлементыФормы.НадписьРасшифровкаСтажа.Заголовок = "Значением данного показателя будет являться стаж вида: """ + ЭтаФорма.ВидСтажа + """";
	КонецЕсли;
	
	УстановитьДоступныеДляВводаНазначения(ЭтаФорма);
	
КонецПроцедуры

Процедура ФормаЭлементаПриЗаписи(Отказ, ЭтаФорма) Экспорт
	
	Если ЭтаФорма.СоставШкалы.Модифицированность() Тогда
		ЭтаФорма.СоставШкалы.Отбор.ШкалаОценкиПоказателя.Значение = ЭтаФорма.Ссылка;
		Для Каждого Строка Из ЭтаФорма.СоставШкалы Цикл
			Строка.НомерСтрокиШкалы = ЭтаФорма.СоставШкалы.Индекс(Строка) + 1;
			Строка.ШкалаОценкиПоказателя = ЭтаФорма.Ссылка;
			Если Строка.ЗначениеПо < Строка.ЗначениеС Тогда
				ОбщегоНазначенияЗК.СообщитьОбОшибке("Диапазон значений шкалы оценок задан неверно (см. строку " + Строка.НомерСтрокиШкалы + ")!", Отказ);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не Отказ Тогда
			ЭтаФорма.СоставШкалы.Записать();
			ПоказателиСхемМотивацииПереопределяемый.ОбновитьФормулыПВРсПоказателямиШкала(ЭтаФорма.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	ПроверитьЗаполнениеПоказателя(Отказ, ЭтаФорма);
	
	Если Не Отказ Тогда
		ПроверкаНаДублированиеИдентификатора(Отказ, ЭтаФорма.ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

Процедура ФормаЭлементаПослеЗаписи(ЭтаФорма) Экспорт
		
	Оповестить("ЗаписанНовыйПоказатель");
	
КонецПроцедуры

Процедура ФормаЭлементаПередЗаписью(Отказ, ЭтаФорма) Экспорт
	
	НовыйОбъект =  ЭтаФорма.ЭтоНовый();
	
	Если ЭтаФорма.ТипПоказателя <> Перечисления.ТипыПоказателейСхемМотивации.Денежный Тогда
		ЭтаФорма.Валюта = Справочники.Валюты.ПустаяСсылка()
	КонецЕсли;	

КонецПроцедуры

Процедура ФормаЭлементаНаименованиеПриИзменении(Элемент, ЭтаФорма) Экспорт
	
	ПолучитьИдентификатор(Элемент.Значение, ЭтаФорма.Идентификатор);
	
КонецПроцедуры

Процедура ФормаЭлементаТарифнаяСтавкаПриИзменении(Элемент, ЭтаФорма) Экспорт
	
	Если ЭтаФорма.ТарифнаяСтавка Тогда
		Расшифровка = "Однажды введенное в кадровом документе значение такого показателя может быть использовано несколькими плановыми начислениями (удержаниями) работника"
	Иначе 
		Расшифровка = "Если в начислении (удержании) для данного показателя указано, что его нужно запрашивать при вводе, то значение показателя используется только тем начислением (удержанием), для которого оно установлено кадровым документом." + Символы.ПС + "Если же в начислении (удержании) для данного показателя указано, что его не нужно запрашивать при вводе, то показатель будет браться из тех кадровых документов, в которых есть начисление, где данный показатель запрашивается";		
	КонецЕсли;
	
	ЭтаФорма.ЭлементыФормы.НадписьРасшифровкаТарифнаяСтавка.Заголовок = Расшифровка;
	ЭтаФорма.ЭлементыФормы.НадписьРасшифровкаТарифнаяСтавкаВалюта.Заголовок = Расшифровка;
	
КонецПроцедуры

Процедура ФормаЭлементаВидПоказателяПриИзменении(Элемент, ЭтаФорма) Экспорт
	
	УстановитьДоступныеДляВводаНазначения(ЭтаФорма);
	
	ПоказателиСхемМотивацииКлиент.ПроверкаТарифнойСтавки(ЭтаФорма.ТипПоказателя, ЭтаФорма.ВозможностьИзменения, ЭтаФорма.ТарифнаяСтавка);
	
КонецПроцедуры

