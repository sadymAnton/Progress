﻿Перем мТекущийПользователь Экспорт;

Функция ПолучитьСписокДублей(ТаблицаИсточников)
	Результат = Новый Массив;
	Для каждого ТекСтр Из ТаблицаИсточников Цикл
		
		Если ТекСтр.Ссылка = Ссылка 
			ИЛИ ТекСтр.Источники.Количество <> Источники.Количество() Тогда
			Продолжить;
		КонецЕсли;		
		
		ТаблицаСвоя = Источники.Выгрузить();
		
	КонецЦикла;
КонецФункции // ()

мТекущийПользователь=ПараметрыСеанса.ТекущийПользователь;

