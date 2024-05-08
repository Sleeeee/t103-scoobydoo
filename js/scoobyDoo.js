/*********************************** scoobyDoo.js ********
* Nom prénom 1 : STAS Justin
* Groupe       : 1TM1
*
*********************************************************/
"use strict";
document.addEventListener('DOMContentLoaded',init);

function init(){
	qs('h1').innerHTML='ScoobyDoo';
	qsa("nav > button").forEach(b=>b.onclick = function(){displayTab(this)});
	qsa(".popup").forEach(p=>dragElement(p)); // Permet de déplacer les popups
	request("/epfilter?t=format", callbackFormats); // Récupère les différents formats pour le filtre
	request("/epfilter?t=series", callbackSeries); // Récupère les séries pour les onglets TP10 et TP12
	request("/monsterelems", callbackMonsterElems); // Rend disponible les genres, types, sous-types, espèces de monstres pour les select
	request("/monsterstoadd", callbackCountMonsters); // Appelle le service sans paramètre pour récupérer tous les monstres, à afficher dans l'onglet TP12
	qsa("#divCountSeries select, #divCountEpisodes > div > select, #divCountMonsters select, #divCountMonsterTypes select, #divCountMonsterSubtypes select, #divCountMonsterSpecies select").forEach(s=>s.onchange = function(){displayDivUpdateValue(this)});
}

function displayTab(button){ // Met en place le système d'onglets
	qsa("section").forEach(s=>s.classList.remove("enabled"));
	getElem(button.id.substr(1, button.id.length-1)).classList.add("enabled");
}

function request(url, callback){ // Template de requête AJAX vers la database
	let xhr = new XMLHttpRequest();
	xhr.open("GET", url, true);
	xhr.onload = function(){callback(xhr);};
	xhr.send();
}

function callbackFormats(xhr){ // Initialise les boutons radio du filtre des séries
	let res = JSON.parse(xhr.response), h = "<input id='radiof00' type='radio' name='format' value='f00' onchange='getSeriesByFormat(this.value);' checked><label for='radiof00'>Tous</label> "; // A l'initialisation, toutes les séries sont affichées
	for (let o of res) h += `<input id="radio${o.id}" type="radio" name="format" value="${o.id}"  onchange="getSeriesByFormat(this.value);"><label for="radio${o.id}">${o.name}</label> `; // Envoie une requête à chaque changement de bouton
	setH("divFormats", h);
}

function getSeriesByFormat(format){ // Récupère les séries correspondant à un format
	getElem("tbEpisodesSeries").style.display = "none"; // Réinitialisation de la table des épisodes si elle était affichée
	request(`/series?f=${format}`, callbacSeriesByFormat);
}

function callbacSeriesByFormat(xhr){ // Génération du select des séries
	let res = JSON.parse(xhr.response), h = "<option disabled selected>Sélectionnez une série</option>", s = getElem("selectSeries");
	for (let o of res) h += `<option value="${o.id}">${o.name}</option>`;
	s.innerHTML = h;
	s.size = res.length + 1;
	s.onchange = function(){request(`/epbyfilter?i=${this.value}`, callbackEpisodesSeries);}; // Récupère les épisodes correspondant à la série sélectionnée
}

function callbackSeries(xhr){ // Remplit le select de la page d'accueil et de la feuille statistique
	let res = JSON.parse(xhr.response), h = "<option disabled selected>Sélectionnez une série</option>", l = res.length, s = getElem("selectSeries");
	for (let o of res) h += `<option value="${o.id}">${o.name}</option>`;
	s.innerHTML = h;
	s.size = l + 1;
	s.onchange = function(){request(`/epbyfilter?i=${this.value}`, callbackEpisodesSeries);}; // Au clic, récupère tous les épisodes de la série concernée
	setT("spanCountSeries", l); // Affiche le compteur du nombre de séries
	qs("#divCountSeries select").innerHTML = h;
}

function callbackMonsterElems(xhr){ // Remplit les select d'attributs de monstres pour les différents onglets
	let res = JSON.parse(xhr.response)[0], elemArray = ["Gender", "Type", "Subtype", "Species"];
	for (let e of elemArray){
		let h = res[e.toLowerCase()];
		// TP10
		let s = `selectUpdateMonster${e}`;
		setH(s, h);
		qsa(`#${s} > option`).forEach(o=>o.onclick = function(){setSelected(this, s)}); // Fix du fonctionnement des select popup
		// TP11
		setH(`selectMonster${e}`, h);
		// TP12
		if (e == "Gender") continue; // Le genre suit un traitement différent
		let nameFix = (e == "Species") ? e : e + "s"; // Species est déjà terminé par un 's'
		setT(`spanCountMonster${nameFix}`, countOccurences(h, "</option>")); // Le service web renvoie du HTML et pas du JSON, on compte le nombre d'options retournées
		setH(`selectCountMonster${nameFix}`, h);
	}
}

