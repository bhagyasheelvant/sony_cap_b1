const cds = require('@sap/cds')

module.exports = class MyService extends cds.ApplicationService { init() {



  this.on ('hello', async (req) => {
    return "Hey ! " + req.data.name + " Welcome to CAPM";
  })

  return super.init()
}}
