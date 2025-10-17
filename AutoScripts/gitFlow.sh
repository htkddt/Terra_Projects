#!/bin/bash

line="+-----------------------+-----------------------------------------------------------------------------+-----------------------------------------------------------------------+"

usage() {
	echo "	$line"
	echo "	|                                                                                                                                                                             |"
	echo "	|                                                      SYNTAX: bash gitFlow.sh [arg1] [arg2] <value1> <value2>                                                                |"
	echo "	|                                                                                                                                                                             |"
	echo "	$line"
	echo "	|       Reference       |                                  Command                                    |                              Description                              |"
	echo "	$line"                                                                                                
	echo "	|  Help                 |  [-h | --help]                                                              |  Display help information about commands of script                    |"
	echo "	$line"                                                                                                                                                                        
	echo "	|  Commit               |  [-c] HEAD                                                                  |  Empty                                                                |"
	echo "	|                       |  [--commit]                                                                 |  Empty                                                                |"
	echo "	$line"                                                                                                                                                                        
	echo "	|  Tagging              |  [-t | --tag] <tag_name>                                                    |  Empty                                                                |"
	echo "	|                       |  [-t | --tag] <tag_name> <commit_id>                                        |  Empty                                                                |"
	echo "	$line"                                                                                                                                                                        
	echo "	|  Stash                |  [-s | --stash] [-l]                                                        |  Empty                                                                |"
	echo "	|                       |  [-s | --stash] [-u] <message>                                              |  Empty                                                                |"
	echo "	|                       |  [-s | --stash] [-o] <stash_id>                                             |  Empty                                                                |"
	echo "	|                       |  [-s | --stash] [-a] <stash_id>                                             |  Empty                                                                |"
	echo "	|                       |  [-s | --stash] [-d] <stash_id>                                             |  Empty                                                                |"
	echo "	$line"                                                                                                                                                                        
	echo "	|  History              |  [-l | --log]                                                               |  Empty                                                                |"
	echo "	|                       |  [-l | --log] <branch_name>                                                 |  Empty                                                                |"
	echo "	|                       |  [-l | --log] <branch_name> <branch_name>                                   |  Empty                                                                |"
	echo "	|                       |-----------------------------------------------------------------------------|-----------------------------------------------------------------------|"
	echo "	|                       |  [-d | --diff]                                                              |  Empty                                                                |"
	echo "	|                       |  [-d | --diff] <branch_name>                                                |  Empty                                                                |"
	echo "	|                       |  [-d | --diff] <branch_name> <branch_name>                                  |  Empty                                                                |"
	echo "	|                       |  [-d | --diff] [-s | --save] <path_file>                                    |  Empty                                                                |"
	echo "	|                       |  [-d | --diff] [-s | --save] <branch_name> <path_file>                      |  Empty                                                                |"
	echo "	|                       |  [-d | --diff] [-s | --save] <branch_name> <branch_name> <path_file>        |  Empty                                                                |"
	echo "	$line"                                                                                                                                                                        
	echo "	|  Branch               |  [-b | --branch]                                                            |  Empty                                                                |"
	echo "	|                       |  [-b | --branch] [-l]                                                       |  Empty                                                                |"
	echo "	|                       |  [-b | --branch] [-t]                                                       |  Empty                                                                |"
	echo "	|                       |  [-b | --branch] [-co] <branch_name>                                        |  Empty                                                                |"
	echo "	|                       |  [-b | --branch] [-cob] <branch_name>                                       |  Empty                                                                |"
	echo "	|                       |  [-b | --branch] [-d] <branch_name>                                         |  Empty                                                                |"
	echo "	$line"                                                                                                                                                                        
	echo "	|  Rebase               |  [-r | --rebase] [-a | --all]                                               |  Empty                                                                |"
	echo "	|                       |  [-r | --rebase] [-o | --only]                                              |  Empty                                                                |"
	echo "	$line"                                                                                                                                                                        
	echo "	|  Reset                |  [-r | --reset] [-s | --soft]                                               |  Empty                                                                |"
	echo "	|                       |  [-r | --reset] [-h | --hard]                                               |  Empty                                                                |"
	echo "	$line"                                                                                                                                                                        
	echo "	|  Clean                |  [-c | --clean]                                                             |  Empty                                                                |"
	echo "	|                       |  [-c | --clean] [-fdn]                                                      |  Empty                                                                |"
	echo "	|                       |  [-c | --clean] [-fd]                                                       |  Empty                                                                |"
	echo "	|                       |  [-c | --clean] [-fdx]                                                      |  Empty                                                                |"
	echo "	$line"
	exit 1
}

