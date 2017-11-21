﻿&НаСервере
Перем ОбработкаОбъект;
Перем ОснМодуль;

&НаСервере
//инициализация модуля и его экспортных функций
Функция МодульОбъекта()

	Если ОбработкаОбъект=Неопределено Тогда
		
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		ОбработкаОбъект.Инициализировать(ОсновнойМодуль());
				
	КонецЕсли;	
	
	Возврат ОбработкаОбъект;
	
КонецФункции

&НаСервере
Функция ОсновнойМодуль()
	Если ОснМодуль = Неопределено Тогда
		ОснМодуль = ПолучитьИзВременногоХранилища(Параметры.АдресХранилища).ОбработкаОбъект;
	КонецЕсли;
	Возврат ОснМодуль;
КонецФункции

&НаКлиенте
Процедура ПредупреждениеМеркурий_Оповещение(Парам1, Парам2) Экспорт
КонецПроцедуры

&НаКлиенте
Процедура ПредупреждениеМеркурий(ТекстПредупреждения)
	
	Если СокрЛП(ТекстПредупреждения) = "" Тогда
		Возврат;
	КонецЕсли;
	
	Кнопки = новый СписокЗначений;
	Кнопки.Добавить("Всё понятно.");
	
	Если Параметры.МодальностьЗапрещена Тогда
		Выполнить("ПоказатьВопрос(Новый ОписаниеОповещения(""ПредупреждениеМеркурий_Оповещение"",ЭтаФорма),ТекстПредупреждения,Кнопки,,,""Контур.Меркурий"")");
	Иначе
		Вопрос(ТекстПредупреждения, Кнопки,,,"Контур.Меркурий");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УдалитьСвязьНаСервере(хсGUID,площадкаGUID)
	Возврат МодульОбъекта().УдалитьСвязьПлощадкиСХС(хсGUID,площадкаGUID);
КонецФункции

