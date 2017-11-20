﻿Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// 1. Закрываем все счета, начиная с 600
	ТекстЗапроса = "ВЫБРАТЬ
	               |	МеждународныйОстатки.Счет КАК Счет,
	               |	МеждународныйОстатки.СуммаОстатокДт КАК СуммаОстатокДт,
	               |	МеждународныйОстатки.СуммаОстатокКт КАК СуммаОстатокКт,
	               |	МеждународныйОстатки.Счет.Код КАК Код
	               |ИЗ
	               |	РегистрБухгалтерии.Международный.Остатки(&Дата,  Счет.Код >= &Код600 И Счет.Код <> &Код999, , Организация = &Организация ) КАК МеждународныйОстатки";


	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Дата", Новый Граница(КонецГода(ДобавитьМесяц(Дата,-12)), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Код600", "600");
	Запрос.УстановитьПараметр("Код999", "999");
	Запрос.УстановитьПараметр("Организация", Организация);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	СуммаДебет  = 0;
	СуммаКредит = 0;
	// Сворачиваем счета по количеству субконто
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.СуммаОстатокДт <> 0 Тогда
			Движение = Движения.Международный.Добавить();
			Движение.Период = НачалоГода(Дата);
			Движение.СчетДт = ПланыСчетов.Международный.СуммарныеДоходыИРасходы;
			Движение.СчетКт = Выборка.Счет;
			Движение.Организация = Организация;
			Движение.Сумма = Выборка.СуммаОстатокДт;
			СуммаДебет     = СуммаДебет + Выборка.СуммаОстатокДт;
			Движение.Содержание = "Закрытие счетов в конце финансового года";
			Движение.НомерЖурнала = "Рег";

		ИначеЕсли Выборка.СуммаОстатокКт <> 0 Тогда
			Движение = Движения.Международный.Добавить();
			Движение.Период = НачалоГода(Дата);
			Движение.СчетДт = Выборка.Счет;
			Движение.СчетКт = ПланыСчетов.Международный.СуммарныеДоходыИРасходы;
			СуммаКредит     = СуммаКредит + Выборка.СуммаОстатокКт;
			Движение.Организация = Организация;
			Движение.Сумма = Выборка.СуммаОстатокКт;
			Движение.Содержание = "Закрытие счетов в конце финансового года";
			Движение.НомерЖурнала = "Рег";
		КонецЕсли;
	КонецЦикла;
	
	//2. Сальдо по 999 переносим на 304. так же как 1.
	
	Если СуммаКредит > 0 ИЛИ СуммаДебет > 0 Тогда
	
		Движение = Движения.Международный.Добавить();
		Движение.Период = КонецГода(ДобавитьМесяц(Дата,-12));
		
		Если СуммаДебет >= СуммаКредит Тогда
			Движение.СчетДт = ПланыСчетов.Международный.НераспределеннаяПрибыль;
			Движение.СчетКт = ПланыСчетов.Международный.СуммарныеДоходыИРасходы;
			Движение.Сумма = СуммаДебет - СуммаКредит;
		Иначе
			Движение.СчетДт = ПланыСчетов.Международный.СуммарныеДоходыИРасходы;
			Движение.СчетКт = ПланыСчетов.Международный.НераспределеннаяПрибыль;
			Движение.Сумма = СуммаКредит - СуммаДебет;
		КонецЕсли;
		
		Движение.Организация = Организация;
		Движение.Содержание = "Закрытие счетов в конце финансового года";
		Движение.НомерЖурнала = "Рег";
		
	КонецЕсли;
	
	// записываем движения регистров
	Движения.Международный.Записать();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью





