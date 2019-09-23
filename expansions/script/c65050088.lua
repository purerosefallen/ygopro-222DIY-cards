--沁恋甜心 甜蜜之白菊
function c65050088.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.NonTuner(c65050088.synfilter),nil,nil,aux.Tuner(nil),1,99)
	c:EnableReviveLimit()
	--chain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65050088.con)
	e1:SetTarget(c65050088.tg)
	e1:SetOperation(c65050088.op)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcda2))
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c65050088.synfilter(c)
	return c:IsSetCard(0xcda2) and c:IsLevelAbove(6)
end

function c65050088.confil(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c65050088.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050088.confil,1,nil,tp)
end
function c65050088.ng1fil(c)
	return c:IsType(TYPE_FUSION) and c:IsAbleToGrave()
end
function c65050088.ng2fil(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToGrave()
end
function c65050088.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eeg=eg:Filter(c65050088.confil,nil,tp)
	local b1=Duel.IsExistingMatchingCard(c65050088.ng1fil,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65050088.ng2fil,tp,LOCATION_EXTRA,0,1,nil) and Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)>=eeg:GetCount()
	if chk==0 then return b1 or b2 end
	local op=2
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(65050088,0),aux.Stringid(65050088,1))
	elseif b1 then
		op=0
	elseif b2 then
		op=1
	end
	if op==0 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eeg,eeg:GetCount(),0,0)
	elseif op==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,eeg:GetCount(),1-tp,LOCATION_EXTRA)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65050088,op))
	e:SetLabel(op)
end
function c65050088.op(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local eeg=eg:Filter(c65050088.confil,nil,tp)
	if op==0 then
		local g1=Duel.SelectMatchingCard(tp,c65050088.ng1fil,tp,LOCATION_EXTRA,0,1,1,nil)
		if g1:GetCount()>0 and Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
			Duel.Destroy(eeg,REASON_EFFECT)
		end
	elseif op==1 then
		local g2=Duel.SelectMatchingCard(tp,c65050088.ng2fil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g2:GetCount()>0 and Duel.SendtoGrave(g2,REASON_EFFECT)~=0 and Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)>=eeg:GetCount() then
			local eec=eeg:GetCount()
			local dg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,eec,eec,nil)
			Duel.SendtoGrave(dg,REASON_EFFECT)
		end
	end
end