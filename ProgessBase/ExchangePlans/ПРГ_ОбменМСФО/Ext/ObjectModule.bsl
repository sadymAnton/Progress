﻿Процедура ПриОтправкеДанныхГлавному(ЭлементДанных, ОтправкаЭлемента)
		//Главный узел - рабочая база, подчиненый узел - МСФО
		//Из базы МСФО не передаем никаких данных, она живет своей жизнью
		//главному ничего не отправляем	
		
		ОтправкаЭлемента = ОтправкаЭлементаДанных.Игнорировать;

	
КонецПроцедуры

Процедура ПриОтправкеДанныхПодчиненному(ЭлементДанных, ОтправкаЭлемента, СозданиеНачальногоОбраза)
	
		
КонецПроцедуры

