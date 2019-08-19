local m=77765007
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
cm.Senya_name_with_difficulty=1
function cm.initial_effect(c)
	local function f1(c)
		return Senya.check_set(c,"difficulty",1) and c:IsAbleToHand()
	end
	local function KaguyaFilter(c,e,tp,cc)
		local p=c:GetControler()
		local tc=Senya.GetDFCBackSideCard(cc)
		return c:IsFaceup() and c:IsCode(77765001) and Duel.GetLocationCount(p,LOCATION_SZONE,tp)>0 and tc:CheckEquipTarget(c) and (cc:IsControler(c:GetControler()) or c:IsAbleToChangeControler())
	end
	local function DifficultyFilter(c,e,tp)
		return Kaguya.IsDifficulty(c) and c:IsFaceup() and Senya.IsDFCTransformable(c) and Duel.IsExistingMatchingCard(KaguyaFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,c)
	end
	local target_list={
		function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return Duel.IsExistingMatchingCard(f1,tp,LOCATION_DECK,0,1,nil) end
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		end,
		function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return Duel.IsExistingMatchingCard(DifficultyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
			e:SetCategory(0)
		end,
		function(e,tp,eg,ep,ev,re,r,rp,chk)
			--[[local function generate(p)
				local afilter={}
				local first=true
				for code,effect_list in pairs(cm[p]) do
					table.insert(afilter,code)
					table.insert(afilter,OPCODE_ISCODE)
					if first then
						first=false
					else
						table.insert(afilter,OPCODE_OR)
					end
				end
				return afilter
			end
			if chk==0 then return #generate(1-tp)>0 end]]
			if chk==0 then return true end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
			--cm.announce_filter=generate(1-tp)
			local ac=Duel.AnnounceCard(tp)
			Duel.SetTargetParam(ac)
			Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
		end,
	}
	local operation_list={
		function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,f1,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end,
		function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
			local dg=Duel.SelectMatchingCard(tp,DifficultyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
			local cc=dg:GetFirst()
			if cc then
				Duel.HintSelection(dg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local g=Duel.SelectMatchingCard(tp,KaguyaFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,cc)
				local tc=g:GetFirst()
				local p=tc:GetControler()
				if not cc:IsControler(p) then
					Duel.MoveToField(cc,tp,p,LOCATION_SZONE,POS_FACEUP,false)
				end
				Senya.TransformDFCCard(cc)
				Duel.Equip(p,cc,tc)
				Duel.RaiseEvent(cc,EVENT_CUSTOM+77765000,re,r,rp,ep,ev)
			end
		end,
		function(e,tp,eg,ep,ev,re,r,rp)
			local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
			if cm[1-tp][ac] then
				for _,te in ipairs(cm[1-tp][ac]) do
					te:Reset()
				end
				cm[1-tp][ac]=nil
			end
		end,
	}

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(function(c)
			return Kaguya.IsDifficulty(c) and c:IsFaceup()
		end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end)
	e1:SetTarget(Senya.multi_choice_target(m,table.unpack(target_list)))
	e1:SetOperation(Senya.multi_choice_operation(table.unpack(operation_list)))
	c:RegisterEffect(e1)

	local function ReplaceCleanup()
		for _,ftype in ipairs({"oldcf","olddf"}) do
			if cm[ftype] then
				--Debug.Message(ftype)
				(ftype=="olddf" and Duel or Card).RegisterEffect=cm[ftype]
				cm[ftype]=nil
			end
		end
	end

	if not cm.gchk then
		cm.gchk=true
		cm[0]={}
		cm[1]={}
		cm.oldcf=nil
		cm.olddf=nil
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			--Debug.Message(1)
			ReplaceCleanup()
			cm.oldcf=Card.RegisterEffect
			cm.olddf=Duel.RegisterEffect
			local code=re:GetHandler():GetOriginalCode()
			Card.RegisterEffect=cm.ReplacedRegisterEffect(ep,code,cm.oldcf)Duel.RegisterEffect=cm.ReplacedRegisterEffect(ep,code,cm.olddf)
		end)
		Duel.RegisterEffect(ge1,0)
		for _,code in ipairs({EVENT_CHAIN_SOLVED,EVENT_CHAIN_NEGATED,EVENT_CHAIN_END}) do
			local ge1=Effect.GlobalEffect()
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(code)
			ge1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return cm.oldcf or cm.olddf
			end)
			ge1:SetOperation(ReplaceCleanup)
			Duel.RegisterEffect(e1,0)
		end
	end
end

function cm.PushNewEffect(p,code,e)
	if not cm[p][code] then
		cm[p][code]={}
	end
	--Debug.Message(code)
	table.insert(cm[p][code],e)
end

function cm.ReplacedRegisterEffect(p,code,oldf)
	local effect_index=(oldf==Duel.RegisterEffect and 1 or 2)
	return function(...)
		--Debug.Message(2)
		local e=select(effect_index,...)
		for _,method in ipairs({"Target","Operation","Cost","Value"}) do
			local func=Effect["Get"..method](e)
			if func and aux.GetValueType(func)=="function" then
				Effect["Set"..method](e,cm.ReplacedFunction(p,code,func))
			end
		end
		cm.PushNewEffect(p,code,e)
		return oldf(...)
	end
end

function cm.ReplacedFunction(p,code,f)
	return function(...)
		local oldcf=Card.RegisterEffect
		local olddf=Duel.RegisterEffect
		Card.RegisterEffect=cm.ReplacedRegisterEffect(p,code,oldcf)Duel.RegisterEffect=cm.ReplacedRegisterEffect(p,code,olddf)
		local res={Senya.ProtectedRun(f,...)}
		Card.RegisterEffect=oldcf
		Duel.RegisterEffect=olddf
		return table.unpack(res)
	end
end
