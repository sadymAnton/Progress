﻿
// сопоставление ВСД и Серии

Процедура ЗафиксроватьСвязьВСДИСерии(ВСД,Серия) Экспорт
	
	ИмяСвойства = "СоответсвуетСерии";
	УстановитьЗначениеСвойстваОбъекта(ВСД, ИмяСвойства, Серия);
	
КонецПроцедуры

// анализ входящих ВСД
Функция НовыеПараметрыОтбораВСД() Экспорт
	
	Параметры = новый Структура;
	Параметры.Вставить("ДатаТТН", Неопределено);
	Параметры.Вставить("НомерТТН", Неопределено);
	Параметры.Вставить("Контрагент", Неопределено);
	Параметры.Вставить("Номенклатура", Неопределено);
	Параметры.Вставить("ДатаВыработки", Неопределено);
	Возврат Параметры;
	
КонецФункции

Функция ВыбратьВходящиеВСД(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтурEDI_Сообщения.Ссылка
		|ИЗ
		|	Справочник.КонтурEDI_Сообщения КАК КонтурEDI_Сообщения
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтурEDI_ДополнительныеРеквизиты КАК ДополнительныеРеквизиты1
		|		ПО КонтурEDI_Сообщения.Ссылка = ДополнительныеРеквизиты1.Объект
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтурEDI_ДополнительныеРеквизиты КАК ДополнительныеРеквизиты2
		|		ПО КонтурEDI_Сообщения.Ссылка = ДополнительныеРеквизиты2.Объект
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтурEDI_ДополнительныеРеквизиты КАК ДополнительныеРеквизиты3
		|		ПО КонтурEDI_Сообщения.Ссылка = ДополнительныеРеквизиты3.Объект
		|ГДЕ
		|	КонтурEDI_Сообщения.ТипСообщения = &ТипСообщения
		|	И КонтурEDI_Сообщения.Направление = &Направление
		|	И КонтурEDI_Сообщения.НомерДокумента = &НомерДокумента
		|	И КонтурEDI_Сообщения.ДатаДокумента = &ДатаДокумента
		|	И КонтурEDI_Сообщения.Статус = &Статус
		|	И НЕ КонтурEDI_Сообщения.ПометкаУдаления
		|	И НЕ КонтурEDI_Сообщения.ОтклоненоОтправителем
		|	И НЕ КонтурEDI_Сообщения.Архив
		|	И ДополнительныеРеквизиты1.Свойство = &Свойство1
		|	И ДополнительныеРеквизиты2.Свойство = &Свойство2
		|	И ДополнительныеРеквизиты3.Свойство = &Свойство3
		|	И ДополнительныеРеквизиты1.Значение = &Контрагент
		|	И ДополнительныеРеквизиты2.Значение = &Номенклатура
		|	И ДополнительныеРеквизиты3.Значение = &ДатаВыработки";
	
	Запрос.УстановитьПараметр("ТипСообщения", "M_INC");
	Запрос.УстановитьПараметр("Направление", "Входящее");
	Запрос.УстановитьПараметр("ДатаДокумента", Параметры.ДатаТТН);
	Запрос.УстановитьПараметр("НомерДокумента", Параметры.НомерТТН);
	Запрос.УстановитьПараметр("Статус", "Действителен");
	Запрос.УстановитьПараметр("Свойство1", "Контрагент");
	Запрос.УстановитьПараметр("Свойство2", "Номенклатура");
	Запрос.УстановитьПараметр("Свойство3", "ДатаВыработки");
	Запрос.УстановитьПараметр("Контрагент", Параметры.Контрагент);
	Запрос.УстановитьПараметр("Номенклатура", Параметры.Номенклатура);
	Запрос.УстановитьПараметр("ДатаВыработки", Параметры.ДатаВыработки);
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

// дополнительные реквизиты объектов (временно)
Функция ПолучитьЗначениеСвойстваОбъекта(Объект, Свойство)
	
	НоваяЗапись = РегистрыСведений.КонтурEDI_ДополнительныеРеквизиты.СоздатьМенеджерЗаписи();
	НоваяЗапись.Объект = Объект;
	НоваяЗапись.Свойство = Свойство;
	НоваяЗапись.Прочитать();
	
	Возврат НоваяЗапись.Значение;
	
КонецФункции

Процедура УстановитьЗначениеСвойстваОбъекта(Объект, Свойство, Значение)
	
	НоваяЗапись = РегистрыСведений.КонтурEDI_ДополнительныеРеквизиты.СоздатьМенеджерЗаписи();
	НоваяЗапись.Объект = Объект;
	НоваяЗапись.Свойство = Свойство;
	НоваяЗапись.Значение = Значение;
	НоваяЗапись.Записать(Истина);
	
КонецПроцедуры

//

Процедура СформироватьКомандуОформлениеВходящейПартии(ВСД, КоличествоКПодтверждению) Экспорт
	
	ВСДОбъект = ВСД.ПолучитьОбъект();
	ВСДОбъект.ТребуемоеДействие = "Погасить";
	
	СтруктураСообщения = ВСДОбъект.Хранилище.Получить();
	СтруктураСообщения.КоличествоКПодтверждению = КоличествоКПодтверждению;
	ВСДОбъект.Хранилище = Новый ХранилищеЗначения(СтруктураСообщения);	
	ВСДОбъект.Записать();
	
КонецПроцедуры
