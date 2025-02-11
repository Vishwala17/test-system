using {test.system as db} from '../db/model';

service DevChallengeService {

    @odata.draft.enabled
    entity Tests @(restrict: [
        {
            grant: 'READ',
            to   : 'RiskViewer'
        },
        {
            grant: '*',
            to   : 'RiskManager'
        },
    ]) as projection on db.Tests
        actions {
            @cds.odata.bindingparameter.name: '_it'
            @Common.SideEffects : {
                TargetProperties: ['_it/questions']
                }
            action assignQuestionsToTest(questionsCount : Integer)             returns String;
            action createQuestions( questionText: String, answerText : String) returns String;
        }

    @odata.draft.enabled
    entity Questions @(restrict: [
        {
            grant: 'READ',
            to   : 'RiskViewer'
        },
        {
            grant: '*',
            to   : 'RiskManager'
        },
    ]) as projection on db.Questions;

    entity Suppliers @(restrict: [
        {
            grant: 'READ',
            to   : 'RiskViewer'
        },
        {
            grant: '*',
            to   : 'RiskManager'
        },
    ]) as projection on db.Suppliers;


}
