## OS
alias ls='ls --color=never'
alias egrep='egrep --color=never'
alias fgrep='fgrep --color=never'
alias grep='grep --color=never'
alias python='python3'
alias temp="watch -- 'vcgencmd measure_temp'"
alias du="du -hd 1"

## Docker
alias dockerps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Command}}\t{{.Image}}\t{{.Ports}}\t{{.ID}}'"
alias dockerkill='docker kill $(docker ps -q)'
alias dockerrm='docker rm $(docker ps -aq --filter "status=exited")'
alias dockerstats="docker stats \$(docker ps | awk '{if(NR>1) print \$NF}')"
alias dockerstop="docker-compose -f compose.yml down --remove-orphans"
alias dockerrmlogs="sudo find /var/lib/docker/containers/ -type f -name “*.log” -delete && docker-compose down && docker-compose up -d"
alias dockerprune="docker system prune --all --volumes --force"

## Directories
alias syslog='cd /var/log'