remove() {
	echo "$(pwd)"
	for folder in $(ls -d  */ 2>/dev/null | sed 's|/$||');
	do
		if [[ ! "$(git ls-tree -d --name-only HEAD)" =~ "$folder" ]]; then
			if [[ "$folder" != "tutorials" && "$folder" != "Debug" && "$folder" != "Release" && "$folder" != "x64" ]]; then
				echo "Processing remove folder $folder."
				rm -rf "$folder"
			fi
		fi
	done
	echo "Successfully removed and cleaned $(pwd)."
	echo "--------------------------------------------------------------------------------------------------------------------------"
}

get_stash_id() {
    branch_name="$1"
    git stash list | grep "On $branch_name" | awk -F: '{print $1}'
}


if [[ $# -eq 0 ]]; then
	usage
	exit 1
fi

while [[ $# -gt 0 ]]; do
	case "$1" in
## ------------------------------------------------Help------------------------------------------------------------
		-h|--help)
			usage
			break
		;;
## ----------------------------------------------------------------------------------------------------------------
## -------------------------------------------Clean | Commit-------------------------------------------------------
		-c)
			if [[ -n "$2" ]]; then
				case "$2" in
					-fd)
						git clean -fd
						break
					;;
					-fdx)
						git clean -fdx
						break
					;;
					-fdn)
						git clean -fdn
						break
					;;
					HEAD)
						git status -uno
						git ls-files -m -d | xargs git add
						git status -uno
						read -p "Do you want commit? (y/n) " commit
						if [[ "$commit" == "y" || "$commit" == "Y" ]]; then
							read -p "<message>? " message
							git commit -m "$message"
							read -p "Do you create a lightweight tag for this commit? (y/n) " tag
							if [[ "$tag" == "y" || "$tag" == "Y" ]]; then
								read -p "<tag_name>? " name
								git tag $name
							fi
						else
							git restore --staged .
						fi
						break
					;;
				esac
			else
				echo "Running remove function ..."
				remove
				if [[ ! -d "prototype" ]]; then
					echo "Dicectory prototype not found."
					exit 1
				else
					cd prototype
					remove
				fi
				cd ../
				if [[ ! -d "prototype_qt6" ]]; then
					echo "Dicectory prototype_qt6 not found."
					exit 1
				else
					cd prototype_qt6
					remove
				fi
				cd ../
				if [[ ! -d "IPStudio_qt6" ]]; then
					echo "Dicectory IPStudio_qt6 not found."
					exit 1
				else
					cd IPStudio_qt6
					remove
				fi
				cd ../
				echo "Current local path: $(pwd)"
			fi
			break
		;;
		--clean)
			if [[ -n "$2" ]]; then
				case "$2" in
					-fd)
						git clean -fd
						break
					;;
					-fdx)
						git clean -fdx
						break
					;;
					-fdn)
						git clean -fdn
						break
					;;
				esac
			else
				echo "Running remove function ..."
				remove
				if [[ ! -d "prototype" ]]; then
					echo "Dicectory prototype not found."
					exit 1
				else
					cd prototype
					remove
				fi
				cd ../
				if [[ ! -d "prototype_qt6" ]]; then
					echo "Dicectory prototype_qt6 not found."
					exit 1
				else
					cd prototype_qt6
					remove
				fi
				cd ../
				if [[ ! -d "IPStudio_qt6" ]]; then
					echo "Dicectory IPStudio_qt6 not found."
					exit 1
				else
					cd IPStudio_qt6
					remove
				fi
				cd ../
				echo "Current local path: $(pwd)"
			fi
			break
		;;
		--commit)
			git status -uno
			git ls-files -m -d | xargs git add
			git status -uno
			read -p "Do you want commit? (y/n) " commit
			if [[ "$commit" == "y" || "$commit" == "Y" ]]; then
				read -p "<message>? " message
				git commit -m "$message"
				read -p "Do you create a lightweight tag for this commit? (y/n) " tag
				if [[ "$tag" == "y" || "$tag" == "Y" ]]; then
					read -p "<tag_name>? " name
					git tag $name
				fi
			else
				git restore --staged .
			fi
			break
		;;
## ----------------------------------------------------------------------------------------------------------------
## ---------------------------------------------------Tag----------------------------------------------------------
		-t|--tag)
			if [[ -n "$2" ]]; then
				if [[ -n "$3" ]]; then
					git tag $2 $3
				else
					git tag $2 HEAD
				fi
			else
				echo "ERROR: Command is not found"
				usage
				exit 1
			fi
			break
		;;
## ----------------------------------------------------------------------------------------------------------------
## --------------------------------------------------Stash---------------------------------------------------------
		-s|--stash)
			if [[ -n "$2" ]]; then
				case "$2" in
					-l)
						git stash list
						break
					;;
					-u)
						if [[ -n "$3" ]]; then
							week_number=$(date +%V)
							message="[W${week_number}] $3"
							git stash push -m "$message"
							git checkout master
						else 
							echo "ERROR: You must type <message>"
							usage
							exit 1
						fi
						break
					;;
					-o)
						if [[ -n "$3" ]]; then
							stash_id=$(get_stash_id "$3")
							echo "Stash ID of $3: $stash_id"
							if ! git checkout $(git stash list --format='%gd - %gs' | grep "^$stash_id" | awk -F': ' '{print $1}' | sed 's/.*On //'); then
								echo "$(git stash list --format='%gd - %gs' | grep "^stash@{"$3"}" | awk -F': ' '{print $1}' | sed 's/.*On //') does not exist."
								git checkout -b $(git stash list --format='%gd - %gs' | grep "^$stash_id" | awk -F': ' '{print $1}' | sed 's/.*On //')
							fi
							git stash pop $stash_id
						else 
							echo "ERROR: You must type <stash_name>"
							usage
							exit 1
						fi
						break
					;;
					-a)
						if [[ -n "$3" ]]; then
							stash_id=$(get_stash_id "$3")
							echo "Stash ID of $3: $stash_id"
							if ! git checkout $(git stash list --format='%gd - %gs' | grep "^$stash_id" | awk -F': ' '{print $1}' | sed 's/.*On //'); then
								echo "$(git stash list --format='%gd - %gs' | grep "^stash@{"$3"}" | awk -F': ' '{print $1}' | sed 's/.*On //') does not exist."
								git checkout -b $(git stash list --format='%gd - %gs' | grep "^$stash_id" | awk -F': ' '{print $1}' | sed 's/.*On //')
							fi
							git stash apply $stash_id
						else 
							echo "ERROR: You must type <stash_name>"
							usage
							exit 1
						fi
						break
					;;
					-d)
						if [[ -n "$3" ]]; then
							stash_id=$(get_stash_id "$3")
							echo "Stash ID of $3: $stash_id"
							git stash drop $stash_id
						else 
							echo "ERROR: You must type <stash_name>"
							usage
							exit 1
						fi
						break
					;;
					-t)
						count=$(git stash list | wc -l)
						echo "Total local stash in stash list: $count"
						break
					;;
				esac
			else
				git stash list
				break
			fi
			break
		;;
## ----------------------------------------------------------------------------------------------------------------
## ------------------------------------------------History---------------------------------------------------------
		-l|--log)
			if [[ -n "$2" ]]; then
				if [[ -n "$3" ]]; then
					git log $2...$3
				else
					git log origin/master..$2
				fi
			else
				git log
			fi
			break
		;;
		-d|--diff)
			if [[ -n "$2" ]]; then
				case "$2" in
					-s|--save)
						if [[ -n "$3" ]]; then
							if [[ -n "$4" ]]; then
								if [[ -n "$5" ]]; then
									git diff $3..$4 > $5
								else 
									git diff master..$3 > $4
								fi
							else
								git diff > $3
							fi
							break
						else
							echo "ERROR: You must type <path_file>"
							usage
							exit 1
						fi
					;;
					*)
						if [[ -n "$3" ]]; then
							git diff $2..$3
						else
							git diff master..$2
						fi
						break
					;;
				esac
			else
				git diff
			fi
			break
		;;
