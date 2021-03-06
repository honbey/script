#!/usr/bin/env bash
# Program to output a system information page

TITLE="System Information Report"
CURRENT_TIME=$(date +"%x %r %Z")
TIME_STAMP="Generated $CURRENT_TIME, by $USER"

report_uptime () {
    #echo "Function report_uptime excuted."
    cat <<- _EOF_
        <H2>System Uptime</H2>
        <PRE>$(uptime)</PRE>
_EOF_
    return
}
report_disk_space () {
    #echo "Function report_disk_space excuted."
    cat <<- _EOF_
        <H2>Disk Space Utilization</H2>
        <PRE>$(df -h)</PRE>
_EOF_
    return
}
report_home_space () {
    #echo "Function report_home_space excuted."
    if [[ $(id -u) -eq 0 ]]; then
        cat <<- _EOF_
        <H2>Home Space Utilization (All Users)</H2
        <PRE>$(du -sh /home/*)</PRE>
_EOF_
    else
        cat <<- _EOF_
        <H2>Home Space Utilization ($USER)</H2
        <PRE>$(du -sh $HOME)</PRE>
_EOF_
    fi
    return
}

# echo "string..."
cat <<- _EOF_
<HTML>
    <HEAD>
        <TITLE>$TITLE</TITLE>
    </HEAD>
    <BODY>
        <H1>$TITLE</H1>
        <P>$TIME_STAMP</P>
        $(report_uptime)
        $(report_disk_space)
        $(report_home_space)
    </BODY>
</HTML>
_EOF_
