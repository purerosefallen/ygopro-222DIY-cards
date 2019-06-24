--景愿『刹那芳华』
local m=1111056
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Scenersh=true
--
function c1111056.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111056.tg1)
	e1:SetOperation(c1111056.op1)
	c:RegisterEffect(e1)
--
	if not c1111056.check then
		c1111056.check=true
		c1111056.code={}
		c1111056.code[1]=0
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local rc=re:GetHandler()
			if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:GetType()==TYPE_SPELL then
				if not c1111056.code then return end
				for k,v in ipairs(c1111056.code) do
					if v==re:GetHandler():GetCode() then return end
				end
				c1111056.code[#c1111056.code+1]=rc:GetCode()
			end
		end)
		Duel.RegisterEffect(e1,0)
	end
--
end
--
function c1111056.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local num=((#c1111056.code)-1)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(num)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,num)
end
--
function c1111056.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(1-p,d,REASON_EFFECT)
	local c=e:GetHandler()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetTargetRange(1,0)
	e1_1:SetTarget(c1111056.tg1_1)
	Duel.RegisterEffect(e1_1,p)
end
function c1111056.tg1_1(e,re,tp)
	return c1111056.code and re:GetHandler():IsCode(table.unpack(c1111056.code)) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
--