function countOccurences(str, substr){
	let regex = new RegExp(substr, 'g');
	return str.match(regex).length;
}

function callbackEpisodesSeries(xhr){ // Construit le tbody de la table des épisodes ainsi que le select de la page de statistiques
	let res = JSON.parse(xhr.response), h = "", h2 = "";
	for (let o of res){
		h += `<tr id="${o.id}" onclick="request('/episode?e=${o.id}', callbackEpisode)"><td>${o.date}</td><td>${o.title}</td></tr>`; // Au clic, affiche dans un popup des informations supplémentaires sur l'épisode
		h2 += `<option value="${o.id}">${o.title}</option>`;
	}
	if (qs("section.enabled").id == "TP10"){ // Si la requête provient de l'onglet TP10
		setH("tbodyEpisodesSeries", h);
		getElem("tbEpisodesSeries").style.display = "block"; // Rend la table visible
	}else{ // Sinon, elle vient du TP12
		let l = res.length,  s = qs("#divCountEpisodesSeries > div > select");
		setT("spanCountEpisodesSeries", l);
		qs("#divCountEpisodesSeries > span").style.display = "inline-block"; // Rend visible le compteur et le bouton d'affichage
		s.size = (l < 10) ? l : 10; // Réduit l'affichage de la liste si nécessaire
		s.innerHTML = h2;
	}
}

function callbackEpisode(xhr){ // Affichage du popup comptant les personnages principaux et les monstres de l'épisode
	let o = JSON.parse(xhr.response)[0], d = getElem("divInfosEpisode");
	let h = `<span onclick="closePopup('divInfosEpisode')">x</span><h3>${o.id} - ${o.title}</h3><div class="container"><span>Casting : ${o.characters} <button onclick="request('/characters?e=${o.id}', callbackPersonnagesEpisode);">Afficher</button></span><br><span>Monstres : <span id="spanEpisodeMonsterCount">${o.monsters}</span> <button onclick="request('/monsters?e=${o.id}', callbackMonstresEpisode);">Afficher</button></span></div>`; // Construit les requêtes permettant d'accéder aux doubleurs ou aux monstres de l'épisode sélectionné
	d.innerHTML = h;
	d.style.display = "block"; // Rend le popup visible
}

function callbackPersonnagesEpisode(xhr){ // Affiche les doubleurs de l'épisode
	let o = JSON.parse(xhr.response)[0];
	let h = `<span onclick="closePopup('divPersMonstres')">x</span><h3>${o.id} - Casting</h3><div class="container">${o.characters}</div>`;
	setDivPersMonstres(h);
}

function callbackMonstresEpisode(xhr){ // Affiche les monstres de l'épisode
	let s = getElem("spanAddEpisodeMonster"), sText = "";
	if (s) sText = s.innerText; // Si la requête est un appel suite à une addition/suppression, récupère le texte pour le rafraichir à la reconstruction du div
	
	let o = JSON.parse(xhr.response)[0];
	let h = `<span onclick="closePopup('divPersMonstres')">x</span><h3>${o.id} - Monstres</h3><div class="container">${o.monsters}<hr><select id="selectAddMonsterEpisode" size=5></select><br><button id="btnAddEpisodeMonster" onclick="addEpisodeMonster('${o.id}');">Ajouter</button></div><span id="spanAddEpisodeMonster">`;
	h += sText + "</span>";
	setDivPersMonstres(h);
	request(`/monsterstoadd?e=${o.id}`, callbackMonstersToAdd); // Récupère les monstres qui peuvent être ajoutés à l'épisode (donc tous sauf ceux présents)
}

function addEpisodeMonster(e){ // Affecte un nouveau monstre à un épisode
	let m = qs('#selectAddMonsterEpisode .selected');
	if (m){
		request(`/addepmon?e=${e}&m=${m.value}`, callbackAddEpisodeMonster) // Essaye de créer une entrée dans la table, puis récupère un message de confirmation
	}else{ // Si aucune option n'a été cliquée
		setT("spanAddEpisodeMonster" , "Veuillez sélectionner un monstre");
	}
}

function setDivPersMonstres(h){ // Fonction générale d'affichage du popup partagé par les personnages et les monstres
	let d = getElem("divPersMonstres");
	d.innerHTML = h;
	d.style.display = "block";
}

function addMonsterElem(type, elem){ // Ajouter un attribut de monstre
	request(`/newelem?t=${type}&e=${elem}`, callbackAddMonsterElem); // Essaye de créer l'élément avec les valeurs entrées dans le formulaire
	request("/monsterelems", callbackMonsterElems); // Rafraichit les select répertoriant les attributs de monstres
	return false;
}

