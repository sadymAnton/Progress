﻿
// Основные экспортные функции (точки входа)

// Корректировка качества товаров
Процедура ДокументККТ_ПриСохранении(Документ1С) Экспорт
	
	НеЗаполненныеСерии = ДатыВыработкиЗаполненыВоВсехСериях(Документ1С);
	
	Если НеЗаполненныеСерии.Количество() > 0 Тогда
		ТекстСообщения = "Для следующих серий не заполнены даты выработки: " + Символы.ПС;
		Для Каждого СтрокаВыгрузки Из НеЗаполненныеСерии Цикл
			ТекстСообщения = ТекстСообщения + СтрокаВыгрузки.СерияНоменклатуры + Символы.ПС;
		КонецЦикла;
		Сообщить(ТекстСообщения);
	КонецЕсли;
	
КонецПРоцедуры

Процедура ДокументККТ_ПриПроведении_УУ(Документ1С, Отказ) Экспорт

	ПоднадзорнаяНоменклатура = ПоднадзорнаяНоменклатураДокумента(Документ1С);
	Если ПоднадзорнаяНоменклатура.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ВыполнитьАвтоматическоеСопоставлениеСерийИВСД(Документ1С, ПоднадзорнаяНоменклатура);

	НеСопоставленныеСерии = НеСопоставленныеСерии(Документ1С);
	Если НеСопоставленныеСерии.Количество() > 0 Тогда
		ОповеститьПользователя(НеСопоставленныеСерии);
		Отказ = Истина;
	Иначе
		СформироватьКомандуОформлениеВходящейПартии(Документ1С);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДокументККТ_РучноеСопоставление(Документ1С, СерияНоменклатуры) Экспорт
	
	Если Документ1С = Неопределено Тогда
		Документ1С = НайтиДокументККТПоСерии(СерияНоменклатуры);
	КонецЕсли;
	Если Документ1С = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НачатьРучноеСопоставление(Документ1С, СерияНоменклатуры);
	
КонецПроцедуры

// Поступление товаров и услуг
Процедура ПриПроведенииПТУ_БУ(Документ1С, Отказ) Экспорт
	
	ВидПоступления = ВидПоступления();
	
	ПоднадзорнаяНоменклатура = ПоднадзорнаяНоменклатураДокумента(Документ1С);
	Если ПоднадзорнаяНоменклатура.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоПервичноеПроведение(Документ1С) Тогда
		ПервичноеПоступление(Документ1С, ПоднадзорнаяНоменклатура, ВидПоступления);
	Иначе
		КорректировкаПоступления(Документ1С, ПоднадзорнаяНоменклатура, ВидПоступления);
	КонецЕсли;
	
КонецПроцедуры

// Обработка ККТ

Функция ДатыВыработкиЗаполненыВоВсехСериях(Документ1С)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КорректировкаКачестваТоваровТовары.СерияНоменклатуры,
		|	КорректировкаКачестваТоваровТовары.Номенклатура
		|ИЗ
		|	Документ.КорректировкаКачестваТоваров.Товары КАК КорректировкаКачестваТоваровТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК СерииНоменклатуры
		|		ПО КорректировкаКачестваТоваровТовары.СерияНоменклатуры = СерииНоменклатуры.Ссылка
		|ГДЕ
		|	КорректировкаКачестваТоваровТовары.Ссылка = &Ссылка
		|	И СерииНоменклатуры.УЗ_ДатаВыработки = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)";
	
	Запрос.УстановитьПараметр("Ссылка", Документ1С);
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка = РезультатЗапроса.Выгрузить();
	
	Возврат Выгрузка;
	
КонецФункции	

// Обработка ПТУ
Функция ВидПоступления()
	
	// TO DO определение типа ПТУ: сырье, молоко, ГП
	// STOP
	Возврат "ГП";
	
КонецФункции

Функция ЭтоПервичноеПроведение(Документ1С)
	
	// STOP

КонецФункции

Процедура ПервичноеПоступление(Документ1С, ПоднадзорнаяНоменклатура, ВидПоступления)
	
	Если ВидПоступления <> "ГП" Тогда
		Возврат;
	КонецЕсли;
		
	// создание локальных партий
	Для Каждого СтрокаПеречня из ПоднадзорнаяНоменклатура Цикл
		Вет_УправлениеЛокальнымиПартиями.СоздатьЛокальнуюПартию(Документ1С, СтрокаПеречня);
	КонецЦикла;
	
	СформироватьКомандуОформлениеВходящейПартии(Документ1С);
	
