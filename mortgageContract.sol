pragma solidity ^0.4.15

contract MortgageContract {

    uint mortgage_id;

    uint price;

    int srok_ipoteki;

    int monthly_payment;
    enum state {under_construction, rented_out, paid}

    address public borrower;

    address public lender;

    struct Mortgage {
    uint balance_borrower;
    bool status_borrower;
    uint fine;
    }

    Mortgage mortgage;

    function getStatusOfMortage() returns (bool status) {

        bool returnStatus = false;

        for (uint i = 0; i < srok_ipoteki; i++) {
            zakladnaya.balance_borrower = price - i * monthly_payment;
            if (zakladnaya.status_borrower == true) {
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
