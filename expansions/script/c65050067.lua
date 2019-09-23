--约定的流忆碎景
function c65050067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050067+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65050067.tg)
	e1:SetOperation(c65050067.op)
	c:RegisterEffect(e1)
end
function c65050067.filter(c)
   return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c65050067.filter1(c)
   return c:IsSetCard(0xada2) and c:IsType(TYPE_MONSTER)
end
function c65050067.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65050067.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65050067.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c65050067.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SelectTarget(tp,c65050067.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65050067.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c65050067.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g) 
			if Duel.SelectYesNo(tp,aux.Stringid(65050067,0)) then
				tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT) 
			end
		end
	end
end