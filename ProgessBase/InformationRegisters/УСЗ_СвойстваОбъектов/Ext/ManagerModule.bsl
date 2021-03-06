﻿//
////// Интерфейс РС
//

// ПолучитьВнешнийИдентификаторОбъекта
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
Функция ПолучитьВнешнийИдентификаторОбъекта(Объект) Экспорт 

	ИмяСвойства = Метаданные.РегистрыСведений.УСЗ_СвойстваОбъектов.Ресурсы.ВнешнийИдентификатор.Имя;
	Возврат ПолучитьСвойствоОбъекта(Объект, ИмяСвойства);	

КонецФункции // ПолучитьВнешнийИдентификаторОбъекта()

// УстановитьВнешнийИдентификаторОбъекта
// возвращает Истина если внешний идентификатор установлен успешно
Функция УстановитьВнешнийИдентификаторОбъекта(Объект, Знач Значение=Неопределено) Экспорт 

	ИмяСвойства = Метаданные.РегистрыСведений.УСЗ_СвойстваОбъектов.Ресурсы.ВнешнийИдентификатор.Имя;
	Возврат УстановитьСвойствоОбъекта(Объект, ИмяСвойства, Значение);	

КонецФункции // УстановитьВнешнийИдентификаторОбъекта()


//
////// Служебные процедуры и функции
//

Функция ПолучитьСвойствоОбъекта(Объект,ИмяСвойства)

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УСЗ_СвойстваОбъектов.%ИмяСвойства% Как Свойство
		|ИЗ
		|	РегистрСведений.УСЗ_СвойстваОбъектов КАК УСЗ_СвойстваОбъектов
		|ГДЕ
		|	УСЗ_СвойстваОбъектов.Объект = &Объект";

	Запрос.УстановитьПараметр("Объект", Объект);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ИмяСвойства%", ИмяСвойства);
	
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Свойство;
	КонецЦикла;

	Возврат Неопределено;	

КонецФункции // ПолучитьСвойствоОбъекта()
 
Функция УстановитьСвойствоОбъекта(Объект, ИмяСвойства, Значение)

	Значение = Строка(Значение);
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
	
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УСЗ_СвойстваОбъектов");
		ЭлементБлокировки.УстановитьЗначение("Объект", Объект);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	УСЗ_СвойстваОбъектов.Объект";
		
		Для каждого Ресурс Из Метаданные.РегистрыСведений.УСЗ_СвойстваОбъектов.Ресурсы Цикл
			
			Запрос.Текст = Запрос.Текст + "
			|	,УСЗ_СвойстваОбъектов."+Ресурс.Имя;	
			
		КонецЦикла; 
		
		Для каждого Реквизит Из Метаданные.РегистрыСведений.УСЗ_СвойстваОбъектов.Реквизиты Цикл
			
			Запрос.Текст = Запрос.Текст + "
			|	,УСЗ_СвойстваОбъектов."+Реквизит.Имя;	
			
		КонецЦикла;
		
		Запрос.Текст = Запрос.Текст + "
		|ИЗ
		|	РегистрСведений.УСЗ_СвойстваОбъектов КАК УСЗ_СвойстваОбъектов
		|ГДЕ
		|	УСЗ_СвойстваОбъектов.Объект = &Объект";
		
		Запрос.УстановитьПараметр("Объект", Объект);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		НаборЗаписей = РегистрыСведений.УСЗ_СвойстваОбъектов.СоздатьМенеджерЗаписи();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(НаборЗаписей,НаборЗаписей,,"Объект");
		КонецЕсли;
		
		НаборЗаписей.Объект = Объект;
		НаборЗаписей[ИмяСвойства] = Значение;
		НаборЗаписей.Записать(Истина);
		
		ЗафиксироватьТранзакцию();
	
	Исключение
		
		Если ТранзакцияАктивна() Тогда
			
			ОтменитьТранзакцию();
			Возврат Ложь;
		
		КонецЕсли; 
		
	КонецПопытки; 
	
	//Установка свойство прошло успешно
	Возврат Истина;	

КонецФункции // ПолучитьСвойствоОбъекта()
