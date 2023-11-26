#!/bin/sh
cd ../site/public || exit 1
aws s3 sync . s3://jeselnikdotxyz
