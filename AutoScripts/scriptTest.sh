#!/bin/bash

## Shortcuts:
##	- Command: Ctrl + K
##	- Uncommand: Ctrl + Shift + K

## Run automation:
while [[ $# -gt 0 ]]; do
	if [[ -f "$1" ]]; then
		if [[ -f "$2" ]] && [[ "$2" == *.txt || "$2" == *.ncf ]]; then
			./$1 $2 &
			if [[ -f "$3" ]]; then
				python $3
			fi
		elif [[ -d "$2" ]]; then
			for file in "$2"/*;
			do
				if [[ $file == *.txt || $file == *.ncf ]]; then
					./$1 $file &
				else
					continue
				fi
			done
		else
			./$1 &
		fi
		break
	else
		echo "ERROR: $1 not found at $(pwd)"
		exit 1
	fi
done

## Check empty of commits list in a branch
# if [[ -n $(git log origin/master..GUI-2557) ]]; then
	# echo "Not empty"
	# read -p "Do you want to remove all internal commits on this branch? (y/n) " confirm
	# if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
		# echo "User press $confirm"
	# else 
		# echo "User press $confirm"
	# fi
# else
	# echo "Empty"
# fi

## Get option
# while [[ $# -gt 0 ]]; do
	# case "$1" in
		# -u)
			# echo "Option: $1 --- Arguments: $2"
			# break
		# ;;
		# -r)
			# echo "Option: $1 --- Arguments: $2"
			# break
		# ;;
		# --r)
			# echo "Option: $1 --- Arguments: $2"
			# break
		# ;;
		# -rs)
			# echo "Option: $1 --- Arguments: $2"
			# break
		# ;;
	# esac
# done

# for branch in $(git branch | sed 's/^..//' | grep -v master);
	# do
	# ## List Branches in local (Excepted: master)
	# echo "Existing branch $branch"
	# echo "--------------------------------"
	
	# ## List Untracking folders
	# # echo "untracking folders: $(pwd)."
	# # for folder in $(ls -d  */ 2>/dev/null | sed 's|/$||');
	# # do
		# # if [[ ! "$(git ls-tree -d --name-only head)" =~ "$folder" ]]; then
			# # if [[ "$folder" != "nocstudio-helptext" && "$folder" != "tutorials" && "$folder" != "debug" && "$folder" != "release" && "$folder" != "x64" ]]; then
				# # echo "$folder."
				# # echo "------------------------------------------------------------"
			# # fi
		# # fi
	# # done

	# ## Check internal commit on branchs
	# # echo "Processing on $branch"
	# # git log origin/master..$branch
	# # echo "--------------------------------"
# done
# git checkout master;