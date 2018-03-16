script "beefy_combat.ash";
import "beefy_tools.ash";
import "beefy_combat_tools.ash";

boolean _deleveled;

//////////////////////////////////
//Macro String Generators
	//////////////////////////////////
	//Group
buffer MakeSub(buffer subcontent, string subname)
{
	buffer mysub;
	mysub.append("sub " + subname + ";");
	mysub.append(subcontent);
	mysub.append("endsub;");
	return mysub;
}
buffer MakeSub(string subcontent, string subname)
{
	buffer mysub;
	mysub.append("sub " + subname + ";");
	mysub.append(subcontent);
	mysub.append("endsub;");
	return mysub;
}
	//////////////////////////////////
	//Skills
buffer GenWhileSkillAction(int skid)
{
	buffer skill_action;
	skill_action.append("while hasskill ");
	skill_action.append(skid + ";");
	skill_action.append("skill " + skid + ";");
	skill_action.append("endwhile;");
	return skill_action;
}
buffer GenWhileSkillAction(string skname)
{
	buffer skill_action;
	skill_action.append("while hasskill ");
	skill_action.append(skname + ";");
	skill_action.append("skill " + skname + ";");
	skill_action.append("endwhile;");
	return skill_action;
}
buffer GenWhileSkillAction(skill sk)
{
	return GenWhileSkillAction(sk);
}

buffer GenSkillAGenWhileSkillActionction(int skid)
{
	buffer skill_action;
	skill_action.append("if hasskill ");
	skill_action.append(skid + ";");
	skill_action.append("skill " + skid + ";");
	skill_action.append("endif;");
	return skill_action;
}
buffer GenSkillAction(string skname)
{
	buffer skill_action;
	skill_action.append("if hasskill ");
	skill_action.append(skname + ";");
	skill_action.append("skill " + skname + ";");
	skill_action.append("endif;");
	return skill_action;
}
buffer GenSkillAction(skill sk)
{
	return GenSkillAction(sk);
}
	//////////////////////////////////
	//Items
buffer GenItemAction(int itid)
{
	buffer item_action;
	item_action.append("if hascombatitem ");
	item_action.append(itid + ";");
	item_action.append("use " + itid + ";");
	item_action.append("endif;");
	return item_action;
}
buffer GenItemAction(string itname)
{
	buffer item_action;
	item_action.append("if hascombatitem ");
	item_action.append(itname + ";");
	item_action.append("use " + itname + ";");
	item_action.append("endif;");
	return item_action;
}
buffer GenItemAction(item it)
{
	buffer item_action;
	item_action.append("if hascombatitem ");
	item_action.append(it.name + ";");
	item_action.append("use " + it + ";");
	item_action.append("endif;");
	return item_action;
}
//////////////////////////////////
//
void doCombatScript(string script)
{
    visit_url("fight.php?action=macro&macrotext=" + url_encode(script) ,true,true);
}
void doCombatScript(buffer script)
{
    doCombatScript(to_string(script));
}

buffer Stealing()
{
	buffer stealing;
	stealing.append(GenSkillAction(7172));//Steal Accordian
	stealing.append("pickpocket");

	return stealing;
	//doCombatScript(stealing.to_string());
}

buffer Gathering()
{
    buffer gathering;
	gathering.append(GenSkillAction(7273));//Extract

	if(monster_element() != $element[none])
	{
		gathering.append(GenSkillAction(7282));//Extract Jelly
	}

	//Frat/Hippie Band Quest
	gathering.append(GenItemAction("jam band flyers"));
	gathering.append(GenItemAction("rock band flyers"));

	//Pirate
	//if (snarfblat 66 || snarfblat 157 || snarfblat 158 || snarfblat 159)
	if(last_monster().manuel_name.to_lower_case().contains_text("pirate"))
	{
		gathering.append(GenItemAction("Big Book of Pirate Insults"));
		gathering.append(GenItemAction("Massive Manual of Marauder Mockery"));
	}
	return gathering;
    //doCombatScript(gathering);
}

buffer Delevel()
{
	buffer deleveling;

	if(my_class() != $class[Pastamancer])
	{//Entangling Noodles
		deleveling.append(GenSkillAction("Entangling Noodles"));
	}
	//Micrometeorite
	deleveling.append(GenSkillAction("Micrometeorite"));

	//Censorious Lecture
	deleveling.append(GenSkillAction("Censorious Lecture"));

	//Fire Sewage Pistol
	deleveling.append(GenSkillAction("Fire Sewage Pistol"));

	//little red book
	deleveling.append(GenItemAction("little red book"));

	//Time-spinner
	deleveling.append(GenSkillAction("Time-Spinner"));

    _deleveled = true;
	return deleveling;
	//doCombat(delevels);
}