КонецПроцедуры	

Процедура КорректировкаПоступления(Документ1С, ПереченьНоменклатуры, ВидПоступления)
	
	Если ВидПоступления <> "ГП" Тогда
		Возврат;
	КонецЕсли;
	
	ИзменениеНачальныхОстатковПартий = Вет_УправлениеЛокальнымиПартиями.РазностьМеждуДокументомИНачальнымиЗначениямиПартий(Документ1С);
	
	// STOP
	
КонецПроцедуры	

Процедура ВыполнитьСопоставлениеГПИВСД(Документ1С, ПереченьНоменклатуры)
	
	Параметры = Вет_ВзаимодействиеСКонтуром.НовыеПараметрыОтбораВСД();	
	Параметры.НомерТТН = Документ1С.НомерВходящегоДокумента;
	Параметры.ДатаТТН =  Документ1С.ДатаВходящегоДокумента;
	Параметры.Контрагент = Документ1С.Контрагент;
	
	Для Каждого СтрокаПеречня из ПереченьНоменклатуры Цикл
		Параметры.Номенклатура = СтрокаПеречня.Номенклатура;
		Параметры.ДатаВыработки = СтрокаПеречня.ДатаВыработки;
		ВходящиеВСД = Вет_ВзаимодействиеСКонтуром.ВыбратьВходящиеВСД(Параметры);
	
		Для Каждого ВСД из ВходящиеВСД Цикл
			НоваяЗапись = регистрыСведений.Вет_СоотвтетствиеГПИВСД.СоздатьМенеджерЗаписи();
			НоваяЗапись.ВСД = ВСД.Ссылка; 
			НоваяЗапись.ПТУ = Документ1С;
			НоваяЗапись.Номенклатура = СтрокаПеречня.Номенклатура;
			НоваяЗапись.ДатаВыработки = СтрокаПеречня.ДатаВыработки;
			
			НоваяЗапись.Записать(Истина);
		КонецЦикла;
	КонецЦикла;
		
КонецПроцедуры

// создание команд

Процедура СформироватьКомандуОформлениеВходящейПартии(Документ1С)
	
	ВСДПодлежащиеГашению = ВСДПодлежащиеГашению(Документ1С);
	
	Для Каждого СтрокаПеречня ИЗ ВСДПодлежащиеГашению Цикл
		Вет_ВзаимодействиеСКонтуром.СформироватьКомандуОформлениеВходящейПартии(СтрокаПеречня.ВСД,СтрокаПеречня.КоличествоКПодтверждению);
	КонецЦикла;
	
КонецПроцедуры

Функция ВСДПодлежащиеГашению(Документ1С)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сообщения.Ссылка КАК ВСД,
		|	0 КАК Количество,
		|	СУММА(Товары.Количество) КАК КоличествоКПодтверждению
		|ИЗ
		|	Документ.КорректировкаКачестваТоваров.Товары КАК Товары
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК Серии
		|		ПО Товары.СерияНоменклатуры = Серии.Ссылка
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтурEDI_СоответствияТоваров КАК Соответствия
		|		ПО Товары.Номенклатура = Соответствия.Номенклатура
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтурEDI_ДополнительныеРеквизиты КАК Реквизиты
		|		ПО Товары.СерияНоменклатуры = Реквизиты.Значение
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтурEDI_Сообщения КАК Сообщения
		|		ПО Реквизиты.Объект = Сообщения.Ссылка
		|ГДЕ
		|	Товары.Ссылка = &ККТ
		|	И Товары.КачествоНовое <> ЗНАЧЕНИЕ(Справочник.Качество.HOLD)
		|	И Реквизиты.Свойство = ""СоответсвуетСерии""
		|	И Сообщения.Статус = ""Действителен""
		|	И НЕ Сообщения.ОтклоненоОтправителем
		|
		|СГРУППИРОВАТЬ ПО
		|	Сообщения.Ссылка";
	
	Запрос.УстановитьПараметр("ККТ", Документ1С);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка = РезультатЗапроса.Выгрузить();
	Возврат Выгрузка;
	
