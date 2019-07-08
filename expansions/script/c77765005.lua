local m=77765005
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
cm.Senya_name_with_difficulty=1
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCountLimit(1,m)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	local function f(c,tp)
		return c:IsFaceup() and Kaguya.IsDifficulty(c) and c:IsAbleToChangeControler() and Duel.GetLocationCount(1-c:GetControler(),LOCATION_SZONE,tp)>0
	end
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local c=e:GetHandler()
		if chkc then return chkc:IsLocation(LOCATION_SZONE) and f(chkc) and chkc~=c end
		if chk==0 then return Duel.IsExistingTarget(f,tp,LOCATION_SZONE,LOCATION_SZONE,1,c) and Duel.IsPlayerCanDraw(tp,1) end
		local g=Duel.SelectTarget(tp,f,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,c)
		e:SetLabel(g:GetFirst():GetControler())
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		local p=e:GetLabel()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(p) and not tc:IsImmuneToEffect(e) and Duel.GetLocationCount(1-p,LOCATION_SZONE,tp)>0 then
			Duel.MoveToField(tc,tp,1-p,LOCATION_SZONE,POS_FACEUP,true)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,m+100)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsReason(REASON_DRAW)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or ft<=0 then return end
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		local tg=g:Filter(Kaguya.IsDifficulty,nil)
		if ft<#tg then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			tg=tg:Select(tp,ft,ft,nil)
		end
		for tc in aux.Next(tg) do
			Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			if not tc:IsType(TYPE_CONTINUOUS+TYPE_FIELD+TYPE_EQUIP) then
				tc:CancelToGrave()
			end
		end
	end)
	c:RegisterEffect(e2)
end
