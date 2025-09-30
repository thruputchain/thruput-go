cat > hog.conf <<EOF
loadgen_server="hog2"
chuckd_server="hog2"
hogexec_servers=("hog4")
hogdb_servers=("hog4")
EOF
# Substitute appropriate hog machines above

# Now launch system
export X23SERVER_TRACE_hogexec=,/tmp/$(whoami)/hogexec.log
scripts/launch-multi.sh
