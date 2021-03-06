﻿///Вадим 28.01.2013 13:30:24
&НаСервере
Процедура УправлениеОтображением()
	Элементы.Показатели.Видимость=Объект.ТипИнформации=1;
	Элементы.Табель.Видимость=Объект.ТипИнформации=0;
	

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеОтображением();
КонецПроцедуры

&НаКлиенте
Процедура ТипИнформацииПриИзменении(Элемент)
	УправлениеОтображением();

КонецПроцедуры

&НаСервере
/////Вадим 28.01.2013 14:25:25
Функция  ЗаполнитьСтрокуПоРабочемуВремениСотрудника(Сотрудник)
  	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РабочееВремяРаботниковОрганизаций.Период,
		|	СУММА(РабочееВремяРаботниковОрганизаций.Дней) КАК Дней,
		|	СУММА(РабочееВремяРаботниковОрганизаций.Часов) КАК Часов
		|ИЗ
		|	РегистрНакопления.РабочееВремяРаботниковОрганизаций КАК РабочееВремяРаботниковОрганизаций
		|ГДЕ
		|	РабочееВремяРаботниковОрганизаций.Сотрудник = &Сотрудник
		|	И РабочееВремяРаботниковОрганизаций.Период МЕЖДУ &Нач И &Кон
		|	И РабочееВремяРаботниковОрганизаций.ВидИспользованияРабочегоВремени.РабочееВремя
		|
		|СГРУППИРОВАТЬ ПО
		|	РабочееВремяРаботниковОрганизаций.Период";

	Запрос.УстановитьПараметр("Кон", КонецМесяца(Объект.Период));
	Запрос.УстановитьПараметр("Нач", НачалоМесяца(Объект.Период));
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);

	Результат = Запрос.Выполнить();

	//ВыборкаДетальныеЗаписи = Результат.Выбрать();

	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

	//КонецЦикла;

	возврат  Результат.Выгрузить();
КонецФункции
//ВадимКонец


&НаКлиенте
Процедура ТабельСотрудникПриИзменении(Элемент)
	стрДанные=Элементы.Табель.ТекущиеДанные;
	тз=ЗаполнитьСтрокуПоРабочемуВремениСотрудника(стрДанные.сотрудник);
	Для каждого стр Из тз Цикл
		стрДанные["Д"+День(стр.Период)]=стр.Часов;
		
	
	КонецЦикла;
КонецПроцедуры
//ВадимКонец

