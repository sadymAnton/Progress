﻿
// Обработчик обновления БЭД 1.1.9.1
// Заполняет дату окончания действия сертификата
//
Процедура ЗаполнитьСрокДействия() Экспорт
	
	Сертификаты = Справочники.СертификатыЭЦП.Выбрать();
	
	Пока Сертификаты.Следующий() Цикл
		
		Попытка
			Сертификат = Сертификаты.ПолучитьОбъект();
			ДанныеСертификата = Сертификат.ФайлСертификата.Получить();
			СертификатКриптографии = Новый СертификатКриптографии(ДанныеСертификата);
			Сертификат.ДатаОкончания = СертификатКриптографии.ДатаОкончания;
			Сертификат.Записать();
		Исключение
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры
