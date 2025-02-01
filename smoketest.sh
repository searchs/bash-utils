#!/usr/bin/env sh

if curl -s --head "https://www.ohprice.com"
then
    echo "web app is alive"
else
    echo "web app deployment failed"
fi
