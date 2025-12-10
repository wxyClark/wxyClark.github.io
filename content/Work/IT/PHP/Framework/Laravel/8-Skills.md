# 小技巧

## 单项目调试

php artisan serve

## 打印原生SQL

```php
DB::connection()->enableQueryLog();
DB::table('students')->select('id','name','age')->get();
$log = DB::getQueryLog();
dd($log);
```

## Excel导出数据为0的项展示空白

```php
use PhpOffice\PhpSpreadsheet\Shared\StringHelper;
$number = '一个数值';
$number = StringHelper::formatNumber($number);

//  设置文字颜色
    $color = new Color(Color::COLOR_BLUE);
    $event->sheet->getDelegate()->getStyle('E2:E'.$this->column)->getFont()->setColor($color);
//  E列 展示图片URL超链接
    foreach ($this->data as $key => &$item) {
        if (empty($item['cover_image'])) {
            continue;
        }
    
        $excelRowCount = $key + 2;
        $event->getSheet()->setCellValue('E' . $excelRowCount, $item['cover_image']);
        $hyperLink = new Hyperlink($item['cover_image'], '');
        $event->getSheet()->getDelegate()->getCell('E' . $excelRowCount)->setHyperlink($hyperLink);
    }
    unset($item);
```

## 嵌套事务

[Laravel嵌套事务](https://learnku.com/articles/15618/transactions-implementation-of-nested-transaction-for-laravel)

```tip
MySQL不支持事务嵌套，如果你嵌套执行 START TRANSACTION 时会隐式执行 commit

laravel 框架却优雅的实现了事务嵌套, 基本实现原理是 savepoint

通过 $this->transactions 对应的数值设定 不同的 savepoint 实现不同层次嵌套

只有在最后一个 commit 时才会真正提交请求。
```

> laravel/framework/src/Illuminate/Database/Concerns/ManagesTransactions.php 90 行

```php
//  每调一次 beginTransaction 会使 $this->transactions 加 1
public function beginTransaction()
{
    $this->createTransaction();

    $this->transactions++;

    $this->fireConnectionEvent('beganTransaction');
}

//  创建新事务
protected function createTransaction()
{
    //  判断是否在事务中: 没有在事务中,相当于 BEGIN;
    if ($this->transactions == 0) {
        try {
            $this->getPdo()->beginTransaction();
        } catch (Exception $e) {
            $this->handleBeginTransactionException($e);
        }
    } 
    //  判断是否在事务中: 在事务中,相当于 创建保存点(SAVEPOINT trans1;)
    elseif ($this->transactions >= 1 && $this->queryGrammar->supportsSavepoints()) {
        $this->createSavepoint();
    }
}

//  创建保存点
protected function createSavepoint()
{
    $this->getPdo()->exec(
        $this->queryGrammar->compileSavepoint('trans'.($this->transactions + 1))
    );
}

//  回滚事务
public function rollBack($toLevel = null)
{
    //  允许回滚到某个事务等级
    //  尝试回滚之前回验证给定的事务等级是否有效；如果无效,则返回 且 不做任何操作
    $toLevel = is_null($toLevel)
                ? $this->transactions - 1
                : $toLevel;

    if ($toLevel < 0 || $toLevel >= $this->transactions) {
        return;
    }

    // 执行回滚并触发回滚事件, 重置事务等级
    $this->performRollBack($toLevel);

    $this->transactions = $toLevel;

    $this->fireConnectionEvent('rollingBack');
}

//  提交事务
public function commit()
{
    //  只有在最外层时才会真正的提交
    if ($this->transactions == 1) {
        $this->getPdo()->commit();
    }

    //  内层提交，修改事务等级
    $this->transactions = max(0, $this->transactions - 1);

    $this->fireConnectionEvent('committed');
}
```

## 队列queue-job

```shell
php artisan queue:work --timeout=60 --tries=3 --queue=mes:push_to_erp_job
--  重试执行失败的JOB：ID 是 failed_jobs 表的ID
php artisan queue:retry ID值
```