﻿Перем ИнтеграционнаяОбработка;
Перем контекстПрограммныхМодулей;
Перем ПрофильКонфигурации;

Перем КонтекстРаботаССерверомДиадок;
Перем Контекст1САдаптерКонфигурации;
Перем КонтекстОрганизации;

Перем КэшПараметровДополнительныхВПФ;
Перем КэшДополнительныхВПФ;

Перем НаименованиеСистемы Экспорт;
Перем КраткоеНаименованиеСистемы Экспорт;
Перем КраткоеНаименованиеСистемыПредложныйПадеж Экспорт;
Перем ТелефонТехПоддержки Экспорт;
Перем ТочкаВходаВеб Экспорт; 
Перем ВерсияОбработки Экспорт;
Перем ИспользоватьИконкуСистемы Экспорт;

Перем Модуль_ИнтеграцияОбщий Экспорт;
Перем Модуль_ЗаполнениеКонтента Экспорт;
Перем Модуль_Интеграция Экспорт;

Функция ПриОкончанииРаботыМодуля() Экспорт
	
	ИнтеграционнаяОбработка=		Неопределено;
	КонтекстПрограммныхМодулей=		Неопределено;
	ПрофильКонфигурации=			Неопределено;
	КонтекстРаботаССерверомДиадок=	Неопределено;
	Контекст1САдаптерКонфигурации=	Неопределено;
	КонтекстОрганизации=			Неопределено;
	
	Модуль_ИнтеграцияОбщий=			Неопределено;
	Модуль_ЗаполнениеКонтента=		Неопределено;
	Модуль_Интеграция=				Неопределено;
	
КонецФункции

Функция ИнициализироватьВнешнююКомпоненту() Экспорт
	Возврат ПолучитьФорму("Модуль_РаботаССерверомДиадок").ИнициализироватьВК(КонтекстРаботаССерверомДиадок);
КонецФункции

Функция ИнициализироватьМодули() Экспорт
	
	Модуль_ИнтеграцияОбщий=		ПолучитьМодульПрог("Модуль_ИнтеграцияОбщий");
	Модуль_ЗаполнениеКонтента=	ПолучитьМодульПрог("Модуль_ЗаполнениеКонтента");
	Модуль_Интеграция=			ПолучитьМодульПрог(ИмяФормыПрикладногорешенияДляИнтеграцииДиадок());
	
	Возврат Истина;
	
КонецФункции

Функция УспешноВыполненаИнициализация(ОрганизацияСсылка = Неопределено, логин = Неопределено, пароль = Неопределено) Экспорт
	
	Если НЕ ЗаполнитьПрофильКонфигурации() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ПолучитьФорму("Модуль_1САдаптер").Инициализировать(Контекст1САдаптерКонфигурации) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ПолучитьФорму("Модуль_РаботаССерверомДиадок").Инициализировать(КонтекстРаботаССерверомДиадок, ОрганизацияСсылка, Логин, пароль) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ПолучитьФорму("Модуль_Организации").Инициализировать(КонтекстОрганизации) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ИнициализироватьМодули() = Ложь Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьМодульПрог(ИмяМодуля) Экспорт 
	Если ЗначениеЗаполнено(КонтекстПрограммныхМодулей)=Ложь Тогда 
		КонтекстПрограммныхМодулей = Новый соответствие;
	КонецЕсли;
	
	ЗначКэша = КонтекстПрограммныхМодулей.Получить(ИмяМодуля);
	Если ЗначКэша = Неопределено Тогда 
		ФормаМодуля = ПолучитьФорму(ИмяМодуля);
		КонтекстПрограммныхМодулей.Вставить(ИмяМодуля, формаМодуля);
	Иначе 
		ФормаМодуля = ЗначКэша
	КонецЕсли;
	
	Возврат   ФормаМодуля
	
КонецФункции

Функция ИдентификаторСвойстваИдентификаторДокументаВДиадок()
	Возврат "ИдентификаторДокументаВДиадок"
КонецФункции 

Функция ЭтоСчетФактура(ТипДокумента) Экспорт
	Возврат ?(ТипДокумента="Invoice", Истина, Ложь);
КонецФункции

Функция ЭтоВходящийДокЕщеБезПодписиИОтказа(СтатусДокумента) Экспорт
	Возврат ?(СтатусДокумента="InboundWaitingForRecipientSignature", Истина, Ложь);	
КонецФункции

Функция ЭтоФормализованныйТОРГ12(ТипДокумента) Экспорт
	Возврат ?(ТипДокумента="XmlTorg12", Истина, Ложь);
КонецФункции

Функция ЭтоФормализованныйАктОВыполненииРабот(ТипДокумента) Экспорт
	Возврат ?(ТипДокумента="XmlAcceptanceCertificate", Истина, Ложь);
КонецФункции

///////////////////////////////////////////////////////////////////
//{ ДОПОЛНИТЕЛЬНЫЕ ПЕЧАТНЫЕ ФОРМЫ
	
	Функция ПолучитьПараметрыДополнительныхВПФ(ВнешняяПечатнаяФорма) Экспорт
		
		Если ЗначениеЗаполнено(КэшПараметровДополнительныхВПФ) = Ложь Тогда
			КэшПараметровДополнительныхВПФ = Новый Соответствие;
		КонецЕсли;
		
		ЗначКэша = КэшПараметровДополнительныхВПФ.Получить(ВнешняяПечатнаяФорма);
		Если ЗначКэша = Неопределено Тогда
			КэшПараметровДополнительныхВПФ.Вставить(ВнешняяПечатнаяФорма, Неопределено);
		КонецЕсли;
		
		Возврат ЗначКэша;
		
	КонецФункции
	
	Процедура ЗаписатьПараметрыДополнительныхВПФ(ВнешняяПечатнаяФорма, ДополнительныеПараметры) Экспорт
		
		Если ЗначениеЗаполнено(КэшПараметровДополнительныхВПФ) = Ложь Тогда
			КэшПараметровДополнительныхВПФ = Новый Соответствие;
		КонецЕсли;
		
		КэшПараметровДополнительныхВПФ.Вставить(ВнешняяПечатнаяФорма, ДополнительныеПараметры);
		
	КонецПроцедуры
	
	Процедура ОчиститьКэшДополнительныхВПФ() Экспорт
		
		КэшДополнительныхВПФ=			Новый Соответствие;
		КэшПараметровДополнительныхВПФ=	Новый Соответствие;
		
	КонецПроцедуры
	
	Функция ПолучитьДополнительнуюВПФ(ВнешняяПечатнаяФормаСсылка) Экспорт
		
		Если ЗначениеЗаполнено(КэшДополнительныхВПФ) = Ложь Тогда
			КэшДополнительныхВПФ = Новый Соответствие;
		КонецЕсли;
		
		ЗначКэша = КэшДополнительныхВПФ.Получить(ВнешняяПечатнаяФормаСсылка);
		Если ЗначКэша = Неопределено Тогда
			КэшДополнительныхВПФ.Вставить(ВнешняяПечатнаяФормаСсылка, Неопределено);
		КонецЕсли;
		
		Возврат ЗначКэша;
		
	КонецФункции
	
	Процедура ЗаписатьДополнительнуюВПФ(ВнешняяПечатнаяФормаСсылка, Обработка) Экспорт
		
		Если ЗначениеЗаполнено(КэшДополнительныхВПФ) = Ложь Тогда
			КэшДополнительныхВПФ = Новый Соответствие;
		КонецЕсли;
		
		КэшДополнительныхВПФ.Вставить(ВнешняяПечатнаяФормаСсылка, Обработка);
		
	КонецПроцедуры
	
