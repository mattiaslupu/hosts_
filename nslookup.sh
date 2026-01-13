#!/bin/bash

while read -r line; do
    for word in $line; do
        if [[ "$word" == \#* ]]; then
            exit 0
        fi

        if [[ "$word" =~ ^[0-9] ]]; then
            ip=$word
        else
            dns_ip=$(nslookup -query=A $word 1.1.1.1 | grep "Address:" | tail -n 1 | awk '{print $2}')
            if [[ -z "$dns_ip" ]]; then continue; fi

            if [[ "$dns_ip" != "$ip" ]]; then
                echo "Bogus IP for $word in /etc/hosts!"
            fi
        fi
    done
done < /etc/hosts
