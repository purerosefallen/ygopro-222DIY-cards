--Snowy Heart
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
c81011024.Senya_desc_with_nanahira=true
function c81011024.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,81011001)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c81011024.reptg)
	e2:SetValue(c81011024.repval)
	e2:SetOperation(c81011024.repop)
	c:RegisterEffect(e2)
end
function c81011024.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsCode(37564765)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c81011024.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c81011024.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c81011024.repval(e,c)
	return c81011024.repfilter(c,e:GetHandlerPlayer())
end
function c81011024.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
