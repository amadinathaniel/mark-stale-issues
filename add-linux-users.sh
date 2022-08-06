#!/bin/bash

# Make sure the script is being executed with superuser privileges.
if [[ "$(id -u)" -ne 0 ]]
then
	echo "Please run with sudo or as root."
	exit 1
fi

# Get the username (login).
read -p "Enter the username to create: " USERNAME

# Get the real name (contents for the description field).
read -p "Enter the name of the person or application that will be using this
account: " COMMENT

# Get the password.
read -p "Enter the password to use for the account: " PASSWORD

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USERNAME} -s /bin/bash

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo "User ${USERNAME} NOT created."
	exit 1
fi

# Set the password.
# echo ${PASSWORD} | passwd --stdin ${USERNAME} # Not for Ubuntu
# echo -e "${PASSWORD}\n${PASSWORD}" | passwd "${USERNAME}"
echo "${USERNAME}:{PASSWORD}" | sudo chpasswd

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo "Password for user ${USERNAME} NOT set successfully"
	exit 1
fi

# Force password change on first login.
passwd -e ${USERNAME}

# Display the username, password, and the host where the user was created.
cat << EOF
username:
${USERNAME}

password:
${PASSWORD}

host:
${HOSTNAME}
EOF

exit 0