&НаКлиенте
Процедура УдалитьСвязь(Команда)
	
	ТекСтрока = Элементы.ПривязанныеПлощадки.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекСтрока.GUID) И ЗначениеЗаполнено(GUID) Тогда
		РезультатУдаленияСвязи = УдалитьСвязьНаСервере(GUID,ТекСтрока.GUID);
		Если РезультатУдаленияСвязи.Успешно = Истина Тогда
			ПредупреждениеМеркурий("Успешно отвязал!");
		Иначе
			ПредупреждениеМеркурий("НЕ удалось отвязать! "+РезультатУдаленияСвязи.ОписаниеОшибки);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоляФормы()
	
	Если НЕ Наш Тогда
		Элементы.ПривязанныеПлощадкиУдалитьСвязь.Доступность = Ложь;
		Элементы.ПривязанныеПлощадкиСвязатьСПлощадкой.Доступность = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаСведенияХС.Заголовок = Элементы.ГруппаСведенияХС.Заголовок + ?(Наш=Истина," (НАШ)"," (СТОРОННИЙ)");
	
	СписокХС = МодульОбъекта().ПолучитьХСПоGUID(GUID);
	
	Если СписокХС.Количество() = 1 Тогда
		
		Наименование	= СписокХС[0].name;
		Если Не ЗначениеЗаполнено(Наименование) И ЗначениеЗаполнено(СписокХС[0].fio) тогда
			Наименование	= СписокХС[0].fio;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Наименование) И ЗначениеЗаполнено(СписокХС[0].fullName) тогда
			Наименование	= СписокХС[0].fullName;
		КонецЕсли;
		ИНН 	= СписокХС[0].inn;
		Адрес 	= СписокХС[0].Адрес;
		ОГРН 	= СписокХС[0].ogrn;
	Иначе
		//Предупреждение("Переданный GUID не найден в Меркурии! Убедитесь что он верный. В крайнем случае удалите сопоставление и установите вновь.");
	КонецЕсли;
	
	//Связанные Площадки
	ЗаполнитьПлощадки(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПлощадки(Обновить = Ложь)
	
    ПривязанныеПлощадки.Очистить();
	
	ТаблицаНайденных = МодульОбъекта().ПолучитьСписокПредприятийПоGUID(GUID,Обновить);
	Если ТаблицаНайденных <> неопределено Тогда
		ТаблицаСопоставленныхПредприятий = МодульОбъекта().ПолучитьСписокЭлементовСправочникаМеркурий("МеркурийПлощадка", Неопределено);
		
		Для Каждого СвязаннаяПлощадка Из ТаблицаНайденных Цикл
			НоваяСтрокаПлощадки = ПривязанныеПлощадки.Добавить();
			НоваяСтрокаПлощадки.GUID =  СвязаннаяПлощадка.guid;
			НоваяСтрокаПлощадки.Наименование =  СвязаннаяПлощадка.name;
			НоваяСтрокаПлощадки.Адрес =  СвязаннаяПлощадка.Адрес;
			
			//наши соответствия
			НайденныйОбъект1С = ТаблицаСопоставленныхПредприятий.Найти(СвязаннаяПлощадка.guid,"GUID");
			Если ЗначениеЗаполнено(НайденныйОбъект1С) Тогда 
				НоваяСтрокаПлощадки.Объект1С = НайденныйОбъект1С.СвязанныйСправочник;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ПривязанныеПлощадки.Сортировать("Объект1С Убыв");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	GUID = Параметры.GUID;
	Объект1С = Параметры.Объект1С;
	Наш = Параметры.Наш;	
	ЗаполнитьПоляФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не ЗначениеЗаполнено(GUID) Тогда
		ПредупреждениеМеркурий("Переданный GUID не найден в Меркурии! Убедитесь что он верный. В крайнем случае удалите сопоставление и установите вновь.");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Перечитать(Команда)
	ЗаполнитьПлощадки(Истина);
КонецПроцедуры

&НаСервере
Функция СвязатьПлощадкуСХСНаСервере(ХСВладелецGUID,ПлощадкаGUID)
	Возврат МодульОбъекта().СвязатьПлощадкуСХС(ХСВладелецGUID,ПлощадкаGUID);
КонецФункции

&НаКлиенте
Процедура ОбработчикВыбораХС(ВыбраннаяСтрока, НеиспользуемыйПараметр = Неопределено) Экспорт
	
	Если ВыбраннаяСтрока = неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ПлощадкаGUID = ВыбраннаяСтрока.GUID;
	ХСВладелецGUID = GUID;
		
	Если ЗначениеЗаполнено(ПлощадкаGUID) И ЗначениеЗаполнено(ХСВладелецGUID) ТОгда
		РезультатУстановкиСвязи = СвязатьПлощадкуСХСНаСервере(ХСВладелецGUID,ПлощадкаGUID);
		Если РезультатУстановкиСвязи.Успешно = Истина Тогда
			ПредупреждениеМеркурий("Удалось связать!");
			ЗаполнитьПлощадки(истина);
		Иначе
			ПредупреждениеМеркурий("НЕ удалось связать! "+РезультатУстановкиСвязи.ОписаниеОшибки);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СвязатьСПлощадкой(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВариантПоиска", 4);//без фильтров
	ПараметрыФормы.Вставить("АдресХранилища", Параметры.АдресХранилища);
		
	Если Параметры.МодальностьЗапрещена Тогда 
		Выполнить("ОткрытьФорму(Параметры.ПутьКФормамМеркурий+""Меркурий_ВыборХСПлощадкиУправляемая"", ПараметрыФормы, ЭтаФорма,,,,Новый ОписаниеОповещения(""ОбработчикВыбораХС"", ЭтаФорма))");
	Иначе
		ВыбраннаяСтрока = ПолучитьФорму(Параметры.ПутьКФормамМеркурий+"Меркурий_ВыборХСПлощадкиУправляемая",ПараметрыФормы,ЭтаФорма).ОткрытьМодально();
		ОбработчикВыбораХС(ВыбраннаяСтрока, Неопределено);
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ПривязанныеПлощадкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры


&НаКлиенте
Процедура ПривязанныеПлощадкиПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикВыбораПлощадки(ВыбраннаяСтрока, НеиспользуемыйПараметр = Неопределено) Экспорт
	//ЗаполнитьПлощадки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПривязанныеПлощадкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	текСтрока = Элементы.ПривязанныеПлощадки.ТекущиеДанные;
	//открыть карточку
	ПараметрыФормы = Новый Структура("Объект1С,GUID,ТипОбъекта,ХСВладелец,ХСВладелецGUID,Наш,АдресХранилища,МодальностьЗапрещена,КэшироватьМодульОбъекта",
	текСтрока.Объект1С,текСтрока.GUID,"Площадка",Объект1С,GUID, Наш, Параметры.АдресХранилища, Параметры.МодальностьЗапрещена, Истина);
	
	Если Параметры.МодальностьЗапрещена Тогда 
		Выполнить("ОткрытьФорму(Параметры.ПутьКФормамМеркурий+""Меркурий_ХС_ПлощадкаУправляемая"", ПараметрыФормы, ЭтаФорма,,,,Новый ОписаниеОповещения(""ОбработчикВыбораПлощадки"", ЭтаФорма))");
	Иначе
		ВыбСтрока = ПолучитьФорму(Параметры.ПутьКФормамМеркурий+"Меркурий_ХС_ПлощадкаУправляемая",ПараметрыФормы,ЭтаФорма).ОткрытьМодально();
		ОбработчикВыбораПлощадки(ВыбСтрока, Неопределено);
	КонецЕсли;

КонецПроцедуры