## ----------------------------------------------------------------------------------------------------------------
## ------------------------------------------------Branch----------------------------------------------------------
		-b|--branch)
			if [[ -n "$2" ]]; then
				case "$2" in
					-l)
						git branch
						break
					;;
					-t)
						count=$(git branch | grep -v "master" | wc -l)
						echo "Total local branch (Excepted: master branch): $count"
						break
					;;
					-co)
						if [[ -n "$3" ]]; then
							git checkout $3
						else
							echo "ERROR: You must type <branch_name>"
							usage
							exit 1
						fi
						break
					;;
					-cob)
						if [[ -n "$3" ]]; then
							git checkout -b $3
						else
							echo "ERROR: You must type <branch_name>"
							usage
							exit 1
						fi
						break;
					;;
					-d)
						if [[ -n "$3" ]]; then
							git branch -D $3
						else
							echo "ERROR: You must type <branch_name>"
							usage
							exit 1
						fi
						break
					;;
				esac
			else 
				git branch
				break
			fi
			break
		;;
## ----------------------------------------------------------------------------------------------------------------
## ----------------------------------------Rebase | Revert | Reset-------------------------------------------------
		-r)
			if [[ -n "$2" ]]; then
				case "$2" in
					-s|--soft)
						git reset --soft origin/master
						break
					;;
					-h|--hard)
						git reset --hard origin/master
						break
					;;
					-a|--all)
						for branch in $(git branch | sed 's/^..//' | grep -v master);
						do
							echo "Rebasing $branch onto master...";
							git checkout $branch;
							if [[ -n $(git log origin/master..$branch) ]]; then
								echo "WARNING: Existing internal commits on $branch..."
								read -p "Do you want to remove all internal commits on $branch? (y/n) " confirm
								if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
									git reset --hard origin/master
								fi
							fi
							if ! git rebase master; then
								echo "ERROR: CONFLICT detected in $branch! Aborting rebase..."
								git rebase --abort
								continue
							fi
							echo "------------------------------------------------------------"
						done
						git checkout master;
						break
					;;
					-o|--only)
						if [[ -n "$3" ]]; then
							if [[ -n $(git log $3..HEAD) ]]; then
								echo "WARNING: Existing internal commits on this branch..."
								read -p "Do you want to remove all internal commits on $branch? (y/n) " confirm
								if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
									git reset --hard origin/master
								else
									exit 1
								fi
							fi
							git rebase $3
						else
							echo "ERROR: You must type <branch_name>"
							usage
							exit 1
						fi
						break
					;;
					*)
						git revert $2
						break
					;;
				esac
			else
				echo "ERROR: Command not found"
				usage
				exit 1
			fi
			break
		;;
		--rebase)
			if [[ -n "$2" ]]; then
				case "$2" in
					-a|--all)
						for branch in $(git branch | sed 's/^..//' | grep -v master);
						do 
							echo "Rebasing $branch onto master...";
							git checkout $branch;
							if [[ -n $(git log origin/master..$branch) ]]; then
								echo "WARNING: Existing internal commits on $branch..."
								read -p "Do you want to remove all internal commits on $branch? (y/n) " confirm
								if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
									git reset --hard origin/master
								else
									echo "------------------------------------------------------------"
									continue
								fi
							fi
							if ! git rebase master; then
								echo "ERROR: CONFLICT detected in $branch! Aborting rebase..."
								git rebase --abort
							fi
							echo "------------------------------------------------------------"
						done
						git checkout master;
						break
					;;
					-o|--only)
						if [[ -n "$3" ]]; then
							if [[ -n $(git log $3..HEAD) ]]; then
								echo "WARNING: Existing internal commits on this branch..."
								read -p "Do you want to remove all internal commits on $branch? (y/n) " confirm
								if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
									git reset --hard origin/master
								else
									exit 1
								fi
							fi
							git rebase $3
						else
							echo "ERROR: You must type <branch_name>"
							usage
							exit 1
						fi
						break
					;;
				esac
			else
				echo "ERROR: Command not found"
				usage
				exit 1
			fi
			break
		;;
		--reset)
			if [[ -n "$2" ]]; then
				case "$2" in
					-s|--soft)
						git reset --soft origin/master
						break
					;;
					-h|--hard)
						git reset --hard origin/master
						break
					;;
				esac
			else
				echo "ERROR: Command not found"
				usage
				exit 1
			fi
			break
		;;
		--revert)
			if [[ -n "$2" ]]; then
				git revert $2
				break
			else
				echo "ERROR: Command not found"
				usage
				exit 1
			fi
			break
		;;
## ----------------------------------------------------------------------------------------------------------------
	esac
done