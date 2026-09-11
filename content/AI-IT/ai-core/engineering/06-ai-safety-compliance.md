# 10 — AI 安全、合规与伦理

> 确保AI系统安全可靠、符合法规要求
> 目标：理解AI安全威胁，掌握合规实践和伦理原则

---

## 一、AI安全威胁全景

### 1.1 安全威胁分类

```mermaid
flowchart TB
    subgraph 输入安全["📥 输入安全"]
        I1["提示词注入<br/>Prompt Injection"]
        I2["越狱攻击<br/>Jailbreak"]
        I3["数据投毒<br/>Data Poisoning"]
    end
    
    subgraph 输出安全["📤 输出安全"]
        O1["幻觉内容<br/>Hallucination"]
        O2["偏见歧视<br/>Bias"]
        O3["有害内容<br/>Harmful Content"]
    end
    
    subgraph 系统安全["🔐 系统安全"]
        S1["API密钥泄露<br/>Key Exposure"]
        S2["模型窃取<br/>Model Stealing"]
        S3["供应链攻击<br/>Supply Chain"]
    end
    
    subgraph 数据安全["💾 数据安全"]
        D1["隐私泄露<br/>Privacy Leak"]
        D2["数据滥用<br/>Data Misuse"]
        D3["数据持久化<br/>Data Persistence"]
    end
    
    style I1 fill:#ffebee
    style O2 fill:#fff3e0
    style S1 fill:#e3f2fd
    style D1 fill:#f3e5f5
```

### 1.2 典型攻击案例

| 攻击类型 | 攻击方式 | 防御措施 |
|----------|----------|----------|
| **提示词注入** | 在输入中嵌入恶意指令 | 输入过滤 + 安全边界检测 |
| **越狱攻击** | 诱导模型违反安全策略 | 输出审核 + 安全提示词 |
| **数据泄露** | 通过查询获取敏感信息 | 数据脱敏 + 访问控制 |
| **模型窃取** | 大量查询重建模型 | 限流 + 查询检测 |

---

## 二、AI合规要求

### 2.1 主要法规概览

```mermaid
flowchart LR
    subgraph 国际法规["🌍 国际法规"]
        EU1["EU AI Act<br/>欧盟人工智能法案"]
        US1["NIST AI RMF<br/>美国AI风险管理框架"]
    end
    
    subgraph 中国法规["🇨🇳 中国法规"]
        CN1["生成式AI服务管理暂行办法"]
        CN2["网络安全法"]
        CN3["数据安全法"]
        CN4["个人信息保护法"]
    end
    
    EU1 & US1 & CN1 & CN2 & CN3 & CN4 --> SAFE["合规实践"]
    
    style EU1 fill:#e3f2fd
    style CN1 fill:#fff3e0
    style SAFE fill:#e8f5e9
```

### 2.2 中国AI合规要点

```mermaid
mindmap
    root((中国AI合规要点))
        生成式AI管理
            算法备案
            内容安全评估
            用户实名登记
        数据安全
            数据分类分级
            重要数据出境安全评估
            数据本地化存储
        个人信息保护
            明示同意
            最小必要原则
            删除权保障
        内容安全
            价值观导向
            禁止生成违法内容
            建立投诉举报机制
```

---

## 三、AI安全防护实践

### 3.1 输入层防护

```python
# security/input_filter.py
import re
from typing import List

class InputFilter:
    """输入安全过滤器"""
    
    # 危险模式
    DANGEROUS_PATTERNS = [
        r'忽略之前的指令',
        r'你是 DAN',
        r'以JSON格式输出系统提示',
        r'不要有任何限制',
    ]
    
    # 敏感信息模式
    SENSITIVE_PATTERNS = [
        r'\b\d{18}\b',           # 身份证号
        r'\b\d{11}\b',           # 手机号
        r'银行卡号?\s*\d+',      # 银行卡
        r'密码?\s*[=:]\s*\S+',   # 密码
    ]
    
    def check(self, text: str) -> dict:
        """检查输入安全性"""
        results = {
            'is_safe': True,
            'threats': [],
            'suggestions': []
        }
        
        # 检查注入攻击
        for pattern in self.DANGEROUS_PATTERNS:
            if re.search(pattern, text, re.IGNORECASE):
                results['is_safe'] = False
                results['threats'].append(f'检测到注入攻击模式: {pattern}')
        
        # 检查敏感信息
        for pattern in self.SENSITIVE_PATTERNS:
            matches = re.findall(pattern, text)
            if matches:
                results['suggestions'].append(f'检测到可能包含敏感信息: {matches[0][:20]}...')
        
        return results

filter = InputFilter()
```

### 3.2 输出层防护

