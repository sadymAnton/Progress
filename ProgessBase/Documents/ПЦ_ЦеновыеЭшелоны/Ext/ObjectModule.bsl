﻿ //++ torchinov@a-prof.ru 19.09.2014
 
 Перем мУдалятьДвижения;
 
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
			 Предупреждение(НСтр("ru = 'Документ можно распечатать только после его записи'"));
			 Возврат;
		 ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
			 Предупреждение(НСтр("ru = Недостаточно полномочий для печати непроведенного документа!'"));
			 Возврат;
		 КонецЕсли;
		 
		 Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
			 Возврат;
		 КонецЕсли;
		 
		 // Получить экземпляр документа на печать
		 Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда
			 ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
			 
			 Если ТабДокумент = Неопределено Тогда
				 Возврат
			 КонецЕсли;
		 КонецЕсли; 
		 
		 УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект,, Ссылка));
		 
	 КонецПроцедуры // Печать
	 
 // Возвращает доступные варианты печати документа
	 //
	 // Возвращаемое значение:
	 //  Структура, каждая строка которой соответствует одному из вариантов печати
	 //  
 Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
		 
		 Возврат Новый Структура();
		 
	 КонецФункции // ПолучитьСтруктуруПечатныхФорм()
 #КонецЕсли
 
 Процедура ОбработкаПроведения(Отказ, Режим)
	 
	 Если мУдалятьДвижения Тогда
		 ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	 КонецЕсли;
	 
	 
	 // Заголовок для сообщений об ошибках проведения.
	 Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	 
	 // Сформируем структуру реквизитов шапки документа.
	 СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	 
	 // Заполним по шапке документа дерево параметров, нужных при проведении.
	 ДеревоПолейЗапросаПоШапке = УправлениеЗапасами.СформироватьДеревоПолейЗапросаПоШапке();
	 
	 // Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа.
	 СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, "");
	 
	 
	 ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	 
	 РезультатЗапросаПоТЧ 	= СформироватьЗапросПоТабличнымЧастям();
	 ТаблицаПоТЧ 			= РезультатЗапросаПоТЧ.Выгрузить();
	 
	 ТаблицаПоТЧИСключения 			= Неопределено;
	 //Если НЕ Исключения.Количество()= 0 Тогда
		 РезультатЗапросаПоТЧИсключения 	= СформироватьЗапросПоТЧИсключения();
		 ТаблицаПоТЧИСключения 			= РезультатЗапросаПоТЧИсключения.Выгрузить();
	 //КонецЕсли;
	 
	 ПроверитьЗаполнениеТабличнойПривязкаТиповЦен(СтруктураШапкиДокумента, Отказ, Заголовок);
	 ПроверитьЗаполнениеТабличнойУточнения(СтруктураШапкиДокумента, Отказ, Заголовок);
	 ПроверитьЗаполнениеТабличнойИсключения(СтруктураШапкиДокумента, Отказ, Заголовок);
	 
	 Если Не ПЦ_СтатусДокумента =  Перечисления.ПЦ_СтатусыЦеновыеЭшелоны.Согласовано Тогда
		 Возврат;
	 КонецЕсли;
	 
	 Если Не Отказ Тогда
		 ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоТЧ, Отказ, Заголовок, ТаблицаПоТЧИСключения);
	 КонецЕсли;
	 
 КонецПроцедуры
 
 Функция СформироватьЗапросПоТабличнымЧастям()
	 ЗапросПоТЧ = Новый Запрос;
	 ЗапросПоТЧ.Текст ="ВЫБРАТЬ
	 |	ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.Регион,
	 //|	ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.ПроектГП,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныУточнения.ПроектГП, ЗНАЧЕНИЕ(Справочник.ПРГ_ПроектыГП.ПустаяСсылка)) КАК ПроектГП,
	 |	ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.КаналПродаж,
	 |	ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.УсловиеПоставки,
	 |	ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.ТипЦен,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныУточнения.Контрагент, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК Контрагент,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныУточнения.АдресПоставки, ЗНАЧЕНИЕ(Справочник.АдресаПоставки.ПустаяСсылка)) КАК АдресПоставки,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныУточнения.Дивизион, ЗНАЧЕНИЕ(Справочник.ПРГДивизионы.ПустаяСсылка)) КАК Дивизион,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныУточнения.ТоварнаяКатегория, ЗНАЧЕНИЕ(Справочник.НСИ_ТоварныеКатегории.ПустаяСсылка)) КАК ТоварнаяКатегория,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныУточнения.Брендообъем, ЗНАЧЕНИЕ(Справочник.НСИ_Брендообъемы.ПустаяСсылка)) КАК Брендообъем,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныУточнения.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Номенклатура
	 |ИЗ
	 |	Документ.ПЦ_ЦеновыеЭшелоны.ПривязкаТиповЦен КАК ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен
	 |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПЦ_ЦеновыеЭшелоны.Уточнения КАК ПЦ_ЦеновыеЭшелоныУточнения
	 |		ПО ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.УИД = ПЦ_ЦеновыеЭшелоныУточнения.УИД
	 |			И ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.Ссылка = ПЦ_ЦеновыеЭшелоныУточнения.Ссылка
	 |ГДЕ
	 |	ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.Ссылка = &Ссылка" ;
	 ЗапросПоТЧ.УстановитьПараметр("Ссылка",Ссылка);
	 
	 Возврат ЗапросПоТЧ.Выполнить();
	 
 КонецФункции 	
 
 Функция СформироватьЗапросПоТЧИсключения()
	 ЗапросПоТЧ = Новый Запрос;
	 ЗапросПоТЧ.Текст ="ВЫБРАТЬ
	 |	ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.Регион,
	 //|	ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.ПроектГП,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныИсключения.ПроектГП, ЗНАЧЕНИЕ(Справочник.ПРГ_ПроектыГП.ПустаяСсылка)) КАК ПроектГП,
	 |	ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.КаналПродаж,
	 |	ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.УсловиеПоставки,
	 |	ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.ТипЦен,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныИсключения.Контрагент, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК Контрагент,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныИсключения.АдресПоставки, ЗНАЧЕНИЕ(Справочник.АдресаПоставки.ПустаяСсылка)) КАК АдресПоставки,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныИсключения.Дивизион, ЗНАЧЕНИЕ(Справочник.ПРГДивизионы.ПустаяСсылка)) КАК Дивизион,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныИсключения.ТоварнаяКатегория, ЗНАЧЕНИЕ(Справочник.НСИ_ТоварныеКатегории.ПустаяСсылка)) КАК ТоварнаяКатегория,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныИсключения.Брендообъем, ЗНАЧЕНИЕ(Справочник.НСИ_Брендообъемы.ПустаяСсылка)) КАК Брендообъем,
	 |	ЕСТЬNULL(ПЦ_ЦеновыеЭшелоныИсключения.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Номенклатура
	 |ИЗ
	 |	Документ.ПЦ_ЦеновыеЭшелоны.Исключения КАК ПЦ_ЦеновыеЭшелоныИсключения
	 |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПЦ_ЦеновыеЭшелоны.ПривязкаТиповЦен КАК ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен
	 |		ПО ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.УИД = ПЦ_ЦеновыеЭшелоныИсключения.УИД
	 |			И ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.Ссылка = ПЦ_ЦеновыеЭшелоныИсключения.Ссылка
	 |ГДЕ
	 |	ПЦ_ЦеновыеЭшелоныПривязкаТиповЦен.Ссылка = &Ссылка" ;
	 ЗапросПоТЧ.УстановитьПараметр("Ссылка",Ссылка);
	 
	 Возврат ЗапросПоТЧ.Выполнить();
	 
 КонецФункции 	
 
 // Выполняет движения по регистрам.
 //
 // Параметры:
 //  СтруктураШапкиДокумента - структура реквизитов шапки.
 //  ТаблицаПоТоварам- таблица товаров.
 //  Отказ - флаг отказа в проведении.
 //  Заголовок - заголовок сообщения об ошибках.
 //
 Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоТЧ, Отказ, Заголовок, ТаблицаПоТЧИСключения = Неопределено)
	 
	 
	 НаборДвиженийТЧ 	= Движения.ПЦ_ЦеновыеЭшелоны;
	 ТаблицаДвиженийТЧ 	= НаборДвиженийТЧ.Выгрузить();
	 
	 //Нужно обнулить все записи которые уже есть
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ
	                |	ПЦ_ЦеновыеЭшелоныСрезПоследних.Регион,
	                |	ПЦ_ЦеновыеЭшелоныСрезПоследних.КаналПродаж,
	                |	ПЦ_ЦеновыеЭшелоныСрезПоследних.УсловиеПоставки,
	                |	ПЦ_ЦеновыеЭшелоныСрезПоследних.Контрагент,
	                |	ПЦ_ЦеновыеЭшелоныСрезПоследних.АдресПоставки,
					|	ПЦ_ЦеновыеЭшелоныСрезПоследних.Дивизион,
	                |	ПЦ_ЦеновыеЭшелоныСрезПоследних.ПроектГП,
	                |	ПЦ_ЦеновыеЭшелоныСрезПоследних.ТоварнаяКатегория,
	                |	ПЦ_ЦеновыеЭшелоныСрезПоследних.Брендообъем,
	                |	ПЦ_ЦеновыеЭшелоныСрезПоследних.Номенклатура,
	                |	ПЦ_ЦеновыеЭшелоныСрезПоследних.ХарактеристикаНоменклатуры,
	                |	ПЦ_ЦеновыеЭшелоныСрезПоследних.ТипЦен
	                |ИЗ
	                |	РегистрСведений.ПЦ_ЦеновыеЭшелоны.СрезПоследних(&Дата, Регистратор.ПЦ_Категория = &Категория) КАК ПЦ_ЦеновыеЭшелоныСрезПоследних";
	 Запрос.УстановитьПараметр("Дата", НачалоДня(Дата) - 1);
	 Запрос.УстановитьПараметр("Категория", ПЦ_Категория);
	 
	 Результат = Запрос.Выполнить().Выгрузить();
	 Сч = 0;
	 Пока Сч < Результат.Количество() Цикл
		 СтрРезультат =  Результат[Сч];
		 
		 СтрТаблицы = ТаблицаПоТЧ.НайтиСтроки(Новый Структура("Регион,КаналПродаж,УсловиеПоставки,Контрагент,АдресПоставки,Дивизион,ПроектГП,ТоварнаяКатегория,Брендообъем,Номенклатура", 
		 					СтрРезультат.Регион,
		 					СтрРезультат.КаналПродаж,  
							СтрРезультат.УсловиеПоставки,
							СтрРезультат.Контрагент,
							СтрРезультат.АдресПоставки,
							СтрРезультат.Дивизион,
		 					СтрРезультат.ПроектГП,
		 					СтрРезультат.ТоварнаяКатегория,
		 					СтрРезультат.Брендообъем,
		 					СтрРезультат.Номенклатура));
		 					//СтрРезультат.ХарактеристикаНоменклатуры,
		 					//СтрРезультат.ТипЦен));
		 Если СтрТаблицы.Количество() > 0 Тогда
			 Результат.Удалить(Сч);
		 Иначе
			 Сч = Сч + 1;
		 КонецЕсли;
		 
	 КонецЦикла; 
	 
	 Для каждого СтрРезультат  Из Результат  Цикл
		 
		 НоваяСтрока = ТаблицаПоТЧ.Добавить();
		 ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрРезультат);
		 НоваяСтрока.ТипЦен = Справочники.ТипыЦенНоменклатуры.ПустаяСсылка();
		 
	 КонецЦикла; 
	 
	 ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоТЧ, ТаблицаДвиженийТЧ);
	 
	 НаборДвиженийТЧ.мПериод          = Дата;
	 НаборДвиженийТЧ.мТаблицаДвижений = ТаблицаДвиженийТЧ;
	 
	 Если Не Отказ Тогда								
		 Движения.ПЦ_ЦеновыеЭшелоны.ВыполнитьДвижения();
		 НаборДвиженийТЧ.Записать();
	 КонецЕсли;
	 
	 
	 Если НЕ ТаблицаПоТЧИСключения = Неопределено Тогда
		 НаборДвиженийТЧИсключения 	= Движения.ПЦ_ИсключенияИзЦеновыхЭшелонов;
		 ТаблицаДвиженийТЧИСключения = НаборДвиженийТЧИсключения.Выгрузить();
		 
		 //Нужно обнулить все записи которые уже есть
		 Запрос = Новый Запрос;
		 Запрос.Текст = "ВЫБРАТЬ
		 |	ПЦ_ЦеновыеЭшелоныСрезПоследних.Регион,
		 |	ПЦ_ЦеновыеЭшелоныСрезПоследних.КаналПродаж,
		 |	ПЦ_ЦеновыеЭшелоныСрезПоследних.УсловиеПоставки,
		 |	ПЦ_ЦеновыеЭшелоныСрезПоследних.Контрагент,
		 |	ПЦ_ЦеновыеЭшелоныСрезПоследних.АдресПоставки,
		 |	ПЦ_ЦеновыеЭшелоныСрезПоследних.Дивизион,
		 |	ПЦ_ЦеновыеЭшелоныСрезПоследних.ПроектГП,
		 |	ПЦ_ЦеновыеЭшелоныСрезПоследних.ТоварнаяКатегория,
		 |	ПЦ_ЦеновыеЭшелоныСрезПоследних.Брендообъем,
		 |	ПЦ_ЦеновыеЭшелоныСрезПоследних.Номенклатура,
		 |	ПЦ_ЦеновыеЭшелоныСрезПоследних.ХарактеристикаНоменклатуры,
		 |	ПЦ_ЦеновыеЭшелоныСрезПоследних.ТипЦен
		 |ИЗ
		 |	РегистрСведений.ПЦ_ИсключенияИзЦеновыхЭшелонов.СрезПоследних(&Дата, Регистратор.ПЦ_Категория = &Категория) КАК ПЦ_ЦеновыеЭшелоныСрезПоследних";
		 Запрос.УстановитьПараметр("Дата", НачалоДня(Дата) - 1);
		 Запрос.УстановитьПараметр("Категория", ПЦ_Категория);
		 
		 Результат = Запрос.Выполнить().Выгрузить();
		 Сч = 0;
		 Пока Сч < Результат.Количество() Цикл
			 СтрРезультат =  Результат[Сч];
			 
			 СтрТаблицы = ТаблицаПоТЧИСключения.НайтиСтроки(Новый Структура("Регион,КаналПродаж,УсловиеПоставки,Контрагент,АдресПоставки,Дивизион,ПроектГП,ТоварнаяКатегория,Брендообъем,Номенклатура", 
			 	СтрРезультат.Регион,
			 	СтрРезультат.КаналПродаж,  
			 	СтрРезультат.УсловиеПоставки,
			 	СтрРезультат.Контрагент,
			 	СтрРезультат.АдресПоставки,
				СтрРезультат.Дивизион,
			 	СтрРезультат.ПроектГП,
			 	СтрРезультат.ТоварнаяКатегория,
			 	СтрРезультат.Брендообъем,
			 	СтрРезультат.Номенклатура));
			 	//СтрРезультат.ХарактеристикаНоменклатуры,
			 	//СтрРезультат.ТипЦен));
			 Если СтрТаблицы.Количество() > 0 Тогда
				 Результат.Удалить(Сч);
			 Иначе
				 Сч = Сч + 1;
			 КонецЕсли;
			 
		 КонецЦикла; 
		 
		 Для каждого СтрРезультат  Из Результат  Цикл
			 
			 НоваяСтрока = ТаблицаПоТЧИСключения.Добавить();
			 ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрРезультат);
			 НоваяСтрока.ТипЦен = Справочники.ТипыЦенНоменклатуры.ПустаяСсылка();
			 
		 КонецЦикла; 
		 
		 ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоТЧИСключения, ТаблицаДвиженийТЧИСключения);
		 
		 НаборДвиженийТЧИсключения.мПериод          = Дата;
		 НаборДвиженийТЧИсключения.мТаблицаДвижений = ТаблицаДвиженийТЧИСключения;
		 Если Не Отказ Тогда								
			 
			 Движения.ПЦ_ИсключенияИзЦеновыхЭшелонов.ВыполнитьДвижения();
			 НаборДвиженийТЧИсключения.Записать();
		 КонецЕсли;		
		 
	 КонецЕсли;			 
	 
 КонецПроцедуры // ДвиженияПоРегистрам()
 
 // Процедура - обработчик события "ПередЗаписью".
 //
 Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	 Если ОбменДанными.Загрузка  Тогда
		 Возврат;
	 КонецЕсли;
	 
	 //m.ionov@a-prof.ru 15.10.2014
	Если Не Отказ Тогда
		РазрешитьЗапись = Ложь;
		Если ДополнительныеСвойства.Свойство("РазрешитьЗапись", РазрешитьЗапись) = Ложь Тогда
			РазрешитьЗапись = Ложь;
		КонецЕсли;
		
		Если Не РазрешитьЗапись Тогда
			Отказ = Не МожноМенятьДокумент();						
		КонецЕсли;		
	КонецЕсли;
	//----m.ionov@a-prof.ru---
	 	 	 
	 мУдалятьДвижения = НЕ ЭтоНовый();
	 
 КонецПроцедуры // ПередЗаписью()
 
 Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)
	 
	 // Укажем, что надо проверить.
	 СтруктураОбязательныхПолей = Новый Структура;
	 
	 СтруктураОбязательныхПолей.Вставить("Организация");
	 СтруктураОбязательныхПолей.Вставить("ПЦ_СтатусДокумента");
	 СтруктураОбязательныхПолей.Вставить("ПЦ_Категория");
	 СтруктураОбязательныхПолей.Вставить("Ответственный");
	 
	 // Теперь вызовем общую процедуру проверки.
	 ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	 
 КонецПроцедуры // ПроверитьЗаполнениеШапки()
 
 Процедура ПроверитьЗаполнениеТабличнойПривязкаТиповЦен(СтруктураШапкиДокумента, Отказ, Заголовок)
	 
	 // Укажем, что надо проверить:
	 СтруктураОбязательныхПолей = Новый Структура("УИД");
	 
	 //СтруктураОбязательныхПолей.Вставить("Регион");
	 //СтруктураОбязательныхПолей.Вставить("ПроектГП");
	 СтруктураОбязательныхПолей.Вставить("ТипЦен");	
	 
	 // Теперь вызовем общую процедуру проверки.
	 ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ПривязкаТиповЦен", СтруктураОбязательныхПолей, Отказ, Заголовок);
	 
	 Если Не Отказ Тогда
		 Для каждого СтрокаТабЧасти  Из ПривязкаТиповЦен Цикл
			 Если Не СтрокаТабЧасти.ТипЦен.ПЦ_Категория = ПЦ_Категория Тогда
			 	 ОбщегоНазначения.СообщитьОбОшибке("Для строки ценового эшелона № " + СокрЛП(ПривязкаТиповЦен.Индекс(СтрокаТабЧасти) + 1) + " указан тип цен с категорией " + СокрЛП(СтрокаТабЧасти.ТипЦен.ПЦ_Категория) + " которая не соответсвует документу!", Отказ);		 
			 КонецЕсли; 	 
         КонецЦикла;
	 КонецЕсли;
 КонецПроцедуры 
 
 Процедура ПроверитьЗаполнениеТабличнойУточнения(СтруктураШапкиДокумента, Отказ, Заголовок)
	 
	 // Укажем, что надо проверить:
	 СтруктураОбязательныхПолей = Новый Структура("УИД");
	 
	 
	 // Теперь вызовем общую процедуру проверки.
	 ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Уточнения", СтруктураОбязательныхПолей, Отказ, Заголовок);
	 
	 Если Не Отказ Тогда
		 Для каждого СтрокаТабЧасти  Из Уточнения Цикл
			 
			 СтрокаПривязки = ПривязкаТиповЦен.Найти(СтрокаТабЧасти.УИД, "УИД");
			 Если СтрокаПривязки = Неопределено Тогда
				 ОбщегоНазначения.СообщитьОбОшибке("Ошибка заполнения уточнений к ценовым эшелонам, есть пустые строки", Отказ);
				 Возврат;
			 КонецЕсли;
			 
			 Если ЗначениеЗаполнено(СтрокаТабЧасти.АдресПоставки) И Не ЗначениеЗаполнено(СтрокаТабЧасти.Контрагент) Тогда
				 ОбщегоНазначения.СообщитьОбОшибке("Для строки ценового эшелона № " + СокрЛП(ПривязкаТиповЦен.Индекс(СтрокаПривязки) + 1) + " в уточнениях указан адрес поставки, но не указан контрагент", Отказ);
			 КонецЕсли;
			 
			 Если ЗначениеЗаполнено(СтрокаТабЧасти.Номенклатура) и (Не ЗначениеЗаполнено(СтрокаТабЧасти.Брендообъем) ИЛИ Не ЗначениеЗаполнено(СтрокаТабЧасти.ТоварнаяКатегория) ИЛИ Не ЗначениеЗаполнено(СтрокаТабЧасти.ПроектГП)) Тогда
				 ОбщегоНазначения.СообщитьОбОшибке("Для строки ценового эшелона № " + СокрЛП(ПривязкаТиповЦен.Индекс(СтрокаПривязки) + 1) + " в уточнениях указана номенклатура, но не указана товарная категория или брендообъем или проект ГП", Отказ);
			 КонецЕсли;
			 
			 Если Не ЗначениеЗаполнено(СтрокаТабЧасти.Контрагент) И Не ЗначениеЗаполнено(СтрокаТабЧасти.АдресПоставки) И Не ЗначениеЗаполнено(СтрокаТабЧасти.Дивизион) 
				 И Не ЗначениеЗаполнено(СтрокаТабЧасти.ТоварнаяКатегория) И Не ЗначениеЗаполнено(СтрокаТабЧасти.Брендообъем)
				 И Не ЗначениеЗаполнено(СтрокаТабЧасти.Номенклатура) И Не ЗначениеЗаполнено(СтрокаТабЧасти.ПроектГП) Тогда
				 ОбщегоНазначения.СообщитьОбОшибке("Для строки ценового эшелона № " + СокрЛП(ПривязкаТиповЦен.Индекс(СтрокаПривязки) + 1) + " в уточнениях указана пустая строка", Отказ);
			 КонецЕсли;
		 КонецЦикла; 
	 КонецЕсли;
	 
 КонецПроцедуры 
 
 Процедура ПроверитьЗаполнениеТабличнойИсключения(СтруктураШапкиДокумента, Отказ, Заголовок)
	 
	 // Укажем, что надо проверить:
	 СтруктураОбязательныхПолей = Новый Структура("УИД");
	 
	 
	 // Теперь вызовем общую процедуру проверки.
	 ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Исключения", СтруктураОбязательныхПолей, Отказ, Заголовок);
	 
	 Если Не Отказ Тогда
		 Для каждого СтрокаТабЧасти  Из Исключения Цикл
			 
			 СтрокаПривязки = ПривязкаТиповЦен.Найти(СтрокаТабЧасти.УИД, "УИД");
			 Если СтрокаПривязки = Неопределено Тогда
				 ОбщегоНазначения.СообщитьОбОшибке("Ошибка заполнения исключений к ценовым эшелонам, есть пустые строки", Отказ);
				 Возврат;
			 КонецЕсли;
			 
			 Если ЗначениеЗаполнено(СтрокаТабЧасти.АдресПоставки) И Не ЗначениеЗаполнено(СтрокаТабЧасти.Контрагент) Тогда
				 ОбщегоНазначения.СообщитьОбОшибке("Для строки ценового эшелона № " + СокрЛП(ПривязкаТиповЦен.Индекс(СтрокаПривязки) + 1) + " в исключениях указан адрес поставки, но не указан контрагент", Отказ);
			 КонецЕсли;
			 
			 Если ЗначениеЗаполнено(СтрокаТабЧасти.Номенклатура) и (Не ЗначениеЗаполнено(СтрокаТабЧасти.Брендообъем) ИЛИ Не ЗначениеЗаполнено(СтрокаТабЧасти.ТоварнаяКатегория) ИЛИ Не ЗначениеЗаполнено(СтрокаТабЧасти.ПроектГП)) Тогда
				 ОбщегоНазначения.СообщитьОбОшибке("Для строки ценового эшелона № " + СокрЛП(ПривязкаТиповЦен.Индекс(СтрокаПривязки) + 1) + " в исключениях указана номенклатура, но не указана товарная категория или брендообъем или проект ГП", Отказ);
			 КонецЕсли;
			 
			 Если Не ЗначениеЗаполнено(СтрокаТабЧасти.Контрагент) И Не ЗначениеЗаполнено(СтрокаТабЧасти.АдресПоставки) И Не ЗначениеЗаполнено(СтрокаТабЧасти.Дивизион) 
				 И Не ЗначениеЗаполнено(СтрокаТабЧасти.ТоварнаяКатегория) И Не ЗначениеЗаполнено(СтрокаТабЧасти.Брендообъем)
				 И Не ЗначениеЗаполнено(СтрокаТабЧасти.Номенклатура) И Не ЗначениеЗаполнено(СтрокаТабЧасти.ПроектГП) Тогда
				 ОбщегоНазначения.СообщитьОбОшибке("Для строки ценового эшелона № " + СокрЛП(ПривязкаТиповЦен.Индекс(СтрокаПривязки) + 1) + " в исключениях указана пустая строка", Отказ);
			 КонецЕсли;
		 КонецЦикла; 
	 КонецЕсли;
	 
 КонецПроцедуры
 
 Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
    	
	ЗаписатьИзменениеСтатусов(Отказ);
