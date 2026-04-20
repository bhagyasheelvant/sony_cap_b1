const cds = require('@sap/cds')
const { SELECT } = require('@sap/cds/lib/ql/cds-ql')

module.exports = class CatalogService extends cds.ApplicationService { init() {

  const { EmployeeSrv, BusinessPartnerSet, BPAddressSet, ProductSet, PurchaseOrderSet, POItems } = cds.entities('CatalogService')

  this.before (['CREATE', 'UPDATE'], EmployeeSrv, async (req) => {
    console.log('Before CREATE/UPDATE EmployeeSrv', req.data)
    if(parseFloat(req.data.salaryAmount) >= 1000000){
      // Induce an error to tell CAP Framework that we have an issue
      req.error(500, "Salary Cannont Be Above One Million");
      
    }
  })
  this.on ('READ', EmployeeSrv, async (employeeSrv, req) => {
      let results = await SELECT.from(EmployeeSrv).limit(5);
      console.log(results);
      for(var empRec of results){
        empRec.nameMiddle = '** on fly change** ';
        
      }
      return results;
    console.log('After READ EmployeeSrv', employeeSrv)
  })
  this.before (['CREATE', 'UPDATE'], BusinessPartnerSet, async (req) => {
    console.log('Before CREATE/UPDATE BusinessPartnerSet', req.data)
  })
  this.after ('READ', BusinessPartnerSet, async (businessPartnerSet, req) => {
    console.log('After READ BusinessPartnerSet', businessPartnerSet)
  })
  this.before (['CREATE', 'UPDATE'], BPAddressSet, async (req) => {
    console.log('Before CREATE/UPDATE BPAddressSet', req.data)
  })
  this.after ('READ', BPAddressSet, async (bPAddressSet, req) => {
    console.log('After READ BPAddressSet', bPAddressSet)
  })
  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    console.log('After READ ProductSet', productSet)
  })
  this.before (['CREATE', 'UPDATE'], PurchaseOrderSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseOrderSet', req.data)
  })
  this.after ('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {


    // take all the PO id's in a array
    //query all the items count ( group by clause ) where my POIDs = ids we collected
    //Loop at the data which we need to send out
    //Find the count of the corresponding order
    //add virtual field value


    //take all the PO id's in a array
    // console.log(purchaseOrderSet);
    // const ids = purchaseOrderSet.map(purchaseorder => purchaseorder.NODE_KEY);
    // console.log(ids);
    //query all the items count(group by ) where my POIDs = ids we collected
    //PARENT_KEY, count
    //ORD1, 2 ; ORD2, 5 ; ORD3  :   4
    // const itemsCount = await SELECT.from(PurchaseOrderSet)
    //                                .columns('NODE_KEY', {func: 'count'})
    //                                .where({NODE_KEY : {in : ids}})
    //                                .groupBy('PARTNER_GUID');


    //loop at the data which we need to send out
    for(const poRecord of purchaseOrderSet  ){
      //reading the record of items from last computation for each PO
      //const poCount = itemsCount.find(rec => rec.NODE_KEY = poRecord.NODE_KEY)
      // Updating the items data
      //poRecord.NO_OF_ITEMs = poCount.count;
      if(!poRecord.NOTE){ //checks for null, not defined/undefined, blank
        poRecord.NOTE = "(no note found)"
      }
    }
    console.log('After READ PurchaseOrderSet', purchaseOrderSet)

  })
  this.before (['CREATE', 'UPDATE'], POItems, async (req) => {
    console.log('Before CREATE/UPDATE POItems', req.data)
  })
  this.after ('READ', POItems, async (pOItems, req) => {
    console.log('After READ POItems', pOItems)
  })

  this.on('getLargestOrder', async(req, res) => {
    try{
      //Initiate an DB transaction
      const tx = cds.tx(req);
      // Call DB table with CQL to fetch largest of purchase order
      const reply = await tx.read(PurchaseOrderSet).orderBy({
        "GROSS_AMOUNT" : 'desc'
      }).limit(1);

      return reply;
    }catch{

    }
  }) 


  // Implementation of our action
  //if the user boost the PO, increase the GROSS AMOUNT by 20000 (update data in the database)
    this.on('boost', async(req, res) => {
      try{
        //Extract the ID(key) of the PO
        const NODE_KEY = req.params[0];
        console.log( "Bro!! I got ann ID==> " + NODE_KEY );
        //initiate a DB transaction
        const tx = cds.tx(req);
        //call DB table with CQL  to fetch largest amount of PO
        await tx.update(PurchaseOrderSet).with({
          GROSS_AMOUNT: {'+=' : 20000},
          NOTE: 'Boosted!'
        }).where(NODE_KEY);

        const reply = tx.read(PurchaseOrderSet).where(NODE_KEY);
        return reply;
      }catch{

      }
    })








  return super.init()
}}
