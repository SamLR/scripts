function suspend_cronjobs() {
  if [ ! -z $1 ]; then
    kubectl get cronjob | grep $1 | awk '{print $1;}' | xargs -L 1 -n 1 -I JOB_NAME kubectl patch cronjob JOB_NAME -p '{"spec": {"suspend": true}}'
  fi
}
function enable_cronjobs() {
  if [ ! -z $1 ]; then
    kubectl get cronjob | grep $1 | awk '{print $1;}' | xargs -L 1 -n 1 -I JOB_NAME kubectl patch cronjob JOB_NAME -p '{"spec": {"suspend": false}}'
  fi
}
