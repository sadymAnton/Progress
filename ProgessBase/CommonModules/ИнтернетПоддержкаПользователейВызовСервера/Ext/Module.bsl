﻿
///////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПО РАБОТЕ С ОБРАБОТКАМИ

// Процедура записывает из двоичных данных файл обработки в константу.
//
// Параметры:
//	ДвоичныеДанныеОбработки - ДвоичныеДанные - двоичные данные обработки.
//
Процедура ЗаписатьФайлОбработкиВКонстанту(ДвоичныеДанныеОбработки) Экспорт
	
	Если ДвоичныеДанныеОбработки <> Неопределено Тогда 
		Константы.ФайлОбработкиИнтернетПоддержкиПользователей.Установить(Новый ХранилищеЗначения(ДвоичныеДанныеОбработки));
	КонецЕсли;	
	
КонецПроцедуры	

// Функция определеяет версию обработки механизма интернет-поддержки пользователей.
//
// Возвращаемое значение - Неопределено или Строка - версия обработки.
//
Функция ПолучитьВерсиюОбработки() Экспорт
	
	ФайлОбработки = Константы.ФайлОбработкиИнтернетПоддержкиПользователей.Получить().Получить();
	Если ФайлОбработки = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	Попытка
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("epf");
		ФайлОбработки.Записать(ИмяВременногоФайла);
		ВнешняяОбработка = ВнешниеОбработки.Создать(ИмяВременногоФайла);
		Версия = ВнешняяОбработка.ВерсияМеханизмаИнтернетПоддержкиПользователей();
		Возврат Версия;
	Исключение
		Возврат Неопределено;
	КонецПопытки;	
	
КонецФункции	

///////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПО РАБОТЕ С НАСТРОЙКАМИ ПОЛЬЗОВАТЕЛЕЙ

// Устанавливает настройку "ПовторитьПопыткуПодключенияПриСтартеПрограммы", которая не позволяет "стучаться" механизму 
// до появления связи.
//
// Параметры:
//	УстанавливатьНастройку - Булево - установить или сбросить "ПовторитьПопыткуПодключенияПриСтартеПрограммы".
//
Процедура УстановитьНастройкуПовторитьПопыткуПодключенияПриСтартеПрограммы(УстанавливатьНастройку) Экспорт 
	
	ХранилищеОбщихНастроек.Сохранить("ИнтернетПоддержкаПользователей", "ПовторитьПопыткуПодключенияПриСтартеПрограммы", УстанавливатьНастройку);
	
КонецПроцедуры	

// Возвращает настройку "ПовторитьПопыткуПодключенияПриСтартеПрограммы".
//
// Возвращаемое значение - Неопределено или Булево - напоминать об отсутствии связи.
//
Функция ПолучитьНастройкуПовторитьПопыткуПодключенияПриСтартеПрограммы() Экспорт
	
	ПовторитьПопыткуПодключенияПриСтартеПрограммы = ХранилищеОбщихНастроек.Загрузить("ИнтернетПоддержкаПользователей", "ПовторитьПопыткуПодключенияПриСтартеПрограммы");
	
	Возврат ?(ПовторитьПопыткуПодключенияПриСтартеПрограммы = Неопределено, Истина, ПовторитьПопыткуПодключенияПриСтартеПрограммы);
	
КонецФункции	

///////////////////////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура получает, если есть логин и пароль из инетрнет-поддрежки пользователей.
//
// Параметры:
//	Логин - Строка - логин.
//	Пароль - Строка - пароль.
//
Процедура ЗагрузкаЛогинаИПароляИзПараметровИнтернетПоддержкиПользователей(Логин = "", Пароль = "") Экспорт
	
	Фильтр = Новый Структура("Имя", "login");
	Выборка = РегистрыСведений.ПараметрыИнтернетПоддержкиПользователей.Выбрать(Фильтр);
	Пока Выборка.Следующий() Цикл
		Если ПустаяСтрока(Выборка.БизнесПроцесс) Тогда 
			Логин = Выборка.Значение;
			Прервать;
		КонецЕсли;	
	КонецЦикла;	
	
	Фильтр = Новый Структура("Имя", "password");
	Выборка = РегистрыСведений.ПараметрыИнтернетПоддержкиПользователей.Выбрать(Фильтр);
	Пока Выборка.Следующий() Цикл
		Если ПустаяСтрока(Выборка.БизнесПроцесс) Тогда 
			Пароль = Выборка.Значение;
			Прервать;
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры	

// Процедура записывает в журнал регистрации код ошибки.
//
// Параметры:
//	КодОшибки - Строка - код ошибки.
//
Процедура ЗаписатьОшибкуВЖурналРегистрации(Ошибка) Экспорт
	
	ИмяСобытия	= НСтр("ru = 'Интернет-поддержка пользователей: Ошибка'");
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , Ошибка);
	
КонецПроцедуры

// Возвращает запускать или нет механизм или нет.
// 
// Возвращаемое значение - Булево - Истина, если запускать, Ложь - иначе.
//
Функция ЗапускатьМеханизмПриСтарте() Экспорт
	
	ПовторитьПопыткуПодключенияПриСтартеПрограммы	= ХранилищеОбщихНастроек.Загрузить("ИнтернетПоддержкаПользователей", "ПовторитьПопыткуПодключенияПриСтартеПрограммы");
	ПовторитьПопыткуПодключенияПриСтартеПрограммы	= ?(ПовторитьПопыткуПодключенияПриСтартеПрограммы = Неопределено, Истина, ПовторитьПопыткуПодключенияПриСтартеПрограммы);
	ВсегдаПоказыватьПриСтартеПрограммы				= ХранилищеОбщихНастроек.Загрузить("ИнтернетПоддержкаПользователей", "ВсегдаПоказыватьПриСтартеПрограммы");
	ВсегдаПоказыватьПриСтартеПрограммы				= ?(ВсегдаПоказыватьПриСтартеПрограммы= Неопределено, Истина, ВсегдаПоказыватьПриСтартеПрограммы);
	
	Возврат ПовторитьПопыткуПодключенияПриСтартеПрограммы и ВсегдаПоказыватьПриСтартеПрограммы;
	
