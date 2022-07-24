#!/bin/bash

# configure the bot
python3 -m simplebot init "$ADDR" "$PASSWORD"
python3 -m simplebot -a "$ADDR" set_name "$BOTNAME"
python3 -m simplebot -a "$ADDR" set_avatar "www.jpg"
python3 -m simplebot -a "$ADDR" db -s "simplebot_downloader/mode" "command"
python3 -m simplebot -a "$ADDR" db -s "simplebot_downloader/max_size" "$FILESIZE"  # 1GB
python3 -m simplebot -a "$ADDR" db -s "simplebot_downloader/delay" $DELAY
python3 -m simplebot -a "$ADDR" db -s "simplebot_translator/filter_enabled" "no"
python3 ./restore_keys.py

# add the web_comress plugin
python3 -c "import requests; r=requests.get('https://github.com/adbenitez/simplebot-scripts/raw/master/scripts/web_compress.py'); open('web_compress.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./web_compress.py

# add the web_search plugin
python3 -c "import requests; r=requests.get('https://github.com/adbenitez/simplebot-scripts/raw/master/scripts/web_search.py'); open('web_search.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./web_search.py

# add the youtube plugin
python3 -c "import requests; r=requests.get('https://github.com/adbenitez/simplebot-scripts/raw/master/scripts/youtube.py'); open('youtube.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./youtube.py

# add the misc plugin
python3 -c "import requests; r=requests.get('https://github.com/adbenitez/simplebot-scripts/raw/master/scripts/misc.py'); open('misc.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./misc.py

# add the image_search plugin
python3 -c "import requests; r=requests.get('https://github.com/adbenitez/simplebot-scripts/raw/master/scripts/image_search.py'); open('image_search.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./image_search.py

# add the encryption_error plugin to leverage key changes
python3 -c "import requests; r=requests.get('https://github.com/adbenitez/simplebot-scripts/raw/master/scripts/encryption_error.py'); open('encryption_error.py', 'wb').write(r.content)"
python3 -m simplebot -a "$ADDR" plugin --add ./encryption_error.py

# add admin plugin
if [ -n "$ADMIN" ]; then
    python3 -c "import requests; r=requests.get('https://github.com/adbenitez/simplebot-scripts/raw/master/scripts/admin.py'); open('admin.py', 'wb').write(r.content)"
    python3 -m simplebot -a "$ADDR" plugin --add ./admin.py
    python3 -m simplebot -a "$ADDR" admin --add "$ADMIN"
fi

# start the bot
python3 -m simplebot -a "$ADDR" serve