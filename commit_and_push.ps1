git add *.yml;
git add .\docs\kata_spoilers.md;
git commit -m "Updated pipelines";
git push;
echo "Commit : $(git rev-parse head)";                                                                                                                                       
