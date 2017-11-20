﻿#Если Клиент Тогда
Перем НП Экспорт;
Перем НачГраница, КонГраница;

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом
//	ПоказыватьЗаголовок - признак видимости строк с заголовком отчета
//	ВысотаЗаголовка - параметр, через который возвращается высота заголовка в строках 
//
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок = Ложь) Экспорт

	ДокументРезультат.Очистить();
	
	НачГраница = ?(НЕ ЗначениеЗаполнено(ДатаНач),неопределено,Новый Граница(НачалоДня(ДатаНач), ВидГраницы.Включая));
	КонГраница = ?(НЕ ЗначениеЗаполнено(ДатаКон),неопределено,Новый Граница(КонецДня(ДатаКон), ВидГраницы.Включая));

	Макет = ПолучитьМакет("Макет");
	Заголовок = Макет.ПолучитьОбласть("Заголовок");
	ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	СтрокаТаблицы 	 = Макет.ПолучитьОбласть("СтрокаТаблицы");
	СтрокаТаблицыСИтогом = Макет.ПолучитьОбласть("СтрокаТаблицыСИтогом");
	СтрокаТаблицыИтог= Макет.ПолучитьОбласть("СтрокаТаблицыИтог");
	ИтогиТаблицы 	 = Макет.ПолучитьОбласть("СтрокаИтогов");
	
	Заголовок.Параметры.НазваниеОрганизации = Организация.НаименованиеПолное;
	Заголовок.Параметры.Заголовок = "Сравнение данных о суммах НДС, исчисленных с авансов полученных, в бухгалтерском учете и специализированных регистрах";
	Заголовок.Параметры.ОписаниеПериода = "" + Формат(ДатаНач, "ДФ = ""дд.ММ.гггг""; ДП = ""...""") + " - " + 
											   Формат(ДатаКон, "ДФ = ""дд.ММ.гггг""; ДП = ""...""");
											   
	// Параметр для показа заголовка
	ВысотаЗаголовка = ДокументРезультат.ВысотаТаблицы;

	ДокументРезультат.Вывести(Заголовок);
	
	// Когда нужен только заголовок:
	Если ТолькоЗаголовок Тогда
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(ВысотаЗаголовка) Тогда
		ДокументРезультат.Область("R1:R" + ВысотаЗаголовка).Видимость = ПоказыватьЗаголовок;
	КонецЕсли;
	// Сначала формируется таблица, отражающая сравнение начисленного НДС с авансов 
	// по данным БухИтогов и данным подсистемы НДС
	ЗаголовокТаблицы.Параметры.ОписаниеТаблицы = "1. Суммы НДС с авансов, начисленные к уплате в бюджет";
	ЗаголовокТаблицы.Параметры.ЗаголовокКолонкиИтоговРегистра = "Сумма НДС по регистру ""НДС продажи""";
	ЗаголовокТаблицы.Параметры.ЗаголовокКолонкиБухИтогов = "Сумма НДС по дебету счета 76.АВ";
	ДокументРезультат.Вывести(ЗаголовокТаблицы);
		
	РезультирующаяТаблица = ВыполнитьСравнительныйЗапросПоРегиструИБухИтогамДляНачисленийАвансов();
	
	СтруктураОтбора = Новый Структура("ДоговорКонтрагента");
	
	Если Не СводныеИтоги Тогда
		
		Для Каждого СтрокаРез Из РезультирующаяТаблица Цикл
			
			СтруктураОтбора.ДоговорКонтрагента = СтрокаРез.ДоговорКонтрагента;
			СтрокаТаблицы.Параметры.ДатаПоступления = Формат(СтрокаРез.Дата, "ДФ=dd.MM.yyyy");
			СтрокаТаблицы.Параметры.Контрагент = СтрокаРез.Контрагент;
			СтрокаТаблицы.Параметры.Договор = 	 СтрокаРез.ДоговорКонтрагента;
			СтрокаТаблицы.Параметры.ДокументПоступленияАванса = СтрокаРез.ДокументПоступления;
			СтрокаТаблицы.Параметры.СчетФактураНаАванс = УчетНДС.НайтиПодчиненныйСчетФактуру(СтрокаРез.ДокументПоступления, "СчетФактураВыданный", СтруктураОтбора);
			СтрокаТаблицы.Параметры.СтавкаНДС =  СтрокаРез.СтавкаНДС;
			
			СтрокаТаблицы.Параметры.СуммаАванса = 	 	 СтрокаРез.СуммаАванса;
			СтрокаТаблицы.Параметры.СуммаНДСПоРегистру = СтрокаРез.СуммаНДСПоРегистру;
			СтрокаТаблицы.Параметры.СуммаНДСПоБухСчету = СтрокаРез.СуммаНДСПоБухСчету;
			СтрокаТаблицы.Параметры.Разница =  			 СтрокаРез.Разница;
			
			ДокументРезультат.Вывести(СтрокаТаблицы);
			
		КонецЦикла;
		
	КонецЕсли;
		
	ИтогиТаблицы.Параметры.ИтогСуммаАванса = 		РезультирующаяТаблица.Итог("СуммаАванса");
	ИтогиТаблицы.Параметры.ИтогСуммаНДСПоРегистру = РезультирующаяТаблица.Итог("СуммаНДСПоРегистру");
	ИтогиТаблицы.Параметры.ИтогСуммаНДСПоБухСчету = РезультирующаяТаблица.Итог("СуммаНДСПоБухСчету");
	ИтогиТаблицы.Параметры.ИтогРазница = 			РезультирующаяТаблица.Итог("Разница");
	
	ДокументРезультат.Вывести(ИтогиТаблицы);
	
	// Далее формируется таблица, отражающая сравнение НДС по полученным авансам, 
	// который был принят к вычету в связи с зачетом этих авансов
	ЗаголовокТаблицы.Параметры.ОписаниеТаблицы = "2. Суммы НДС, предъявленные к вычету в связи с зачетом авансов";
	ЗаголовокТаблицы.Параметры.ЗаголовокКолонкиИтоговРегистра = "Сумма НДС по регистру ""НДС покупки""";
	ЗаголовокТаблицы.Параметры.ЗаголовокКолонкиБухИтогов = "Сумма НДС по кредиту счета 76.АВ";
	ДокументРезультат.Вывести(ЗаголовокТаблицы);
	
	ВыполнитьСравнительныйЗапросПоРегиструИБухИтогамДляЗачетаАвансов(РезультирующаяТаблица);
	
	Если Не СводныеИтоги Тогда
		
		Для Каждого СтрокаРез Из РезультирующаяТаблица Цикл
			
			СтрокаТаблицы.Параметры.ДатаПоступления 	= Формат(СтрокаРез.Дата, "ДФ=dd.MM.yyyy");
			СтрокаТаблицы.Параметры.Контрагент 			= СтрокаРез.Контрагент;
			СтрокаТаблицы.Параметры.Договор 			= СтрокаРез.ДоговорКонтрагента;
			СтрокаТаблицы.Параметры.ДокументПоступленияАванса = СтрокаРез.ДокументПоступления;
			СтрокаТаблицы.Параметры.СчетФактураНаАванс 	= УчетНДС.НайтиПодчиненныйСчетФактуру(СтрокаРез.ДокументПоступления, "СчетФактураВыданный");
			СтрокаТаблицы.Параметры.СтавкаНДС 			= СтрокаРез.СтавкаНДС;
			СтрокаТаблицы.Параметры.СуммаАванса 		= СтрокаРез.СуммаАванса;
			СтрокаТаблицы.Параметры.СуммаНДСПоРегистру 	= СтрокаРез.СуммаНДСПоРегистру;
			СтрокаТаблицы.Параметры.СуммаНДСПоБухСчету 	= СтрокаРез.СуммаНДСПоБухСчету;
			СтрокаТаблицы.Параметры.Разница 			= СтрокаРез.Разница;
				
			ДокументРезультат.Вывести(СтрокаТаблицы);
				
		КонецЦикла;
		
	КонецЕсли;
		
	ИтогиТаблицы.Параметры.ИтогСуммаАванса = 		РезультирующаяТаблица.Итог("СуммаАванса");
	ИтогиТаблицы.Параметры.ИтогСуммаНДСПоРегистру = РезультирующаяТаблица.Итог("СуммаНДСПоРегистру");
	ИтогиТаблицы.Параметры.ИтогСуммаНДСПоБухСчету = РезультирующаяТаблица.Итог("СуммаНДСПоБухСчету");
	ИтогиТаблицы.Параметры.ИтогРазница = 			РезультирующаяТаблица.Итог("Разница");
	
	ДокументРезультат.Вывести(ИтогиТаблицы);
	
	ДокументРезультат.Автомасштаб = Истина;