//} ДОПОЛНИТЕЛЬНЫЕ ПЕЧАТНЫЕ ФОРМЫ
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
//{ РАБОТА С СЕРВЕРОМ ДИАДОК
	
	Функция РаботаССерверомДиадок_Авторизоваться() Экспорт
		
		Если НЕ ПолучитьФорму("Модуль_РаботаССерверомДиадок").АвторизоватьсяИЗаполнитьКонтекст(КонтекстРаботаССерверомДиадок) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если НЕ ПолучитьФорму("Модуль_Организации").Инициализировать(КонтекстОрганизации) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Возврат Истина;
		
	КонецФункции
	
	Функция РаботаССерверомДиадок_ПолучитьDiadocConnection() Экспорт
		Возврат ПолучитьФорму("Модуль_РаботаССерверомДиадок").ПолучитьDiadocConnection(КонтекстРаботаССерверомДиадок);
	КонецФункции
	
	Функция РаботаССерверомДиадок_ПолучитьПредставлениеТекущегоПользователя() Экспорт
		Возврат ПолучитьФорму("Модуль_РаботаССерверомДиадок").ПолучитьПредставлениеТекущегоПользователя(КонтекстРаботаССерверомДиадок);
	КонецФункции
	
	Функция РаботаССерверомДиадок_ПолучитьФИОПодписанта() Экспорт
		Возврат ПолучитьФорму("Модуль_РаботаССерверомДиадок").ПолучитьФИОПодписанта(КонтекстРаботаССерверомДиадок);
	КонецФункции
	
	Функция РаботаССерверомДиадок_ПолучитьСтруктуруОшибкиВнешнейКомпоненты(Подробности) Экспорт
		Возврат ПолучитьФорму("Модуль_РаботаССерверомДиадок").ПолучитьСтруктуруОшибкиВнешнейКомпоненты(Подробности);
	КонецФункции
	
	Функция РаботаССерверомДиадок_ПроверитьПодключениеКСерверуДиадокаПоПрокси(стПрокси) Экспорт
		Возврат ПолучитьФорму("Модуль_РаботаССерверомДиадок").ПроверитьПодключениеКСерверуДиадокаПоПрокси(КонтекстРаботаССерверомДиадок, стПрокси);
	КонецФункции
	
	Функция РаботаССерверомДиадок_ПроверитьПодключениеКСерверуДиадокаПоПрокси_СНастройкамиInternetExplorer(стПрокси,ИспользоватьНастройкиIE) Экспорт
		Возврат ПолучитьФорму("Модуль_РаботаССерверомДиадок").ПроверитьПодключениеКСерверуДиадокаПоПроксиСНастройкамиInternetExplorer(КонтекстРаботаССерверомДиадок, стПрокси,ИспользоватьНастройкиIE);
	КонецФункции
	
	Процедура РаботаССерверомДиадок_ОсвободитьРесурсы() Экспорт
		ПолучитьМодульПрог("Модуль_РаботаССерверомДиадок").ОсвободитьРесурсы(КонтекстРаботаССерверомДиадок);
	КонецПроцедуры
	
	Функция РаботаССерверомДиадок_ПолучитьВерсиюКомпоненты() Экспорт
		Возврат ПолучитьФорму("Модуль_РаботаССерверомДиадок").ПолучитьВерсиюКомпоненты(КонтекстРаботаССерверомДиадок);
	КонецФункции
	
	Функция РаботаССерверомДиадок_ПолучитьDefaultDPI() Экспорт
		Возврат ПолучитьФорму("Модуль_РаботаССерверомДиадок").ПолучитьDefaultDPI(КонтекстРаботаССерверомДиадок);
	КонецФункции
	
	Функция РаботаССерверомДиадок_ПолучитьНастройкиПрокси() Экспорт
		Возврат ПолучитьФорму("Модуль_РаботаССерверомДиадок").ПолучитьНастройкиПрокси();
	КонецФункции
	
	Процедура РаботаССерверомДиадок_УстановитьНастройкиПрокси(стПрокси) Экспорт
		ПолучитьФорму("Модуль_РаботаССерверомДиадок").УстановитьНастройкиПрокси(КонтекстРаботаССерверомДиадок, стПрокси);
	КонецПроцедуры
	
	Процедура РаботаССерверомДиадок_УстановитьНастройкиПрокси_InternetExplorer(стПрокси,ИспользоватьНастройкиПроксиIE) Экспорт
		ПолучитьФорму("Модуль_РаботаССерверомДиадок").УстановитьНастройкиПрокси_InternetExplorer(КонтекстРаботаССерверомДиадок, стПрокси, ИспользоватьНастройкиПроксиIE);
	КонецПроцедуры
	
	Функция РаботаССерверомДиадок_ПолучитьДанныеOrganizationDepartmentДляСопоставления() Экспорт
		Возврат ПолучитьФорму("Модуль_РаботаССерверомДиадок").ПолучитьДанныеOrganizationDepartmentДляСопоставления(КонтекстРаботаССерверомДиадок);
	КонецФункции
	
	Процедура РаботаССерверомДиадок_УстановитьПодразделениеОтправителяУDocument(Organization, DocumentId, DepartmentKpp) Экспорт
		ПолучитьФорму("Модуль_РаботаССерверомДиадок").УстановитьПодразделениеОтправителяУDocument(Organization, DocumentId, DepartmentKpp);
	КонецПроцедуры
	
	Функция РаботаССерверомДиадок_ПолучитьDepartment(Organization, DepartmentKpp) Экспорт
		Возврат ПолучитьФорму("Модуль_РаботаССерверомДиадок").ПолучитьDepartment(Organization, DepartmentKpp);
	КонецФункции
	
