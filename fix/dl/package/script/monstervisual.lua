--[[#tag push auto]]

-- 怪物显示相关
MonsterVisual = {}
MonsterVisual.VisualName = {}				--
MonsterVisual.GfxName    = {}
MonsterVisual.SpecialAction = {}
MonsterVisual.AttributeName = {}
MonsterVisual.MonsterNotes = {}
MonsterVisual.MonsterAttribute = {}
MonsterVisual.WalkRunBlendParams = {}
----------------------------------------------------------------
MonsterVisual.VisualName[8929] = {--[[!AUTO_1]]"Test"}
MonsterVisual.VisualName[9181] = {--[[!AUTO_2]]"Acute Vision"}
MonsterVisual.VisualName[9182] = {--[[!AUTO_3]]"Slow Vision"}
MonsterVisual.VisualName[9183] = {--[[!AUTO_4]]"Militant"}
MonsterVisual.VisualName[9184] = {--[[!AUTO_5]]"Very Docile"}
MonsterVisual.VisualName[9185] = {--[[!AUTO_6]]"HP Enhancement"}
MonsterVisual.VisualName[9186] = {--[[!AUTO_7]]"Unassailable"}
MonsterVisual.VisualName[9187] = {--[[!AUTO_8]]"Lucky Attack"}
MonsterVisual.VisualName[9188] = {--[[!AUTO_9]]"Hysteria"}
MonsterVisual.VisualName[9189] = {--[[!AUTO_10]]"Very Strong"}
MonsterVisual.VisualName[9190] = {--[[!AUTO_11]]"Exceedingly tough"}
MonsterVisual.VisualName[9191] = {--[[!AUTO_12]]"Crtical Strike"}
MonsterVisual.VisualName[9192] = {--[[!AUTO_13]]"Phantom strike"}
MonsterVisual.VisualName[9193] = {--[[!AUTO_14]]"Stable Chi"}
MonsterVisual.VisualName[9194] = {--[[!AUTO_15]]"Surging Reflex"}
MonsterVisual.VisualName[9195] = {--[[!AUTO_16]]"Profound Endo"}
MonsterVisual.VisualName[9196] = {--[[!AUTO_17]]"Power of Chi"}
MonsterVisual.VisualName[9197] = {--[[!AUTO_18]]"Dealy Endo"}
MonsterVisual.VisualName[9198] = {--[[!AUTO_19]]"Spirit Strike"}
MonsterVisual.VisualName[9199] = {--[[!AUTO_20]]"Battle Recovery"}
MonsterVisual.VisualName[9200] = {--[[!AUTO_21]]"Distant Slay"}
MonsterVisual.VisualName[9201] = {--[[!AUTO_22]]"Feeble"}
MonsterVisual.VisualName[9202] = {--[[!AUTO_23]]"Self-adjustment"}
MonsterVisual.VisualName[9203] = {--[[!AUTO_24]]"Light as Bird"}
MonsterVisual.VisualName[9204] = {--[[!AUTO_25]]"Fast as Wind"}
MonsterVisual.VisualName[9205] = {--[[!AUTO_26]]"Heavy steps"}
MonsterVisual.VisualName[9206] = {--[[!AUTO_27]]"Very Slow"}
MonsterVisual.VisualName[9207] = {--[[!AUTO_28]]"Flexible"}
MonsterVisual.VisualName[9208] = {--[[!AUTO_29]]"Stagnant"}
MonsterVisual.VisualName[9209] = {--[[!AUTO_30]]"Unlucky Attack"}
MonsterVisual.VisualName[9210] = {--[[!AUTO_31]]"Exceedingly Weak"}
MonsterVisual.VisualName[9211] = {--[[!AUTO_32]]"Exceedingly Weak"}
MonsterVisual.VisualName[9212] = {--[[!AUTO_33]]"Strong Physique"}
MonsterVisual.VisualName[9799] = {--[[!AUTO_34]]""}
MonsterVisual.VisualName[9805] = {--[[!AUTO_35]]"Vulnerability increased"}
MonsterVisual.VisualName[9808] = {--[[!AUTO_36]]"Health Points increased"}
MonsterVisual.VisualName[9809] = {--[[!AUTO_37]]"Minimum attack increased"}
MonsterVisual.VisualName[9810] = {--[[!AUTO_38]]"Maximum attack increased"}
MonsterVisual.VisualName[9811] = {--[[!AUTO_39]]"Attack Speed increased"}
MonsterVisual.VisualName[9812] = {--[[!AUTO_40]]"Defence increased"}
MonsterVisual.VisualName[9813] = {--[[!AUTO_41]]"Critical chance increased"}
MonsterVisual.VisualName[9814] = {--[[!AUTO_42]]"Critical damage increased"}
MonsterVisual.VisualName[9815] = {--[[!AUTO_43]]"Heroic Bearing"}
MonsterVisual.VisualName[9816] = {--[[!AUTO_44]]"Movement speed increased"}
MonsterVisual.VisualName[16665] = {--[[!AUTO_45]]""}
MonsterVisual.VisualName[26407] = {--[[!AUTO_46]]"5 times of health points"}
MonsterVisual.VisualName[26408] = {--[[!AUTO_47]]"50 times of health points"}
MonsterVisual.VisualName[26409] = {--[[!AUTO_48]]"100 times of health points"}
MonsterVisual.VisualName[26410] = {--[[!AUTO_49]]"200 times of health points"}
MonsterVisual.VisualName[26411] = {--[[!AUTO_50]]"5 times of health points"}
MonsterVisual.VisualName[26412] = {--[[!AUTO_51]]"Quest light effect"}
MonsterVisual.VisualName[26413] = {--[[!AUTO_52]]"Special Monster light effect"}
MonsterVisual.VisualName[26414] = {--[[!AUTO_53]]"Random Monster light effect"}
MonsterVisual.VisualName[26415] = {--[[!AUTO_54]]"BOSS ight effect"}
MonsterVisual.VisualName[26416] = {--[[!AUTO_55]]"Common Vulnerability"}
MonsterVisual.VisualName[26417] = {--[[!AUTO_56]]"5 times of Vulnerability"}
MonsterVisual.VisualName[26418] = {--[[!AUTO_57]]"2000 Vulnerability"}
MonsterVisual.VisualName[26419] = {--[[!AUTO_58]]"1000 Vulnerability"}
MonsterVisual.VisualName[26420] = {--[[!AUTO_59]]"Common Vulnerability"}
MonsterVisual.VisualName[26421] = {--[[!AUTO_60]]"Level HP20"}
MonsterVisual.VisualName[26422] = {--[[!AUTO_61]]"Level HP40"}
MonsterVisual.VisualName[26423] = {--[[!AUTO_62]]"Level HP100"}
MonsterVisual.VisualName[26424] = {--[[!AUTO_63]]"Level HP400"}
MonsterVisual.VisualName[26425] = {--[[!AUTO_64]]"Level HP150"}
MonsterVisual.VisualName[26426] = {--[[!AUTO_65]]"Level HP300"}
MonsterVisual.VisualName[26427] = {--[[!AUTO_66]]"Level HP750"}
MonsterVisual.VisualName[26428] = {--[[!AUTO_67]]"Level HP3000"}
MonsterVisual.VisualName[26429] = {--[[!AUTO_68]]"Level HP200"}
MonsterVisual.VisualName[26430] = {--[[!AUTO_69]]"Level HP400"}
MonsterVisual.VisualName[26431] = {--[[!AUTO_70]]"Level HP1000"}
MonsterVisual.VisualName[26432] = {--[[!AUTO_71]]"Level HP4000"}
MonsterVisual.VisualName[26433] = {--[[!AUTO_72]]"Vulnerability  increased by 100"}
MonsterVisual.VisualName[26434] = {--[[!AUTO_73]]"Vulnerability  increased by 400"}
MonsterVisual.VisualName[26435] = {--[[!AUTO_74]]"Vulnerability  increased by 900"}
MonsterVisual.VisualName[26436] = {--[[!AUTO_75]]"Vulnerability  increased by 4900"}
MonsterVisual.VisualName[26437] = {--[[!AUTO_76]]"Maximize Exo damage"}
MonsterVisual.VisualName[26438] = {--[[!AUTO_77]]"Floating Exo damage"}
MonsterVisual.VisualName[26439] = {--[[!AUTO_78]]"x2 Exo-Attack"}
MonsterVisual.VisualName[26440] = {--[[!AUTO_79]]"x3 Exo-Attack"}
MonsterVisual.VisualName[26441] = {--[[!AUTO_80]]"x5 Exo-Attack"}
MonsterVisual.VisualName[26442] = {--[[!AUTO_81]]"x10 Exo-Attack"}
MonsterVisual.VisualName[26443] = {--[[!AUTO_82]]"x3 Armor"}
MonsterVisual.VisualName[26444] = {--[[!AUTO_83]]"50% Exo Critical Chance"}
MonsterVisual.VisualName[26445] = {--[[!AUTO_84]]"200% Exo Critical damage"}
MonsterVisual.VisualName[26446] = {--[[!AUTO_85]]"Maximize Exo damage"}
MonsterVisual.VisualName[26447] = {--[[!AUTO_86]]"Floating Endo damage"}
MonsterVisual.VisualName[26448] = {--[[!AUTO_87]]"x2 Endo-Attack"}
MonsterVisual.VisualName[26449] = {--[[!AUTO_88]]"x3 Endo-Attack"}
MonsterVisual.VisualName[26450] = {--[[!AUTO_89]]"x5 Endo-Attack"}
MonsterVisual.VisualName[26451] = {--[[!AUTO_90]]"x10 Endo-Attack"}
MonsterVisual.VisualName[26452] = {--[[!AUTO_91]]"x3 Endo defence"}
MonsterVisual.VisualName[26453] = {--[[!AUTO_92]]"50% Endo Critical Chance"}
MonsterVisual.VisualName[26454] = {--[[!AUTO_93]]"200% Exo Critical damage"}
MonsterVisual.VisualName[26455] = {--[[!AUTO_94]]"x1.5 Speed"}
MonsterVisual.VisualName[26456] = {--[[!AUTO_95]]"Fire damage Decreased by 0.25"}
MonsterVisual.VisualName[26457] = {--[[!AUTO_96]]"Fire damage Decreased by 0.5"}
MonsterVisual.VisualName[26458] = {--[[!AUTO_97]]"Fire damage Decreased by 0.75"}
MonsterVisual.VisualName[26459] = {--[[!AUTO_98]]"Immune to fire damage"}
MonsterVisual.VisualName[26460] = {--[[!AUTO_99]]"Ice damage Decreased by 0.25"}
MonsterVisual.VisualName[26461] = {--[[!AUTO_100]]"Ice damage Decreased by 0.5"}
MonsterVisual.VisualName[26462] = {--[[!AUTO_101]]"Ice damage Decreased by 0.75"}
MonsterVisual.VisualName[26463] = {--[[!AUTO_102]]"Immune to ice damage"}
MonsterVisual.VisualName[26464] = {--[[!AUTO_103]]"Poison damage Decreased by 0.25"}
MonsterVisual.VisualName[26465] = {--[[!AUTO_104]]"Poison damage Decreased by 0.5"}
MonsterVisual.VisualName[26466] = {--[[!AUTO_105]]"Poison damage Decreased by 0.75"}
MonsterVisual.VisualName[26467] = {--[[!AUTO_106]]"Immune to Poison damage"}
MonsterVisual.VisualName[26468] = {--[[!AUTO_107]]"BOSS strategy 1"}
MonsterVisual.VisualName[26469] = {--[[!AUTO_108]]"BOSS strategy 2"}
MonsterVisual.VisualName[26470] = {--[[!AUTO_109]]"BOSS strategy 3"}
MonsterVisual.VisualName[26471] = {--[[!AUTO_110]]"BOSS strategy 4"}
MonsterVisual.VisualName[26472] = {--[[!AUTO_111]]"BOSS strategy 5"}
MonsterVisual.VisualName[26473] = {--[[!AUTO_112]]"Snake"}
MonsterVisual.VisualName[26474] = {--[[!AUTO_113]]"Spider"}
MonsterVisual.VisualName[26475] = {--[[!AUTO_114]]"Ox"}
MonsterVisual.VisualName[26476] = {--[[!AUTO_115]]"Tiger"}
MonsterVisual.VisualName[26477] = {--[[!AUTO_116]]"Pangolin"}
MonsterVisual.VisualName[26478] = {--[[!AUTO_117]]"Bee"}
MonsterVisual.VisualName[26479] = {--[[!AUTO_118]]"Crow"}
MonsterVisual.VisualName[26480] = {--[[!AUTO_119]]"Vulture"}
MonsterVisual.VisualName[26481] = {--[[!AUTO_120]]"Weasel"}
MonsterVisual.VisualName[26482] = {--[[!AUTO_121]]"Mink"}
MonsterVisual.VisualName[26483] = {--[[!AUTO_122]]"Wolf"}
MonsterVisual.VisualName[26484] = {--[[!AUTO_123]]"Leopard"}
MonsterVisual.VisualName[26485] = {--[[!AUTO_124]]"M/A人豪爽"}
MonsterVisual.VisualName[26486] = {--[[!AUTO_125]]"N/A人霸气"}
MonsterVisual.VisualName[26487] = {--[[!AUTO_126]]"N/A人阴险"}
MonsterVisual.VisualName[26807] = {--[[!AUTO_127]]"Scout escapes"}
MonsterVisual.VisualName[26808] = {--[[!AUTO_128]]"Guard calls for help first"}
MonsterVisual.VisualName[26809] = {--[[!AUTO_129]]"Berserker Guard"}
MonsterVisual.VisualName[26818] = {--[[!AUTO_130]]"Board"}
MonsterVisual.VisualName[26819] = {--[[!AUTO_131]]"Fox"}
MonsterVisual.VisualName[26820] = {--[[!AUTO_132]]"Scorpion"}
MonsterVisual.VisualName[26821] = {--[[!AUTO_133]]"Mountain Pheasant"}
MonsterVisual.VisualName[26822] = {--[[!AUTO_134]]"Bamboo"}
MonsterVisual.VisualName[26823] = {--[[!AUTO_135]]"Flower Spirit"}

--------------------------------------------------------------------
--[[暂时不使用
MonsterVisual.GfxName[1] = {"快如闪电的"}
MonsterVisual.GfxName[2] = {"迅捷如风的"}
MonsterVisual.GfxName[3] = {"力大如牛的"}
MonsterVisual.GfxName[4] = {"两眼充血的"}
MonsterVisual.GfxName[5] = {"歇斯底里的"}
MonsterVisual.GfxName[6] = {"疯狂的"}
MonsterVisual.GfxName[7] = {"强大的"}
MonsterVisual.GfxName[8] = {"胆小的"}
MonsterVisual.GfxName[9] = {"强壮的"}
MonsterVisual.GfxName[10] = {"阴险狡诈的"}
MonsterVisual.GfxName[11] = {"心沉手稳的"}
MonsterVisual.GfxName[12] = {"迅捷如风的"}
MonsterVisual.GfxName[13] = {"高傲自大的"}
MonsterVisual.GfxName[14] = {"唧唧歪歪的"}
MonsterVisual.GfxName[15] = {"挥刀自宫的"}
MonsterVisual.GfxName[16] = {"久经沙场的"}
MonsterVisual.GfxName[17] = {"惊天动地的"}
MonsterVisual.GfxName[18] = {"天下无敌的"}
MonsterVisual.GfxName[19] = {"身轻如燕的"}
MonsterVisual.GfxName[20] = {"虎背熊腰的"}
MonsterVisual.GfxName[21] = {"身轻如燕的"}
MonsterVisual.GfxName[22] = {"挥刀自宫的"}
MonsterVisual.GfxName[23] = {"唧唧歪歪的"}
MonsterVisual.GfxName[24] = {"力大无穷的"}
MonsterVisual.GfxName[25] = {"挨打不痛的"}
MonsterVisual.GfxName[26] = {"疯狂的"}
MonsterVisual.GfxName[27] = {"两眼充血的"}
MonsterVisual.GfxName[28] = {"与众不同的"}
MonsterVisual.GfxName[29] = {"迅捷如风的"}
MonsterVisual.GfxName[30] = {"力大如牛的"}
MonsterVisual.GfxName[31] = {"身轻如燕的"}
MonsterVisual.GfxName[32] = {"久经沙场的"}
MonsterVisual.GfxName[33] = {"心沉手稳的"}
MonsterVisual.GfxName[34] = {"阴险狡诈的"}
MonsterVisual.GfxName[35] = {"足下生风的"}
MonsterVisual.GfxName[36] = {"拳上冒火的"}
MonsterVisual.GfxName[37] = {"暴力的"}
MonsterVisual.GfxName[38] = {"温顺的"}
MonsterVisual.GfxName[39] = {"歇斯底里的"}
MonsterVisual.GfxName[40] = {"渴望战斗的"}
MonsterVisual.GfxName[41] = {"带电的"}
MonsterVisual.GfxName[42] = {"燃烧的"}
MonsterVisual.GfxName[43] = {"寒冰的"}
MonsterVisual.GfxName[44] = {"巨毒的"}
MonsterVisual.GfxName[45] = {"歇斯底里的"}
MonsterVisual.GfxName[46] = {"的"}
MonsterVisual.GfxName[47] = {"的"}
MonsterVisual.GfxName[48] = {"的"}
MonsterVisual.GfxName[49] = {"的"}
MonsterVisual.GfxName[50] = {"歇斯底里的"}
MonsterVisual.GfxName[51] = {"的"}
MonsterVisual.GfxName[52] = {"的"}
MonsterVisual.GfxName[53] = {"的"}
MonsterVisual.GfxName[54] = {"的"}
MonsterVisual.GfxName[55] = {"的"}
MonsterVisual.GfxName[56] = {"的"}
MonsterVisual.GfxName[57] = {"的"}
MonsterVisual.GfxName[58] = {"的"}
MonsterVisual.GfxName[59] = {"的"}
暂时不使用]]--
MonsterVisual.GfxName[60] = {--[[!AUTO_136]]""}
MonsterVisual.GfxName[61] = {--[[!AUTO_137]]""}
MonsterVisual.GfxName[62] = {--[[!AUTO_138]]""}
MonsterVisual.GfxName[63] = {--[[!AUTO_139]]""}
--------------------------------------------------------------------
MonsterVisual.SlowBind =
{
--tmplid	--模板名
[142] = true,	--测试交通工具
[13927] = true,	--测试载具操作任务绑定
[16584] = true,	--梅关古道镖车
[16945] = true,	--任务库良马
[18530] = true,	--闽南马
[18613] = true,	--01少林门派坐骑01
[18614] = true,	--02武当门派坐骑01
[18615] = true,	--03华山门派坐骑01
[18616] = true,	--04唐门门派坐骑01
[18617] = true,	--05五仙门派坐骑01
[18618] = true,	--06逍遥门派坐骑01
[18619] = true,	--07峨嵋门派坐骑01
[18620] = true,	--08日月门派坐骑01
[18621] = true,	--09恒山门派坐骑01
[18622] = true,	--10衡山门派坐骑01
[18623] = true,	--01少林门派坐骑02
[18624] = true,	--02武当门派坐骑02
[18625] = true,	--03华山门派坐骑02
[18626] = true,	--04唐门门派坐骑02
[18627] = true,	--05五仙门派坐骑02
[18628] = true,	--06逍遥门派坐骑02
[18629] = true,	--07峨嵋门派坐骑02
[18630] = true,	--08日月门派坐骑02
[18631] = true,	--09恒山门派坐骑02
[18632] = true,	--10衡山门派坐骑02
[21865] = true,	--城市出售黄骠马
[25993] = true,	--东方剧情逃亡马匹
[27499] = true,	--桂林载具羊
[27500] = true,	--桂林载具狼
[27517] = true,	--39泰山马
}
--------------------------------------------------------------------
MonsterVisual.BeAtkConfig =
{
--模板id	canshake是否受伤抖动		是否物理受伤
[34631] = {canshake = false },
[34824] = {canshake = false ,   canPhyDmg = false},	--青城破碎
[34825] = {canshake = false ,   canPhyDmg = false},	--青城破碎
[34830] = {canshake = false },	--青城破碎
[34831] = {canshake = false },	--青城破碎
[34832] = {canshake = false },	--青城破碎
[34833] = {canshake = false },	--青城破碎
[34834] = {canshake = false },	--青城破碎
[34835] = {canshake = false },	--青城破碎
[58652] = {canshake = false },	--青城覆灭乌鸦图腾
[59059] = {canshake = false },	--酒肆破碎
[59060] = {canshake = false },	--酒肆破碎
[59061] = {canshake = false },	--酒肆破碎
[60636] = {canshake = false },	--孤岛破碎
[60637] = {canshake = false },	--孤岛破碎
[62650] = {canshake = false },	--孤岛破碎
[38477] = {canshake = false },	--东厂破碎
[38478] = {canshake = false },	--东厂破碎
[38479] = {canshake = false },	--东厂破碎
[38480] = {canshake = false },	--东厂破碎
[38481] = {canshake = false },	--东厂破碎
[55447] = {canshake = false },	--龙岭破碎
[55448] = {canshake = false },	--龙岭破碎
[55449] = {canshake = false },	--龙岭破碎
[55450] = {canshake = false },	--龙岭破碎
[55451] = {canshake = false },	--龙岭破碎
[55452] = {canshake = false },	--龙岭破碎
[55453] = {canshake = false },	--龙岭破碎
[57336] = {canshake = false },	--蝎王破碎
[57337] = {canshake = false },	--蝎王破碎
[57338] = {canshake = false },	--蝎王破碎
[62169] = {canshake = false },	--青城覆灭竹林
[66386] = {canshake = false },	--梅庄外围破碎
[66387] = {canshake = false },	--梅庄外围破碎
[66388] = {canshake = false },	--梅庄外围破碎
[66389] = {canshake = false },	--梅庄外围破碎
[67377] = {canshake = false },	--连云堡破碎
[67378] = {canshake = false },	--连云堡破碎
[67379] = {canshake = false },	--连云堡破碎
[72984] = {canshake = false },	--连云堡破碎
[72985] = {canshake = false },	--连云堡破碎
[74499] = {canshake = false },	--连云堡破碎
[74500] = {canshake = false },	--连云堡破碎
[67608] = {canshake = false },	--山崖破碎
[67609] = {canshake = false },	--山崖破碎
[67610] = {canshake = false },	--山崖破碎
[67611] = {canshake = false },	--山崖破碎
[77607] = {canshake = false },
[77608] = {canshake = false },
[77609] = {canshake = false },
[77610] = {canshake = false },
[77611] = {canshake = false },
[77612] = {canshake = false },
[77613] = {canshake = false },
[77614] = {canshake = false },
[80596] = {canshake = false },
[75422] = {canshake = false },
[75423] = {canshake = false },
[75424] = {canshake = false },
[75425] = {canshake = false },
[75426] = {canshake = false },
[75427] = {canshake = false },
[75428] = {canshake = false },
[75429] = {canshake = false },
[75430] = {canshake = false },
[75431] = {canshake = false },
[75432] = {canshake = false },
[67073] = {canshake = false },
[67074] = {canshake = false },
[73673] = {canshake = false },
[73674] = {canshake = false },
[73682] = {canshake = false },
[73690] = {canshake = false },
[73694] = {canshake = false },
[73695] = {canshake = false },
[73696] = {canshake = false },
[73697] = {canshake = false },
[73698] = {canshake = false },
[67626] = {canshake = false,   canPhyDmg = false },	--连云堡大门
[44024] = {canshake = false,   canPhyDmg = false },	--金熊像
[44025] = {canshake = false,   canPhyDmg = false },	--石猴像
[33017] = {canshake = true,   canPhyDmg = false },	--评书副本青城山青城派精英弟子A
[33018] = {canshake = true,   canPhyDmg = false },	--评书副本青城山青城派精英弟子B
[34826] = {canshake = true,   canPhyDmg = false },	--评书青城隐藏看守高手A
[34827] = {canshake = true,   canPhyDmg = false },	--评书青城隐藏看守高手B
[34839] = {canshake = true,   canPhyDmg = false },	--评书青城八荒阵竹林伏击高手B
[33019] = {canshake = true,   canPhyDmg = false },	--评书副本青城山小BOSS侯人英
[33020] = {canshake = true,   canPhyDmg = false },	--评书副本青城山小BOSS于人豪
[33021] = {canshake = true,   canPhyDmg = false },	--评书副本青城山小BOSS洪人雄
[33022] = {canshake = true,   canPhyDmg = false },	--评书副本青城山小BOSS罗人杰
[33025] = {canshake = true,   canPhyDmg = false },	--评书副本青城山擂台精英弟子A
[33026] = {canshake = true,   canPhyDmg = false },	--评书副本青城山擂台精英弟子B
[33027] = {canshake = true,   canPhyDmg = false },	--评书副本青城山擂台小BOSS侯人英
[33028] = {canshake = true,   canPhyDmg = false },	--评书副本青城山擂台小BOSS于人豪
[33029] = {canshake = true,   canPhyDmg = false },	--评书副本青城山擂台小BOSS洪人雄
[33030] = {canshake = true,   canPhyDmg = false },	--评书副本青城山擂台小BOSS罗人杰
[33031] = {canshake = true,   canPhyDmg = false },	--评书副本青城山BOSS余沧海
[38075] = {canshake = true,   canPhyDmg = false },	--青城深渊_木高峰一阶
[38078] = {canshake = true,   canPhyDmg = false },	--青城深渊_岳灵珊
[55460] = {canshake = true,   canPhyDmg = false },	--随机事件四秀1侯人英
[55461] = {canshake = true,   canPhyDmg = false },	--随机事件四秀2洪人雄
[55462] = {canshake = true,   canPhyDmg = false },	--随机事件四秀3于人豪
[55463] = {canshake = true,   canPhyDmg = false },	--随机事件四秀4罗人杰
[55466] = {canshake = true,   canPhyDmg = false },	--随机事件青城近战精英
[55467] = {canshake = true,   canPhyDmg = false },	--随机事件青城跳劈精英
[56359] = {canshake = true,   canPhyDmg = false },	--镖局副本蒙面杀手
[59058] = {canshake = true,   canPhyDmg = false },	--酒肆副本伏击高手
[60632] = {canshake = true,   canPhyDmg = false },	--孤岛副本BOSS丁勉
[67428] = {canshake = true,   canPhyDmg = false },	--孤岛副本BOSS东海一枪
[34862] = {canshake = true,   canPhyDmg = false },	--东厂副本机器人1
[34863] = {canshake = true,   canPhyDmg = false },	--东厂副本机器人2
[34867] = {canshake = true,   canPhyDmg = false },	--东厂副本机器人BOSS
}
--------------------------------------------------------------------
--------------------------------------------------------------------
MonsterVisual.SpecialModelSpeed =
{
--pathid	标准走速	标准跑速	是否平稳速度（车辆、无腿）	--模型名备注
[5059] = {ws = 0.5, ms = 2.5, sp = false},	--穿山甲
[6434] = {ws = 1.5, ms = 4.5, sp = true},	--马车
[13944] = {ws = 1.5, ms = 4.5, sp = false},	--西湖黑雨刺客镖局
[13943] = {ws = 1.8, ms = 5.4, sp = false},	--红巾怪客镖局
[13942] = {ws = 3, ms = 9, sp = false},		--嗜血和尚镖局
[14794] = {ws = 3, ms = 9, sp = false},		--Models\NPCs\怪物\BOSS\叛军首领\叛军首领帮派boss.ecm
[14795] = {ws = 3, ms = 9, sp = false},		--Models\NPCs\怪物\BOSS\水贼头领鱼得水\水贼头领鱼得水帮派boss.ecm
[14796] = {ws = 3, ms = 9, sp = false},		--Models\NPCs\怪物\BOSS\鬼丸一斩\鬼丸一斩帮派boss.ecm
[14797] = {ws = 3, ms = 9, sp = false},		--Models\NPCs\怪物\人形\灯奴\灯奴帮派boss.ecm
[14798] = {ws = 3, ms = 9, sp = false},		--Models\NPCs\怪物\人形\黑衣人头目\黑衣人头目帮派boss.ecm
[77604] = {ws = 1.8, ms = 5.4, sp = false},	--绝情谷主公孙灭
}
--------------------------------------------------------------------
MonsterVisual.ForceAction =
{
-- 如果怪物有格挡技能，而且有格挡动作和光效，需要在这里设置canblock = true
-- locktarget为1是有索敌动作时调用，2为没有索敌动作调用行走，3为没有索敌动作调用战斗奔跑
[13049] = {locktarget = 1, canblock = false},		--腐奴
[13052] = {locktarget = 2, canblock = false},		--刑鬼
[13139] = {locktarget = 2, canblock = true},		--死牢冤魂
[33015] = {locktarget = 1, canblock = false},		--评书副本青城山青城派弟子A
[33016] = {locktarget = 1, canblock = false},		--评书副本青城山青城派弟子B
[33017] = {locktarget = 1, canblock = true},		--评书副本青城山青城派精英弟子A
[33018] = {locktarget = 1, canblock = true},		--评书副本青城山青城派精英弟子B
[34826] = {locktarget = 1, canblock = true},		--评书青城隐藏看守高手A
[34827] = {locktarget = 1, canblock = true},		--评书青城隐藏看守高手B
[34838] = {locktarget = 1, canblock = false},		--评书青城八荒阵弟子B
[34839] = {locktarget = 1, canblock = true},		--评书青城八荒阵竹林伏击高手B
[33019] = {locktarget = 1, canblock = true},		--评书副本青城山小BOSS侯人英

[33020] = {locktarget = 1, canblock = true},		--评书副本青城山小BOSS于人豪

[33021] = {locktarget = 1, canblock = true},		--评书副本青城山小BOSS洪人雄

[33022] = {locktarget = 1, canblock = true},		--评书副本青城山小BOSS罗人杰

[33023] = {locktarget = 1, canblock = false},		--评书副本青城山擂台弟子A
[33024] = {locktarget = 1, canblock = false},		--评书副本青城山擂台弟子B
[33025] = {locktarget = 1, canblock = true},		--评书副本青城山擂台精英弟子A
[33026] = {locktarget = 1, canblock = true},		--评书副本青城山擂台精英弟子B
[33027] = {locktarget = 1, canblock = true},		--评书副本青城山擂台小BOSS侯人英

[33028] = {locktarget = 1, canblock = true},		--评书副本青城山擂台小BOSS于人豪

[33029] = {locktarget = 1, canblock = true},		--评书副本青城山擂台小BOSS洪人雄

[33030] = {locktarget = 1, canblock = true},		--评书副本青城山擂台小BOSS罗人杰

[33031] = {locktarget = 1, canblock = true},		--评书副本青城山BOSS余沧海

[33048] = {locktarget = 1, canblock = false},		--联手产品演示_剧情亭中御敌_1侯人雄

[33049] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_1青城弟子
[33050] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_2怀杖黑衣人
[33051] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_2铁牌黑衣人

[33052] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_3铜锤黑衣人

[33053] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_4长枪黑衣人

[33054] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_5双刀女人
[33055] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_5链锤大汉
[33056] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_5软鞭大汉
[33057] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_6天乙道人
[33058] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_7泰山护门
[33059] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_8衡山剑客
[33060] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_8魔教盾使
[33061] = {locktarget = 3, canblock = false},		--联手产品演示_剧情亭中御敌_9持刀黑衣人

[33062] = {locktarget = 3, canblock = false},		--联手产品演示_剧情峡谷突破_a江湖刺客
[33063] = {locktarget = 3, canblock = false},		--联手产品演示_剧情峡谷突破_a江湖狙击手

[33064] = {locktarget = 3, canblock = false},		--联手产品演示_剧情峡谷突破_a江湖爆破手

[33065] = {locktarget = 3, canblock = false},		--联手产品演示_剧情峡谷突破_a江湖黑手
[38066] = {locktarget = 1, canblock = false},		--青城深渊_踉跄的青城弟子

[38073] = {locktarget = 2, canblock = false},		--青城深渊_乌鸦
[38074] = {locktarget = 1, canblock = false},		--青城深渊_尸傀
[38075] = {locktarget = 1, canblock = true},		--青城深渊_木高峰一阶

[38077] = {locktarget = 2, canblock = false},		--青城深渊_BOSS战尸傀
[38078] = {locktarget = 1, canblock = true},		--青城深渊_岳灵珊

[55460] = {locktarget = 1, canblock = true},		--随机事件四秀1侯人英

[55461] = {locktarget = 1, canblock = true},		--随机事件四秀2洪人雄

[55462] = {locktarget = 1, canblock = true},		--随机事件四秀3于人豪

[55463] = {locktarget = 1, canblock = true},		--随机事件四秀4罗人杰

[55464] = {locktarget = 1, canblock = false},		--随机事件手雷兵

[55465] = {locktarget = 1, canblock = false},		--随机事件青城近战兵

[55466] = {locktarget = 1, canblock = true},		--随机事件青城近战精英
[38077] = {locktarget = 1, canblock = false},		--青城深渊_boss尸傀
[60713] = {locktarget = 1, canblock = false},		--青城深渊_无主尸傀
[55467] = {locktarget = 1, canblock = true},		--随机事件青城跳劈精英
[34858] = {locktarget = 1, canblock = true},		--测试怪物行为丰富性

[35047] = {locktarget = 1, canblock = true},		--测试怪物受伤动作
[56358] = {locktarget = 2, canblock = false},		--镖局副本假面刺客
[56359] = {locktarget = 1, canblock = true},		--镖局副本蒙面杀手

[56360] = {locktarget = 2, canblock = false},		--镖局副本铁面暴僧
[59057] = {locktarget = 1, canblock = false},		--酒肆副本伏击弟子
[59058] = {locktarget = 1, canblock = true},		--酒肆副本伏击高手
[60632] = {locktarget = 1, canblock = true},		--孤岛副本BOSS丁勉
[67364] = {locktarget = 1, canblock = false},		--连云堡射手
[67365] = {locktarget = 1, canblock = false},		--连云堡刀客
[67367] = {locktarget = 1, canblock = false},		--连云堡大刀
[67368] = {locktarget = 1, canblock = false},		--连云堡拳师
[67369] = {locktarget = 1, canblock = false},		--连云堡醉刀
[67599] = {locktarget = 3, canblock = false},		--山崖副本女徒
[83863] = {locktarget = 1, canblock = false},		--嵩山之巅单剑
[83864] = {locktarget = 1, canblock = false},		--嵩山之巅重剑
[83865] = {locktarget = 1, canblock = false},		--嵩山之巅转轮
[83866] = {locktarget = 1, canblock = false},		--嵩山之巅全套
[83867] = {locktarget = 1, canblock = false},		--嵩山之巅暗器
[83868] = {locktarget = 1, canblock = false},		--嵩山之巅八公
[83869] = {locktarget = 1, canblock = false},		--嵩山之巅钟镇
[83871] = {locktarget = 1, canblock = false},		--嵩山之巅冷禅
[85096] = {locktarget = 1, canblock = false},		--嵩山之巅冷禅
[83829] = {locktarget = 1, canblock = false},		--嵩山之路单剑
[83830] = {locktarget = 1, canblock = false},		--嵩山之路重剑
[83831] = {locktarget = 1, canblock = false},		--嵩山之路转轮
[83833] = {locktarget = 1, canblock = false},		--嵩山之路叛门武当
[83834] = {locktarget = 1, canblock = false},		--嵩山之路叛门华山
[83835] = {locktarget = 1, canblock = false},		--嵩山之路叛门峨眉
[83836] = {locktarget = 1, canblock = false},		--嵩山之路叛门日月
[83838] = {locktarget = 1, canblock = false},		--嵩山之路卜沉
[83839] = {locktarget = 1, canblock = false},		--嵩山之路沙天江
[83841] = {locktarget = 1, canblock = false},		--嵩山之路乐厚
[83893] = {locktarget = 1, canblock = false},		--嵩山之路转剑
[83894] = {locktarget = 1, canblock = false},		--嵩山之路阵法
[84640] = {locktarget = 1, canblock = false},		--嵩山之路单剑
[84641] = {locktarget = 1, canblock = false},		--嵩山之路重剑
[84642] = {locktarget = 1, canblock = false},		--嵩山之路转轮
[85953] = {locktarget = 1, canblock = false},		--大漠三环陆海
}
--------------------------------------------------------------------
MonsterVisual.AttributeName[26521] = --[[!AUTO_140]]"[Lead]"
MonsterVisual.AttributeName[26522] = --[[!AUTO_141]]"[Trouble]"
MonsterVisual.AttributeName[26523] = --[[!AUTO_142]]"[Trouble]"
MonsterVisual.AttributeName[26524] = --[[!AUTO_143]]"[Trouble]"
MonsterVisual.AttributeName[26525] = --[[!AUTO_144]]"[Trouble]"
MonsterVisual.AttributeName[26526] = --[[!AUTO_145]]"[Lead]"
MonsterVisual.AttributeName[26527] = --[[!AUTO_146]]"[Lead]"
MonsterVisual.AttributeName[26528] = --[[!AUTO_147]]"[Trouble]"
MonsterVisual.AttributeName[26529] = --[[!AUTO_148]]"[Trouble]"
MonsterVisual.AttributeName[26530] = --[[!AUTO_149]]"[Trouble]"
MonsterVisual.AttributeName[26531] = --[[!AUTO_150]]"[Trouble]"
MonsterVisual.AttributeName[26534] = --[[!AUTO_151]]"[Trouble]"
MonsterVisual.AttributeName[26535] = --[[!AUTO_152]]"[Trouble]"
MonsterVisual.AttributeName[26536] = --[[!AUTO_153]]"[Lead]"
MonsterVisual.AttributeName[26537] = --[[!AUTO_154]]"[Trouble]"
MonsterVisual.AttributeName[26538] = --[[!AUTO_155]]"[Trouble]"
MonsterVisual.AttributeName[26539] = --[[!AUTO_156]]"[Trouble]"
MonsterVisual.AttributeName[26540] = --[[!AUTO_157]]"[Trouble]"
MonsterVisual.AttributeName[26541] = --[[!AUTO_158]]"[Trouble]"
MonsterVisual.AttributeName[26542] = --[[!AUTO_159]]"[Lead]"
MonsterVisual.AttributeName[26543] = --[[!AUTO_160]]"[Lead]"
MonsterVisual.AttributeName[26544] = --[[!AUTO_161]]"[Trouble]"
MonsterVisual.AttributeName[26545] = --[[!AUTO_162]]"[Trouble]"
MonsterVisual.AttributeName[26546] = --[[!AUTO_163]]"[Trouble]"
MonsterVisual.AttributeName[26547] = --[[!AUTO_164]]"[Lead]"
MonsterVisual.AttributeName[26548] = --[[!AUTO_165]]"[Lead]"
MonsterVisual.AttributeName[26549] = --[[!AUTO_166]]"[Trouble]"
MonsterVisual.AttributeName[26550] = --[[!AUTO_167]]"[Trouble]"
MonsterVisual.AttributeName[26551] = --[[!AUTO_168]]"[Trouble]"
MonsterVisual.AttributeName[26552] = --[[!AUTO_169]]"[Trouble]"
MonsterVisual.AttributeName[26553] = --[[!AUTO_170]]"[Lead]"
MonsterVisual.AttributeName[26554] = --[[!AUTO_171]]"[Trouble]"
MonsterVisual.AttributeName[26555] = --[[!AUTO_172]]"[Trouble]"
MonsterVisual.AttributeName[26556] = --[[!AUTO_173]]"[Trouble]"
MonsterVisual.AttributeName[26557] = --[[!AUTO_174]]"[Lead]"
MonsterVisual.AttributeName[26558] = --[[!AUTO_175]]"[Lead]"
MonsterVisual.AttributeName[26559] = --[[!AUTO_176]]"[Trouble]"
MonsterVisual.AttributeName[26560] = --[[!AUTO_177]]"[Trouble]"
MonsterVisual.AttributeName[26561] = --[[!AUTO_178]]"[Trouble]"
MonsterVisual.AttributeName[26562] = --[[!AUTO_179]]"[Trouble]"
MonsterVisual.AttributeName[26563] = --[[!AUTO_180]]"[Trouble]"
MonsterVisual.AttributeName[26564] = --[[!AUTO_181]]"[Trouble]"
MonsterVisual.AttributeName[26565] = --[[!AUTO_182]]"[Trouble]"
MonsterVisual.AttributeName[26566] = --[[!AUTO_183]]"[Lead]"
MonsterVisual.AttributeName[26567] = --[[!AUTO_184]]"[Lead]"
MonsterVisual.AttributeName[26574] = --[[!AUTO_185]]"[Lead]"
MonsterVisual.AttributeName[26571] = --[[!AUTO_186]]"[Lead]"
MonsterVisual.AttributeName[26572] = --[[!AUTO_187]]"[Lead]"
MonsterVisual.AttributeName[26573] = --[[!AUTO_188]]"[Lead]"
MonsterVisual.AttributeName[26720] = --[[!AUTO_189]]"[Trouble]"
MonsterVisual.AttributeName[26721] = --[[!AUTO_190]]"[Trouble]"
MonsterVisual.AttributeName[26722] = --[[!AUTO_191]]"[Trouble]"
MonsterVisual.AttributeName[26723] = --[[!AUTO_192]]"[Trouble]"
MonsterVisual.AttributeName[26724] = --[[!AUTO_193]]"[Lead]"
MonsterVisual.AttributeName[26725] = --[[!AUTO_194]]"[Trouble]"
MonsterVisual.AttributeName[26575] = --[[!AUTO_195]]"[Trouble]"
MonsterVisual.AttributeName[26576] = --[[!AUTO_196]]"[Trouble]"
MonsterVisual.AttributeName[26577] = --[[!AUTO_197]]"[Lead]"
MonsterVisual.AttributeName[26578] = --[[!AUTO_198]]"[Trouble]"
MonsterVisual.AttributeName[26726] = --[[!AUTO_199]]"[Trouble]"
MonsterVisual.AttributeName[26579] = --[[!AUTO_200]]"[Trouble]"
MonsterVisual.AttributeName[26727] = --[[!AUTO_201]]"[Trouble]"
MonsterVisual.AttributeName[26580] = --[[!AUTO_202]]"[Lead]"
MonsterVisual.AttributeName[26581] = --[[!AUTO_203]]"[Trouble]"
MonsterVisual.AttributeName[26582] = --[[!AUTO_204]]"[Trouble]"
MonsterVisual.AttributeName[26583] = --[[!AUTO_205]]"[Lead]"
MonsterVisual.AttributeName[26584] = --[[!AUTO_206]]"[Trouble]"
MonsterVisual.AttributeName[26585] = --[[!AUTO_207]]"[Trouble]"
MonsterVisual.AttributeName[26586] = --[[!AUTO_208]]"[Trouble]"
MonsterVisual.AttributeName[26587] = --[[!AUTO_209]]"[Trouble]"
MonsterVisual.AttributeName[26588] = --[[!AUTO_210]]"[Lead]"
MonsterVisual.AttributeName[26589] = --[[!AUTO_211]]"[Trouble]"
MonsterVisual.AttributeName[26590] = --[[!AUTO_212]]"[Trouble]"
MonsterVisual.AttributeName[26591] = --[[!AUTO_213]]"[Trouble]"
MonsterVisual.AttributeName[26592] = --[[!AUTO_214]]"[Trouble]"
MonsterVisual.AttributeName[26593] = --[[!AUTO_215]]"[Lead]"
MonsterVisual.AttributeName[26594] = --[[!AUTO_216]]"[Lead]"
MonsterVisual.AttributeName[26595] = --[[!AUTO_217]]"[Trouble]"
MonsterVisual.AttributeName[26596] = --[[!AUTO_218]]"[Trouble]"
MonsterVisual.AttributeName[26597] = --[[!AUTO_219]]"[Trouble]"
MonsterVisual.AttributeName[26598] = --[[!AUTO_220]]"[Trouble]"
MonsterVisual.AttributeName[26599] = --[[!AUTO_221]]"[Lead]"
MonsterVisual.AttributeName[26601] = --[[!AUTO_222]]"[Trouble]"
MonsterVisual.AttributeName[26600] = --[[!AUTO_223]]"[Trouble]"
MonsterVisual.AttributeName[26602] = --[[!AUTO_224]]"[Trouble]"
MonsterVisual.AttributeName[26603] = --[[!AUTO_225]]"[Trouble]"
MonsterVisual.AttributeName[26608] = --[[!AUTO_226]]"[Lead]"
MonsterVisual.AttributeName[26604] = --[[!AUTO_227]]"[Lead]"
MonsterVisual.AttributeName[26605] = --[[!AUTO_228]]"[Trouble]"
MonsterVisual.AttributeName[26607] = --[[!AUTO_229]]"[Trouble]"
MonsterVisual.AttributeName[26606] = --[[!AUTO_230]]"[Trouble]"
MonsterVisual.AttributeName[26656] = --[[!AUTO_231]]"[Sentry]"
MonsterVisual.AttributeName[26657] = --[[!AUTO_232]]"[Sentry]"
MonsterVisual.AttributeName[26658] = --[[!AUTO_233]]"[Scout]"
MonsterVisual.AttributeName[26659] = --[[!AUTO_234]]"[Scout]"
MonsterVisual.AttributeName[26660] = --[[!AUTO_235]]"[Scout]"
MonsterVisual.AttributeName[26661] = --[[!AUTO_236]]"[Scout]"
MonsterVisual.AttributeName[26662] = --[[!AUTO_237]]"[Sentry]"
MonsterVisual.AttributeName[26663] = --[[!AUTO_238]]"[Scout]"
MonsterVisual.AttributeName[26664] = --[[!AUTO_239]]"[Guard]"
MonsterVisual.AttributeName[26665] = --[[!AUTO_240]]"[Sentry]"
MonsterVisual.AttributeName[26666] = --[[!AUTO_241]]"[Scout]"
MonsterVisual.AttributeName[26728] = --[[!AUTO_242]]"[Guard]"
MonsterVisual.AttributeName[26667] = --[[!AUTO_243]]"[Sentry]"
MonsterVisual.AttributeName[26668] = --[[!AUTO_244]]"[Guard]"
MonsterVisual.AttributeName[26669] = --[[!AUTO_245]]"[Scout]"
MonsterVisual.AttributeName[26670] = --[[!AUTO_246]]"[Sentry]"
MonsterVisual.AttributeName[26671] = --[[!AUTO_247]]"[Scout]"
MonsterVisual.AttributeName[26672] = --[[!AUTO_248]]"[Scout]"
MonsterVisual.AttributeName[26673] = --[[!AUTO_249]]"[Scout]"
MonsterVisual.AttributeName[26674] = --[[!AUTO_250]]"[Sentry]"
MonsterVisual.AttributeName[26675] = --[[!AUTO_251]]"[Scout]"
MonsterVisual.AttributeName[26676] = --[[!AUTO_252]]"[Scout]"
MonsterVisual.AttributeName[26677] = --[[!AUTO_253]]"[Scout]"
MonsterVisual.AttributeName[26678] = --[[!AUTO_254]]"[Scout]"
MonsterVisual.AttributeName[26679] = --[[!AUTO_255]]"[Scout]"
MonsterVisual.AttributeName[26680] = --[[!AUTO_256]]"[Scout]"
MonsterVisual.AttributeName[26681] = --[[!AUTO_257]]"[Sentry]"
MonsterVisual.AttributeName[26682] = --[[!AUTO_258]]"[Scout]"
MonsterVisual.AttributeName[26683] = --[[!AUTO_259]]"[Guard]"
MonsterVisual.AttributeName[26684] = --[[!AUTO_260]]"[Sentry]"
MonsterVisual.AttributeName[26685] = --[[!AUTO_261]]"[Scout]"
MonsterVisual.AttributeName[26686] = --[[!AUTO_262]]"[Guard]"
MonsterVisual.AttributeName[26687] = --[[!AUTO_263]]"[Scout]"
MonsterVisual.AttributeName[26688] = --[[!AUTO_264]]"[Scout]"
MonsterVisual.AttributeName[26689] = --[[!AUTO_265]]"[Scout]"
MonsterVisual.AttributeName[26690] = --[[!AUTO_266]]"[Sentry]"
MonsterVisual.AttributeName[26691] = --[[!AUTO_267]]"[Scout]"
MonsterVisual.AttributeName[26692] = --[[!AUTO_268]]"[Guard]"
MonsterVisual.AttributeName[26693] = --[[!AUTO_269]]"[Sentry]"
MonsterVisual.AttributeName[26694] = --[[!AUTO_270]]"[Guard]"
MonsterVisual.AttributeName[26695] = --[[!AUTO_271]]"[Scout]"
MonsterVisual.AttributeName[26696] = --[[!AUTO_272]]"[Scout]"
MonsterVisual.AttributeName[26697] = --[[!AUTO_273]]"[Scout]"
MonsterVisual.AttributeName[26698] = --[[!AUTO_274]]"[Guard]"
MonsterVisual.AttributeName[26699] = --[[!AUTO_275]]"[Scout]"
MonsterVisual.AttributeName[26700] = --[[!AUTO_276]]"[Scout]"
MonsterVisual.AttributeName[26701] = --[[!AUTO_277]]"[Sentry]"
MonsterVisual.AttributeName[26702] = --[[!AUTO_278]]"[Scout]"
MonsterVisual.AttributeName[26703] = --[[!AUTO_279]]"[Scout]"
MonsterVisual.AttributeName[26704] = --[[!AUTO_280]]"[Scout]"
MonsterVisual.AttributeName[26705] = --[[!AUTO_281]]"[Scout]"
MonsterVisual.AttributeName[26706] = --[[!AUTO_282]]"[Sentry]"
MonsterVisual.AttributeName[26707] = --[[!AUTO_283]]"[Scout]"
MonsterVisual.AttributeName[26708] = --[[!AUTO_284]]"[Guard]"
MonsterVisual.AttributeName[26709] = --[[!AUTO_285]]"[Scout]"
MonsterVisual.AttributeName[26710] = --[[!AUTO_286]]"[Guard]"
MonsterVisual.AttributeName[26711] = --[[!AUTO_287]]"[Sentry]"
MonsterVisual.AttributeName[26712] = --[[!AUTO_288]]"[Scout]"
MonsterVisual.AttributeName[26713] = --[[!AUTO_289]]"[Guard]"
MonsterVisual.AttributeName[26714] = --[[!AUTO_290]]"[Sentry]"
MonsterVisual.AttributeName[26715] = --[[!AUTO_291]]"[Scout]"
MonsterVisual.AttributeName[26716] = --[[!AUTO_292]]"[Guard]"
MonsterVisual.AttributeName[26717] = --[[!AUTO_293]]"[Scout]"
MonsterVisual.AttributeName[26718] = --[[!AUTO_294]]"[Scout]"
MonsterVisual.AttributeName[26719] = --[[!AUTO_295]]"[Scout]"
MonsterVisual.AttributeName[26729] = --[[!AUTO_296]]"[Sentry]"
MonsterVisual.AttributeName[26730] = --[[!AUTO_297]]"[Sentry]"
MonsterVisual.AttributeName[26731] = --[[!AUTO_298]]"[Sentry]"
MonsterVisual.AttributeName[26732] = --[[!AUTO_299]]"[Scout]"
MonsterVisual.AttributeName[26733] = --[[!AUTO_300]]"[Scout]"
MonsterVisual.AttributeName[26734] = --[[!AUTO_301]]"[Scout]"
MonsterVisual.AttributeName[26735] = --[[!AUTO_302]]"[Scout]"
MonsterVisual.AttributeName[26736] = --[[!AUTO_303]]"[Sentry]"
MonsterVisual.AttributeName[27165] = --[[!AUTO_304]]"[Sentry]"
MonsterVisual.AttributeName[27166] = --[[!AUTO_305]]"[Sentry]"
MonsterVisual.AttributeName[27167] = --[[!AUTO_306]]"[Sentry]"
MonsterVisual.AttributeName[27168] = --[[!AUTO_307]]"[Sentry]"
MonsterVisual.AttributeName[27169] = --[[!AUTO_308]]"[Scout]"
MonsterVisual.AttributeName[27170] = --[[!AUTO_309]]"[Scout]"
MonsterVisual.AttributeName[27171] = --[[!AUTO_310]]"[Scout]"
MonsterVisual.AttributeName[27172] = --[[!AUTO_311]]"[Scout]"
MonsterVisual.AttributeName[27173] = --[[!AUTO_312]]"[Guard]"
MonsterVisual.AttributeName[27174] = --[[!AUTO_313]]"[Guard]"
MonsterVisual.AttributeName[27175] = --[[!AUTO_314]]"[Guard]"
MonsterVisual.AttributeName[27176] = --[[!AUTO_315]]"[Guard]"
MonsterVisual.AttributeName[27177] = --[[!AUTO_316]]"[Guard]"
MonsterVisual.AttributeName[27178] = --[[!AUTO_317]]"[Guard]"
MonsterVisual.AttributeName[27153] = --[[!AUTO_318]]"[Eliminate Evil]"
MonsterVisual.AttributeName[27154] = --[[!AUTO_319]]"[Eliminate Evil]"
MonsterVisual.AttributeName[27155] = --[[!AUTO_320]]"[Eliminate Evil]"
MonsterVisual.AttributeName[27156] = --[[!AUTO_321]]"[Eliminate Evil]"
MonsterVisual.AttributeName[27157] = --[[!AUTO_322]]"[Eliminate Evil]"
MonsterVisual.AttributeName[27158] = --[[!AUTO_323]]"[Eliminate Evil]"
MonsterVisual.AttributeName[27159] = --[[!AUTO_324]]"[Eliminate Evil]"
MonsterVisual.AttributeName[27160] = --[[!AUTO_325]]"[Eliminate Evil]"
MonsterVisual.AttributeName[27161] = --[[!AUTO_326]]"[Eliminate Evil]"
MonsterVisual.AttributeName[27162] = --[[!AUTO_327]]"[Eliminate Evil]"
MonsterVisual.AttributeName[27163] = --[[!AUTO_328]]"[Eliminate Evil]"
MonsterVisual.AttributeName[27164] = --[[!AUTO_329]]"[Eliminate Evil]"
--------------------------------------------------------------------

MonsterVisual.MonsterNotes[3461] = --[[!AUTO_330]]"Plum Fortress Mob\rNormal Humanoid Monster\rCommon pawn from bandit camps. Knows some basic sword moves.\rAttack Damage ★\rDefense: ★\rHP: ★\rBattle EXP: ☆\rSkill: \rStone Breaks: sword skill containing 2 heavy blows.\rJianghu Evaluation: Nameless Rabble"
MonsterVisual.MonsterNotes[3466] = --[[!AUTO_331]]"Mountain Patrol Captain\rNormal Humanoid Monster\rUseless grass-root subchief from Old Plum Road's camps. Actually the difference between him and average monsters is very little.\rAttack Damage: ★\rDefense: ★\rHP: ★\rBattle EXP: ☆\rSkill: \rAutumn Wind-Blow: A skill that can dodge lower attacks when you attack.\rJianghu Evaluation: Nameless Rabble"
MonsterVisual.MonsterNotes[3467] = --[[!AUTO_332]]"Pangolin\rNormal Animal Monster\rSpreads in every corner of Old Plum Road. Good at digging.\rAttack Damage: ★\rDefense: ★☆\rHP: ★\rBattle EXP:☆\rFeature: \rScaled: Cover your body with scales that can reduce Exo-Damage.\rSkill: \rAcid Liquid: Pangolin's tongue is covered by acid that can lower its target's Armor Points.\rJianghu Evaluation: Harmless Wildlife"
MonsterVisual.MonsterNotes[3468] = --[[!AUTO_333]]"Plum Road Sentry\rNormal Humanoid Monster\rCommon pawn from bandit camps. Knows some basic spear moves. But he is very careful with sharp eye and hearing. Therefore has a place in Plum Camp.\rAttack Damage: ★☆\rDefense: ★☆\rHP: ★\rBattle EXP: ★☆\rSkill: \rBack Thrusting: An imitation of the famous spear technique Back-Thrusting Spear. Can cause serious damage.\rJianghu Evaluation: Nameless Rabble"
MonsterVisual.MonsterNotes[3470] = --[[!AUTO_334]]"Horned Buffalo\rNormal Animal Monster\rHorned Buffalo spreads in the middle part of Old Plum Road. It is a mild and slow animal. But it can be furious and dangerous when it is angered.\rAttack Damage: ★\rDefense: ★☆\rHP: ★★\rBattle EXP: ★\rFeature: \rEndless Power: can blow away or knock down targets in Vulnerable Status with almost any skill.\rJianghu Evaluation: Feral Predator"
MonsterVisual.MonsterNotes[3472] = --[[!AUTO_335]]"Razor Bandit\rNormal Humanoid Monster\rCommon pawn from bandit camps. His sword skill is a little better than the minors, but not much better.\rAttack Damage: ★\rDefense: ★\rHP: ★\rBattle EXP: ★\rSkill: \rStone Breaks: sword skill containing 2 heavy blows.\rJianghu Evaluation: Nameless Rabble"
MonsterVisual.MonsterNotes[3473] = --[[!AUTO_336]]"Spike Bandit\rNormal Humanoid Monster\rCommon pawn from bandit camps. His spear skill is a little better than his minors, but not much better.\rAttack Damage: ★\rDefense: ★\rHP: ★\rBattle EXP: ★\rSkill: \rBack Thrusting: a skill inspired by the famous spear technique Back-Thrusting Spear. Can deal serious damage to the target.\rJianghu Evaluation: Nameless Rabble"
MonsterVisual.MonsterNotes[3474] = --[[!AUTO_337]]"Sturdy Iron\rHumanoid Leader\rLeader of the Bandits of the Plumstead. Uses a big mace, which is quite skillful in his hand.\rAttack Damage:★★★\rDefense: ★★★\rHP: ★★★\rBattle EXP: ★★★\rSkill: \rBlasting Wind: a strong blow that can attack all the enemies within a sector area before you and blow away those in Vulnerable Status. \rChaotic Genesis: use mace to smash the area before you violently and cause enormous damage.\rJianghu Evaluation: Veteran Gangster"
MonsterVisual.MonsterNotes[4857] = --[[!AUTO_338]]"Plum Road Commando\rNormal Humanoid Monster\rThe strongest one among the Bandits of Plumstead. Ready to die for the gang anytime.\rAttack Damage: ★★\rDefense: ☆\rHP: ★\rBattle EXP: ★☆\rSkill: \rStone Breaks: sword skill containing 2 heavy blows.\rJianghu Evaluation: Street Thug"
MonsterVisual.MonsterNotes[3475] = --[[!AUTO_339]]"Leaf Blade Thrower\rNormal Humanoid Monster\rThe weakest one among the Bandits of Plumstead. But he is good at tools.\rAttack Damage: ★\rDefense: ☆\rHP: ★\rBattle EXP: ★☆\rSkill: \rChain Kick: a kicking skill that can kick back nearby targets.\rJianghu Evaluation: Nameless Rabble"
MonsterVisual.MonsterNotes[6052] = --[[!AUTO_340]]"Shura Swordbearer\rNormal Humanoid Monster\rA rare backhand swordsman who's good at stabbing and poking. Hangs around in Wu-Tang for unknown reason.\rAttack Damage: ★\rDefense: ★\rHP: ★\rBattle EXP: ★☆\rFeature: \rBack Thone: gifted with 5% Critical Chance when using a sword.\rJianghu Evaluation: Local Bully"

--------------------------------------------------------------------

MonsterVisual.MonsterAttribute[26421] = {11334,--[[!AUTO_341]]"Basic HP Enhancement: \rIncreases a little max HP for monsters, according to monster's level."}
MonsterVisual.MonsterAttribute[26422] = {11335,--[[!AUTO_342]]"Medium HP Enhancement: \rIncreases some max HP for monsters, according to monster's level."}
MonsterVisual.MonsterAttribute[26423] = {11336,--[[!AUTO_343]]"Advanced HP Enhancement: \rIncreases a lot of max HP for monsters, according to monster's level."}
MonsterVisual.MonsterAttribute[26424] = {11337,--[[!AUTO_344]]"Supreme HP Enhancement: \rIncreases a great deal of max HP for monsters, according to monster's level."}
MonsterVisual.MonsterAttribute[26425] = {11334,--[[!AUTO_345]]"Basic HP Enhancement: \rIncreases a little max HP for monsters, according to monster's level."}
MonsterVisual.MonsterAttribute[26426] = {11335,--[[!AUTO_346]]"Medium HP Enhancement: \rIncreases some max HP for monsters, according to monster's level."}
MonsterVisual.MonsterAttribute[26427] = {11336,--[[!AUTO_347]]"Advanced HP Enhancement: \rIncreases a lot of max HP for monsters, according to monster's level."}
MonsterVisual.MonsterAttribute[26428] = {11337,--[[!AUTO_348]]"Supreme HP Enhancement: \rIncreases a great deal of max HP for monsters, according to monster's level."}
MonsterVisual.MonsterAttribute[26429] = {11334,--[[!AUTO_349]]"Basic HP Enhancement: \rIncreases a little max HP for monsters, according to monster's level."}
MonsterVisual.MonsterAttribute[26430] = {11335,--[[!AUTO_350]]"Medium HP Enhancement: \rIncreases some max HP for monsters, according to monster's level."}
MonsterVisual.MonsterAttribute[26431] = {11336,--[[!AUTO_351]]"Advanced HP Enhancement: \rIncreases a lot of max HP for monsters, according to monster's level."}
MonsterVisual.MonsterAttribute[26432] = {11337,--[[!AUTO_352]]"Supreme HP Enhancement: \rIncreases a great deal of max HP for monsters, according to monster's level."}
MonsterVisual.MonsterAttribute[26433] = {11338,--[[!AUTO_353]]"Basic Vulnerability Infliction: \rIncreases a little max Vulnerability for monsters."}
MonsterVisual.MonsterAttribute[26434] = {11339,--[[!AUTO_354]]"Medium Vulnerability Infliction: \rIncreases some max Vulnerability for monsters."}
MonsterVisual.MonsterAttribute[26435] = {11340,--[[!AUTO_355]]"Advanced Vulnerability Infliction: \rIncreases a lot of max Vulnerability for monsters."}
MonsterVisual.MonsterAttribute[26436] = {11341,--[[!AUTO_356]]"Supreme Vulnerability Infliction: \rIncreases a great deal of max Vulnerability for monsters."}
MonsterVisual.MonsterAttribute[26437] = {11342,--[[!AUTO_357]]"Steady Moves: \rMonster's Exo-Attack floating range reduced, and gets closer to max damage."}
MonsterVisual.MonsterAttribute[26438] = {11343,--[[!AUTO_358]]"Raging Attack: \rMonster's Exo-Attack floating range enlarged, and max damage increased."}
MonsterVisual.MonsterAttribute[26439] = {11344,--[[!AUTO_359]]"Basic Exo-Attack Boost: \rIncreases a little Exo-Attack damage for monsters."}
MonsterVisual.MonsterAttribute[26440] = {11345,--[[!AUTO_360]]"Medium Exo-Attack Boost: \rIncreases some Exo-Attack damage for monsters."}
MonsterVisual.MonsterAttribute[26441] = {11346,--[[!AUTO_361]]"Advanced Exo-Attack Boost: \rIncreases a lot of Exo-Attack damage for monsters."}
MonsterVisual.MonsterAttribute[26442] = {11347,--[[!AUTO_362]]"Supreme Exo-Attack Boost: \rIncreases a great deal of Exo-Attack damage for monsters."}
MonsterVisual.MonsterAttribute[26443] = {11348,--[[!AUTO_363]]"Armor Boost: \rMonster's Armor Points increased."}
MonsterVisual.MonsterAttribute[26444] = {11349,--[[!AUTO_364]]"Exo-Critical Chance: \rGreatly increases monster's Exo-Critical Chance."}
MonsterVisual.MonsterAttribute[26445] = {11350,--[[!AUTO_365]]"Exo-Critical Strike: \rGreatly increases monster's Exo-Critical Strike damage."}
MonsterVisual.MonsterAttribute[26446] = {11351,--[[!AUTO_366]]"Calm: \rMonster's Endo-Attack floating range reduced, and gets closer to max damage."}
MonsterVisual.MonsterAttribute[26447] = {11352,--[[!AUTO_367]]"Emotional:  \rMonster's Endo-Attack floating range enlarged, and max damage increased."}
MonsterVisual.MonsterAttribute[26448] = {11353,--[[!AUTO_368]]"Basic Endo-Attack Boost: \rIncreases a little Endo-Attack damage for monsters."}
MonsterVisual.MonsterAttribute[26449] = {11354,--[[!AUTO_369]]"Medium Endo-Attack Boost: \rIncreases some Endo-Attack damage for monsters."}
MonsterVisual.MonsterAttribute[26450] = {11355,--[[!AUTO_370]]"Advanced Endo-Attack Boost: \rIncreases a lot of Endo-Attack damage for monsters."}
MonsterVisual.MonsterAttribute[26451] = {11356,--[[!AUTO_371]]"Supreme Endo-Attack Boost: \rIncreases a great deal of Endo-Attack damage for monsters."}
MonsterVisual.MonsterAttribute[26452] = {11357,--[[!AUTO_372]]"Endo-Defense Boost: \rIncreases monster's Endo-Defense."}
MonsterVisual.MonsterAttribute[26453] = {11358,--[[!AUTO_373]]"Endo-Critical Chance: \rGreatly increases monster's Endo-Critical Chance."}
MonsterVisual.MonsterAttribute[26454] = {11359,--[[!AUTO_374]]"Endo-Critical Strike: \rGreatly increases monster's Endo-Critical Strike damage."}
MonsterVisual.MonsterAttribute[26455] = {11360,--[[!AUTO_375]]"Speed Boost: \rGreatly increases monster's movement speed."}
MonsterVisual.MonsterAttribute[26456] = {11361,--[[!AUTO_376]]"Basic Flame Resistance: \rIncreases a little Flame Resistance for monsters."}
MonsterVisual.MonsterAttribute[26457] = {11362,--[[!AUTO_377]]"Medium Flame Resistance: \rIncreases some Flame Resistance for monsters."}
MonsterVisual.MonsterAttribute[26458] = {11363,--[[!AUTO_378]]"Advanced Flame Resistance: \rIncreases a lot of Flame Resistance for monsters."}
MonsterVisual.MonsterAttribute[26459] = {11364,--[[!AUTO_379]]"Supreme Flame Resistance: \rIncreases a great deal of Flame Resistance for monsters."}
MonsterVisual.MonsterAttribute[26460] = {11365,--[[!AUTO_380]]"Basic Ice Resistance: \rIncreases a little Ice Resistance for monsters."}
MonsterVisual.MonsterAttribute[26461] = {11366,--[[!AUTO_381]]"Medium Ice Resistance: \rIncreases some Ice Resistance for monsters."}
MonsterVisual.MonsterAttribute[26462] = {11367,--[[!AUTO_382]]"Advanced Ice Resistance: \rIncreases a lot of Ice Resistance for monsters."}
MonsterVisual.MonsterAttribute[26463] = {11368,--[[!AUTO_383]]"Supreme Ice Resistance: \rIncreases a great deal of Ice Resistance for monsters."}
MonsterVisual.MonsterAttribute[26464] = {11369,--[[!AUTO_384]]"Basic Venom Resistance: \rIncreases a little Venom Resistance for monsters."}
MonsterVisual.MonsterAttribute[26465] = {11370,--[[!AUTO_385]]"Medium Venom Resistance: \rIncreases some Venom Resistance for monsters."}
MonsterVisual.MonsterAttribute[26466] = {11371,--[[!AUTO_386]]"Advance Venom Resistance: \rIncreases a lot of Venom Resistance for monsters."}
MonsterVisual.MonsterAttribute[26467] = {11372,--[[!AUTO_387]]"Supreme Venom Resistance: \rIncreases a great deal of Venom Resistance for monsters."}
MonsterVisual.MonsterAttribute[26473] = {11373,--[[!AUTO_388]]"Snake Poison: \rHas a chance to poison target when normal attack."}
MonsterVisual.MonsterAttribute[26474] = {11374,--[[!AUTO_389]]"Thread Bind: \rHas a chance to immobilize target when attack."}
MonsterVisual.MonsterAttribute[26475] = {11375,--[[!AUTO_390]]"Red Eye: \rWhen monster enter fight over 10 seconds, its attack damage will be increased."}
MonsterVisual.MonsterAttribute[26476] = {11376,--[[!AUTO_391]]"Tiger Roar: \rRoars when HP at a certain percentage, reduces the attack damage of targets around."}
MonsterVisual.MonsterAttribute[26477] = {11377,--[[!AUTO_392]]"Acid: \rNormal attack has a chance to reduce its target's Armor Points."}
MonsterVisual.MonsterAttribute[26478] = {11378,--[[!AUTO_393]]"Sacrifice: \rBee will give its life, to shoot Poisonous Needle to targets. Suicide, target will be poisoned."}
MonsterVisual.MonsterAttribute[26479] = {11379,--[[!AUTO_394]]"Swarming: \rCrow always call its nearby companions to attack together when entering fight."}
MonsterVisual.MonsterAttribute[26480] = {11380,--[[!AUTO_395]]"Stagnant: \rVultures have higher max vulnerability than ordinary monsters."}
MonsterVisual.MonsterAttribute[26481] = {11381,--[[!AUTO_396]]"Crawling: \rSome upper part attack skills can not hit the normal state Weasel."}
MonsterVisual.MonsterAttribute[26482] = {11382,--[[!AUTO_397]]"Gas Defense: \rMinks often break wind to poison players when they are in danger."}
MonsterVisual.MonsterAttribute[26483] = {11383,--[[!AUTO_398]]"Swarming: \rCrow always call its nearby companions to attack together when entering fight."}
MonsterVisual.MonsterAttribute[26484] = {11384,--[[!AUTO_399]]"Perfect Creature: \rLeopard can not enter vulnerability state."}
MonsterVisual.MonsterAttribute[26485] = {11385,--[[!AUTO_400]]"Nimble: \rThis monster loves fighting, can adjust itself in battle. To recover vulnerability according to time."}
MonsterVisual.MonsterAttribute[26486] = {11386,--[[!AUTO_401]]"Crippling: \rThis monster will cause bonus vulnerability when attacks."}
MonsterVisual.MonsterAttribute[26487] = {11387,--[[!AUTO_402]]"Cunning: \rThis monster has a chance to make players blood when attacks."}
MonsterVisual.MonsterAttribute[26807] = {11388,--[[!AUTO_403]]"Coward: \rThis monster often runs away when fights."}
MonsterVisual.MonsterAttribute[26808] = {11389,--[[!AUTO_404]]"S.O.S: \rThis monster will call for help when fights."}
MonsterVisual.MonsterAttribute[26809] = {11390,--[[!AUTO_405]]"Self-healing: \rThis monster often recovers HP."}
MonsterVisual.MonsterAttribute[26818] = {11391,--[[!AUTO_406]]"Thick Skin: \rReduces a lot of taken damage for this monster."}
MonsterVisual.MonsterAttribute[26819] = {11392,--[[!AUTO_407]]"Controlling: \rThis monster's any attack will attach controlling effect when target's vulnerability is full."}
MonsterVisual.MonsterAttribute[26820] = {11393,--[[!AUTO_408]]"Blood Poison: \rThis monster will poison the current target when it lose half HP."}
MonsterVisual.MonsterAttribute[26821] = {11394,--[[!AUTO_409]]"Cowardice: \rOften runs away."}
MonsterVisual.MonsterAttribute[26822] = {11395,--[[!AUTO_410]]"Plant: \rHold still."}
MonsterVisual.MonsterAttribute[26823] = {11396,--[[!AUTO_411]]"Spiritual: \rDemon has higher Armor Points and Endo-Defense."}

--------------------------------------------------------------------

-- MonsterVisual.WalkRunBlendParams[模型路径ID] = {走的速度, 跑的速度, 走的组合动作名, 跑的组合动作名, 走跑的组合动作名}
MonsterVisual.WalkRunBlendParams[0]		= {1.5, 3.5, --[[!]]"行走", --[[!]]"战斗奔跑", --[[!]]"走跑"}	-- 默认配置
MonsterVisual.WalkRunBlendParams[13942]		= {3, 8, --[[!]]"行走", --[[!]]"战斗奔跑", --[[!]]"走跑"}		-- 嗜血和尚
MonsterVisual.WalkRunBlendParams[15239]		= {1.5, 5, --[[!]]"行走", --[[!]]"奔跑", --[[!]]"走跑"}		-- models\npcs\npcs\战斗npc\新日月教年轻女弟子\新日月教年轻女弟子.ecm
MonsterVisual.WalkRunBlendParams[15464]		= {0.7, 0.7, --[[!]]"行走", --[[!]]"行走", --[[!]]"走跑"}		-- Models\NPCs\NPCs\普通npc\花店小妹\花店小妹.ecm（如果一个普通的NPC，没有奔跑类动作，就把两个动作设一样，走的速度填对，跑和走一样就行）
MonsterVisual.WalkRunBlendParams[15465]		= {0.7, 0.7, --[[!]]"行走", --[[!]]"行走", --[[!]]"走跑"}		-- Models\NPCs\NPCs\普通npc\花店小妹02\花店小妹02.ecm
MonsterVisual.WalkRunBlendParams[7114]		= {0.7, 0.7, --[[!]]"行走", --[[!]]"行走", --[[!]]"走跑"}		-- Models\NPCs\NPCs\普通NPC\江南男童\江南男童.ecm
MonsterVisual.WalkRunBlendParams[16161]		= {20, 40, --[[!]]"行走", --[[!]]"行走", --[[!]]"走跑"}		-- Models\NPCs\怪物\boss\帮派专用boss独角兽\帮派专用boss独角兽.ecm
MonsterVisual.WalkRunBlendParams[16159]		= {3, 5, --[[!]]"行走", --[[!]]"战斗奔跑", --[[!]]"走跑"}		-- Models\NPCs\怪物\boss\帮派专用boss山猴小\帮派专用boss山猴小.ecm
MonsterVisual.WalkRunBlendParams[16157]		= {6, 10, --[[!]]"行走", --[[!]]"战斗奔跑", --[[!]]"走跑"}		-- Models\NPCs\怪物\boss\帮派专用boss山猴中\帮派专用boss山猴中.ecm
MonsterVisual.WalkRunBlendParams[16158]		= {14.4, 24, --[[!]]"行走", --[[!]]"行走", --[[!]]"走跑"}		-- Models\NPCs\怪物\boss\帮派专用boss山猴大\帮派专用boss山猴大.ecm
MonsterVisual.WalkRunBlendParams[16160]		= {12, 24, --[[!]]"行走", --[[!]]"行走", --[[!]]"走跑"}		-- Models\NPCs\怪物\boss\帮派专用boss巨蝎\帮派专用boss巨蝎.ecm
MonsterVisual.WalkRunBlendParams[16162]		= {15, 30, --[[!]]"行走", --[[!]]"行走", --[[!]]"走跑"}		-- Models\NPCs\怪物\boss\帮派专用boss白猿\帮派专用boss白猿.ecm
MonsterVisual.WalkRunBlendParams[16163]		= {7.5, 20, --[[!]]"行走", --[[!]]"行走", --[[!]]"走跑"}		-- Models\NPCs\怪物\boss\帮派专用boss野牛\帮派专用boss野牛.ecm
MonsterVisual.WalkRunBlendParams[20745]		= {1.5, 5, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\刃魔狼白\刃魔狼白.ecm
MonsterVisual.WalkRunBlendParams[20793]		= {5, 12, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\刃魔狼白\刃魔狼白大.ecm
MonsterVisual.WalkRunBlendParams[20774]		= {3.5, 8, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\剑冢鬼怪\剑冢鬼怪土.ecm
MonsterVisual.WalkRunBlendParams[20775]		= {3.5, 8, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\剑冢鬼怪\剑冢鬼怪木.ecm
MonsterVisual.WalkRunBlendParams[20776]		= {3.5, 8, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\剑冢鬼怪\剑冢鬼怪水.ecm
MonsterVisual.WalkRunBlendParams[20777]		= {3.5, 8, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\剑冢鬼怪\剑冢鬼怪火.ecm
MonsterVisual.WalkRunBlendParams[20778]		= {3.5, 8, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\剑冢鬼怪\剑冢鬼怪金.ecm
MonsterVisual.WalkRunBlendParams[20769]		= {3.5, 8, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\刑鬼\刑鬼土.ecm
MonsterVisual.WalkRunBlendParams[20770]		= {3.5, 8, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\刑鬼\刑鬼木.ecm
MonsterVisual.WalkRunBlendParams[20771]		= {3.5, 8, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\刑鬼\刑鬼水.ecm
MonsterVisual.WalkRunBlendParams[20772]		= {3.5, 8, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\刑鬼\刑鬼火.ecm
MonsterVisual.WalkRunBlendParams[20773]		= {3.5, 8, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\刑鬼\刑鬼金.ecm
MonsterVisual.WalkRunBlendParams[20787]		= {2.5, 6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\红衣女鬼\红衣女鬼土.ecm
MonsterVisual.WalkRunBlendParams[20788]		= {2.5, 6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\红衣女鬼\红衣女鬼木.ecm
MonsterVisual.WalkRunBlendParams[20789]		= {2.5, 6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\红衣女鬼\红衣女鬼水.ecm
MonsterVisual.WalkRunBlendParams[20790]		= {2.5, 6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\红衣女鬼\红衣女鬼火.ecm
MonsterVisual.WalkRunBlendParams[20791]		= {2.5, 6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\红衣女鬼\红衣女鬼金.ecm
MonsterVisual.WalkRunBlendParams[20779]		= {2.5, 6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\商旅亡魂\商旅亡魂土.ecm
MonsterVisual.WalkRunBlendParams[20780]		= {2.5, 6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\商旅亡魂\商旅亡魂木.ecm
MonsterVisual.WalkRunBlendParams[20781]		= {2.5, 6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\商旅亡魂\商旅亡魂水.ecm
MonsterVisual.WalkRunBlendParams[20782]		= {2.5, 6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\商旅亡魂\商旅亡魂火.ecm
MonsterVisual.WalkRunBlendParams[20783]		= {2.5, 6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\商旅亡魂\商旅亡魂金.ecm
MonsterVisual.WalkRunBlendParams[20786]		= {3.5, 7.5, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\死牢怨魂\死牢怨魂金.ecm
MonsterVisual.WalkRunBlendParams[20785]		= {3, 7, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\树甲人\树甲人木.ecm
MonsterVisual.WalkRunBlendParams[20792]		= {2.5, 6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\剑冢护剑流亡剑客\剑冢护剑流亡剑客水.ecm
MonsterVisual.WalkRunBlendParams[20767]		= {3, 7.5, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\机关\梅庄弩兽\梅庄弩兽火.ecm
MonsterVisual.WalkRunBlendParams[20766]		= {3.2, 7, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\人形\囚奴\囚奴土.ecm
MonsterVisual.WalkRunBlendParams[20784]		= {5, 12, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\鬼怪\恶鬼马车\恶鬼马车水.ecm
MonsterVisual.WalkRunBlendParams[20762]		= {3, 9, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\boss\剑冢邪兽\剑冢邪兽金.ecm
MonsterVisual.WalkRunBlendParams[20765]		= {2, 6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\boss\玄龟\玄龟木.ecm
MonsterVisual.WalkRunBlendParams[20763]		= {2.8, 6.6, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\boss\帮派专用boss山猴小\帮派专用boss山猴小水.ecm
MonsterVisual.WalkRunBlendParams[20764]		= {3, 7.2, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\boss\狱火麒麟兽\狱火麒麟兽火.ecm
MonsterVisual.WalkRunBlendParams[20768]		= {3, 7.2, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\怪物\神兽\陆吾\陆吾土.ecm
MonsterVisual.WalkRunBlendParams[7938]		= {3, 5, "Walk", "Battle Run", "Walk/Run"} -- Models\NPCs\NPCs\战斗NPC\戚继光\戚继光.ecm


MonsterVisual.DisableWRB = {}
--MonsterVisual.WalkRunBlendParams[1561]		= {3.5, 3.5, "行走", "战斗奔跑", "走跑"}		-- 吉人通1
--MonsterVisual.WalkRunBlendParams[15268]		= {3.5, 3.5, "行走", "战斗奔跑", "走跑"}		-- 吉人通2
MonsterVisual.DisableWRB[1561]		= true	-- 吉人通1
MonsterVisual.DisableWRB[15268]		= true	-- 吉人通2
MonsterVisual.DisableWRB[1556]		= true	-- 罗人杰1
MonsterVisual.DisableWRB[15167]		= true	-- 罗人杰2
MonsterVisual.DisableWRB[1024]		= true	-- 东岗掠夺者
MonsterVisual.DisableWRB[983]		= true	-- 泰山豹子
MonsterVisual.DisableWRB[20330]         = true  -- 秦军守卫兵
MonsterVisual.DisableWRB[23173]         = true  -- 少女鸢萝
--------------------------------------------------------------------
function MonsterVisual:GetMonsterActionConfig()
	return MonsterVisual.ForceAction
end
--------------------------------------------------------------------



-- 根据特性ID数组，得到面板的特性显示文字
-- arrProp: 特性ID数组
-- 返回：怪物特性的显示文字
function  MonsterVisual:GetPropName(arrProp)
    local propName = {}
	for k,v in pairs(arrProp) do
	if MonsterVisual.VisualName[v] then
		propName[k] = MonsterVisual.VisualName[v][1]
	end
	end
	return propName
end

-- 根据64位光效、特性组id，得到怪物的显示名字
-- arrGfx: 64位光效数组
-- templName: 模板名
-- idPropGroup: 特性组ID
function MonsterVisual:GetMonsterNameWithProp(arrGfx, templName, idPropGroup)
	--LogPrint("………………………………………………开始………………………………………………")
	if MonsterVisual.AttributeName[idPropGroup] then
		newName =  string.format(--[[!AUTO_412]]"%s%s",templName,MonsterVisual.AttributeName[idPropGroup])
	else
		newName = templName
	end
	return newName
	--local newGfxName = {}
	--for k,v in pairs(arrGfx) do
		--if MonsterVisual.GfxName[v] then
			--newGfxName[k] = MonsterVisual.GfxName[v][1]
		--else
			--newGfxName[k] = ""
		--end
	--end
	--local newName = ""
	--if #newGfxName > 0 then
	--	newName =  string.format("%s%s",newGfxName[math.random(1,#newGfxName)],templName)
	--else
	--	newName = templName
	--end
	--return newName
end


-- 根据模板id、特性组id、特性id数组，得到怪物的悬浮
-- tid: 怪物模板id
-- templName: 模板名
-- idPropGroup: 特性组ID
-- arrProp: 特性ID数组
function MonsterVisual:GetMonsterHint(tid, templName, idPropGroup, arrProp)

	local strHint = --[[!AUTO_413]]""
	if MonsterVisual.MonsterNotes[tid] then
	strHint = MonsterVisual.MonsterNotes[tid]
	else
	-- TODO: ...
	strHint = templName
	end
	return strHint
end

-- 根据特性id，得到特性的图标id、悬浮说明
-- idSpec: 怪物特性id
--需要显示但没图标idIcon = 0，完全不显示idIcon = -1
function MonsterVisual:GetMonsterSpecialtyInfo(idSpec)

	local idIcon = 0
	local strHint = --[[!AUTO_414]]""
	if MonsterVisual.MonsterAttribute[idSpec] then
	idIcon = MonsterVisual.MonsterAttribute[idSpec][1]
	strHint = MonsterVisual.MonsterAttribute[idSpec][2]
	--TODO: ...
	else
	idIcon = -1
	end
	return idIcon, strHint
end

-------------------------------------
--	Loot：4种模型的前缀名
-------------------------------------

LootModelNamePrefix =
{
	["default"] =
	{
		--[[!AUTO_415]]"",			-- 模型1对应的前缀
		--[[!]]"涨鼓鼓的",		-- 模型2对应的前缀
		--[[!]]"闪闪发光的",		-- 模型3对应的前缀
		--[[!]]"巨牛百的",		-- 模型4对应的前缀
	},

	--	各个loot模板tid可单独配置
	--[123] = ...
}

-- tidLoot:	loot的模板id
-- idxModel:	模型索引，0 ~ 3
function MonsterVisual:GetLootModelNamePrefix(tidLoot, idxModel)

	local Prefix = --[[!AUTO_416]]""

	local tabLoot = LootModelNamePrefix[tidLoot]
	if tabLoot == nil then
		tabLoot = LootModelNamePrefix["default"]
	end

	if tabLoot ~= nil then
		Prefix = tabLoot[idxModel + 1]
	end

	return Prefix

end

-- 组合怪物描述函数
function MonsterVisual:GetMonsterDesc(tid)

	tbl = {}

	--描述面板表头
	tbl["title"] = DescUtility:GetMonsterName(tid)

	--描述面板图标
	tbl["icon"] = DescUtility:GetMonsterIcon(tid)

	--描述面板表头
	--1最多3行，2最多1行，3最多2行（用\r分割）
	local _, monster_type = DescUtility:GetItemDBProp(tid, ClassType.ICID_MONSTER, --[[!]]"怪物类型")
	if monster_type == 0 then
		local _, monster_prof = DescUtility:GetItemDBProp(tid, ClassType.ICID_MONSTER, --[[!]]"显示职业")
		if monster_prof > 0 and monster_prof < 12 then
			tbl["info1"] = string.format(MONSTER_TYPE_STYLE, ITEM_LIMIT_FACTION_DESC[monster_type + 1])
		else
			tbl["info1"] = string.format(MONSTER_TYPE_STYLE, MONSTER_TYPE_DESC[monster_type + 1])
		end
	else
		tbl["info1"] = string.format(MONSTER_TYPE_STYLE, MONSTER_TYPE_DESC[monster_type + 1])
	end

	local _, monster_level = DescUtility:GetItemDBProp(tid, ClassType.ICID_MONSTER, --[[!]]"等级")
	tbl["info1"] = string.format(MONSTER_LEVEL_STYLE, tbl["info1"], monster_level)

	local _, monster_rank = DescUtility:GetItemDBProp(tid, ClassType.ICID_MONSTER, --[[!]]"怪物星级")
	--[[
	if monster_type == 0 then
		tbl["info1"] = string.format(MONSTER_TYPE_HUMAN_STYLE, tbl["info1"], MONSTER_TYPE_HUMAN_DESC[monster_rank + 1] or MONSTER_TYPE_HUMAN_DESC_DEFAULT)
	end
	]]

	--描述面板星级
	--s_t，s代表星数，-1不显示。t代表显示方案，0为正常，1为同步闪烁，2为待定
	tbl["star"] = --[[!AUTO_417]]"-1_0"

 	--描述面板描述信息
	--用\r分割
	tbl["limitskill"] = --[[!AUTO_418]]""
	if MONSTER_COMMON_DESC[tid] then
		tbl["limitskill"] = MONSTER_COMMON_DESC[tid]
	end

	--描述面板附加信息
	--用\r分割
	tbl["remark"] = --[[!AUTO_419]]""
	if MONSTER_SKILL_DESC[tid] then
		tbl["remark"] = MONSTER_SKILL_DESC[tid]
	end

	return tbl

end

-- 走跑融合参数
function MonsterVisual:GetWalkRunBlendParams(idModelPath)
	return unpack(MonsterVisual.WalkRunBlendParams[idModelPath] or MonsterVisual.WalkRunBlendParams[0])
end
-- BEGIN CODEX RAI BOSS NOTES
-- Only these five template tooltips are augmented. Preferences are consulted
-- when a tooltip is requested, so disabling restores the previous behavior.
do
    local notes = {
        [66993] = "Northern Black Wolf\rRAI - Central\rListed spawn: (-60, 75)\rBoss trophy: Black Wolf's Head",
        [66994] = "Sword Barrow Guardian Spirit\rRAI - Northeast\rListed spawn: (152, 338)\rBoss trophy: Guardian Spirit Blade",
        [66998] = "Sacred Flame Ox\rRAI - Southeast\rListed spawn: (280, -94)\rBoss trophy: Ox Horn",
        [67000] = "Undead Scorpion\rRAI - Southwest\rListed spawn: (-310, -85)\rBoss trophy: Scorpion's Stinger",
        [66995] = "Jade Realm Beast\rRAI - Northwest\rListed spawn: (-347, 352)\rBoss trophy: Legendary Beast's Tail",
    }
    local previousHint = MonsterVisual.GetMonsterHint
    function MonsterVisual:GetMonsterHint(tid, ...)
        local preferences = LuaClientTweaks
        if notes[tid] and type(preferences) == "table" and type(preferences.IsEnabled) == "function" then
            local ok, enabled = pcall(preferences.IsEnabled, preferences, "boss_notes")
            if ok and enabled == true then return notes[tid] end
        end
        return previousHint(self, tid, ...)
    end
end
-- END CODEX RAI BOSS NOTES
