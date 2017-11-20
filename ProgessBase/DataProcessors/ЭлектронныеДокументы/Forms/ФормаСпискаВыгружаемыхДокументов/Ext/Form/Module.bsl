﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиенте
Процедура ВывестиЭДНаПросмотр(СтрокаДанных)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПолноеИмяФайла");
	СтруктураПараметров.Вставить("НаименованиеФайла");
	СтруктураПараметров.Вставить("НаправлениеЭД");
	СтруктураПараметров.Вставить("Контрагент");
	СтруктураПараметров.Вставить("УникальныйИдентификатор");
	СтруктураПараметров.Вставить("ВладелецЭД");
	СтруктураПараметров.Вставить("ЭлектронныйДокумент");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, СтрокаДанных);
	Если ЗначениеЗаполнено(СтруктураПараметров.ЭлектронныйДокумент) Тогда
		ЭлектронныеДокументыСлужебныйКлиент.ОткрытьЭДДляПросмотра(СтруктураПараметров.ЭлектронныйДокумент);
	Иначе
		ОткрытьФорму("Обработка.ЭлектронныеДокументы.Форма.ФормаЗагрузкиПросмотраЭД",
			Новый Структура("СтруктураЭД", СтруктураПараметров), ЭтаФорма, СтруктураПараметров.УникальныйИдентификатор);
	КонецЕсли;
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ТаблицаДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВывестиЭДНаПросмотр(ТаблицаДанных[ВыбраннаяСтрока]);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтруктурЭД = "";
	Если Параметры.Свойство("СтруктураЭД", МассивСтруктурЭД) Тогда
		Для Каждого СтруктураОбмена Из МассивСтруктурЭД Цикл
			НоваяСтрока = ТаблицаДанных.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураОбмена);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры


