# 基础控制器

```php
<?php

use App\Http\Controllers\Api\ApiController;
use \App\Services\BaseService;
use Illuminate\Http\Request;

class BaseController extends ApiController
{

    /** @var \App\Services\BaseService */
    private $service;

    //  组装参数
    private $params;

    /**
     * 构造函数，依赖注入
     */
    public function __construct(BaseService $service) 
    {
        $this->service = $service;
    }

    /**
     * 列表
     */
    public function list(Request $request)
    {
        try {
            //  middleWare 鉴权

            //  用户参数组装
            //  用户参数处理
            $this->params = [

            ];
            $rules = [];
            
            //  参数校验
            $this->validateBase($this->params, $rules);
            
            $data = $this->service->doSthFunction($this->params);

            return $this->responseJson(CONST_SUCCESS_CODE, $data, GET_CONST_SUCCESS_TEXT);
        } catch (\Throwable $t) {
            //  记录日志
            return $this->responseJson($t->getCode(), [], $t->getMessage());
        }
    }

    /**
     * 基类方法-参数校验
     */
    private function validateBase($params, $rules)
    {
        //  基于Validate 验证
        return [
           'status' => true,    //  false
        ];
    }

    /**
     * 基类方法-统一返回格式
     */
    private function responseJson($code, $data, $message = '')
    {
        return [
            'code' => 0,
            'data' => [

            ],
            'msg' => '操作成功|失败原因',
        ];
    }
}

```