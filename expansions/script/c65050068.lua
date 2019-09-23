--期许的流忆碎景
function c65050068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050068+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65050068.tg)
	e1:SetOperation(c65050068.op)
	c:RegisterEffect(e1)
end
function c65050068.filter(c)
   return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c65050068.filter1(c)
   return c:IsSetCard(0xada2) and c:IsType(TYPE_MONSTER)
end
function c65050068.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65050068.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65050068.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c65050068.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp) end
	Duel.SelectTarget(tp,c65050068.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c65050068.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c65050068.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then 
			Duel.Overlay(tc,g)
			Duel.Draw(tp,1,REASON_EFFECT)		
		end
	end
end
