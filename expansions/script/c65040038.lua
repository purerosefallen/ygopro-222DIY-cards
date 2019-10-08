--甜蜜死亡
function c65040038.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,65040038)
	e1:SetCondition(c65040038.con)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c65040038.tg)
	e1:SetOperation(c65040038.op)
	c:RegisterEffect(e1)
end
function c65040038.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsHasCategory(CATEGORY_DAMAGE)
end
function c65040038.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=9
	if Duel.IsPlayerCanDraw(tp) then
		op=Duel.SelectOption(1-tp,aux.Stringid(65040038,0),aux.Stringid(65040038,1))
	else
		op=1
	end
	if op==0 then
		Duel.RegisterFlagEffect(tp,65040038,RESET_CHAIN,0,1)
		local typ=Duel.SetOperationInfo(1-tp,aux.Stringid(65040038,2),aux.Stringid(65040038,3))
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
	end
end
function c65040038.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,65040038)>0 then
		local typ1=e:GetLabel()
		local typ=0
		if typ1==0 then typ=TYPE_MONSTER 
		elseif typ1==1 then typ=TYPE_SPELL+TYPE_TRAP end
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			local dg=Duel.GetOperatedGroup()
			local tc=dg:GetFirst()
			Duel.ConfirmCards(1-tp,tc)
			Duel.BreakEffect()
			if tc:IsType(typ) then
				--reflect damage
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_REFLECT_DAMAGE)
				e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e3:SetReset(RESET_PHASE+PHASE_END)
				e3:SetTargetRange(1,0)
				e3:SetValue(c65040038.refcon)
				Duel.RegisterEffect(e3,tp)
			else
				--avoid damage
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CHANGE_DAMAGE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetTargetRange(1,0)
				e1:SetValue(c65040038.damval)
				Duel.RegisterEffect(e1,tp)
			end
		end  
	else
		 local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetValue(c65040038.damval2)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	local e2=e4:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	end
end
function c65040038.refcon(e,re,val,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0 
end
function c65040038.damval(e,re,val,r,rp)
	if r&REASON_EFFECT==REASON_EFFECT and re then
		return val*2
	end
	return val
end
function c65040038.damval2(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end