local m=77765004
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
--cm.Senya_name_with_difficulty=1
function cm.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	for _,code in ipairs({EFFECT_CANNOT_BE_XYZ_MATERIAL,EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,EFFECT_CANNOT_BE_FUSION_MATERIAL,EFFECT_CANNOT_BE_LINK_MATERIAL}) do
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(code)
		e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
		e2:SetTargetRange(0xff,0xff)
		e2:SetTarget(function(e,c)
			return c:GetSequence()>4 or not c:IsLocation(LOCATION_MZONE)
		end)
		e2:SetRange(LOCATION_SZONE)
		e2:SetValue(function(e,c)
			return c and c:IsControler(1-e:GetHandlerPlayer())
		end)
		c:RegisterEffect(e2)
	end
	local function KaguyaFilter(c,e,tp,cc)
		local p=c:GetControler()
		local tc=Senya.GetDFCBackSideCard(cc)
		return c:IsFaceup() and c:IsCode(77765001) and Duel.GetLocationCount(p,LOCATION_SZONE,tp)>0 and tc:CheckEquipTarget(c)
	end
	local function DifficultyFilter(c,e,tp)
		return Kaguya.IsDifficulty(c) and Senya.IsDFCTransformable(c) and Duel.IsExistingMatchingCard(KaguyaFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,c)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(0x14000+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local dg=Duel.SelectMatchingCard(tp,DifficultyFilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local cc=dg:GetFirst()
		if cc then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,KaguyaFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,cc)
			local tc=g:GetFirst()
			local p=tc:GetControler()
			Duel.MoveToField(cc,tp,p,LOCATION_SZONE,POS_FACEUP,false)
			Senya.TransformDFCCard(cc)
			Duel.Equip(p,cc,tc)
			Duel.RaiseEvent(cc,EVENT_CUSTOM+77765000,re,r,rp,ep,ev)
		end
	end)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return c:IsCode(m-1) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_GRAVE)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.descon)
	e1:SetOperation(cm.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
	cm[e:GetHandler()]=e1
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_RULE)
		c:ResetFlagEffect(1082946)
	end
end
