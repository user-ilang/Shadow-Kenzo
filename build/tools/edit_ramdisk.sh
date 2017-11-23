#!/sbin/sh

CONFIGFILE="/tmp/init.shadow.rc"
SPECFILE="/tmp/init.spectrum.rc"
INTERACTIVE=$(cat /tmp/aroma/interactive.prop | cut -d '=' -f2)
if [ $INTERACTIVE == 1 ]; then
TLS="50 1017600:60 1190400:70 1305600:80 1382400:90 1401600:95"
TLB="85 1382400:90 1747200:95"
BOOST="0"
HSFS=1440000
HSFB=1382400
FMS=691200
FMB=883200
FMAS=1440000
FMAB=1843200
TR=20000
AID=N
ABST=0
TBST=0
GHLS=100
GHLB=90
SWAP=40
VFS=100
GLVL=8
GFREQ=133333333
TEMPTT=65
TEMPTL=45
LPA=1
LPT=1035
LPH=8
LPP=0
LPC=6
elif [ $INTERACTIVE == 2 ]; then
TLS="65 1017600:75 1190400:85"
TLB="90 1382400:95"
BOOST="0"
HSFS=1440000
HSFB=1190400
FMS=691200
FMB=883200
FMAS=1305600
FMAB=1612800
TR=30000
AID=Y
ABST=0
TBST=0
GHLS=100
GHLB=85
SWAP=20
VFS=40
GLVL=8
GFREQ=133333333
TEMPTT=60
TEMPTL=40
LPA=1
LPT=1050
LPH=11
LPP=4
LPC=6
elif [ $INTERACTIVE == 3 ]; then
TLS="40 1017600:50 1190400:60 1305600:70 1382400:80 1401600:90"
TLB="75 1382400:80 1747200:85"
BOOST="0:1305600 4:1305600"
HSFS=1440000
HSFB=1382400
FMS=691200
FMB=883200
FMAS=1440000
FMAB=1843200
TR=20000
AID=N
ABST=1
TBST=1
GHLS=95
GHLB=80
SWAP=60
VFS=100
GLVL=7
GFREQ=200000000
TEMPTT=80
TEMPTL=60
LPA=0
LPT=1035
LPH=8
LPP=0
LPC=6
fi
DT2W=$(cat /tmp/aroma/dt2w.prop | cut -d '=' -f2)
if [ $DT2W == 1 ]; then
DTP=1
VIBS=50
elif [ $DT2W == 2 ]; then
DTP=1
VIBS=0
elif [ $DT2W == 3 ]; then
DTP=0
VIBS=50
fi
DFSC=`grep "item.0.1" /tmp/aroma/mods.prop | cut -d '=' -f2`
if [ $DFSC = 1 ]; then
DFS=0
elif [ $DFSC = 0 ]; then
DFS=1
fi
FC=`grep "item.0.2" /tmp/aroma/mods.prop | cut -d '=' -f2`
if [ $FC = 1 ]; then
USB=1
elif [ $FC = 0 ]; then
USB=0
fi
echo "# VARIABLES FOR SH" >> $CONFIGFILE
echo "# zrammode=$INTERACTIVE" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# USER TWEAKS" >> $CONFIGFILE
echo "service usertweaks /system/bin/sh /system/etc/shadow.sh" >> $CONFIGFILE
echo "class main" >> $CONFIGFILE
echo "group root" >> $CONFIGFILE
echo "user root" >> $CONFIGFILE
echo "oneshot" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "on property:dev.bootcomplete=1" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# SWAPPINESS AND VFS CACHE PRESSURE" >> $CONFIGFILE
echo "write /proc/sys/vm/swappiness $SWAP" >> $CONFIGFILE
echo "write /proc/sys/vm/vfs_cache_pressure $VFS" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# DT2W" >> $CONFIGFILE
echo "write /sys/android_touch/doubletap2wake " $DTP >> $CONFIGFILE
echo "write /sys/android_touch/vib_strength " $VIBS >> $CONFIGFILE
echo "" >> $CONFIGFILE
COLOR=$(cat /tmp/aroma/color.prop | cut -d '=' -f2)
echo "# KCAL" >> $CONFIGFILE
if [ $COLOR == 1 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 269" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 256" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 256" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"254 252 230"\" >> $CONFIGFILE
elif [ $COLOR == 2 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 269" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 256" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 256" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"254 254 240"\" >> $CONFIGFILE
elif [ $COLOR == 3 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 270" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 257" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 265" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"256 256 256"\" >> $CONFIGFILE
elif [ $COLOR == 4 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_val 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_cont 255" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"256 256 256"\" >> $CONFIGFILE
fi
echo "" >> $CONFIGFILE
echo "# CHARGING RATE" >> $CONFIGFILE
CRATE=$(cat /tmp/aroma/crate.prop | cut -d '=' -f2)
if [ $CRATE == 1 ]; then
CHG=2000
elif [ $CRATE == 2 ]; then
CHG=2400
fi 
echo "chmod 666 /sys/module/qpnp_smbcharger/parameters/default_dcp_icl_ma" >> $CONFIGFILE
echo "chmod 666 /sys/module/qpnp_smbcharger/parameters/default_hvdcp_icl_ma" >> $CONFIGFILE
echo "chmod 666 /sys/module/qpnp_smbcharger/parameters/default_hvdcp3_icl_ma" >> $CONFIGFILE
echo "write /sys/module/qpnp_smbcharger/parameters/default_dcp_icl_ma $CHG" >> $CONFIGFILE
echo "write /sys/module/qpnp_smbcharger/parameters/default_hvdcp_icl_ma $CHG" >> $CONFIGFILE
echo "write /sys/module/qpnp_smbcharger/parameters/default_hvdcp3_icl_ma $CHG" >> $CONFIGFILE
echo "write /sys/kernel/fast_charge/force_fast_charge $USB" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# DISABLE BCL & CORE CTL" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_soc_mask 0" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# BRING CORES ONLINE" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu1/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu2/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu3/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu5/online 1" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# TWEAK A53 CLUSTER GOVERNOR" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor \"interactive\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load $GHLS" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate $TR" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq $HSFS" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads \"$TLS\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time 40000" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq $FMS" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq $FMAS" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# TWEAK A72 CLUSTER GOVERNOR" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/online 1" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor \"interactive\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay \"19000 1382400:39000\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load $GHLB" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate $TR" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq $HSFB" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy 0" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads \"$TLB\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time 40000" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq $FMB" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq $FMAB" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# ENABLE BCL & CORE CTL" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 0">> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode disable" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_mask 48" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/hotplug_soc_mask 32" >> $CONFIGFILE
echo "write /sys/devices/soc.0/qcom,bcl.56/mode enable" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# GPU SETTINGS" >> $CONFIGFILE
echo "write /sys/devices/soc.0/1c00000.qcom,kgsl-3d0/kgsl/kgsl-3d0/default_pwrlevel $GLVL" >> $CONFIGFILE
echo "write /sys/devices/soc.0/1c00000.qcom,kgsl-3d0/kgsl/kgsl-3d0/min_pwrlevel $GLVL" >> $CONFIGFILE
echo "write /sys/devices/soc.0/1c00000.qcom,kgsl-3d0/kgsl/kgsl-3d0/devfreq/min_freq $GFREQ" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# CPU BOOST PARAMETERS" >> $CONFIGFILE
echo "write /sys/module/cpu_boost/parameters/input_boost_freq \"$BOOST\"" >> $CONFIGFILE
echo "write /sys/module/cpu_boost/parameters/input_boost_ms 50" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# SET IO SCHEDULER" >> $CONFIGFILE
echo "setprop sys.io.scheduler \"maple\"" >> $CONFIGFILE
echo "write /sys/block/mmcblk0/queue/read_ahead_kb 512" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# TOUCH BOOST" >> $CONFIGFILE
echo "write /sys/module/msm_performance/parameters/touchboost $TBST" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# ADRENO IDLER" >> $CONFIGFILE
echo "write /sys/module/adreno_idler/parameters/adreno_idler_active $AID" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# ADRENO BOOST" >> $CONFIGFILE
echo "write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost $ABST" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# FSYNC" >> $CONFIGFILE
echo "write /sys/module/sync/parameters/fsync_enabled $DFS" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# RUN USERTWEAKS SERVICE" >> $CONFIGFILE
echo "start usertweaks" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "write /sys/module/mdss_fb/parameters/backlight_dimmer y" >> $CONFIGFILE
echo "write /sys/block/mmcblk0/queue/iostats 0" >> $CONFIGFILE
echo "write /sys/block/mmcblk1/queue/iostats 0" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# THERMAL SETTINGS" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/parameters/enabled y" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/parameters/temp_threshold $TEMPTL" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/parameters/core_limit_temp_degC $TEMPTT" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# KSM" >> $CONFIGFILE
echo "write /sys/kernel/mm/ksm/run 0" >> $CONFIGFILE
echo "write /sys/kernel/mm/ksm/run_charging 0" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# LAZYPLUG" >> $CONFIGFILE
echo "write /sys/module/lazyplug/parameters/lazyplug_active $LPA" >> $CONFIGFILE
echo "write /sys/module/lazyplug/parameters/cpu_nr_run_threshold $LPT" >> $CONFIGFILE
echo "write /sys/module/lazyplug/parameters/nr_run_hysteresis $LPH" >> $CONFIGFILE
echo "write /sys/module/lazyplug/parameters/nr_run_profile_sel $LPP" >> $CONFIGFILE
echo "write /sys/module/lazyplug/parameters/nr_possible_cores $LPC" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# CPU SCHEDULER" >> $CONFIGFILE
echo "chmod 755 /proc/sys/kernel/sched_boost" >> $CONFIGFILE
echo "write /proc/sys/kernel/sched_boost 0" >> $CONFIGFILE
echo "write /proc/sys/kernel/sched_freq_inc_notify 400000" >> $CONFIGFILE
echo "write /proc/sys/kernel/sched_freq_dec_notify 400000" >> $CONFIGFILE
echo "write /proc/sys/kernel/sched_wake_to_idle 0" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# SHADOW SCHEDULING" >> $CONFIGFILE
echo "chmod 755 /proc/sys/kernel/sched_use_shadow_scheduling" >> $CONFIGFILE
echo "write /proc/sys/kernel/sched_use_shadow_scheduling 1" >> $CONFIGFILE
echo "write /proc/sys/kernel/sched_shadow_downmigrate 80" >> $CONFIGFILE
echo "write /proc/sys/kernel/sched_shadow_upmigrate 85" >> $CONFIGFILE
echo "" >> $CONFIGFILE
echo "# POWERSUSPEND" >> $CONFIGFILE
echo "write /sys/kernel/power_suspend/power_suspend_mode 3" >> $CONFIGFILE
VOLT=$(cat /tmp/aroma/uv.prop | cut -d '=' -f2)
if [ $VOLT == 1 ]; then
echo "# CPU & GPU UV" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/GPU_mV_table \"700 720 760 800 860 900 920 980 1020\"" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table \"740 760 820 920 980 1020 1050 1060 1070 780 800 870 910 970 1020 1040\"" >> $CONFIGFILE
fi

echo "# SPECTRUM KERNEL MANAGER" >> $SPECFILE
echo "# Ramdisk file for profile based kernel management" >> $SPECFILE
echo "# Implimentation inspired by Franco's fku profiles" >> $SPECFILE
echo "" >> $SPECFILE
echo "# Initialization" >> $SPECFILE
echo "on property:sys.boot_completed=1" >> $SPECFILE
echo "   # Set default profile on first boot" >> $SPECFILE
echo "   exec u:r:init:s0 root root -- /init.spectrum.sh" >> $SPECFILE
echo "   exec u:r:su:s0 root root -- /init.spectrum.sh" >> $SPECFILE
echo "   # Enable Spectrum support" >> $SPECFILE
echo "   setprop spectrum.support 1" >> $SPECFILE
echo "" >> $SPECFILE
echo "   setprop persist.spectrum.kernel Shadow" >> $SPECFILE
echo "" >> $SPECFILE
echo "# Balance (default profile)" >> $SPECFILE
echo "on property:persist.spectrum.profile=0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 2" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor \"interactive\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor \"interactive\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/online 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu5/online 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq $FMS" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq $FMAS" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq $FMB" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq $FMAB" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load $GHLS" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate $TR" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq $HSFS" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack -1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads \"$TLS\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time 40000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/ignore_hispeed_on_notif 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/fast_ramp_down 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/enable_prediction 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load $GHLB" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay \"19000 1382400:39000\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate $TR" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq $HSFB" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack -1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads \"$TLB\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time 40000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/ignore_hispeed_on_notif 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/boost 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/fast_ramp_down 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/enable_prediction 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration 0" >> $SPECFILE
echo "    write /sys/module/cpu_boost/parameters/input_boost_enabled 0" >> $SPECFILE
echo "    write /sys/module/cpu_boost/parameters/input_boost_freq \"0:0 1:0 2:0 3:0 4:0 5:0\"" >> $SPECFILE
echo "    write /sys/module/cpu_boost/parameters/input_boost_ms 30" >> $SPECFILE
echo "    write /sys/module/msm_performance/parameters/touchboost 0" >> $SPECFILE
echo "    write /sys/module/adreno_idler/parameters/adreno_idler_active Y" >> $SPECFILE
echo "    write /sys/class/kgsl/kgsl-3d0/devfreq/max_freq 600000000" >> $SPECFILE
echo "    write /sys/class/kgsl/kgsl-3d0/devfreq/governor msm-adreno-tz" >> $SPECFILE
echo "    write /sys/block/mmcblk0/queue/scheduler maple" >> $SPECFILE
echo "    write /sys/block/mmcblk1/queue/scheduler maple" >> $SPECFILE
echo "    write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost $ABST" >> $SPECFILE
echo "    write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 1" >> $SPECFILE
echo "    write /sys/module/lazyplug/parameters/lazyplug_active $LPA" >> $SPECFILE
echo "    write /sys/module/lazyplug/parameters/cpu_nr_run_threshold $LPT" >> $SPECFILE
echo "    write /sys/module/lazyplug/parameters/nr_run_hysteresis $LPH" >> $SPECFILE
echo "    write /sys/module/lazyplug/parameters/nr_run_profile_sel $LPP" >> $SPECFILE
echo "    write /sys/module/lazyplug/parameters/nr_possible_cores $LPC" >> $SPECFILE
echo "" >> $SPECFILE
echo "# Performance" >> $SPECFILE
echo "on property:persist.spectrum.profile=1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 2" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor \"interactive\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor \"interactive\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/online 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu5/online 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 691200" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1440000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 883200" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 1843200" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load 99" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay 25000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq $HSFS" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time 30000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate 20000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack -1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads \"60 806400:35 1017600:40 1190400:60 1305600:80 1401600:90 1440000:99\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack -1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load 65" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay \"15000 1382400:30000\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq 1382400" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time 30000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate 25000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/boost 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads \"50 883200:30 998400:45 1113600:55 1382400:65 1612800:75 1747200:85 1804800:93 1843200:98\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis 25000" >> $SPECFILE
echo "    write /sys/module/cpu_boost/parameters/input_boost_enabled 1" >> $SPECFILE
echo "    write /sys/module/cpu_boost/parameters/input_boost_freq \"0:1305600 1:1305600 2:0 3:0 4:1113600 5:0\"" >> $SPECFILE
echo "    write /sys/module/cpu_boost/parameters/input_boost_ms 90" >> $SPECFILE
echo "    write /sys/module/msm_performance/parameters/touchboost 1" >> $SPECFILE
echo "    write /sys/module/adreno_idler/parameters/adreno_idler_active N" >> $SPECFILE
echo "    write /sys/class/kgsl/kgsl-3d0/devfreq/max_freq 600000000" >> $SPECFILE
echo "    write /sys/class/kgsl/kgsl-3d0/devfreq/governor msm-adreno-tz" >> $SPECFILE
echo "    write /sys/block/mmcblk0/queue/scheduler fiops" >> $SPECFILE
echo "    write /sys/block/mmcblk1/queue/scheduler fiops" >> $SPECFILE
echo "    write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 2" >> $SPECFILE
echo "    write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 0" >> $SPECFILE
echo "    write /sys/module/lazyplug/parameters/lazyplug_active 0" >> $SPECFILE
echo "" >> $SPECFILE
echo "# Battery" >> $SPECFILE
echo "on property:persist.spectrum.profile=2" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/online 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu5/online 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor \"cultivation\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 400000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1305600" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/cultivation/go_hispeed_load 99" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/cultivation/above_hispeed_delay 30000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/cultivation/hispeed_freq 1305600" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/cultivation/min_sample_time 45000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/cultivation/timer_rate 40000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/cultivation/max_freq_hysteresis 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/cultivation/timer_slack -1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/cultivation/powersave_bias 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/cultivation/fastlane 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/cultivation/align_windows 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/cultivation/target_loads \"60 400000:25 691200:40 1017600:55 1190400:85 1305600:99"\" >> $SPECFILE
echo "    write /sys/module/cpu_boost/parameters/input_boost_enabled 0" >> $SPECFILE
echo "    write /sys/module/cpu_boost/parameters/input_boost_freq \"0:0 1:0 2:0 3:0 4:0 5:0\"" >> $SPECFILE
echo "    write /sys/module/cpu_boost/parameters/input_boost_ms 30" >> $SPECFILE
echo "    write /sys/module/msm_performance/parameters/touchboost 0" >> $SPECFILE
echo "    write /sys/module/adreno_idler/parameters/adreno_idler_active Y" >> $SPECFILE
echo "    write /sys/class/kgsl/kgsl-3d0/devfreq/max_freq 432000000" >> $SPECFILE
echo "    write /sys/class/kgsl/kgsl-3d0/devfreq/governor powersave" >> $SPECFILE
echo "    write /sys/block/mmcblk0/queue/scheduler noop" >> $SPECFILE
echo "    write /sys/block/mmcblk1/queue/scheduler noop" >> $SPECFILE
echo "    write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 0" >> $SPECFILE
echo "    write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 1" >> $SPECFILE
echo "    write /sys/module/lazyplug/parameters/lazyplug_active 1" >> $SPECFILE
echo "    write /sys/module/lazyplug/parameters/cpu_nr_run_threshold 1050" >> $SPECFILE
echo "    write /sys/module/lazyplug/parameters/nr_run_hysteresis 11" >> $SPECFILE
echo "    write /sys/module/lazyplug/parameters/nr_run_profile_sel 4" >> $SPECFILE
echo "    write /sys/module/lazyplug/parameters/nr_possible_cores 4" >> $SPECFILE
echo "" >> $SPECFILE
echo "# Gaming" >> $SPECFILE
echo "on property:persist.spectrum.profile=3" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 2" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor \"interactive\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor \"interactive\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/online 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu5/online 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 691200" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1440000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 883200" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 1843200" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load 95" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay 25000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq 1440000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time 25000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate 20000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack -1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads \"80 1017600:30 1190400:40 1305600:50 1401600:75 1440000:90\" " >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack -1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load 50" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/boost 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay \"15000 1382400:25000\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq 1382400" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time 30000" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load 1" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows 0" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads \"50 1113600:35 1382400:50 1612800:60 1747200:70 1804800:80 1958600:90\"" >> $SPECFILE
echo "    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis 45000" >> $SPECFILE
echo "    write /sys/module/cpu_boost/parameters/input_boost_enabled 1" >> $SPECFILE
echo "    write /sys/module/cpu_boost/parameters/input_boost_freq \"0:1305600 1:1305600 2:1305600 3:1305600 4:1190400 5:1190400\"" >> $SPECFILE
echo "    write /sys/module/cpu_boost/parameters/input_boost_ms 100" >> $SPECFILE
echo "    write /sys/module/adreno_idler/parameters/adreno_idler_active N" >> $SPECFILE
echo "    write /sys/class/kgsl/kgsl-3d0/devfreq/max_freq 600000000" >> $SPECFILE
echo "    write /sys/class/kgsl/kgsl-3d0/devfreq/governor performance" >> $SPECFILE
echo "    write /sys/block/mmcblk0/queue/scheduler deadline" >> $SPECFILE
echo "    write /sys/block/mmcblk1/queue/scheduler deadline" >> $SPECFILE
echo "    write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 3" >> $SPECFILE
echo "    write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 0" >> $SPECFILE
echo "    write /sys/module/lazyplug/parameters/lazyplug_active 0" >> $SPECFILE
