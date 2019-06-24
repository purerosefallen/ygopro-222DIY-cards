--心之怪盗团-试炼双子
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873632
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(rsphh.set2),7,2,cm.ovfilter,aux.Stringid(m,0),2,nil)
	local e2=rsef.I(c,{m,2},{1,m},nil,nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rstg.target(rsop.list(cm.setfilter,nil,LOCATION_DECK)),cm.setop)
	local e3,e4=rsef.SV_INDESTRUCTABLE(c,"battle,effect",{cm.val1,cm.val2})
	local e5=rsef.QO(c,nil,{m,1},1,nil,nil,LOCATION_MZONE,cm.attcon,nil,nil,cm.attop)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.discon)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	--c:RegisterEffect(e1)
end
function cm.attcon(e,tp)
	return rscon.phmp(e) and e:GetHandler():GetFlagEffect(m)==0
end
function cm.attop(e,tp)
	local c=rscf.GetRelationThisCard(e)
	if not c then return end
	local ct=Duel.GetTurnPlayer()==tp and 1 or 2
	c:RegisterFlagEffect(m,rsreset.est_pend+RESET_OPPO_TURN,0,ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,0xff-c:GetAttribute())
	local e1=rsef.SV_CHANGE(c,"att",att,nil,rsreset.est_d)
end
function cm.val1(e,c)
	return c:IsAttribute(e:GetHandler():GetAttribute())
end
function cm.val2(e,re,rp)
	return aux.indoval(e,re,rp) and re:GetHandler():IsAttribute(e:GetHandler():GetAttribute())
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsCode(15873641)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and not re:GetHandler():IsType(TYPE_TOKEN) and rp~=tp
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and c:IsType(TYPE_XYZ) and not rc:IsType(TYPE_TOKEN) then
		rc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(rc))
		Duel.BreakEffect()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function cm.setfilter(c)
	return rsphh.stset(c) and c:IsSSetable()
end
function cm.setop(e,tp)
	rsof.SelectHint(tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SSet(tp,tc)
	Duel.ConfirmCards(1-tp,tc)
	local e1=rsef.SV_LIMIT({e:GetHandler(),tc},"tri",nil,nil,rsreset.est_pend)
end