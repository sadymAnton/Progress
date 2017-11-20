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
	ПараметрыПодключения.Вставить("ИДУстройства", "");

	ВыходныеПараметры = Новый Массив();

	// Проверка параметров устройства
	Порт                     = Неопределено;
	Скорость                 = Неопределено;
	ТипСвязи                 = Неопределено;
	НомерБазы                = Неопределено;
	НомерДокумента           = Неопределено;
	ОчищатьДокумент          = Неопределено;
	ВыбиратьИсточникЗагрузки = Неопределено;
	ФорматБазы               = Неопределено;
	ФорматДокумента          = Неопределено;
	Модель                   = Неопределено;

	Параметры.Свойство("Порт"                    , Порт);
	Параметры.Свойство("Скорость"                , Скорость);
	Параметры.Свойство("ТипСвязи"                , ТипСвязи);
	Параметры.Свойство("НомерБазы"               , НомерБазы);
	Параметры.Свойство("НомерДокумента"          , НомерДокумента);
	Параметры.Свойство("ОчищатьДокумент"         , ОчищатьДокумент);
	Параметры.Свойство("ВыбиратьИсточникЗагрузки", ВыбиратьИсточникЗагрузки);
	Параметры.Свойство("ФорматБазы"              , ФорматБазы);
	Параметры.Свойство("ФорматДокумента"         , ФорматДокумента);
	Параметры.Свойство("Модель",                   Модель);

	Если Порт                     = Неопределено
	 Или Скорость                 = Неопределено
	 Или ТипСвязи                 = Неопределено
	 Или НомерБазы                = Неопределено
	 Или НомерДокумента           = Неопределено
	 Или ОчищатьДокумент          = Неопределено
	 Или ВыбиратьИсточникЗагрузки = Неопределено
	 Или ФорматБазы               = Неопределено
	 Или ФорматДокумента          = Неопределено
	 Или Модель                   = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
		|Для корректной работы устройства необходимо задать параметры его работы.
		|Сделать это можно при помощи формы ""Настройка параметров"" модели
		|подключаемого оборудования в форме ""Подключение и настройка оборудования"".'"));

		Результат = Ложь;
	КонецЕсли;
   	
	Если Результат Тогда
		
		МассивЗначений = Новый Массив;
		МассивЗначений.Добавить(Порт);
		МассивЗначений.Добавить(Скорость);
		МассивЗначений.Добавить(ТипСвязи); 
				
		Если ОбъектДрайвера.Подключить(МассивЗначений, ПараметрыПодключения.ИДУстройства) Тогда
			ВыходныеПараметры.Добавить(""); // Источник событий
			ВыходныеПараметры.Добавить(Неопределено); // Список событий
		Иначе
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

			Результат = Ложь;
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
	
	Результат = Ложь;

	// Обязательные выходные
	ВыходныеПараметры = Новый Массив();

	Если НЕ ОбъектДрайвера.Отключить(ПараметрыПодключения.ИДУстройства) Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
	Иначе
		Результат = Истина;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	// Выгрузка таблицы в устройство
	Если Команда = "ВыгрузитьТаблицу" ИЛИ Команда = "UploadDirectory" Тогда
		ТаблицаВыгрузки = ВходныеПараметры[1];

		Результат = ВыгрузитьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                             ТаблицаВыгрузки, ВыходныеПараметры);

	// Загрузка таблицы из устройства
	ИначеЕсли Команда = "ЗагрузитьТаблицу" ИЛИ Команда = "DownloadDocument" Тогда
		Результат = ЗагрузитьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" Тогда
		Результат = ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Тестирование устройства
	ИначеЕсли Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
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

// Функция осуществляет подготовку процедуры выгрузки данных в терминал.
//
Функция НачатьВыгрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;
	Ответ = ОбъектДрайвера.НачатьЗагрузку(Параметры.НомерБазы);
	Если НЕ (Ответ = 0) Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет выгрузку строки в терминал сбора данных.
