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

    // setTimeout(function () {
    //     $("#exec-step-2").show();
    // }, 4000);

    // setTimeout(function () {
    //     $("#exec-step-3").show();
    // }, 6000);

    // setTimeout(function () {
    //     $("#exec-step-4").show();
    // }, 7000);

    // setTimeout(function () {
    //     $("#exec-progress").hide();
    //     $("#exec-submit").show();
    // }, 9000);

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
    }, 8000);

    setTimeout(function () {
        $("#fin-step-2").show();
    }, 12000);

    setTimeout(function () {
        $("#fin-step-3").show();
        $("#fin-progress").hide();
        $("#fin-submit").show();
    }, 18000);

    $("form#finalization").submit(function (event) {
        event.preventDefault();

        $("#spinner").show();

        setTimeout(function () {
            $("#spinner").hide();

            window.location = window.location = "/end/" + localStorage.getItem('address');
        }, 2000 + Math.random(1000));
    });
});

var stepsDone = 0;

function onExecuteStep(el) {
    var spinner = $(el).find('.fa');
    var actionTodo = $(el).parent();
    var actionDone = $(el).parent().next();
    var checkbox = $(el).parent().parent().find('.fa-square-o');
    var submit = $(el).parent().parent().parent().find('button[type=submit]')

    spinner.show();

    setTimeout(function () {
        spinner.hide();
        actionTodo.hide();
        actionDone.show();
        checkbox.removeClass('fa-square-o').addClass('fa-check-square-o');

        if (++stepsDone >= 3)
            submit.prop("disabled", false);
    }, 2000 + Math.random(1000));
}

function setMetamaskAddress(el) {
    var input = $(el).parent().prev();
    var address = web3.eth.getAccounts(function (err, accounts) { input.val(accounts[0]); });
}