import glob
import os
import json
from datetime import datetime
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

os.makedirs('./html/js-data', exist_ok=True)
files = sorted(glob.glob("./data/editions/*.xml"))
out_file = "./html/js-data/calendarData.js"
data = []
for x in tqdm(files, total=len(files)):
    head, tail = os.path.split(x)
    doc = TeiReader(x)
    counter = 0
    for date in doc.any_xpath(".//tei:title[@when-iso]"):
        item = {}
        counter += 1
        item["name"] = doc.any_xpath('//tei:title[@level="a"]/text()')[0]
        date_str = f"{date.attrib['when-iso']}"
        try:
            datetime.fromisoformat(date_str)
        except ValueError:
            continue
        item["startDate"] = date.attrib["when-iso"]
        item["tageszaehler"] = counter
        item["id"] = tail.replace(".xml", ".html")
        data.append(item)

print(f"writing calendar data to {out_file}")
with open(out_file, "w", encoding="utf8") as f:
    my_js_variable = f"var calendarData = {json.dumps(data, ensure_ascii=False)}"
    f.write(my_js_variable)
