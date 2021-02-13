import os
import subprocess
import zipfile
import datetime

zf = zipfile.ZipFile("dist/dist.zip", "w", zipfile.ZIP_DEFLATED)
for dirname, subdirs, files in os.walk("."):
    if '.git' in dirname or 'dist' in dirname: continue
    zf.write(dirname)
    for filename in files:
        zf.write(os.path.join(dirname, filename))
zf.close()

today = datetime.date.today()
today = today.strftime('%d.%m.%y')
love_file = 'dist\Galleons %s.love' % today
if os.path.isfile(love_file):
    os.remove(love_file)
os.rename('dist/dist.zip', love_file)