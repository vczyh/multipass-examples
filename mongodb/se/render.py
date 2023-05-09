import jinja2

if __name__ == '__main__':
    env = jinja2.Environment(loader=jinja2.FileSystemLoader("."))
    temp = env.get_template('config-template.yaml')

    mongodb_install = ''

    with open('./install.sh', 'r', encoding='utf-8') as f:
        mongodb_install = f.readlines()
    symbol = '      '
    out = temp.render(mongodb_install=symbol.join(mongodb_install))

    with open('config.yaml', 'w', encoding='utf-8') as f:
        f.writelines(out)
