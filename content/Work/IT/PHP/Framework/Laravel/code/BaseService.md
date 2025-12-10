# 基础服务

```php
<?php

class SthService extends BaseService
{
    /** @var \App\Repositorys\ModeuleName\XxxRepository */
    private $xxxRepository;

    /** @var \App\Repositorys\ModeuleName\YyyRepository */
    private $yyyRepository;

    /**
     * 构造函数，依赖注入
     */
    public function __construct(
        XxxRepository $xxxRepository,
        YyyRepository $yyyRepository,
    ) {
        $this->xxxRepository = $xxxRepository;
        $this->yyyRepository = $yyyRepository;
    }

    /**
     * 简单业务
     * @prarms int $primaryBusinessId 显式声明主业务ID,方便检查代码
     * @prarms array $params 原始参数只在controller层处理
     */
    public function doSth($primaryBusinessId, $params)
    {
        try {
            //  业务处理
        } catch (\Throwable $t) {
            throw $t;
        }
    }

    /**
     * 复杂业务
     * @prarms int $primaryBusinessId 显式声明主业务ID,方便检查代码
     * @prarms array $params 原始参数只在controller层处理
     */
    public function doSthComplex($primaryBusinessId, $params)
    {
        try {
            DB::beginTransaction();

            //  参数组装

            //  调用 repository 处理数据
            //  日志记录

            DB::commit();

            //  缓存释放

            //  返回结果
            return [

            ];
        } catch (\Throwable $throwable) {
            DB::rollback();
            throw $throwable;
        }
    }
}
    
```