namespace test.system;

using {managed,Currency} from '@sap/cds/common';
using from '@sap/cds-common-content';
using {  API_BUSINESS_PARTNER as bupa } from '../srv/external/API_BUSINESS_PARTNER';

entity Tests : managed
{
    key testId:UUID;
    title : String;
    description : String;
    questions : Association to many Questions on questions.test = $self;
    price: Double;
    currency : Currency;
    rating: Integer;
    supplier:Association to Suppliers;
}
 
entity Questions
{
   key questionId:String;
   test:Association to one Tests;
   text:String;
   answer:Composition of one Answers;
    rating   : Integer;
}
 
 
aspect Answers{
   key answerId:String;
    text:String;
    questions:Composition of one Questions;
}

 entity Suppliers as projection on bupa.A_BusinessPartner {
        key BusinessPartner as ID,
        BusinessPartnerFullName as fullName,
        BusinessPartnerIsBlocked as isBlocked,
}