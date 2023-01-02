import glob
import os
import lxml.etree as ET
from collections import defaultdict
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

old_listperson = TeiReader('./data/indices/listperson.xml')
old_header = old_listperson.any_xpath('.//tei:teiHeader')[0]
print("download listperson.xml from pmb-service")
doc = TeiReader("https://pmb-service.acdh-dev.oeaw.ac.at/media/listperson.xml")
for bad in doc.any_xpath('.//tei:person[not(.//@subtype="schnitzler-kino")]'):
    bad.getparent().remove(bad)
for bad in doc.any_xpath('.//tei:note[@type="mention"]'):
    bad.getparent().remove(bad)

for x in doc.any_xpath('.//tei:person'):
    ask_id = x.xpath('.//*[@subtype="schnitzler-kino"]')[0].text.split('/')[-1].replace('.html', '')
    x.attrib["{http://www.w3.org/XML/1998/namespace}id"] = ask_id

for bad in doc.any_xpath('.//tei:teiHeader'):
    bad.getparent().remove(bad)

doc.tree.insert(0, old_header)

print("now add mentions")
files = glob.glob('./data/editions/*.xml')
persons = defaultdict(list)
for x in tqdm(files, total=len(files)):
    _, tail = os.path.split(x)
    ed_doc = TeiReader(x)
    for person in ed_doc.any_xpath('.//tei:person/@xml:id'):
        persons[person].append(tail)
for x in doc.any_xpath('.//tei:person[@xml:id]'):
    ask_id = x.attrib["{http://www.w3.org/XML/1998/namespace}id"]
    try:
        mentions = persons[ask_id]
    except KeyError:
        print(ask_id)
        continue
    for men in mentions:
        note = ET.Element("{http://www.tei-c.org/ns/1.0}note")
        note.attrib["type"] = "mention"
        note.attrib["target"] = men
        note.text = men.replace(".xml", "")
        x.append(note)

doc.tree_to_file('./data/indices/listperson.xml')