local m=77765040
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
cm.Senya_name_with_difficulty=true
function cm.initial_effect(c)
	local ex=Kaguya.ContinuousCommonEffect(c,EVENT_DESTROYED,function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(function(c)
			return c:GetPreviousControler()==tp and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
		end,1,nil)
	end)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(function(c)
			return not c:IsReason(REASON_DRAW) and c:GetReasonPlayer()==tp
		end,1,nil)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		local g=eg:Filter(function(c)
			return c:IsAbleToRemove() and not c:IsReason(REASON_DRAW) and c:GetReasonPlayer()==tp
		end,nil)
		Duel.SetTargetCard(g)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(function(c)
			return c:IsAbleToRemove() and not c:IsReason(REASON_DRAW) and c:IsRelateToEffect(e) and c:GetReasonPlayer()==tp
		end,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return re:IsActiveType(TYPE_MONSTER) and ep==tp
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=re:GetHandler()
		Duel.Recover(1-tp,tc:GetAttack()+tc:GetDefense(),REASON_EFFECT)
	end)
	c:RegisterEffect(e1)
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		e:SetLabel(eg:IsExists(function(c)
			return c:GetEquipCount()>0
		end,1,nil) and 1 or 0)
	end)
	c:RegisterEffect(e2)
	ex:SetLabelObject(e2)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.damcon)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	local function equip_filter(c,mc)
		return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(mc) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
	end
	local function monster_filter(c,tp)
		return c:IsFaceup() and Duel.IsExistingMatchingCard(equip_filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c)
	end
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(monster_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectMatchingCard(tp,monster_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local ec=Duel.SelectMatchingCard(tp,equip_filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tc):GetFirst()
			Duel.Equip(tp,ec,tc)
		end
	end)
	c:RegisterEffect(e1)]]
end
--[[function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)~=0
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Recover(e:GetHandler():GetOwner(),800,REASON_EFFECT)
end
]]
