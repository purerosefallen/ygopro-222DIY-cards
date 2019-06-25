local m=77765002
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
--竹取飛翔　～ Lunatic Princess
function c77765002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77765002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c77765002.activate)
	c:RegisterEffect(e1)
	--
	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)>0 and Duel.IsExistingMatchingCard(c77765002.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)<=0 then return end
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		 local g=Duel.SelectMatchingCard(tp,c77765002.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
		 Duel.SendtoGrave(g,REASON_EFFECT)
		local sc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,c77765002.filter2,tp,LOCATION_DECK,0,1,1,sc,sc)
		if #sg>0 then
			local tc=sg:GetFirst()
			local te=tc:GetActivateEffect()
			Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			c:SetCardTarget(tc)
			if te then
				te:UseCountLimit(tp,1,true)
			end
		end
	end)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	e2:SetOperation(c77765002.checkop)
	c:RegisterEffect(e2)
	local function KaguyaFilter(c,e,tp,cc)
		local p=c:GetControler()
		local tc=Senya.GetDFCBackSideCard(cc)
		return c:IsFaceup() and c:IsCode(77765001) and Duel.GetLocationCount(p,LOCATION_SZONE,tp)>0 and tc:CheckEquipTarget(c)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(0x14000+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local g=e:GetLabelObject():GetLabelObject()
		local tg=g:Filter(function(c)
			return Senya.IsDFCTransformable(c) and Duel.IsExistingMatchingCard(KaguyaFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,c)
		end,nil)
		if chk==0 then return #tg>0 end
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,tg,#tg,0,0)
	end)
	e3:SetOperation(function (e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=e:GetLabelObject():GetLabelObject()
		local tg=g:Filter(function(c)
			return Senya.IsDFCTransformable(c) and Duel.IsExistingMatchingCard(KaguyaFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,c)
		end,nil)
		for cc in aux.Next(tg) do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,KaguyaFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,cc)
			local tc=g:GetFirst()
			local p=tc:GetControler()
			if p~=cc:GetControler() then
				Duel.MoveToField(cc,p,p,LOCATION_SZONE,POS_FACEUP,true)
			end
			Senya.TransformDFCCard(cc)
			Duel.Equip(p,cc,tc)
		end
		Duel.RaiseEvent(tg,EVENT_CUSTOM+77765000,re,r,rp,ep,ev)
	end)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c77765002.filter(c,e,tp)
	return c:IsCode(77765001) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c77765002.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c77765002.filter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77765002,1))
	local g=Duel.SelectMatchingCard(tp,c77765002.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		if sc then
			if sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and (not sc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(77765002,2))) then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			end
		end
	end
end
function c77765002.filter1(c)
	return c:IsAbleToGrave() and Kaguya.IsDifficulty(c) and Duel.IsExistingMatchingCard(c77765002.filter2,tp,LOCATION_DECK,0,1,c,c)
end
function c77765002.filter2(c,mc)
	return c:IsCode(mc:GetCode())
end
function c77765002.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g:Clear()
	g:Merge(e:GetHandler():GetCardTarget())
end
