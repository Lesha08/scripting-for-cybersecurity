#!/bin/bash

# attacker_report.sh

# 1–2. Check argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <logfile>" >&2
    exit 1
fi

logfile="$1"

# 3. Check file exists
if [ ! -f "$logfile" ]; then
    echo "Error: file does not exist: $logfile" >&2
    exit 2
fi

# 4. Total failed password events
failed_count=$(grep -c "Failed password" "$logfile")

echo "Total failed password events: $failed_count"

# 5. IP responsible for most failed attempts
top_ip=$(awk '
/Failed password/ {
    for (i = 1; i <= NF; i++) {
        if ($i == "from" && (i + 1) <= NF) {
            count[$(i+1)]++
        }
    }
}
END {
    max = 0
    ip = ""
    for (addr in count) {
        if (count[addr] > max) {
            max = count[addr]
            ip = addr
        }
    }
    if (ip != "")
        print ip
}
' "$logfile")

echo "IP responsible for most failed attempts: ${top_ip:-None}"

# 6. Three busiest source IPs, using top3.sh
echo "Three busiest source IPs:"
./top3.sh "$logfile"

# 7. Three most-targeted usernames
echo "Three most-targeted usernames:"

awk '
/Failed password/ {
    user = ""

    for (i = 1; i <= NF; i++) {
        if ($i == "for") {
            if ($(i+1) == "invalid" && $(i+2) == "user")
                user = $(i+3)
            else
                user = $(i+1)
            break
        }
    }

    if (user != "")
        count[user]++
}
END {
    for (user in count)
        print count[user], user
}
' "$logfile" |
sort -nr |
head -3

# 8. Success
exit 0