//} РАБОТА С СЕРВЕРОМ ДИАДОК
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
//{ РАБОТА С 1С АДАПТЕРОМ
	
	Функция ОдинСАдаптер_Инициализировать() Экспорт
		Возврат ПолучитьМодульПрог("Модуль_1САдаптер").Инициализировать(Контекст1САдаптерКонфигурации);
	КонецФункции
	
	Функция ОдинСАдаптер_Документы_ПолучитьТипСправочникаГТД() Экспорт
		Возврат ПолучитьМодульПрог("Модуль_1САдаптер").Документы_ПолучитьТипСправочникаГТД(Контекст1САдаптерКонфигурации);
	КонецФункции
	
	Функция ОдинСАдаптер_Документы_ПолучитьТипСправочникаДоговоров() Экспорт
		Возврат ПолучитьМодульПрог("Модуль_1САдаптер").Документы_ПолучитьТипСправочникаДоговоров(Контекст1САдаптерКонфигурации);
	КонецФункции
	
	Функция ОдинСАдаптер_НастройкиТекущегоПользователя_ПолучитьНастройку(Наименование) Экспорт
		Возврат ПолучитьМодульПрог("Модуль_1САдаптер").НастройкиТекущегоПользователя_ПолучитьНастройку(Контекст1САдаптерКонфигурации, Наименование);
	КонецФункции
	
	Процедура ОдинСАдаптер_НастройкиТекущегоПользователя_УстановитьНастройку(Наименование, Значение) Экспорт
		Если Контекст1САдаптерКонфигурации = Неопределено Тогда
			ВызватьИсключение "Адаптер 1С конфигурации не инициализирован";
		КонецЕсли;
		
		ПолучитьФорму("Модуль_1САдаптер").НастройкиТекущегоПользователя_УстановитьНастройку(Контекст1САдаптерКонфигурации, Наименование, Значение);
	КонецПроцедуры
	
	Функция ОдинСАдаптер_СвойстваОбъектов_НайтиОбъект(НаименованиеСвойства, ЗначениеСвойства, НаименованиеСвойства2 = Неопределено, ЗначениеСвойства2 = Неопределено) Экспорт
		Возврат ПолучитьМодульПрог("Модуль_1САдаптер").СвойстваОбъектов_НайтиОбъект(Контекст1САдаптерКонфигурации, НаименованиеСвойства, ЗначениеСвойства, НаименованиеСвойства2, ЗначениеСвойства2);
	КонецФункции
	
	Функция ОдинСАдаптер_СвойстваОбъектов_НайтиОбъекты(НаименованиеСвойства, ЗначениеСвойства) Экспорт
		Возврат ПолучитьМодульПрог("Модуль_1САдаптер").СвойстваОбъектов_НайтиОбъекты(Контекст1САдаптерКонфигурации, НаименованиеСвойства, ЗначениеСвойства);
	КонецФункции
	
	Функция ОдинСАдаптер_НайтиОбъектыПоМассивуЗначений(НаименованиеСвойства, ЗначениеСвойства) Экспорт
		Возврат ПолучитьМодульПрог("Модуль_1САдаптер").СвойстваОбъектов_НайтиОбъектыПоМассивуЗначений(Контекст1САдаптерКонфигурации, НаименованиеСвойства, ЗначениеСвойства);
	КонецФункции
	
	Процедура ОдинСАдаптер_СвойстваОбъектов_УстановитьЗначениеСвойства(Объект, НаименованиеСвойства, ЗначениеСвойства) Экспорт
		ПолучитьМодульПрог("Модуль_1САдаптер").СвойстваОбъектов_УстановитьЗначениеСвойства(Контекст1САдаптерКонфигурации, Объект, НаименованиеСвойства, ЗначениеСвойства);
	КонецПроцедуры
	
	Функция ОдинСАдаптер_СвойстваОбъектов_ПолучитьЗначениеСвойства(Объект, НаименованиеСвойства) Экспорт
		Возврат ПолучитьМодульПрог("Модуль_1САдаптер").СвойстваОбъектов_ПолучитьЗначениеСвойства(Контекст1САдаптерКонфигурации, Объект, НаименованиеСвойства);
	КонецФункции
	
	Функция ОдинСАдаптер_СвойстваОбъектов_ПолучитьСсылкуНаСвойство(ИдентификаторСвойства) Экспорт
		Возврат ПолучитьФорму("Модуль_1САдаптер").СвойстваОбъектов_ПолучитьСсылкуНаСвойство(Контекст1САдаптерКонфигурации, ИдентификаторСвойства);
	КонецФункции
	
	Процедура Организации_ОбновитьКонтекст() Экспорт
		ПолучитьМодульПрог("Модуль_Организации").Инициализировать(КонтекстОрганизации);
	КонецПроцедуры
	
	Процедура ВнешнийАдаптер_СопоставлятьДокументыФоном(ДатаНачала, ДатаОкончания) Экспорт
		ПолучитьМодульПрог("Модуль_ВнешнийАдаптер").СопоставитьДокументыФоном(ДатаНачала,ДатаОкончания);	
	КонецПроцедуры
	
//} РАБОТА С 1С АДАПТЕРОМ
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
//{ РАБОТА С НОМЕНКЛАТУРОЙ
	
	Процедура Номенклатура_УстановитьСоответствие(Номенклатура, Контрагент, Code, NomenclatureArticle, Name) Экспорт
		ПолучитьФорму("Модуль_Номенклатура").УстановитьСоответствие(Номенклатура, Контрагент, Code, NomenclatureArticle, Name);
	КонецПроцедуры
	
	Функция Номенклатура_ПолучитьНоменклатуруПоставщика(Контрагент, Name, Code, NomenclatureArticle) Экспорт
		Возврат ПолучитьФорму("Модуль_Номенклатура").ПолучитьНоменклатуруПоставщика(Контрагент, Name, Code, NomenclatureArticle);
	КонецФункции
	
	Функция Номенклатура_ПолучитьНоменклатуруПоАртикулу(NomenclatureArticle) Экспорт
		Возврат ПолучитьФорму("Модуль_Номенклатура").ПолучитьНоменклатуруПоАртикулу(NomenclatureArticle);
	КонецФункции
	
	Функция Номенклатура_ПолучитьАвтомобильПоVIN(NomenclatureName) Экспорт
		Возврат ПолучитьФорму("Модуль_1САдаптерПолучениеДокументов_Рарус").ПолучитьАвтомобильПоVIN(NomenclatureName);
	КонецФункции
	
	Функция Номенклатура_ПолучитьVINИзНаименования(NomenclatureName) Экспорт
		Возврат ПолучитьФорму("Модуль_1САдаптерПолучениеДокументов_Рарус").НайтиVINВНаименовании(NomenclatureName);
	КонецФункции
	
