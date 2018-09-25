%sysexec perl test.pl "GOO" 8 > tets.ot;
dm "inc 'tets.ot'";
$db->Sql("SELECT * FROM MSysIMEXColumns");
$db->Sql("SELECT * FROM Products");
$db->FetchRow();
%hash=$db->DataHash;
foreach $key (sort(keys %hash)) { print $key, '=', $hash{$key}, "\n";};
%sysexec perl test.pl "HOO" 8 > tets.ot;
dm "inc 'tets.ot'";
%sysexec perl test8.pl "HOO" 8 > tets.ot;
dm "inc 'tets.ot'";
$db->Sql("SELECT * FROM MSysACEs");
$db->Sql("SELECT * FROM MSysIMEXColumns");
$db->Sql("SELECT * FROM Products");
$db->FetchRow();
%hash=$db->DataHash;
foreach $key (sort(keys %hash)) { print $key, '=', $hash{$key}, "\n";};

use Win32::ODBC;
$db = new Win32::ODBC("HOO");

@FieldNames = $db->FieldNames();

print @FieldNames[4];

print @Attributes[4];

@att =ColAttributes($Attributes,@FieldNames);

$db->ColAttributes(@Attribute,@FieldNames);


use Win32::ODBC;
$db = new Win32::ODBC("HOO");
$db->Sql("SELECT * FROM Products");
@FieldNames = $db->DescribeCol();
print @FieldNames;

@Attributes = $db->ColAttributes();
print @Attributes;

@att = $db->ColAttributes("","PRODUCTNAME");
@att = $db->ColAttributes("","");
@att = $db->ColAttributes($att,@FieldNames);
print @att;
print $x;

$t=$db->Catalog("","","%"


use Win32::ODBC;
$db = new Win32::ODBC("HOO");
$db->Sql("SELECT * FROM Products");
@FieldNames = $db->FieldNames();
@att = $db->ColAttributes($att,@FieldNames);
while ($db->FetchRow()){
    undef %Data;
    %Data = %db -> DataHash();
    print();
}

print "\n\tNo More Data.\n";
}else{ $Failed{'Read'} = "Sql(): " . $db->Error();
}


use Win32::ODBC;
$db = new Win32::ODBC("HOO");
$P=Products;
$MaxRows = 1E10;
$db->SetStmtOption($db->SQL_MAX_ROWS, $MaxRows)
$db->Sql("SELECT * FROM $P");
@F = $db->FieldNames();
print "$#F\n";
for ( $i=0; $i<=$#F; $i++ ) { $G[$i]=uc $F[$i]; print "$G[$i]\n";};
for ( $i=0; $i<=$#F; $i++ ) { $R[$i]=$db->Sql("SELECT $G[$i] FROM $P WHERE $G[$i] = 2"); print "$F[$i] $R[$i] \n"; };
$db->Sql("SELECT * FROM Products");
while ($db->FetchRow()){ undef %Data; %Data = $db -> DataHash(); foreach (keys(%Data)) { print "$Data{$_}\n"; } };



@att = $db->ColAttributes($att,@FieldNames);
print "\n\tNo More Data.\n"; }else{ $Failed{'Read'} = "Sql(): " . $db->Error(); }


sub Error{ my($Data) = @_; $Data->DumpError() if ref($Data); Win32::ODBC::DumpError() if !  ref($Data); }


 print "$Data{$FieldNames[1]}";


$rc = $db->Sql("SELECT PRODUCTID FROM Products where PRODUCTID='2'");
$rc = $db->Sql("SELECT PRODUCTID FROM Products where PRODUCTNAME='X'");

foreach ( $rc = $db->Sql("SELECT uc $FieldNames  FROM Products where PRODUCTNAME='X'");

for ( $i=1; $i<$#Fieldnames; $i++ ) { print uot "@tables[$i]\n"; };

$db->Sql("SELECT * FROM Products");
@F = $db->FieldNames();

for ( $i=0; $i<=$#F; $i++ ) { $G[$i]=uc $F[$i]; };
