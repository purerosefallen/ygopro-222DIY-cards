--初代怪异杀手
function c1000377.initial_effect(c)
	c:SetUniqueOnField(1,0,1000377)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetCondition(c1000377.adcon)
	e6:SetTarget(c1000377.adtg)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_SET_ATTACK_FINAL)
	e8:SetValue(0)
	c:RegisterEffect(e8)
end
function c1000377.adcon(e)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:GetBattleTarget()
		and (Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL)
end
function c1000377.adtg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end