КонецФункции

// выделение поднадзорной номенклатуры
Функция ПоднадзорнаяНоменклатураДокумента(Документ1С)
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаКешНоменклатуры() + ТекстЗапросаНоменклатурыДокумента(Документ1С);
	Запрос.УстановитьПараметр("Ссылка", Документ1С);
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

Функция ТекстЗапросаКешНоменклатуры()
	
	Возврат 
		"ВЫБРАТЬ
		|	СоответствияТоваров.Номенклатура
		|ПОМЕСТИТЬ
		|	КешНоменклатуры
		|ИЗ
		|	РегистрСведений.КонтурEDI_СоответствияТоваров КАК СоответствияТоваров
		|СГРУППИРОВАТЬ ПО
		|	СоответствияТоваров.Номенклатура
		|;
		|";
	
КонецФункции

Функция ТекстЗапросаНоменклатурыДокумента(Документ1С)
	
	Если ТипЗнч(Документ1С) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		Возврат ТекстЗапросаНоменклатурыПТУ();
	ИначеЕсли ТипЗнч(Документ1С) = Тип("ДокументСсылка.КорректировкаКачестваТоваров") Тогда
		Возврат ТекстЗапросаНоменклатурыККТ();
	Иначе
		Возврат "";
	КонецЕсли;	
	
КонецФункции

Функция ТекстЗапросаНоменклатурыПТУ()
	
	Возврат 
		"ВЫБРАТЬ
		|	ПоступлениеТоваровУслугТовары.Номенклатура,
		|	ПоступлениеТоваровУслугТовары.ЕдиницаИзмерения,
		|	ПоступлениеТоваровУслугТовары.Количество,
		|	ПоступлениеТоваровУслугТовары.СерияНоменклатуры,
		|	ПоступлениеТоваровУслугТовары.УЗ_ДатаВыработки КАК ДатаВыработки
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ КешНоменклатуры КАК КешНоменклатуры
		|		ПО ПоступлениеТоваровУслугТовары.Номенклатура = КешНоменклатуры.Номенклатура
		|ГДЕ
		|	ПоступлениеТоваровУслугТовары.Ссылка = &Ссылка";
	
КонецФункции

Функция ТекстЗапросаНоменклатурыККТ()
	
	Возврат
		"ВЫБРАТЬ
		|	КорректировкаКачестваТоваровТовары.Номенклатура,
		|	КорректировкаКачестваТоваровТовары.ЕдиницаИзмерения,
		|	КорректировкаКачестваТоваровТовары.Количество,
		|	КорректировкаКачестваТоваровТовары.СерияНоменклатуры,
		|	СерииНоменклатуры.УЗ_ДатаВыработки КАК ДатаВыработки
		|ИЗ
		|	Документ.КорректировкаКачестваТоваров.Товары КАК КорректировкаКачестваТоваровТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК СерииНоменклатуры
		|		ПО КорректировкаКачестваТоваровТовары.СерияНоменклатуры = СерииНоменклатуры.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ КешНоменклатуры КАК КешНоменклатуры
		|		ПО КорректировкаКачестваТоваровТовары.Номенклатура = КешНоменклатуры.Номенклатура
		|ГДЕ
		|	КорректировкаКачестваТоваровТовары.Ссылка = &Ссылка
		|	И КорректировкаКачестваТоваровТовары.КачествоНовое <> ЗНАЧЕНИЕ(Справочник.Качество.HOLD)";
	
КонецФункции

