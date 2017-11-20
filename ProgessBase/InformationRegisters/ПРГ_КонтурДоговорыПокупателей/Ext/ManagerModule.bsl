﻿
Функция ДоговорПартнера(ДатаЗапроса, Партнер, Контрагент) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	1 КАК Приоритет,
	|	ПРГ_КонтурДоговорыПокупателейСрезПоследних.Договор
	|ИЗ
	|	РегистрСведений.ПРГ_КонтурДоговорыПокупателей.СрезПоследних(
	|			&ДатаЗапроса,
	|			Партнер = &Партнер
	|				И Контрагент = &Контрагент
	|				И Пользователь = &Пользователь) КАК ПРГ_КонтурДоговорыПокупателейСрезПоследних
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2,
	|	ПРГ_КонтурДоговорыПокупателейСрезПоследних.Договор
	|ИЗ
	|	РегистрСведений.ПРГ_КонтурДоговорыПокупателей.СрезПоследних(
	|			&ДатаЗапроса,
	|			Партнер = &Партнер
	|				И Контрагент = &ПустойКонтрагент
	|				И Пользователь = &Пользователь) КАК ПРГ_КонтурДоговорыПокупателейСрезПоследних
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	3,
	|	ПРГ_КонтурДоговорыПокупателейСрезПоследних.Договор
	|ИЗ
	|	РегистрСведений.ПРГ_КонтурДоговорыПокупателей.СрезПоследних(
	|			&ДатаЗапроса,
	|			Партнер = &Партнер
	|				И Контрагент = &ПустойКонтрагент
	|				И Пользователь = &ПустойПользователь) КАК ПРГ_КонтурДоговорыПокупателейСрезПоследних
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет");
	
	Запрос.УстановитьПараметр("ДатаЗапроса", 		ДатаЗапроса);
	Запрос.УстановитьПараметр("Партнер", 			Партнер);
	Запрос.УстановитьПараметр("Контрагент", 		Контрагент);
	Запрос.УстановитьПараметр("Пользователь", 		ПараметрыСеанса.ТекущийПользователь);
	Запрос.УстановитьПараметр("ПустойКонтрагент",	Справочники.Контрагенты.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустойПользователь",	Справочники.Пользователи.ПустаяСсылка());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Договор;
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


Процедура УстановитьДоговорПартнера(ДатаУстановки, Партнер, Контрагент, ДоговорКонтрагента) Экспорт
	
	НоваяЗапись 				= РегистрыСведений.ПРГ_КонтурДоговорыПокупателей.СоздатьМенеджерЗаписи();
	НоваяЗапись.Период 			= ДатаУстановки;
	НоваяЗапись.Партнер 		= Партнер;
	НоваяЗапись.Контрагент		= Контрагент;
	НоваяЗапись.Пользователь 	= ПараметрыСеанса.ТекущийПользователь;
	НоваяЗапись.Договор 		= ДоговорКонтрагента;
	
	НоваяЗапись.Записать();
	
КонецПроцедуры
