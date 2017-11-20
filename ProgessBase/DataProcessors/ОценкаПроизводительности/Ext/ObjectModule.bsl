﻿
//Функция формирует таблицу значений которая будет выведена пользователю
//
// Возвращаемое значение:
//  ТаблицаЗначений - итоговая таблица значений
//
Функция ПолучитьПоказателиПроизводительности() Экспорт
	
	ПараметрыЗапроса = Новый Структура("ШагЧисло, КоличествоШагов");
	
	РазницаВремени = Период.ДатаОкончания - Период.ДатаНачала + 1;
	
	Если РазницаВремени <= 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	//КоличествоШагов - целое число, округленное вверх
	КоличествоШагов = 0;
	Если Шаг = "Час" Тогда
		ШагЧисло = 86400 / 24;
		КоличествоШагов = РазницаВремени / ШагЧисло;
		КоличествоШагов = Цел(КоличествоШагов) + ?(КоличествоШагов - Цел(КоличествоШагов) > 0, 1, 0);
	ИначеЕсли Шаг = "День" Тогда
		ШагЧисло = 86400;
		КоличествоШагов = РазницаВремени / ШагЧисло;
		КоличествоШагов = Цел(КоличествоШагов) + ?(КоличествоШагов - Цел(КоличествоШагов) > 0, 1, 0);
	ИначеЕсли Шаг = "Неделя" Тогда
		ШагЧисло = 86400 * 7;
		КоличествоШагов = РазницаВремени / ШагЧисло;
		КоличествоШагов = Цел(КоличествоШагов) + ?(КоличествоШагов - Цел(КоличествоШагов) > 0, 1, 0);
	ИначеЕсли Шаг = "Месяц" Тогда
		ШагЧисло = 86400 * 30;
		ДатаНачала = КонецДня(Период.ДатаНачала);
		Пока ДатаНачала < Период.ДатаОкончания Цикл
			ДатаНачала = ДобавитьМесяц(ДатаНачала, 1);
			КоличествоШагов = КоличествоШагов + 1;
		КонецЦикла;
	Иначе
		ШагЧисло = 0;
		КоличествоШагов = 1;
	КонецЕсли;
	
	ПараметрыЗапроса.ШагЧисло = ШагЧисло;
	ПараметрыЗапроса.КоличествоШагов = КоличествоШагов;
	
	Возврат ПолучитьAPDEX(ПараметрыЗапроса);
	
КонецФункции

