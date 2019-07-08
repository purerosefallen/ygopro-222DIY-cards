--出阵！刻下一闪之灯火
local m=20100233
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100000") end,function() require("script/c20100000") end)
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)   
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.lfcon)
	e3:SetTarget(cm.lftg)
	e3:SetOperation(cm.lfop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(C9.YanaseMaiCon)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc90))
	e4:SetValue(300)
	c:RegisterEffect(e4)
end

function cm.tgfilter(c,ec)
	if c:IsType(TYPE_PENDULUM) then return false end
	local code=c:GetOriginalCode()
	if ec:GetFlagEffect(code)>0 then return false end
	if c:IsLocation(LOCATION_SZONE) and c:IsFacedown() then return false end
	return c:IsSetCard(0xc91) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave()
end

function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_SZONE+LOCATION_DECK,0,1,e:GetHandler(),e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_SZONE)
end

function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK+LOCATION_SZONE,0,1,1,c,c)
	if g:GetCount()>0 then
		if g:GetFirst():IsLocation(LOCATION_DECK) then
			Duel.ConfirmCards(1-tp,g)
		end
		Duel.SendtoGrave(g,REASON_EFFECT)
		local code=g:GetFirst():GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,0))
	end
end
function cm.lfcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function cm.lftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.lffilter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xc91)
end

function cm.lfop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.lffilter),tp,LOCATION_GRAVE,0,2,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.lffilter),tp,LOCATION_GRAVE,0,2,5,nil)
	if g:GetCount()>0 then 
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct==g:GetCount() then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end