КонецПроцедуры

Процедура ЗаписатьИзменениеСтатусов(Отказ) Экспорт
	
	//Движения по регистру накопления "АП_СтатусыДокументов"
	ДанныеПоСтатусу = РегистрыСведений.АП_СтатусыДокументов.СрезПоследних(ТекущаяДата(), Новый Структура("Документ", Ссылка));
	
	Если ДанныеПоСтатусу.Количество() = 0 Тогда
		СформируемЗаписьПоРегиструСтатусы(Отказ);
	ИначеЕсли НЕ ДанныеПоСтатусу[0].Статус = ПЦ_СтатусДокумента Тогда
	    СформируемЗаписьПоРегиструСтатусы(Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура СформируемЗаписьПоРегиструСтатусы(Отказ)

	мДатаЗаписи = ТекущаяДата();
	
	НаборЗаписей = РегистрыСведений.АП_СтатусыДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Ссылка);
	НаборЗаписей.Отбор.Период.Установить(мДатаЗаписи);
	
	НаборЗаписей.Прочитать();
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = мДатаЗаписи;
	НоваяСтрока.Документ = Ссылка;
	НоваяСтрока.Статус = ПЦ_СтатусДокумента;
	НоваяСтрока.Ответственный = глЗначениеПеременной("глТекущийПользователь");
	
	Попытка		
		НаборЗаписей.Записать();		
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки(), Отказ);
	КонецПопытки;
	
