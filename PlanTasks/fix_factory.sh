#!/bin/bash
PBXPROJ=$(find "$(dirname "$0")" -name "project.pbxproj" -maxdepth 3 | head -1)
if [ -z "$PBXPROJ" ]; then echo "❌ project.pbxproj not found"; exit 1; fi
python3 << PYTHON
import re
path = "$PBXPROJ"
with open(path, "r") as f: content = f.read()
before = content.count("FactoryTesting")
content = re.sub(r'\t\t\w+ /\* FactoryTesting in Frameworks \*/ = \{[^\}]+\};\n', '', content)
content = re.sub(r'\t+\w+ /\* FactoryTesting in Frameworks \*/,\n', '', content)
content = re.sub(r'\t+\w+ /\* FactoryTesting \*/,\n', '', content)
content = re.sub(r'\t\t\w+ /\* FactoryTesting \*/ = \{\n\t\t\tisa = XCSwiftPackageProductDependency;\n\t\t\tpackage[^\}]+\};\n', '', content)
with open(path, "w") as f: f.write(content)
after = content.count("FactoryTesting")
print(f"✅ Removed {before - after} FactoryTesting refs!" if after == 0 else f"⚠️ {after} refs remain")
PYTHON
