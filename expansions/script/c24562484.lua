--猛毒性 覆毬
function c24562484.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24562484,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c24562484.ttcon)
	e1:SetOperation(c24562484.ttop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c24562484.e3con)
	e3:SetTarget(c24562484.e3tg)
	e3:SetOperation(c24562484.e3op)
	c:RegisterEffect(e3)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(c24562484.e4con)
	e4:SetTarget(c24562484.e4tg)
	e4:SetOperation(c24562484.e4op)
	c:RegisterEffect(e4)
end
function c24562484.e4con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_NORMAL+1
end
function c24562484.bbfil(c,e,tp,bb)
	return c:GetEquipGroup():IsContains(bb)
end
function c24562484.e3con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local bb=e:GetHandler()
	local bb1=Duel.GetMatchingGroupCount(c24562484.bbfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,tp,bb)
	if bb1==0 then return false end
	return e:GetHandler():GetEquipTarget()==eg:GetFirst()
end
function c24562484.e4fil(c,e,tp)
	return c:IsSetCard(0x9390) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24562484.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c24562484.e4fil,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c24562484.e4op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 and Duel.IsExistingMatchingCard(c24562484.e4fil,tp,LOCATION_REMOVED,0,1,nil,e,tp) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c24562484.e4fil,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
			Duel.BreakEffect()
			if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 and not Duel.GetMatchingGroupCount(c24562484.e4fil,tp,LOCATION_REMOVED,0,nil,e,tp)<=0 and not tc:IsFaceup() then return false end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c24562484.eqlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
		end
	end
end
function c24562484.eqlimit(e,c)
	return c:IsSetCard(0x9390)
end
function c24562484.filter0(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function c24562484.filter1(c,e)
	return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c24562484.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9390) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,cv,chkf)
end
function c24562484.filter3(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c24562484.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cv=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c24562484.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c24562484.filter3,tp,LOCATION_DECK,0,nil)
		local mg5=Duel.GetMatchingGroup(c24562484.filter3,tp,LOCATION_SZONE,0,nil)
		mg1:Merge(mg2)
		mg1:Merge(mg5)
		local res=Duel.IsExistingMatchingCard(c24562484.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,cv)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c24562484.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf,cv)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c24562484.e3op(e,tp,eg,ep,ev,re,r,rp)
	local cv=e:GetHandler()
	local chkf=tp
	if cv:IsFacedown() or not cv:IsRelateToEffect(e) or cv:IsImmuneToEffect(e) or not cv:IsAbleToRemove() then return false end
	local mg1=Duel.GetFusionMaterial(tp):Filter(c24562484.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c24562484.filter3,tp,LOCATION_DECK,0,nil)
	local mg5=Duel.GetMatchingGroup(c24562484.filter3,tp,LOCATION_SZONE,0,nil)
	mg1:Merge(mg2)
	mg1:Merge(mg5)
	local sg1=Duel.GetMatchingGroup(c24562484.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,cv)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c24562484.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf,cv)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,cv,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,cv,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c24562484.ttfil(c)
	return c:IsReleasable() and c:IsFaceup() and c:IsSetCard(0x9390)
end
function c24562484.ttcon(e,c)
	return Duel.GetMatchingGroupCount(c24562484.ttfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>0
end
function c24562484.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c24562484.ttfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Release(g,REASON_COST)
end