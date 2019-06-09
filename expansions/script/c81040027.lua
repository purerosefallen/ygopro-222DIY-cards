--周子·只身旅途
function c81040027.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcEqual2(c,c81040027.ritfilter,LOCATION_REMOVED+LOCATION_GRAVE)
	e1:SetCountLimit(1,81040027)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,81040927)
	e3:SetCondition(c81040027.damcon)
	e3:SetCost(c81040027.damcost)
	e3:SetTarget(c81040027.damtg)
	e3:SetOperation(c81040027.damop)
	c:RegisterEffect(e3)
end
function c81040027.ritfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x81c)
end
function c81040027.cfilter(c,e,tp)
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
		and c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0x81c)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c81040027.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81040027.cfilter,1,nil,e,tp)
end
function c81040027.damfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x81c) and c:IsAbleToRemoveAsCost() and c:GetTextAttack()>0
end
function c81040027.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c81040027.damfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81040027.damfilter,tp,LOCATION_GRAVE,0,1,1,c)
	e:SetLabel(g:GetFirst():GetTextAttack())
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81040027.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function c81040027.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
