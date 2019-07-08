--御刀流 鹤翼闪
local m=20100235
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100000") end,function() require("script/c20100000") end)
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.btcon)
	e2:SetValue(aux.imval1)   
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE+LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.ntg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3) 
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(cm.btcon1)
	e4:SetValue(cm.atkval)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE+LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(cm.ntg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--Release
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetRange(LOCATION_SZONE+LOCATION_FZONE)
	e6:SetCountLimit(1,m)
	e6:SetCost(cm.rcost)
	e6:SetCondition(cm.rcon)
	e6:SetTarget(cm.rtg)
	e6:SetOperation(cm.rop)
	c:RegisterEffect(e6)
end

function cm.nfilter(c,seq)
	local cseq=c:GetSequence()
	return cseq<5 and math.abs(cseq-seq)==1 and c:IsFaceup() and c:IsSetCard(0xc90)
end

function cm.btcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local seq=c:GetSequence()
	if seq>4 then return false end
	return Duel.GetMatchingGroupCount(cm.nfilter,p,LOCATION_MZONE,0,c,seq)==1 
end

function cm.btcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local seq=c:GetSequence()
	local fct=Duel.GetFlagEffect(1-p,20100000)
	if seq>4 then return false end
	return Duel.GetMatchingGroupCount(cm.nfilter,p,LOCATION_MZONE,0,c,seq)==2 
		and Duel.GetTurnPlayer()~=p and Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and c:IsRelateToBattle() and fct>0
end

function cm.ntg(e,c)
	return c:IsSetCard(0xc90) and c:IsFaceup()
end

function cm.atkval(e,c)
	local c=e:GetHandler()
	local p=c:GetControler()
	local seq=c:GetSequence()
	local ng=Duel.GetMatchingGroup(cm.nfilter,p,LOCATION_MZONE,0,c,seq)
	return ng:GetSum(Card.GetAttack)
end

function cm.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_EFFECT)
end

function cm.afilter(c)
	return c:GetAttackAnnouncedCount()==0 and c:IsAttackable()
end

function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local seq=ac:GetSequence()
	if seq>4 or ac:IsControler(1-tp) or not ac:IsSetCard(0xc90) then return false end
	local ng=Duel.GetMatchingGroup(cm.nfilter,tp,LOCATION_MZONE,0,ac,seq)
	if ng:GetCount()<1 then return false end
	return true
	--[[
	local ncg=Group.CreateGroup()
	local fc=ng:GetFirst()
	while fc do
		local cg=fc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		if cg:GetCount()>0 then ncg:Merge(cg) end
		fc=ng:GetNext()
	end
	if ncg:GetCount()>0 then
		return true
	else
		if ng:IsExists(cm.afilter,1,nil) then
			return true
		end
		return false
	end
	--]]
end

function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ac=Duel.GetAttacker()
	local seq=ac:GetSequence()
	local ng=Duel.GetMatchingGroup(cm.nfilter,tp,LOCATION_MZONE,0,ac,seq)
	local ncg=Group.CreateGroup()
	local fc=ng:GetFirst()
	while fc do
		local cg=fc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		if cg:GetCount()>0 then ncg:Merge(cg) end
		fc=ng:GetNext()
	end
	if ncg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,ncg,ncg:GetCount(),0,0)
	end
end

function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		local ac=Duel.GetAttacker()
		local seq=ac:GetSequence()
		local ng=Duel.GetMatchingGroup(cm.nfilter,tp,LOCATION_MZONE,0,ac,seq)
		if ng:GetCount()<1 then return end
		local ncg=Group.CreateGroup()
		local ag=Group.CreateGroup()
		local fc=ng:GetFirst()
		while fc do
			local cg=fc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
			if cg:GetCount()>0 then 
				ncg:Merge(cg)
			else
				ag:AddCard(fc)
			end
			fc=ng:GetNext()
		end
		if ncg:GetCount()>0 then 
			Duel.Destroy(ncg,REASON_EFFECT)
		end
		if ag:GetCount()>0 then
			local dam=ag:GetSum(Card.GetAttack)
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end