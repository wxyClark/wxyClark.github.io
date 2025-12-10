---
sort: 6
---

# 扩展 Extensions

## maatwebsite/excel

```php
composer require "maatwebsite/excel:~3.1.25"
composer require "mavinoo/laravel-batch"
```

* 注意配置 **Provider** 和 **Facade**

```php
//  安装完成后，修改 config/app.php 在 providers 数组内追加如下内容
'providers' => [
    ...
    Maatwebsite\Excel\ExcelServiceProvider::class,
    Mavinoo\Batch\BatchServiceProvider::class,
],
...

// 同时在 aliases 数组内追加如下内容
 'aliases' => [
    ...
    'Excel' => Maatwebsite\Excel\Facades\Excel::class,
    'Batch' => Mavinoo\Batch\BatchFacade::class,
]
```
* 接下来运行以下命令生成此扩展包的配置文件 config/excel.php：

```php
php artisan vendor:publish --provider="Maatwebsite\Excel\ExcelServiceProvider"
```

* 修改 config/excel.php 的 to_ascii 配置

```php
    //  to_ascii 默认值为true，会导致excel文件中的中文无法读取
    'to_ascii'             => false,
    //  设置特殊字符白名单
    'slug_whitelist'       => '._（）() */',    //  -
```

* excel 导出 pdf 图片丢失问题

    [Missing image when convert to pdf file](https://github.com/PHPOffice/PHPWord/issues/306)
```php
use PhpOffice\PhpSpreadsheet\Writer\Pdf\Mpdf as OriginalMpdf;
class Mpdf extends OriginalMpdf
{
    private $_embedImagesFixRollback;

    private function applyImageFix()
    {
        $this->isPdf = false;
        $this->_embedImagesFixRollback = $this->getEmbedImages();
        $this->setEmbedImages(true);
    }

    private function rollbackImageFix()
    {
        $this->isPdf = true;
        $this->setEmbedImages($this->_embedImagesFixRollback);
    }

    /**
     * Save Spreadsheet as html to variable.
     *
     * @return string
     */
    public function generateHtmlAll()
    {
        $this->applyImageFix();
        $html = parent::generateHtmlAll();
        $this->rollbackImageFix();
        return $html;;
    }
}
```
### 导入

```php
$reader = Excel::load($excelFilePath);

读取第一个sheet
$rowList = $reader->first()->toArray();

读取所有数据
$dataList = $reader->all()->toArray();
```

* wps导入数据，日期时间类型会转变成数值，导入时需要处理转换
> 如： 2022/4/6 14:16:42 在导入时得到：44657.594930556
```php
if (is_numeric($val)) {
    $timeFormat = \Carbon\Carbon::instance(\PhpOffice\PhpSpreadsheet\Shared\Date::excelToDateTimeObject($val));
    $timeFormat = json_decode(json_encode($timeFormat), true);
    $checkedRow['occurrence_time'] = substr($timeFormat['date'], 0, 19);
} else {
    $checkedRow['occurrence_time'] = date('Y-m-d H:i:s', strtotime($val));
}
```

### 导出
store(指定后缀名)保存到本地 storage/export 目录；export(指定后缀名)导出到页面

```php
Excel::create(time(), function ($excel) use ($rowList) {
                $excel->sheet('sheet1', function ($sheet) use ($rowList) {
                    $sheet->rows($rowList);
                });
            })->store('xlsx');
```

### 注意事项

导出数据指定key是否有效，Excel导出 按标题顺序对应

## avinoo/laravel-batch

    批量更新操作