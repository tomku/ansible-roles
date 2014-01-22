ansible-reload() {
    ansible-playbook /vagrant/ansible/$1.yml -c local -i "127.0.0.1," $2 $3 $4 $5 $6
}

ansible-setup() {
    ansible all -c local -i "127.0.0.1," -m setup
}
