﻿/////////////////////////////////////////////////////////////////////////////////
// Внутренние процедуры и функции подсистемы "Базовая функциональность",
// предназначенные для вызова из клиентского кода
//

// Записать настройку подтверждения завершения работы программы
// для текущего пользователя.
// 
// Параметры:
//   Значение - Булево   - значение настройки.
// 
Процедура СохранитьНастройкуПодтвержденияПриЗавершенииПрограммы(Значение) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы", Значение);
	
КонецПроцедуры

// Возвращает настройку подтверждения завершения работы программы
// для текущего пользователя.
// 
Функция ЗагрузитьНастройкуПодтвержденияПриЗавершенииПрограммы() Экспорт
	
	Результат = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы");
	Если Результат = Неопределено Тогда
		Результат = Истина;
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

