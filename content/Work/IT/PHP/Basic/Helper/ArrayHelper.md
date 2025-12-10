# ArrayHelper

二维数组按某一列排序(如：聚合数据按运算后的结果排序 —— 统计场景)
```php
$list = Query->get();
foreach ($list as &$item) {
    //  推荐使用 foreach ($list as $key => $item) { $list[$key]['new_column'] = '运算后的结果'; } 
    $item['new_column'] = '运算后的结果';
}
if (!empty($params['sort_by']) && in_array($params['sort_by'], ['column_name1', 'column_name2'])) {
    $sortArray = array_column($list, $params['sort_by']);
    if (strtoupper($params['sort_order']) == 'ASC') {
        array_multisort($sortArray, SORT_ASC, $list);
    } else {
        array_multisort($sortArray, SORT_DESC, $list);
    }
}

//  分配导出数据时，如果使用 foreach ($list as $item) { item 会出现 奇怪现象，如 某一个item重复而另一个item丢失}
$exportDataList = [];
foreach ($list as $row) {
    $exportDataList[] = [
        $row['columne_1'],
        $row['columne_2'],
        ...
        $row['new_column'],
    ];
}

```