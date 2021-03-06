﻿
Функция ПолучитьДатуНачалаАвтонумерацииДокументов() Экспорт

	Возврат '20140806000000';

КонецФункции // ПолучитьДатуНачалаАвтонумерацииДокументов()


Функция ПолучитьНовыйНомер(Префикс) Экспорт

	Нумератор = Справочники.ПРГ_ВидыНумераторов.НайтиПоРеквизиту("Префикс", Префикс);
	
	Нумерация = РегистрыСведений.ПРГ_НумерацияОбъектов.СоздатьМенеджерЗаписи();
	Нумерация.Нумератор = Нумератор;
	Нумерация.Прочитать();
	
	НовыйНомер = Нумерация.Номер + 1;
	
	Возврат Формат(НовыйНомер, "ЧГ=0");

КонецФункции // ()


Функция ЗаписатьНовыйНомер(Префикс, НовыйНомер) Экспорт

	Нумератор = Справочники.ПРГ_ВидыНумераторов.НайтиПоРеквизиту("Префикс", Префикс);
	
	Нумерация = РегистрыСведений.ПРГ_НумерацияОбъектов.СоздатьМенеджерЗаписи();
	Нумерация.Нумератор = Нумератор;
	Нумерация.Номер = НовыйНомер;
	Нумерация.Записать();

КонецФункции // ЗаписатьНовыйНомер()
 