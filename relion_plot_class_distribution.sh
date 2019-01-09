#!/bin/bash
#

starin=$1

# Get total class occupancy
total=$(relion_star_printtable $starin data_model_classes _rlnClassDistribution | awk -F '|' '{sum+=$NF} END {print sum}')

# Print sanity check
echo "Total class occupancy total: ${total}"
echo ""

# Get per class occupancy
relion_star_printtable $starin data_model_classes _rlnClassDistribution | sort -r | grep -v e > classocc.dat
xhigh=$(wc -l classocc.dat | awk {'print $1'})

# Plot data

gnuplot <<- EOF
set xlabel "Class number"
set ylabel "Class % ptcl occupancy"
set xrange [-3:$xhigh]
set key outside
set term png size 900,400
set size ratio 0.6
set output "class_occupancy.png"
plot "classocc.dat" with boxes
EOF

eog class_occupancy.png