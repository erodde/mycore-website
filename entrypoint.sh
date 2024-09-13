#!/bin/bash

# Test if the necessary volume was mounted
if [ ! -d /public ]; then
    echo "Volume /public does not exist. Add a volume using -v <volume name>:/public"
    exit
fi

echo "Using repo:  '$1'"
echo "Website url: '$2'"

# Clone the git project
git clone $1 /site

# Set the working directory to the cloned project
cd /site

# Build the project
yarn build

# Run Hugo inside the mycore.org/ subfolder
cd /site/mycore.org
hugo -b $2 --cleanDestinationDir

# Copy built dir with volume
cp -R /site/mycore.org/public/* /public
