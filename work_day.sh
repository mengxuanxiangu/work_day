#!/bin/bash
function usage {
    echo "usage: sh $0 -m month -d day -y year"
    echo "      -m set the month default last month"
    echo "      -d set the day default current day"
    echo "      -y set the year default current year"
}

#set the default
function default {
    year=`date +%Y`
    month=`date -d "1 month ago" +%m`
    day=`date +%d`
}
default
while getopts m:y:d:h option;do
    case "$option" in
        m) month=$OPTARG;;
        y) year=$OPTARG;;
        d) day=$OPTARG;;
        h) usage;exit 0;;
        *) usage;exit 0;;
    esac
done

#set the day
cur_month=`date +%m`
if [ $cur_month -ne $month ];then
    day=31
else
    day=`date --date="$year$month$day" +%e`
fi

min=0
sum=0
echo ======== $month month =============""
for i in `seq 0 $day`
do
    j=$(($i + 1))
    week=`date -d "$i day $year${month}01" +%u`
    the_month=`date -d "$j day $year${month}01" +%m`
    the_day=`date -d "$i day $year${month}01" +%e`
    if [ $the_month -ne $month ];then
        day=$the_day
    fi
    if [ $the_day -eq 1 -a $week -lt 6 ];then
            echo -ne $the_day"-"
            min=$the_day
    elif [ $week -eq 1 ];then
        echo -ne $the_day"-"
        min=$the_day
    fi
    if [ $week -eq 5 -o $the_day -eq $day -a $week -lt 6 ];then
        echo $the_day" "$(($the_day-$min+1))
        sum=$(($sum + $(($the_day-$min+1))))
    fi
    if [ $the_month -ne $month ];then
        break;
    fi
done
echo "work day: "$sum
echo "meals: $(($sum * 20))"
echo "phone rate: 150"
echo "total $(($(($sum * 20)) + 150))"
echo =========== end ==============""
