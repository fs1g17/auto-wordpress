# Auto Wordpress
This project contains all the files required to automatically spin up a wordpress droplet and install an SSL certificate using LetsEncrypt. 

## Explanation 
### wordpress-ssl.conf
`wordperss-ssl.conf` requires an environment variable: 
- `WORDPRESS_DOMAIN` - which should be just the domain name (for example, for a website `https://randomgarbage.site`, `WORDPRESS_DOMAIN = randomgarbage.site`).

### init.sh
`init.sh` requires the following env vars: 
- `URL`: the url of the wordpress site, e.g. `https://randomgarbage.site`
- `TITLE`: the title of the wordpress site, e.g. `Random Garbage`
- `ADMIN_USER`: the name of the administrator user
- `ADMIN_PASSWORD`: the password for the administrator user
- `ADMIN_EMAIL`: the email of the administrator user
