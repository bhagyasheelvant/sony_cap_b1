//this is to load the reference of our data model and it is like import
using anubhav.db from '../db/datamodel';

service CatalogService @(path: 'CatalogService') {
        //Nobody should be able to edi this, hence using the annotation readonly
        // @readonly
        //All the CRUDQ create, read, update, delete and query operations on ODATA
        //When you have to create a service end point in my odata called as EmployeeSrv which will be created on the basis of the database table called employees.
        entity EmployeeSrv as projection on db.master.employees;

        //Other Entities
        entity BusinessPartnerSet as projection on db.master.businesspartner;
        entity BPAddressSet as projection on db.master.address;
        entity ProductSet as projection on db.master.product;
        entity PurchaseOrderSet @(odata.draft.enabled: true) as projection on db.transaction.purchaseorder{
         *,
        case OVERALL_STATUS
            when 'P' then 'Pending'
            when 'A' then 'Approved'
            when 'X' then 'Rejected'
            when 'N' then 'New'
             end as OverallStatus: String(32),
             case OVERALL_STATUS
            when 'P' then 2
            when 'A' then 3
            when 'X' then 1
            when 'N' then 2
             end as IconColor: Integer
             //These are the standard colour coding given by SAP
        }

        
        // Define action which is instance bound
        //In the action boost(), computer will automatically pass the primary key of the record
        actions{
                //definition of our action will get called by passing the NODE_KEY
                action boost() returns PurchaseOrderSet;
        };
        entity POItems as projection on db.transaction.poitems;

        


        // function getLargestOrder() returns array of PurchaseOrderSet;
         function getLargestOrder() returns PurchaseOrderSet;
}
