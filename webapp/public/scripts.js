$("document").ready(function () {
    $("form#deploy").submit(function (event) {
        event.preventDefault();

        var unindexed_array = $(this).serializeArray();
        var indexed_array = {};

        $.map(unindexed_array, function(n, i){
            indexed_array[n['name']] = n['value'];
        });

        $("#spinner").show();

        $.ajax({ url: '/api/v1/contracts/deploy', type: 'POST', contentType: 'application/json', data: JSON.stringify(indexed_array), success: function (data) {
            $("#spinner").hide();

            localStorage.setItem('address', data.address);

            window.location = "/execution/" + data.address;
        }});
    });

    setTimeout(function () {
        $("#exec-step-2").show();
    }, 4000);

    setTimeout(function () {
        $("#exec-step-3").show();
    }, 6000);

    setTimeout(function () {
        $("#exec-step-4").show();
    }, 7000);

    setTimeout(function () {
        $("#exec-progress").hide();
        $("#exec-submit").show();
    }, 9000);

    $("form#execution").submit(function (event) {
        event.preventDefault();

        $("#spinner").show();

        setTimeout(function () {
            $("#spinner").hide();

            console.log(window.location);
            window.location = "/finalization/" + localStorage.getItem('address');
            console.log(window.location);
        }, 2200);
    });

    setTimeout(function () {
        $("#fin-step-1").show();
    }, 4000);

    setTimeout(function () {
        $("#fin-step-2").show();
    }, 6000);

    setTimeout(function () {
        $("#fin-step-3").show();
    }, 7000);

    setTimeout(function () {
        $("#fin-progress").hide();
        $("#fin-submit").show();
    }, 9000);

    $("form#finalization").submit(function (event) {
        event.preventDefault();

        $("#spinner").show();

        setTimeout(function () {
            $("#spinner").hide();

            window.location = window.location = "/end/" + localStorage.getItem('address');
        }, 1400);
    });
});

function addCoborrower() {
    var el = $('<div class="form-group"><label for="coborrower" class="col-sm-2 control-label">Созаёмщик</label><div class="col-sm-10"><div class="input-group"><input type="text" class="form-control" id="coborrower" placeholder="Адрес созаёмщика" name="coborrower" value=""><span class="input-group-btn"><button type="button" class="btn btn-default" onclick="setMetamaskAddress(this)" title="Получить из Metamask">@</button></span></div></div>');
    var target = $('#extra');
    target.replaceWith(el);
}

function setMetamaskAddress(el) {
    var input = $(el).parent().prev();
    var address = web3.eth.getAccounts(function (err, accounts) { input.val(accounts[0]); });
}