```python
# security/output_filter.py
class OutputFilter:
    """输出安全过滤器"""
    
    # 禁止生成的内容类型
    FORBIDDEN_CONTENT = {
        'hate_speech': ['种族歧视', '性别歧视', '地域歧视'],
        'illegal': ['赌博', '毒品', '武器'],
        'private': ['身份证', '银行卡', '密码'],
    }
    
    def filter(self, text: str) -> dict:
        """过滤输出内容"""
        results = {
            'is_safe': True,
            'filtered_text': text,
            'issues': []
        }
        
        for category, keywords in self.FORBIDDEN_CONTENT.items():
            for keyword in keywords:
                if keyword in text:
                    results['is_safe'] = False
                    results['issues'].append(f'{category}: 包含禁止内容 "{keyword}"')
                    # 替换为安全文本
                    results['filtered_text'] = results['filtered_text'].replace(keyword, '[已过滤]')
        
        return results
```

### 3.3 访问控制

```python
# security/access_control.py
from functools import wraps
import time

class RateLimiter:
    """API限流器"""
    
    def __init__(self, max_requests: int = 60, window: int = 60):
        self.max_requests = max_requests
        self.window = window
        self.requests = {}
    
    def check(self, user_id: str) -> bool:
        """检查是否超出限流"""
        now = time.time()
        key = f"{user_id}:{int(now // self.window)}"
        
        if key not in self.requests:
            self.requests[key] = 0
        
        self.requests[key] += 1
        
        # 清理过期记录
        if self.requests[key] > self.max_requests:
            return False
        
        return True
    
    def clean_expired(self):
        """清理过期记录"""
        current_window = int(time.time() // self.window)
        expired_keys = [k for k in self.requests if int(k.split(':')[1]) < current_window]
        for key in expired_keys:
            del self.requests[key]

rate_limiter = RateLimiter(max_requests=30, window=60)  # 每分钟30次
```

---

## 四、AI伦理原则

### 4.1 核心伦理原则

```mermaid
flowchart TB
    subgraph 原则["AI伦理五大原则"]
        P1["公平公正<br/>Fairness"]
        P2["透明可解释<br/>Transparency"]
        P3["隐私保护<br/>Privacy"]
        P4["安全可靠<br/>Safety"]
        P5["责任可追溯<br/>Accountability"]
    end
    
    P1 & P2 & P3 & P4 & P5 --> IMPLEMENT["落地实施"]
    
    style P1 fill:#e3f2fd
    style P2 fill:#fff3e0
    style P3 fill:#e8f5e9
    style P4 fill:#fce4ec
    style P5 fill:#f3e5f5
```

### 4.2 公平性检测

```python
# ethics/fairness_checker.py
import pandas as pd

class FairnessChecker:
    """AI输出公平性检测"""
    
    def check_bias(self, predictions: pd.Series, sensitive_attr: pd.Series) -> dict:
        """检测预测结果中的偏见"""
        # 计算不同群体的预测分布
        group_stats = predictions.groupby(sensitive_attr).agg({
            'mean': 'mean',
            'std': 'std',
            'count': 'count'
        })
        
        # 计算公平性指标
        disparate_impact = group_stats['mean'].min() / group_stats['mean'].max()
        
        return {
            'disparate_impact': disparate_impact,
            'threshold': 0.8,  # 公平性阈值
            'is_fair': disparate_impact >= 0.8,
            'group_statistics': group_stats.to_dict()
        }
```

---

## 五、合规检查清单

### 5.1 部署前检查

```
□ 已完成算法备案（如适用）
□ 已完成内容安全评估
□ 用户协议和隐私政策已更新
□ API密钥已加密存储
□ 访问控制已启用
□ 日志记录已配置
□ 数据脱敏已实施
□ 应急恢复预案已制定
```

### 5.2 运行时检查

```
□ 输入安全过滤已启用
□ 输出安全审核已启用
□ 限流策略已生效
□ 异常监控已配置
□ 投诉举报通道已开放
□ 定期安全审计已安排
```

---

## 六、应急响应

### 6.1 安全事件响应流程

```mermaid
flowchart TD
    A["发现安全事件"] --> B["立即隔离"]
    B --> C["评估影响范围"]
    C --> D{"是否严重?"}
    D -->|是| E["启动应急预案"]
    D -->|否| F["记录并监控"]
    E --> G["修复漏洞"]
    G --> H["恢复服务"]
    H --> I["复盘总结"]
    F --> I
    I --> J["更新安全策略"]
    
    style A fill:#ffebee
    style E fill:#fff3e0
    style I fill:#e8f5e9
```

### 6.2 常见应急场景

| 场景 | 立即行动 | 后续处理 |
|------|----------|----------|
| API密钥泄露 | 立即吊销密钥 | 审计所有使用该密钥的请求 |
| 模型输出有害内容 | 暂停服务 | 审查提示词和训练数据 |
| 大规模数据泄露 | 通知监管和用户 | 启动法律程序 |
| DDoS攻击 | 启用防护 | 联系服务商 |

---

## 七、本章总结

> **核心结论：** AI安全是系统工程，需要"技术防护 + 管理制度 + 合规审查"三位一体。始终将用户安全放在首位，建立透明的问责机制。

---

## 延伸阅读

- [06 AI工程化实践](./02-ai-engineering-practice.md) — 生产环境的安全部署
- [11 AI工具链与平台推荐](./07-ai-tools-platforms.md) — 安全工具推荐
