C9=C9 or {}

-------------------------------------------
nef=Effect.CreateEffect
tpara={e,tp,eg,ep,ev,re,r,rp}
para=table.unpack(tpara)
-------------------------------------------

function C9.TojiMonster(c)
	--Equip Okatana
	local e1=nef(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(C9.Eqcon1)
	e1:SetOperation(C9.Eqop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=nef(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(C9.Eqcon2)
	e3:SetOperation(C9.Eqop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=nef(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetCondition(C9.Eqcon3)
	e5:SetOperation(C9.Eqop1)
	e5:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e5)
	--Chain Attack
	local e6=nef(c)
	e6:SetDescription(aux.Stringid(20100000,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_START)
	e6:SetTarget(C9.TojiChainAttackTg)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetOperation(C9.TojiChainAttackOp)
	e6:SetCountLimit(1)
	c:RegisterEffect(e6)
	if not C9.battle_check then
		C9.battle_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
		ge1:SetOperation(C9.BattleCheckOp)
		Duel.RegisterEffect(ge1,0)
	end
end

function C9.BattleCheckOp(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	Duel.RegisterFlagEffect(p,20100000,RESET_PHASE+PHASE_BATTLE,0,1)
end

function C9.Eqcon1(e,tp,eg,ep,ev,re,r,rp)
	if not re then return true end
	return not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end

function C9.Eqcon2(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end

function C9.Eqcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(20100000)~=0
end

function C9.TojiEquip(ec,code,e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,code)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	token:CancelToGrave()
	local e1_1=Effect.CreateEffect(token)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
	e1_1:SetReset(RESET_EVENT+0x1fc0000)
	token:RegisterEffect(e1_1,true)
	local e1_2=Effect.CreateEffect(token)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_EQUIP_LIMIT)
	e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_2:SetValue(1)
	token:RegisterEffect(e1_2,true)
	token:CancelToGrave()   
	if Duel.Equip(tp,token,ec,false) then 
		if code==20100201 then  --御 刀 加 州 清 光
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(300)
			token:RegisterEffect(e2_1)
			--extra summon
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetDescription(aux.Stringid(20100201,0))
			e2_2:SetType(EFFECT_TYPE_FIELD)
			e2_2:SetRange(LOCATION_SZONE)
			e2_2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
			e2_2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
			e2_2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc90))
			token:RegisterEffect(e2_2)
		elseif code==20100203 then  --御 刀 莲 华 不 动 辉 广
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(200)
			token:RegisterEffect(e2_1)
			--tograve
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetDescription(aux.Stringid(20100203,0))
			e2_2:SetCategory(CATEGORY_TOGRAVE)
			e2_2:SetType(EFFECT_TYPE_IGNITION)
			e2_2:SetRange(LOCATION_SZONE)
			e2_2:SetCountLimit(1)
			e2_2:SetTarget(C9.MusumiKiyokaTg)
			e2_2:SetOperation(C9.MusumiKiyokaOp)
			token:RegisterEffect(e2_2)
		elseif code==20100205 then  --御 刀 北 谷 菜 切 二 王 清 纲
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(300)
			token:RegisterEffect(e2_1)
			--Destroy
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetDescription(aux.Stringid(20100205,0))
			e2_2:SetCategory(CATEGORY_DESTROY)
			e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e2_2:SetCode(EVENT_BATTLE_DAMAGE)
			e2_2:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e2_2:SetRange(LOCATION_SZONE)
			e2_2:SetCountLimit(1)
			e2_2:SetCondition(C9.ShichinosatoKofukiCon)
			e2_2:SetTarget(C9.ShichinosatoKofukiTg)
			e2_2:SetOperation(C9.ShichinosatoKofukiOp)
			token:RegisterEffect(e2_2)
		elseif code==20100207 then  --御 刀 骚 速 剑
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_DEFENSE)
			e2_1:SetValue(400)
			token:RegisterEffect(e2_1)
			--special summon
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetDescription(aux.Stringid(20100207,0))
			e2_2:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e2_2:SetType(EFFECT_TYPE_IGNITION)
			e2_2:SetCountLimit(1,20100207)
			e2_2:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e2_2:SetRange(LOCATION_SZONE)
			e2_2:SetTarget(C9.SetouchiChieTg)
			e2_2:SetOperation(C9.SetouchiChieOp)
			token:RegisterEffect(e2_2)
		elseif code==20100209 then  --御 刀 实 休 光 忠
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(200)
			token:RegisterEffect(e2_1)
			--to hand
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			e2_2:SetType(EFFECT_TYPE_IGNITION)
			e2_2:SetRange(LOCATION_SZONE)
			e2_2:SetCountLimit(1)
			e2_2:SetTarget(C9.KitoraMirjaTg)
			e2_2:SetOperation(C9.KitoraMirjaOp)
			token:RegisterEffect(e2_2)
		elseif code==20100211 then  --御 刀 千 鸟
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(400)
			token:RegisterEffect(e2_1)
			--to deck
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetType(EFFECT_TYPE_EQUIP)
			e2_2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
			e2_2:SetValue(LOCATION_DECKSHF)
			token:RegisterEffect(e2_2)
		elseif code==20100213 then  --御 刀 小 乌 丸
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(400)
			token:RegisterEffect(e2_1)
			--direct attack
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetType(EFFECT_TYPE_EQUIP)
			e2_2:SetCode(EFFECT_DIRECT_ATTACK)
			e2_2:SetCondition(C9.JujoHiyoriCon)
			token:RegisterEffect(e2_2)
		elseif code==20100215 then  --御 刀 孙 六 兼 元
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_FIELD)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetRange(LOCATION_SZONE)
			e2_1:SetTargetRange(LOCATION_MZONE,0)
			e2_1:SetCondition(C9.YanaseMaiCon)
			e2_1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc90))
			e2_1:SetValue(300)
			token:RegisterEffect(e2_1)
		elseif code==20100217 then  --御 刀 妙 法 村 正
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(300)
			token:RegisterEffect(e2_1)
			--immune
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetType(EFFECT_TYPE_EQUIP)
			e2_2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2_2:SetCondition(C9.YanaseMaiCon)
			e2_2:SetValue(C9.ItomiSayakaVal)
			token:RegisterEffect(e2_2)
			--must attack
			local e2_3=Effect.CreateEffect(ec)
			e2_3:SetType(EFFECT_TYPE_EQUIP)
			e2_3:SetCode(EFFECT_MUST_ATTACK)
			token:RegisterEffect(e2_3)
		elseif code==20100219 then  --御 刀 弥 弥 切 丸
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(800)
			token:RegisterEffect(e2_1)
			--Pierce
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetType(EFFECT_TYPE_EQUIP)
			e2_2:SetCode(EFFECT_PIERCE)
			token:RegisterEffect(e2_2)
		elseif code==20100222 then  --御 刀 越 前 康 继
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(300)
			token:RegisterEffect(e2_1)
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetType(EFFECT_TYPE_EQUIP)
			e2_2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2_2:SetValue(300)
			token:RegisterEffect(e2_2)
			--atk limit
			local e2_3=Effect.CreateEffect(ec)
			e2_3:SetType(EFFECT_TYPE_FIELD)
			e2_3:SetRange(LOCATION_SZONE)
			e2_3:SetTargetRange(0,LOCATION_MZONE)
			e2_3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
			e2_3:SetValue(C9.KohaguraErenVal)
			token:RegisterEffect(e2_3)
			--target
			local e2_4=Effect.CreateEffect(ec)
			e2_4:SetType(EFFECT_TYPE_FIELD)
			e2_4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e2_4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
			e2_4:SetRange(LOCATION_SZONE)
			e2_4:SetTargetRange(LOCATION_MZONE,0)
			e2_4:SetTarget(C9.KohaguraErenVal)
			e2_4:SetValue(aux.tgoval)
			token:RegisterEffect(e2_4)
		elseif code==20100224 then  --御 刀 薄 绿
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(400)
			token:RegisterEffect(e2_1)
			--actlimit
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetType(EFFECT_TYPE_FIELD)
			e2_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2_2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2_2:SetRange(LOCATION_SZONE)
			e2_2:SetTargetRange(0,1)
			e2_2:SetValue(aux.TRUE)
			e2_2:SetCondition(C9.ShidouMakiCon)
			token:RegisterEffect(e2_2)
		elseif code==20100226 then  --御 刀 九 字 兼 定
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(300)
			token:RegisterEffect(e2_1)
			--act limit
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2_2:SetCode(EVENT_CHAINING)
			e2_2:SetRange(LOCATION_SZONE)
			e2_2:SetCondition(C9.YanaseMaiCon)
			e2_2:SetOperation(C9.KonohanaSuzukaOp)
			token:RegisterEffect(e2_2)
		elseif code==20100228 then  --御 刀 水 神 切 兼 光
			--atk
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetCategory(CATEGORY_ATKCHANGE)
			e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e2_1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
			e2_1:SetRange(LOCATION_SZONE)
			e2_1:SetCondition(C9.SatsukiYumiCon)
			e2_1:SetCost(C9.SatsukiYumiCost)
			e2_1:SetOperation(C9.SatsukiYumiOp)
			token:RegisterEffect(e2_1)
		elseif code==20100230 then  --御 刀 笑 面 青 江
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(400)
			token:RegisterEffect(e2_1)
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetCategory(CATEGORY_ATKCHANGE)
			e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e2_2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
			e2_2:SetRange(LOCATION_SZONE)
			e2_2:SetCondition(C9.TsubakuroYumeCon)
			e2_2:SetOperation(C9.TsubakuroYumeOp)
			token:RegisterEffect(e2_2)
		elseif code==20100232 then  --御 刀 童 子 切 安 纲
			local e2_1=Effect.CreateEffect(ec)
			e2_1:SetType(EFFECT_TYPE_EQUIP)
			e2_1:SetCode(EFFECT_UPDATE_ATTACK)
			e2_1:SetValue(500)
			token:RegisterEffect(e2_1)
			local e2_2=Effect.CreateEffect(ec)
			e2_2:SetType(EFFECT_TYPE_SINGLE)
			e2_2:SetRange(LOCATION_SZONE)
			e2_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e2_2:SetCode(EFFECT_LINK_SPELL_KOISHI)
			e2_2:SetValue(LINK_MARKER_TOP)
			token:RegisterEffect(e2_2) 
		end
		return true
	else Duel.SendtoGrave(token,REASON_RULE) return false
	end
