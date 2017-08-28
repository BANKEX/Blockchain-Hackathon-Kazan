$("document").ready(function () {
});

function addCoborrower() {
	var el = $('<div class="form-group"><label for="coborrower" class="col-sm-2 control-label">Созаёмщик</label><div class="col-sm-10"><div class="input-group"><input type="text" class="form-control" id="coborrower" placeholder="Адрес созаёмщика" value=""><span class="input-group-btn"><button type="button" class="btn btn-default" onclick="setMetamaskAddress(this)" title="Получить из Metamask">@</button></span></div></div>');
	var target = $('#extra');
	target.replaceWith(el);
}

function setMetamaskAddress(el) {
	var input = $(el).parent().prev();
	var address = web3.eth.getAccounts(function (err, accounts) { input.val(accounts[0]); });
}