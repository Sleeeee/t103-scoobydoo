"use strict";

function setH(id, content){
    document.getElementById(id).innerHTML = content;
}

function getH(id){
    return document.getElementById(id).innerHTML;
}

function addH(id, content){
	document.getElementById(id).innerHTML += content;
}

function setT(id, content){
    document.getElementById(id).innerText = content;
}

function getElem(id){
    return document.getElementById(id)
}

function qs(selector){
    return document.querySelector(selector);
}

function qsa(selector){
    return document.querySelectorAll(selector);
}