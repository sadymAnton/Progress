﻿
///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция осуществляет подключение устройства.
//
// Параметры:
//  ОбъектДрайвера   - <*>
//           - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	ПараметрыПодключения.Вставить("ИДУстройства", "");

	// Проверка настроенных параметров
	Порт              = Неопределено;
	Скорость          = Неопределено;
	Четность          = Неопределено;
	БитыДанных        = Неопределено;
	СтопБиты          = Неопределено;
	Кодировка         = Неопределено;
	ЗагружатьШрифты   = Неопределено;
	Модель            = Неопределено;
	РазмерДисплея	  = Неопределено;

	Параметры.Свойство("Порт",              Порт);
	Параметры.Свойство("Скорость",          Скорость);
	Параметры.Свойство("Четность",          Четность);
	Параметры.Свойство("БитыДанных",        БитыДанных);
	Параметры.Свойство("СтопБиты",          СтопБиты);
	Параметры.Свойство("Кодировка",         Кодировка);
	Параметры.Свойство("ЗагружатьШрифты",   ЗагружатьШрифты);
	Параметры.Свойство("Модель", 			Модель);
	Параметры.Свойство("РазмерДисплея",		РазмерДисплея);

	Если Порт              = Неопределено
	 Или Скорость          = Неопределено
	 Или Четность          = Неопределено
	 Или БитыДанных        = Неопределено
	 Или СтопБиты          = Неопределено
	 Или Кодировка         = Неопределено
	 Или ЗагружатьШрифты   = Неопределено
	 Или Модель            = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
		|Для корректной работы устройства необходимо задать параметры его работы.
		|Сделать это можно при помощи формы ""Настройка параметров"" модели
		|подключаемого оборудования в форме ""Подключение и настройка оборудования"".'"));

		Результат = Ложь;
	КонецЕсли;

	Если Результат Тогда
		ОбъектДрайвера.ДобавитьУстройство();
		Если ОбъектДрайвера.Результат = 0 Тогда
			ПараметрыПодключения.ИДУстройства = ОбъектДрайвера.НомерТекущегоУстройства;

			ОбъектДрайвера.НаименованиеТекущегоУстройства = Параметры.Модель;
			ОбъектДрайвера.Модель                         = ПолучитьКодПротокола(Параметры.Модель);
			ОбъектДрайвера.БитыДанных                     = Параметры.БитыДанных;
			ОбъектДрайвера.ЗагружатьШрифты                = Параметры.ЗагружатьШрифты;
			ОбъектДрайвера.НомерПорта                     = Параметры.Порт;
			ОбъектДрайвера.СкоростьОбмена                 = Параметры.Скорость;
			ОбъектДрайвера.СтопБиты                       = Параметры.СтопБиты;
			ОбъектДрайвера.Четность                       = Параметры.Четность;
			ОбъектДрайвера.НаборСимволов                  = Параметры.Кодировка;

			ОбъектДрайвера.УстройствоВключено = 1;
			Если ОбъектДрайвера.Результат <> 0 Тогда
				ВыходныеПараметры.Добавить(999);
				ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

				Результат = Ложь;

				ОбъектДрайвера.УдалитьУстройство();
				ПараметрыПодключения.ИДУстройства = Неопределено;
			Иначе
				КолвоСтрок	 	= ОбъектДрайвера.КолвоСтрокДисплея;
				КолвоСтолбцов	= ОбъектДрайвера.КолвоСтолбцовДисплея;
			    ОбъектДрайвера.СоздатьОкно(0, 0, КолвоСтрок + 1, КолвоСтолбцов, КолвоСтрок + 1, КолвоСтолбцов);
			КонецЕсли;
		КонецЕсли;

		Если Результат Тогда
			ОбъектДрайвера.УстройствоВключено = 1;
			Если ОбъектДрайвера.Результат <> 0 Тогда
				ВыходныеПараметры.Добавить(999);
				ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

				Результат = Ложь;

				ОбъектДрайвера.УстройствоВключено = 0;
				ОбъектДрайвера.УдалитьУстройство();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отключение устройства.
