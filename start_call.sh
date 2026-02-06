#!/usr/bin/env bash
#################################
###### AUTHOR : Fouad Yasser #####
#################################

#==================================
############ function ##############
#==================================
log()  { echo -e "\e[32m[INFO]\e[0m $1"; }
warn() { echo -e "\e[33m[WARN]\e[0m $1"; }
err()  { echo -e "\e[31m[ERROR]\e[0m $1"; exit 1 ; }
#==================================

from_msisdn="$1"
to_msisdn="$2"
imei="$3"
ki="$4"
#============================
######## file validation #####
#============================

[[ -f vlr ]] || err "vlr file not found!"
[[ -f eir ]] || err "eir file not found!"
[[ -f hlr ]] || err "hlr file not found!"
[[ -f auc ]] || err "auc file not found!"

#=============================
####### mobile number val ####
#=============================

mobileCheck () {
  local num="$1"
  case "$num" in 
    010????????) log "that is Vodafone num" ;;
    011????????) log "that is Etesalate num"  ;;
    012????????) log "that is Orange num"  ;;
    *) err "Can't handle this mobile number format: $num" ;;
  esac
}

#=============================
####### imei validation #####
#=============================
imeiCheck() {
  local imei="$1"
  if [[ "$imei" =~ ^[0-9]{15}$ ]]; then
    log "IMEI is valid"
  else
    err "IMEI is invalid"
  fi
}

# Call validations first
echo "============= from ============="
mobileCheck "$from_msisdn"
echo "============== to ============="
mobileCheck "$to_msisdn"
echo "= imei check for the originated mobile ="
imeiCheck "$imei"

#=============================
####### EIR validation  #####
#=============================
eir_result=$(awk -F',' -v imei="$imei" 'NR > 1 && $1 == imei { print $2 }' eir)

case "$eir_result" in
  "WHITE") log "Congrats, you can make a call now." ;;
  "BLACK") err "You are barred from the network." ;;
  "GREY")  warn "You need some updates..." ;;
  *)       warn "Unknown EIR status: $eir_result" ;;
esac

#=============================
####### Authentication  #####
#=============================

imsi=$(awk -F',' -v var="$from_msisdn" 'NR>1 && $2 == var { print $1 }' vlr)

kn=$(awk -F',' -v var="$imsi" 'NR>1 && $1 == var { print $2 }' auc)

if [[ "$kn" == "$ki" ]]; then
  log "Authentication success :)"
else
  err "You are not authorized to connect to our network."
fi

#==================================
####### Status of receiver  #####
#==================================

r_status=$(awk -F',' -v var="$to_msisdn" 'NR > 1 && $2 == var { print $4 }' vlr)

if [[ "$r_status" != "IDLE" ]]; then
  warn "The requested number is unreachable or unavailable :("
else
  log "You are now in the call, smile :)"
fi
