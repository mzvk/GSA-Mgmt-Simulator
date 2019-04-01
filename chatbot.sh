#!/usr/bin/bash
VERSION="0.4.10b ryz_cookie 03/10/2017"

function fromfile {
  local array
  if [[ -r $1 ]]; then
    while read -r line; do
      array=(${line})
      case $2 in
        WIARA)
          WIARA[${array[0]}]=${array[1]/_/ }
          ;;
        BOTS)
          BOTS[${array[0]}]=${array[1]/_/ }
          ;;
        *)
          ;;
        esac
    done < "$1"
  fi
}

declare -A BOTS
declare -A WIARA

fromfile "/tftpboot/chatbot/chatbot.users" "WIARA"
fromfile "/tftpboot/chatbot/chatbot.bots" "BOTS"

if [[ ${WIARA[`whoami`]} ]]; then
  USER=${WIARA[`whoami`]}
else
  USER=`whoami`
fi

while (( $# )); do
  case $1 in
    -b|--bot)
      BOTID=$2
      BOTNAME=${BOTS[$2]} && shift
      ;;
    -v|--version)
      echo -e " .Current version: \e[31m$VERSION\e[0m\n .Designed by life" && exit 1
      ;;
    -?)
      cat << UsageMsg
Usage: <scriptname> [OPTIONS]
 +Options:
  -b|--boot:    defines bot name (must be present in chatbot.bots file)
  -v|--version: prints current script version and build name
  -?:           prints this message
 +Files:
  - chatbot       : [bash script] core file of chatbot
  - chatbot.yml   : [yaml file]   per bot texts
  - chatbot.users : [data file]   user mapping
  - chatbot.bots  : [data file]   bot names
  - data.pl       : [perl script] YAML translator
UsageMsg
      exit 1
      ;;
    *)
      echo -e "\e[31mInvalid option $1\e[0m - Use -? for help"
      ;;
  esac
  shift
done

BOTNAME=${BOTNAME:-"Master Bot"}
BOTID=${BOTID:-"mbot"}

read -p "Type a message: " userin
echo -e "-----------\n $USER `date "+%H:%M"`\n $userin"
echo -e "\n $BOTNAME is typing a message..."
sleep 1
echo -e "\e[1A $BOTNAME `date "+%H:%M"`                                               \n `perl $PWD/data.pl $PWD/chatbot.yml $BOTID | tail -n 1`"
sleep 1
echo -e "\nThis conversation is saved in the Conversations tab in Lync and in the Conversation History folder in Outlook."
while true
do
  read -p "Type a message: " userin
  if [[ -z $userin ]]; then
    exit 1
  fi
  echo -e "-----------\n $USER `date "+%H:%M"`                          \n \e[31mx\e[0m $userin\n"
  echo -e " >> This message was not delivered to $BOTNAME because this person does not want to be disturbed.\n     \e[31m$userin\e[0m"
done