//
// Параметры:
//  ОбъектДрайвера - <*>
//         - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;
	ОбъектДрайвера.УстройствоВключено = 0;
	ОбъектДрайвера.УдалитьУстройство();

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	// Вывод строк на дисплей
	Если Команда = "ВывестиСтрокуНаДисплейПокупателя" ИЛИ Команда = "DisplayText" Тогда
		СтрокаТекста = ВходныеПараметры[0];
		Результат = ВывестиТекст(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры);

	// Очистка дисплея
	ИначеЕсли Команда = "ОчиститьДисплейПокупателя" ИЛИ Команда = "ClearText" Тогда
		Результат = ОчиститьТекст(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Тестирование устройства
	ИначеЕсли Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	// Получить параметры вывода	
	ИначеЕсли Команда = "ПолучитьПараметрыВывода" Тогда
		Результат = ПолучитьПараметрыВывода(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" Тогда
		Результат = ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Указанная команда не поддерживается данным драйвером
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		Результат = Ложь;

	КонецЕсли;

	Возврат Результат;

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция осуществляет вывод списка строк на дисплей покупателя.
//
Функция ВывестиТекст(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;	
	
	КолвоСтолбцов	 = ОбъектДрайвера.КолвоСтолбцовДисплея;
	СтрокаТекстаВрем = ПостроитьПоле(СтрПолучитьСтроку(СтрокаТекста, 1), КолвоСтолбцов)
					 + ПостроитьПоле(СтрПолучитьСтроку(СтрокаТекста, 2), КолвоСтолбцов);
	
	Результат = (ОбъектДрайвера.ПоказатьТекст(СтрокаТекстаВрем, 0) = 0);
	Если Не Результат Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет очистку дисплея покупателя.
//
Функция ОчиститьТекст(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;

	ОбъектДрайвера.Очистить();

	Возврат Результат;

КонецФункции

// Функция возвращает параметры вывода на дисплей покупателя)
Функция ПолучитьПараметрыВывода(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;
	ВыходныеПараметры.Очистить();
    
	Если Параметры.РазмерДисплея = 0 Тогда
		ВыходныеПараметры.Добавить(20);
		ВыходныеПараметры.Добавить(2);
	ИначеЕсли Параметры.РазмерДисплея = 0 Тогда
		ВыходныеПараметры.Добавить(16);
		ВыходныеПараметры.Добавить(1);
	Иначе	
		ВыходныеПараметры.Добавить(26);
		ВыходныеПараметры.Добавить(2);	
	КонецЕсли;	
		
	Возврат Результат;

КонецФункции

// Функция осуществляет тестирование устройства.
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Результат = ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	Если Не Результат Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка при подключении устройства'"));
	Иначе                  
		СтрокаТекста = НСтр("ru='Тестовая строка 1'") + Символы.ПС + НСтр("ru='Тестовая строка 2'") + Символы.ПС + НСтр("ru='Тестовая строка 3'");

		ВывестиТекст(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры);
		Пауза(5);

		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(НСтр("ru='Тест успешно выполнен'"));
	КонецЕсли;

	ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	Возврат Результат;

КонецФункции

// Функция возвращает версию установленного драйвера
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ВыходныеПараметры.Добавить(НСтр("ru='Установлен'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена'"));

	Попытка
		ВыходныеПараметры[1] = ОбъектДрайвера.Версия;
	Исключение
	КонецПопытки;

	Возврат Результат;

КонецФункции

// Процедура формирует задержку указанной длительности
//
// Параметры:
//  Время - <Число>
//        - Длительность задержки в секундах.
//
Процедура Пауза(Время)

	ВремяЗавершения = ТекущаяДата() + Время;
	Пока ТекущаяДата() < ВремяЗавершения Цикл
	КонецЦикла;

КонецПроцедуры

// Возвращает по наименованию модели код протокола устройства
//
Функция ПолучитьКодПротокола(Модель)

	КодПротокола = 0;

	Протоколы = Новый Соответствие;
	Протоколы["Datecs DPD-201"]          = 0;
	Протоколы["EPSON-совместимый"]       = 1;
	Протоколы["Меркурий ДП-01"]          = 2;
	Протоколы["Меркурий ДП-02"]          = 3;
	Протоколы["Меркурий ДП-03"]          = 4;
	Протоколы["Flytech"]                 = 5;
	Протоколы["GIGATEK DSP800"]          = 6;
	Протоколы["GIGATEK DSP850A"]         = 6;
	Протоколы["Штрих-FrontMaster"]       = 7;
	Протоколы["EPSON-совместимый (USA)"] = 8;
	Протоколы["Posiflex PD2300 USB"]     = 9;
	Протоколы["IPC"]                     = 10;
	Протоколы["GIGATEK DSP820"]          = 11;
	Протоколы["TEC LIUST-51"]            = 12;
	Протоколы["Демо-дисплей"]            = 255;

	Попытка
		КодПротокола = Протоколы[Модель];
	Исключение
	КонецПопытки;

	Возврат КодПротокола;

КонецФункции

// Обрезает передаваемую строку по длине поля. если поле слишком короткое - дополняет пробелами
Функция ПостроитьПоле(Текст, ДлинаПоля)
	
	Если СтрДлина(Текст) < ДлинаПоля Тогда
		ТекстПолный = Текст;
		КолвоПробелов = ДлинаПоля - СтрДлина(ТекстПолный);
		Для й = 1 По КолвоПробелов Цикл
			ТекстПолный = ТекстПолный + " ";
		КонецЦикла;
	Иначе
		ТекстПолный = Лев(Текст, ДлинаПоля);
	КонецЕсли;
	
	Возврат ТекстПолный;
КонецФункции
