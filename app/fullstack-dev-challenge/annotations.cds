using DevChallengeService as service from '../../srv/cat-service';


annotate service.Tests with @(
    UI.LineItem         : [
        {
            $Type: 'UI.DataField',
            Value: title,
            Label: 'title',
        },
        {
            $Type: 'UI.DataField',
            Value: description,
            Label: 'description',
        },
        {
            $Type: 'UI.DataField',
            Value: price,
            Label: 'price',
        },
        {
            $Type: 'UI.DataField',
            Value: createdBy,
        },
        {
            $Type: 'UI.DataField',
            Value: createdAt,
            Label: 'Created At',
        },
        {
            $Type            : 'UI.DataFieldForAnnotation',
            Label            : 'rating',
            Target           : '@UI.DataPoint#rating',
            ![@UI.Importance]: #High,
        },
        {
            $Type: 'UI.DataField',
            Value: supplier.fullName,
            Label: 'Business Partner',
        },
    ],

    UI.Identification   : [
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'DevChallengeService.assignQuestionsToTest',
            Label : 'AssignQuestionsToTest',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'DevChallengeService.createQuestions',
            Label : 'createQuestions',
        },
    ],
    UI.DataPoint #rating: {
        Value        : rating,
        TargetValue  : 5,
        Visualization: #Rating,
    },
);

annotate service.Tests with @(
    UI.FieldGroup #TestDetails: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Title',
                Value: title,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Description',
                Value: description,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Created By',
                Value: createdBy,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Created At',
                Value: createdAt,
            },
            {
                $Type: 'UI.DataField',
                Value: price,
                Label: 'Price',
            },
            {
                $Type: 'UI.DataField',
                Value: rating,
                Label: 'rating',
            },
            {
                Label: 'Business Partner',
                Value: supplier_ID
            },
            {Value: supplier.isBlocked},
        ],
    },

    UI.Facets                 : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'TestDetailsFacet',
            Label : 'Test Details',
            Target: '@UI.FieldGroup#TestDetails',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Questions',
            ID    : 'Questions',
            Target: 'questions/@UI.LineItem#Questions',
        },
    ]
);

annotate service.Questions with @(
    UI.Facets             : [{
        $Type : 'UI.ReferenceFacet',
        Target: 'questions/@UI.LineItem#Questions',
        Label : 'Questions',
        ID    : 'questions',
    }, ],
    UI.LineItem #Questions: [
        {
            $Type: 'UI.DataField',
            Value: text,
            Label: 'Questions text',
        },
        {
            $Type: 'UI.DataField',
            Value: answer.text,
            Label: 'Answer text',
        },
    ],

);

annotate service.Tests with {
    price @Measures.ISOCurrency: currency_code
};

annotate service.Tests with {
    supplier @(
        Common.Text     : {
            $value                : supplier.fullName,
            ![@UI.TextArrangement]: #TextFirst
        },
        Common.ValueList: {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Suppliers',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: supplier_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'fullName',
                },
            ],
            Label         : 'Suppliers',
        },
    )
};

annotate service.Suppliers with {
    ID       @(
        title      : 'ID',
        Common.Text: fullName
    );

    fullName @title: 'Name';

};

annotate service.Suppliers with {
    isBlocked @title: 'Supplier Blocked';
};

annotate service.Suppliers with @Capabilities.SearchRestrictions.Searchable: false;
