arr=($( cat /etc/passwd | cut -d: -f1 ))

vars=(${arr[@]})
len=${#arr[@]}

printf "{\n"
printf "\t"'"SchemaVersion"'":\"1.0\",\n"
printf "\t"'"TypeName"'":\"Custom:LocalAccounts\",\n"
printf "\t"'"Content"'": [\n"
for (( i=0; i<len; i+=1 ))
do
printf "\t\t{  "'"User'$i"\":\"${vars[i]}\" }"
if [ $i -lt $((len-1)) ] ; then
    printf ",\n"
fi
done
printf "\n\t]\n"
printf "}\n"
echo