КонецПроцедуры

// Выполняет сравнительный запрос к БД для сопоставления информации между регистром учета НДС
// и бухитогами для операций начислений авансов
//
Функция ВыполнитьСравнительныйЗапросПоРегиструИБухИтогамДляНачисленийАвансов()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр( "Организация",   Организация);
	Запрос.УстановитьПараметр( "НачалоПериода", НачГраница);
	Запрос.УстановитьПараметр( "КонецПериода",  КонГраница);
	
	ТекстФильтраПоКонтрагенту = "";
	Если ЗначениеЗаполнено(Контрагент) Тогда
		// Установлен фильтр по контрагенту
		Запрос.УстановитьПараметр("Контрагент", Контрагент);
		ТекстФильтраПоКонтрагенту = " И НДСсАвансовОбороты.Покупатель = &Контрагент";
	КонецЕсли;
	
	ТекстФильтраПоДоговору = "";
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		// Установлен фильтр по договору
		Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
		ТекстФильтраПоКонтрагенту = " И НДСсАвансовОбороты.ДоговорКонтрагента = &ДоговорКонтрагента";
	КонецЕсли;
	
	Если ВидАвансов = 0 Тогда
		Запрос.УстановитьПараметр( "НДС0", Перечисления.СтавкиНДС.НДС0);
		ТекстФильтрПоСтавке = " И СтавкаНДс <> &НДС0 ";
	ИначеЕсли ВидАвансов = 1 Тогда
		Запрос.УстановитьПараметр( "НДС0", Перечисления.СтавкиНДС.НДС0);
		ТекстФильтрПоСтавке = " И СтавкаНДс = &НДС0 ";
	Иначе
		ТекстФильтрПоСтавке = "";
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НДСсАвансовОбороты.Регистратор,
	|	НДСсАвансовОбороты.Регистратор.Дата КАК Дата,
	|	НДСсАвансовОбороты.Покупатель КАК Контрагент,
	|	НДСсАвансовОбороты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	НДСсАвансовОбороты.СчетФактура КАК ДокументПоступления,
	|	НДСсАвансовОбороты.СтавкаНДС,
	|	НДСсАвансовОбороты.СуммаБезНДСПриход + НДСсАвансовОбороты.НДСПриход КАК СуммаАванса,
	|	НДСсАвансовОбороты.СуммаБезНДСПриход КАК СуммаБезНДС,
	|	НДСсАвансовОбороты.НДСПриход КАК НДС
	|ИЗ
	|	РегистрНакопления.НДСсАвансов.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Организация = &Организация " + ТекстФильтрПоСтавке + " И ВидЦенности = ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.АвансыПолученные)) КАК НДСсАвансовОбороты
	|ГДЕ
	|	НДСсАвансовОбороты.Организация = &Организация
	|   " + ТекстФильтраПоКонтрагенту + "
	|   " + ТекстФильтраПоДоговору + "
	|";
					
	ДанныеПодсистемыНДС = Запрос.Выполнить().Выгрузить();
	
	Запрос.УстановитьПараметр("Организация",	Организация);
	Запрос.УстановитьПараметр("НачалоПериода",  НачГраница);
	Запрос.УстановитьПараметр("КонецПериода",   КонГраница);
	
	Запрос.УстановитьПараметр("СчетАнализа", 	ПланыСчетов.Хозрасчетный.НДСпоАвансамИПредоплатам);
	Запрос.УстановитьПараметр("КорСчетАнализа", ПланыСчетов.Хозрасчетный.НДС);
	
	ТекстФильтраПоКонтрагенту = "";
	Если ЗначениеЗаполнено(Контрагент) Тогда
		// Установлен фильтр по контрагенту
		Запрос.УстановитьПараметр("Контрагент", Контрагент);
		ТекстФильтраПоКонтрагенту = " И ХозрасчетныйОбороты.Субконто1 = &Контрагент";
	КонецЕсли;
	
	ТекстФильтраПоДоговору = "";
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		// Установлен фильтр по договору
		Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
		ТекстФильтраПоКонтрагенту = " И ХозрасчетныйОбороты.Субконто2.ДоговорКонтрагента = &ДоговорКонтрагента";
	КонецЕсли;
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХозрасчетныйОбороты.Регистратор,
	|	ХозрасчетныйОбороты.Счет КАК СчетУчетаНДС,
	|	ХозрасчетныйОбороты.Субконто1 КАК Контрагент,
	|	ХозрасчетныйОбороты.Субконто2 КАК ДокументПоступления,
	|	СУММА(ХозрасчетныйОбороты.СуммаОборотДт) КАК СуммаОборотДт
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Счет В ИЕРАРХИИ (&СчетАнализа), , Организация = &Организация, КорСчет В ИЕРАРХИИ (&КорСчетАнализа), ) КАК ХозрасчетныйОбороты
	|ГДЕ
	|	ХозрасчетныйОбороты.СуммаОборотДт <> 0
	|   " + ТекстФильтраПоКонтрагенту + "
	|   " + ТекстФильтраПоДоговору + "
	|
	|СГРУППИРОВАТЬ ПО
	|	ХозрасчетныйОбороты.Регистратор,
	|	ХозрасчетныйОбороты.Счет,
	|	ХозрасчетныйОбороты.Субконто1,
	|	ХозрасчетныйОбороты.Субконто2";
					
	ДанныеПоБухИтогам = Запрос.Выполнить().Выгрузить();
	ДанныеПоБухИтогам.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
	ДанныеПоБухИтогам.Колонки.Добавить("ДоговорКонтрагента", Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов"));
	
	т = 0;
	Пока т < ДанныеПоБухИтогам.Количество() Цикл
		СтрокаДанных = ДанныеПоБухИтогам[т];
		ДокРег = ДанныеПоБухИтогам[т]["Регистратор"].ПолучитьОбъект();
		
		СтрокаУдалена = Ложь;
		
		Если ТипЗнч(ДокРег) = Тип("ДокументОбъект.СчетФактураВыданный") Тогда
			Если ДокРег.ДокументыОснования.Количество() > 0 Тогда
				СтрокаДанных["ДокументПоступления"] = ДокРег.ДокументыОснования[0]["ДокументОснование"];
			КонецЕсли;
			
			// проверяем условие фильтрации по виду ценности
			Если ВидАвансов = 0 Тогда
				Если ДокРег.Под0 Тогда
					// данную операцию не нужно включать в анализ
					ДанныеПоБухИтогам.Удалить(т);
					СтрокаУдалена = Истина;
				КонецЕсли;
			ИначеЕсли ВидАвансов = 1 Тогда
				Если НЕ ДокРег.Под0 Тогда
					// данную операцию не нужно включать в анализ
					ДанныеПоБухИтогам.Удалить(т);
					СтрокаУдалена = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Не СтрокаУдалена тогда
			Если СтрокаДанных.ДокументПоступления.Метаданные().Реквизиты.Найти("ДоговорКонтрагента") <> Неопределено 
				И ЗначениеЗаполнено(СтрокаДанных.ДокументПоступления.ДоговорКонтрагента) Тогда
				СтрокаДанных.ДоговорКонтрагента = СтрокаДанных.ДокументПоступления.ДоговорКонтрагента;
			ИначеЕсли ДокРег.Метаданные().Реквизиты.Найти("ДоговорКонтрагента") <> Неопределено Тогда
				СтрокаДанных.ДоговорКонтрагента = ДокРег.ДоговорКонтрагента;
			КонецЕсли;
				
			СтрокаДанных.Дата = ДокРег.Дата;
			т = т + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	РезультирующаяТаблица = ДанныеПодсистемыНДС.Скопировать();
	РезультирующаяТаблица.Колонки.Добавить("СуммаНДСПоРегистру", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));
	РезультирующаяТаблица.Колонки.Добавить("СуммаНДСПоБухСчету", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));
	РезультирующаяТаблица.Колонки.Добавить("Разница", 			 Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));
	
	РезультирующаяТаблица.ЗагрузитьКолонку(РезультирующаяТаблица.ВыгрузитьКолонку("НДС"), "СуммаНДСПоРегистру");
	РезультирующаяТаблица.ЗагрузитьКолонку(РезультирующаяТаблица.ВыгрузитьКолонку("НДС"), "Разница");
	
	// Учитываем данные по бухитогам
	Для Каждого СтрокаНДСБухИтогов Из ДанныеПоБухИтогам Цикл
		
		СтруктураПоиска = Новый Структура("Дата, Контрагент, ДоговорКонтрагента, ДокументПоступления", СтрокаНДСБухИтогов.Дата, СтрокаНДСБухИтогов.Контрагент, СтрокаНДСБухИтогов.ДоговорКонтрагента, СтрокаНДСБухИтогов.ДокументПоступления);
			
		СтрокаОснТаблицы = РезультирующаяТаблица.НайтиСтроки(СтруктураПоиска);
		
		Если СтрокаОснТаблицы.Количество() > 0 Тогда
			// в подсистеме НДС данное поступление зарегистрировано
			СтрокаОснТаблицы[0]["СуммаНДСПоБухСчету"] = СтрокаНДСБухИтогов.СуммаОборотДт;
			СтрокаОснТаблицы[0]["Разница"] = СтрокаОснТаблицы[0]["СуммаНДСПоРегистру"] - СтрокаОснТаблицы[0]["СуммаНДСПоБухСчету"];
			
		Иначе
			// в подсистеме НДС данное поступление не зарегистрировано
			СтрокаОснТаблицы = РезультирующаяТаблица.Добавить();
			СтрокаОснТаблицы.Дата 				= СтрокаНДСБухИтогов.Дата;
			СтрокаОснТаблицы.Контрагент 		= СтрокаНДСБухИтогов.Контрагент;
			СтрокаОснТаблицы.ДоговорКонтрагента = СтрокаНДСБухИтогов.ДоговорКонтрагента;
			СтрокаОснТаблицы.ДокументПоступления= СтрокаНДСБухИтогов.ДокументПоступления;
			СтрокаОснТаблицы.СуммаНДСПоБухСчету = СтрокаНДСБухИтогов.СуммаОборотДт;
			СтрокаОснТаблицы.Разница = 			- СтрокаОснТаблицы.СуммаНДСПоБухСчету;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат РезультирующаяТаблица;
	