КонецФункции

// Процедура сохранения стартовых параметров в регистре сведений
// при запуске механизма
//
// Параметры
// СтруктураСтартовыхПараметров - структура Ключ - имя параметра
//                                значение - значение параметра во временном хранилище
// ОбластьВидимости - область видимости параметра
Процедура СохранитьСтартовыеПараметры(СтруктураСтартовыхПараметров, ОбластьВидимости) Экспорт
	
	Для каждого ЭлементСтруктуры Из СтруктураСтартовыхПараметров Цикл
	
		Запись = РегистрыСведений.ПараметрыИнтернетПоддержкиПользователей.СоздатьМенеджерЗаписи();
		Запись.Имя              = ЭлементСтруктуры.Ключ;
		Запись.Значение         = ЗначениеВСтрокуВнутр(ПолучитьИзВременногоХранилища(ЭлементСтруктуры.Значение));
		Запись.Пользователь     = "00000000-0000-0000-0000-000000000000";
		Запись.ОбластьВидимости = ОбластьВидимости;
		Запись.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С ВЕБ-СЕРВИСОМ ИПП

// Проверяет возможность обслуживания конфигурации в ИПП
//
// Параметры:
//	ОшибкаДоступаКВебСервису (Булево) - в параметре возвращается значение Истина,
//		если в процессе обращения к веб-сервису появилась ошибка
//
// Возвращаемое значение:
//	Истина - есть доступ к веб-сервиу, Ложь - нет доступа.
//
Функция КонфигурацияЗарегистрированаВСервисеИПП(ОшибкаДоступаКВебСервису = Ложь) Экспорт
	
	Попытка
		
		ИмяWSОпределения = ИнтернетПоддержкаПользователейКлиентСервер.ИмяWSОпределения();
		ПараметрыWSОпределений = Новый Массив;
		ПараметрыWSОпределений.Добавить(ИмяWSОпределения);
		ПараметрыWSОпределений.Добавить(Неопределено); // Имя пользователя
		ПараметрыWSОпределений.Добавить(Неопределено); // Пароль
		
		ТаймаутПодключения = 0;
		ИспользоватьТаймауты = ИспользоватьТаймаутыПриПодключении(ТаймаутПодключения);
		Если ИспользоватьТаймауты Тогда
			ПараметрыWSОпределений.Добавить(ТаймаутПодключения);
		КонецЕсли;
		
		ОпределениеWS = Новый (Тип("WSОпределения"), ПараметрыWSОпределений);
		
		ИмяURIСервиса    = ИнтернетПоддержкаПользователейКлиентСервер.ИмяURIСервиса();
		Сервис           = ОпределениеWS.Сервисы.Получить(0);
		ИмяСервиса       = Сервис.Имя;
		ТочкаПодключения = Сервис.ТочкиПодключения.Получить(0).Имя;
		
		ПараметрыКлиентаWS = Новый Массив;
		ПараметрыКлиентаWS.Добавить(ОпределениеWS);
		ПараметрыКлиентаWS.Добавить(ИмяURIСервиса);
		ПараметрыКлиентаWS.Добавить(ИмяСервиса);
		ПараметрыКлиентаWS.Добавить(ТочкаПодключения);
		
		Если ИспользоватьТаймауты Тогда
			ПараметрыКлиентаWS.Добавить(ТаймаутПодключения);
		КонецЕсли;
		
		КлиентWS = Новый (Тип("WSПрокси"), ПараметрыКлиентаWS);
		
		// В качестве параметра метода передается имя конфигурации
		ИмяКонфигурации = Метаданные.Имя;
		ОтветСервера = КлиентWS.isConfigurationSupported(ИмяКонфигурации);
		
		Возврат (ОтветСервера = Истина ИЛИ ОтветСервера = "true");
		
	Исключение
		ОшибкаДоступаКВебСервису = Истина;
		ЗаписатьОшибкуВЖурналРегистрации(ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

// Возвращаемое значение: Булево: Истина - платформа поддерживает таймауты сети,
//	Ложь - в противном случае
//
Функция ИспользоватьТаймаутыПриПодключении(Таймаут = Неопределено) Экспорт
	
	//СистемнаяИнформация = Новый СистемнаяИнформация;
	//ВерсияПриложения = СистемнаяИнформация.ВерсияПриложения;
	
	ВерсияПриложения = "8.2.15.392";
	
	КоличествоСимволов = СтрДлина(ВерсияПриложения);
	ВерсияСтрокой       = "";
	Подверсия           = "";
	КоличествоПодверсий = 0;
	Для Итератор = 1 По КоличествоСимволов Цикл
		ТекущийСимвол = Сред(ВерсияПриложения, Итератор, 1);
		Если ТекущийСимвол <> "." Тогда
			Подверсия = Подверсия + ТекущийСимвол;
		Иначе
			ВерсияСтрокой = ВерсияСтрокой + Прав("0000" + Подверсия, 4);
			Подверсия     = "";
			КоличествоПодверсий = КоличествоПодверсий + 1;
			Если КоличествоПодверсий > 2 Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Результат = (ВерсияСтрокой > "000800020016");
	
	Если Результат Тогда
		УстановитьПривилегированныйРежим(Истина);
		Таймаут = Константы.ТаймаутПодключенияКСервисуИнтернетПоддержки.Получить();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
