--+++++猛毒性 毒丝
function c24562472.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,24562471,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9390),1,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c24562472.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24562472,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DAMAGE)
	e2:SetTarget(c24562472.e2tg)
	e2:SetOperation(c24562472.e2op)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24562472,4))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetCountLimit(1)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c24562472.e4con)
	e4:SetTarget(c24562472.e4tg)
	e4:SetOperation(c24562472.e4op)
	c:RegisterEffect(e4)
end
function c24562472.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0x9390)
end
function c24562472.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c24562472.e4con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc then p=bc:GetControler() end
	return bc and bc:GetColumnGroup():FilterCount(c24562472.e4fil,nil,p)>0
end
function c24562472.e4op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not tc:IsRelateToBattle() then return end
	if not c:IsRelateToEffect(e) or c:IsFacedown() then Duel.SendtoGrave(tc,REASON_EFFECT) return end
	if Duel.Equip(tp,tc,c,false) then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e5:SetCode(EFFECT_EQUIP_LIMIT)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		e5:SetValue(c24562472.eqlimit)
		tc:RegisterEffect(e5)
		local e9=Effect.CreateEffect(c)
		e9:SetDescription(aux.Stringid(24562472,5))
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_ADD_CODE)
		e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e9:SetValue(24562464)
		e9:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e9)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_EQUIP)
		e7:SetCode(EFFECT_UPDATE_ATTACK)
		e7:SetValue(-200)
		tc:RegisterEffect(e7)
	end
end
function c24562472.e4fil(c,p)
	return c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and c:IsSetCard(0x9390) and c:IsControler(p)
end
function c24562472.eqlimit(e,c)
	return e:GetOwner()==c
end
function c24562472.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c24562472.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 or not Duel.IsPlayerCanDiscardDeck(tp,1) then return false end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x9390) then
		if Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(24562472,1)) then
			Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			local e10=Effect.CreateEffect(c)
			e10:SetCode(EFFECT_CHANGE_TYPE)
			e10:SetType(EFFECT_TYPE_SINGLE)
			e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e10:SetReset(RESET_EVENT+0x1fc0000)
			e10:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e10)
			tc:RegisterFlagEffect(24562472,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(24562472,3))
			local e8=Effect.CreateEffect(c)
			e8:SetDescription(aux.Stringid(24562472,2))
			e8:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e8:SetType(EFFECT_TYPE_FIELD)
			e8:SetCode(EFFECT_CANNOT_ATTACK)
			e8:SetRange(LOCATION_ONFIELD)
			e8:SetReset(RESET_EVENT+0x1fe0000)
			e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e8:SetTarget(c24562472.atktarget)
			tc:RegisterEffect(e8,true)
		end
		else
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
		Duel.Damage(1-tp,700,REASON_EFFECT)
	end
end
function c24562472.atktarget(e,c)
	local gp=e:GetHandler():GetControler()
	local g=e:GetHandler():GetColumnGroup()
	return c:IsControler(gp) and g:IsContains(c)
end