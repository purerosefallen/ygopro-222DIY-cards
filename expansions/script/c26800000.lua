--Used By Amana
Amana=Amana or {}
--Mogami Shizuka, 81018xxx, 0x81b
function Amana.AttackBelow(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_ATTACK)
	e0:SetCondition(Amana.atcon)
	c:RegisterEffect(e0)
end
function Amana.atcon(e)
	return e:GetHandler():GetAttack()>=2000
end
