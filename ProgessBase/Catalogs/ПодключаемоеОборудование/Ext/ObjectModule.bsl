﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура производит инициализацию параметров устройства.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
    УстройствоОтключено = НЕ УстройствоИспользуется;
	
	Если ЭтоНовый() Тогда
		Параметры = Новый ХранилищеЗначения(Новый Структура());
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура проверяет уникальность наименования элемента справочника
// для данного компьютера.
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если НЕ ПустаяСтрока(Наименование) Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|    1
		|ИЗ
		|    Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|    ПодключаемоеОборудование.Наименование = &Наименование
		|    И ПодключаемоеОборудование.РабочееМесто = &РабочееМесто
		|    И ПодключаемоеОборудование.Ссылка <> &Ссылка
		|");

		Запрос.УстановитьПараметр("Наименование", Наименование);
		Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
		Запрос.УстановитьПараметр("Ссылка"      , Ссылка);

		Если Не Запрос.Выполнить().Пустой() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Указано неуникальное наименование элемента!
			                                                       |Необходимо указать уникальное наименование.'"),
			                                                  ЭтотОбъект, , , Отказ);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура производит очистку реквизитов, которые не должны копироваться.
// Следующие реквизиты очищаются при копировании:
// "УстройствоОтключено" - устанавливается для нового устройства в Ложь;
// "Параметры"      - параметры устройства сбрасываются в Неопределено;
// "Наименование"   - устанавливается отличное от исходного наименования;
Процедура ПриКопировании(ОбъектКопирования)
	
	УстройствоОтключено = Ложь;
	УстройствоИспользуется = Истина;
	Параметры = Неопределено;

	Наименование = НСтр("ru='%Наименование% (копия)'");
	Наименование = СтрЗаменить(Наименование, "%Наименование%", ОбъектКопирования.Наименование);
	
КонецПроцедуры

// При записи
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры
