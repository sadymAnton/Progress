﻿Функция ОбработатьСогласованиеЗаявок() Экспорт
	
	//Получим этапы согласования текущего пользователя
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	МаршрутыСогласованияСогласующиеЛица.Ссылка КАК МаршрутСогласования
	               |ИЗ
	               |	Справочник.МаршрутыСогласования.СогласующиеЛица КАК МаршрутыСогласованияСогласующиеЛица
	               |ГДЕ
	               |	МаршрутыСогласованияСогласующиеЛица.Пользователь = &ТекПользователь";
				   
	Запрос.УстановитьПараметр("ТекПользователь", ТекущийПользователь);
	ЭтапыТекущегоПользователя = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("МаршрутСогласования");
	СоответствиеСледующиеЭтапы = Новый Соответствие();
	
	ЕстьОшибки = Ложь;
	
	УспешноОбработанныеЗаявки = Новый Массив;
	
	Для Каждого СтрокаТабличнойЧасти ИЗ ЗаявкиНаРасходованиеСредств Цикл
		Если НЕ СтрокаТабличнойЧасти.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Состояние)
			ИЛИ (СтрокаТабличнойЧасти.ПоследнийСогласующий = ТекущийПользователь
			    // <- Шевченков 20170313 #62814
			    И СтрокаТабличнойЧасти.Этап.Родитель.СогласующиеЛица.Найти(ТекущийПользователь) = Неопределено
				// ->
				И СтрокаТабличнойЧасти.ТекущееСостояние = СтрокаТабличнойЧасти.Состояние) Тогда
				
			УспешноОбработанныеЗаявки.Добавить(СтрокаТабличнойЧасти);
			Продолжить;
		КонецЕсли;

		Отказ = Ложь;
		ТекстПоля = ОбщегоНазначенияКлиентСервер.ПолучитьТекстДляВыдачиСообщенийПоСтрокеТЧ("ЗаявкиНаРасходованиеСредств", СтрокаТабличнойЧасти.НомерСтроки, "Дата");
		
		Если СтрокаТабличнойЧасти.ПоследнийСогласующий = ТекущийПользователь
			ИЛИ НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Этап.Родитель) Тогда
			
			НовыйЭтап = СтрокаТабличнойЧасти.Этап;
			
		Иначе
			
			//Определим новый этап - это может быть следующий этап (непосредственный родитель) 
			//	или один из вышестоящих этапов
			НовыйЭтап = Неопределено;
			ОпределитьСледующийЭтапСогласования(НовыйЭтап, СтрокаТабличнойЧасти.Этап, ЭтапыТекущегоПользователя, СоответствиеСледующиеЭтапы);
			
			//Если новый этап не удалось определить - сообщим об ошибке
			//	Такой ситуации возникать не должно.
			Если НовыйЭтап = Неопределено Тогда
				ТекстСообщения = НСтр("ru = 'Не удалось определить следующий этап согласования заявки &Заявка.
											|Состояние заявки изменено не будет.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "&Заявка", СтрокаТабличнойЧасти.Заявка);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ТекстПоля,, Отказ);
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		НовыйУровень = НовыйЭтап.Уровень() + 1;
		
		//Обработаем состояние Отказано
		Если СтрокаТабличнойЧасти.Состояние = Перечисления.СостоянияОбъектов.Отклонен
			И СтрокаТабличнойЧасти.Заявка.Проведен Тогда
			
			Попытка
				ЗаявкаОбъект = СтрокаТабличнойЧасти.Заявка.ПолучитьОбъект();
				ЗаявкаОбъект.ПКК_АктНачисленияБонусов = Документы.ПКК_АктНачисленияБонусовУслуг.ПустаяСсылка();
				ЗаявкаОбъект.Заблокировать();
				ЗаявкаОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			Исключение
				ТекстСообщения = НСтр("ru = 'Не удалось отменить проведение документа &Заявка.
											|Состояние заявки изменено не будет.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "&Заявка", СтрокаТабличнойЧасти.Заявка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ТекстПоля,, Отказ);
			КонецПопытки;
		КонецЕсли;
		
		// Обработаем изменение состояния с Отказано на другое
		Если СтрокаТабличнойЧасти.ТекущееСостояние = Перечисления.СостоянияОбъектов.Отклонен 
			И НЕ СтрокаТабличнойЧасти.Заявка.Проведен Тогда
			
			Попытка
				ЗаявкаОбъект = СтрокаТабличнойЧасти.Заявка.ПолучитьОбъект();
				ЗаявкаОбъект.Заблокировать();
				ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				ТекстСообщения = НСтр("ru = 'Не удалось провести документ &Заявка.
											|Состояние заявки изменено не будет'");
											
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "&Заявка", СтрокаТабличнойЧасти.Заявка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ТекстПоля,, Отказ);
			КонецПопытки;
		КонецЕсли;
		
		Если Отказ Тогда
			ЕстьОшибки = Истина;
			Продолжить;
		КонецЕсли;
		
		//Изменим состояние заявки в регистре
		НаборЗаписейСостояниеСогласования = РегистрыСведений.СостоянияСогласованияЗаявок.СоздатьНаборЗаписей();
		НаборЗаписейСостояниеСогласования.Отбор.Заявка.Установить(СтрокаТабличнойЧасти.Заявка);
		НаборЗаписейСостояниеСогласования.Прочитать();
		
		//Проверим последнюю запись - если она относится к тому же пользователю и этапу, удалим ее
		Если НаборЗаписейСостояниеСогласования.Количество() > 0 Тогда
			ПоследняяЗапись = НаборЗаписейСостояниеСогласования[НаборЗаписейСостояниеСогласования.Количество()-1];
			Если ПоследняяЗапись.Пользователь = ТекущийПользователь
				И ПоследняяЗапись.Этап = НовыйЭтап Тогда
				
				НаборЗаписейСостояниеСогласования.Удалить(ПоследняяЗапись);
			КонецЕсли;
		КонецЕсли;

		Если СтрокаТабличнойЧасти.Состояние = Перечисления.СостоянияОбъектов.Согласован
			И НовыйУровень = 1 Тогда
			
			НовоеСостояние = Перечисления.СостоянияОбъектов.Утвержден;
		Иначе
			НовоеСостояние = СтрокаТабличнойЧасти.Состояние;
		КонецЕсли; 
		
		НоваяЗапись = НаборЗаписейСостояниеСогласования.Добавить();
		НоваяЗапись.Период       = ТекущаяДата();
		НоваяЗапись.Активность   = Истина;
		НоваяЗапись.Заявка       = СтрокаТабличнойЧасти.Заявка;
		НоваяЗапись.Пользователь = ТекущийПользователь;
		НоваяЗапись.Состояние    = НовоеСостояние;
		НоваяЗапись.Уровень      = НовыйУровень;
		НоваяЗапись.Этап         = НовыйЭтап;
						
		// <- Шевченков проверка когда для этапа друг за другом имеют одинаковых согласующих
		Попытка
			Если НовыйЭтап.Уровень() > 0 Тогда
				Если НовыйЭтап.Родитель.СогласующиеЛица.Найти(ТекущийПользователь) <> Неопределено Тогда			
					//НоваяЗапись = НаборЗаписейСостояниеСогласования.Добавить();
					//НоваяЗапись.Период       = ТекущаяДата();
					//НоваяЗапись.Активность   = Истина;
					//НоваяЗапись.Заявка       = СтрокаТабличнойЧасти.Заявка;
					//НоваяЗапись.Пользователь = ТекущийПользователь;
					//НоваяЗапись.Состояние    = НовоеСостояние;
					НоваяЗапись.Уровень      = ?(НовыйЭтап.Родитель.Уровень()<1, 1, НовыйЭтап.Родитель.Уровень());
					НоваяЗапись.Этап         = НовыйЭтап.Родитель;
					//НаборЗаписейСостояниеСогласования.Записать();
				КонецЕсли;       				
			КонецЕсли;			
		Исключение
			ПРГ_Регламентый.ОтправитьУведомление(ПРГ_Регламентый.ПолучитьАдресЭлПочты(Справочники.Пользователи.НайтиПоКоду("Шевченков А.В.").ФизЛицо), "Ошибка в согласовании заявок (повторяются согласующие)", Строка(СтрокаТабличнойЧасти.Заявка));
		КонецПопытки;		
		// ->
		
		НаборЗаписейСостояниеСогласования.Записать();
		
		//начало изменений 
		ЗаявкаОбъект = СтрокаТабличнойЧасти.Заявка.ПолучитьОбъект();
		Если ЗаявкаОбъект.Состояние <> НовоеСостояние Тогда
			Если НовоеСостояние = Перечисления.СостоянияОбъектов.Отклонен Тогда
				ЗаявкаОбъект.ПКК_АктНачисленияБонусов = Документы.ПКК_АктНачисленияБонусовУслуг.ПустаяСсылка();
			КонецЕсли;			
			ЗаявкаОбъект.Состояние = НовоеСостояние;
			///ЗаявкаОбъект.Заблокировать(); пока без блокировки
			ЗаявкаОбъект.ОбменДанными.Загрузка = истина;
			ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
		// <- Шевченков
		Попытка
			БылаОшибка = Ложь;
			//ПРГ_Регламентый.ПодготовитьУведомление(ЗаявкаОбъект.Ссылка, СтрокаТабличнойЧасти.Состояние); // Шевченков
			ПРГ_Регламентый.ПодготовитьУведомление(ЗаявкаОбъект.Ссылка, ?(ЗначениеЗаполнено(НовоеСостояние), НовоеСостояние, СтрокаТабличнойЧасти.Состояние)); // Шевченков
		Исключение
			БылаОшибка = Истина;
			ТекОшибка = ОписаниеОшибки();
			Сообщить(ТекОшибка);			
		КонецПопытки;	
		
		Если БылаОшибка Тогда
			Попытка
				ТемаПисьма = Строка(ЗаявкаОбъект) + " ошибка при отправке уведомления";
				ПРГ_Регламентый.ОтправитьУведомление(ПРГ_Регламентый.ПолучитьАдресЭлПочты(Справочники.Пользователи.НайтиПоКоду("Шевченков А.В.").ФизЛицо), ТемаПисьма, Строка(ТекОшибка) + Символы.ПС + Символы.ПС + "Пользователь: " + ПараметрыСеанса.ТекущийПользователь);
			Исключение
				Сообщить(ОписаниеОшибки());
			КонецПопытки;		
		КонецЕсли;		
		// ->
		//конец изменений 
		
		УспешноОбработанныеЗаявки.Добавить(СтрокаТабличнойЧасти);
		
	КонецЦикла;
	
	// Удалим из списка заявки по которым удалось изменить состояние
	Для каждого ЭлКоллекции Из УспешноОбработанныеЗаявки Цикл
		ЗаявкиНаРасходованиеСредств.Удалить(ЭлКоллекции);
	КонецЦикла; 
	
	Возврат НЕ ЕстьОшибки;
	
