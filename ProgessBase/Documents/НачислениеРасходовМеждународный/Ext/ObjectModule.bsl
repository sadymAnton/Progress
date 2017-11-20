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

	Для Каждого ТекСтрокаСостав Из Состав Цикл
		//Движение = Движения.Международный.Добавить();
		//Движение.Период = Дата;
		//Движение.СчетДт = ТекСтрокаСостав.Счет;
		//Движение.СчетКт = ПланыСчетов.Международный.НачисленныеРасходы;
		//Движение.Организация = Организация;
		//Движение.Сумма = ТекСтрокаСостав.Сумма;
		//Движение.Содержание = ТекСтрокаСостав.СодержаниеОперации;
		//Движение.НомерЖурнала = "Рег";
		//
		//Для Ном = 1 по Движение.СчетДт.ВидыСубконто.Количество() Цикл
		//	Движение.СубконтоДт[Движение.СчетДт.ВидыСубконто[Ном-1].ВидСубконто] = ТекСтрокаСостав["Субконто" + Ном];
		//КонецЦикла;

		//Если РеверсированиеРасходов Тогда
		//	Движение = Движения.Международный.Добавить();
		//	Движение.Период = ДатаНачисленияРеверсированныхРасходов;
		//	Движение.СчетКт = ПланыСчетов.Международный.НачисленныеРасходы;
		//	Движение.СчетДт = ТекСтрокаСостав.Счет;
		//	Движение.Организация = Организация;
		//	Движение.Сумма = -ТекСтрокаСостав.Сумма;
		//	Движение.Содержание = ТекСтрокаСостав.СодержаниеОперации;
		//	Движение.НомерЖурнала = "Рег";
		//	
		//	Для Ном = 1 по Движение.СчетДт.ВидыСубконто.Количество() Цикл
		//		Движение.СубконтоДт[Движение.СчетДт.ВидыСубконто[Ном-1].ВидСубконто] = ТекСтрокаСостав["Субконто" + Ном];
		//	КонецЦикла;
		//КонецЕсли;
		
		//удалить нерабочий(в следствие доработок) типовой функционал

		//начало изменений ДС МСФО 03.12.2013
		//Если (ТекСтрокаСостав.Счет = ПланыСчетов.Международный.ОсновноеПроизводство) или (ТекСтрокаСостав.Счет = ПланыСчетов.Международный.ВспомогательноеПроизводство) Тогда
		Если (ТекСтрокаСостав.Счет = ПланыСчетов.Международный.ОсновноеПроизводство) Тогда
			//конец изменений ДС МСФО 03.12.2013
			Если ЗначениеЗаполнено(ТекСтрокаСостав.Субконто1) Тогда
				// регистр НезавершенноеПроизводствоМеждународныйУчет Приход
				Движение = Движения.НезавершенноеПроизводствоМеждународныйУчет.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
				Движение.Период = Дата;
				Движение.Организация = Организация;
				Движение.Подразделение = ТекСтрокаСостав.Субконто3;
				Движение.СтатьяЗатрат = ТекСтрокаСостав.Субконто2;
				Движение.НоменклатурнаяГруппа = ТекСтрокаСостав.Субконто1;
				Движение.Заказ = ТекСтрокаСостав.Заказ;
				Движение.Стоимость = ТекСтрокаСостав.Сумма;

				Если РеверсированиеРасходов Тогда
					Движение = Движения.НезавершенноеПроизводствоМеждународныйУчет.Добавить();
					Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
					Движение.Период = ДатаНачисленияРеверсированныхРасходов;
					Движение.Организация = Организация;
					Движение.Подразделение = ТекСтрокаСостав.Субконто3;
					Движение.СтатьяЗатрат = ТекСтрокаСостав.Субконто2;
					Движение.НоменклатурнаяГруппа = ТекСтрокаСостав.Субконто1;
					Движение.Заказ = ТекСтрокаСостав.Заказ;
					Движение.Стоимость = ТекСтрокаСостав.Сумма;	
				КонецЕсли;
			
			КонецЕсли;
		КонецЕсли;
		
		Если (ТекСтрокаСостав.Счет = ПланыСчетов.Международный.ОбщепроизводственныеРасходы) Тогда
			// регистр ЗатратыМеждународныйУчет Приход
			Движение = Движения.ЗатратыМеждународныйУчет.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.СчетУчета   = ТекСтрокаСостав.Счет;
			Движение.Период = Дата;
			Движение.Организация = Организация;
			Движение.Подразделение = ТекСтрокаСостав.Субконто2;
			Движение.СтатьяЗатрат = ТекСтрокаСостав.Субконто1;
			Движение.Заказ = ТекСтрокаСостав.Заказ;
			Движение.Сумма = ТекСтрокаСостав.Сумма;
        			
			Если РеверсированиеРасходов Тогда
				Движение = Движения.ЗатратыМеждународныйУчет.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = ДатаНачисленияРеверсированныхРасходов;
				Движение.Организация = Организация;
				Движение.Подразделение = ТекСтрокаСостав.Субконто2;
				Движение.СтатьяЗатрат = ТекСтрокаСостав.Субконто1;
				Движение.Заказ = ТекСтрокаСостав.Заказ;
				Движение.Сумма = ТекСтрокаСостав.Сумма;
			КонецЕсли;
		КонецЕсли;
		
		//начало изменений ДС МСФО 11.12.2013
		Движение = Движения.Международный.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, ТекСтрокаСостав);
		Движение.Период = Дата;
		Движение.СчетДт = ТекСтрокаСостав.Счет;
		Движение.Организация = Организация;
		Движение.Содержание = ТекСтрокаСостав.СодержаниеОперации; 
		Движение.Сумма = - ТекСтрокаСостав.Сумма;
		БухгалтерскийУчет.УстановитьСубконто(ТекСтрокаСостав.Счет, Движение.СубконтоДт, 1, ТекСтрокаСостав.Субконто1);
		БухгалтерскийУчет.УстановитьСубконто(ТекСтрокаСостав.Счет, Движение.СубконтоДт, 2, ТекСтрокаСостав.Субконто2);
		БухгалтерскийУчет.УстановитьСубконто(ТекСтрокаСостав.Счет, Движение.СубконтоДт, 3, ТекСтрокаСостав.Субконто3);
		БухгалтерскийУчет.УстановитьСубконто(ТекСтрокаСостав.СчетКт, Движение.СубконтоКт, 1, ТекСтрокаСостав.СубконтоКт1);
		БухгалтерскийУчет.УстановитьСубконто(ТекСтрокаСостав.СчетКт, Движение.СубконтоКт, 2, ТекСтрокаСостав.СубконтоКт2);
		БухгалтерскийУчет.УстановитьСубконто(ТекСтрокаСостав.СчетКт, Движение.СубконтоКт, 3, ТекСтрокаСостав.СубконтоКт3);

	КонецЦикла;
	
	

	// записываем движения регистров
	Движения.Международный.Записать();
	Движения.НезавершенноеПроизводствоМеждународныйУчет.Записать();
	Движения.ЗатратыМеждународныйУчет.Записать();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью




