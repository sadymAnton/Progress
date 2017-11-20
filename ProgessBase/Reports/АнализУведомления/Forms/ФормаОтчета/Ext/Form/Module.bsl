﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРасшифровки(Элемент, ИмяПоля)
	
	Если ТипЗнч(Элемент) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Поле = Элемент.ПолучитьПоля().Найти(ИмяПоля);
		Если Поле <> Неопределено Тогда
			Возврат(Поле.Значение);
		КонецЕсли;
	КонецЕсли;
	
	Родители  = Элемент.ПолучитьРодителей();
	Если Родители.Количество()>0 Тогда
		Возврат(ПолучитьЗначениеРасшифровки(Родители[0], ИмяПоля));
	КонецЕсли;
	
    Возврат(Неопределено);
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеРасшифровки(Расшифровка, СтруктураПолей)
	
	Данные_Расшифровки = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	
	СтруктураДанных = Новый Структура();
	
	Если Данные_Расшифровки <> Неопределено Тогда
		Для каждого ЭлементДанных Из СтруктураПолей Цикл
			Родитель = Данные_Расшифровки.Элементы[Расшифровка];
			ЗначениеРасшифровки = ПолучитьЗначениеРасшифровки(Родитель, ЭлементДанных.Ключ);
			Если ЗначениеРасшифровки <> Неопределено Тогда
				СтруктураДанных.Вставить(ЭлементДанных.Ключ, ЗначениеРасшифровки);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат СтруктураДанных;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрУведомление(Отчет)
	
	Настройки = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки;
	Для Каждого Элемент Из Настройки.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
			И Элемент.Параметр = Новый ПараметрКомпоновкиДанных("Уведомление") Тогда
			Элемент.Значение = Отчет.Уведомление;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НайтиУведомление(ТипПоиска)
	
	Если Не ЗначениеЗаполнено(Отчет.ОтчетныйГод) Тогда 
		Отчет.ОтчетныйГод = Год(ТекущаяДата());
	КонецЕсли;
	Если ЗначениеЗаполнено(Отчет.Организация) Тогда
		
		НайденноеУведомление = КонтролируемыеСделки.НайтиУведомлениеОрганизацииВОтчетномГоду(Отчет.Организация,Отчет.ОтчетныйГод,ЭтаФорма.ТипУведомления,ЭтаФорма.НомерКорректировки,ТипПоиска);
		
		Если НайденноеУведомление <> Неопределено Тогда
			Отчет.Уведомление = НайденноеУведомление;
		ИначеЕсли ЗначениеЗаполнено(Отчет.Уведомление) Тогда
			Если Отчет.Уведомление.Организация = Отчет.Организация Тогда
				НомерКорректировки = Отчет.Уведомление.НомерКорректировки;
				ТипУведомления = ?(НомерКорректировки = 0,0,1);
				Отчет.ОтчетныйГод = Год(Отчет.Уведомление.ОтчетныйГод);
			Иначе
				Отчет.Уведомление = Неопределено;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Отчет.Уведомление = Неопределено;	
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Отчет.Уведомление) И ЗначениеЗаполнено(Отчет.Организация) Тогда
		Элементы.ДекорацияУведомлениеНеНайдено.Заголовок = "За " + Формат(Отчет.ОтчетныйГод,"ЧГ=") + " год у " + Отчет.Организация.НаименованиеСокращенное + " нет уведомлений";	
	Иначе
		Элементы.ДекорацияУведомлениеНеНайдено.Заголовок = "";
	КонецЕсли;
	ЭтаФорма.Элементы.НомерКорректировки.Доступность = ТипУведомления <> 0;
	УстановитьПараметрУведомление(Отчет);	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
//

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	НайтиУведомление("Последний");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйГодПриИзменении(Элемент)
	
	НомерКорректировки = 0;
	НайтиУведомление("Последний");
	
КонецПроцедуры

&НаКлиенте
Процедура ТипУведомленияПриИзменении(Элемент)
	
	Если ТипУведомления = 0 Тогда
		НомерКорректировки = 0;
		НайтиУведомление("Указанный");
	Иначе
		НайтиУведомление("Последний");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НомерКорректировкиРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	НомерКорректировки = НомерКорректировки + Направление;
	НайтиУведомление(?(Направление > 0,"Следующий","Предыдущий"));
	
КонецПроцедуры

&НаКлиенте
Процедура НомерКорректировкиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	НомерКорректировки = Число(Текст);
	НайтиУведомление("Указанный");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(Отчет, Параметры);
	
	Если ЗначениеЗаполнено(Отчет.Уведомление) Тогда
		Отчет.Организация = Отчет.Уведомление.Организация;
		Отчет.ОтчетныйГод = Год(Отчет.Уведомление.ОтчетныйГод);
		НомерКорректировки = Отчет.Уведомление.НомерКорректировки;
		ТипУведомления = ?(НомерКорректировки = 0,0,1);
		ЭтаФорма.Элементы.НомерКорректировки.Доступность = ТипУведомления <> 0;
	Конецесли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Уведомление").Значение = Отчет.Уведомление;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Документ", );
	СтруктураДанных.Вставить("НомерСтроки", );
	ЗначенияПолейРасшифровки = ПолучитьДанныеРасшифровки(Расшифровка, СтруктураДанных);
	
	Если ЗначенияПолейРасшифровки.Свойство("Документ") Тогда
	СтандартнаяОбработка     = Ложь;
		Форма = ПолучитьФорму("Документ.КонтролируемаяСделка.ФормаОбъекта",Новый Структура("Ключ",ЗначенияПолейРасшифровки.Документ));
		Форма.Открыть();
		
		Если ЗначенияПолейРасшифровки.Свойство("НомерСтроки") Тогда
			Форма.ТекущийЭлемент = Форма.Элементы.Сделки;
			Форма.ТекущийЭлемент.ТекущаяСтрока = ЗначенияПолейРасшифровки.НомерСтроки - 1;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПередЗагрузкойПользовательскихНастроекНаСервере(Настройки)
	
	УстановитьПараметрУведомление(Отчет);
	
КонецПроцедуры




