﻿
&НаСервере
Процедура ЗаполнитьНаСервере()
	
	КонтролируемыеСделки.ЗаполнитьГраницыКонтролируемости();
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьЗначениямиПоУмолчанию(Команда)
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры
