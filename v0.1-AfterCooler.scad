/*
Dual 5015 Fan Mount for Voron 0.1
Design by Greg Huber, Greg's Maker Corner 

Purpose: Provide additional cooling, which will be helpful for many reasons including:
    - PLA, TPU, 
    - Faster printing in general 
Goal: Printable on Voron 0.1, easily add after building (no square nuts required)
Supplies needed: 
    - 2 small m5 heat inserts (same kind as used during Voron assembly)
    - 2 M3x12mm socket head screws
    - 2 5015 fans. I used these: https://amzn.to/2ZfxumB
    - Not recommended to wire to SKR e3 v2 fan connection, due to small MOSFETS which may burn out
    - Option 1: Klipper Extender if you want to control fans
    - Option 2: Wire directly to PSU and put a small switch inline to turn on manually at 100%   
*/

//Duct: should fan out to 120mm, covering entire span of build volume
//Need 30mm of clearance from side

$fn=100; 
h=10; //height of fan body

module fanout()
{
            translate([-7,0,0])
            linear_extrude(h)
            polygon(points=[[0,-2], [-60,17], [-60,25], [74,25], [74,17], [14,-2]], paths=[[0,1,2,3,4,5]]);        
    
            difference(){
                translate([0,7,0])
                linear_extrude(h)
                square([134,20], center=true);            
                
                //m3 screw cut outs                
                 translate([-61.25,2.75,5])
                 cylinder(h=h, r=3.4/2, center=true);
                 
                 translate([61.25,2.75,5])
                 cylinder(h=h, r=3.4/2, center=true);

                //cap head recess cutouts                    
                 translate([-61.25,2.75,9.1])
                 cylinder(h=3, r=5.8/2, center=true);
                 
                 translate([61.25,2.75,9.1])
                 cylinder(h=3, r=5.8/2, center=true);

             }
}

module brace(l,ang)
{
    rotate([0,0,ang])
    linear_extrude(h)
    square([l,1.5], center=true);
}

module duct()
{

    difference()
    {
        fanout();
        translate([0,7.1,2])
        scale([.90, .75, .4]) fanout(); //duct cutout

        //Cutout for 5015 fan: 19x15mm
        translate([0,11,5])
        linear_extrude(h)
        square([19.25,15], center=true);

        //front nub of fan 
        translate([10,11,8.1])
        cylinder(h=4,r=2/2,center=true);        
    }
 
    //brace spacing from front
    y1=21.75;
    y2=20.25;
  
    //create braces    
    translate([45,y1,0])
    brace(10,30);    

    translate([-45,y1,0])
    brace(10,-30);    

    translate([25,y2,0])
    brace(20,23);    

    translate([-25,y2,0])
    brace(20,-23);    

    translate([10,y1,0])
    brace(11.75,25);    

    translate([-10,y1,0])
    brace(11.75,-25);    
}


//Assume opening for extrusion is 3.4 (+/- .2)mm wide, 1.1 mm lip, 4mm depth, and ~5.8mm internal
//Refer to https://us.misumi-ec.com/vona2/detail/110300465870/

cliph=10; //thickness of clip

//generates the clip profile to fit into 1515 extrusion (left side- is later mirrored)
module clip_profile()
{
    linear_extrude(cliph)
    polygon(points=[[0,0], [-.85,.5], [-2,2.4], [-1,2.4], [-1,7], [0,7], [0,0]], paths=[[0,1,2,3,4,5,6]]);
}

module clip()
{
    
    scale([1.15, 1.15, 1.15]) //account for ABS shrinkage
    {

        difference()
            {
            union(){
                clip_profile();
                mirror([1,0,0]) clip_profile();
                
            //base against 1515
                translate([0, 7.5, 0])
                linear_extrude(cliph)
                square([10,8], center=true);
                }

            //cut out for squeezing 
            translate([0, 4, 0])
            linear_extrude(cliph + .1)        
            square([.75,9], center=true);      
            
            //m5 heat insert cutout (??)
            translate([0,10,5])
            rotate([90,0,0])
            cylinder(r=3.5/2, h=4, center=true);
                
            }
      }    
}


//Generates a "full body" assembled view. 
module fullbody(a1,a2,a3)
{
    
//Generate full Model

    rotate([a1,a2,a3])
    {
        //Generate Duct
        translate([0,0,10])
        rotate([180,0,0])
        duct();

        translate([-55.5,-2.75,23])
        rotate([-90,0,90])
        clip();

        translate([67,-2.75,23])
        rotate([-90,0,90])
        clip();
    }

}

//Generates a printable view of just the fan part.
module printbody(a1,a2,a3)
{
    
//Generate full Model

    rotate([a1,a2,a3])
    {
        //Generate Duct
        translate([0,0,10])
        rotate([180,0,0])
        duct();
    }

}

//Comment / Uncomment to generate each component. Rotate as needed. 

//fullbody(0,0,0);
//printbody(90,0,45);
clip();
   