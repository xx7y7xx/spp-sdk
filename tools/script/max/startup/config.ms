/*----------------------------------------------------------
--
-- Copyright (C) 2012 Sanpolo Co.LTD
-- http://www.spolo.org
--
--  This file is part of the UGE(Uniform Game Engine).
--  Copyright (C) by SanPolo Co.Ltd. 
--  All rights reserved.
--
--  See http://uge.spolo.org/ for more information.
--
--  SanPolo Co.Ltd
--  http://uge.spolo.org/  sales@spolo.org uge-support@spolo.org

--
------------------------------------------------------------
*/

-- Debug function
SPP_DEBUG = false
SPP_MESHGEN = true

G_SCENELOGFILE = "D:\\scenetool.log"

-- Global config
G_IgnoreTextureList = #(
	"sky.jpg",
	"water1.jpg"
)

G_LevelAError = #(
	"A1——",
	"A2——",
	"A3——",
	"A4——",
	"A5——",
	"A6——",
	"A7——",
	"A8——",
	"A9——",
	"A10——",
	"A11——",
	"A12——",
	"A13——",
	"A14——部分png贴图不透明——需要修改",
	"A15——贴图不符合规范,需要修改",
	"A16——",
	"A17——",
	"A18——",
	"A19——",
	"A20——",
	"A21——",
	"A22——",
	"A23——",
	"A24——",
	"A25——",
	"A26——",
	"A27——",
	"A28——"
)

G_LevelBError = #(
	"B1——模型包含坏面",
	"B2——物体没定义材质在 face",
	"B3——场景中有模型名字有重复",
	"B4——模型的面数超过50000个三角面",
	"B5——物体的mesh名字长度超过了16个字符，且没有定义#和序列号",
	"B6——物体的mesh名字长度超过了16个字符",
	"B7——物体的mesh名字没有定义#和序列号",
	"B8——建筑模型总面数已超过33万三角面，需要做减面处理",
	"B9——场景贴图总数量超过900张，需要减少贴图数量",
	"B10——场景里存在微软x文件不支持的工具对象，需要清除",
	"B11——场景中mesh体积过小需要修改",
	"B12——场景中HUD植物间距太小",
	"B13——物体里面有大于四边形的面存在，需要修改",
	"B14——预留",
	"B15——预留",
	"B16——预留",
	"B17——预留",
	"B18——预留",
	"B19——预留",
	"B20——预留",
	"B21——场景中有不被SPP支持的物体存在",
	"B22——物体的mesh名字不符合规范",
	"B23——预留",
	"B24——预留",
	"B25——预留",
	"B26——预留",
	"B27——预留"
)

--EOF