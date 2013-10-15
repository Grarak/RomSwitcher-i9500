#!/sbin/busybox sh

cat << CTAG
{
    name:I/O,
    elements:[
        { SPane:{
		title:"I/O schedulers",
		description:"Set the active I/O elevator algorithm. The scheduler decides how to handle I/O requests and how to handle them."
        }},
	{ SOptionList:{
		title:"Internal storage scheduler",
		default:`echo $(/res/synapse/actions/bracket-option /sys/block/mmcblk0/queue/scheduler)`,
		action:"bracket-option /sys/block/mmcblk0/queue/scheduler",
		values:[
`
			for IOSCHED in \`cat /sys/block/mmcblk0/queue/scheduler | sed -e 's/\]//;s/\[//'\`; do
			  echo "\"$IOSCHED\","
			done
`
		]
	}},
	{ SOptionList:{
		title:"SD card scheduler",
		default:`echo $(/res/synapse/actions/bracket-option /sys/block/mmcblk1/queue/scheduler)`,
		action:"bracket-option /sys/block/mmcblk1/queue/scheduler",
		values:[
`
			for IOSCHED in \`cat /sys/block/mmcblk1/queue/scheduler | sed -e 's/\]//;s/\[//'\`; do
			  echo "\"$IOSCHED\","
			done
`
		]
	}},
	{ SSeekBar:{
		title:"Internal storage read-ahead",
		description:"The read-ahead value on the internal phone memory.",
		max:2048, min:128, unit:"kB", step:128,
		default:`cat /sys/block/mmcblk0/queue/read_ahead_kb`,
                action:"generic /sys/block/mmcblk0/queue/read_ahead_kb"
	}},
	{ SSeekBar:{
		title:"SD card read-ahead",
		description:"The read-ahead value on the external SD card.",
		max:2048, min:128, unit:"kB", step:128,
		default:`cat /sys/block/mmcblk1/queue/read_ahead_kb`,
                action:"generic /sys/block/mmcblk1/queue/read_ahead_kb"
	}},
    ]
}
CTAG
