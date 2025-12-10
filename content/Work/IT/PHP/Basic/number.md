# number

## 浮点数精度问题
```php
$rate = round( $out_in_time_cnt / $outbound_no_cnt, 4);
//  rate 浮点数，可能展示位 98.76000000000000000001
$percent = bcmul($rate, 100, 2);
```
