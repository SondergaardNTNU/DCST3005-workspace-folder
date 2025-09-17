#cloud-config
package_update: true
packages:
  - nginx
runcmd:
  - echo "<h1>${name_prefix} environment</h1>" > /var/www/html/index.html
