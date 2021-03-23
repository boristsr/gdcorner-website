find . | grep '\.png\b' | parallel build/png-zopflipng.sh
