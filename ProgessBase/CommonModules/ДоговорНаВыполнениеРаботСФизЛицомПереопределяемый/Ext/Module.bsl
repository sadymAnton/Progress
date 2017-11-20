﻿
Процедура ДобавитьСтрокуВРеглУчетПлановыхНачисленийРаботниковОрганизаций(Объект, ВыборкаПоШапкеДокумента) Экспорт
	
	// регистрируем способы отражения в учете
	
	Если НЕ ЗначениеЗаполнено(Объект.СпособОтраженияВБухучете) И НЕ ЗначениеЗаполнено(Объект.ОтнесениеРасходовКДеятельностиЕНВД) Тогда
		//не задан способ отражения, не регистрируем в регистре сведений
		Возврат;
	КонецЕсли;
	
	//Движения по регистру "РеглУчетПлановыхНачисленийРаботниковОрганизаций"
	Движение = Объект.Движения.РеглУчетПлановыхНачисленийРаботниковОрганизаций.Добавить();
	
	Если Объект.ХарактерОплаты = Перечисления.ХарактерВыплатыПоДоговору.ОднократноВКонцеСрока Тогда
		Движение.Период	= НачалоМесяца(Объект.ДатаОкончания);
	Иначе
		Движение.Период	= Объект.ДатаНачала;
	КонецЕсли;
	
	// Измерения
	Движение.Сотрудник			= Объект.Сотрудник;
	Движение.Организация		= ОбщегоНазначенияЗК.ГоловнаяОрганизация(Объект.Организация);
	Движение.ВидРасчета			= Объект.ВидРасчета;
	Движение.ДокументОснование 	= Объект.Ссылка;
	
	// Ресурсы
	Движение.СпособОтраженияВБухучете			= Объект.СпособОтраженияВБухучете;
	Движение.КодДоходаЕСН						= ВыборкаПоШапкеДокумента.КодДоходаЕСН;
	Движение.ОтнесениеРасходовКДеятельностиЕНВД = Объект.ОтнесениеРасходовКДеятельностиЕНВД;

КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение Тогда

// Формирует понятное описание порядка отражения в учете
//
// Параметры
//  Объект - ДокументОбъект.ДоговорНаВыполнениеРаботСФизЛицом -  
//                 документ, данные которого отображаются на форме
//
// Возвращаемое значение:
//   строка
//
Функция ПолучитьОписаниеОтраженияВУчете(Объект, РасшифровкаОтражениеВБухучете = Неопределено) Экспорт 

	Если РасшифровкаОтражениеВБухучете = Неопределено Тогда
		РасшифровкаОтражениеВБухучете = РаботаСДиалогамиДополнительный.ПолучитьПредставлениеСпособаОтраженияНачисленияВУчетах(Объект.СпособОтраженияВБухучете, Истина);
	КонецЕсли;
	
	Возврат СтрЗаменить(РасшифровкаОтражениеВБухучете, Символы.ПС, " ")

КонецФункции // ПолучитьОписаниеОтраженияВУчете()

Процедура ОформитьКоманднуюПанельФормы(КоманднаяПанель) Экспорт

	ДоговорНаВыполнениеРаботСФизЛицомДополнительный.УточнитьВводНаОсновании(КоманднаяПанель);

КонецПроцедуры

#КонецЕсли
