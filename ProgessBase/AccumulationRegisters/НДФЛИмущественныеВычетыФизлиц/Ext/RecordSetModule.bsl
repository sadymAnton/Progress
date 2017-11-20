﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ГодНачалаУчетаПоОКТМО = Год(ПроведениеРасчетов.ДатаПереходаНаКодыОКТМО()) - 1;
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Запись.Год < ГодНачалаУчетаПоОКТМО Тогда
			Запись.КодПоОКТМО = "";
		КонецЕсли;
		Если Запись.Год > 2014 И Запись.КодВычетаИмущественный = Справочники.ВычетыНДФЛ.Код318 Тогда
			Запись.КодВычетаИмущественный = Справочники.ВычетыНДФЛ.Код312
		КонецЕсли;
	КонецЦикла

КонецПроцедуры

