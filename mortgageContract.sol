pragma solidity ^0.4.4;

contract ipoteka {

   uint ipoteka_id;
    uint price;
    int srok_ipoteki;
    int monthly_payment;
    enum state {under_construction, rented_out, paid}

   address public borrower;
    address public lender;
    uint[] zakladnaya;
    struct zakladnaya {
        uint balance_borrower;
        bool status_borrower;
        uint fine;
    }

   function check {
        for (uint i = 0; i < srok_ipoteki; i++){
          zakladnaya[0] == price - i*monthly_payment;
          zakladnaya[1] == true;

       }
    }


   address public construction;

   event ipoteka_paid()


 function ipoteka() {
    // constructor
  }
}
