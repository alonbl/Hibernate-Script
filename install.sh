#!/bin/sh
# -*- sh -*-
# vim:ft=sh:ts=8:sw=4:noet

[ -z "$PREFIX" ]        	&& PREFIX=/usr/local
[ -z "$EXEC_PREFIX" ]   	&& EXEC_PREFIX=$PREFIX

[ -z "$SCRIPT_DEST" ]   	&& SCRIPT_DEST=$BASE_DIR$EXEC_PREFIX/sbin/hibernate
[ -z "$SHARE_DIR" ] 		&& SHARE_DIR=$BASE_DIR$PREFIX/share/hibernate
[ -z "$SCRIPTLET_DIR" ] 	&& SCRIPTLET_DIR=$BASE_DIR$PREFIX/share/hibernate/scriptlets.d
[ -z "$MAN_DIR" ]       	&& MAN_DIR=$BASE_DIR$PREFIX/man
[ -z "$CONFIG_DIR" ]    	&& CONFIG_DIR=${BASE_DIR}${CONFIG_PREFIX}/etc/hibernate
[ -z "$CONFIG_FILE" ]   	&& CONFIG_FILE=$CONFIG_DIR/hibernate.conf
[ -z "$RAM_CONFIG_FILE" ]   && RAM_CONFIG_FILE=$CONFIG_DIR/ram.conf
[ -z "$DISK_CONFIG_FILE" ]  && DISK_CONFIG_FILE=$CONFIG_DIR/disk.conf
[ -z "$S2_CONFIG_FILE" ]    && S2_CONFIG_FILE=$CONFIG_DIR/tuxonice.conf
[ -z "$US_BOTH_CONFIG_FILE" ]   && US_BOTH_CONFIG_FILE=$CONFIG_DIR/ususpend-both.conf
[ -z "$US_DISK_CONFIG_FILE" ]   && US_DISK_CONFIG_FILE=$CONFIG_DIR/ususpend-disk.conf
[ -z "$US_RAM_CONFIG_FILE" ]    && US_RAM_CONFIG_FILE=$CONFIG_DIR/ususpend-ram.conf
[ -z "$SYSFS_RAM_CONFIG_FILE" ] && SYSFS_RAM_CONFIG_FILE=$CONFIG_DIR/sysfs-ram.conf
[ -z "$SYSFS_DISK_CONFIG_FILE" ] && SYSFS_DISK_CONFIG_FILE=$CONFIG_DIR/sysfs-disk.conf
[ -z "$COMMON_CONFIG_FILE" ]	&& COMMON_CONFIG_FILE=$CONFIG_DIR/common.conf
[ -z "$BLACKLIST" ]     	&& BLACKLIST=$CONFIG_DIR/blacklisted-modules
[ -z "$LOGROTATE_DIR" ] 	&& LOGROTATE_DIR=${BASE_DIR}/etc/logrotate.d

[ -z "$OLD_SCRIPTLET_DIR" ] && OLD_SCRIPTLET_DIR=$CONFIG_DIR/scriptlets.d

(
set -e

echo "Installing hibernate script to $SCRIPT_DEST ..."
mkdir -p `dirname $SCRIPT_DEST`
cp -a hibernate.sh $SCRIPT_DEST

echo "Installing configuration files to $CONFIG_DIR ..."
mkdir -p $CONFIG_DIR
# We assume that if hibernate.conf does not exist, no config files do.
# Let a package management system figure this one out.
if [ -f $CONFIG_FILE ] ; then
    ext=.dist
    echo "  **"
    echo "  ** You already have a configuration file at $CONFIG_FILE"
    echo "  ** The new version will be installed to ${CONFIG_FILE}${ext}"
    echo "  **"
    EXISTING_CONFIG=1
else
    ext=
fi
cp -a conf/hibernate.conf ${CONFIG_FILE}${ext}
cp -a conf/ram.conf ${RAM_CONFIG_FILE}${ext}
cp -a conf/disk.conf ${DISK_CONFIG_FILE}${ext}
cp -a conf/tuxonice.conf ${S2_CONFIG_FILE}${ext}
cp -a conf/ususpend-ram.conf ${US_RAM_CONFIG_FILE}${ext}
cp -a conf/ususpend-disk.conf ${US_DISK_CONFIG_FILE}${ext}
cp -a conf/ususpend-both.conf ${US_BOTH_CONFIG_FILE}${ext}
cp -a conf/sysfs-ram.conf ${SYSFS_RAM_CONFIG_FILE}${ext}
cp -a conf/sysfs-disk.conf ${SYSFS_DISK_CONFIG_FILE}${ext}
cp -a conf/common.conf ${COMMON_CONFIG_FILE}${ext}

if [ -n "$DISTRIBUTION" ] ; then
    sed -i -e "s/^# \\(Distribution\\) .*/\1 $DISTRIBUTION/" ${COMMON_CONFIG_FILE}${ext}
fi

cp -a blacklisted-modules $BLACKLIST

# Test if they have anything in there, and warn them
if /bin/ls $OLD_SCRIPTLET_DIR/* > /dev/null 2>&1 ; then
    echo "  **"
    echo "  ** You have scriptlets already installed in $OLD_SCRIPTLET_DIR"
    echo "  ** Since version 0.95, these have moved to $SCRIPTLET_DIR."
    echo "  ** If you are upgrading from a version prior to 0.95, you will"
    echo "  ** need to empty the contents of $OLD_SCRIPTLET_DIR manually!"
    echo "  **"
fi

echo "Installing scriptlets to $SCRIPTLET_DIR ..."
mkdir -p $SCRIPTLET_DIR
for i in scriptlets.d/* ; do
    cp -a $i $SCRIPTLET_DIR
done

if [ -d "$LOGROTATE_DIR" ] ; then
    LOGROTATE_TARGET=$LOGROTATE_DIR/hibernate-script
    echo "Installing logrotate file for hibernate.log to $LOGROTATE_TARGET ..."
    cp -a logrotate.d-hibernate-script $LOGROTATE_TARGET
    [ `whoami` = "root" ] && chown root:root $LOGROTATE_TARGET && chmod 644 $LOGROTATE_TARGET
fi

echo "Installing man pages to $MAN_DIR ..."
mkdir -p $MAN_DIR/man5 $MAN_DIR/man8
bash gen-manpages.sh
cp hibernate.conf.5 $MAN_DIR/man5
cp hibernate.8 $MAN_DIR/man8
rm -f hibernate.conf.5 hibernate.8

chmod 644 $MAN_DIR/man5/hibernate.conf.5 $MAN_DIR/man8/hibernate.8
[ `whoami` = "root" ] && chown root:root $MAN_DIR/man5/hibernate.conf.5 $MAN_DIR/man8/hibernate.8

echo "Setting permissions on installed files ..."
chmod 755 $SCRIPT_DEST $CONFIG_DIR
[ `whoami` = "root" ] && chown root:root -R $SCRIPT_DEST $CONFIG_DIR

echo "Installed."
echo
if [ -z "$EXISTING_CONFIG" ] ; then
    echo "Edit $CONFIG_FILE to taste, and see `basename $SCRIPT_DEST` -h for help."
else
    echo "You may want to merge $CONFIG_FILE with"
    echo "$CONFIG_FILE.dist"
    echo "See `basename $SCRIPT_DEST` -h for help on any extra options."
fi



)

[ $? -ne 0 ] && echo "Install aborted due to errors."

exit 0

# $Id$