function callbackAddMonsterElem(xhr){ // Après l'insertion, récupère soit un message de confirmation ou d'erreur
	setSpan(xhr, "spanAddMonsterElem");
}

function setSpan(xhr, spanId){ // Raccourcit le format encombrant des messages d'erreur de SQLAny
	qsa("form span").forEach(s=>s.innerText="");
	let res = xhr.response.split("SQL error: ");
	setT(spanId, res[res.length - 1]);
}

function addMonster(name, gender, type, subtype, species){ // Créée un nouveau monstre
	request(`/newmon?n=${name}&g=${gender}&t=${type}&st=${subtype}&sp=${species}`, callbackAddMonster); // Essaye de créer le monstre avec les valeurs entrées dans le formulaire
	return false;
}

function callbackAddMonster(xhr){ // Après la création, récupère soit un message de confirmation ou d'erreur
	setSpan(xhr, "spanAddMonster");
}

function callbackMonstersToAdd(xhr){ // Affichage des monstres dans le select du popup d'ajout de monstres à un épisode 
	let res = JSON.parse(xhr.response), h = "";
	for (let o of res) h += `<option onclick="setSelected(this, 'selectAddMonsterEpisode');" value="${o.id}">${o.monster}</option>`; // Fix du fonctionnement des select du popup
	setH("selectAddMonsterEpisode", h);
}

function setSelected(option, selId){ // Met à jour l'option sélectionnée dans un popup
	qsa(`#${selId} > option`).forEach(o=>o.classList.remove("selected"));
	option.classList.add("selected");
}

function callbackAddEpisodeMonster(xhr){ // Affiche le message de confirmation (les appels créés par le select ne génèrent pas d'erreur)
	setT("spanAddEpisodeMonster", xhr.response);
	let e = qs("#divPersMonstres > h3").innerText.substr(0, 4); // Récupère l'id de l'épisode stocké dans le titre
	request(`/monsters?e=${e}`, callbackMonstresEpisode); // Recalcule la liste de monstres appartenant à l'épisode
	let s = getElem("spanEpisodeMonsterCount");
	s.innerText = parseInt(s.innerText) + 1; // Incrémente le compteur de monstres
}

function callbackRemoveMonsterEpisode(xhr){ // Affiche le message de confirmation (pas de message d'erreur)
	setT("spanAddEpisodeMonster", xhr.response);
	let e = qs("#divPersMonstres > h3").innerText.substr(0, 4); // Récupère l'id de l'épisode stocké dans le titre
	request(`/monsters?e=${e}`, callbackMonstresEpisode); // Recalcule la liste de monstres appartenant à l'épisode
	let s = getElem("spanEpisodeMonsterCount");
	s.innerText = parseInt(s.innerText) - 1; // Décrémente le compteur de monstres
}

function callbackInfosMonster(xhr){ // Affiche le popup de modification du monstre
	let o = JSON.parse(xhr.response)[0]; // Traitement d'un seul objet (id unique)
	qs("#divModMonstre > h3").innerText = `${o.id} - ${o.name}`;
	qs("#divModMonstre tbody > tr").innerHTML = `<td>${o.gender}</td><td>${o.type}</td><td>${o.subtype}</td><td>${o.species}</td>`; // Créée la ligne de tableau correspondante
	getElem("divModMonstre").style.display = "block"; // Affiche le popup
}

function updateMonster(form){ // Modifie les attributs d'un monstre existant
	let m = qs("#divModMonstre > h3").innerText.substr(0, 4); // Récupère l'id du monstre stocké dans le titre
	let g = qs(`#${form.gender.id} > .selected`), t = qs(`#${form.type.id} > .selected`), st = qs(`#${form.subtype.id} > .selected`), sp = qs(`#${form.species.id} > .selected`);
	if (!(g && t && st && sp)){ // Vérifie qu'aucun champ n'a été laissé vide
		setT("spanUpdateMonster", "Veuillez sélectionner tous les champs");
	}else{
		request(`/upmon?m=${m}&g=${g.value}&t=${t.value}&st=${st.value}&sp=${sp.value}`, callbackUpdateMonster); // Met à jour les valeurs des attributs du monstre
	}
	return false;
}

function callbackUpdateMonster(xhr){ // Affiche le message de confirmation (pas de message d'erreur)
	setT("spanUpdateMonster", xhr.response);
	request(`/infosmon?m=${qs("#divModMonstre > h3").innerText.substr(0, 4)}`, callbackInfosMonster); // Recalcule les informations affichées sur la page
}

function displayList(divId){ // Fonction générale d'affichage des listes de la feuille statistique
	qs(`#${divId} > div`).style.display = 'block';
	let b = qs(`#${divId} > span > button`);
	b.onclick = function(){hideList(divId)};
	b.innerText = "Cacher la liste";
}

