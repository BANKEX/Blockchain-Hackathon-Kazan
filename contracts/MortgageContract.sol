pragma solidity ^0.4.4;


import "./MultiSigWallet.sol";

contract MortgageContract is MultiSigWallet {

    uint mortgage_id;

    uint price;

    uint time;

    uint monthly_payment;

    uint signTimestamp;

    enum state {under_construction, rented_out, paid}

    address public borrower;

    address public lender;

    struct Verify {
        bool borrower_signature;
        bool lender_signature;
    }

    function signDeal(address _borrower, address _lender) {
//        require(Verify.borrower_signature && Verify.lender_signature);

    }

    function getMonthlyPayment () payable returns (bool) {
        /*lender.send(this.monthly_payment);*/
        return true;
    }

    struct Mortgage {
    uint balance_borrower;
    bool status_borrower;
    uint fine;
    }

    Mortgage mortgage;

    function setBalanceBorrower (uint balance){
        mortgage.balance_borrower = balance;
    }


    function checkClosed() returns (bool status) {

        bool returnStatus = false;

        for (uint i = 0; i < time; i++) {
            mortgage.balance_borrower = price - i * monthly_payment;
            if (mortgage.balance_borrower > 0) {
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
