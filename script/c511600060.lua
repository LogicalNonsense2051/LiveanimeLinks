--オーバーロード・アンカー (Anime)
--Overload Anchor (Anime)
--scripted by Larry126
--cleaned up by MLD
function c511600060.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetTarget(c511600060.target)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2414168,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c511600060.con)
	e2:SetTarget(c511600060.tg)
	e2:SetOperation(c511600060.op)
	c:RegisterEffect(e2)
end
function c511600060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ex,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE,true)
	if ex and c511600060.con(e,tp,teg,tep,tev,tre,tr,trp) and c511600060.tg(e,tp,teg,tep,tev,tre,tr,trp,0) and Duel.SelectYesNo(tp,94) then
		c511600060.tg(e,tp,teg,tep,tev,tre,tr,trp,1)
		e:SetOperation(c511600060.op)
	else
		e:SetOperation(nil)
	end
end
function c511600060.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return Duel.GetAttacker():IsControler(1-tp) and g:GetCount()==1 and tc:IsFaceup() and tc:IsType(TYPE_LINK)
end
function c511600060.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	e:SetLabelObject(nil)
	Duel.SetTargetCard(tc)
end
function c511600060.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
		if not tc:IsImmuneToEffect(e1) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CHANGE_DAMAGE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
			e2:SetTargetRange(1,0)
			e2:SetValue(c511600060.damval)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_DAMAGE_STEP_END)
			e3:SetLabelObject(e2)
			e3:SetCondition(c511600060.edcon)
			e3:SetOperation(c511600060.edop)
			e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c511600060.damval(e,re,val,r,rp,rc)
	if r==REASON_BATTLE then
		e:SetLabel(1)
		return val/2
	else return val end
end
function c511600060.edcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end
function c511600060.edop(e,tp,eg,ep,ev,re,r,rp)
	Duel.BreakEffect()
	e:GetLabelObject():SetLabel(0)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	local c=e:GetOwner()
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2137678,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e3:SetOwnerPlayer(tp)
	e3:SetCondition(c511600060.atkcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c511600060.atktg)
	e3:SetOperation(c511600060.atkop)
	c:RegisterEffect(e3)
end
function c511600060.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsControler(e:GetOwnerPlayer()) and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c511600060.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c511600060.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511600060.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c511600060.atkop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c511600060.filter,tp,0,LOCATION_MZONE,nil)
	sg:ForEach(function(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e1:SetValue(tc:GetAttack()/2)
		tc:RegisterEffect(e1)
	end)
end
