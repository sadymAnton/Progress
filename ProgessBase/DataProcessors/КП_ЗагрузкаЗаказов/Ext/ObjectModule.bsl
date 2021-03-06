﻿
Перем СоотвествиеОшибок Экспорт;

Перем мРегистрНоменклатураКонтрагентов Экспорт;

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//ПроверяемыеРеквизиты.Вставить("ПерваяСтрока");
	//ПроверяемыеРеквизиты.Вставить("Колонка_Количество");
	//ПроверяемыеРеквизиты.Вставить("Колонка_Поиска");
	//ПроверяемыеРеквизиты.Вставить("НомерЛиста");
	//
КонецПроцедуры

//++ Spl_Апроф 09.02.2015 (k.russkih@a-prof.ru)
Функция ПолучимКоэффициентЕдиницыПоКонтрагентуИНоменклатуре(ТекСтрока, мНоменклатура) Экспорт 

	НайтиСтроки = мРегистрНоменклатураКонтрагентов.НайтиСтроки(Новый Структура("Номенклатура", мНоменклатура));
	
	Если НЕ НайтиСтроки.Количество() = 0 Тогда
	
		 Возврат НайтиСтроки[0].КоличествоПоЕдиницеИзмеренияКонтрагента;
	
	КонецЕсли;
	
	ТекСтрока.Примечание = ?(ПустаяСтрока(СокрЛП(ТекСтрока.Примечание)), "", СокрЛП(ТекСтрока.Примечание) + "; ") + СоотвествиеОшибок.Получить("НеОбнаруженаЕдиницаПоКонтрагенту");
	
	Возврат 0; 

КонецФункции // ()

СоотвествиеОшибок = Новый Соответствие;
СоотвествиеОшибок.Вставить("БезОшибок"							, "Без ошибок");
СоотвествиеОшибок.Вставить("ПроблемыВЗаказе"					, "Проблемы в заказе");
СоотвествиеОшибок.Вставить("УжеЗагружен"						, "Уже загружен");
СоотвествиеОшибок.Вставить("НесколькоСоотвествийНоменклатуры"	, "Обнаружено несколько соответствий номенклатуры");
СоотвествиеОшибок.Вставить("НоменклатураНеНайдена"				, "Номенклатура не найдена");
СоотвествиеОшибок.Вставить("АдресПоставкиНеНайден"				, "Не найден адрес поставки");
СоотвествиеОшибок.Вставить("НеОбнаруженаЕдиницаПоКонтрагенту"	, "Не обнаружена единица по контрагенту");

мРегистрНоменклатураКонтрагентов = Новый ТаблицаЗначений;
мРегистрНоменклатураКонтрагентов.Колонки.Добавить("Номенклатура");
