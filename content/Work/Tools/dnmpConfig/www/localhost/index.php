<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo '<h1 style="text-align: center;">欢迎使用DNMP！</h1>';
echo '<h2>版本信息</h2>';

echo '<ul>';
echo '<li>PHP版本：', PHP_VERSION, '</li>';
echo '<li>Nginx版本：', $_SERVER['SERVER_SOFTWARE'], '</li>';
echo '<li>MySQL服务器版本：', getMysqlVersion(), '</li>';
echo '<li>Redis服务器版本：', getRedisVersion(), '</li>';
echo '<li>MongoDB服务器版本：', getMongoVersion(), '</li>';
echo '</ul>';

echo '<h2>导航</h2>';
printDomains();

echo '<h2>已安装扩展</h2>';
printExtensions();

phpinfo();


/**
 * 获取MySQL版本
 */
function getMysqlVersion()
{
    if (extension_loaded('PDO_MYSQL')) {
        try {
            $dbh = new PDO('mysql:host=mysql;dbname=mysql', 'root', '123456');
            $sth = $dbh->query('SELECT VERSION() as version');
            $info = $sth->fetch();
        } catch (PDOException $e) {
            return $e->getMessage();
        }
        return $info['version'];
    } else {
        return 'PDO_MYSQL 扩展未安装 ×';
    }

}

/**
 * 获取Redis版本
 */
function getRedisVersion()
{
    if (extension_loaded('redis')) {
        try {
            $redis = new Redis();
            $redis->connect('redis', 6379);
            $info = $redis->info();
            return $info['redis_version'];
        } catch (Exception $e) {
            return $e->getMessage();
        }
    } else {
        return 'Redis 扩展未安装 ×';
    }
}

/**
 * 获取MongoDB版本
 */
function getMongoVersion()
{
    if (extension_loaded('mongodb')) {
        try {
            $manager = new MongoDB\Driver\Manager('mongodb://root:123456@mongodb:27017');
            $command = new MongoDB\Driver\Command(array('serverStatus'=>true));

            $cursor = $manager->executeCommand('admin', $command);

            return $cursor->toArray()[0]->version;
        } catch (Exception $e) {
            return $e->getMessage();
        }
    } else {
        return 'MongoDB 扩展未安装 ×';
    }
}

/**
 * 获取已安装扩展列表
 */
function printExtensions()
{
    printTable(get_loaded_extensions(), 5);
}


/**
 * 打印域名导航
 */
function printDomains()
{
    $domains = [
        '<a target="_blank" href="http://localhost/" >localhost</a>',
        '<a target="_blank" href="http://www.laravel9.wxy/" >laravel9</a>',
        '<a target="_blank" href="http://127.0.0.1:8080" >phpMyAdmin</a>',
        '<a target="_blank" href="http://127.0.0.1:8081" >redisAdmin</a>',
        '<a target="_blank" href="http://127.0.0.1:1234" >mongoAdmin</a>',
        '<a target="_blank" href="http://127.0.0.1:5601" >elk</a>',
    ];
    printTable($domains, 3);
}

/**
 * 打印表格
 */
function printTable($data, $columnNum)
{
    echo "<table border=1  cellpadding=30>";

    foreach($data as  $i => $name){
        $order = $i % $columnNum;
        if ($order == 0) {
            echo "<tr>";
        }

        echo "<td> $i $name</td>";

        if ($order == $columnNum - 1) {
            echo "</tr>";
        }
    }

    echo "</table>";
}