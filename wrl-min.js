"use strict";var limit=$.url().param("limit")||localStorage.getItem("limit")||3,country=$.url().param("country")||localStorage.getItem("country")||"";$.getJSON("http://data.judobase.org/api/get_json?params[action]=country.get_list",function(data){var html="";$.each(data,function(key,value){return value.ioc.search("OJU|PJC|EJU|AJU|JUA|IJF")?void(html+='<li><a href="http://lancew.github.io/WRL_hacks/?country='+value.ioc+'&limit=9999">'+value.name+"</a></li>"):!0}),$("#nations").html(html)}),$.getJSON("http://data.judobase.org/api/get_json?params[action]=wrl.by_category&params[category_limit]="+limit,function(data){var total_athletes=0,top_mover={change:"",athlete:""},top_male={points:0,athlete:""},top_female={points:0,athlete:""},bottom_mover={change:"",athlete:""};$.url().param("country")&&(localStorage.setItem("country",""+$.url().param("country")),console.log("---"+$.url().param("country"))),$.url().param("limit")&&localStorage.setItem("limit",$.url().param("limit")),$.each(data.categories,function(index,value){$("#text").append("<h2>"+value.name+"</h2>"),$.each(value.competitors,function(index2,athlete){if(athlete.country_short==country||""==country){var delta_text,delta=Math.abs(athlete.place-athlete.place_prev);athlete.place<athlete.place_prev?(delta_text="&#8593;"+delta+" position(s)",bottom_mover.change<delta&&(bottom_mover.change=delta,bottom_mover.delta_text=delta_text,bottom_mover.athlete=athlete)):athlete.place>athlete.place_prev?(delta_text="&#8595;"+delta+" position(s)",top_mover.change<delta&&(top_mover.change=delta,top_mover.delta_text=delta_text,top_mover.athlete=athlete)):(delta="",delta_text="&#8594; No change in position."),"f"===athlete.gender&&Number(athlete.points)>Number(top_female.points)&&(top_female=athlete),"m"===athlete.gender&&Number(athlete.points)>Number(top_male.points)&&(top_male=athlete),$("#text").append(athlete.place+") "+athlete.family_name+", "+athlete.given_name+" ("+athlete.country_short+") "+delta_text+" ("+athlete.points+" points) <br />"),total_athletes++}}),$("#loading").html("")}),top_mover.athlete&&$("#no1_faller").html(top_mover.delta_text+"  positions: <br />"+top_mover.athlete.family_name+" "+top_mover.athlete.given_name+" "+top_mover.athlete.weight_name),bottom_mover.athlete&&$("#no1_climber").html(bottom_mover.delta_text+"  positions  <br />"+bottom_mover.athlete.family_name+" "+bottom_mover.athlete.given_name+" "+bottom_mover.athlete.weight_name),top_male.points&&$("#top_male").html(top_male.family_name+" "+top_male.given_name+" "+top_male.points+" points"),top_female.points&&$("#top_female").html(top_female.family_name+" "+top_female.given_name+" "+top_female.points+" points"),$("#total_athletes").html(total_athletes),country&&$("#country").html(country)});