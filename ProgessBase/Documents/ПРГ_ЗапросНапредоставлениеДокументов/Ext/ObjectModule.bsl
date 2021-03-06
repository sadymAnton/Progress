﻿ Перем мУдалятьДвижения;
 
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	НаборЗаписей       = РегистрыСведений.ПРГ_ЗапросынаПредоставлениеДокументов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Запрос.Установить(Ссылка);
	НаборЗаписей.Отбор.Статус.Установить(Статус);
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	НоваяЗапись        = НаборЗаписей.Добавить();
	НоваяЗапись.Запрос  = Ссылка;  
	Если Статус = Перечисления.ПРГ_СтатусыЗапросовНаПредоставление.Открыт Тогда
		НоваяЗапись.Период       = Ссылка.Дата; 
	ИначеЕсли Статус = Перечисления.ПРГ_СтатусыЗапросовНаПредоставление.ВРаботе Тогда
		НоваяЗапись.Период       = ТекущаяДата(); 
	ИначеЕсли Статус = Перечисления.ПРГ_СтатусыЗапросовНаПредоставление.Закрыт Тогда
		НоваяЗапись.Период       = ТекущаяДата(); 
	КонецЕсли;
	НоваяЗапись.Организация = Организация;
	НоваяЗапись.Инициатор = Инициатор;
	НоваяЗапись.Исполнитель = Исполнитель;
	НоваяЗапись.ПредметЗапроса = ПредметЗапроса;
	НоваяЗапись.ВидЗапроса = ВидЗапроса;	
	НоваяЗапись.Статус = Статус;
	НоваяЗапись.Отправлено = Ложь;
	
	НаборЗаписей.Записать(); 

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	мУдалятьДвижения = НЕ ЭтоНовый();

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если мУдалятьДвижения Тогда
		НаборЗаписей       = РегистрыСведений.ПРГ_ЗапросынаПредоставлениеДокументов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Запрос.Установить(Ссылка);
		НаборЗаписей.Отбор.Организация.Установить(Организация);
		НаборЗаписей.Записать();	
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание)
	Если ЭтоНовый() И НЕ Основание = Неопределено И НЕ ТипЗнч(Основание) = Тип("Структура") Тогда
		
		ДокументОснование = Основание;
								
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
		ЗаполнимПоДаннымОснования(Основание);
	КонецЕсли;
   
КонецПроцедуры
Процедура   ЗаполнимПоДаннымОснования(Основание)
	 ЗаполнитьЗначенияСвойств(ЭтотОбъект, Основание, "Исполнитель, Комментарий, ЗапрашиваемыйДокумент, ПредоставленныйДокумент, Склад");

КонецПроцедуры