﻿
&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	//сообщить(1);
	стр=Элементы.Сотрудники.ТекущиеДанные;
	если не ЗначениеЗаполнено(стр.ВидИспользованияРабочегоВремени) тогда
		стр.ВидИспользованияРабочегоВремени=Справочники.КлассификаторИспользованияРабочегоВремени.Работа;
	Конецесли;	
КонецПроцедуры
