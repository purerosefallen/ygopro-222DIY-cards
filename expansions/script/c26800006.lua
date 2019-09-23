--ALSTROEMERIA！
function c26800006.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c26800006.mfilter1,c26800006.mfilter2,true)
	c:EnableReviveLimit()
end
function c26800006.mfilter1(c)
	return c:IsFusionAttribute(ATTRIBUTE_WIND) and c:IsFusionType(TYPE_NORMAL) and c:IsLevel(8)
end
function c26800006.mfilter2(c)
	return c:IsLink(4) and c:IsFusionType(TYPE_LINK) and c:IsFusionAttribute(ATTRIBUTE_WIND)
end
