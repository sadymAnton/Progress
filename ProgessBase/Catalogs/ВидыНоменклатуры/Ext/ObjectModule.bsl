﻿// Обработчик события ПередЗаписью формы.
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Не  ЗначениеЗаполнено(ТипНоменклатуры) Тогда
		ТекстСообщения = "Необходимо указать тип номенклатуры!";
		ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ);
	КонецЕсли;

	СуществуютСсылки = Неопределено;
	Если НЕ ЭтоНовый() 
	   И ТипНоменклатуры <> Ссылка.ТипНоменклатуры 
	   И ПолныеПрава.ВидыНоменклатуры_СуществуютСсылкиВНоменклатуре(Ссылка, СуществуютСсылки) Тогда
		ТекстСообщения = "Вид номенклатуры """ + СокрЛП(Ссылка) + """ выбран в элементах справочника ""Номенклатура"".
		|Тип не может быть изменен!";
		ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ);
	КонецЕсли;
	
	//m_ionov@mail.ru 31.08.2016
	Если Не Отказ 
		И Не ЭтоНовый() 
		И Ссылка.НСИ_ОбменСПролайт
		И НЕ НСИ_ОбменСПролайт Тогда
		//Выполнили снятие признака обмена с Пролайт, 
		//проверим нет ли объектов с данным видом номенклатуры выгруженных в Пролайт
		Если Не МЗ_ОбменПролайт.ПроверкаВозможностиИзмененияПризнакаОбменасПролайт(Ссылка) Тогда
			НСИ_ОбменСПролайт = Истина;	
		КонецЕсли;	
	КонецЕсли;
	//------- m_ionov@mail.ru -------
	
	//m_ionov@mail.ru 24.11.2016
	//Если вид номенклатуры где-то используется в номенклатуре, то изменить признак "НСИ_РазузловыватьВПотребностях" может только администратор
	Если Не Отказ 
		И Не ЭтоНовый() 
		И НЕ Ссылка.НСИ_РазузловыватьВПотребностях = НСИ_РазузловыватьВПотребностях
		И НЕ РольДоступна("МЗ_Администратор") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	Номенклатура.Ссылка
		               |ИЗ
		               |	Справочник.Номенклатура КАК Номенклатура
		               |ГДЕ
		               |	Номенклатура.ВидНоменклатуры = &ВидНоменклатуры";
		Запрос.УстановитьПараметр("ВидНоменклатуры", Ссылка);
		Если Не Запрос.Выполнить().Пустой() Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Вид номенклатуры " + СокрЛП(Ссылка) + " уже используется в справочнике Номенклатура!" + " Для изменения признака Разузловывать в потребностях обратитесь в ИТ службу", Отказ);
			НСИ_РазузловыватьВПотребностях = Ссылка.НСИ_РазузловыватьВПотребностях;
		КонецЕсли;
		
	КонецЕсли;
	//------- m_ionov@mail.ru -------

КонецПроцедуры // ПередЗаписью()

//m_ionov@mail.ru 07.09.2016
Процедура ПриКопировании(ОбъектКопирования)
	Если Не ЭтотОбъект.ЭтоГруппа Тогда
		НСИ_ОбменСПролайт = Ложь;
		НСИ_РазузловыватьВПотребностях = Ложь;
	КонецЕсли;
КонецПроцедуры
//------- m_ionov@mail.ru -------

