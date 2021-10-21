//Fan Cooling Test

module BridgeTest()
{
    linear_extrude(1)
    square([10,10]);

    i=0;

    for (r=[10:20:90])  
    {
        translate([0,i,0])
        rotate([90-r,0,0])
        linear_extrude(.4)
        square([10,10]);    
    }
}

for(x=[10:40:120])
{

    for(y=[10:40:120])
    {
            translate([x,y,0])
            BridgeTest();   
    }

}



