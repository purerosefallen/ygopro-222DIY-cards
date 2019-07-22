local m=77765030
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
cm.Senya_name_with_difficulty=true
function cm.initial_effect(c)
	local ex=Kaguya.ContinuousCommonEffect(c,EVENT_CUSTOM+m,function(e,tp,eg,ep,ev,re,r,rp)
		local flag=ev
		--Debug.Message(100+ev)
		return flag&(0x1<<tp)>0
	end,Senya.DescriptionCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:GetFlagEffect(m+200)==0 end
		c:RegisterFlagEffect(m+200,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	end))
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--[[e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_HAND,0,nil)
		if chk==0 then return #g>0 end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_HAND,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		end
	end)]]
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(function(e,tp)
		return Duel.GetTurnPlayer()==tp
	end)
	e2:SetOperation(function(e,tp,eg,ep,eg,re,r,rp)
		local g=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,LOCATION_HAND,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
			local tc=g:Select(tp,1,1,nil):GetFirst()
					local ex=Effect.CreateEffect(e:GetHandler())
					ex:SetType(EFFECT_TYPE_SINGLE)
					ex:SetCode(EFFECT_PUBLIC)
					ex:SetValue(1)
					ex:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					ex:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(ex)
		end
	end)
	c:RegisterEffect(e2)
	for _,code in ipairs({
		--EFFECT_PUBLIC,
		EFFECT_CANNOT_TRIGGER,
		EFFECT_CANNOT_SSET,
		EFFECT_CANNOT_MSET
	}) do
		local ex=Effect.CreateEffect(c)
		ex:SetType(EFFECT_TYPE_FIELD)
		ex:SetCode(code)
		ex:SetValue(1)
		ex:SetRange(LOCATION_SZONE)
		ex:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		ex:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ex:SetTarget(function(e,c)
			return c:IsHasEffect(EFFECT_PUBLIC)
		end)
		c:RegisterEffect(ex)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SSET_COST)
	e3:SetCost(function(e,c,tp)
        return Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,LOCATION_HAND,0,1,c) and tp==e:GetLabelObject():GetHandlerPlayer()
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,LOCATION_HAND,0,1,1,e:GetHandler())
		Duel.SendtoHand(g,1-tp,REASON_COST)
	end)
	--c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_MSET_COST)
	--c:RegisterEffect(e5)
	local e3_=Effect.CreateEffect(c)
	e3_:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3_:SetRange(LOCATION_SZONE)
	e3_:SetProperty(EFFECT_TYPE_IGNORE_RANGE)
	e3_:SetTargetRange(0xff,0xff)
	e3_:SetLabelObject(e3)
    e3:SetLabelObject(e3)
	c:RegisterEffect(e3_)
	local e3__=e3_:Clone()
	e3__:SetLabelObject(e5)
    e5:SetLabelObject(e3__)
	c:RegisterEffect(e3__)
	if not cm.gchk then
		cm.gchk=true
		local ex=Effect.GlobalEffect()
		ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex:SetCode(EVENT_ADJUST)
		ex:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			for p=0,1 do
				local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
				if #g>0 and g:FilterCount(Card.IsPublic,nil)==#g then return true end
			end
			return false
		end)
		ex:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local flag=0
			for p=0,1 do
				local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
				if #g>0 and g:FilterCount(Card.IsPublic,nil)==#g then
					flag=flag|(0x1<<p)
				end
			end
			--Debug.Message(flag)
			Duel.RaiseEvent(c,EVENT_CUSTOM+m,e,0,tp,tp,flag)
		end)
		Duel.RegisterEffect(ex,0)
	end
	--[[local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(Senya.DescriptionCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return Duel.GetFlagEffect(tp,m)-Duel.GetFlagEffect(tp,m+100)==0 end
		Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end))
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)
		if chk==0 then return #g>0 end
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)
		if #g>0 then
			local sg=g:RandomSelect(tp,1)
			local tc=sg:GetFirst()
			if not tc:IsPublic() then
				for _,code in ipairs({
					EFFECT_PUBLIC,
					EFFECT_CANNOT_TRIGGER,
					EFFECT_CANNOT_SSET,
					EFFECT_CANNOT_MSET
				}) do
					local ex=Effect.CreateEffect(e:GetHandler())
					ex:SetType(EFFECT_TYPE_SINGLE)
					ex:SetCode(code)
					ex:SetValue(1)
					ex:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					ex:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(ex)

				end
			end
		end
	end)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16+1)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(Senya.DescriptionCost(Senya.DiscardHandCost(1)))
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.RegisterFlagEffect(tp,m+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end)
	c:RegisterEffect(e2)]]
end
