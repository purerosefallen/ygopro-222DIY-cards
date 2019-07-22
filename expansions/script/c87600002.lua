local m=87600002
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return c:GetEquipCount()==0 and eg:IsExists(function(c)
			return c:GetSequence()>4
		end,1,nil)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		local g=eg:Filter(function(c)
			return c:GetSequence()>4
		end,nil)
		Duel.SetTargetCard(g)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsLocation(LOCATION_MZONE) then return end
		if not c:IsRelateToEffect(e) then return end
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Equip(tp,c,tc)
			for code in ipairs({
				EFFECT_UNRELEASABLE_SUM,
				EFFECT_UNRELEASABLE_NONSUM,
				EFFECT_CANNOT_BE_FUSION_MATERIAL,
				EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,
				EFFECT_CANNOT_BE_XYZ_MATERIAL,
				EFFECT_CANNOT_BE_LINK_MATERIAL,
			}) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_EQUIP)
				e1:SetCode(code)
				e1:SetValue(code==EFFECT_CANNOT_BE_FUSION_MATERIAL and (
					function(e,c,sumtype)
						return sumtype==SUMMON_TYPE_FUSION
					end
				) or 1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
			end
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_EQUIP_LIMIT)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetValue(aux.TRUE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
		end
	end)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:GetEquipTarget() end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,c:GetEquipTarget(),1,0,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=c:GetEquipTarget()
		if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			if tc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				Duel.BreakEffect()
				if Duel.Equip(tp,tc,c,false) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(function(e,c)
						return e:GetOwner()==c
					end)
					tc:RegisterEffect(e1)
				end
			end
		end
	end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	local function f(c,e,tp)
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local g=c:GetEquipGroup()
		if chk==0 then return Duel.GetMZoneCount(tp)>0 and g:IsExists(f,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=c:GetEquipGroup():Filter(f,nil,e,tp)
		if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 and #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end)
	c:RegisterEffect(e3)
end
