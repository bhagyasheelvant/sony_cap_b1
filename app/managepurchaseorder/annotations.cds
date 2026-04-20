using CatalogService as service from '../../srv/CatalogService';


//Anotate our entity on which we created fiori app 
annotate service.PurchaseOrderSet with @(
    //selection fields to show filter fields
    UI.SelectionFields:[
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        OVERALL_STATUS

    ],
    //line item to add columns to the table
    //CTRL+space
    UI.LineItem:[
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,

        }, 
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },  
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.boost',
            Label: 'boost',
            Inline: true
            //show it in every single line
        },
        {
            $Type : 'UI.DataField',
            Value : OverallStatus,
            Criticality: IconColor
           
        },
    ],
    //HEADER INFRO TO ADD THE TITLE OF THE TABLE ALONG WITH THE 
    //SECOND PAGE TO THE TOP AREA
    UI.HeaderInfo: {
        TypeName: 'Purchase order',
        TypeNamePlural: 'Purchase Orders',
        Title: { Value: PO_ID},
        Description: { Value: PARTNER_GUID.COMPANY_NAME},
        ImageUrl : 'https://tse1.mm.bing.net/th/id/OIP.PIvNYb6DSO1bZt861TQgKwAAAA?w=250&h=250&rs=1&pid=ImgDetMain&o=7&rm=3',
    },
    //add a tabstrip which has multiple tabs - FAcets
    UI.Facets: [
        {
            $Type : 'UI.CollectionFacet',
            Label: 'PO details',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label: 'More Info',
                    Target : '@UI.Identification',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#Spiderman',
                    Label: 'Pricing Data',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label: 'Status Data',
                    Target : '@UI.FieldGroup#Superman',
                },
                
            ],
        },
        //this reference facet doesn't come form the current entity it comes from the secondary entity 
        {
            $Type : 'UI.ReferenceFacet',
            Label: 'PO Items',
            Target : 'Items/@UI.LineItem',
        },
    ],
    //first block inside the collection facet - identification ( default )
    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID_NODE_KEY,
        },
    ],
    //other fields grouped in a field group for creating multiple blocks
    UI.FieldGroup #Spiderman: {
        Data: [
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },
        ]
    },
    UI.FieldGroup #Superman: {
        Data: [
            {
                $Type : 'UI.DataField',
                Value : OVERALL_STATUS,
            },
            {
                $Type : 'UI.DataField',
                Value : LIFECYCLE_STATUS,
            },
            {
                $Type : 'UI.DataField',
                Value : CURRENCY_code,
            },
        ]
    }
        
    

    
);


//annotate the purchase order item to create table for item and 3rd level drill down
annotate service.POItems with @(
    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
    ],
    UI.HeaderInfo: {
        TypeName : 'PO Item',
        TypeNamePlural : 'PO Items',
        Title: { Value: PO_ITEM_POS},
        Description: {Value: PRODUCT_GUID.DESCRIPTION}
    },
    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            Label: 'Item details',
            Target : '@UI.Identification',
        },

    ],
    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : NODE_KEY,
            Label: 'Item Key'
        },
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
            Label: ''
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
        {
            $Type : 'UI.DataField',
            Value : NOTE,
        },
    ]
) ;


//THIS ANNOTATION IS FOR SETTING DEAFULT VALUE FOR A FIELD
annotate service.PurchaseOrderSet with {
    @Common : { FilterDefaultValue: 'P' }
    OVERALL_STATUS;
    @Common : { Text: PARTNER_GUID.COMPANY_NAME,
                 valueList.entity: service.BusinessPartnerSet }
    PARTNER_GUID;
    @Common : { Text: NOTE }
    NODE_KEY; 
    @Common: { Text: OverallStatus }
    OVERALL_STATUS;
}

//SETTING DEFAULT VALUE FOR A FIELD ON LIST REPORT
annotate service.POItems with {
    @Common : {
        Text : PRODUCT_GUID.DESCRIPTION,
        // valueList.entity: service.ProductSet
         valueList.entity: service.BusinessPartnerSet
    }
    PRODUCT_GUID;
} ;


//annotate master data entities to support value help
@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(
    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : COMPANY_NAME,
        },
    ]
) ;

@cds.odata.valuelist
annotate service.ProductSet with @(
    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : DESCRIPTION,
        },
    ]
) ;





