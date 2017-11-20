﻿#Если Клиент Тогда
	
Функция ЧислоПериодовВДиапазоне(Период, ДатаНач, ДатаКон)

	ДатаНачТ = НачалоДня(ДатаНач);
	ДатаКонТ = НачалоДня(ДатаКон);

	Если Период = Перечисления.Периодичность.День Тогда
		
		Возврат (ДатаКонТ - ДатаНачТ) / 86400 + 1;

	ИначеЕсли Период = Перечисления.Периодичность.Неделя Тогда
		
		Возврат ((ДатаКонТ - ДатаНачТ) / 86400 + 1) / 7;
		
	ИначеЕсли Период = Перечисления.Периодичность.Месяц Тогда
		
		Если НачалоМесяца(ДатаКонТ) > КонецМесяца(ДатаНачТ) Тогда // пересекает границу
			
			ЦелаяЧасть = (Месяц(ДатаКонТ) - Месяц(ДатаНачТ) - 1) + 12 * (Год(ДатаКонТ) - Год(ДатаНачТ));
			Сверх = (ДатаКонТ - НачалоМесяца(ДатаКонТ) + 86400) / (НачалоДня(КонецМесяца(ДатаКонТ)) - НачалоМесяца(ДатаКонТ) + 86400) +
					(НачалоДня(КонецМесяца(ДатаНачТ)) - ДатаНачТ + 86400) / (НачалоДня(КонецМесяца(ДатаНачТ)) - НачалоМесяца(ДатаНачТ) + 86400);
					
			Возврат (ЦелаяЧасть + Сверх);
			
		Иначе
			
			Возврат (ДатаКонТ - ДатаНачТ + 86400) / (НачалоДня(КонецМесяца(ДатаНачТ)) - НачалоМесяца(ДатаНачТ) + 86400);
			
		КонецЕсли; 
		
	ИначеЕсли Период = Перечисления.Периодичность.Квартал Тогда
		
		Если НачалоКвартала(ДатаКонТ) > КонецКвартала(ДатаНачТ) Тогда // пересекает границу
			
			ЦелаяЧасть = Цел((Месяц(ДатаКонТ) + 2) / 3) - Цел((Месяц(ДатаНачТ) + 2) / 3) - 1 + 4 * (Год(ДатаКонТ) - Год(ДатаНачТ));
			Сверх = (ДатаКонТ - НачалоКвартала(ДатаКонТ) + 86400) / (НачалоДня(КонецКвартала(ДатаКонТ)) - НачалоКвартала(ДатаКонТ) + 86400) + 
					(НачалоДня(КонецКвартала(ДатаНачТ)) - ДатаНачТ + 86400) / (НачалоДня(КонецКвартала(ДатаНачТ)) - НачалоКвартала(ДатаНачТ) + 86400);
					
			Возврат (ЦелаяЧасть+Сверх);
			
		Иначе
			
			Возврат (ДатаКонТ - ДатаНачТ + 86400) / (НачалоДня(КонецКвартала(ДатаНачТ)) - НачалоКвартала(ДатаНачТ) + 86400);
			
		КонецЕсли; 
		
	ИначеЕсли Период = Перечисления.Периодичность.Год Тогда
		
		Если НачалоГода(ДатаКонТ) > КонецГода(ДатаНачТ) Тогда // пересекает границу
			
			ЦелаяЧасть = Год(ДатаКонТ) - Год(ДатаНачТ) - 1;
			Сверх = (ДатаКонТ - НачалоГода(ДатаКонТ) + 86400) / (НачалоДня(КонецГода(ДатаКонТ)) - НачалоГода(ДатаКонТ) + 86400) + 
					(НачалоДня(КонецГода(ДатаНачТ)) - ДатаНачТ + 86400) / (НачалоДня(КонецГода(ДатаНачТ)) - НачалоГода(ДатаНачТ) + 86400);
					
			Возврат (ЦелаяЧасть + Сверх);
			
		Иначе
			
			Возврат (ДатаКонТ - ДатаНачТ + 86400) / (НачалоДня(КонецГода(ДатаНачТ)) - НачалоГода(ДатаНачТ) + 86400);
			
		КонецЕсли; 

	Иначе
		
		Возврат 0;
		
	КонецЕсли; 

