$("document").ready(function () {
    $("form#deploy").submit(function (event) {
        event.preventDefault();

        var unindexed_array = $(this).serializeArray();
        var indexed_array = {};

        $.map(unindexed_array, function(n, i){
            indexed_array[n['name']] = n['value'];
        });

        $.ajax({ url: '/api/v1/contracts/deploy', type: 'POST', contentType: 'application/json', data: JSON.stringify(indexed_array), success: function (data) {
            localStorage.setItem('address', data.address);

            window.location = "/execution/" + data.address;
        }});
    });

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
        $("#fin-step-1").text("Obligations repaid").next().removeClass("grey").addClass("green");
    }, 4000);

    setTimeout(function () {
        $("#fin-step-2").text("Approved").next().removeClass("grey").addClass("green");
    }, 9000);

    setTimeout(function () {
        $("#fin-step-3").text("Withdrawal of encumbrances").next().removeClass("grey").addClass("green");
        $("#btn-submit").prop("disabled", false);
        $("#all-done").removeClass("grey").addClass("green");
    }, 14000);

    $("form#finalization").submit(function (event) {
        event.preventDefault();

        setTimeout(function () {
            window.location = window.location = "/end/" + localStorage.getItem('address');
        }, 2000 + Math.random(1000));
    });
});

var stepsDone = 0;

function onExecuteStep(el) {
    var button = $(el);
    var actionTodo = button.parent();
    var actionDone = actionTodo.next();
    var checkbox = actionDone.next();
    var submit = $("#btn-submit")

    button.prop("disabled", true);
    button.text("Mining...");

    setTimeout(function () {
        actionTodo.hide();
        actionDone.show();
        checkbox.removeClass('grey').addClass('green');

        if (++stepsDone >= 3)
            submit.prop("disabled", false);
    }, 2000 + Math.random(1000));
}

function setMetamaskAddress(el) {
    var input = $(el).next();
    var address = web3.eth.getAccounts(function (err, accounts) { input.val(accounts[0]); });
}