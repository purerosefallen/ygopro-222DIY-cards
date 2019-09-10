--Extra Data of DJ.Tenka
Tenka=Tenka or {}
--Mogami Shizuka, 81018xxx, 0x81b
function Tenka.Shizuka(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(Tenka.valcon)
	c:RegisterEffect(e1)
end
function Tenka.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
--Kitakami Reika, 81015xxx(81015028~ ), 0x81a
--Reika effect condition
function Tenka.ReikaCon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	for i=0,4 do
		if Duel.GetFieldCard(tp,LOCATION_SZONE,i) then return false end
	end
	return true
end
