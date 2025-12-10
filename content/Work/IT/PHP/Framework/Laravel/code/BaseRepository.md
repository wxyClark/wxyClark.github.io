# Repository基类

```php
<?php

namespace App\Repositorys;

use App\Helpers\DateTimeHelper;
use App\Models\BaseModel;
use Mavinoo\Batch\Batch;

/**
 * @desc    基础仓库
 *
 * @package App\Repositorys
 */
class BaseRepository
{
    /** @var BaseModel  */
    protected $model;

    public function __construct(BaseModel $model)
    {
        $this->model = $model;
    }

    /**
     * @desc    单个或批量创建数据
     *
     * @param $attributesList
     *
     * @return mixed
     */
    public function insert($attributesList)
    {
        return $this->model->insert($attributesList);
    }

    /**
     * @desc  批量更新数据,依赖 mavinoo/laravel-batch
     * @param [包含 $index 的 model 数据] $data
     * @param string $index
     *
     * @return bool|int
     */
    public function batchUpdate($data, $index = 'id')
    {
        return Batch::update($this->model, $data, $index);
    }

    /**
     * @desc    获取映射集
     *
     * @param $params
     * @param $value_column
     * @param null $key_column
     *
     * @return array
     */
    public function getMap($params, $value_column, $key_column = null)
    {
        $list = $this->condition($params)->pluck($value_column, $key_column);

        if ($list) {
            return $list->toArray();
        }

        return [];
    }

    /**
     * @desc  获取总数
     *
     * @param $params
     *
     * @return mixed
     */
    public function getTotalCount($params)
    {
        return $this->condition($params)->count();
    }

    /**
     * @desc    获取列表
     *
     * @param $params
     * @param string[] $fields
     *
     * @return array
     */
    public function getList($params, $fields = ['*'])
    {
        $query = $this->condition($params);
        if (!empty($params['page']) && !empty($params['page_size'])) {
            $offset = ($params['page'] - 1) * $params['page_size'];

            $query->offset($offset)->limit($params['page_size']);
        }

        $sort_type = !empty($params['sort_type']) ? $params['sort_type'] : 'asc';
        $sort_column = !empty($params['sort_column']) ? $params['sort_column'] : 'id';
        $query->orderBy($sort_column, $sort_type);

        $list = $query->select($fields)->get();

        if ($list) {
            return $list->toArray();
        }

        return [];
    }

    /**
     * @desc  单个或批量创建数据
     *
     * @param $condition
     * 
     * @return mixed
     */
    public function delete($params)
    {
        return $this->condition($params)->delete();
    }

    /**
     * @desc  条件判定
     *
     * @param $params
     *
     * @return mixed
     */
    private function condition($params)
    {
        $query = $this->model->where('tenant_id', '=', $params['tenant_id']);

        //  Enums 值 0 标识非法数据，所有条件 使用 if (!empty($params['column'])) 判定
        //  统一字段定义：
        //  查询时段  start_time    end_time
        //  排序参数  sort_column   sort_type
        //  分页参数  page_size     page
        //  选中导出  select_code_list
        //  自增主键  id    与业务无关,仅表示数据创建顺序
        //  业务主键  xxx_code     联表字段

        //  等值条件
        if (!empty($params['xxx_code'])) {
            if (is_array($params['xxx_code'])) {
                $query->whereIn('xxx_code', $params['xxx_code']);
            } else {
                $query->where('xxx_code', '=', $params['xxx_code']);
            }
        }

        //  范围条件
        if (!empty($params['start_time'])) {
            $query->where('xxx_date', '>=', DateTimeHelper::getDateStart($params['start_time']));
        }

        if (!empty($params['end_time'])) {
            $query->where('xxx_date', '<=', DateTimeHelper::getDateStart($params['end_time']));
        }

        //  模糊匹配条件
        if (!empty($params['order_sn'])) {
            $query->where('order_sn', 'like', '%'.$params['order_sn'].'%');
        }

        //  联表 需要考虑groupBy,保证count、分页准确性 $query->groupBy(['xxx_code']);

        return $query->groupBy();
    }
}
```