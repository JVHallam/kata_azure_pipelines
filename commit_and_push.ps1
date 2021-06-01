git pull;
git add .;
git commit -m "Updated pipelines";
git push;
echo "Commit : $(git rev-parse head)";                                                                                                                                       
for($i = 0; $i -lt 7; $i += 1){
    echo "waiting : $i / 6";
    sleep 1 
}
