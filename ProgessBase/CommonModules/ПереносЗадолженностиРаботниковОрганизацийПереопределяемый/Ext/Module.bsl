﻿////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры, функции

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции объекта

Процедура ДополнитьСоставПолейТаблицыЗапроса(ТекстЗапроса, ИмяТаблицы) Экспорт
	    
	// В текущей конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ДополнитьСоставУсловийСоединенияТаблицЗапроса(ТекстЗапроса, ИмяТаблицы1, ИмяТаблицы2) Экспорт
	    
	// В текущей конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ПроверитьЗаполнениеДополнительныхПолей(ВыборкаПоСтрокамДокумента, СтрокаНачалаСообщенияОбОшибке, Отказ, Заголовок) Экспорт
	
	// В текущей конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ДополнитьСтрокуДвиженияПоВзаиморасчетам(Движение, ВыборкаПоТЧ) Экспорт
	
	// В текущей конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ДополнитьДвиженияПоРегистрамНакопления(Движения, ВыборкаПоШапкеДокумента, ВыборкаПоТЧ, ОбрабатываетсяПрошлыйПериод) Экспорт
	
	// В текущей конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы документа

#Если ТолстыйКлиентОбычноеПриложение Тогда

Процедура ФормаДокументаПередОткрытиемДополнительно(Форма) Экспорт
	
	// В текущей конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры
	
#КонецЕсли