//} РАБОТА С НОМЕНКЛАТУРОЙ
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
//{ РАБОТА С ДОГОВОРАМИ КОНТРАГЕНТОВ
	
	Процедура Договор_УстановитьСоответствие(Договор, ДоговорСвойство) Экспорт
		ПолучитьФорму("Модуль_Данные1С_СвязиОбъектов").УстановитьСоотвествиеДоговора(Договор,ДоговорСвойство);
	КонецПроцедуры
	
//} РАБОТА С ДОГОВОРАМИ КОНТРАГЕНТОВ
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
//{ РАБОТА С СООБЩЕНИЯМИ ПОЛЬЗОВАТЕЛЕЙ
	
	Функция  СообщенияПользователям_ПоказатьСообщениеОбОшибке(Ошибка, Подробности, Параметр = Неопределено) Экспорт
		Возврат ПолучитьФорму("Модуль_СообщенияДляПользователей").ПоказатьСообщениеОбОшибке(Ошибка, Подробности, Параметр);
	КонецФункции
	
//} РАБОТА С СООБЩЕНИЯМИ ПОЛЬЗОВАТЕЛЕЙ
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
//{ РАБОТА С ПРОФИЛЕМ КОНФИГУРАЦИИ
	
	Функция ПолучитьПрофильКонфигурации() Экспорт
		Возврат ПрофильКонфигурации;
	КонецФункции
	
	Функция ЗаполнитьПрофильКонфигурации() Экспорт
		ПрофильКонфигурации = ПолучитьМодульПрог("Модуль_Логика_ПрофилиКонфигурации").СформироватьПрофильКонфигурации();
		Если ПрофильКонфигурации <> Неопределено Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецФункции
	
