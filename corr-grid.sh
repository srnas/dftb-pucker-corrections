#!/bin/bash

if [ $# = 0 ] ; then
cat << EOF
Usage:
./generate-grids.sh method sequence

methods is dftb3 or am1d
sequence is space separated sequence

Example:
./generate-grids.sh dftb3 C G U U C G G C

EOF

exit
fi

num=0
rm -f plumed.dat

method=$1
shift

for name
do

num=$((num+1))

cat >> plumed.dat << EOF

puck_${name}${num} PUCKERING ATOMS=@sugar-$num
ext_$name$i: ...
  EXTERNAL
  ARG=puck_${name}${num}.Zx,puck_${name}${num}.Zy FILE=ext-${method}_${name}${num}.dat
...
EOF


max=`awk -v name=$name 'BEGIN{a=-400}{
if(name=="A") column=7; else if(name=="C") column=8; else if(name=="G") column=9; else if(name=="U") column=10;
if(NF>0){if($2 == 60.0 || $2 == -60.0 || $1 == 60.0 || $1 == -60.0){if($column>a) a=$column}}}END{print a}' grid_points_$method.dat `

# echo $max

awk -v name=$name -v max=$max -v num=$num '
function ceiling(x)
{

   return (x == int(x)) ? x : int(x)+1

}
BEGIN{ 

    pi=3.14159265359
    for(i=-180;i<=180;i+=6) for(j=-180;j<=180;j+=6) a[i,j]=max*4.184 
    z=0
} 
{

   if(name=="A") f=$7; else if(name=="C") f=$8; else if(name=="G") f=$9; else if(name=="U") f=$10;
   if (NF !=0 && NR > 2) a[int($1),int($2)]=f*4.184
   #if($1==0 && $2==0) print f
   #c[x]=$1 
   #d[y]=$2

} END { 

 zx="puck_" name num ".Zx";
 zy="puck_" name num ".Zy";
  
 print "#! FIELDS " zx " " zy " ext.bias der_" zx " der_" zy
 print "#! SET min_" zx " -3.141593"
 print "#! SET max_" zx "  3.141593"
 print "#! SET nbins_" zx " 60"
 print "#! SET periodic_" zx " false"
 print "#! SET min_" zy " -3.141593"
 print "#! SET max_" zy "  3.141593"
 print "#! SET nbins_" zy " 60"
 print "#! SET periodic_" zy " false"

   #print "#",a[0,0]/4.184 
   for(i=-180;i<=180;i+=6) {
      for(j=-180;j<=180;j+=6) {

        y=(a[i,j+6]-a[i,j-6])/(2.0*0.1047)
        x=(a[i+6,j]-a[i-6,j])/(2.0*0.1047)
        
        if( i == 180 ){ x=(a[i,j]-a[174,j])/0.1047 }
        if( i == -180 ){ x=(a[-174,j]-a[i,j])/0.1047 }
        if( j == 180 ){ y=(a[i,j]-a[i,174])/0.1047 } 
        if( j == -180 ){ y=(a[i,-174]-a[i,j])/0.1047 }
        
        printf("%.6lf    %.6lf    %.2lf    %.6lf    %.6lf\n", i*pi/180, j*pi/180, a[i,j], x, y) 

  }
 print " "
 }
}' grid_points_$method.dat > ext-${method}_${name}${i}.dat

done