//
// Параметры:
//  Объект                         - <*>
//                                 - Объект драйвера торгового оборудования.
//
//  Штрихкод                       - <Строка>
//                                 - Штрихкод товара.
//
//  Номенклатура                   - <СправочникСсылка.Номенклатура>
//                                 - Номенклатура.
//
//  ЕдиницаИзмерения               - <СправочникСсылка.ЕдиницыИзмерения>
//                                 - Единица измерения номенклатуры.
//
//  ХарактеристикаНоменклатуры     - <СправочникСсылка.ХарактеристикиНоменклатуры>
//                                 - Характеристика номенклатуры.
//
//  СерияНоменклатуры              - <СправочникСсылка.СерииНоменклатуры>
//                                 - Серия номенклатуры.
//
//  Качество                       - <СправочникСсылка.Качество>
//                                 - Качество.
//
//  Цена                           - <Число>
//                                 - Цена номенклатуры.
//
//  Количество                     - <Число>
//                                 - Количество номенклатуры.
//
// Возвращаемое значение:
//  <ПеречислениеСсылка.ТООшибки*> - Результат работы функции
//
Функция ВыгрузитьСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                        Штрихкод, Номенклатура, ЕдиницаИзмерения,
                        ХарактеристикаНоменклатуры, СерияНоменклатуры,
                        Качество, Цена, Количество, ВыходныеПараметры) Экспорт

	Результат = Истина;

	Для Индекс = 1 По 8 Цикл
		ОбъектДрайвера["Поле" + Индекс] = "";
	КонецЦикла;

	// Обрезание поля "Номенклатура" связана с настройками задач ТСД, где по умолчанию наименование 40 символов

	Если Параметры.ФорматБазы.Количество() > 0 Тогда
		КоличествоПолей = Параметры.ФорматБазы.Количество(); 
		Для Каждого СтрокаФормата Из Параметры.ФорматБазы Цикл
			Если СтрокаФормата.Наименование = "Штрихкод" Тогда
				ОбъектДрайвера["Поле" + СтрокаФормата.НомерПоля] = Штрихкод;
			ИначеЕсли СтрокаФормата.Наименование = "Номенклатура" Тогда
				ОбъектДрайвера["Поле" + СтрокаФормата.НомерПоля] = Лев(Номенклатура, 40);
			ИначеЕсли СтрокаФормата.Наименование = "ЕдиницаИзмерения" Тогда
				ОбъектДрайвера["Поле" + СтрокаФормата.НомерПоля] = ЕдиницаИзмерения;
			ИначеЕсли СтрокаФормата.Наименование = "ХарактеристикаНоменклатуры" Тогда
				ОбъектДрайвера["Поле" + СтрокаФормата.НомерПоля] = ХарактеристикаНоменклатуры;
			ИначеЕсли СтрокаФормата.Наименование = "СерияНоменклатуры" Тогда
				ОбъектДрайвера["Поле" + СтрокаФормата.НомерПоля] = СерияНоменклатуры;
			ИначеЕсли СтрокаФормата.Наименование = "Качество" Тогда
				ОбъектДрайвера["Поле" + СтрокаФормата.НомерПоля] = Качество;
			ИначеЕсли СтрокаФормата.Наименование = "Цена" Тогда
				ОбъектДрайвера["Поле" + СтрокаФормата.НомерПоля] = Строка(Цена);
			ИначеЕсли СтрокаФормата.Наименование = "Количество" Тогда
				ОбъектДрайвера["Поле" + СтрокаФормата.НомерПоля] = Строка(Количество);
			КонецЕсли;
		КонецЦикла;
	Иначе
		КоличествоПолей = 8; 
		ОбъектДрайвера.Поле1 = Штрихкод;
		ОбъектДрайвера.Поле2 = Лев(Номенклатура, 40);
		ОбъектДрайвера.Поле3 = ЕдиницаИзмерения;
		ОбъектДрайвера.Поле4 = ХарактеристикаНоменклатуры;
		ОбъектДрайвера.Поле5 = СерияНоменклатуры;
		ОбъектДрайвера.Поле6 = Качество;
		ОбъектДрайвера.Поле7 = Строка(Цена);
		ОбъектДрайвера.Поле8 = Строка(Количество);
	КонецЕсли;

	Ответ = ОбъектДрайвера.ДобавитьЗапись(КоличествоПолей);
	Если НЕ (Ответ = 0) Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет завершение процедуры выгрузки данных в терминал сбора данных.
//
Функция ЗавершитьВыгрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;
	ОбъектДрайвера.ЗавершитьЗагрузку();
	Возврат Результат;

КонецФункции

// Функция осуществляет подготовку процедуры загрузки данных из терминала сбора данных.
//
Функция НачатьЗагрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, Количество, ВыходныеПараметры)

	Результат = Истина;
	ПараметрыПодключения.Вставить("ПоследнийИсточникЗагрузки", "Документ");

	Если Параметры.ВыбиратьИсточникЗагрузки Тогда
		СписокИсточниковЗагрузки = Новый СписокЗначений();
		СписокИсточниковЗагрузки.Добавить("Документ", НСтр("ru='Документ терминала сбора данных'"));
		СписокИсточниковЗагрузки.Добавить("База",     НСтр("ru='База терминала сбора данных'"));

		ИсточникЗагрузки = СписокИсточниковЗагрузки.ВыбратьЭлемент(НСтр("ru='Выберите источник загрузки данных'"));
		Если ИсточникЗагрузки <> Неопределено Тогда
			ПараметрыПодключения.ПоследнийИсточникЗагрузки = ИсточникЗагрузки.Значение;
			Если ПараметрыПодключения.ПоследнийИсточникЗагрузки = "Документ" Тогда
				Количество = ОбъектДрайвера.ЧислоЗаписей(0, Параметры.НомерДокумента);
			Иначе
				Количество = ОбъектДрайвера.ЧислоЗаписей(1, Параметры.НомерБазы);
			КонецЕсли;
		Иначе
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(НСтр("ru='Операция отменена пользователем'"));
			Возврат Ложь;
		КонецЕсли;
	Иначе
		Количество = ОбъектДрайвера.ЧислоЗаписей(0, Параметры.НомерДокумента);
	КонецЕсли;

	Если Количество > 0 Тогда
		
		Если ПараметрыПодключения.ПоследнийИсточникЗагрузки = "Документ" Тогда
			ОбъектДрайвера.НачатьЧтение(0, Параметры.НомерДокумента);
		Иначе
			ОбъектДрайвера.НачатьЧтение(1, Параметры.НомерБазы);
		КонецЕсли;
		
	ИначеЕсли Количество = 0 Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Отсутствуют данные для загрузки из терминала сбора данных.'"));
		Результат = Ложь;
	ИначеЕсли Количество < 0 Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет загрузку строки из терминала сбора данных.
//
// Параметры:
//  Объект                         - <*>
//                                 - Объект драйвера торгового оборудования.
//
//  Штрихкод                       - <Строка>
//                                 - Штрихкод, соответствующий данной номенклатуре.
//
//  Количество                     - <Число>
//                                 - Выходной параметр; количество номенклатуры.
//
// Возвращаемое значение:
//  <ПеречислениеСсылка.ТООшибки*> - Результат работы функции.
//
Функция ЗагрузитьСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения, Штрихкод, Количество, ВыходныеПараметры)

	Результат  = Истина;

	Штрихкод   = Неопределено;
	Количество = Неопределено;

	Ответ = ОбъектДрайвера.ЧитатьЗапись();
	Если Ответ > 0 Тогда
		Если Параметры.ФорматДокумента.Количество() > 0 Тогда
			Для Каждого СтрокаФормата Из Параметры.ФорматДокумента Цикл
				Если СтрокаФормата.Наименование = "Штрихкод" Тогда
					Штрихкод = ОбъектДрайвера["Поле" + СтрокаФормата.НомерПоля];
				ИначеЕсли СтрокаФормата.Наименование = "Количество" Тогда
					Количество = ОбъектДрайвера["Поле" + СтрокаФормата.НомерПоля];
				КонецЕсли;
			КонецЦикла;
		Иначе
			Штрихкод   = ОбъектДрайвера["Поле1"];
			Количество = ОбъектДрайвера["Поле2"];
		КонецЕсли;
	Иначе
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет завершение процедуры загрузки данных из терминала сбора данных.
//
// Параметры:
//  Объект                         - <*>
//                                 - Объект драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <ПеречислениеСсылка.ТООшибки*> - Результат работы функции.
//
Функция ЗавершитьЗагрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Ответ = ОбъектДрайвера.ЗавершитьЧтение();

	Если НЕ (Ответ = 0) Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
		Результат = Ложь;
	Иначе
		Если Параметры.ОчищатьДокумент
		   И ПараметрыПодключения.ПоследнийИсточникЗагрузки = "Документ" Тогда
		   
			ВсегоЗаписей = ОбъектДрайвера.ЧислоЗаписей(0, Параметры.НомерДокумента);
			Если ВсегоЗаписей > 0 Тогда
				УдаленоЗаписей = ОбъектДрайвера.УдалитьДанные(0, Параметры.НомерДокумента);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет выгрузку строки в терминал сбора данных.
