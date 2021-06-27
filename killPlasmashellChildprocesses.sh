plasmashellPID=$(ps h -opid -C plasmashell)

# get all childprocess pids
#cpids=$(pgrep -P $plasmashellPID)

# for cpid in $cpids;
# do
#     echo "killing childprocess"
#     echo "$cpid"
#     
#     sudo kill -9 $cpid
# done


pkill -P $plasmashellPID
