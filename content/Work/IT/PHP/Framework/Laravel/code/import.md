# import

## 本地导入
use Maatwebsite\Excel\Facades\Excel;
```php
$filePath = 'xx.xlsx';
$data = Excel::toArray('', realpath(base_path('public')).'/'.$filePath);

//  表头 key
$head = $data[0][0];
foreach ($head as $key => $value) {
    if (empty($value)) {
        unset($head[$key]);
    }
}
unset($data[0][0]);

$import_group = array_chunk($data[0], 50);
$page = 1;
foreach ($import_group as $item_arr) {
    $insert_arr = [];
    foreach ($item_arr as $row) {
        $insert = [];
        foreach ($head as $key => $value) {
            $insert[$value] = $row[$key] ?? '';
        }
        $insert_arr[] = $insert;


    }
    if (!empty($insert_arr)) {
        app(XyzRepository::class)->create($insert_arr);
    }
    self::logger('$page = '.$page, 'test319');
    $page++;
}
```
