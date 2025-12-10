# 导出

## 组件 maatwebsite Excel3.1

## Controller 

```php
public function exportSearch(Request $request)
{
    try {
        $exportData = $service->getExportData($params);

        //  直接导出流文件
        return Excel::download(new XxxExport($exportData), $fileName);
    } catch (\Exception $e) {
        //  处理异常，兼容导出数量超限
        //  记录日志
        return $this->responseJson($e->getCode(), [], $e->getMessage());
    }
}
```

## Service 

```php
public function getExportData($params)
{
    $total = $repository->getTotal($params);
    if ($total == 0) {
        throw new Excepiton('没有需要导出的数据', $errCode);
    }
    if ($total > $maxNum) {
        throw new Excepiton('超出导出最大数量限制，请缩小范围后再试', $errCode);
    }

    //  导出要求是和页面保持相同的排序规则——默认是按更新时间逆序 会导致数据不准:
    //  读取第1页数据的时候 单据A是第一页的最后一条数据
    //  读取第2页数据的时候 因为其他单据AA 操作过 出现在分页的第1页导致获取不到，单据A出现在了第2页 导致重复读取
    //  【结论】导出数据应按id排序，补充参数min_id, 不能按当前查询的总数据指定获取数据条数，导出过程中数据状态可能变化
    $list = $repository->getList($params, $fields);

    //  格式化导出数据，注意bigIng转为string
    $getExportData = [];
    foreach ($list as $item) {
        $getExportData = [
            (string)$a,
            (string)$b,
            (string)$c,
            (string)$d,
        ];
    }

    return $getExportData;
}
```

## XxxExport

导出组件，支持设定表格样式

```php
class ProductExport extends DefaultValueBinder implements FromCollection, WithCustomValueBinder, WithHeadings, WithEvents
{
    rivate $data;

    private $column = 0;

    public function __construct($data)
    {
        $this->data = $data;
    }

    /**
     * @return \Illuminate\Support\Collection
     */
    public function collection()
    {
        $this->column = count($this->data) + 1;
        return collect($this->data);
    }

    public function bindValue(\PhpOffice\PhpSpreadsheet\Cell\Cell $cell, $value)
    {
        // Excel默认支持15位的数字，超过15位就会将其转换成0标记为无效位
        if (preg_match('/^[\+\-]?(\d+\\.?\d*|\d*\\.?\d+)([Ee][\-\+]?[0-2]?\d{1,3})?$/', $value) &&
            strlen($value) > 10
        ) {
            $cell->setValueExplicit($value, DataType::TYPE_STRING);
            return true;
        }
        return parent::bindValue($cell, $value);
    }

    /**
     * 定义表单头
     * @return array
     */
    public function headings(): array
    {
        $headerTitle = [
            '商品编码（SPU）', '产品编码（SKU）', '商品名称（中文）', '商品名称（英文）', '规格属性', '1688货源链接'
        ];
        return $headerTitle;
    }

    /**
     * @return array
     */
    public function registerEvents(): array
    {
        return [
            AfterSheet::class => function (AfterSheet $event) {
                // 所有表头-设置字体为14
                $cellRange = 'A1:W1';
                $event->sheet->getDelegate()->getStyle($cellRange)->getFont()->setSize(14);
                $event->sheet->getDelegate()->getStyle('A1:Z1265')->getAlignment()->setVertical('left');
                //设置区域单元格水平居中
                $event->sheet->getDelegate()->getStyle('A1:Z1265')->getAlignment()->setHorizontal('left');
                $event->sheet->getDelegate()->getStyle('B2:B'.$this->column)->getAlignment()->setHorizontal('left');
                //设置列宽
                // 将第一行行高设置为20
                $event->sheet->getDelegate()->getRowDimension(1)->setRowHeight(20);

                //自动换行
                $event->sheet->getDelegate()->getStyle('B2:B'.$this->column)->getAlignment()->setWrapText(true);

                //设置列宽
                $event->sheet->getDelegate()->getColumnDimension('A')->setWidth(22);
                $event->sheet->getDelegate()->getColumnDimension('B')->setWidth(22);
                $event->sheet->getDelegate()->getColumnDimension('C')->setWidth(50);
                $event->sheet->getDelegate()->getColumnDimension('D')->setWidth(80);
                $event->sheet->getDelegate()->getColumnDimension('E')->setWidth(20);
                $event->sheet->getDelegate()->getColumnDimension('F')->setWidth(30);
            },
        ];
    }
}
```