--+++++猛毒性 矢豊
function c24562461.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,24562460,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9390),1,false,false)
	--spsummon condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c24562461.splimit)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24562461,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,24562440)
	e3:SetCost(c24562461.damcost)
	e3:SetTarget(c24562461.damtg2)
	e3:SetOperation(c24562461.damop2)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24562461,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c24562461.e2cost)
	e2:SetTarget(c24562461.e2tg)
	e2:SetOperation(c24562461.e2op)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24562461,2))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,24562440)
	e1:SetCost(c24562461.damcost)
	e1:SetTarget(c24562461.damtg)
	e1:SetOperation(c24562461.damop)
	c:RegisterEffect(e1)
end
function c24562461.e2thfil(c,tp)
	return c:IsCode(24562470)
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c24562461.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24562461.e2thfil,tp,LOCATION_DECK,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c24562461.e2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(24562461,0))
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	local g=Duel.SelectMatchingCard(tp,c24562461.e2thfil,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.ResetFlagEffect(tp,15248873)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		local b1=tc:IsAbleToHand()
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
		local b2=te:IsActivatable(tp,true,true)
		Duel.ResetFlagEffect(tp,15248873)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function c24562461.e2costfil(c)
	return c:IsSetCard(0x9390) and c:IsAbleToRemoveAsCost()
end
function c24562461.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c24562461.e2costfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24562461.e2costfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--
function c24562461.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0x9390)
end
function c24562461.e1damfil(c)
	return c:IsSetCard(0x9390) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c24562461.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c24562461.e1damfil,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,ct*500)
end
function c24562461.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c24562461.e1damfil,tp,LOCATION_REMOVED,0,nil)
	Duel.Damage(p,ct*500,REASON_EFFECT)
end
--
function c24562461.e3cfil(c)
	return c:IsSetCard(0x9390) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c24562461.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c24562461.e3cfil,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24562461.e3cfil,tp,LOCATION_MZONE,0,1,1,c)
	local tc=g:GetFirst()
	if tc then
	local ct=tc:GetBaseAttack()
	e:SetLabel(ct)
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	end
end
function c24562461.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ct)
end
function c24562461.damop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct<0 then ct=0 end
	local val=Duel.Damage(tp,ct,REASON_EFFECT)
	if val>0 and Duel.GetLP(tp)>0 then
		Duel.BreakEffect()
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-val)
	end
end