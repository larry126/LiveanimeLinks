--Cardian - Botan ni Cho
function c511001724.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511001724,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c511001724.spcost)
	e1:SetTarget(c511001724.sptg)
	e1:SetOperation(c511001724.spop)
	c:RegisterEffect(e1,false,2)
	--synchro level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetOperation(c511001724.synop)
	c:RegisterEffect(e3)
	aux.CallToken(419)
end
function c511001724.filter(c,ft,tp)
	local re=c:GetReasonEffect()
	return (ft>0 or c:GetSequence()<5) and c:GetLevel()==6 and c:IsSetCard(0xe6)
		and (not c:IsSummonType(SUMMON_TYPE_SPECIAL) or (not re or not re:GetHandler():IsSetCard(0xe6) or not re:GetHandler():IsType(TYPE_MONSTER)))
end
function c511001724.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,c511001724.filter,1,false,nil,nil,ft,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,c511001724.filter,1,1,false,nil,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c511001724.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c511001724.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)>0 then
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		Duel.Draw(tp,1,REASON_EFFECT)
		if tc then
			Duel.ConfirmCards(1-tp,tc)
			if c419.cardianchk(tc,tp,eg,ep,ev,re,r,rp) then
				Duel.ShuffleHand(tp)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
	end
end
function c511001724.synop(e,tg,ntg,sg,lv,sc,tp)
	local res=sg:CheckWithSumEqual(Card.GetSynchroLevel,lv,sg:GetCount(),sg:GetCount(),sc) 
		or sg:CheckWithSumEqual(function() return 2 end,lv,sg:GetCount(),sg:GetCount())
	return res,true
end
