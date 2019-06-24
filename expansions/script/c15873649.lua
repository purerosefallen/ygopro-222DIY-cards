--人格面具-梅塔特隆
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873649
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c,true)
	local e1=rsef.FV_LIMIT(c,"dis",nil,aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),{0,LOCATION_MZONE })
	local e2=rsef.SV_UPDATE(c,"atk",cm.val)
	local e4=rsphh.EndPhaseFun(c,15873611)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.atkcon)
	e3:SetCost(cm.atkcost)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(rscf.FilterFaceUp(Card.IsAttribute,ATTRIBUTE_LIGHT),e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)*500
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc~=nil and bc:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1,e2=rsef.SV_SET({c,bc},"atkf,deff",0,nil,rsreset.est+RESET_PHASE+PHASE_DAMAGE_CAL)
	end
end