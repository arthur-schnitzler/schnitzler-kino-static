rm -rf data
wget https://github.com/arthur-schnitzler/schnitzler-kino-data/archive/refs/heads/main.zip
unzip main.zip && rm main.zip
mv schnitzler-kino-data-main/data ./data
rm -rf schnitzler-kino-data-main
./dl_imprint.sh
# python create_listperson.py