function hideList(divId){ // Désactivation des listes de la feuille statistique
	qs(`#${divId} > div`).style.display = 'none';
	let b = qs(`#${divId} > span > button`);
	b.onclick = function(){displayList(divId)};
	b.innerText = "Afficher la liste";
}

function displaySelectCountEpisodes(value){ // A la sélection d'un bouton radio, récupère les valeurs correspondant au bouton pour servir de filtre aux épisodes
	request(`/epfilter?t=${value}`, callbackEpisodeFilters);
}

function callbackEpisodeFilters(xhr){ // Génère le select des valeurs filtrantes des épisodes
	let res = JSON.parse(xhr.response), h = "<option disabled selected>Sélectionnez une option</option>";
	for (let o of res) h += `<option value=${o.id}>${o.name}</option>`;
	hideList("divCountEpisodes"); // Cache la liste si elle était déjà affichée
	qs("#divCountEpisodes > span").style.display = "none";
	qs("#divCountEpisodes > select").innerHTML = h;
	qs("#divCountEpisodes > select").style.display = "block";
}

function countEpisodes(id){ // A la sélection d'une valeur filtrante, compte le nombre d'épisodes correspondant
	qs("#divCountEpisodes > span").style.display = "inline-block";
	request(`/epbyfilter?i=${id}`, callbackCountEpisodes); // Récupère les épisodes en fonction de l'id de la valeur filtrante
}

function callbackCountEpisodes(xhr){ // Génère le select des épisodes (qui sera affiché au clic du bouton d'affichage de liste) et affiche le compte
	let res = JSON.parse(xhr.response), h = "<option disabled selected>Sélectionnez une option</option>", l = res.length, s = getElem("selectCountEpisodes");
	for (let o of res) h += `<option value=${o.id}>${o.title}</option>`;
	setT("spanCountEpisodes", l);
	s.size = (l < 10) ? l+1 : 10;
	s.innerHTML = h;
	s.onchange = function(){displayDivUpdateValue(this)}; // A la sélection d'un épisode, affiche les options de modification / suppression
}

function callbackCountMonsters(xhr){ // Génère le select des monstres et en compte le nombre
	let res = JSON.parse(xhr.response), h = "", l = res.length, s = getElem("selectCountMonsters");
	for (let o of res) h += `<option value="${o.id}">${o.monster}</option>`;
	setT("spanCountMonsters", l);
	qs("#divCountMonsters > div > select").innerHTML = h;
}

function countMonstersByGender(g){ // Au changement de valeur du select, compte le nombre de monstres correspondant au genre correspondant
	qs("#divCountMonstersByGender > span").style.display = "block";
	request(`/monbygen?g=${g}`, callbackCountMonstersByGender); // Récupère les monstres
}

function callbackCountMonstersByGender(xhr){ // Génère le select des monstres filtrés selon le genre et en compte le nombre
	let res =  JSON.parse(xhr.response), h = "<option disabled selected>Sélectionnez une option</option>", l = res.length, s = getElem("selectCountMonstersByGender");
	for (let o of res) h += `<option value=${o.id}>${o.name}</option>`;
	setT("spanCountMonstersByGender", l);
	s.size = (l < 10) ? l+1 : 10;
	s.innerHTML = h;
	s.onchange = function(){displayDivUpdateValue(this)}; // A la sélection d'un monstre, affiche les options de modification / suppression
}

function displayDivUpdateValue(select){ // Génère le div de modification / suppression d'éléments
	let d = getElem("divUpdateValue");
	qs("#divUpdateValue > h3").innerHTML = `<span>${select.value}</span> - ${select[select.selectedIndex].innerText}`; // Récupère la valeur sélectionnée et le libellé associé
	d.style.display = "block";
}

function updateValue(value){ // Modification du libellé d'un élement
	setT("spanUpdateValue", ""); // Réinitialisation du span de confirmation / d'erreur
	if (value === "") {
		setT("spanUpdateValue", "Veuillez entrer une valeur");
		return false; // Pas d'envoi de requête si le champ est vide
	}
	let id = qs("#divUpdateValue > h3 > span").innerText;
	request(`/upelem?i=${id}&v=${value}`, callbackUpdateValue);
	return false;
}

function callbackUpdateValue(xhr){ // Affichage du message de confirmation ou d'erreur récupéré par la requête
	setSpan(xhr, "spanUpdateValue");
}

function deleteValue(){ // Suppression d'un élément
	setT("spanUpdateValue", ""); // Réinitialisation du span de confirmation / d'erreur
	let id = qs("#divUpdateValue > h3 > span").innerText;
	request(`/delelem?i=${id}`, callbackDeleteValue);
}

function callbackDeleteValue(xhr){ // Affichage du message de confirmation ou d'erreur récupéré par la requête
	setSpan(xhr, "spanUpdateValue");
}