//} РАБОТА С ПРОФИЛЕМ КОНФИГУРАЦИИ
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
//{ ФУНКЦИИ ИНТЕГРАЦИИ С ПРИКЛАДНЫМИ РЕШНИЯМИ
	
	Функция ИмяФормыПрикладногорешенияДляИнтеграцииДиадок() Экспорт
		Если найти(  метаданные.синоним, "10.3")>0 Тогда 
			Возврат "Модуль_ИнтеграцияУТ103";
		ИначеЕсли  найти(  метаданные.синоним, "10.2")>0 Тогда 
			Возврат "Модуль_ИнтеграцияУТ102";
		ИначеЕсли найти( метаданные.синоним, "Управление торговлей")>0 Тогда
			Возврат "Модуль_ИнтеграцияУТ103";
		ИначеЕсли  найти(  метаданные.синоним, "Комплексная автоматизация")>0 Тогда 
			Возврат "Модуль_ИнтеграцияКА";
		ИначеЕсли  найти(  метаданные.синоним, "Управление производственным предприятием, редакция 1.3")>0 Тогда 
			Возврат "Модуль_ИнтеграцияУПП13";
		ИначеЕсли  найти(  метаданные.синоним, "Альфа-Авто") > 0 И найти(  метаданные.синоним, "4.1") > 0 Тогда 
			Возврат "Модуль_ИнтеграцияАльфаАвто41";
		ИначеЕсли  найти(  метаданные.синоним, "Альфа-Авто") > 0 И найти(  метаданные.синоним, "5") > 0 Тогда 
			Возврат "Модуль_ИнтеграцияАльфаАвто41";
		Иначе 
			Возврат "Модуль_ИнтеграцияБух";
		КонецЕсли;
		
		ВызватьИсключение "Текущая конфигурация " + метаданные.синоним + ". Не поддерживается";
	КонецФункции 
	
	Функция ПолучитьТекстПоддерживаемыхКонфигураций() Экспорт
		Возврат 
		"    Бухгалтерия предприятия,
		|    Комплексная автоматизация,
		|    Управление торговлей,
		|    Управление производственным предприятием";
	КонецФункции
	
	Функция ПолучитьТекущуюВерсиюПлатформы() Экспорт
		системнаяИнформация = Новый СистемнаяИнформация;
		Возврат системнаяИнформация.ВерсияПриложения;
	КонецФункции
		
	Функция СоздатьДокументВ1СПоступление(Параметры, стВероятныеПоля, ЭДОбъект, ТабличнаяЧасть = Неопределено, СуммаВключаетНДС = Истина, ВидОперации, ЗаполнениеГТД = Ложь) Экспорт
		
		ДокументОбъект = Модуль_ИнтеграцияОбщий.СоздатьДокументПоступлениеТоваровУслуг(параметры, стВероятныеПоля, ЭДОбъект, ТабличнаяЧасть, СуммаВключаетНДС, Видоперации, ЗаполнениеГТД);
		ДокументОбъект.ПолучитьФорму().ОткрытьМодально();
		Если ДокументОбъект.Модифицированность() = Ложь Тогда
			Возврат ДокументОбъект.Ссылка;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	КонецФункции	
	
	Функция СоздатьДокументВ1СВозврат(параметры, стВероятныеПоля, ЭДОбъект) Экспорт
		ДокументОбъект = Модуль_ИнтеграцияОбщий.СоздатьДокументВозвратТоваровОтПокупателя(параметры, стВероятныеПоля, ЭДОбъект);
		ДокументОбъект.ПолучитьФорму().ОткрытьМодально();
		Если ДокументОбъект.Модифицированность() = Ложь Тогда
			Возврат ДокументОбъект.Ссылка;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	КонецФункции
	
	Процедура УстановитьДоговорВСчетеФактуреДляДиадок(СчетФактура) Экспорт 
		ИнтОбработка = 	Модуль_ИнтеграцияОбщий;
		ИнтОбработка.УстановитьДоговорВСчетеФактуреДляДиадокПР(СчетФактура);
	КонецПроцедуры
	
	//Функция возвращает список документов, на основании которых требуется выставлять счета-фатуры
	// возвращает таблицу значений
	//колонки : СчетФактура, продавец, Покупатель, суммаДокумента,  ID (в Диадоке)
	Функция ПолучитьТаблицуЗначенийДокументовДляОтправкиДиадок(ДатаНачала, ДатаОкончания, ТипыДокументов, Организация = Неопределено, Контрагент = Неопределено, ТаблицаОтношенийОрганизацийКонтрагентов) Экспорт 
		Если ЗначениеЗаполнено(Организация) Тогда 
			СписокОрганизаций = Новый СписокЗначений;
			СписокОрганизаций.Добавить(Организация);
		Иначе 	
			//СписокОрганизаций =  ПолучитьМодульПрог("Модуль_Данные1С_СвязиОбъектов").ПолучитьСписокПодключенныхКДиадокуОрганизаций();	
			масОрганизаций =   ТаблицаОтношенийОрганизацийКонтрагентов.выгрузитьКолонку("Организация");
			СписокОрганизаций = Новый списокЗначений;
			СписокОрганизаций.ЗагрузитьЗначения(масОрганизаций);
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(Контрагент) Тогда 
			СписокКонтрагентов = Новый СписокЗначений;
			СписокКонтрагентов.Добавить(Контрагент);
		Иначе 	
			//СписокКонтрагентов = ПолучитьМодульПрог("Модуль_Данные1С_СвязиОбъектов").ПолучитьСписокАссоциированныхКонтрагентовДиадок();
			масКонтрагентов =   ТаблицаОтношенийОрганизацийКонтрагентов.выгрузитьКолонку("Контрагент");
			списокконтрагентов = Новый списокЗначений;
			списокКонтрагентов.ЗагрузитьЗначения(масКонтрагентов);
		КонецЕсли;
		
		ТаблицаГенерируемыхПФ = Новый ТаблицаЗначений;
		ТаблицаГенерируемыхПФ.Колонки.Добавить("Организация",Новый ОписаниеТипов ("СправочникСсылка.Организации"));
		ТаблицаГенерируемыхПФ.Колонки.Добавить("ОтпрНеПроведенные",Новый ОписаниеТипов ("Булево"));
		ТаблицаГенерируемыхПФ.Колонки.Добавить("ПечатьСчетаПоРТУ",Новый ОписаниеТипов ("Булево"));
		ТаблицаГенерируемыхПФ.Колонки.Добавить("ПечатьСчетаПоЗаказу",Новый ОписаниеТипов ("Булево"));
		ТаблицаГенерируемыхПФ.Колонки.Добавить("ПечатьСчетаПоСчету",Новый ОписаниеТипов ("Булево"));
		
		
		Для каждого Элем из СписокОрганизаций Цикл
			Стр = ТаблицаГенерируемыхПФ.Добавить();
			Стр.Организация = Элем.Значение;
			НастройкиВнешнихПечатныхФорм =  ПолучитьМодульПрог("Модуль_Данные1С_СвязиОбъектов").ПолучитьНастройкиВнешнихПечатныхФормДляДиадок(Стр.Организация);
			СпособОтправкиСчета = НастройкиВнешнихПечатныхФорм.ДиадокСпособОтправкиСчета;
			
			Стр.ОтпрНеПроведенные = ?(ОдинСАдаптер_СвойстваОбъектов_ПолучитьЗначениеСвойства(Элем.Значение,"ДиадокОтправкаНепроведенных") = "Да", Истина, Ложь);
			Стр.ПечатьСчетаПоРТУ = (СпособОтправкиСчета="РеализацияТоваров");
			Стр.ПечатьСчетаПоЗаказу = (СпособОтправкиСчета="Заказ");
			Стр.ПечатьСчетаПоСчету = (СпособОтправкиСчета="СчетНаОплату");
			
		КонецЦикла;
		
		ТаблицаНастроекПечати = ТаблицаОтношенийОрганизацийКонтрагентов.Скопировать();
		ТаблицаНастроекПечати.свернуть("Организация, ПечатнаяФормаДляТоваров , ПечатнаяФормаДляУслуг");
		ИнтОбработкаДиадок = Модуль_ИнтеграцияОбщий;
		ТаблицаДокументов = ИнтОбработкаДиадок.СформироватьТЗВыгрузкиВДиадок(ДатаНачала,?(ЗначениеЗаполнено(датаокончания), КонецДня(ДатаОкончания), КонецДня(ТекущаяДата())) ,  ТипыДокументов, ИдентификаторСвойстваИдентификаторДокументаВДиадок(), ТаблицаГенерируемыхПФ, СписокКонтрагентов, ТаблицаНастроекПечати);  
		
		//очистим строки по контрагентам которые не дружат
		ц=0;
		пока ц <  ТаблицаДокументов.Количество() цикл 
			стр = ТаблицаДокументов.получить(ц);
			Если КонтрагентыДружатВДиадоке( стр.продавец, стр.Покупатель, стр.Грузополучатель,ТаблицаОтношенийОрганизацийКонтрагентов ) =Ложь Тогда 
				ТаблицаДокументов.удалить(ц)
			иначе 
				ц =ц +1;
			КонецЕсли;
		КонецЦикла;	
		
		Возврат ТаблицаДокументов;
	КонецФункции	
	
	Функция КонтрагентыДружатВДиадоке(Продавец, Покупатель, Грузополучатель,ТаблицаОтношенийОрганизацийКонтрагентов )
		Если   ТаблицаОтношенийОрганизацийКонтрагентов.НайтиСтроки(Новый Структура("Организация, Контрагент", продавец, Покупатель)).количество()>0 Тогда 
			Возврат Истина
		ИначеЕсли ЗначениеЗаполнено(Грузополучатель) и (ТаблицаОтношенийОрганизацийКонтрагентов.НайтиСтроки(Новый Структура("Организация, Контрагент", продавец, Грузополучатель)).количество()>0) Тогда 
			Возврат  Истина
		Иначе 
			Возврат Ложь
		КонецЕсли;	
	КонецФункции
	
	Функция  ПолучитьСуммуДокументаВВалютеРегламентированногоУчетаДиадок(ДокументССылка) Экспорт 
		Возврат  Модуль_ИнтеграцияОбщий.ПолучитьСуммуДокументаВВалютеРегламентированногоУчета_Диадок(ДокументССылка);
	КонецФункции	
	
	Функция ЭтоРТУ(СсылкаНаОбъект)   Экспорт
		Возврат  Модуль_ИнтеграцияОбщий.ЭтоРТУ_ДД(СсылкаНаОбъект);
 	КонецФункции 
	
