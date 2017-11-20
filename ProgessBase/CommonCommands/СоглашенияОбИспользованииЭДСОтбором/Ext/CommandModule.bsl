﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	НазваниеСправочникаБанки = ИмяПрикладногоСправочника("Банки");
	Если Не ЗначениеЗаполнено(НазваниеСправочникаБанки) Тогда
		НазваниеСправочникаБанки = "КлассификаторБанковРФ";
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Контрагенты") Тогда
		ПараметрыФормы.Вставить("Контрагент", ПараметрКоманды);
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Организации") Тогда
		ПараметрыФормы.Вставить("Организация", ПараметрКоманды);
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка." + НазваниеСправочникаБанки) Тогда
		ПараметрыФормы.Вставить("Банк", ПараметрКоманды);
	КонецЕсли;
	
	Если ИспользуетсяДополнительнаяАналитикаКонтрагентов() Тогда
		НазваниеСправочникаПартнеры = ИмяПрикладногоСправочника("Партнеры");
		Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка." + НазваниеСправочникаПартнеры) Тогда
			ПараметрыФормы.Вставить("Партнер", ПараметрКоманды);
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

&НаСервере
Функция ИмяПрикладногоСправочника(Название)
	
	Возврат ЭлектронныеДокументыПовтИсп.ПолучитьИмяПрикладногоСправочника(Название);
	
КонецФункции

&НаСервере
Функция ИспользуетсяДополнительнаяАналитикаКонтрагентов()
	
	Возврат ЭлектронныеДокументыПовтИсп.ИспользуетсяДополнительнаяАналитикаКонтрагентовСправочникПартнеры();
	
КонецФункции
