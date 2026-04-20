namespace sony.metro.reuse;

type Guid: String(32) @title : 'Key';

//aspects: like a structure which is the combination of fields
aspect address {
    city: String(32);
    country: String(32);
    region: String(32);
    landmark: String(32);
    houseNo: Int16;
} 