КонецФункции

Процедура ПодготовитьУведомлениеНаПочкуСледСогласующему(ЗаявкаНаРасход = Неопределено, ФизЛицоСогласующего = Неопределено)
		
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Представление КАК ЭлектроннаяПочта
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Объект = &Объект
	|	И КонтактнаяИнформация.Тип = &Тип";
	Запрос.УстановитьПараметр("Объект", ФизЛицоСогласующего);
	Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	Рез = Запрос.Выполнить().Выбрать();
	
	Если Рез.Количество() = 1 Тогда
		
		НаборЗаписейСостояниеСогласования = РегистрыНакопления.ОтправкаПочты.СоздатьНаборЗаписей();
		НаборЗаписейСостояниеСогласования.Отбор.Заявка.Установить(ЗаявкаНаРасход);	
		НаборЗаписейСостояниеСогласования.Прочитать();
		НоваяЗапись                = НаборЗаписейСостояниеСогласования.Добавить();    	
		НоваяЗапись.Период         = ЗаявкаНаРасход.Дата;
		НоваяЗапись.Активность     = Истина;
		НоваяЗапись.Заявка         = ЗаявкаНаРасход;
		НоваяЗапись.ФизическоеЛицо = ФизЛицоСогласующего;
		НоваяЗапись.ВидДвижения    = Перечисления.ВидыДвиженийПриходРасход.Приход;
		НоваяЗапись.ЭлектроннаяПочта = Рез[0].ЭлектроннаяПочта;	
		НаборЗаписейСостояниеСогласования.Записать();
		
	Иначе
		
		Возврат;
		
	КонецЕсли;  	
	
КонецПроцедуры
 
//Процедура определяет этап согласования, который соответствует маршруту согласования и текущему пользователю
Процедура ОпределитьСледующийЭтапСогласования(НовыйЭтап, ТекущийЭтап, ЭтапыТекущегоПользователя, СоответствиеСледующиеЭтапы)
	
	НовыйЭтап = СоответствиеСледующиеЭтапы.Получить(ТекущийЭтап);
	
	Если НовыйЭтап = Неопределено Тогда
		Если ЭтапыТекущегоПользователя.Найти(ТекущийЭтап)<>Неопределено Тогда
			НовыйЭтап = ТекущийЭтап;
			СоответствиеСледующиеЭтапы.Вставить(ТекущийЭтап, НовыйЭтап);
		ИначеЕсли ЗначениеЗаполнено(ТекущийЭтап.Родитель) Тогда
			ОпределитьСледующийЭтапСогласования(НовыйЭтап, ТекущийЭтап.Родитель, ЭтапыТекущегоПользователя, СоответствиеСледующиеЭтапы)
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
