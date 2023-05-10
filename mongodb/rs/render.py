import jinja2

if __name__ == '__main__':
    env = jinja2.Environment(loader=jinja2.FileSystemLoader("."))

    # install mongod
    temp = env.get_template('template/mongod-template.yaml')
    with open('script/mongod-install.sh', 'r', encoding='utf-8') as f:
        mongodb_install = f.readlines()
    symbol = '      '
    out = temp.render(mongodb_install=symbol.join(mongodb_install))
    for i in range(1, 4):
        name = 'datanode-{}-install.yaml'.format(i)
        with open(name, 'w', encoding='utf-8') as f:
            f.writelines(out)
