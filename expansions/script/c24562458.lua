--猛毒性 马陆
function c24562458.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,24562484,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9390),1,false,false)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24562458,0))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c24562458.e4con)
	e4:SetTarget(c24562458.e4tg)
	e4:SetOperation(c24562458.e4op)
	c:RegisterEffect(e4)
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(24562458,1))
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c24562458.e6cost)
	e6:SetTarget(c24562458.tdtg)
	e6:SetOperation(c24562458.tdop)
	c:RegisterEffect(e6)
end
function c24562458.e6cosfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x9390)
end
function c24562458.e6cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24562458.e6cosfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24562458.e6cosfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c24562458.e6tdfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() --and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function c24562458.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c24562458.e6tdfil,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c24562458.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c24562458.e6tdfil,tp,0,LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			local dmg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_EXTRA):GetCount()
			if dmg>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(dmg*250)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
			end
		end
	end
end
---
function c24562458.e4dam3fil(c)
	return c:IsSetCard(0x9390) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c24562458.e4dam2fil(c,tp,btc)
	return c:IsLocation(LOCATION_REMOVED) and c:IsFaceup() and c:GetCode()==btc and c:IsControler(1-tp)
end
function c24562458.e4tgfil(c,dmbbb)
	return c:IsType(TYPE_MONSTER) and c:IsCode(dmbbb) and c:IsAbleToRemove()
end
function c24562458.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dmbbb=e:GetHandler():GetBattleTarget():GetCode()
	if chk==0 then return Duel.IsExistingMatchingCard(c24562458.e4tgfil,tp,0,LOCATION_EXTRA,1,nil,dmbbb)
	and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c24562458.e4op(e,tp,eg,ep,ev,re,r,rp)
	local btc=e:GetLabel()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	local tg=g:Filter(Card.IsCode,nil,btc)
	if tg:GetCount()>0 then
		if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)~=0 then
			local ct=Duel.GetOperatedGroup():FilterCount(c24562458.e4dam2fil,nil,tp,btc)
			if ct>0 then
				local ct2=Duel.GetMatchingGroupCount(c24562458.e4dam3fil,tp,LOCATION_REMOVED,0,nil)
				Duel.Damage(1-tp,ct*ct2*400,REASON_EFFECT)
			end
		end
	end
end
function c24562458.e4con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local btc=c:GetBattleTarget():GetCode()
	e:SetLabel(btc)
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and c:GetSummonLocation()==LOCATION_EXTRA 
end