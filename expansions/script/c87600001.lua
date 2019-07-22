local m=87600001
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
		if Duel.CheckLocation(tp,LOCATION_MZONE,5) and Duel.CheckLocation(1-tp,LOCATION_MZONE,6) then ft=ft+1 end
		if Duel.CheckLocation(tp,LOCATION_MZONE,6) and Duel.CheckLocation(1-tp,LOCATION_MZONE,5) then ft=ft+1 end
		if chk==0 then return ft>0 and e:GetHandler():IsAbleToRemove() end
		local seq=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0)
		e:SetLabel(seq)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local seq=e:GetLabel()
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT) then
			c:RegisterFlagEffect(m,0x1fe100,0,1,seq)
		end
	end)
	c:RegisterEffect(e1)
	local function f(c,tp,seq)
		if not seq then return false end
		local nseq=c:GetSequence()
		if c:IsControler(1-tp) then nseq=nseq+16 end
		return bit.extract(seq,nseq)~=0
	end
	for _,code in ipairs({EVENT_SUMMON_SUCCESS,EVENT_FLIP_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS}) do
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(code)
		e2:SetRange(LOCATION_REMOVED)
		e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local seq=e:GetHandler():GetFlagEffectLabel(m)
			return seq and eg:IsExists(f,1,nil,tp,seq)
		end)
		e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return true end
			local seq=e:GetHandler():GetFlagEffectLabel(m)
			local g=eg:Filter(f,nil,tp,seq)
			Duel.SetTargetCard(g)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		end)
		e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
			if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
		end)
		c:RegisterEffect(e2)
	end
end
