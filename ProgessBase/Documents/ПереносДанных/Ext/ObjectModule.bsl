﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем ЗапретОткрытияДокумента Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Если ТолстыйКлиентОбычноеПриложение Тогда
	
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

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначенияЗК.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные табличные части для заполнения
//
// Возвращаемое значение:
//   Список значений с именами табличных частей
//
Функция ПолучитьТабличныеЧастиДляЗаполнения() Экспорт

	ТабличныеЧасти = Новый СписокЗначений;
	
	Возврат ТабличныеЧасти;

КонецФункции // ПолучитьТабличныеЧастиДляЗаполнения()

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура устанавливает/снимает признак активности движений документа
//
Процедура УстановитьАктивностьДвижений(ФлагАктивности)
	
	Для Каждого Движение Из Движения Цикл   
		Движение.Прочитать();
		Для Каждого Строка Из Движение Цикл
			Строка.Активность = ФлагАктивности;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры // УстановитьАктивностьДвижений()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПриКопировании(ОбъектКопирования)
	
	Заголовок = "Копирование документа: "+СокрЛП(ОбъектКопирования);
	ТаблицаРегистров_ДвиженияДокументаОснования = ПолныеПрава.ОпределитьНаличиеДвиженийПоРегистратору(ОбъектКопирования.Ссылка);
	Для каждого Строка из ТаблицаРегистров_ДвиженияДокументаОснования цикл
		//В таблице имя регистра хранится в виде РегистрСведений.<ИмяРегистра>, РегистрНакопления.<ИмяРегистра> и т.д.
		ПолноеИмяРегистра = СокрЛП(Строка.Имя);
		ПозицияТочки = Найти(ПолноеИмяРегистра,".");
		ТипРегистра = Лев(ПолноеИмяРегистра,ПозицияТочки-1);
		//Для получения метаданных тип регистра должен быть не РегистрНакопления а РегистрыНакопления - необходимо изменить тип регистра
		ТипРегистра = СтрЗаменить(ТипРегистра,"Регистр","Регистры");
		ИмяРегистра = Прав(СокрЛП(Строка.Имя),стрДлина(СокрЛП(Строка.Имя))-ПозицияТочки);
		МетаданныеРегистра = Метаданные[ТипРегистра][ИмяРегистра];
		Если НЕ (ПараметрыДоступа("Изменение", МетаданныеРегистра, "", ПользователиИнформационнойБазы.ТекущийПользователь()).Доступность
			И ПараметрыДоступа("Чтение", МетаданныеРегистра, "", ПользователиИнформационнойБазы.ТекущийПользователь()).Доступность) Тогда
			ОбщегоНазначенияЗК.СообщитьОбОшибке("Недостаточно прав доступа к регистру """+ИмяРегистра+"""",ЗапретОткрытияДокумента,Заголовок);
			Продолжить;
		КонецЕсли;
		Набор = ОбъектКопирования.Движения[ИмяРегистра];
		//Используется попытка на случай наличия ограничений доступа к регистру на уровне записей
		Попытка
			Набор.Прочитать();
		Исключение
			ОбщегоНазначенияЗК.СообщитьОбОшибке("Установлено ограничение доступа на уровне записей к регистру """+ИмяРегистра+"""",ЗапретОткрытияДокумента,Заголовок);
			Продолжить;
		КонецПопытки;
		
		НаборТекущегоОбъекта = Движения[ИмяРегистра];
		Для каждого ЗаписьНабора Из Набор Цикл
		
			НоваяЗапись = НаборТекущегоОбъекта.Добавить();
			Если Найти(нрег(ТипРегистра),"накопления")<>0 Тогда
				Если МетаданныеРегистра.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
					НоваяЗапись.ВидДвижения = ЗаписьНабора.ВидДвижения;
				КонецЕсли;
				ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗаписьНабора,,"Период,Регистратор,ВидДвижения");
				НоваяЗапись.Период				= ТекущаяДата();
				
			ИначеЕсли Найти(нрег(ТипРегистра),"расчета")<>0 Тогда
				ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗаписьНабора,,"ПериодРегистрации,Регистратор");
				НоваяЗапись.ПериодРегистрации	= ТекущаяДата();
				
			Иначе
				ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗаписьНабора,,"Период,Регистратор");
				НоваяЗапись.Период				= ТекущаяДата();
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Если  ЗапретОткрытияДокумента Тогда
		ОбщегоНазначенияЗК.СообщитьОбОшибке("Документ не может быть скопирован!",ЗапретОткрытияДокумента,Заголовок);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	ПереносДанныхПереопределяемый.ПередЗаписью(Отказ, ЭтотОбъект);
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоНовый() И Ссылка.ПометкаУдаления <> ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(НЕ ПометкаУдаления);
	ИначеЕсли ПометкаУдаления Тогда
		//запись помеченного на удаление документа с активными записями
		УстановитьАктивностьДвижений(Ложь);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

ЗапретОткрытияДокумента = ложь;