//
&НаКлиенте
Функция ВыгрузитьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаВыгрузки, ВыходныеПараметры)

	Результат = Истина;
	
	Если ТаблицаВыгрузки.Количество() = 0 Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Нет данных для выгрузки.'"));
		Возврат Ложь;
	КонецЕсли;
	
	Результат = НачатьВыгрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	Если Результат Тогда
			
		ТекущийПроцент = 0;
		ПроцентИнкремент = 100 / ТаблицаВыгрузки.Количество();
		
		ОбъектДрайвера.РазделительБД = 11;
		
		Для Индекс = 0 По ТаблицаВыгрузки.Количество() - 1 Цикл
			Результат = ВыгрузитьСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
										ТаблицаВыгрузки[Индекс][0].Значение, ТаблицаВыгрузки[Индекс][1].Значение,
										ТаблицаВыгрузки[Индекс][2].Значение, ТаблицаВыгрузки[Индекс][3].Значение,
										ТаблицаВыгрузки[Индекс][4].Значение, ТаблицаВыгрузки[Индекс][5].Значение,
										ТаблицаВыгрузки[Индекс][6].Значение, ТаблицаВыгрузки[Индекс][7].Значение,
										ВыходныеПараметры);
			Если Не Результат Тогда
				ЗавершитьВыгрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
				Прервать;
			КонецЕсли;
			
			ТекущийПроцент = ТекущийПроцент + ПроцентИнкремент;
			Состояние(НСтр("ru='Выгрузка данных...'"), Окр(ТекущийПроцент));
		КонецЦикла;
		
		Если Результат Тогда
			Результат = ЗавершитьВыгрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

// Функция осуществляет загрузку строки из терминала сбора данных.
//
Функция ЗагрузитьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат  = Истина;
	Штрихкод   = Неопределено;
	Количество = Неопределено;

	Результат = НачатьЗагрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, Количество, ВыходныеПараметры);

	Если Результат Тогда
		
		ТекущийПроцент = 0;
		ПроцентИнкремент = 100 / Количество;
		
		ВыходныеПараметры.Добавить(Новый Массив());
		Для Индекс = 1 По Количество Цикл
			Результат = ЗагрузитьСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
			                            Штрихкод, Количество, ВыходныеПараметры);
			Если Результат Тогда
				ВыходныеПараметры[0].Добавить(Штрихкод);
				ВыходныеПараметры[0].Добавить(Количество);
			Иначе
				ВыходныеПараметры.Очистить();
				ВыходныеПараметры.Добавить(999);
				ВыходныеПараметры.Добавить("");
				ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
				
				ЗавершитьЗагрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, Новый Массив());
				Результат = Ложь;
				Прервать;
			КонецЕсли;
			
			ТекущийПроцент = ТекущийПроцент + ПроцентИнкремент;
			Состояние(НСтр("ru='Загрузка данных...'"), Окр(ТекущийПроцент));

		КонецЦикла;
	КонецЕсли;

	Если Результат Тогда
		Результат = ЗавершитьЗагрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		Если Не Результат Тогда
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция возвращает версию установленного драйвера
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ВыходныеПараметры.Добавить(НСтр("ru='Установлен'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена'"));

	Попытка
		ВыходныеПараметры[1] = ОбъектДрайвера.ПолучитьНомерВерсии();
	Исключение
	КонецПопытки;

	Возврат Результат;

КонецФункции

// Функция осуществляет снятие отчёта без гашения.
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;            
	РезультатТеста = "";

	МассивЗначений = Новый Массив;
	МассивЗначений.Добавить(Параметры.Порт);
	МассивЗначений.Добавить(Параметры.Скорость);
	МассивЗначений.Добавить(Параметры.ТипСвязи);

	Результат = ОбъектДрайвера.ТестУстройства(МассивЗначений, РезультатТеста);

	ВыходныеПараметры.Добавить(?(Результат, 0, 999));
	ВыходныеПараметры.Добавить(РезультатТеста);

	Возврат Результат;
	
КонецФункции
