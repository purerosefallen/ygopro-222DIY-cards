--三位一体的女神 拉结尔
function c12026033.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,4,4,c12026033.lcheck)
	c:EnableReviveLimit()

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,12026033)
	e3:SetCondition(c12026033.discon)
	e3:SetTarget(c12026033.distg)
	e3:SetOperation(c12026033.disop)
	c:RegisterEffect(e3)

	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(12026033,2))
	e6:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c12026033.cpcon)
	e6:SetTarget(c12026033.target)
	e6:SetOperation(c12026033.activate)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(12026033,ACTIVITY_CHAIN,c12026033.chainfilter)
--  Duel.AddCustomActivityCounter(12026033,ACTIVITY_SPSUMMON,c12026033.chainfilter1)
end
function c12026033.chainfilter(re,tp,cid)
	return not ( re:IsHasType(EFFECT_TYPE_ACTIVATE) )
end
function c12026033.chainfilter1(re,tp,cid)
	return not ( re:GetHandler():IsPreviousLocation(LOCATION_HAND) )
end
function c12026033.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function c12026033.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c12026033.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c12026033.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.BreakEffect()
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(12026033,1))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCategory(re:GetCategory())
		e2:SetProperty(re:GetProperty())
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetTarget(c12026033.target1)
		e2:SetOperation(re:GetOperation())
		c:RegisterEffect(e2)
	end
end
function c12026033.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12026033,2))
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	e:SetLabelObject(re)
	e:SetCategory(re:GetCategory())
	e:SetProperty(re:GetProperty())
	e:SetLabel(re:GetLabel())
--  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c12026033.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetCustomActivityCount(12016013,tp,ACTIVITY_CHAIN)>1
end
function c12026033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tg=re:GetTarget()
		local event=re:GetCode()
		if event==EVENT_CHAINING then return
		   not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		else		 
		   local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
		   return not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0)
		end
		return re:GetHandler():IsRelateToEffect(re) 
	end
	local event=re:GetCode()
	e:SetLabelObject(re)
	e:SetCategory(re:GetCategory())
	e:SetProperty(re:GetProperty())
	local tg=re:GetTarget()
	if event==EVENT_CHAINING then
	   if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	else
	   local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
	   if tg then tg(e,tp,teg,tep,tev,tre,tr,trp,1) end
	end
end
function c12026033.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end