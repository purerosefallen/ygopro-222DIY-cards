if Kaguya then return end
Kaguya={}
Duel.LoadScript("c37564765.lua")

function Kaguya.IsDifficulty(c)
	return Senya.check_set(c,"difficulty")
end
function Kaguya.IsTreasure(c)
	return Senya.check_set(c,"treasure")
end

local function KaguyaFilter(c,e,tp)
	local ec=e:GetHandler()
	local tc=Senya.GetDFCBackSideCard(ec)
	local p=c:GetControler()
	return c:IsFaceup() and c:IsCode(77765001) and tc:CheckEquipTarget(c) and Duel.GetLocationCount(p,LOCATION_SZONE,p)>0
end

local function KaguyaTransformTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Senya.IsDFCTransformable(c) and Duel.IsExistingMatchingCard(KaguyaFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

local function KaguyaTransformOperation(extra_opreation)
	return function (e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not KaguyaTransformTarget(e,tp,eg,ep,ev,re,r,rp,0) or not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
		if extra_opreation and not extra_opreation(e,tp,eg,ep,ev,re,r,rp) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,KaguyaFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local p=tc:GetControler()
		if p~=tp then
			Duel.MoveToField(c,p,p,LOCATION_SZONE,POS_FACEUP,true)
		end
		Senya.TransformDFCCard(c)
		Duel.Equip(p,e:GetHandler(),tc)
		Duel.RaiseEvent(c,EVENT_CUSTOM+77765000,re,r,rp,ep,ev)
	end
end

function Kaguya.ContinuousCommonEffect(c,effect_code,effect_codition,effect_cost,reserve,extra_opreation)
	effect_codition=effect_codition or aux.TRUE
	effect_cost=effect_cost or aux.TRUE
	local cd=c:GetOriginalCode()
	local mt=getmetatable(c)
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		mt.dfc_front_side=cd+1
	end
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	ex:SetCode(effect_code)
	ex:SetRange(LOCATION_SZONE)
	ex:SetProperty(0x14000)
	ex:SetCondition(effect_codition)
	ex:SetTarget(KaguyaTransformTarget)
	ex:SetOperation(KaguyaTransformOperation(extra_opreation))
	if not reserve then
		c:RegisterEffect(ex)
	end
	return ex
end

local function KaguyaEquipLimit(e,c)
	return c:IsCode(77765001)
end

function Kaguya.EquipCommonEffect(c)
	local cd=c:GetOriginalCode()
	local mt=getmetatable(c)
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		mt.dfc_back_side=cd-1
	end
	Senya.DFCBackSideCommonEffect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(KaguyaEquipLimit)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(function(e,te)
		return te:GetOwner()~=e:GetOwner()
	end)
	c:RegisterEffect(e3)
end
