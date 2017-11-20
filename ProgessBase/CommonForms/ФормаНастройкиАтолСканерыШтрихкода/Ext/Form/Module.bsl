﻿///////////////////////////////////////////////////////////////////////////////
//// БЛОК НАСТРОЙКИ ПАРАМЕТРОВ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("Идентификатор", Идентификатор);
	Заголовок = НСтр("ru='СШК'") + " """ + Строка(Идентификатор) + """";

	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СпПорт = Элементы.Порт.СписокВыбора;
	Для Индекс = 1 По 32 Цикл
		СпПорт.Добавить(Индекс, "COM" + Строка(Индекс));
	КонецЦикла;
	СпПорт.Добавить(100, НСтр("ru='Клавиатура'"));

	СпСкорость = Элементы.Скорость.СписокВыбора;
	СпСкорость.Добавить(1,  "300");
	СпСкорость.Добавить(2,  "600");
	СпСкорость.Добавить(3,  "1200");
	СпСкорость.Добавить(4,  "2400");
	СпСкорость.Добавить(5,  "4800");
	СпСкорость.Добавить(7,  "9600");
	СпСкорость.Добавить(9,  "14400");
	СпСкорость.Добавить(10, "19200");
	СпСкорость.Добавить(12, "38400");

	СпБитДанных = Элементы.БитДанных.СписокВыбора;
	СпБитДанных.Добавить(3, "7");
	СпБитДанных.Добавить(4, "8");

	СпСтопБит = Элементы.СтопБит.СписокВыбора;
	СпСтопБит.Добавить(0, 1);
	СпСтопБит.Добавить(2, 2);

	СпЧетность = Элементы.Четность.СписокВыбора;
	СпЧетность.Добавить(0, НСтр("ru='Нет'"));
	СпЧетность.Добавить(1, НСтр("ru='Нечетность'"));
	СпЧетность.Добавить(2, НСтр("ru='Четность'"));
	СпЧетность.Добавить(3, НСтр("ru='Установлен'"));
	СпЧетность.Добавить(4, НСтр("ru='Сброшен'"));

	УстановитьПараметрыШК(Элементы.Префикс);
	УстановитьПараметрыШК(Элементы.Суффикс);

	времПорт             = Неопределено;
	времСкорость         = Неопределено;
	времБитДанных        = Неопределено;
	времСтопБит          = Неопределено;
	времЧетность         = Неопределено;
	времЧувствительность = Неопределено;
	времПрефикс          = Неопределено;
	времСуффикс          = Неопределено;
	времМодель           = Неопределено;

	Параметры.Свойство("Порт"             , времПорт);
	Параметры.Свойство("Скорость"         , времСкорость);
	Параметры.Свойство("БитДанных"        , времБитДанных);
	Параметры.Свойство("СтопБит"          , времСтопБит);
	Параметры.Свойство("Четность"         , времЧетность);
	Параметры.Свойство("Чувствительность" , времЧувствительность);
	Параметры.Свойство("Префикс"          , времПрефикс);
	Параметры.Свойство("Суффикс"          , времСуффикс);
	Параметры.Свойство("Модель"           , времМодель);

	Порт             = ?(времПорт             = Неопределено,     1, времПорт);
	Скорость         = ?(времСкорость         = Неопределено,     7, времСкорость);
	БитДанных        = ?(времБитДанных        = Неопределено,     3, времБитДанных);
	СтопБит          = ?(времСтопБит          = Неопределено,     0, времСтопБит);
	Четность         = ?(времЧетность         = Неопределено,     0, времЧетность);
	Чувствительность = ?(времЧувствительность = Неопределено,    30, времЧувствительность);
	Префикс          = ?(времПрефикс          = Неопределено,    "", времПрефикс);
	Суффикс          = ?(времСуффикс          = Неопределено, "#13", времСуффикс);

	Модель = ?(времМодель = Неопределено, Элементы.Модель.СписокВыбора[0], времМодель);

	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента
	                                        = Идентификатор.РабочееМесто);

КонецПроцедуры

// Процедура - обработчик события "Перед открытием" формы.
//
// Параметры:
//  Отказ                - <Булево>
//                       - Признак отказа от открытия формы. Если в теле
//                         процедуры-обработчика установить данному параметру
//                         значение Истина, открытие формы выполнено не будет.
//                         Значение по умолчанию: Ложь 
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОбновитьИнформациюОДрайвере();

	ПортПриИзменении();

КонецПроцедуры // ПередОткрытием()

// Процедура представляет обработчик события "Нажатие" кнопки
// "ОК" командной панели.
//
//
&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	Если Суффикс <> "" Тогда
		Параметры.ПараметрыНастройки.Добавить(Порт             , "Порт");
		Параметры.ПараметрыНастройки.Добавить(Скорость         , "Скорость");
		Параметры.ПараметрыНастройки.Добавить(БитДанных        , "БитДанных");
		Параметры.ПараметрыНастройки.Добавить(СтопБит          , "СтопБит");
		Параметры.ПараметрыНастройки.Добавить(Четность         , "Четность");
		Параметры.ПараметрыНастройки.Добавить(Чувствительность , "Чувствительность");
		Параметры.ПараметрыНастройки.Добавить(Префикс          , "Префикс");
		Параметры.ПараметрыНастройки.Добавить(Суффикс          , "Суффикс");
		Параметры.ПараметрыНастройки.Добавить(Модель           , "Модель");

		ОчиститьСообщения();
		Закрыть(КодВозвратаДиалога.ОК);
	Иначе
		ТекстСообщения = НСтр("ru = 'Не указан суффикс сканера штрихкода.
		|Для идентификации штрихкода суффикс должен быть указан'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Суффикс");
	КонецЕсли;

КонецПроцедуры // ОсновныеДействияФормыОК()

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	МенеджерОборудованияКлиент.УстановитьДрайвер(Идентификатор);

	ОбновитьИнформациюОДрайвере();

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
//// ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПортПриИзменении()

	Элементы.Скорость.Доступность  = Порт <> 100;
	Элементы.БитДанных.Доступность = Порт <> 100;
	Элементы.СтопБит.Доступность   = Порт <> 100;
	Элементы.Четность.Доступность  = Порт <> 100;

КонецПроцедуры

&НаКлиенте
Процедура ПрефиксОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если ВыбранноеЗначение <> Неопределено Тогда
		Префикс = Префикс + ВыбранноеЗначение;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СуффиксОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если ВыбранноеЗначение <> Неопределено Тогда
		Суффикс = Суффикс + ВыбранноеЗначение;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПортПриИзменении1(Элемент)

	ПортПриИзменении();

КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыШК(Элемент)

	Если (Элемент.Имя = "Префикс"
	 Или Элемент.Имя = "Суффикс")
	   И Элемент.СписокВыбора.Количество() = 0 Тогда
		СпПараметрыДорожек = Элемент.СписокВыбора;

		Для КодЭлемента = 0 По 127 Цикл
			СимволДорожки = "";
			Если КодЭлемента > 32 Тогда
				СимволДорожки = " ( " + Символ(КодЭлемента) + " )";
			ИначеЕсли КодЭлемента = 8 Тогда
				СимволДорожки = " (BACKSPACE)";
			ИначеЕсли КодЭлемента = 9 Тогда
				СимволДорожки = " (TAB)";
			ИначеЕсли КодЭлемента = 10 Тогда
				СимволДорожки = " (LF)";
			ИначеЕсли КодЭлемента = 13 Тогда
				СимволДорожки = " (CR)";
			ИначеЕсли КодЭлемента = 16 Тогда
				СимволДорожки = " (SHIFT)";
			ИначеЕсли КодЭлемента = 17 Тогда
				СимволДорожки = " (CONTROL)";
			ИначеЕсли КодЭлемента = 18 Тогда
				СимволДорожки = " (ALT)";
			ИначеЕсли КодЭлемента = 27 Тогда
				СимволДорожки = " (ESCAPE)";
			ИначеЕсли КодЭлемента = 32 Тогда
				СимволДорожки = " (SPACE)";
			КонецЕсли;
			СпПараметрыДорожек.Добавить("#" + СокрЛП(КодЭлемента), "#" + СокрЛП(КодЭлемента) + СимволДорожки);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"            , Порт);
	времПараметрыУстройства.Вставить("Скорость"        , Скорость);
	времПараметрыУстройства.Вставить("БитДанных"       , БитДанных);
	времПараметрыУстройства.Вставить("СтопБит"         , СтопБит);
	времПараметрыУстройства.Вставить("Четность"        , Четность);
	времПараметрыУстройства.Вставить("Чувствительность", Чувствительность);
	времПараметрыУстройства.Вставить("Префикс"         , Префикс);
	времПараметрыУстройства.Вставить("Суффикс"         , Суффикс);
	времПараметрыУстройства.Вставить("Модель"          , Модель);

	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
		Версия  = ВыходныеПараметры[1];
	Иначе
		Драйвер = ВыходныеПараметры[2];
		Версия  = НСтр("ru='Не определена'");
	КонецЕсли;

	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);

КонецПроцедуры
