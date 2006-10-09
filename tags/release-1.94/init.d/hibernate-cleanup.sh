#!/bin/sh

# This script invalidates any stale swsusp and Software Suspend 2 images. It
# searches all swap partitions on your machine, as well as Suspend2's
# filewriter files (by way of the hibernate script telling it where to find
# it).
#
# It should be called on boot, after mounting filesystems, but before enabling
# swap or clearing out /var/run. Copy this into /etc/init.d/ (or the appropriate
# place on your system), then add a symlink at the appropriate point on boot.
# On a Debian system, you would do this:
#   update-rc.d hibernate-cleanup.sh start 31 S .
#
# On other SysV-based systems, you would do something like:
#   ln -s ../init.d/hibernate-cleanup.sh /etc/rcS.d/S31hibernate-cleanup.sh

HIBERNATE_FILEWRITER_TRAIL="/var/run/suspend2_filewriter_image_exists"

get_swap_id() {
	local line
	fdisk -l 2>/dev/null | while read line; do
		case "$line" in
			/*Linux\ [sS]wap*) echo "${line%% *}"
		esac
	done
}

clear_swap() {
	local where wason
	where=$1
	wason=
	swapoff $where 2>/dev/null && wason=yes
	mkswap $where > /dev/null || echo -n " (failed: $?)"
	[ -n "$wason" ] && swapon $where
}

check_swap_sig() {
	local part="$(get_swap_id)"
	local where what type rest p c
	while read  where what type rest ; do
		test "$type" = "swap" || continue
		c=continue
		for p in $part ; do
			test "$p" = "$where" && c=:
		done
		$c
		case "$(dd if=$where bs=1 count=6 skip=4086 2>/dev/null)" in
			S1SUSP|S2SUSP|pmdisk|[zZ]*)
				echo -n "$where"
				clear_swap $where
				echo -n ", "
		esac
	done < /etc/fstab
}

check_filewriter_sig() {
	local target
	[ -f "$HIBERNATE_FILEWRITER_TRAIL" ] || return
	read target < $HIBERNATE_FILEWRITER_TRAIL
	[ -f "$target" ] || return
	case "`dd \"if=$target\" bs=8 count=1 2>/dev/null`" in
		HaveImag)
			/bin/echo -ne "Suspend2\n\0\0" | dd "of=$target" bs=11 count=1 conv=notrunc 2>/dev/null
			echo -n "$target, "
			rm -f $HIBERNATE_FILEWRITER_TRAIL
	esac
}

case "$1" in
start)
        echo -n "Invalidating stale software suspend images... "
        check_swap_sig
        check_filewriter_sig
        echo "done."
        ;;
stop|restart|force-reload)
        ;;
*)
        echo "Usage: /etc/init.d/hibernate {start|stop|restart|force-reload}"
esac

exit 0
