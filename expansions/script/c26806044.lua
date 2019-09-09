--Quadimension·诗岸
function c26806044.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c26806044.ffilter,2,false)	
end
function c26806044.ffilter(c)
	return c:IsAttack(2200) and c:IsDefense(600)
end