КонецПроцедуры
 
 Функция МожноМенятьДокумент() Экспорт
	 //Проверка на существование более поздних документов
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	                |	ПЦ_ЦеновыеЭшелоныСрезПервых.Регистратор
	                |ИЗ
	                |	РегистрСведений.ПЦ_ЦеновыеЭшелоны.СрезПервых(&Дата, Регистратор.ПЦ_Категория = &Категория) КАК ПЦ_ЦеновыеЭшелоныСрезПервых
	                |ГДЕ
	                |	НЕ ПЦ_ЦеновыеЭшелоныСрезПервых.Регистратор = &Ссылка
	                |
	                |УПОРЯДОЧИТЬ ПО
	                |	ПЦ_ЦеновыеЭшелоныСрезПервых.Регистратор.Дата";
	 
	 Запрос.УстановитьПараметр("Дата", НачалоДня(Дата));
	 Запрос.УстановитьПараметр("Ссылка", Ссылка);
	 Запрос.УстановитьПараметр("Категория", ПЦ_Категория);
	 
	 Результат = Запрос.Выполнить();
	 ВыборкаДетальныеЗаписи = Результат.Выбрать();
	 
	 Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		 ОбщегоНазначения.Сообщение("Существуют более поздний документ установки ценовых эшелонов " + СокрЛП(ВыборкаДетальныеЗаписи.Регистратор) + " .Данный документ запрещено менять", СтатусСообщения.Важное);			
		 Если РольДоступна("АП_АдминистраторПродаж") 
			 //{29.03.2016 Островерхий заявка №б/н 
			 ИЛИ РольДоступна("ПКК_РуководительОКК") 
			 //29.03.2016 Островерхий} 
			 тогда
			 Возврат Истина;
		 Иначе
		 	Возврат Ложь;
		КонецЕсли;
	 Иначе
		 Возврат Истина;
	 КонецЕсли;	 
 КонецФункции
 
 мУдалятьДвижения = Ложь;
 