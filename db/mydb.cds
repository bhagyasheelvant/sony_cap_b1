namespace sony.metro;

//like a data element in abap
// type Guid: String(32) @title : 'Key';


//now adding the structure in our database table :
// This is the custom aspect
using { sony.metro.reuse as reuse } from './myreuse';
//sap also provides standard aspects like - ID generation - id, temporal - date(begin and end), managed(admin data like created by, created on..)
using { cuid, managed, temporal} from '@sap/cds/common';

//the best practice is naming the alias as the last one present like sony.metro.reuse

entity book {
    key id: reuse.Guid;
    bookName: localized String(64);
    author: String(64);
}

//add the address data aspect fields will be imported to the table
entity student: reuse.address {
    key id: reuse.Guid;
    name: String(255);
    gender: String(1);
    rollNo: Integer64;
    // foreign key = column name = class CONCATENATE id = class_id (class is here the column and the id is the primary key of this column)
    class: Association to one class;
}

entity class {
    key id: reuse.Guid;
    specialization: String(255);
    semester: Int32;
    hod: String(64);
    student: Association to many student 
    on student.class = $self;
}

//reusing aspects from sap standard to bring fields for id, createdBy, changedBy, validFrom, validTo
entity Subs: cuid, managed, temporal {
    student: Association to one student; 
    book: Association to one book;
}