КонецФункции // ВыполнитьСравнительныйЗапросПоРегиструИБухИтогамДляНачисленийАвансов()

// Выполняет сравнительный запрос к БД для сопоставления информации между регистром учета НДС
// и бухитогами для операций вычета при зачете авансов
Процедура ВыполнитьСравнительныйЗапросПоРегиструИБухИтогамДляЗачетаАвансов(РезультирующаяТаблица)

	РезультирующаяТаблица.Очистить();
	РезультирующаяТаблица.Колонки.Очистить();
	
	// Задаем структуру выходной таблицы
	РезультирующаяТаблица.Колонки.Добавить("Дата");
	РезультирующаяТаблица.Колонки.Добавить("Контрагент");
	РезультирующаяТаблица.Колонки.Добавить("ДоговорКонтрагента");
	
	РезультирующаяТаблица.Колонки.Добавить("СтавкаНДС");
	РезультирующаяТаблица.Колонки.Добавить("Регистратор");
	РезультирующаяТаблица.Колонки.Добавить("ДокументПоступления");
	
	РезультирующаяТаблица.Колонки.Добавить("СуммаАванса", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));
	РезультирующаяТаблица.Колонки.Добавить("СуммаБезНДС", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));
	РезультирующаяТаблица.Колонки.Добавить("НДС", 		  Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));
	
	// ЗАПРОС ДЛЯ АНАЛИЗА РЕГИСТРОВ УЧЕТА НДС
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",       Организация);
	Запрос.УстановитьПараметр("НачалоПериода",     НачГраница);
	Запрос.УстановитьПараметр("КонецПериода",      КонГраница);
	
	ТекстФильтраПоКонтрагенту = "";
	Если ЗначениеЗаполнено(Контрагент) Тогда
		// Установлен фильтр по контрагенту
		Запрос.УстановитьПараметр("Контрагент", Контрагент);
		ТекстФильтраПоКонтрагенту = " И НДСсАвансовОбороты.Покупатель = &Контрагент";
	КонецЕсли;
	
	ТекстФильтраПоДоговору = "";
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		// Установлен фильтр по договору
		Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
		ТекстФильтраПоКонтрагенту = " И НДСсАвансовОбороты.СчетФактура.ДоговорКонтрагента = &ДоговорКонтрагента";
	КонецЕсли;
	
	Если ВидАвансов = 0 Тогда
		Запрос.УстановитьПараметр( "НДС0", Перечисления.СтавкиНДС.НДС0);
		ТекстФильтрПоСтавке = " И СтавкаНДс <> &НДС0 ";
	ИначеЕсли ВидАвансов = 1 Тогда
		Запрос.УстановитьПараметр( "НДС0", Перечисления.СтавкиНДС.НДС0);
		ТекстФильтрПоСтавке = " И СтавкаНДс = &НДС0 ";
	Иначе
		ТекстФильтрПоСтавке = "";
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НДСсАвансовОбороты.Регистратор,
	|	НДСсАвансовОбороты.Регистратор.Дата КАК Дата,
	|	НДСсАвансовОбороты.Покупатель КАК Контрагент,
	|	НДСсАвансовОбороты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	НДСсАвансовОбороты.СчетФактура КАК СчетФактура,
	|	НДСсАвансовОбороты.СтавкаНДС,
	|	СУММА(НДСсАвансовОбороты.СуммаБезНДСРасход) + СУММА(НДСсАвансовОбороты.НДСРасход) КАК СуммаЗачетаАванса,
	|	СУММА(НДСсАвансовОбороты.СуммаБезНДСРасход) КАК СуммаБезНДС,
	|	СУММА(НДСсАвансовОбороты.НДСРасход) КАК НДС
	|ИЗ
	|	РегистрНакопления.НДСсАвансов.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Организация = &Организация " + ТекстФильтрПоСтавке + " И ВидЦенности = ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.АвансыПолученные)) КАК НДСсАвансовОбороты
	|ГДЕ
	|	НДСсАвансовОбороты.Организация = &Организация
	|   " + ТекстФильтраПоКонтрагенту + "
	|   " + ТекстФильтраПоДоговору + "
	|
	|СГРУППИРОВАТЬ ПО
	|	НДСсАвансовОбороты.Регистратор,
	|	НДСсАвансовОбороты.Покупатель,
	|	НДСсАвансовОбороты.ДоговорКонтрагента,
	|	НДСсАвансовОбороты.СчетФактура,
	|	НДСсАвансовОбороты.СтавкаНДС
	|ИТОГИ СУММА(СуммаЗачетаАванса), СУММА(СуммаБезНДС), СУММА(НДС) ПО
	|	Контрагент,
	|	ДоговорКонтрагента
	|";
				   
	ДанныеПодсистемыНДС = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Для Каждого СтрКонтрагента Из ДанныеПодсистемыНДС.Строки Цикл
		Для Каждого СтрДоговора Из СтрКонтрагента.Строки Цикл
			
			Для Каждого СтрДокумента Из СтрДоговора.Строки Цикл
				
				НоваяСтрока = РезультирующаяТаблица.Добавить();
				НоваяСтрока.Контрагент 	= СтрДоговора.Контрагент;
				НоваяСтрока.ДоговорКонтрагента = СтрДоговора.ДоговорКонтрагента;
				
				НоваяСтрока.Регистратор = СтрДокумента.Регистратор;
				НоваяСтрока.ДокументПоступления = СтрДокумента.СчетФактура;
				НоваяСтрока.Дата 		= СтрДокумента.Дата;
				НоваяСтрока.СтавкаНДС 	= СтрДокумента.СтавкаНДС;
				
				НоваяСтрока.СуммаАванса = СтрДокумента.СуммаЗачетаАванса;
				НоваяСтрока.СуммаБезНДС = СтрДокумента.СуммаБезНДС;
				НоваяСтрока.НДС 		= СтрДокумента.НДС;
				
			КонецЦикла;
			
		КонецЦикла;
	КонецЦикла;
	
	РезультирующаяТаблица.Колонки.Добавить("СуммаНДСПоРегистру", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));
	РезультирующаяТаблица.Колонки.Добавить("СуммаНДСПоБухСчету", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));
	РезультирующаяТаблица.Колонки.Добавить("Разница", 			 Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));
	РезультирующаяТаблица.ЗагрузитьКолонку(РезультирующаяТаблица.ВыгрузитьКолонку("НДС"), "СуммаНДСПоРегистру");
	РезультирующаяТаблица.ЗагрузитьКолонку(РезультирующаяТаблица.ВыгрузитьКолонку("НДС"), "Разница");
	
	// ЗАПРОС ДЛЯ АНАЛИЗА БУХИТОГОВ
	
	Запрос.УстановитьПараметр("Организация",	Организация);
	Запрос.УстановитьПараметр("НачалоПериода",  НачГраница);
	Запрос.УстановитьПараметр("КонецПериода",   КонГраница);
	
	Запрос.УстановитьПараметр("СчетАнализа", 	ПланыСчетов.Хозрасчетный.НДСпоАвансамИПредоплатам);
	Запрос.УстановитьПараметр("КорСчетАнализа", ПланыСчетов.Хозрасчетный.НДС);
	
	ТекстФильтраПоКонтрагенту = "";
	Если ЗначениеЗаполнено(Контрагент) Тогда
		// Установлен фильтр по контрагенту
		Запрос.УстановитьПараметр("Контрагент", Контрагент);
		ТекстФильтраПоКонтрагенту = "ХозрасчетныйОбороты.Субконто1 = &Контрагент И";
	КонецЕсли;
	
	ТекстФильтраПоДоговору = "";
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		// Установлен фильтр по договору
		Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
		ТекстФильтраПоКонтрагенту = "ХозрасчетныйОбороты.Субконто2.ДоговорКонтрагента = &ДоговорКонтрагента И";
	КонецЕсли;
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХозрасчетныйОбороты.Субконто2 КАК Регистратор,
	|	ХозрасчетныйОбороты.Субконто2 КАК ДокументПоступления,
	|	ХозрасчетныйОбороты.Регистратор.Дата КАК Дата,
	|	ХозрасчетныйОбороты.Счет КАК СчетУчетаНДС,
	|	ХозрасчетныйОбороты.Субконто1 КАК Контрагент,
	|	СУММА(ХозрасчетныйОбороты.СуммаОборотКт) КАК СуммаОборотКт,
	|	ХозрасчетныйОбороты.Субконто2.ДоговорКонтрагента КАК ДоговорКонтрагента
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Счет В ИЕРАРХИИ (&СчетАнализа), , Организация = &Организация, КорСчет В ИЕРАРХИИ (&КорСчетАнализа), ) КАК ХозрасчетныйОбороты
	|ГДЕ
	|   " + ТекстФильтраПоКонтрагенту + "
	|   " + ТекстФильтраПоДоговору + "
	|	ХозрасчетныйОбороты.СуммаОборотКт <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ХозрасчетныйОбороты.Субконто2,
	|	ХозрасчетныйОбороты.Регистратор.Дата,
	|	ХозрасчетныйОбороты.Счет,
	|	ХозрасчетныйОбороты.Субконто1,
	|	ХозрасчетныйОбороты.Субконто2.ДоговорКонтрагента
	|";
				   
	ДанныеПоБухИтогам = Запрос.Выполнить().Выгрузить();
	
	// Учитываем данные по бухитогам
	Для Каждого СтрокаНДСБухИтогов Из ДанныеПоБухИтогам Цикл
		
		СтруктураПоиска = Новый Структура("Дата, Контрагент, ДокументПоступления", СтрокаНДСБухИтогов.Дата, СтрокаНДСБухИтогов.Контрагент, СтрокаНДСБухИтогов.ДокументПоступления);
			
		СтрокаОснТаблицы = РезультирующаяТаблица.НайтиСтроки(СтруктураПоиска);
		
		Если СтрокаОснТаблицы.Количество() > 0 Тогда
			
			СтрокаОснТаблицы[0].СуммаНДСПоБухСчету 	= СтрокаОснТаблицы[0].СуммаНДСПоБухСчету + СтрокаНДСБухИтогов.СуммаОборотКт;
			СтрокаОснТаблицы[0].Разница 			= СтрокаОснТаблицы[0].Разница - СтрокаНДСБухИтогов.СуммаОборотКт;
			
		Иначе
			
			// В подсистеме НДС данное поступление незарегистрировано.
			НоваяСтрока = РезультирующаяТаблица.Добавить();
			НоваяСтрока.Контрагент 	= СтрокаНДСБухИтогов.Контрагент;
			НоваяСтрока.ДоговорКонтрагента = Неопределено;
				
			НоваяСтрока.Регистратор = СтрокаНДСБухИтогов.Регистратор;
			НоваяСтрока.ДокументПоступления = СтрокаНДСБухИтогов.ДокументПоступления;
			НоваяСтрока.Дата 		= СтрокаНДСБухИтогов.Дата;
				
			НоваяСтрока.СуммаНДСПоБухСчету 	= СтрокаНДСБухИтогов.СуммаОборотКт;
			НоваяСтрока.Разница 		= - СтрокаНДСБухИтогов.СуммаОборотКт;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 
НП = Новый НастройкаПериода;
#КонецЕсли