buffer CombatMagicPref()
{
    buffer mattack;
	skdmg [int] bdmgs = best_skills("spell");
	foreach num in bdmgs
	{
		if (sk_cast_once contains bdmgs[num].sk)
		{
			mattack.append("skill " + bdmgs[num].sk + ";");
		}
		else
		{
			mattack.append("skill " + bdmgs[num].sk + "; repeat;");
			break;
		}
	}

	mattack.append("skill saucestorm; repeat;");
    return mattack;
	//doCombatScript(mattack);
}

buffer CombatPref(string sktype)
{
    buffer attack;
	skdmg [int] bdmgs = best_skills("sktype");
	foreach num in bdmgs
	{
		string skstring;
		if(bdmgs[num].sk == $skill[none])
		{
			skstring = "attack;";
		}
		else
		{
			skstring = "skill " + bdmgs[num].sk + ";";
		}
		if (sk_cast_once contains bdmgs[num].sk)
		{
			attack.append(skstring);
		}
		else
		{
			attack.append(skstring + " repeat;");
			break;
		}
	}

    return attack;
}

buffer GetTTattack()
{
	buffer ttattack;
	/*
    if (have_skill(to_skill(2005)))
    {
        return "skill Shieldbutt; repeat;";
    }
    else if (have_skill(to_skill(2015)))
    {
        return "skill Kneebutt; repeat;";
    }
    else if (have_skill(to_skill(2003)))
    {
        return "skill Headbutt; repeat;";
    }*/

	ttattack.append("attack; repeat;");
    return ttattack;
}

buffer AllTheSmacks()
{
	buffer scattack;
	//Thrust-Smack
	scattack.append(GenWhileSkillAction(1003));
	//Lunge Smack
	scattack.append(GenWhileSkillAction(1004));
	//Clobber
	scattack.append(GenWhileSkillAction(1022));

	return scattack;

}

buffer GetSCattack(string type)
{
	buffer scattack;	
	switch(type)
	{
		case "magic":
			scattack.append("skill saucestorm;");
		break;
		case "fight":
			scattack.append("attack;repeat;");
		break;
		case "willhit":
			scattack.append("attack;repeat;");
		break;
		case "willmiss":
			if(equipped_item($slot[weapon]).item_type() == "club")
			{
				scattack.append(AllTheSmacks());
			}
			else
			{
				scattack.append("skill saucestorm;");
			}
		break;
	}
	scattack = MakeSub(scattack,"myattack");
	scattack.append("call myattack;");
	scattack.append("repeat;");
	return scattack;
}

void CombatMeleePref()
{
    string attack;
	string missattack = CombatPref("spell");
	string hitattack = CombatPref("");

    if((! will_usually_miss() ))
    {
        attack = hitattack;
    }
    else if ( ! _deleveled)
    {
        //Delevel();
        if ( ! will_usually_miss())
        {
            attack = hitattack;
        }
        else
        {
			
            attack =missattack;
        }
    }
    else
    {

        attack = missattack;
    }
    doCombatScript(attack); 
}


void GhostBust()
{
    string bustit = "#####Ghost check \
    if hasskill 7279 \
        skill 7279 \
        repeat hasskill 7279 \
        skill 7280 \
        #trap ghost \
    endif";
    doCombatScript(bustit);
}
void StaggerActions()
{
	string staggeractions = "##damage	\
    if hasskill Fire Death Ray	\
        skill Fire Death Ray	\
    endif	\
    if hascombatitem beehive	\
        use beehive	\
    endif	\
    ###Other	\
    if hascombatitem nasty-smelling moss	\
        ##Heals	\
		if hascombatitem jam band flyers	\
			use nasty-smelling moss, jam band flyers	\
		endif	\
		if hascombatitem rock band flyers	\
			use nasty-smelling moss, rock band flyers	\
		endif	\
		if !hascombatitem jam band flyers && !hascombatitem rock band flyers	\
			use nasty-smelling moss \
		endif\
    endif";

    doCombatScript(staggeractions);
}
void main()
{
    _deleveled = false;
	doCombatScript(Stealing());
	doCombatScript(Gathering());

    GhostBust();
	print("to stagger actions");
    StaggerActions();
	
    if((! will_usually_dodge()) && (_deleveled == false))
    {
		print("to delevel actions");
		doCombatScript(Delevel());
    }

    if(my_class().primestat == $stat[Muscle] || my_class().primestat == $stat[Moxie])
    {//does not handle $class[none] atm
		print("to possible physical attack actions");
        CombatMeleePref();
    }
    else
    {
		print("to magic attack actions");
        doCombatScript(CombatMagicPref());
    }
}
