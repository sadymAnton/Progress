﻿Перем мВыполнятьДополнительныеДвижения Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаНабора Из ЭтотОбъект Цикл
		Если Не ЗначениеЗаполнено(СтрокаНабора.ДатаПолученияДохода) Тогда
			СтрокаНабора.ДатаПолученияДохода = НачалоДня(КонецМесяца(СтрокаНабора.Период)) 
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
        Возврат;
    КонецЕсли;

	Если ЭтотОбъект.Количество() = 0 Или Не мВыполнятьДополнительныеДвижения Тогда
        Возврат;
    КонецЕсли;
	
	Регистратор = Отбор.Регистратор.Значение;
	Если Регистратор.Метаданные().Движения.Содержит(Метаданные.РегистрыНакопления.РасчетыПоСтраховымВзносам) Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Регистратор",Регистратор);
		Запрос.УстановитьПараметр("ДатаПередачиАдминистрированияВзносовФНС",РасчетСтраховыхВзносов.ДатаПередачиАдминистрированияВзносовФНС());
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СтраховыеВзносыИсчисленные.Регистратор,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
		|	СтраховыеВзносыИсчисленные.Период,
		|	СтраховыеВзносыИсчисленные.ОбособленноеПодразделение КАК Организация,
		|	ВЫБОР
		|		КОГДА СтраховыеВзносыИсчисленные.ОснованиеДляДоначисления = ЗНАЧЕНИЕ(Перечисление.ОснованияДляДоначисленияСтраховыхВзносов.КамеральнаяПроверка)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПлатежейВГосБюджет.НалогАкт)
		|		КОГДА СтраховыеВзносыИсчисленные.ОснованиеДляДоначисления = ЗНАЧЕНИЕ(Перечисление.ОснованияДляДоначисленияСтраховыхВзносов.ВыезднаяПроверка)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПлатежейВГосБюджет.НалогАкт)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПлатежейВГосБюджет.Налог)
		|	КОНЕЦ КАК ВидПлатежа,
		|	НАЧАЛОПЕРИОДА(СтраховыеВзносыИсчисленные.Период, МЕСЯЦ) КАК МесяцРасчетногоПериода,
		|	ВЫБОР
		|		КОГДА СтраховыеВзносыИсчисленные.Период < &ДатаПередачиАдминистрированияВзносовФНС
		|			ТОГДА СУММА(СтраховыеВзносыИсчисленные.ПФРПоСуммарномуТарифу + СтраховыеВзносыИсчисленные.ПФРПоСуммарномуТарифуЕНВД + СтраховыеВзносыИсчисленные.ПФРДоПредельнойВеличины + СтраховыеВзносыИсчисленные.ПФРДоПредельнойВеличиныЕНВД + СтраховыеВзносыИсчисленные.ПФРСПревышения + СтраховыеВзносыИсчисленные.ПФРСПревышенияЕНВД)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ПФРПоСуммарномуТарифу,
		|	ВЫБОР
		|		КОГДА СтраховыеВзносыИсчисленные.Период < &ДатаПередачиАдминистрированияВзносовФНС
		|			ТОГДА СУММА(СтраховыеВзносыИсчисленные.ПФРСтраховая + СтраховыеВзносыИсчисленные.ПФРСтраховаяЕНВД)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ПФРСтраховая,
		|	ВЫБОР
		|		КОГДА СтраховыеВзносыИсчисленные.Период < &ДатаПередачиАдминистрированияВзносовФНС
		|			ТОГДА СУММА(СтраховыеВзносыИсчисленные.ПФРНакопительная + СтраховыеВзносыИсчисленные.ПФРНакопительнаяЕНВД)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ПФРНакопительная,
		|	СУММА(СтраховыеВзносыИсчисленные.ФСС + СтраховыеВзносыИсчисленные.ФССЕНВД) КАК ФСС,
		|	СУММА(СтраховыеВзносыИсчисленные.ФССНесчастныеСлучаи) КАК ФССНесчастныеСлучаи,
		|	ВЫБОР
		|		КОГДА СтраховыеВзносыИсчисленные.Период < &ДатаПередачиАдминистрированияВзносовФНС
		|			ТОГДА СУММА(СтраховыеВзносыИсчисленные.ФФОМС + СтраховыеВзносыИсчисленные.ФФОМСЕНВД)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ФФОМС,
		|	ВЫБОР
		|		КОГДА СтраховыеВзносыИсчисленные.Период < &ДатаПередачиАдминистрированияВзносовФНС
		|			ТОГДА СУММА(СтраховыеВзносыИсчисленные.ТФОМС + СтраховыеВзносыИсчисленные.ТФОМСЕНВД)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ТФОМС,
		|	ВЫБОР
		|		КОГДА СтраховыеВзносыИсчисленные.Период < &ДатаПередачиАдминистрированияВзносовФНС
		|			ТОГДА СУММА(СтраховыеВзносыИсчисленные.ПФРПоДополнительномуТарифу)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ПФРПоДополнительномуТарифу,
		|	ВЫБОР
		|		КОГДА СтраховыеВзносыИсчисленные.Период < &ДатаПередачиАдминистрированияВзносовФНС
		|			ТОГДА СУММА(СтраховыеВзносыИсчисленные.ПФРНаДоплатуКПенсииШахтерам)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ПФРНаДоплатуКПенсииШахтерам,
		|	ВЫБОР
		|		КОГДА СтраховыеВзносыИсчисленные.Период < &ДатаПередачиАдминистрированияВзносовФНС
		|			ТОГДА СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботах + СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахОпасный + СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный1 + СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный2 + СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный3 + СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный4)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ПФРЗаЗанятыхНаПодземныхИВредныхРаботах,
		|	ВЫБОР
		|		КОГДА СтраховыеВзносыИсчисленные.Период < &ДатаПередачиАдминистрированияВзносовФНС
		|			ТОГДА СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах + СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахОпасный + СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный1 + СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный2 + СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный3 + СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный4)
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах
		|ИЗ
		|	РегистрНакопления.СтраховыеВзносыИсчисленные КАК СтраховыеВзносыИсчисленные
		|ГДЕ
		|	СтраховыеВзносыИсчисленные.Регистратор = &Регистратор
		|
		|СГРУППИРОВАТЬ ПО
		|	СтраховыеВзносыИсчисленные.Период,
		|	СтраховыеВзносыИсчисленные.Регистратор,
		|	СтраховыеВзносыИсчисленные.ОбособленноеПодразделение,
		|	ВЫБОР
		|		КОГДА СтраховыеВзносыИсчисленные.ОснованиеДляДоначисления = ЗНАЧЕНИЕ(Перечисление.ОснованияДляДоначисленияСтраховыхВзносов.КамеральнаяПроверка)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПлатежейВГосБюджет.НалогАкт)
		|		КОГДА СтраховыеВзносыИсчисленные.ОснованиеДляДоначисления = ЗНАЧЕНИЕ(Перечисление.ОснованияДляДоначисленияСтраховыхВзносов.ВыезднаяПроверка)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыПлатежейВГосБюджет.НалогАкт)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыПлатежейВГосБюджет.Налог)
		|	КОНЕЦ";
		
		НаборЗаписейВторичногоРегистра = РегистрыНакопления.РасчетыПоСтраховымВзносам.СоздатьНаборЗаписей();
		НаборЗаписейВторичногоРегистра.Отбор.Регистратор.Установить(Регистратор);
		НаборЗаписейВторичногоРегистра.Загрузить(Запрос.Выполнить().Выгрузить());
		НаборЗаписейВторичногоРегистра.Записать(Ложь);

	КонецЕсли;
	
КонецПроцедуры

мВыполнятьДополнительныеДвижения = Ложь;