// Функция динамически формирует запрос и получает APDEX
//
// Параметры:
//  ПараметрыЗапроса - Структура, с полянми "НачПериода", "КонПериода" и
//  "ТЗ", в ней находится список ключевых операций и целевые времена выполнения
//
// Возвращаемое значение:
//  ТаблицаЗначений - в таблице возвращается ключевая операция и 
//  показатель производительности за определенный период времени
//
Функция ПолучитьAPDEX(ПараметрыЗапроса)
	
	КОИтого = ОценкаПроизводительностиВызовСервера.ПолучитьПредопределенный();
	Если Не ЗначениеЗаполнено(КОИтого) Или Производительность.Найти(КОИтого, "КлючеваяОперация") = Неопределено Тогда
		ВыводитьИтоги = Ложь
	Иначе
		ВыводитьИтоги = Истина;
	КонецЕсли;
	
	ТЗ = Производительность.Выгрузить(, "КлючеваяОперация, НомерСтроки, ЦелевоеВремя");
	
	МВТ = Новый МенеджерВременныхТаблиц;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЗ", ТЗ);
	Запрос.УстановитьПараметр("НачПериода", Период.ДатаНачала);
	Запрос.УстановитьПараметр("КонПериода", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("КОИтого", КОИтого);
	
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлючевыеОперации.КлючеваяОперация КАК КлючеваяОперация,
	|	КлючевыеОперации.НомерСтроки КАК НомерСтроки,
	|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя
	|ПОМЕСТИТЬ КлючевыеОперации
	|ИЗ
	|	&ТЗ КАК КлючевыеОперации";
	Запрос.Выполнить();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КлючевыеОперации.КлючеваяОперация КАК КлючеваяОперация,
	|	КлючевыеОперации.НомерСтроки КАК Приоритет,
	|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя%Колонки%
	|ИЗ
	|	КлючевыеОперации КАК КлючевыеОперации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамерыВремени КАК ЗамерыВремени
	|		ПО КлючевыеОперации.КлючеваяОперация = ЗамерыВремени.КлючеваяОперация
	|		И ЗамерыВремени.ДатаЗамера МЕЖДУ &НачПериода И &КонПериода
	|ГДЕ
	|	НЕ КлючевыеОперации.КлючеваяОперация = &КОИтого
	|
	|СГРУППИРОВАТЬ ПО
	|	КлючевыеОперации.КлючеваяОперация,
	|	КлючевыеОперации.НомерСтроки,
	|	КлючевыеОперации.ЦелевоеВремя
	|%Итоги%";
	

	Выражение = 
	"
	|	,ВЫБОР
	|		КОГДА СУММА(ВЫБОР
	|					КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|							И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|						ТОГДА 1
	|					ИНАЧЕ 0
	|				КОНЕЦ) = 0
	|			ТОГДА 0
	|		ИНАЧЕ (ВЫРАЗИТЬ((СУММА(ВЫБОР
	|								КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|										И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|									ТОГДА ВЫБОР
	|											КОГДА ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя
	|												ТОГДА 1
	|											ИНАЧЕ 0
	|										КОНЕЦ
	|								ИНАЧЕ 0
	|							КОНЕЦ) + СУММА(ВЫБОР
	|								КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|										И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|									ТОГДА ВЫБОР
	|											КОГДА ЗамерыВремени.ВремяВыполнения > КлючевыеОперации.ЦелевоеВремя
	|													И ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя * 4
	|												ТОГДА 1
	|											ИНАЧЕ 0
	|										КОНЕЦ
	|								ИНАЧЕ 0
	|							КОНЕЦ) / 2) / СУММА(ВЫБОР
	|								КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|										И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|									ТОГДА 1
	|								ИНАЧЕ 0
	|							КОНЕЦ) + 0.001 КАК ЧИСЛО(6, 3)))
	|	КОНЕЦ КАК Производительность%Номер%";
	
	ВыражениеДляИтогов = 
	"
	|	,СУММА(ВЫБОР
	|			КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|					И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВремВсего%Номер%,
	|	СУММА(ВЫБОР
	|			КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|					И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|				ТОГДА ВЫБОР
	|						КОГДА ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВремДоТ%Номер%,
	|	СУММА(ВЫБОР
	|			КОГДА ЗамерыВремени.ДатаЗамера >= &НачПериода%Номер%
	|					И ЗамерыВремени.ДатаЗамера <= &КонПериода%Номер%
	|				ТОГДА ВЫБОР
	|						КОГДА ЗамерыВремени.ВремяВыполнения > КлючевыеОперации.ЦелевоеВремя
	|								И ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя * 4
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВремМеждуТ4Т%Номер%";
	
	Итог = 
	"
	|	МАКСИМУМ(ВремВсего%Номер%)";
	
	ПоОбщие = 
	"
	|ПО
	|	ОБЩИЕ";
	
	ЗаголовкиКолонок = Новый Массив;
	Колонки = "";
	Итоги = "";
	НачПериода = Период.ДатаНачала;
	Для а = 0 По ПараметрыЗапроса.КоличествоШагов - 1 Цикл
		
		КонПериода = ?(а = ПараметрыЗапроса.КоличествоШагов - 1, Период.ДатаОкончания, НачПериода + ПараметрыЗапроса.ШагЧисло - 1);
		
		Запрос.УстановитьПараметр("НачПериода" + а, НачПериода);
		Запрос.УстановитьПараметр("КонПериода" + а, КонПериода);
		
		ЗаголовкиКолонок.Добавить(ПолучитьЗаголовокКолонки(НачПериода));
		
		НачПериода = НачПериода + ПараметрыЗапроса.ШагЧисло;
		
		Колонки = Колонки + ?(ВыводитьИтоги, ВыражениеДляИтогов, "") + Выражение;
		Колонки = СтрЗаменить(Колонки, "%Номер%", а);
		
		Если ВыводитьИтоги Тогда
			Итоги = Итоги + Итог + ?(а = ПараметрыЗапроса.КоличествоШагов - 1, "", ",");
			Итоги = СтрЗаменить(Итоги, "%Номер%", а);
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Колонки%", Колонки);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Итоги%", ?(ВыводитьИтоги, "ИТОГИ" + Итоги, ""));
	ТекстЗапроса = ТекстЗапроса + ?(ВыводитьИтоги, ПоОбщие, "");
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Новый ТаблицаЗначений;
	Иначе
		ТЗ = Результат.Выгрузить();
		
		ТЗ.Сортировать("Приоритет");
		Если ВыводитьИтоги Тогда
			ТЗ[0][0] = КОИтого;
			ВычислитьИтоговыйAPDEX(ТЗ);
			ТЗ.Сдвинуть(0, ТЗ.Количество() - 1);
		КонецЕсли;
		
		а = 0;
		ИндексМассива = 0;
		Пока а <= ТЗ.Колонки.Количество() - 1 Цикл
			
			КолонкаТЗ = ТЗ.Колонки[а];
			Если Лев(КолонкаТЗ.Имя, 4) = "Врем" Тогда
				ТЗ.Колонки.Удалить(КолонкаТЗ);
				Продолжить;
			КонецЕсли;
			
			Если а < 3 Тогда
				а = а + 1;
				Продолжить;
			КонецЕсли;
			КолонкаТЗ.Заголовок = ЗаголовкиКолонок[ИндексМассива];
			
			ИндексМассива = ИндексМассива + 1;
			а = а + 1;
			
		КонецЦикла;
		
		Возврат ТЗ;
	КонецЕсли;
	
КонецФункции

// Процедура рассчитывает итоговое значение APDEX
//
// Параметры:
//  ТЗ - ТаблицаЗначений, результат запроса рассчитавшего APDEX
//
Процедура ВычислитьИтоговыйAPDEX(ТЗ)
	
	// Начинаем с 4 колонки первые 3 это КлючеваяОперация, Приоритет, ЦелевоеВремя
	ИндексНачальнойКолонки	= 3;
	ИндексСтрокиИтогов		= 0;
	ИндексКолонкиПриоритет	= 1;
	ИндексПоследнейСтроки	= ТЗ.Количество() - 1;
	ИндексПоследнейКолонки	= ТЗ.Колонки.Количество() - 1;
	МинимальныйПриоритет	= ИндексПоследнейСтроки;
	
	Колонка = ИндексНачальнойКолонки;
	Пока Колонка < ИндексПоследнейКолонки Цикл
		
		МаксимальноеКоличествоОперацийЗаПериод = ТЗ[ИндексСтрокиИтогов][Колонка];
		//Обнуление строки итогов, чтобы она не повлияла на функцию Итог таблицы значений при расчете итогового APDEX за период
		ТЗ[ИндексСтрокиИтогов][Колонка] = 0;
		// с 1 т.к. 0 это строка итогов
		Для Строка = 1 По ИндексПоследнейСтроки Цикл
			
			ПриоритетТекущейОперации = ТЗ[Строка][ИндексКолонкиПриоритет];
			КоличествоТекущейОперации = ТЗ[Строка][Колонка];
			
			Коэффициент = ?(КоличествоТекущейОперации = 0, 0, 
							МаксимальноеКоличествоОперацийЗаПериод / КоличествоТекущейОперации * (1 - (ПриоритетТекущейОперации - 1) / МинимальныйПриоритет));
			
			ТЗ[Строка][Колонка] = ТЗ[Строка][Колонка] * Коэффициент;
			ТЗ[Строка][Колонка + 1] = ТЗ[Строка][Колонка + 1] * Коэффициент;
			ТЗ[Строка][Колонка + 2] = ТЗ[Строка][Колонка + 2] * Коэффициент;
			
		КонецЦикла;
		
		Н = ТЗ.Итог(ТЗ.Колонки[Колонка].Имя);
		НС = ТЗ.Итог(ТЗ.Колонки[Колонка + 1].Имя);
		НТ = ТЗ.Итог(ТЗ.Колонки[Колонка + 2].Имя);
		ИтоговыйAPDEX = ?(Н = 0, 0, (НС + НТ / 2) / Н);
		ТЗ[ИндексСтрокиИтогов][Колонка + 3] = ИтоговыйAPDEX;
		
		Колонка = Колонка + 4;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьЗаголовокКолонки(НП)
	
	Если Шаг = "Час" Тогда
		// Страна указана для вывода лидирующего нуля чтобы было не 1:30:25, а 01:30:25
		ЗаголовокКолонки = Строка(Формат(НП, "Л=ru_UA; ДЛФ=T"));
	Иначе
		ЗаголовокКолонки = Строка(Формат(НП, "ДФ=dd.MM.yy"));
	КонецЕсли;
	
	Возврат ЗаголовокКолонки;
	
КонецФункции

