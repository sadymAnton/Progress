﻿
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
	 
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	РезультатЗапросаПоТЧ 	= СформироватьЗапросПоТЧ();
	ТаблицаПоТЧ 			= РезультатЗапросаПоТЧ.Выгрузить();
	
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоТЧ, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьЗапросПоТЧ()
	 ЗапросПоТЧ = Новый Запрос;
	 ЗапросПоТЧ.Текст ="ВЫБРАТЬ
	                   |	ПП_ПланПроведенияПромоАкцийТабличнаяЧасть.Брендообъем,
	                   |	ПП_ПланПроведенияПромоАкцийТабличнаяЧасть.Дивизион,
	                   |	ПП_ПланПроведенияПромоАкцийТабличнаяЧасть.КатегорияКлиента,
	                   |	ПП_ПланПроведенияПромоАкцийТабличнаяЧасть.Вывеска,
	                   |	ПП_ПланПроведенияПромоАкцийТабличнаяЧасть.ВидПоказателя,
	                   |	ПП_ПланПроведенияПромоАкцийТабличнаяЧасть.Показатель,
	                   |	ПП_ПланПроведенияПромоАкцийТабличнаяЧасть.Группа,
	                   |	ПП_ПланПроведенияПромоАкцийТабличнаяЧасть.Ссылка.Период КАК Месяц,
	                   |	ПП_ПланПроведенияПромоАкцийТабличнаяЧасть.СкидкаПредоставляетсяВСчете
	                   |ИЗ
	                   |	Документ.ПП_ПланПроведенияПромоАкций.ТабличнаяЧасть КАК ПП_ПланПроведенияПромоАкцийТабличнаяЧасть
	                   |ГДЕ
	                   |	ПП_ПланПроведенияПромоАкцийТабличнаяЧасть.Ссылка = &Ссылка" ;
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
 Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоТЧ, Отказ, Заголовок)
	 
	 НаборДвиженийТЧ 	= Движения.ППП_ПланПроведенияПромоАкций;
	 ТаблицаДвиженийТЧ 	= НаборДвиженийТЧ.Выгрузить();
	 
	 //Нужно обнулить все записи которые уже есть
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ
	                |	ППП_ПланПроведенияПромоАкций.Дивизион,
	                |	ППП_ПланПроведенияПромоАкций.КатегорияКлиента,
	                |	ППП_ПланПроведенияПромоАкций.Брендообъем,
	                |	ППП_ПланПроведенияПромоАкций.Вывеска,
	                |	ППП_ПланПроведенияПромоАкций.Месяц,
	                |	ППП_ПланПроведенияПромоАкций.Группа,
	                |	ППП_ПланПроведенияПромоАкций.ВидПоказателя,
	                |	ППП_ПланПроведенияПромоАкций.СкидкаПредоставляетсяВСчете
	                |ИЗ
	                |	РегистрСведений.ППП_ПланПроведенияПромоАкций.СрезПоследних(&Дата, Месяц = &Месяц) КАК ППП_ПланПроведенияПромоАкций";
	 Запрос.УстановитьПараметр("Дата", НачалоДня(Дата) - 1);
	 Запрос.УстановитьПараметр("Месяц", НачалоМесяца(Период));
	 
	 Результат = Запрос.Выполнить().Выгрузить();
	 Сч = 0;
	 Пока Сч < Результат.Количество() Цикл
		 СтрРезультат =  Результат[Сч];
		 //bolshevykh@a-prof.ru 12.03.2015
		 СтрТаблицы = ТаблицаПоТЧ.НайтиСтроки(Новый Структура("Дивизион,КатегорияКлиента,Брендообъем,Вывеска,Месяц,Группа,ВидПоказателя,СкидкаПредоставляетсяВСчете", 
		 //bolshevykh@a-prof.ru 12.03.2015
		 					СтрРезультат.Дивизион,
		 					СтрРезультат.КатегорияКлиента,  
							СтрРезультат.Брендообъем,
							СтрРезультат.Вывеска,
							СтрРезультат.Месяц,
							//bolshevykh@a-prof.ru 12.03.2015
							СтрРезультат.Группа,
							//bolshevykh@a-prof.ru 12.03.2015
							СтрРезультат.ВидПоказателя,
							//{10.06.2016 Островерхий заявка №б/н 
							СтрРезультат.СкидкаПредоставляетсяВСчете 
							//10.06.2016 Островерхий} 
							));
		 Если СтрТаблицы.Количество() > 0 Тогда
			 Результат.Удалить(Сч);
		 Иначе
			 Сч = Сч + 1;
		 КонецЕсли;
		 
	 КонецЦикла; 
	 
	 Для каждого СтрРезультат  Из Результат  Цикл
		 НоваяСтрока = ТаблицаПоТЧ.Добавить();
		 ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрРезультат);
		 НоваяСтрока.Показатель = 0;
	 КонецЦикла; 
	 
	 ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоТЧ, ТаблицаДвиженийТЧ);
	 
	 НаборДвиженийТЧ.мПериод          = Дата;
	 НаборДвиженийТЧ.мТаблицаДвижений = ТаблицаДвиженийТЧ;
	 
	 Если Не Отказ Тогда								
	 	Движения.ППП_ПланПроведенияПромоАкций.ВыполнитьДвижения();
		НаборДвиженийТЧ.Записать();
	 КонецЕсли;
	 
 КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = НЕ МожноМенятьДокумент();	
	
	мУдалятьДвижения = НЕ ЭтоНовый();
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = глЗначениеПеременной("глТекущийПользователь");
	КонецЕсли;
	
 КонецПроцедуры
 
 Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)
	 
	 // Укажем, что надо проверить.
	 СтруктураОбязательныхПолей = Новый Структура;
	 
	 СтруктураОбязательныхПолей.Вставить("Организация");
	 СтруктураОбязательныхПолей.Вставить("Ответственный");
	 СтруктураОбязательныхПолей.Вставить("Период");
	 
	 // Теперь вызовем общую процедуру проверки.
	 ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	 
 КонецПроцедуры // ПроверитьЗаполнениеШапки()

Функция МожноМенятьДокумент() экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ППП_ПланПроведенияПромоАкций.Регистратор
		|ИЗ
		|	РегистрСведений.ППП_ПланПроведенияПромоАкций.СрезПервых(&Дата, Месяц = &Месяц и Регистратор <> &Регистратор ) КАК ППП_ПланПроведенияПромоАкций";

	Запрос.УстановитьПараметр("Месяц", НачалоМесяца(Период));
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Регистратор", Ссылка);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ОбщегоНазначения.Сообщение("Существуют более поздний документ " + СокрЛП(ВыборкаДетальныеЗаписи.Регистратор) + " .Данный документ запрещено менять", СтатусСообщения.Важное);			
		Если РольДоступна("АП_АдминистраторПродаж") тогда
			 Возврат Истина;
		Иначе
		 	Возврат Ложь;
		КонецЕсли;
	 Иначе
		 Возврат Истина;
	 КонецЕсли;	 
	
КонецФункции

 мУдалятьДвижения = Ложь;

