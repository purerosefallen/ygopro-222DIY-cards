--终形魔-戈罗波
function c21520175.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcMixRep(c,false,false,c21520175.sefilter,3,100)
--[[	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c21520175.fscondition)
	e0:SetOperation(c21520175.fsoperation)
	c:RegisterEffect(e0)]]
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c21520175.splimit)
	c:RegisterEffect(e1)
	--cost
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e00:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetCode(EVENT_PHASE+PHASE_END)
	e00:SetCountLimit(1)
	e00:SetRange(LOCATION_MZONE)
	e00:SetCondition(c21520175.ccon)
	e00:SetOperation(c21520175.ccost)
	c:RegisterEffect(e00)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e2)
	--atk def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c21520175.matcheck)
	c:RegisterEffect(e4)
--[[	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c21520175.regcon)
	e5:SetOperation(c21520175.regop)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)--]]
	--can not be effect target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--draw
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(21520175,3))
	e7:SetCategory(CATEGORY_DAMAGE+CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c21520175.drcon)
--	e7:SetCost(c21520175.drcost)
	e7:SetTarget(c21520175.drtg)
	e7:SetOperation(c21520175.drop)
	c:RegisterEffect(e7)
end
function c21520175.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c21520175.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function c21520175.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21520175.ccost(e,tp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(c21520175.cfilter1,tp,LOCATION_HAND,0,nil)
	local opselect=2
	if g1:GetCount()>0 then
		opselect=Duel.SelectOption(tp,aux.Stringid(21520175,0),aux.Stringid(21520175,1),aux.Stringid(21520175,2))
	else 
		opselect=Duel.SelectOption(tp,aux.Stringid(21520175,1),aux.Stringid(21520175,2))
		opselect=opselect+1
	end
	if opselect==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=g1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	elseif opselect==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(-c:GetAttack())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCategory(CATEGORY_DEFCHANGE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-c:GetDefense())
		c:RegisterEffect(e2)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
function c21520175.matcheck(e,c)
--	local g=c:GetMaterial()
--	e:SetLabel(g:GetClassCount(Card.GetOriginalCode))
	local ct=c:GetMaterialCount()
	local ae=Effect.CreateEffect(c)
	ae:SetType(EFFECT_TYPE_SINGLE)
	ae:SetCode(EFFECT_SET_BASE_ATTACK)
	ae:SetValue(ct*500)
	ae:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(ae)
	local de=ae:Clone()
	de:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(de)
end
function c21520175.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c21520175.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	local ae=Effect.CreateEffect(c)
	ae:SetType(EFFECT_TYPE_SINGLE)
	ae:SetCode(EFFECT_UPDATE_ATTACK)
	ae:SetValue(ct*1000)
	ae:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(ae)
	local de=ae:Clone()
	de:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(de)
end
function c21520175.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) --and c:IsReason(REASON_BATTLE)
end
function c21520175.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN) then
			return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==1 
		else 
			return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3,tp)
end
function c21520175.drfilter(c)
	return c:IsSetCard(0x490) and c:IsFaceup()
end
function c21520175.fcfilter(c)
	return c:IsCode(21520181) and c:IsFaceup()
end
function c21520175.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local gc=Duel.GetMatchingGroupCount(c21520175.drfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local fchk=Duel.IsExistingMatchingCard(c21520175.fcfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local d=gc*300
	local ops=Duel.SelectOption(tp,aux.Stringid(21520175,3),aux.Stringid(21520175,4))
	e:SetLabel(ops)
	if ops==0 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520175,3))
		if fchk then d=d*2 end
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(d)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,gc*300)
	elseif ops==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520175,4))
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2-h)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2-h)
	end
end
function c21520175.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ops=e:GetLabel()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local fchk=Duel.IsExistingMatchingCard(c21520175.fcfilter,p,LOCATION_ONFIELD,0,1,nil)
	if ops==0 then 
		local gc=Duel.GetMatchingGroupCount(c21520175.drfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)*300
		if fchk then gc=gc*2 end
		Duel.Damage(p,gc,REASON_EFFECT)
	elseif ops==1 then 
		local hc=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
		if hc>=3 then return end
		Duel.Draw(p,3-hc,REASON_EFFECT)
		local hg=Duel.GetFieldGroup(1-p,LOCATION_HAND,0)
		if hg:GetCount()>0 and not fchk and Duel.SelectYesNo(1-p,aux.Stringid(21520175,5)) then 
			Duel.Hint(HINT_CARD,p,21520175)
			Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
			Duel.Draw(1-p,3-hg:GetCount(),REASON_EFFECT)
		end
	end
end
function c21520175.sefilter(c)
	return c:IsFusionSetCard(0x490) and c:IsType(TYPE_MONSTER)
end
function c21520175.fscondition(e,g,gc,chkf)
	if g==nil then return true end
	if gc then return false end
	return g:IsExists(c21520175.sefilter,3,nil)
end
function c21520175.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	Duel.SetFusionMaterial(eg:FilterSelect(tp,c21520175.sefilter,3,100,nil))
end
