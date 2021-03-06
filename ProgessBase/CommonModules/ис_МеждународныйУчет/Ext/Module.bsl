﻿// Служебная функция, предназначенная для установки соответствий аналитики бух. и медж. планов счетов
// Используется в УстановитьСоответствие
//
Функция ЗаполнитьСтруктуру(Знач Выборка, СчетБУ, Субконто1 = Неопределено, Субконто2 = Неопределено, Субконто3 = Неопределено)
	Структура = Новый Структура("Счет, Субконто1, Субконто2, Субконто3, СтруктураСчетов");
	Структура.Счет  = Выборка.СчетМеждународный;
	Структура.Субконто1 = Неопределено;
	Структура.Субконто2 = Неопределено;
	Структура.Субконто3 = Неопределено;
	Структура.СтруктураСчетов = Неопределено;

	//Заполняем субконто
	Для Ном = 1 по 3 Цикл
		Если Ном <= Выборка["СчетМеждународный"].ВидыСубконто.Количество() Тогда
			// is ЯннуровВФ нач 20141029
			//Тип = Выборка.СчетМеждународный.ВидыСубконто[Ном-1].ВидСубконто.ТипЗначения.Типы();
			ТипЗначения = Выборка.СчетМеждународный.ВидыСубконто[Ном-1].ВидСубконто.ТипЗначения;
			Структура["Субконто"+Ном] = ТипЗначения.ПривестиЗначение(Структура["Субконто"+Ном]);
			Тип = ТипЗначения.Типы();
			// is ЯннуровВФ кон 20141029
			
			Если НЕ ЗначениеЗаполнено(Выборка["СубконтоМежд"+Ном]) Тогда
				// Заполняем значением из исходной проводки (если совпадают типы)
				Если Тип[0] = ТипЗнч(Субконто1) Тогда
					Структура["Субконто"+Ном] = Субконто1;
				ИначеЕсли Тип[0] = ТипЗнч(Субконто2) Тогда
					Структура["Субконто"+Ном] = Субконто2;
				ИначеЕсли Тип[0] = ТипЗнч(Субконто3) Тогда
					Структура["Субконто"+Ном] = Субконто3;
				КонецЕсли;
			Иначе
				// Заполняем как указано в соответствиях
				Структура["Субконто"+Ном] = Выборка["СубконтоМежд"+Ном];
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Структура;
КонецФункции

// Возрващает список пустых значений для заданного плана видов характеристик
//
// Параметры
//  ВидыСубконто  – ПланВидовХарактеристикСсылка – план видов характеристик
//
// Возвращаемое значение:
//   СписокЗначений
//
Функция ПолучитьСписокПустыхСубконто() Экспорт

	сзПустыеСубконто = Новый Массив;
	
	ВыборкаСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Выбрать();
	
	Пока ВыборкаСубконто.Следующий() Цикл
		ПС = ВыборкаСубконто.ТипЗначения.ПривестиЗначение();
		Если сзПустыеСубконто.Найти(ПС) = Неопределено Тогда
			сзПустыеСубконто.Добавить(ПС);
		КонецЕсли;
	КонецЦикла;
	
	Возврат сзПустыеСубконто; 

КонецФункции // ПолучитьСписокПустыхСубконто()