//} ФУНКЦИИ ИНТЕГРАЦИИ С ПРИКЛАДНЫМИ РЕШНИЯМИ
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
//{ РАБОТА С ОРГАНИЗАЦИЯМИ
	
	Функция Организации_ПолучитьОрганизацииФилиалыСопоставленныеСДиадоком() Экспорт
		Возврат ПолучитьФорму("Модуль_Организации").ПолучитьОрганизацииФилиалыСопоставленныеСДиадоком(КонтекстОрганизации);
	КонецФункции
	
//}РАБОТА С ОРГАНИЗАЦИЯМИ
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
//{ РАБОТА С "ВНЕШНИМИ" КОМПОНЕНТАМИ
	
	Функция ВнешнийАдаптер_ПолучитьСобытияИзмененийСтатусовДокументов(ОрганизацияСсылка, ИдентификаторПоследнейПорции = Неопределено) Экспорт
		Возврат ПолучитьФорму("Модуль_ВнешнийАдаптер").ПолучитьСобытияИзмененийСтатусовДокументов(ОрганизацияСсылка, ИдентификаторПоследнейПорции);
	КонецФункции
	
	Функция ВнешнийАдаптер_ПолучитьИдентификаторПоследнейПорции(ОрганизацияСсылка) Экспорт
		Возврат ПолучитьФорму("Модуль_ВнешнийАдаптер").ПолучитьИдентификаторПоследнейПорции(ОрганизацияСсылка);
	КонецФункции
	
	Процедура ВнешнийАдаптер_События_ПриИзмененииСтатусаДокумента(ДокументСсылка, СопоставленСЭлектроннымДокументом, СтатусВДиадоке) Экспорт
		ПолучитьФорму("Модуль_ВнешнийАдаптер").События_ПриИзмененииСтатусаДокумента(ДокументСсылка, СопоставленСЭлектроннымДокументом, СтатусВДиадоке);
	КонецПроцедуры
	
	Процедура ВнешнийАдаптер_ЗагрузитьФайлыИзДД(Организация=Неопределено) Экспорт
		ПолучитьФорму("Модуль_ВнешнийАдаптер").ЗагрузитьФайлыИзДДВ1С(Организация);
	КонецПроцедуры
	
