﻿//m.ionov@a-prof.ru 26/11/2013
//Поменяли периодичность по позици регистратора, чтобы можно было вводить несколько документов на один период
//----- m.ionov@a-prof.ru
//m.ionov@a-prof.ru 05.09.2014
//1. Для продажных цен добавили измерение контрагент - чтобы можно было задавать для контрагентам в целом
//1. Для продажный цен добавили Регион и Канал продаж - чтобы фильтровать цены по данным параметрам при выборе в заказе адреса поставки
//2. В ресурсы добавил "Тип цен" чтобы была информация какой тип цен присвоен и как считать цену с НДС или без НДС
//3. Добавили регистратор - "Установка цен номенклатуры" чтобы можно было устанавливать индивидуальные цены
//----m.ionov@a-prof.ru---

//++ torchinov@a-prof.ru 10.09.2014
Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

// Выполняет движения по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижения() Экспорт

	мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "Период");
	мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "Активность");

	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);

КонецПроцедуры // ВыполнитьДвижения()

//--torchinov@a-prof.ru 10.09.2014