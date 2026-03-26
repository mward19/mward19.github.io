cd matthew/ 
if [[ $1 == "-r" ]]; then
    rm -rf _site
fi
make 
cd _site
python -m http.server 8000
cd ../..