﻿////////////////////////////////////////////////////////////////////////////////
//  ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ДЛЯ РАБОТЫ С ЭЦП

// Получает назначение сертификата ЭЦП
//
// Параметры
//  ФиксированныйМассивСвойств  - ФиксированныйМассив - массив расширенных свойств сертификата (EKU)
Функция ПолучитьНазначение(ФиксированныйМассивСвойств)
	
	Назначение = "";
	
	Для Индекс = 0 По ФиксированныйМассивСвойств.Количество() - 1 Цикл
		Назначение = Назначение + ФиксированныйМассивСвойств.Получить(Индекс);
		Назначение = Назначение + Символы.ПС;
	КонецЦикла;	
	
	Возврат Назначение;
	
КонецФункции	

// Получает представление поля КомуВыдан или КемВыдан сертификата ЭЦП
//
// Параметры
//  СтруктураПользователя  - Структура - структура поля КомуВыдан или КемВыдан сертификата
// Возвращаемое значение - Строка - представление
//
// Возвращаемое значение:
//   Строка  - представление
Функция ПолучитьПредставлениеПользователя(СтруктураПользователя) Экспорт
	
	Представление = "";
	CN = "";
	Если СтруктураПользователя.Свойство("CN", CN) Тогда
		Представление = Представление + CN;
	КонецЕсли;	
	O = "";
	Если СтруктураПользователя.Свойство("O", O) Тогда
		Представление = Представление + ", " + O;
	КонецЕсли;	
	OU = "";
	Если СтруктураПользователя.Свойство("OU", OU) Тогда
		Представление = Представление + ", " + OU;
	КонецЕсли;	
	
	Возврат Представление;
	
КонецФункции	

// Заполняет структуру полями сертификата
//
// Параметры
//  Сертификат  - СертификатКриптографии - сертификат криптографии 
//
// Возвращаемое значение:
//   Структура  - структура с полями сертификата
Функция ЗаполнитьСтруктуруСертификата(Сертификат) Экспорт
	
	КомуВыдан = ПолучитьПредставлениеПользователя(Сертификат.Субъект);
	КемВыдан = ПолучитьПредставлениеПользователя(Сертификат.Издатель);
	ДействителенДо = Сертификат.ДатаОкончания;
	
	EKU = Неопределено;
	Если Сертификат.РасширенныеСвойства.Свойство("EKU", EKU) Тогда
		Назначение = ПолучитьНазначение(EKU);
	КонецЕсли;	
	
	Отпечаток = Base64Строка(Сертификат.Отпечаток);
	
	СтруктураВозврата = Новый Структура("КомуВыдан, КемВыдан, ДействителенДо, Назначение, Отпечаток",
		КомуВыдан, КемВыдан, ДействителенДо, Назначение, Отпечаток);
		
	Возврат СтруктураВозврата;
КонецФункции