// сопоставление
Функция НеСопоставленныеСерии(Документ1С)
	
	// TO DO Фильтрация по актам инвенторизаци
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Товары.Номенклатура,
		|	Товары.ЕдиницаИзмерения,
		|	Товары.Количество,
		|	Товары.СерияНоменклатуры,
		|	Серии.УЗ_ДатаВыработки КАК ДатаВыработки
		|ПОМЕСТИТЬ
		|	СерииДокумента
		|ИЗ
		|	Документ.КорректировкаКачестваТоваров.Товары КАК Товары
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК Серии
		|		ПО Товары.СерияНоменклатуры = Серии.Ссылка
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтурEDI_СоответствияТоваров КАК Соответствия
		|		ПО Товары.Номенклатура = Соответствия.Номенклатура
		|ГДЕ
		|	Товары.Ссылка = &ККТ
		|	И Товары.КачествоНовое <> ЗНАЧЕНИЕ(Справочник.Качество.HOLD)
		|;
		|
		|ВЫБРАТЬ
		|	СерииДокумента.Номенклатура,
		|	СерииДокумента.ЕдиницаИзмерения,
		|	СерииДокумента.Количество,
		|	СерииДокумента.СерияНоменклатуры,
		|	СерииДокумента.ДатаВыработки
		|ИЗ
		|	СерииДокумента КАК СерииДокумента
		|ГДЕ
		|	СерииДокумента.СерияНоменклатуры НЕ В (
		|		ВЫБРАТЬ
		|			СерииДокумента.СерияНоменклатуры
		|		ИЗ
		|       	СерииДокумента
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КонтурEDI_ДополнительныеРеквизиты КАК Реквизиты
		|				ПО СерииДокумента.СерияНоменклатуры = Реквизиты.Значение
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтурEDI_Сообщения КАК Сообщения
		|				ПО Реквизиты.Объект = Сообщения.Ссылка
		|		ГДЕ
		|			Сообщения.Статус = ""Действителен""
		|			И НЕ Сообщения.ОтклоненоОтправителем
		|			И Реквизиты.Свойство = ""СоответсвуетСерии""
		|		СГРУППИРОВАТЬ ПО
		|			СерииДокумента.СерияНоменклатуры
		|	)
		|";
	
	Запрос.УстановитьПараметр("ККТ", Документ1С);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка = РезультатЗапроса.Выгрузить();
	Возврат Выгрузка;
	
КонецФункции

Процедура ВыполнитьСопоставлениеСерии(СерияНоменклатуры, Документ1С)
	
	Параметры = Вет_ВзаимодействиеСКонтуром.НовыеПараметрыОтбораВСД();	
	Параметры.НомерТТН = Документ1С.ДокументОснование.НомерВходящегоДокумента;
	Параметры.ДатаТТН =  Документ1С.ДокументОснование.ДатаВходящегоДокумента;
	Параметры.Контрагент = Документ1С.ДокументОснование.Контрагент;
	Параметры.Номенклатура = СерияНоменклатуры.Владелец;
	Параметры.ДатаВыработки = СерияНоменклатуры.УЗ_ДатаВыработки;
	
	ВходящиеВСД = Вет_ВзаимодействиеСКонтуром.ВыбратьВходящиеВСД(Параметры);
	
	Для Каждого ВСД из ВходящиеВСД Цикл
		Вет_ВзаимодействиеСКонтуром.ЗафиксроватьСвязьВСДИСерии(ВСД.Ссылка,СерияНоменклатуры);
	КонецЦикла;
	// TO DO обработку ошибок
	
КонецПроцедуры

Процедура ВыполнитьАвтоматическоеСопоставлениеСерийИВСД(Документ1С, ПоднадзорнаяНоменклатура)
	
	// Важно! Для строк с одинаковой номенклатурой/датойпроизводства - не выполняем автоматическое сопоставление
	ОтфильтрованныйСписок =  ИсключитьОдинаковыеНоменклатурыИзСопоставления(ПоднадзорнаяНоменклатура);
	Для Каждого СтрокаТаблицы Из ОтфильтрованныйСписок Цикл
		Если НЕ СозданАктОбИнвенторизацииВМеркурии(СтрокаТаблицы.СерияНоменклатуры) Тогда
			ВыполнитьСопоставлениеСерии(СтрокаТаблицы.СерияНоменклатуры, Документ1С);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция НачатьРучноеСопоставление(Документ1С, СерияНоменклатуры)
	
	ПараметрыПередачи = Новый Структура;
	ПараметрыПередачи.Вставить("НомерТТН", Документ1С.ДокументОснование.НомерВходящегоДокумента);
	ПараметрыПередачи.Вставить("ДатаТТН", Документ1С.ДокументОснование.ДатаВходящегоДокумента);
	ПараметрыПередачи.Вставить("Контрагент", Документ1С.ДокументОснование.Контрагент);
	ПараметрыПередачи.Вставить("Номенклатура", СерияНоменклатуры.Владелец);
	ПараметрыПередачи.Вставить("ДатаВыработки", СерияНоменклатуры.УЗ_ДатаВыработки);
	ПараметрыПередачи.Вставить("СерияНоменклатуры", СерияНоменклатуры);
	
	ПолучаемаяФорма =  ПолучитьОбщуюФорму("Вет_СопоставлениеСерийНоменклатурыСВСД"); 
	ПолучаемаяФорма.ПараметрыПриема = ПараметрыПередачи;
	ПолучаемаяФорма.Открыть();