КонецФункции // ЧислоПериодовВДиапазоне()

Функция ПроверитьЗаполнениеНастроек(Период, ВидПланирования, СценарийПлана, СценарийРесурсов)
	
	Результат = Истина;
	
	Если НЕ ЗначениеЗаполнено(Период) Тогда
		
		Предупреждение("Не указана настройка параметров учета ""Периодичность доступности ключевых ресурсов предприятия""!");
		Результат = Ложь;
		
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ВидПланирования) Тогда
		
		Предупреждение("Не указан вид планирования!");
		Результат = Ложь;
		
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(СценарийПлана) Тогда
		
		Предупреждение("Не указан сценарий планирования!");
		Результат = Ложь;
		
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(СценарийРесурсов) Тогда
		
		Предупреждение("Не указан сценарий доступности ресурсов!");
		Результат = Ложь;
		
	КонецЕсли;

	Возврат Результат;

КонецФункции // ПроверитьЗаполнениеНастроек()

Функция ПроверкаДостаточностиКлючевыхРесурсов(Результат = "", ВидПланирования, СценарийПлана, СценарийРесурсов) Экспорт
	
	Период = Константы.ПериодичностьДоступностиКлючевыхРесурсовПредприятия.Получить();

	Если НЕ ПроверитьЗаполнениеНастроек(Период, ВидПланирования, СценарийПлана, СценарийРесурсов) Тогда
		
		Возврат Ложь;
		
	КонецЕсли; 
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Доступность.КлючевойРесурс КАК КлючевойРесурс,
	|	ПРЕДСТАВЛЕНИЕ(Доступность.КлючевойРесурс) КАК КлючевойРесурсПредставление,
	|	Доступность.ОбъемДоступности * &КоэффПериодов КАК ОбъемДоступностиРесурса,
	|	ЕСТЬNULL(Потребность.ОбъемПотребностиРесурса, 0) КАК ОбъемПотребностиРесурса,
	|	ЕСТЬNULL(Потребность.ОбъемПотребностиРесурса, 0) - Доступность.ОбъемДоступности * &КоэффПериодов КАК ДефицитРесурса
	|ИЗ
	|	РегистрСведений.ДоступностьКлючевыхРесурсовПредприятия.СрезПоследних(&ДатаНач, Сценарий В ИЕРАРХИИ (&СценарийРесурсов)) КАК Доступность
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			Потребность.КлючевойРесурс КАК КлючевойРесурс,
	|			СУММА(ВЫБОР
	|					КОГДА Потребность.КлючевойРесурс.БазаЗаданияПотребности = ЗНАЧЕНИЕ(Перечисление.БазыЗаданияПотребностейПоКлючевымРесурсам.СуммовыеПоказатели)
	|						ТОГДА Потребность.ОбъемПотребности * #ИмяРегистра#.СтоимостьОборот * #ИмяРегистра#.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / (Потребность.КоличествоСуммаНоменклатуры * Потребность.Коэффициент)
	|					ИНАЧЕ Потребность.ОбъемПотребности * #ИмяРегистра#.КоличествоОборот * #ИмяРегистра#.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / (Потребность.КоличествоСуммаНоменклатуры * Потребность.Коэффициент)
	|				КОНЕЦ) КАК ОбъемПотребностиРесурса
	|		ИЗ
	|			РегистрСведений.ПотребностьВКлючевыхРесурсахПредприятия КАК Потребность
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.#ИмяРегистра#.Обороты(&ДатаНач, &ДатаКон, , Сценарий В ИЕРАРХИИ (&СценарийПлана)) КАК #ИмяРегистра#
	|				ПО Потребность.Номенклатура = #ИмяРегистра#.Номенклатура
	|					И Потребность.ХарактеристикаНоменклатуры = #ИмяРегистра#.ХарактеристикаНоменклатуры
	|		ГДЕ
	|			Потребность.ВидПланирования = &ВидПланирования
	|		
	|		СГРУППИРОВАТЬ ПО
	|			Потребность.КлючевойРесурс) КАК Потребность
	|		ПО Доступность.КлючевойРесурс = Потребность.КлючевойРесурс
	|ГДЕ
	|	Доступность.Учитывается = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	КлючевойРесурс");

	Запрос.УстановитьПараметр("ДатаНач", ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон", ДатаКон);
	Запрос.УстановитьПараметр("ВидПланирования", ВидПланирования);
	Запрос.УстановитьПараметр("СценарийПлана", СценарийПлана);
	Запрос.УстановитьПараметр("СценарийРесурсов", СценарийРесурсов);
	Запрос.УстановитьПараметр("КоэффПериодов", ЧислоПериодовВДиапазоне(Период, ДатаНач, ДатаКон));

	// установка имени регистра
	Если ВидПланирования = Перечисления.ВидыПланирования.Продажи Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ИмяРегистра#", "ПланыПродаж");
		
	ИначеЕсли ВидПланирования = Перечисления.ВидыПланирования.Производство Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ИмяРегистра#", "ПланыПроизводства");
		
	ИначеЕсли ВидПланирования = Перечисления.ВидыПланирования.Закупки Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ИмяРегистра#", "ПланыЗакупок");
		
	Иначе
		
		ОбщегоНазначения.Сообщение("Вид планирования не соответствует известным регистрам!");
		Возврат Ложь;
		
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	
	// проведем оценку плана
	ПланВыполним = Истина;
	
	ТЗ = Результат.Выгрузить();
	
	Для каждого СтрокаТЗ Из ТЗ Цикл
		
		Если СтрокаТЗ.ДефицитРесурса > 0 Тогда
			
			ПланВыполним = Ложь; // недостаточно ключевых ресурсов
			Прервать;
			
		КонецЕсли; 
		
	КонецЦикла;
	
	ВывестиОтчет(Результат, ВидПланирования, СценарийПлана, СценарийРесурсов);

	Возврат ПланВыполним;

КонецФункции // ПроверкаДостаточностиКлючевыхРесурсов

Процедура ВывестиОтчет(Результат, ВидПланирования, СценарийПлана, СценарийРесурсов)
	
	ТабДок = Новый ТабличныйДокумент;
	
	КрасныйЦвет = Новый Цвет (255,0,0);
	
	Макет = ПолучитьМакет("ПроверкаДостаточностиКлючевыхРесурсов");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьДетали = Макет.ПолучитьОбласть("Детали");

	ОбластьЗаголовок.Параметры.Период 			= "За период с " + Формат(ДатаНач, "ДФ=dd.MM.yyyy; ДЛФ=D") +" по "+Формат(ДатаКон, "ДФ=dd.MM.yyyy; ДЛФ=D");
	ОбластьЗаголовок.Параметры.СценарийПлана	= "Сценарий плана: " + СценарийПлана;
	ОбластьЗаголовок.Параметры.СценарийРесурсов	= "Сценарий ресурсов: " + СценарийРесурсов;

	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);

	ВыборкаДетали = Результат.Выбрать();

	Пока ВыборкаДетали.Следующий() Цикл
		
		ОбластьДетали.Параметры.Заполнить(ВыборкаДетали);
		ОбластьДетали.Параметры.ДефицитРесурса = ?(ВыборкаДетали.ДефицитРесурса > 0, ВыборкаДетали.ДефицитРесурса, "Нет");
		ТабДок.Вывести(ОбластьДетали);
		
		Если ВыборкаДетали.ДефицитРесурса > 0 Тогда
			
			ТабДок.Область("Детали").ЦветТекста = КрасныйЦвет;
			
		КонецЕсли; 
		
	КонецЦикла;
	
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;

	ТабДок.Показать("Проверка достаточности ключевых ресурсов");

КонецПроцедуры // ВывестиОтчет()

#КонецЕсли
