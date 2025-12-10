<?php


namespace App\Helper;

class ArrayHelper
{
    /**
     * sql查询列 换行显示 用于刷数
     * @param $array  一维数组
     * @param $column_count 每行显示多少个值
     * @return array
     */
    public static function rowArray($array, $column_count)
    {
        $row_group = array_chunk($array, $column_count);
        $str = '';
        $count = count($row_group);
        foreach ($row_group as $row) {
            $count--;
            foreach ($row as $key => $value) {
                $row[$key] = "'".$value."'";
            }
            $str .= implode(', ', $row);

            if ($count > 0) {
                $str .= ',' . PHP_EOL;
            } else {
                $str .= PHP_EOL;
            }
        }

        echo $str;
    }
}