КонецФункции

Функция НайтиДокументККТПоСерии(СерияНоменклатуры)
	
	Документ1С = Неопределено;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КорректировкаКачестваТоваровТовары.Ссылка КАК ДокументККТ
		|ИЗ
		|	Документ.КорректировкаКачестваТоваров.Товары КАК КорректировкаКачестваТоваровТовары
		|ГДЕ
		|	КорректировкаКачестваТоваровТовары.СерияНоменклатуры = &СерияНоменклатуры
		|
		|СГРУППИРОВАТЬ ПО
		|	КорректировкаКачестваТоваровТовары.Ссылка";
	
	Запрос.УстановитьПараметр("СерияНоменклатуры", СерияНоменклатуры);
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка = РезультатЗапроса.Выгрузить();
	
	Если Выгрузка.Количество() = 0 Тогда
		Сообщить("Серия не включена ни в один документ.");
	КонецЕсли;	
	Если Выгрузка.Количество() = 1 Тогда
		Документ1С = Выгрузка[0].ДокументККТ;
	КонецЕсли;	
	Если Выгрузка.Количество() > 1 Тогда
		Сообщить("Серия включена более чем в один документ.");
	КонецЕсли;	
	
	Возврат Документ1С;
	
КонецФункции

Функция СозданАктОбИнвенторизацииВМеркурии(Скрия)
	
	// STOP
	Возврат Ложь;
	
КонецФункции

Функция ИсключитьОдинаковыеНоменклатурыИзСопоставления(ПоднадзорнаяНоменклатура)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"
	|ВЫБРАТЬ
	|	Т3.Номенклатура,
	|	Т3.ЕдиницаИзмерения,
	|	Т3.Количество,
	|	Т3.СерияНоменклатуры,
	|	Т3.ДатаВыработки
	|ПОМЕСТИТЬ
	|	КешНоменклатуры
	|ИЗ
	|	&ВТ КАК Т3
	|;
	|
	|ВЫБРАТЬ
	|	Т2.Номенклатура,
	|	Т2.ЕдиницаИзмерения,
	|	Т2.Количество,
	|	Т2.СерияНоменклатуры,
	|	Т2.ДатаВыработки
	|ИЗ
	|	КешНоменклатуры КАК Т2
	|	ЛЕВОЕ СОЕДИНЕНИЕ 	
	|		(ВЫБРАТЬ
	|			Т1.Номенклатура,
	|			Т1.ДатаВыработки
	|		ИЗ
	|			КешНоменклатуры КАК Т1
	|		СГРУППИРОВАТЬ ПО
	|			Т1.Номенклатура,
	|			Т1.ДатаВыработки
	|		ИМЕЮЩИЕ
	|			КОЛИЧЕСТВО(Т1.Номенклатура) > 1 ) Дубли
	|	ПО Т2.Номенклатура = Дубли.Номенклатура И Т2.ДатаВыработки = Дубли.ДатаВыработки
	|ГДЕ
	|	(Дубли.Номенклатура ЕСТЬ NULL)";
	
	Запрос.УстановитьПараметр("ВТ", ПоднадзорнаяНоменклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выгрузка = РезультатЗапроса.Выгрузить();
	Возврат Выгрузка;

КонецФункции

Процедура ОповеститьПользователя(НеСопоставленныеСерии)
	
	Если НеСопоставленныеСерии.Количество() > 0 Тогда
		ТекстСообщения = "Для следующих серий не выполнено сопоставление с ВСД: " + Символы.ПС;
		Для Каждого СтрокаВыгрузки Из НеСопоставленныеСерии Цикл
			ТекстСообщения = ТекстСообщения + СтрокаВыгрузки.СерияНоменклатуры + Символы.ПС;
		КонецЦикла;
		Сообщить(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры
