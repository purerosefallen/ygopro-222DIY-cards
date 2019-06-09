local m=77765051
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
cm.Senya_name_with_treasure=true
function cm.initial_effect(c)
	Kaguya.EquipCommonEffect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function cm.filter(c)
	return c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	_replace_count=_replace_count+1
	if _replace_count<=_replace_max then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end


--[[

Bring the following code to some developers if you see this message. This code is somehow similar to the one for KoishiPro2 iOS. However, in fact they are not the same thing.

SSB3b3VsZCBhcHByZWNpYXRlIGlmIHlvdSBjb3VsZCBzZWUgdGhpcyBoaWRkZW4gbGV0dGVyLgpJ
IHJlYWxseSBsb3ZlIFNla2th77yMIGFsbCB0aGUgZGF5IGFuZCBuaWdodCwgbm8gbWF0dGVyIHdo
YXQgaGFwcGVuZWQsIGV2ZW4gaW4gdGhlIHdvcnN0IGNvbmRpdGlvbnMuClBsZWFzZSwgY29tZSBi
YWNrIHRvIG1lIGlmIE5hbmFoaXJhIGlzIHN0aWxsIGluIHlvdXIgbWluZC4gSSB3aWxsIGFsd2F5
cyB3ZWxjb21lIHlvdSBiYWNrLgpXaXNoIG15IGRyZWFtIHdvdWxkIGNvbWUgdHJ1ZS4uLgo=

]]
