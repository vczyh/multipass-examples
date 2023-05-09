import jinja2

if __name__ == '__main__':
    env = jinja2.Environment(loader=jinja2.FileSystemLoader("."))
    temp = env.get_template('config-template.yaml')

    redis_init = ''
    sentinel_init = ''
    replica = ''
    sentinel_monitor = ''

    with open('./redis-init.sh', 'r', encoding='utf-8') as f:
        redis_init = f.readlines()

    symbol = '      '
    out = temp.render(redis_init=symbol.join(redis_init))

    with open('config.yaml', 'w', encoding='utf-8') as f:
        f.writelines(out)
