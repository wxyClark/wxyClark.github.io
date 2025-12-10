<?php

namespace App\Helpers;

class Go
{
    public function test()
    {
        $test_count = 10000;
        $user_count = 49;
        $turn_count = 6;
        $min_success = 5;
        list($rate, $map) = $this->traceArr($test_count, $user_count, $turn_count, $min_success);

        $rs = $user_count.'人 '.$turn_count.'轮赛 '.$test_count.'次 平均升级率:'.$rate;
        dd($rs, $map);
    }

    private function traceArr($test_count, $user_count, $turn_count, $min_success)
    {
        $user_num = 0;
        $map = [];
        for ($i = 0; $i < $test_count; $i++) {
            $success_user_count = $this->trace($user_count, $turn_count, $min_success);

            if (isset($map[$success_user_count])) {
                $map[$success_user_count] += 1;
            } else {
                $map[$success_user_count] = 1;
            }
            $user_num += $success_user_count;
        }

        $rate = $user_num / $test_count;

        return [$rate, $map];
    }

    private function trace($user_count, $turn_count, $min_success)
    {
        $user_list = $this->getUserList($user_count);
        $team_count = ceil($user_count / 2);

        for ($turn = 1; $turn <= $turn_count; $turn++) {
            $score_arr = array_column($user_list, 'score');
            array_multisort($score_arr, SORT_DESC, $user_list);

            for ($team = 0; $team < $team_count; $team++) {
                $key = $team * 2;
                $user = $user_list[$key] ?? [];
                $match_user = $user_list[$key +1] ?? [];
                if (empty($match_user)) {
                    $user_list[$key]['success'] += 1;
                    $user_list[$key]['score'] += 2;
                    $user_list[$key]['trace'][] = [
                        'user_name' => $match_user['user_name'] ?? '',
                        'remark' => '胜',
                    ];
                } else {
                    $rand = rand(0, 1);
                    if ($rand > 0.5) {
                        $user_list[$key]['success'] += 1;
                        $user_list[$key]['score'] += 2;
                        $user_list[$key]['trace'][] = [
                            'user_name' => $match_user['user_name'] ?? '',
                            'remark' => '胜',
                        ];

                        $user_list[$key+1]['trace'][] = [
                            'user_name' => $user['user_name'],
                            'remark' => '负',
                        ];
                    } else {
                        $user_list[$key]['trace'][] = [
                            'user_name' => $match_user['user_name'] ?? '',
                            'remark' => '负',
                        ];

                        $user_list[$key+1]['success'] += 1;
                        $user_list[$key+1]['score'] += 2;
                        $user_list[$key+1]['trace'][] = [
                            'user_name' => $user['user_name'],
                            'remark' => '胜',
                        ];
                    }

                }


            }
        }

        $level_up = collect($user_list)->where('success', '>=', $min_success)->toArray();
        return count($level_up);
    }

    public function getUserList($user_count)
    {
        $user_list = [];
        for ($i = 1; $i <= $user_count; $i++) {
            $user_name = $this->getUserName($i +26);
            $user_list[] = [
                'user_name' => $user_name,
                'success' => 0,
                'score' => 0,
                'trace' => [],
            ];
        }

        return $user_list;
    }

    private function getUserName($i)
    {
        $diff = ord('A') - 1;
        $max = 26;

        if ($i <= $max) {
            return chr($i + $diff);
        }

        $first = floor($i / $max) + $diff;
        $second = $i % $max + $diff;
        return chr($first).chr($second);
    }
}