// Функция возвразает структуру, состоящую из счета и трех субконт международного плана счетов, 
// соответствующих хозрасчетным, переданным как параметры функции
// Например: ПреобразоватьСчетаБУвСчетМСФО(СчетБУ, Субконто1, Субконто2, Субконто3).Счет
Функция ПреобразоватьСчетаБУвСчетМСФО(СчетБУ,
									  Субконто1 = Неопределено,
									  Субконто2 = Неопределено,
									  Субконто3 = Неопределено,
									  Знач ДатаСреза = Неопределено,
									  ПолучитьВсеСоответствия = Ложь,
	    // is ЯннуровВФ нач 20141016
		Приход = Неопределено
	    // is ЯннуровВФ кон 20141016
		) Экспорт
		
	Структура = Неопределено;
	СтруктураСчетов = Новый Структура();
	
	Если ДатаСреза = Неопределено Тогда
		ДатаСреза = ОбщегоНазначения.ПолучитьРабочуюДату();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	// is ЯннуровВФ нач 20141001
	//Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//			   |	СоответствиеСчетовСрезПоследних.СчетМеждународный КАК СчетМеждународный,
	//			   |	СоответствиеСчетовСрезПоследних.СубконтоМежд1 КАК СубконтоМежд1,
	//			   |	СоответствиеСчетовСрезПоследних.СубконтоМежд2 КАК СубконтоМежд2,
	//			   |	СоответствиеСчетовСрезПоследних.СубконтоМежд3 КАК СубконтоМежд3,
	//			   |	СоответствиеСчетовСрезПоследних.Реквизит КАК Реквизит,
	//			   |	СоответствиеСчетовСрезПоследних.Значение КАК Значение
	//			   |ИЗ
	//			   |	РегистрСведений.СоответствиеСчетовБУиМСФО.СрезПоследних(&ДатаСреза, СчетХозрасчетный В ИЕРАРХИИ(&СчетБУ)) КАК СоответствиеСчетовСрезПоследних
	//			   |
	//			   |ГДЕ
	//			   |	(СоответствиеСчетовСрезПоследних.Учитывается) И
	//			   |	((СоответствиеСчетовСрезПоследних.СчетМеждународный) ЕСТЬ НЕ NULL ) И
	//			   |	(СоответствиеСчетовСрезПоследних.СубконтоХозр1 В (&ПустоеСубконто) ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр1 = &Субконто1 ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр1 = &Субконто2 ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр1 = &Субконто3) И
	//			   |	(СоответствиеСчетовСрезПоследних.СубконтоХозр2 В (&ПустоеСубконто) ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр2 = &Субконто1 ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр2 = &Субконто2 ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр2 = &Субконто3) И
	//			   |	(СоответствиеСчетовСрезПоследних.СубконтоХозр3 В (&ПустоеСубконто) ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр3 = &Субконто1 ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр3 = &Субконто2 ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр3 = &Субконто3)
	//			   |
	//			   |УПОРЯДОЧИТЬ ПО
	//			   |	СоответствиеСчетовСрезПоследних.Приоритет";
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СоответствиеСчетовСрезПоследних.СчетМеждународный КАК СчетМеждународный,
	|	СоответствиеСчетовСрезПоследних.СубконтоМежд1 КАК СубконтоМежд1,
	|	СоответствиеСчетовСрезПоследних.СубконтоМежд2 КАК СубконтоМежд2,
	|	СоответствиеСчетовСрезПоследних.СубконтоМежд3 КАК СубконтоМежд3,
	|	СоответствиеСчетовСрезПоследних.Реквизит КАК Реквизит,
	|	СоответствиеСчетовСрезПоследних.Значение КАК Значение,
	|	СоответствиеСчетовСрезПоследних.Приоритет КАК Приоритет
	|ИЗ
	|	РегистрСведений.СоответствиеСчетовБУиМСФО.СрезПоследних(&ДатаСреза, СчетХозрасчетный = &СчетБУ) КАК СоответствиеСчетовСрезПоследних
	|ГДЕ
	|	СоответствиеСчетовСрезПоследних.Учитывается = ИСТИНА
	|	И (&Приход = НЕОПРЕДЕЛЕНО
	|			ИЛИ &Приход = ИСТИНА
	|				И СоответствиеСчетовСрезПоследних.ВидДвижения = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийБухгалтерии.Дебет)
	|			ИЛИ &Приход = ЛОЖЬ
	|				И СоответствиеСчетовСрезПоследних.ВидДвижения = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийБухгалтерии.Кредит))
	|	И (СоответствиеСчетовСрезПоследних.СубконтоХозр1 В
	|				(ВЫБРАТЬ
	|					ис_ПустыеСубконто.ЗначениеПустогоСубконто
	|				ИЗ
	|					РегистрСведений.ис_ПустыеСубконто КАК ис_ПустыеСубконто
	|		
	|				ОБЪЕДИНИТЬ ВСЕ
	|		
	|				ВЫБРАТЬ
	|					НЕОПРЕДЕЛЕНО)
	|			ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр1 = &Субконто1
	|			ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр1 = &Субконто2
	|			ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр1 = &Субконто3)
	|	И (СоответствиеСчетовСрезПоследних.СубконтоХозр2 В
	|				(ВЫБРАТЬ
	|					ис_ПустыеСубконто.ЗначениеПустогоСубконто
	|				ИЗ
	|					РегистрСведений.ис_ПустыеСубконто КАК ис_ПустыеСубконто
	|		
	|				ОБЪЕДИНИТЬ ВСЕ
	|		
	|				ВЫБРАТЬ
	|					НЕОПРЕДЕЛЕНО)
	|			ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр2 = &Субконто1
	|			ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр2 = &Субконто2
	|			ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр2 = &Субконто3)
	|	И (СоответствиеСчетовСрезПоследних.СубконтоХозр3 В
	|				(ВЫБРАТЬ
	|					ис_ПустыеСубконто.ЗначениеПустогоСубконто
	|				ИЗ
	|					РегистрСведений.ис_ПустыеСубконто КАК ис_ПустыеСубконто
	|		
	|				ОБЪЕДИНИТЬ ВСЕ
	|		
	|				ВЫБРАТЬ
	|					НЕОПРЕДЕЛЕНО)
	|			ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр3 = &Субконто1
	|			ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр3 = &Субконто2
	|			ИЛИ СоответствиеСчетовСрезПоследних.СубконтоХозр3 = &Субконто3)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет
	|АВТОУПОРЯДОЧИВАНИЕ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ДС_ИсключениеСчетовСрезПоследних.Счет,
	|	ДС_ИсключениеСчетовСрезПоследних.Субконто1,
	|	ДС_ИсключениеСчетовСрезПоследних.Субконто2,
	|	ДС_ИсключениеСчетовСрезПоследних.Субконто3,
	|	ДС_ИсключениеСчетовСрезПоследних.Реквизит,
	|	ДС_ИсключениеСчетовСрезПоследних.Значение
	|ИЗ
	|	РегистрСведений.ДС_ИсключениеСчетов.СрезПоследних(&ДатаСреза, Счет = &СчетБУ) КАК ДС_ИсключениеСчетовСрезПоследних
	|ГДЕ
	|	ДС_ИсключениеСчетовСрезПоследних.Учитывается = ИСТИНА
	|	И (&Приход = НЕОПРЕДЕЛЕНО
	|			ИЛИ &Приход = ИСТИНА
	|				И ДС_ИсключениеСчетовСрезПоследних.ВидДвижения = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийБухгалтерии.Дебет)
	|			ИЛИ &Приход = ЛОЖЬ
	|				И ДС_ИсключениеСчетовСрезПоследних.ВидДвижения = ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийБухгалтерии.Кредит))
	|	И (ДС_ИсключениеСчетовСрезПоследних.Субконто1 В
	|				(ВЫБРАТЬ
	|					ис_ПустыеСубконто.ЗначениеПустогоСубконто
	|				ИЗ
	|					РегистрСведений.ис_ПустыеСубконто КАК ис_ПустыеСубконто
	|		
	|				ОБЪЕДИНИТЬ ВСЕ
	|		
	|				ВЫБРАТЬ
	|					НЕОПРЕДЕЛЕНО)
	|			ИЛИ ДС_ИсключениеСчетовСрезПоследних.Субконто1 = &Субконто1
	|			ИЛИ ДС_ИсключениеСчетовСрезПоследних.Субконто1 = &Субконто2
	|			ИЛИ ДС_ИсключениеСчетовСрезПоследних.Субконто1 = &Субконто3)
	|	И (ДС_ИсключениеСчетовСрезПоследних.Субконто2 В
	|				(ВЫБРАТЬ
	|					ис_ПустыеСубконто.ЗначениеПустогоСубконто
	|				ИЗ
	|					РегистрСведений.ис_ПустыеСубконто КАК ис_ПустыеСубконто
	|		
	|				ОБЪЕДИНИТЬ ВСЕ
	|		
	|				ВЫБРАТЬ
	|					НЕОПРЕДЕЛЕНО)
	|			ИЛИ ДС_ИсключениеСчетовСрезПоследних.Субконто2 = &Субконто1
	|			ИЛИ ДС_ИсключениеСчетовСрезПоследних.Субконто2 = &Субконто2
	|			ИЛИ ДС_ИсключениеСчетовСрезПоследних.Субконто2 = &Субконто3)
	|	И (ДС_ИсключениеСчетовСрезПоследних.Субконто3 В
	|				(ВЫБРАТЬ
	|					ис_ПустыеСубконто.ЗначениеПустогоСубконто
	|				ИЗ
	|					РегистрСведений.ис_ПустыеСубконто КАК ис_ПустыеСубконто
	|		
	|				ОБЪЕДИНИТЬ ВСЕ
	|		
	|				ВЫБРАТЬ
	|					НЕОПРЕДЕЛЕНО)
	|			ИЛИ ДС_ИсключениеСчетовСрезПоследних.Субконто3 = &Субконто1
	|			ИЛИ ДС_ИсключениеСчетовСрезПоследних.Субконто3 = &Субконто2
	|			ИЛИ ДС_ИсключениеСчетовСрезПоследних.Субконто3 = &Субконто3)";
	// is ЯннуровВФ кон 20141001
	Запрос.УстановитьПараметр("ДатаСреза", ДатаСреза);
	Запрос.УстановитьПараметр("СчетБУ", СчетБУ);
	Запрос.УстановитьПараметр("Субконто1", Субконто1);
	Запрос.УстановитьПараметр("Субконто2", Субконто2);
	Запрос.УстановитьПараметр("Субконто3", Субконто3);
	Запрос.УстановитьПараметр("Приход", Приход);
	// is ЯннуровВФ нач 20141001
	//Результат = Запрос.Выполнить();
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	ТаблицаИсключенийСчетов = РезультатыЗапроса[1].Выгрузить();
	Выборка = РезультатыЗапроса[0].Выбрать();
	// is ЯннуровВФ кон 20141001
	Пока Выборка.Следующий() Цикл

		СтруктураСчетов.Вставить("Код"+СтрЗаменить(Выборка.СчетМеждународный.Код, ".",""), Выборка.СчетМеждународный);
		
		// is ЯннуровВФ нач 20141001
		//Если НЕ ЗначениеЗаполнено(Выборка.Реквизит) Тогда
		//	
		//	Если Структура = Неопределено Тогда
		//		Структура = ЗаполнитьСтруктуру(Выборка, СчетБУ, Выборка.СубконтоМежд1, Выборка.СубконтоМежд2, Выборка.СубконтоМежд3);
		//		Если НЕ ПолучитьВсеСоответствия Тогда
		//			Возврат Структура;
		//		КонецЕсли;
		//	КонецЕсли;
		//	
		//Иначе
		//	
		//	Если ЗначениеЗаполнено(Выборка.Реквизит) Тогда // проверяем условие
		//		НомерСубконто = Число(Сред(Выборка.Реквизит,9,1));
		//		Рекв = Сред(Выборка.Реквизит,Найти(Выборка.Реквизит, ".")+1);
		//		Попытка
		//			//Если (НомерСубконто = 1) и ((Субконто1 = Неопределено) или (Субконто1[Рекв] <> Выборка.Значение)) или 
		//			//	 (НомерСубконто = 2) и ((Субконто1 = Неопределено) или (Субконто2[Рекв] <> Выборка.Значение)) или 
		//			//	 (НомерСубконто = 3) и ((Субконто1 = Неопределено) или (Субконто3[Рекв] <> Выборка.Значение)) Тогда
		//			Если (НомерСубконто = 1) и (Субконто1[Рекв] <> Выборка.Значение) или 
		//				 (НомерСубконто = 2) и (Субконто2[Рекв] <> Выборка.Значение) или 
		//				 (НомерСубконто = 3) и (Субконто3[Рекв] <> Выборка.Значение) Тогда
		//				Продолжить;
		//			КонецЕсли
		//		Исключение
		//			Сообщить("В правиле соответствия для субконто "+НомерСубконто+" счета "+СчетБУ+" не найден реквизит "+Рекв);
		//			Продолжить;
		//		КонецПопытки;
		//	КонецЕсли;
		//	
		//	Если Структура = Неопределено Тогда
		//		//Структура = ЗаполнитьСтруктуру(Выборка, СчетБУ, Субконто1, Субконто2, Субконто3);
		//		Структура = ЗаполнитьСтруктуру(Выборка, СчетБУ, Выборка.СубконтоМежд1, Выборка.СубконтоМежд2, Выборка.СубконтоМежд3);
		//		Структура.Вставить("СтруктураСчетов", СтруктураСчетов);
		//		Если НЕ ПолучитьВсеСоответствия Тогда
		//			Возврат Структура;
		//		КонецЕсли;
		//	КонецЕсли;
		//	
		//КонецЕсли;
		Если ЗначениеЗаполнено(Выборка.Реквизит) Тогда
			Если ЗначениеЗаполнено(Выборка.Реквизит) Тогда // проверяем условие
				НомерСубконто = Число(Сред(Выборка.Реквизит,9,1));
				Рекв = Сред(Выборка.Реквизит,Найти(Выборка.Реквизит, ".")+1);
				Попытка
					Если (НомерСубконто = 1) и (Субконто1 <> Неопределено И Субконто1[Рекв] <> Выборка.Значение) или 
						 (НомерСубконто = 2) и (Субконто2 <> Неопределено И Субконто2[Рекв] <> Выборка.Значение) или 
						 (НомерСубконто = 3) и (Субконто3 <> Неопределено И Субконто3[Рекв] <> Выборка.Значение) Тогда
						Продолжить;
					КонецЕсли
				Исключение
					Сообщить("В правиле соответствия для субконто "+НомерСубконто+" счета "+СчетБУ+" не найден реквизит "+Рекв);
					Продолжить;
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
			
		ЕстьИсключения = Ложь;
		Для Каждого СтрокаИсключения Из ТаблицаИсключенийСчетов Цикл 
			Если ЗначениеЗаполнено(СтрокаИсключения.Реквизит) Тогда 
				НомерСубконто = Число(Сред(СтрокаИсключения.Реквизит,9,1));
				Реквизит = Сред(СтрокаИсключения.Реквизит, Найти(СтрокаИсключения.Реквизит, ".")+1);
				Попытка
					Если (НомерСубконто = 1 И Субконто1 <> Неопределено И Субконто1[Реквизит] = СтрокаИсключения.Значение) 
					 Или (НомерСубконто = 2 И Субконто2 <> Неопределено И Субконто2[Реквизит] = СтрокаИсключения.Значение) 
					 Или (НомерСубконто = 3 И Субконто3 <> Неопределено И Субконто3[Реквизит] = СтрокаИсключения.Значение) Тогда
						ЕстьИсключения = Истина;
						Структура = Неопределено;
						Прервать;
					КонецЕсли;	
				Исключение
					Сообщить("В правиле исключения для субконто "+НомерСубконто+" счета "+СчетБУ+" не найден реквизит "+Реквизит);
					Прервать;
				КонецПопытки;
			Иначе
				ЕстьИсключения = Истина;
				Структура = Неопределено;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если ЕстьИсключения Тогда 
			Прервать;
		КонецЕсли;
		
		Если Структура = Неопределено Тогда
			Структура = ЗаполнитьСтруктуру(Выборка, СчетБУ, Субконто1, Субконто2, Субконто3);
			Структура.Вставить("СтруктураСчетов", СтруктураСчетов);
			Если НЕ ПолучитьВсеСоответствия Тогда
				Возврат Структура;
			КонецЕсли;
		КонецЕсли;
		// is ЯннуровВФ кон 20141001
		
	КонецЦикла;

	Если Структура = Неопределено Тогда
		Структура = Новый Структура("Счет, Субконто1, Субконто2, Субконто3, СтруктураСчетов", Неопределено, Неопределено, Неопределено, Неопределено);
	КонецЕсли;
	
	Структура.Вставить("СтруктураСчетов", СтруктураСчетов);
	
	Возврат Структура;
