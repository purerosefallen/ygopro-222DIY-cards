--氷獄の王・サタン
local m=17090009
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to deck
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(17090009,0))
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTarget(cm.tdtg)
	e0:SetOperation(cm.tdop)
	c:RegisterEffect(e0)
	--deck remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(cm.flag)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function cm.tdfilter(c)
	return c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 and Duel.Destroy(c,REASON_EFFECT)~=0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end
function cm.rmfilter(c)
	return not c:IsSetCard(0x47f2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_DECK,0,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function cm.flag(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,17090009,0,0,0)
end	