--悲剧的幸存者 拉结尔
function c12026025.initial_effect(c)
	  --set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12026025,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12026025)
	e1:SetTarget(c12026025.settg)
	e1:SetOperation(c12026025.setop)
	c:RegisterEffect(e1)
	--set
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(12026025,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c12026025.cpcon)
	e6:SetTarget(c12026025.target)
	e6:SetOperation(c12026025.activate)
	c:RegisterEffect(e6)
end
function c12026025.describe_with_Raphael(c)
	local m=_G["c"..c:GetCode()]
	return m and m.lighting_with_Raphael
end
function c12026025.filter(c)
	return c12026025.describe_with_Raphael(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c12026025.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c12026025.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12026025.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c12026025.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c12026025.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c12026025.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetType()==TYPE_SPELL and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c12026025.describe_with_Raphael(re:GetHandler())
end
function c12026025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local tg=re:GetTarget()
		local event=re:GetCode()
		if event==EVENT_CHAINING then return
		   not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		else		 
		   local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
		   return not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0)
		end
		return re:GetHandler():IsRelateToEffect(re) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	local event=re:GetCode()
	e:SetLabelObject(re)
	e:SetCategory(re:GetCategory())
	e:SetProperty(re:GetProperty())
	e:SetLabel(re:GetLabel())
	local tg=re:GetTarget()
	if event==EVENT_CHAINING then
	   if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	else
	   local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
	   if tg then tg(e,tp,teg,tep,tev,tre,tr,trp,1) end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c12026025.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:GetOriginalCode()==12026025 then return end
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	Duel.BreakEffect()
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end