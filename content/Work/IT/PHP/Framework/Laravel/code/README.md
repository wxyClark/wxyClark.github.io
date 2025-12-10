---
sort: 8
---

# 代码模板



<hr />

## Route


## Controller

### API

### Command

## Service


## Repository

```php
class TableNameRepository extends BaseRepository
{
    /** @var TableNameModel  */
    protected $model;

    public function __construct(TableNameModel $model)
    {
        $this->model = $model;
    }

    public function insert($attributesList)

    public function batchUpdate($data, $index = 'id')

    public function getMap($params, $value_column, $key_column = null){}

    public function getTotalCount($params){}

    public function getList($params, $fields = ['*']){}

    public function delete($params){}

    private function condition($params){}
}
```

## Model

## apache重定向配置

./public/.htaccess

```apache
<IfModule mod_rewrite.c>
    <IfModule mod_negotiation.c>
        Options -MultiViews -Indexes
    </IfModule>

    RewriteEngine On

    # Handle Authorization Header
    RewriteCond %{HTTP:Authorization} .
    RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]

    # Redirect Trailing Slashes If Not A Folder...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} (.+)/$
    RewriteRule ^ %1 [L,R=301]

    # Handle Front Controller...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [L]
</IfModule>

```


