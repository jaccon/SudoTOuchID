#!/bin/bash

echo "Hi, please input your password here to enable the magic"

touchid_sudo(){
  sudo bash -eu <<'EOF'
  file=/etc/pam.d/sudo
  # A backup file will be created with the pattern /etc/pam.d/.sudo.1
  # (where 1 is the number of backups, so that rerunning this doesn't make you lose your original)
  bak=$(dirname $file)/.$(basename $file).$(echo $(ls $(dirname $file)/{,.}$(basename $file)* | wc -l))
  cp $file $bak

  awk -v is_done='pam_tid' -v rule='auth       sufficient     pam_tid.so' '
  {
    # $1 is the first field
    # !~ means "does not match pattern"
    if($1 !~ /^#.*/){
      line_number_not_counting_comments++
    }
    # $0 is the whole line
    if(line_number_not_counting_comments==1 && $0 !~ is_done){
      print rule
    }
    print
  }' > $file < $bak
EOF
}

touchid_sudo
