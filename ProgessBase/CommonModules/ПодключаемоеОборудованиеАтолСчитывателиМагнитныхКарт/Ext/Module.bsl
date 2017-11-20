﻿////////// ОБЩИЕ КОМАНДЫ ВСЕХ ОБРАБОТЧИКОВ //////////////

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

	Результат  = Истина;

	// Обязательные выходные
	Если ТипЗнч(ВыходныеПараметры) <> Тип("Массив") Тогда
		ВыходныеПараметры = Новый Массив();
	КонецЕсли;

	// Проверка настроенных параметров
	Порт             = Неопределено;
	Скорость         = Неопределено;
	БитДанных        = Неопределено;
	СтопБит          = Неопределено;
	Четность         = Неопределено;
	Чувствительность = Неопределено;
	ПараметрыДорожек = Неопределено;
	Модель           = Неопределено;

	Параметры.Свойство("Порт"            , Порт);
	Параметры.Свойство("Скорость"        , Скорость);
	Параметры.Свойство("БитДанных"       , БитДанных);
	Параметры.Свойство("СтопБит"         , СтопБит);
	Параметры.Свойство("Четность"        , Четность);
	Параметры.Свойство("Чувствительность", Чувствительность);
	Параметры.Свойство("ПараметрыДорожек", ПараметрыДорожек);
	Параметры.Свойство("Модель"          , Модель);

	Если Порт             = Неопределено
	 Или Скорость         = Неопределено
	 Или БитДанных        = Неопределено
	 Или СтопБит          = Неопределено
	 Или Четность         = Неопределено
	 Или Чувствительность = Неопределено
	 Или ПараметрыДорожек = Неопределено
	 Или Модель           = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
		|Для корректной работы устройства необходимо задать параметры его работы.
		|Сделать это можно при помощи формы ""Настройка параметров"" модели
		|подключаемого оборудования в форме ""Подключение и настройка оборудования"".'"));

		Результат = Ложь;
	КонецЕсли;

	Если Результат Тогда
		ВыходныеПараметры.Добавить("MagneticStripeCardReader");
		ВыходныеПараметры.Добавить(Новый Массив());
		ВыходныеПараметры[1].Добавить("MagneticStripeCardValue");

		Если Параметры.Порт <> 100 Тогда
			ОбъектДрайвера.ДобавитьУстройство();
		КонецЕсли;

		Если (Параметры.Порт <> 100 И ОбъектДрайвера.Результат = 0)
		 Или Параметры.Порт = 100 Тогда
			ПараметрыПодключения.Вставить("ИДУстройства", ОбъектДрайвера.НомерТекущегоУстройства);
			Если Параметры.Порт <> 100 Тогда
				ПараметрыПодключения.ИДУстройства = ОбъектДрайвера.НомерТекущегоУстройства;
			Иначе
				ОбъектДрайвера.НомерТекущегоУстройства = 1;
				ПараметрыПодключения.ИДУстройства = 1;
			КонецЕсли;
			ОбъектДрайвера.НаименованиеТекущегоУстройства = Параметры.Модель;

			ОбъектДрайвера.НомерПорта       = Параметры.Порт;
			ОбъектДрайвера.СкоростьОбмена   = Параметры.Скорость;
			ОбъектДрайвера.Четность         = Параметры.Четность;
			ОбъектДрайвера.БитыДанных       = Параметры.БитДанных;
			ОбъектДрайвера.СтопБиты         = Параметры.СтопБит;
			ОбъектДрайвера.Чувствительность = Параметры.Чувствительность;
			ОбъектДрайвера.Модель           = 1;
			ОбъектДрайвера.СтараяВерсия     = 0;

			Для Индекс = 1 По 3 Цикл
				Если Параметры.ПараметрыДорожек[Индекс - 1].Использовать Тогда
					ПрефиксДрайвера = Параметры.ПараметрыДорожек[Индекс - 1].Префикс;
					Прервать;
				КонецЕсли;
			КонецЦикла;

			Для Индекс = 1 По 3 Цикл
				Если Параметры.ПараметрыДорожек[3 - Индекс].Использовать Тогда
					СуффиксДрайвера = Параметры.ПараметрыДорожек[3 - Индекс].Суффикс;
					Прервать;
				КонецЕсли;
			КонецЦикла;

			ТекПрефикс = СтрЗаменить(ПрефиксДрайвера, "#", Символы.ПС);
			КоличествоСимволов = СтрЧислоСтрок(ТекПрефикс);
			ПрефиксДрайвера = "";
			Для Тмп = 2 По КоличествоСимволов Цикл
				ПрефиксДрайвера = ПрефиксДрайвера + Символ(Число(СтрПолучитьСтроку(ТекПрефикс, Тмп)));
			КонецЦикла;

			ТекСуффикс = СтрЗаменить(СуффиксДрайвера, "#", Символы.ПС);
			КоличествоСимволов = СтрЧислоСтрок(ТекСуффикс);
			СуффиксДрайвера = "";
			Для Тмп = 2 По КоличествоСимволов Цикл
				СуффиксДрайвера = СуффиксДрайвера + Символ(Число(СтрПолучитьСтроку(ТекСуффикс, Тмп)));
			КонецЦикла;

			ОбъектДрайвера.Префикс = ПрефиксДрайвера;
			ОбъектДрайвера.Суффикс = СуффиксДрайвера;
		Иначе
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.ОписаниеОшибки = ОбъектДрайвера.ОписаниеРезультата;

			Результат = Ложь;
		КонецЕсли;

		Если Результат Тогда
			ОбъектДрайвера.УстройствоВключено = 1;
			Если ОбъектДрайвера.Результат <> 0 Тогда
				ВыходныеПараметры.Очистить();
				ВыходныеПараметры.Добавить(999);
				ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

				ОбъектДрайвера.УстройствоВключено = 0;
				ОбъектДрайвера.УдалитьУстройство();

				Результат = Ложь;
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

	// Обязательные выходные
	Если ТипЗнч(ВыходныеПараметры) <> Тип("Массив") Тогда
		ВыходныеПараметры = Новый Массив();
	КонецЕсли;

	ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;
	ОбъектДрайвера.УстройствоВключено = 0;
	Если ОбъектДрайвера.КоличествоУстройств > 1 Тогда
		ОбъектДрайвера.УдалитьУстройство();
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	// Обязательные выходные
	Если ТипЗнч(ВыходныеПараметры) <> Тип("Массив") Тогда
		ВыходныеПараметры = Новый Массив();
	КонецЕсли;

	// Обработка события от устройства
	Если Команда = "ОбработатьСобытие" Тогда
		Событие = ВходныеПараметры[0];
		Данные  = ВходныеПараметры[1];

		Результат = ОбработатьСобытие(ОбъектДрайвера, Параметры, ПараметрыПодключения, Событие, Данные, ВыходныеПараметры);

	// Завершение обработки события от устройства
	ИначеЕсли Команда = "ЗавершитьОбработкуСобытия" Тогда
		Результат = ЗавершитьОбработкуСобытия(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

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


/////////////////////////////////////
// Функции-исполнители команд

///////// СПЕЦИФИЧНЫЕ ПО ТИПУ ОБОРУДОВАНИЯ КОМАНДЫ ////////////////

// Функция осуществляет обработку внешних событий торгового оборудования.
//
Функция ОбработатьСобытие(ОбъектДрайвера, Параметры, ПараметрыПодключения, Событие, Данные, ВыходныеПараметры)

	Результат = Истина;
	КодКарты  = Данные;	

	Попытка
		ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;
		ОбъектДрайвера.ПосылкаДанных  = 0;
		ОбъектДрайвера.НомерСообщения = Число(Данные);
		КодКарты                      = ВРег(ОбъектДрайвера.Данные);
	Исключение
		ПараметрыПодключения.ОписаниеОшибки = ОбъектДрайвера.ОписаниеРезультата;
		Результат = Ложь;
	КонецПопытки;
	
	// _ВРЕМЕННОЕ_ решение проблемы первого двоеточия в коде
	Если Лев(КодКарты, 1) = ":" Тогда
		КодКарты = Прав(КодКарты, СтрДлина(КодКарты)-1);
	КонецЕсли;

	ПозицияПрефикса = 0;
	ПозицияСуффикса = 0;
	времКодКарты    = "";
	ДанныеКарты = "";
	ПозицияДляЧтения = 1;

	ДанныеДорожек = Новый Массив();
	Для НомерДорожки = 1 По 3 Цикл
		ДанныеДорожек.Добавить("");

		ТекущаяДорожка = Параметры.ПараметрыДорожек[НомерДорожки - 1];
		Если ТекущаяДорожка.Использовать Тогда
			ПрефиксДрайвера = ТекущаяДорожка.Префикс;
			СуффиксДрайвера = ТекущаяДорожка.Суффикс;

			Если ПозицияДляЧтения < СтрДлина(КодКарты) Тогда
				ДанныеКарты = Сред(КодКарты, ПозицияДляЧтения);

				// ПРЕОБРАЗОВАНИЕ И ПОИСК ПРЕФИКСА В СТРОКЕ ДАННЫХ
				ТекПрефикс = СтрЗаменить(ПрефиксДрайвера, "#", Символы.ПС);
				КоличествоСимволов = СтрЧислоСтрок(ТекПрефикс);
				ПрефиксДрайвера = "";
				Для Тмп = 2 По КоличествоСимволов Цикл
					ПрефиксДрайвера = ПрефиксДрайвера + Символ(Число(СтрПолучитьСтроку(ТекПрефикс, Тмп)));
				КонецЦикла;
				ПозицияПрефикса = Найти(ДанныеКарты, ПрефиксДрайвера);

				// ПРЕОБРАЗОВАНИЕ И ПОИСК СУФФИКСА В СТРОКЕ ДАННЫХ
				ТекСуффикс = СтрЗаменить(СуффиксДрайвера, "#", Символы.ПС);
				КоличествоСимволов = СтрЧислоСтрок(ТекСуффикс);
				СуффиксДрайвера = "";
				Для Тмп = 2 По КоличествоСимволов Цикл
					СуффиксДрайвера = СуффиксДрайвера + Символ(Число(СтрПолучитьСтроку(ТекСуффикс, Тмп)));
				КонецЦикла;
				ПозицияСуффикса = Найти(ДанныеКарты, СуффиксДрайвера);

				времПозицияПрефикса = ?(ПозицияПрефикса = 0, 1, ПозицияПрефикса + СтрДлина(ПрефиксДрайвера));
				времДлинаДоСуффикса = ?(ПозицияСуффикса = 0,
				    СтрДлина(ДанныеКарты) + 1 - времПозицияПрефикса, ПозицияСуффикса - времПозицияПрефикса);
				времКодКарты = времКодКарты + Сред(ДанныеКарты, времПозицияПрефикса, времДлинаДоСуффикса);

				ДанныеДорожек[НомерДорожки - 1] = Сред(ДанныеКарты,
				                                  времПозицияПрефикса,
				                                  времДлинаДоСуффикса);

				ПозицияДляЧтения = ПозицияДляЧтения + ?(ПозицияСуффикса = 0,
				                                        СтрДлина(ДанныеКарты),
				                                        ПозицияСуффикса + СтрДлина(СуффиксДрайвера) - 1);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	КодКарты = времКодКарты;

	ВыходныеПараметры.Добавить("TracksData");
	ВыходныеПараметры.Добавить(Новый Массив());
	ВыходныеПараметры[1].Добавить(КодКарты);
	ВыходныеПараметры[1].Добавить(Новый Массив);
	ВыходныеПараметры[1][1].Добавить(КодКарты);
	ВыходныеПараметры[1][1].Добавить(ДанныеДорожек);
	ВыходныеПараметры[1][1].Добавить(0);
	ВыходныеПараметры[1][1].Добавить(МенеджерОборудованияСервер.РасшифроватьКодМагнитнойКарты(ДанныеДорожек, Параметры.ПараметрыДорожек));
	
	Возврат Результат;

КонецФункции

// Процедура вызывается, когда система готова принять следующее событие от устройства.
Функция ЗавершитьОбработкуСобытия(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Попытка
		ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;
		ОбъектДрайвера.ПосылкаДанных = 1;
	Исключение
	КонецПопытки;

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
