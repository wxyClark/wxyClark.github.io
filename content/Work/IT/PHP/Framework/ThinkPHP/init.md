# ThinkPHP初始化

## 官方.htaccess文件错误，应修改为：
```editorconfig
 <IfModule mod_rewrite.c>
   Options +FollowSymlinks -Multiviews
   RewriteEngine On

   RewriteCond %{REQUEST_FILENAME} !-d
   RewriteCond %{REQUEST_FILENAME} !-f
   RewriteRule ^(.*)$ index.php/ [L,E=PATH_INFO:$1]
 </IfModule>
```