КонецФункции

Функция ИспользоватьНовыйРежимТрансляцииВМСФО() Экспорт
	возврат Константы.ис_НовыйРежимТрансляцииВМСФО.Получить();
КонецФункции

// Перенос проводок

Функция ВыполнитьПереносПроводок_СоздатьТабЗначВрем(ИндексированныеКолонки) Экспорт
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Период");
	ТЗ.Колонки.Добавить("НомерСтроки");
	ТЗ.Колонки.Добавить("Регистратор");
	ТЗ.Колонки.Добавить("СчетДт");
	ТЗ.Колонки.Добавить("СубконтоДт1");
	ТЗ.Колонки.Добавить("СубконтоДт2");
	ТЗ.Колонки.Добавить("СубконтоДт3");
	ТЗ.Колонки.Добавить("СчетКт");
	ТЗ.Колонки.Добавить("СубконтоКт1");
	ТЗ.Колонки.Добавить("СубконтоКт2");
	ТЗ.Колонки.Добавить("СубконтоКт3");
	ТЗ.Колонки.Добавить("ВалютаДт");
	ТЗ.Колонки.Добавить("ВалютаКт");
	ТЗ.Колонки.Добавить("Сумма");
	ТЗ.Колонки.Добавить("ВалютнаяСуммаДт");
	ТЗ.Колонки.Добавить("ВалютнаяСуммаКт");
	ТЗ.Колонки.Добавить("КоличествоДт");
	ТЗ.Колонки.Добавить("КоличествоКт");
	ТЗ.Колонки.Добавить("НомерЖурнала");
	ТЗ.Колонки.Добавить("Содержание");
	ТЗ.Колонки.Добавить("СчетМеждународныйДт");
	ТЗ.Колонки.Добавить("СубконтоМеждДт1");
	ТЗ.Колонки.Добавить("СубконтоМеждДт2");
	ТЗ.Колонки.Добавить("СубконтоМеждДт3");
	ТЗ.Колонки.Добавить("РеквизитДт");
	ТЗ.Колонки.Добавить("ЗначениеДт");
	ТЗ.Колонки.Добавить("СчетМеждународныйКт");
	ТЗ.Колонки.Добавить("СубконтоМеждКт1");
	ТЗ.Колонки.Добавить("СубконтоМеждКт2");
	ТЗ.Колонки.Добавить("СубконтоМеждКт3");
	ТЗ.Колонки.Добавить("РеквизитКт");
	ТЗ.Колонки.Добавить("ЗначениеКт");
	ТЗ.Колонки.Добавить("РеквизитИсклДТ");
	ТЗ.Колонки.Добавить("ЗначениеИсклДТ");
	ТЗ.Колонки.Добавить("РеквизитИсклКт");
	ТЗ.Колонки.Добавить("ЗначениеИсклКт");
	ТЗ.Колонки.Добавить("ОтменитьИсключениеДт");
	ТЗ.Колонки.Добавить("ОтменитьИсключениеКт");
	ТЗ.Колонки.Добавить("ТипРегистратора");
	ТЗ.Колонки.Добавить("ТипРегистратораСоответствия");
	ТЗ.Колонки.Добавить("ис_БезСуммы");
	ТЗ.Колонки.Добавить("ис_БезВалютнойСуммыДт");
	ТЗ.Колонки.Добавить("ис_БезВалютнойСуммыКт");
	ТЗ.Колонки.Добавить("ис_БезКоличестваДт");
	ТЗ.Колонки.Добавить("ис_БезКоличестваКт");
	ТЗ.Колонки.Добавить("ПравилоПереносаДт");
	ТЗ.Колонки.Добавить("НомерСтрокиПравилаПереносаДт");
	ТЗ.Колонки.Добавить("ПравилоПереносаКт");
	ТЗ.Колонки.Добавить("НомерСтрокиПравилаПереносаКт");
	//Добавлено Андрей Перов 18.10.2017
	ТЗ.Колонки.Добавить("ПравилоПереноса");
	//Конец добавления
	ТЗ.Индексы.Добавить(ИндексированныеКолонки);
	возврат ТЗ;
КонецФункции

Функция ВалютыМеждународного_и_РегламентированногоУчетаСовпадают() Экспорт
	возврат глЗначениеПеременной("ВалютаМеждународногоУчета") = глЗначениеПеременной("ВалютаРегламентированногоУчета");
КонецФункции