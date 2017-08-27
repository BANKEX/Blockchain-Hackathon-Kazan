pragma solidity ^0.4.4;


contract MortgageContract {

    uint mortgage_id;

    uint price;

    int time;

    int monthly_payment;

    enum state {under_construction, rented_out, paid}

    address public borrower;

    address public lender;

    struct Verify {
        bool borrower_signature;
        bool lender_signature;
    }

    ///API Sign.Me

    function sign_Deal {
        require();
        uint moment_Deal = now;
        require((Verify.borrower_signature && Verify.lender_signature) = True);

    }

    function getMonthlyPayment () payable returns (bool) {
        lender.send(this.monthly_payment);
    }

    struct Mortgage {
    uint balance_borrower;
    bool status_borrower;
    uint fine;
    }

    Mortgage mortgage;

    mortgage.balance_borrower = price;


    function checkClosed returns (bool) {

        bool returnStatus = false;

        for (uint i = 0; i < time; i++) {
            mortgage.balance_borrower = price - i * monthly_payment;
            if (balance_borrower > 0) {
                    mortgage.status_borrower = false;
            } else {
                mortgage.status_borrower = true;
            }
            if (mortgage.status_borrower == true) {
                returnStatus = true;
                break;
            }
        }
        return returnStatus;
    }

    address public construction;

    event ipoteka_paid();

    function ipoteka() {
        // constructor
    }
}