//} РАБОТА С "ВНЕШНИМИ" КОМПОНЕНТАМИ
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
//{ КОНСТАНТЫ
	
	Функция ВернутьСписокОрганизацийТребующихНомерЗаказа() Экспорт
		СписокОрганизаций = Новый списокЗначений;
		СписокОрганизаций.Добавить("53717c42b4f74fd384330094aeb0f15a@diadoc.ru");
		СписокОрганизаций.Добавить("ca7fe457542f467987df60bb9997208f@diadoc.ru");
		СписокОрганизаций.Добавить("481f205217df46d9bc21b0d8f02b6f2b@diadoc.ru");
		
		Возврат СписокОрганизаций;
		
	КонецФункции	
	
	Функция ВернутьСписокОрганизацийНеТребующихСверкиПоНомеру() Экспорт
		
		СписокОрганизаций=	Новый СписокЗначений;
		//СписокОрганизаций.Добавить("8fd0af8abe934c7091b5ccd476ef1cb5@diadoc.ru");
		СписокОрганизаций.Добавить("7c25b4816a974cca9b33884611b38cda@diadoc.ru");
		
		Возврат СписокОрганизаций;
		
	КонецФункции
	
	Функция ВернутьСписокОрганизацийНеТребующихВизуализацииДопПоля() Экспорт
		
		СписокОрганизаций = Новый списокЗначений;
		СписокОрганизаций.Добавить("c19b1b8c75ab4ca3a2ab8ea3771631ab@diadoc.ru");
		
		Возврат СписокОрганизаций;
		
	КонецФункции
	
//} КОНСТАНТЫ
///////////////////////////////////////////////////////////////////

Функция ПолучитьСловарьЛайф()
	Результат = Новый Структура("НаименованиеСистемы, КраткоеНаименованиеСистемы, КраткоеНаименованиеСистемыПредложныйПадеж, ТочкаВходаВеб, ТелефонТехподдержки, ИспользоватьиконкуСистемы");
	Результат.НаименованиеСистемы = "Лайф Факторинг";
	Результат.КраткоеНаименованиеСистемы = "Лайф";
	Результат.КраткоеНаименованиеСистемыПредложныйПадеж = "Лайфе";
	Результат.ТочкаВходаВеб = "life.kontur.ru";
	Результат.ТелефонТехподдержки = "8 (495) 645-10-51";
	Результат.ИспользоватьИконкуСистемы = Ложь;
	Возврат Результат;	
КонецФункции	

Функция ПолучитьСловарьДиадок()
	Результат = Новый Структура("НаименованиеСистемы, КраткоеНаименованиеСистемы, КраткоеНаименованиеСистемыПредложныйПадеж, ТочкаВходаВеб, ТелефонТехподдержки, ИспользоватьиконкуСистемы");
	Результат.НаименованиеСистемы = "Диадок";
	Результат.КраткоеНаименованиеСистемы = "Диадок";
	Результат.КраткоеНаименованиеСистемыПредложныйПадеж = "Диадоке";
	Результат.ТочкаВходаВеб = "diadoc.kontur.ru";
	Результат.ТелефонТехподдержки = "8 800 500-10-18";
	Результат.ИспользоватьИконкуСистемы = Истина;
	Возврат Результат;	
КонецФункции	


Контекст1САдаптерКонфигурации	= Новый Структура;
КонтекстРаботаССерверомДиадок	= Новый Структура;
КонтекстОрганизации				= Новый Структура;

ИнтеграционнаяОбработка = Неопределено;
ПрофильКонфигурации = Неопределено;

Словарь = ПолучитьСловарьДиадок();

НаименованиеСистемы 						= Словарь.НаименованиеСистемы;
КраткоеНаименованиеСистемы 					= Словарь.КраткоеНаименованиеСистемы;
КраткоеНаименованиеСистемыПредложныйПадеж 	= Словарь.КраткоеНаименованиеСистемыПредложныйПадеж;
ТочкаВходаВеб 						        = Словарь.ТочкаВходаВеб;
ТелефонТехподдержки 						= Словарь.ТелефонТехподдержки;
ИспользоватьИконкуСистемы					= Словарь.ИспользоватьИконкуСистемы;
ВерсияОбработки = "3.15.01";