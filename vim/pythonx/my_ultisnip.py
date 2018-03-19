import vim, re, os, time

def get_git_path(path):
    try:
        return vim.eval("fugitive#repo(fugitive#extract_git_dir('" + path + "')).tree()")
    except Exception as e:
        return ""

def get_git_rel_path(path):
    git = get_git_path(path)
    if not git:
        return os.path.basename(path)
    if os.path.isabs(path):
        guard = os.path.relpath(path, git)
    else:
        guard = os.path.relpath(os.path.abspath(path), git)
    return os.path.relpath(path, git)

def get_ns_and_name(filename):
    ns, name = "", ""
    with open(filename) as f:
        for line in f.readlines():
            if line.find("PROJECT") >= 0:
                name = line.split("PROJECT")[1].strip()
                continue
            if line.strip().startswith("namespace"):
                if line.strip().endswith("{"):
                    ns = line.strip().split()[1]
                    if ns in {"{", "", "std", "boost"}:
                        ns = ""
                        continue
                    break
    return ns, name

def get_project_vars(path):
    import os, sys, time, stat
    root = get_git_path(path) or os.path.dirname(path)
    incname = os.path.join(root, "include")
    files, dirname = [], os.path.dirname(path)
    if os.path.exists(incname):
        for filename in os.listdir(incname):
            if not filename.startswith("."):
                filename = os.path.join(root, "include", filename)
                if os.path.isdir(filename):
                    dirname = filename
                    break
    if not dirname: return ["", ""]
    for filename in os.listdir(dirname):
        if "." in filename:
            if filename.split(".")[-1] in {"h", "hh", "hpp", "cc", "cpp", "c"}:
                filename = os.path.join(dirname, filename)
                if os.path.isfile(filename): files.append(filename)
    entries = list(reversed(sorted((os.stat(f)[stat.ST_CTIME], f) for f in files)))
    ns, name = get_ns_and_name(entries[0][1]) if entries else ("", "")
    return [ns if ns else os.path.basename(dirname), name]

def get_guard_name(path):
    import os
    try:
        git = get_git_path(path)
        if not git:
            return path.replace("/", "_").replace(".", "_").upper().strip("_")
        if os.path.isabs(path):
            guard = os.path.relpath(path, git)
        else:
            guard = os.path.relpath(os.path.abspath(path), git)
        if guard.startswith("include"):
            guard = guard.lstrip("include").lstrip("/")
            return re.sub("[^0-9A-Za-z_]", "_", guard.upper())
        elif guard.startswith("src"):
            project = git.split("/")[-2]
            app = git.split("/")[-1].lstrip("lib")
            guard = app + "_" + guard
            if project in {"email", "rus"}:
                guard = project + "_" + guard
            return re.sub("[^0-9A-Za-z_]", "_", guard.upper())
        else:
            return re.sub("[^0-9A-Za-z_]", "_", guard.upper())
    except Exception as e:
        return path.replace("/", "_").replace(".", "_").upper().strip("_")

