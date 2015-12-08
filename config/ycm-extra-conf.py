import os
import re

flags = [
    '-x', 'c++', '-std=c++11', '-stdlib=libc++'
]

SCRIPT_PATH = os.path.dirname(os.path.abspath(__file__))
SEARCH_PATH = [
    SCRIPT_PATH,
    os.getcwd(),
    os.path.join(SCRIPT_PATH, 'build'),
    os.path.join(os.getcwd(), 'build'),
]

for search_path in SEARCH_PATH:
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
                            flags.append('-I' + SCRIPT_PATH)
                        else:
                            flags.append('-I' +
                                os.path.join(SCRIPT_PATH, match[2:]))
            break
    except FileNotFoundError:
        pass


def FlagsForFile(filename, **kwargs):
    return {
        'flags': flags,
        'do_cache': True
    }
