import os
import re
import sys

def minify_lua(content):
    # Remove comments outside of strings
    content = re.sub(r'--(?=[^\'"]*(?:[\'"][^\'"]*[\'"][^\'"]*)*$).*', '', content)
    # Remove multiline comments
    content = re.sub(r'\-\-\[\[.*?\]\]', '', content, flags=re.DOTALL)
    # Remove extra whitespace outside of strings
    content = re.sub(r'\s+(?=[^\'"]*(?:[\'"][^\'"]*[\'"][^\'"]*)*$)', ' ', content)
    # Remove spaces around operators
    content = re.sub(r'\s*([=+\-*/%^#<>~])\s*(?=[^\'"]*(?:[\'"][^\'"]*[\'"][^\'"]*)*$)', r'\1', content)
    # Remove spaces after semicolons
    content = re.sub(r'\s*([;])\s*(?=[^\'"]*(?:[\'"][^\'"]*[\'"][^\'"]*)*$)', r'\1', content)
    # Remove spaces around braces
    content = re.sub(r'\s*([\(\)\[\]\{\}])\s*(?=[^\'"]*(?:[\'"][^\'"]*[\'"][^\'"]*)*$)', r'\1', content)
    # Remove spaces after commas outside of strings
    content = re.sub(r'\s*,\s*(?=[^\'"]*(?:[\'"][^\'"]*[\'"][^\'"]*)*$)', ',', content)
    # Remove spaces around concatenation operator
    content = re.sub(r'\s*\.\.\s*(?=[^\'"]*(?:[\'"][^\'"]*[\'"][^\'"]*)*$)', '..', content)
    return content

def resolve_requires(content, dir, packed_files=set()):
    def replace_require(match):
        var_name = match.group(1)
        module_name = match.group(2)
        module_path = os.path.join(dir, module_name.replace('.', '/'))
        if os.path.isdir(module_path):
            module_path = os.path.join(module_path, 'init.lua')
        else:
            module_path += '.lua'
        if os.path.exists(module_path) and module_path not in packed_files:
            with open(module_path, 'r', encoding='utf-8') as f:
                module_content = f.read()
            main_var = module_name.split("/")[0]
            # module_content = re.sub(r'return\s+{}\s*$'.format(main_var), '', module_content, flags=re.MULTILINE)
            packed_files.add(module_path)
            module_content = resolve_requires(module_content, os.path.dirname(module_path), packed_files)
            return f'-- begin {module_name}\nlocal function {main_var.replace('.', '_')}()\n{module_content}\nend\n-- end {module_name}\nlocal {var_name} = {main_var.replace('.', '_')}()'
        return match.group(0)

    pattern = re.compile(r'local\s+(\w+)\s*=\s*require\s*\(?\s*[\'"]([^\'"]+)[\'"]\s*\)?')
    content = pattern.sub(replace_require, content)
    
    return content

def main():
    if len(sys.argv) < 3 or len(sys.argv) > 4:
        print("Usage: python packer.py <main_file> <output_file> [--minify]")
        sys.exit(1)

    main_file = sys.argv[1]
    output_file = sys.argv[2]
    minify = len(sys.argv) == 4 and sys.argv[3] == '--minify'

    with open(main_file, 'r', encoding='utf-8') as f:
        main_content = f.read()

    resolved_content = resolve_requires(main_content, os.path.dirname(main_file))
    if minify:
        resolved_content = minify_lua(resolved_content)

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(resolved_content)

    print(f'All Lua files have been packed into {output_file}')

if __name__ == "__main__":
    main()
