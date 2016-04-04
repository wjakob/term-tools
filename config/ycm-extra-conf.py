import os
import re
from sys import platform

flags = [
    '-x', 'c++', '-std=c++11', '-stdlib=libc++',
]

search_paths = []

if platform == "darwin":
    base_path = '/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs'
    sysroot = os.path.join(base_path, next(os.walk(base_path))[1][0])
    flags.append('-isysroot')
    flags.append(sysroot)


def collect_parents(path):
    search_paths.append(path)
    search_paths.append(os.path.join(path, 'build'))
    parent = os.path.dirname(path)
    if parent != path:
        collect_parents(parent)

collect_parents(os.path.dirname(os.path.abspath(__file__)))
collect_parents(os.getcwd())

for search_path in search_paths:
    try:
        with open(os.path.join(search_path, 'build.ninja')) as f:
            matches = set(re.compile(' (-[ID][^\r\n ]+)').findall(f.read()))

            for match in matches:
                if match.startswith('-D'):
                    flags.append(match)
                elif match.startswith('-I'):
                    if match.startswith('-I/'):
                        flags.append(match)
                    else:
                        if match == '-I.':
                            flags.append('-I' + search_path)
                        else:
                            flags.append('-I' +
                                os.path.join(search_path, match[2:]))
            break
    except:
        pass


def FlagsForFile(filename, **kwargs):
    return {
        'flags': flags,
        'do_cache': True
    }
