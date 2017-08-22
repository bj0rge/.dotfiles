git fetch
for remote in `git branch -r `; do echo $remote | cut -d/ -f2- | xargs git checkout && git merge; done
git checkout master
git branch --merged master | grep -v master | grep -v production | grep -v staging | grep -v design | xargs -n 1 git push --delete origin
git branch --merged master | grep -v master | grep -v production | grep -v staging | grep -v design | xargs -n 1 git branch -d
git remote prune origin
