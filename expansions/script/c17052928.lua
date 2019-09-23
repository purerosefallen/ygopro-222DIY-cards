--雷维翁姐妹登场
local m=17052928
local cm=_G["c"..m]
cm.dfc_front_side=17052928
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17052928+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local off=1
	local ops={aux.Stringid(17052928,0),aux.Stringid(17052928,1),aux.Stringid(17052928,2)}
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(op)
	e:SetCategory(CATEGORY_TOHAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():CancelToGrave()
	local sel=e:GetLabel()
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	local tcode=17052929+sel
	e:GetHandler():SetEntityCode(tcode,true)
	e:GetHandler():ReplaceEffect(tcode,0,0)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	e:GetHandler():RegisterFlagEffect(17052928,RESET_EVENT+RESETS_STANDARD,1,0)
end
