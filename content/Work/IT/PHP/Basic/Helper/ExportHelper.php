<?php


namespace App\Helpers;


use Illuminate\Support\Facades\Storage;
use Maatwebsite\Excel\Events\AfterSheet;
use PhpOffice\PhpSpreadsheet\Cell\Coordinate;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Worksheet\Drawing;
use SimpleSoftwareIO\QrCode\BaconQrCodeGenerator;

class ExportHelper
{
    const CELL_HEIGHT_MAX = 409;    //  WPS单行高度限制409

    /**
     * 计算合并(12列的表格自动合并参数)
     * @param $number
     * @return array
     */
    public static function calculateMergeNumber($number){
        $needMergeArr  = [1,2,3,4,6];
        if(!in_array($number,$needMergeArr)){
            return [];
        }

        $mergeTimes = 12 / $number;
        $data = [];
        foreach (range(0,$number - 1) as $v){

            $start = $v * $mergeTimes;
            $end = $start + $mergeTimes;

            $start = $start + 1;
            $start = Coordinate::stringFromColumnIndex($start);

            $data['value'][] = $start;
            $data['merge'][] = [
                'start' => $start,
                'end' => Coordinate::stringFromColumnIndex($end),
            ];
        }

        return  $data;
    }

    /**
     * @desc 生成二维码
     * @param $relative_path
     * @param $content
     * @return bool
     */
    public static function createQrCode($relative_path, $content)
    {
        $size = 100;
        $margin = 1;
        $qr_code = new BaconQrCodeGenerator();
        //  白底黑码
        $img = $qr_code->format('png')->size($size)->margin($margin)->backgroundColor(255,255,255)->color(0,0, 0)->generate($content);
        Storage::disk('local')->put($relative_path, $img);
        return true;
    }

    /**
     * @desc 写入长文本，兼容单元格高度超限的场景(拆分多行，合并单元格)
     *
     * @demo：
     * $_start = $statisticsStart;
     * ExportHelper::writeLongText($statisticsStart, $event, $desc, self::CELL_HEIGHT_DEFAULT);
     * $_end = $statisticsStart - 1;
     * for ($i = $_start; $i <= $_end; $i++) {
     *     $event->getDelegate()->getStyle($this->columnStart.$i)->getAlignment()->setVertical(Alignment::VERTICAL_CENTER);
     *     $event->getDelegate()->getStyle($this->columnStart.$i)->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT);
     * }
     * $event->getSheet()->mergeCells($this->columnStart.$_start.':'.$this->columnEnd.$_end);
     *
     * @param  AfterSheet  $event
     * @param  string  $text
     * @param  int  $statisticsStart
     * @param  int  $cell_height
     */
    public static function writeLongText(int &$statisticsStart, AfterSheet $event, string $text, int $cell_height)
    {
        $lines_arr = preg_split('/\n|\r/',$text);
        $line_num = count($lines_arr);
        $line_num = max(1, $line_num);
        $height = $line_num * $cell_height;
        $times = ceil($height / self::CELL_HEIGHT_MAX);
        if ($times > 1) {
            $last_row_height = $height % self::CELL_HEIGHT_MAX;
            for ($i = 1; $i < $times; $i++) {
                $event->getSheet()->getDelegate()->getRowDimension($statisticsStart)->setRowHeight(self::CELL_HEIGHT_MAX);
                $statisticsStart++;
            }
            $event->getSheet()->getDelegate()->getRowDimension($statisticsStart)->setRowHeight($last_row_height);
            $statisticsStart++;
        } else {
            $event->getSheet()->getDelegate()->getRowDimension($statisticsStart)->setRowHeight($height);
            $statisticsStart++;
        }
    }


    /**
     * @desc    处理本地图片
     * @param AfterSheet $event
     * @param string $cell 列
     * @param int $statisticsStart 行
     * @param string $relativePath 图片相对路径
     */
    public static function handleLocalImg(AfterSheet $event, string $cell, int $statisticsStart, string $relativePath)
    {
        try {
            $event->getSheet()->getDelegate()->getRowDimension($statisticsStart)->setRowHeight(100);
            $filename = storage_path('app') . $relativePath;

            $drawing = new Drawing();
            $drawing->setName($filename);
            $drawing->setDescription($filename);
            $drawing->setPath($filename);
            $drawing->setHeight(100);
            $drawing->setCoordinates($cell . $statisticsStart);
            $drawing->setOffsetX(2);
            $drawing->setOffsetY(2);
            $drawing->setWorksheet($event->getSheet()->getDelegate());
        } catch (\Exception $e) {
            $event->getSheet()->setCellValue($cell . $statisticsStart, '图片处理图片：' . $relativePath);
        }
    }
}
