# This file is NOT licensed under the GPLv3, which is the license for the rest
# of ycmd.
#
# Here's the license text for this file:
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>

import os, json

from ycmd import utils
import ycm_core

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]
HEADER_EXTENSIONS = [ '.h', '.hxx', '.hpp', '.hh' ]

# We cache the database for any given source directory
compilation_database_dir_map = dict()

# Return a compilation database path for the supplied path or None if none
# could be found.
def FindCompilationDatabasePath(wd):
    # Find all the ancestor directories of the supplied directory
    for folder in utils.PathsToAllParentFolders(wd):
        # Guess not. Let's see if a compile_commands.json file already exists...
        compile_commands = os.path.join(folder, 'compile_commands.json')
        if os.path.exists(compile_commands):
            return compile_commands

        # Doesn't exist. Check the next ancestor

    # Nothing was found. No compilation flags are available.
    return None

# Return a compilation database object for the supplied path or None if none
# could be found.
#
# We search up the directory hierarchy, to first see if we have a compilation
# database already for that path, or if a compile_commands.json file exists in
# that directory.
def FindCompilationDatabase(wd):
    # Find all the ancestor directories of the supplied directory
    for folder in utils.PathsToAllParentFolders(wd):
        # Did we already cache a datbase for this path?
        if folder in compilation_database_dir_map:
            # Yep. Return that.
            return compilation_database_dir_map[ folder ]

        # Guess not. Let's see if a compile_commands.json file already exists...
        compile_commands = os.path.join(folder, 'compile_commands.json')
        if os.path.exists(compile_commands):
            # Yes, it exists. Create a database and cache it in our map.
            database = ycm_core.CompilationDatabase(folder)
            compilation_database_dir_map[ folder ] = database
            return database

        # Doesn't exist. Check the next ancestor

    # Nothing was found. No compilation flags are available.
    return None


# Find the compilation info structure from the supplied database for the
# supplied file. If the source file is a header, try and find an appropriate
# source file and return the compilation_info for that.
def GetCompilationInfoForFile(database, file_name):
    # The compilation_commands.json file generated by CMake does not have entries
    # for header files. So we do our best by asking the db for flags for a
    # corresponding source file, if any. If one exists, the flags for that file
    # should be good enough.
    if os.path.splitext(file_name)[1] not in HEADER_EXTENSIONS:
        # It's a source file. Just ask the database for the flags.
        return database.GetCompilationInfoForFile(file_name)

    # It's a header file
    basename = os.path.splitext(file_name)[ 0 ]
    for extension in SOURCE_EXTENSIONS:
        replacement_file = basename + extension
        if not os.path.exists(replacement_file):
            continue
        # We found a corresponding source file with the same basename. Try and
        # get the flags for that file.
        compilation_info = database.GetCompilationInfoForFile(replacement_file)
        if compilation_info.compiler_flags_:
            return compilation_info

    # fallback for header files
    path = FindCompilationDatabasePath(os.path.dirname(file_name))
    compile_commands = json.load(open(path))
    first_file_name = compile_commands[0]["file"]
    compilation_info = database.GetCompilationInfoForFile(first_file_name)
    return compilation_info if compilation_info.compiler_flags_ else None


# ycmd calls this method to get the compile flags for a given file. It returns a
# dictionary with 2 keys: 'flags' and 'do_cache', or None if no flags can be
# found.
def FlagsForFile(file_name, **kwargs):
    # Create or retrieve the cached compilation database object
    database = FindCompilationDatabase(os.path.dirname(file_name))
    if database is None:
        return {
            "flags": [
                '-W',
                '-Wall',
                '-Wconversion',
                '-Wdeprecated',
                '-Weffc++',
                '-Wextra',
                '-Wno-sign-conversion',
                '-Wold-style-cast',
                '-std=c++14',
            ], "do_cache": True
        }

    compilation_info = GetCompilationInfoForFile(database, file_name)
    if compilation_info is None:
        return None

    return {
        # We pass the compiler flags from the database unmodified.
        'flags': compilation_info.compiler_flags_,

        # We always want to use ycmd's cache, as this significantly improves
        # performance.
        'do_cache': True
    }