end

function C9.Eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local m=c:GetOriginalCode()
	c:ResetFlagEffect(20100000)
	if c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		C9.TojiEquip(c,m+1,e,tp,eg,ep,ev,re,r,rp)
	end
end

function C9.Eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(20100000,RESET_CHAIN,0,1)   
end

function C9.TojiChainAttackTg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	if chk==0 then return ac:IsControler(tp) and ac:IsSetCard(0xc90) and ac~=c 
		and c:GetAttackAnnouncedCount()==0 and c:IsAttackable() end
	Duel.SetTargetCard(c)
end

function C9.TojiChainAttackOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	local atk=c:GetAttack()
	if atk<1 then return end
	if ac:IsFaceup() and ac:IsRelateToBattle() and c:IsRelateToEffect(e) then
		local e1=nef(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1) 
		local e2=nef(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(C9.TojiChainAttackCon)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		ac:RegisterEffect(e2)
	end
end
function C9.TojiChainAttackCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and c:IsRelateToBattle()  
end

--Okatana Effect Function
-----------------------------------------------------------------------------------------------------------
function C9.MusumiKiyokaFilter(c)
	return c:IsSetCard(0xc90) and c:IsAbleToGrave()
end
function C9.MusumiKiyokaTg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(C9.MusumiKiyokaFilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function C9.WarriorSpLimit(e,c)
	return not c:IsRace(RACE_WARRIOR) and c:IsLocation(LOCATION_EXTRA)
end
function C9.MusumiKiyokaOp(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,C9.MusumiKiyokaFilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(C9.WarriorSpLimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function C9.ShichinosatoKofukiCon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function C9.ShichinosatoKofukiFilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function C9.ShichinosatoKofukiTg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and C9.ShichinosatoKofukiFilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,C9.ShichinosatoKofukiFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function C9.ShichinosatoKofukiOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(200)
			ec:RegisterEffect(e1)
		end
	end
end
function C9.SetouchiChieFilter(c,e,tp)
	return c:IsSetCard(0xc90) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function C9.SetouchiChieTg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and C9.SetouchiChieFilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(C9.SetouchiChieFilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,C9.SetouchiChieFilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function C9.SetouchiChieOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(C9.WarriorSpLimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function C9.KitoraMirjaFilter(c)
	return c:IsSetCard(0xc91) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function C9.KitoraMirjaTg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(C9.KitoraMirjaFilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function C9.KitoraMirjaOp(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,C9.KitoraMirjaFilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(C9.WarriorSpLimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function C9.JujoHiyoriCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local ecc=ec:GetControler()
	local cg=ec:GetColumnGroup()
	return cg:FilterCount(Card.IsControler,nil,1-ecc)==0
end
function C9.YanaseMaiCon(e)
	local p=e:GetHandler():GetControler()
	local fec1=Duel.GetFlagEffect(p,20100000)
	local fec2=Duel.GetFlagEffect(1-p,20100000)
	return fec1>0 or fec2>0
end
function C9.ItomiSayakaVal(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function C9.KohaguraErenVal(e,c)
	return c~=e:GetHandler():GetEquipTarget()
end
function C9.ShidouMakiCon(e)
	local tc=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc
end
function C9.KonohanaSuzukaOp(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xc90) then
		Duel.SetChainLimit(C9.KonohanaSuzukaChainLim)
	end
end
function C9.KonohanaSuzukaChainLim(e,rp,tp)
	return tp==rp
end
function C9.SatsukiYumiCon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec~=Duel.GetAttacker() and ec~=Duel.GetAttackTarget() then return false end
	local tc=ec:GetBattleTarget()
	return tc and tc:IsFaceup() and (tc:GetAttack())>(ec:GetAttack())
end
function C9.SatsukiYumiCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	local atk1=ec:GetAttack()
	local atk2=ec:GetBattleTarget():GetAttack()
	local dif=atk2-atk1
	local a1=math.ceil(dif/1000)
	if (dif%1000)==0 then a1=a1+1 end
	if chk==0 then return Duel.CheckLPCost(tp,a1*1000) end
	Duel.PayLPCost(tp,a1*1000)
	e:SetLabel(a1*1000)
end
function C9.SatsukiYumiOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ec=c:GetEquipTarget()
	local atk=e:GetLabel()
	if ec and ec:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		ec:RegisterEffect(e1)
	end
end
function C9.TsubakuroYumeCon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local ec=e:GetHandler():GetEquipTarget()
	local tc=ec:GetBattleTarget()
	return ec==Duel.GetAttacker() and tc and tc:IsFaceup() and tc:IsControler(1-tp) and tc:GetAttack()>0
end
function C9.TsubakuroYumeOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ec=c:GetEquipTarget()
	local tc=ec:GetBattleTarget()
	if ec:IsRelateToBattle() and ec:IsFaceup() and tc:IsRelateToBattle() and tc:IsFaceup() and tc:GetAttack()>0 then
		for i=1,3 do
			local op1=Duel.SelectOption(tp,aux.Stringid(20100229,1),aux.Stringid(20100229,2))
			local op2=Duel.SelectOption(1-tp,aux.Stringid(20100229,1),aux.Stringid(20100229,2))
			Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(20100229,op2+1))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(20100229,op1+1))
			if op1~=op2 then
				local e1=Effect.CreateEffect(ec)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetValue(-1000)
				tc:RegisterEffect(e1)
			end
		end
	end   
end
-----------------------------------------------------------------------------------------------------------