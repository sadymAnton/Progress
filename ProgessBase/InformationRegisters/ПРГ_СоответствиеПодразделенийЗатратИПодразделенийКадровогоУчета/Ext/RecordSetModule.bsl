﻿
Процедура ПередЗаписью(Отказ, Замещение)
	// Вставить содержимое обработчика.
	Если Не (РольДоступна("НастройкаНСИЗатрат")
		 или РольДоступна("КадровикРегламентированныхДанных")
		 или РольДоступна("КадровикУправленческихДанных")
		 или РольДоступна("РасчетчикУправленческойЗарплаты")
		 или РольДоступна("РасчетчикРегламентированнойЗарплаты") 
		 или РольДоступна("НастройкаНСИРегл") 
		 или РольДоступна("ПолныеПрава"))
	 Тогда
	    ОбщегоНазначения.СообщитьОбОшибке("Не достаточно прав доступа !!",Отказ);
	 КонецЕсли;
	 
КонецПроцедуры
