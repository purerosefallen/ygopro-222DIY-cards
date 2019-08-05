--二轮之花
function c26807041.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(26807041)
	--link summon
	aux.AddLinkProcedure(c,nil,1,1)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(c26807041.spcost)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(26807041)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--cannot link material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--damage val
	local e5=e3:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5)
   --search
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetTarget(c26807041.settg)
	e6:SetOperation(c26807041.setop)
	c:RegisterEffect(e6)
	--remove
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c26807041.rmtg)
	e7:SetTargetRange(LOCATION_ONFIELD,0)
	e7:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e7)
end
function c26807041.cfilter(c,tp)
	return c:GetOwner()==1-tp and c:IsFaceup()
end
function c26807041.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.IsExistingMatchingCard(c26807041.cfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
end
function c26807041.filter(c)
	return c:IsCode(26807032)
end
function c26807041.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26807041.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26807041.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26807041,1))
	local g=Duel.SelectMatchingCard(tp,c26807041.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c26807041.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and c:GetControler()==e:GetHandlerPlayer()
end
