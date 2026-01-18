# 如何减少HTTP请求次数？

## 概要回答

减少HTTP请求次数是Web性能优化的核心策略之一，主要方法包括：

1. **资源合并**：合并CSS、JavaScript文件，使用CSS Sprites合并小图片
2. **缓存策略**：合理设置HTTP缓存头，利用浏览器缓存
3. **延迟加载**：实现图片懒加载、组件按需加载
4. **内联关键资源**：内联关键CSS和小型JavaScript
5. **域名分片**：使用多个域名并行下载资源
6. **预加载技术**：使用预加载、预连接等技术优化资源加载

## 深度解析

### 资源合并优化

资源合并是减少HTTP请求最直接有效的方法，通过将多个小文件合并为一个大文件来减少请求数量。

```php
<?php
/**
 * 资源合并工具类
 */
class AssetMerger {
    
    /**
     * 合并CSS文件
     */
    public static function mergeCSS($cssFiles, $outputFile) {
        $mergedContent = "/* 合并时间: " . date('Y-m-d H:i:s') . " */\n\n";
        
        foreach ($cssFiles as $file) {
            if (file_exists($file)) {
                $content = file_get_contents($file);
                // 添加文件名注释便于调试
                $mergedContent .= "/* Source: $file */\n";
                $mergedContent .= $content . "\n\n";
            }
        }
        
        // 写入合并后的文件
        file_put_contents($outputFile, $mergedContent);
        
        return $outputFile;
    }
    
    /**
     * 合并JavaScript文件
     */
    public static function mergeJS($jsFiles, $outputFile, $wrapInIIFE = false) {
        $mergedContent = "// 合并时间: " . date('Y-m-d H:i:s') . "\n\n";
        
        if ($wrapInIIFE) {
            $mergedContent .= "(function() {\n'use strict';\n\n";
        }
        
        foreach ($jsFiles as $file) {
            if (file_exists($file)) {
                $content = file_get_contents($file);
                // 添加文件名注释
                $mergedContent .= "// Source: $file\n";
                $mergedContent .= $content . "\n\n";
            }
        }
        
        if ($wrapInIIFE) {
            $mergedContent .= "})();\n";
        }
        
        // 写入合并后的文件
        file_put_contents($outputFile, $mergedContent);
        
        return $outputFile;
    }
    
    /**
     * 生成CSS Sprites
     */
    public static function createCSSSprite($imageFiles, $spriteFile, $cssFile) {
        if (!extension_loaded('gd')) {
            throw new Exception("GD扩展未安装");
        }
        
        // 计算精灵图尺寸
        $totalWidth = 0;
        $maxHeight = 0;
        $imageInfo = [];
        
        foreach ($imageFiles as $index => $file) {
            if (file_exists($file)) {
                list($width, $height) = getimagesize($file);
                $imageInfo[$index] = [
                    'file' => $file,
                    'width' => $width,
                    'height' => $height,
                    'x' => $totalWidth,
                    'y' => 0
                ];
                $totalWidth += $width;
                $maxHeight = max($maxHeight, $height);
            }
        }
        
        // 创建精灵图
        $sprite = imagecreatetruecolor($totalWidth, $maxHeight);
        
        // 设置透明背景
        $transparent = imagecolorallocatealpha($sprite, 0, 0, 0, 127);
        imagefill($sprite, 0, 0, $transparent);
        imagealphablending($sprite, false);
        imagesavealpha($sprite, true);
        
        // 合并图片
        foreach ($imageInfo as $info) {
            $source = imagecreatefrompng($info['file']);
            imagecopy($sprite, $source, $info['x'], $info['y'], 0, 0, 
                     $info['width'], $info['height']);
            imagedestroy($source);
        }
        
        // 保存精灵图
        imagepng($sprite, $spriteFile);
        imagedestroy($sprite);
        
        // 生成CSS
        $css = "/* CSS Sprites 生成时间: " . date('Y-m-d H:i:s') . " */\n\n";
        $css .= ".sprite { display: inline-block; background-image: url('$spriteFile'); }\n\n";
        
        foreach ($imageInfo as $index => $info) {
            $className = pathinfo($info['file'], PATHINFO_FILENAME);
            $css .= ".icon-$className {\n";
            $css .= "    width: {$info['width']}px;\n";
            $css .= "    height: {$info['height']}px;\n";
            $css .= "    background-position: -{$info['x']}px -{$info['y']}px;\n";
            $css .= "}\n\n";
        }
        
        file_put_contents($cssFile, $css);
        
        return [
            'sprite' => $spriteFile,
            'css' => $cssFile,
            'mapping' => $imageInfo
        ];
    }
    
    /**
     * 批量处理资源合并
     */
    public static function batchMerge($config) {
        $results = [];
        
        // 合并CSS
        if (isset($config['css'])) {
            foreach ($config['css'] as $group => $files) {
                $output = "assets/css/$group.min.css";
                try {
                    self::mergeCSS($files, $output);
                    $results['css'][$group] = [
                        'output' => $output,
                        'files' => count($files),
                        'size' => filesize($output)
                    ];
                } catch (Exception $e) {
                    $results['css'][$group] = ['error' => $e->getMessage()];
                }
            }
        }
        
        // 合并JavaScript
        if (isset($config['js'])) {
            foreach ($config['js'] as $group => $files) {
                $output = "assets/js/$group.min.js";
                try {
                    self::mergeJS($files, $output);
                    $results['js'][$group] = [
                        'output' => $output,
                        'files' => count($files),
                        'size' => filesize($output)
                    ];
                } catch (Exception $e) {
                    $results['js'][$group] = ['error' => $e->getMessage()];
                }
            }
        }
        
        return $results;
    }
}

// 使用示例
// $config = [
//     'css' => [
//         'main' => ['css/reset.css', 'css/layout.css', 'css/theme.css'],
//         'components' => ['css/button.css', 'css/form.css', 'css/modal.css']
//     ],
//     'js' => [
//         'vendor' => ['js/jquery.js', 'js/bootstrap.js'],
//         'app' => ['js/utils.js', 'js/main.js']
//     ]
// ];
// 
// $results = AssetMerger::batchMerge($config);
// print_r($results);
?>
```

### 缓存策略优化

合理的缓存策略可以让浏览器复用已下载的资源，避免重复请求。

```php
<?php
/**
 * HTTP缓存优化工具类
 */
class HttpCacheOptimizer {
    
    /**
     * 设置静态资源缓存头
     */
    public static function setStaticCacheHeaders($maxAge = 31536000) {
        // 设置长期缓存
        header('Cache-Control: public, max-age=' . $maxAge);
        header('Expires: ' . gmdate('D, d M Y H:i:s', time() + $maxAge) . ' GMT');
        
        // 设置ETag
        $etag = md5($_SERVER['REQUEST_URI'] . filemtime($_SERVER['SCRIPT_FILENAME']));
        header('ETag: "' . $etag . '"');
        
        // 检查If-None-Match
        if (isset($_SERVER['HTTP_IF_NONE_MATCH']) && 
            trim($_SERVER['HTTP_IF_NONE_MATCH'], '"') === $etag) {
            header('HTTP/1.1 304 Not Modified');
            exit;
        }
    }
    
    /**
     * 设置短期缓存
     */
    public static function setShortCacheHeaders($maxAge = 3600) {
        header('Cache-Control: public, max-age=' . $maxAge);
        header('Expires: ' . gmdate('D, d M Y H:i:s', time() + $maxAge) . ' GMT');
    }
    
    /**
     * 设置不缓存头
     */
    public static function setNoCacheHeaders() {
        header('Cache-Control: no-cache, no-store, must-revalidate');
        header('Pragma: no-cache');
        header('Expires: 0');
    }
    
    /**
     * 生成带版本号的资源URL
     */
    public static function versionedAsset($path) {
        $version = filemtime($_SERVER['DOCUMENT_ROOT'] . $path);
        return $path . '?v=' . $version;
    }
    
    /**
     * Apache .htaccess缓存配置
     */
    public static function getApacheCacheConfig() {
        return '
# 启用Expires模块
<IfModule mod_expires.c>
    ExpiresActive On
    
    # 默认缓存1个月
    ExpiresDefault "access plus 1 month"
    
    # HTML文件缓存1小时
    ExpiresByType text/html "access plus 1 hour"
    
    # CSS和JavaScript文件缓存1年
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType text/javascript "access plus 1 year"
    
    # 图片文件缓存1年
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
    ExpiresByType image/webp "access plus 1 year"
    
    # 字体文件缓存1年
    ExpiresByType application/font-woff "access plus 1 year"
    ExpiresByType application/font-woff2 "access plus 1 year"
    ExpiresByType application/vnd.ms-fontobject "access plus 1 year"
    ExpiresByType font/truetype "access plus 1 year"
    ExpiresByType font/opentype "access plus 1 year"
</IfModule>

# 设置Cache-Control头
<IfModule mod_headers.c>
    # 静态资源设置immutable缓存
    <FilesMatch "\.(css|js|png|jpg|jpeg|gif|ico|svg|webp|woff|woff2|ttf|eot)$">
        Header set Cache-Control "public, immutable"
    </FilesMatch>
</IfModule>';
    }
    
    /**
     * Nginx缓存配置
     */
    public static function getNginxCacheConfig() {
        return '
# 设置expires头
location ~* \.(css|js)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}

location ~* \.(png|jpg|jpeg|gif|ico|svg|webp)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}

location ~* \.(woff|woff2|ttf|eot)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}

location ~* \.html$ {
    expires 1h;
    add_header Cache-Control "public, must-revalidate";
}

# 启用ETag
location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|webp|woff|woff2|ttf|eot)$ {
    etag on;
}';
    }
    
    /**
     * 资源版本管理
     */
    public static function getResourceManifest() {
        $manifest = [];
        $directories = ['css', 'js', 'images', 'fonts'];
        
        foreach ($directories as $dir) {
            $files = glob("$dir/*.{css,js,png,jpg,jpeg,gif,svg,webp,woff,woff2,ttf,eot}", GLOB_BRACE);
            foreach ($files as $file) {
                $manifest[$file] = md5_file($file) . '.' . filemtime($file);
            }
        }
        
        return json_encode($manifest, JSON_PRETTY_PRINT);
    }
}

// 使用示例
// if (strpos($_SERVER['REQUEST_URI'], '.css') !== false || 
//     strpos($_SERVER['REQUEST_URI'], '.js') !== false) {
//     HttpCacheOptimizer::setStaticCacheHeaders();
// }
?>
```

### 延迟加载实现

延迟加载可以推迟非关键资源的加载，减少初始页面加载时间。

```php
<?php
/**
 * 延迟加载实现类
 */
class LazyLoader {
    
    /**
     * 图片懒加载HTML生成
     */
    public static function lazyImage($src, $alt = '', $classes = '', $attributes = []) {
        $attrs = '';
        foreach ($attributes as $key => $value) {
            $attrs .= " $key=\"" . htmlspecialchars($value) . "\"";
        }
        
        return "<img data-src=\"$src\" alt=\"$alt\" class=\"lazy $classes\"$attrs>";
    }
    
    /**
     * 响应式图片懒加载
     */
    public static function lazyPicture($sources, $fallbackSrc, $alt = '', $classes = '') {
        $html = "<picture class=\"lazy-picture $classes\">\n";
        
        foreach ($sources as $source) {
            $media = isset($source['media']) ? " media=\"{$source['media']}\"" : '';
            $html .= "    <source data-srcset=\"{$source['srcset']}\"$media>\n";
        }
        
        $html .= "    <img data-src=\"$fallbackSrc\" alt=\"$alt\" class=\"lazy\">\n";
        $html .= "</picture>";
        
        return $html;
    }
    
    /**
     * JavaScript懒加载实现
     */
    public static function getLazyLoadScript() {
        return '
<script>
document.addEventListener("DOMContentLoaded", function() {
    // 图片懒加载
    const lazyImages = [].slice.call(document.querySelectorAll("img.lazy"));
    let active = false;
    
    const lazyLoad = function() {
        if (active === false) {
            active = true;
            
            setTimeout(function() {
                lazyImages.forEach(function(lazyImage) {
                    if ((lazyImage.getBoundingClientRect().top <= window.innerHeight && 
                         lazyImage.getBoundingClientRect().bottom >= 0) && 
                         getComputedStyle(lazyImage).display !== "none") {
                        
                        if (lazyImage.dataset.src) {
                            lazyImage.src = lazyImage.dataset.src;
                            lazyImage.removeAttribute("data-src");
                        }
                        
                        if (lazyImage.dataset.srcset) {
                            lazyImage.srcset = lazyImage.dataset.srcset;
                            lazyImage.removeAttribute("data-srcset");
                        }
                        
                        lazyImage.classList.remove("lazy");
                        
                        if (lazyImages.length === 0) {
                            document.removeEventListener("scroll", lazyLoad);
                            window.removeEventListener("resize", lazyLoad);
                            window.removeEventListener("orientationchange", lazyLoad);
                        }
                    }
                });
                
                active = false;
            }, 200);
        }
    };
    
    // 初始化
    lazyLoad();
    
    // 绑定事件
    document.addEventListener("scroll", lazyLoad);
    window.addEventListener("resize", lazyLoad);
    window.addEventListener("orientationchange", lazyLoad);
});
</script>';
    }
    
    /**
     * Intersection Observer API实现的懒加载
     */
    public static function getIntersectionObserverScript() {
        return '
<script>
document.addEventListener("DOMContentLoaded", function() {
    if ("IntersectionObserver" in window) {
        const imageObserver = new IntersectionObserver(function(entries, observer) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    const lazyImage = entry.target;
                    
                    if (lazyImage.dataset.src) {
                        lazyImage.src = lazyImage.dataset.src;
                        lazyImage.removeAttribute("data-src");
                    }
                    
                    if (lazyImage.dataset.srcset) {
                        lazyImage.srcset = lazyImage.dataset.srcset;
                        lazyImage.removeAttribute("data-srcset");
                    }
                    
                    lazyImage.classList.remove("lazy");
                    imageObserver.unobserve(lazyImage);
                }
            });
        });
        
        document.querySelectorAll("img.lazy").forEach(function(image) {
            imageObserver.observe(image);
        });
    } else {
        // 降级到传统懒加载
        // ... 传统实现代码 ...
    }
});
</script>';
    }
    
    /**
     * 组件懒加载
     */
    public static function lazyComponent($componentName, $placeholder = 'Loading...', $classes = '') {
        return "<div class=\"lazy-component $classes\" data-component=\"$componentName\">$placeholder</div>";
    }
    
    /**
     * 组件懒加载JavaScript
     */
    public static function getLazyComponentScript() {
        return '
<script>
document.addEventListener("DOMContentLoaded", function() {
    const lazyComponents = document.querySelectorAll(".lazy-component");
    
    const componentObserver = new IntersectionObserver(function(entries, observer) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                const component = entry.target;
                const componentName = component.dataset.component;
                
                // 动态加载组件
                loadComponent(componentName, component);
                componentObserver.unobserve(component);
            }
        });
    });
    
    lazyComponents.forEach(function(component) {
        componentObserver.observe(component);
    });
    
    function loadComponent(componentName, container) {
        // 这里可以使用fetch或其他方法动态加载组件内容
        fetch("/components/" + componentName + ".html")
            .then(response => response.text())
            .then(html => {
                container.innerHTML = html;
            })
            .catch(error => {
                container.innerHTML = "Failed to load component";
                console.error("Component load error:", error);
            });
    }
});
</script>';
    }
}

// 使用示例
// echo LazyLoader::lazyImage('/images/large-banner.jpg', 'Banner Image', 'banner');
// echo LazyLoader::getLazyLoadScript();
?>
```

### 内联关键资源

内联关键CSS和小型JavaScript可以减少首屏渲染所需的HTTP请求。

```php
<?php
/**
 * 关键资源内联工具类
 */
class CriticalResourceInliner {
    
    /**
     * 内联CSS
     */
    public static function inlineCriticalCSS($cssFiles, $maxSize = 14000) {
        $criticalCSS = '';
        $totalSize = 0;
        
        foreach ($cssFiles as $file) {
            if (file_exists($file)) {
                $css = file_get_contents($file);
                $cssSize = strlen($css);
                
                if ($totalSize + $cssSize <= $maxSize) {
                    $criticalCSS .= "/* $file */\n" . $css . "\n\n";
                    $totalSize += $cssSize;
                } else {
                    // 如果超过限制，只内联部分内容
                    $remainingSpace = $maxSize - $totalSize;
                    if ($remainingSpace > 0) {
                        $partialCSS = substr($css, 0, $remainingSpace);
                        $criticalCSS .= "/* Partial: $file */\n" . $partialCSS . "\n\n";
                    }
                    break;
                }
            }
        }
        
        return "<style>\n$criticalCSS</style>";
    }
    
    /**
     * 内联JavaScript
     */
    public static function inlineCriticalJS($jsFiles, $maxSize = 14000) {
        $criticalJS = '';
        $totalSize = 0;
        
        foreach ($jsFiles as $file) {
            if (file_exists($file)) {
                $js = file_get_contents($file);
                $jsSize = strlen($js);
                
                if ($totalSize + $jsSize <= $maxSize) {
                    $criticalJS .= "/* $file */\n" . $js . "\n\n";
                    $totalSize += $jsSize;
                } else {
                    break;
                }
            }
        }
        
        return "<script>\n$criticalJS</script>";
    }
    
    /**
     * SVG图标内联
     */
    public static function inlineSVGIcon($svgFile, $id = null, $classes = '') {
        if (!file_exists($svgFile)) {
            return '';
        }
        
        $svgContent = file_get_contents($svgFile);
        
        // 移除外层svg标签的xmlns声明（如果已在外层声明）
        $svgContent = preg_replace('/<svg[^>]*>/', '<svg' . ($id ? ' id="' . $id . '"' : '') . 
                                  ($classes ? ' class="' . $classes . '"' : '') . '>', $svgContent, 1);
        
        return $svgContent;
    }
    
    /**
     * 生成关键资源内联模板
     */
    public static function generateInlineTemplate($config) {
        $template = "<!DOCTYPE html>\n<html>\n<head>\n";
        $template .= "    <meta charset=\"UTF-8\">\n";
        $template .= "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n";
        $template .= "    <title>{$config['title']}</title>\n";
        
        // 内联关键CSS
        if (isset($config['critical_css'])) {
            $template .= "    " . self::inlineCriticalCSS($config['critical_css']) . "\n";
        }
        
        // 预加载非关键资源
        if (isset($config['preload'])) {
            foreach ($config['preload'] as $resource) {
                $as = pathinfo($resource, PATHINFO_EXTENSION);
                $asMap = [
                    'css' => 'style',
                    'js' => 'script',
                    'png' => 'image',
                    'jpg' => 'image',
                    'jpeg' => 'image',
                    'webp' => 'image',
                    'woff' => 'font',
                    'woff2' => 'font'
                ];
                $asType = $asMap[$as] ?? 'fetch';
                $template .= "    <link rel=\"preload\" href=\"$resource\" as=\"$asType\">\n";
            }
        }
        
        $template .= "</head>\n<body>\n";
        
        // 页面内容
        $template .= $config['content'] ?? '';
        
        // 内联关键JavaScript
        if (isset($config['critical_js'])) {
            $template .= "    " . self::inlineCriticalJS($config['critical_js']) . "\n";
        }
        
        // 异步加载非关键JavaScript
        if (isset($config['async_js'])) {
            foreach ($config['async_js'] as $js) {
                $template .= "    <script src=\"$js\" async></script>\n";
            }
        }
        
        $template .= "</body>\n</html>";
        
        return $template;
    }
}

// 使用示例
// $config = [
//     'title' => 'My Website',
//     'critical_css' => ['css/critical.css', 'css/header.css'],
//     'preload' => ['css/main.css', 'js/app.js', 'fonts/main.woff2'],
//     'critical_js' => ['js/polyfills.js'],
//     'async_js' => ['js/analytics.js', 'js/social.js'],
//     'content' => '<h1>Welcome</h1><p>This is my website</p>'
// ];
// 
// echo CriticalResourceInliner::generateInlineTemplate($config);
?>
```

### 域名分片技术

域名分片可以并行下载多个资源，突破浏览器对同一域名的并发连接限制。

```php
<?php
/**
 * 域名分片工具类
 */
class DomainSharding {
    
    private $domains;
    private $counter = 0;
    
    public function __construct($domains) {
        $this->domains = $domains;
    }
    
    /**
     * 获取分片域名
     */
    public function getShardDomain() {
        $domain = $this->domains[$this->counter % count($this->domains)];
        $this->counter++;
        return $domain;
    }
    
    /**
     * 生成分片资源URL
     */
    public function shardAsset($path) {
        $domain = $this->getShardDomain();
        return "//$domain" . $path;
    }
    
    /**
     * 批量生成分片资源URL
     */
    public function shardAssets($paths) {
        $sharded = [];
        foreach ($paths as $path) {
            $sharded[] = $this->shardAsset($path);
        }
        return $sharded;
    }
    
    /**
     * HTML标签生成器
     */
    public function cssTag($path, $attributes = []) {
        $url = $this->shardAsset($path);
        $attrString = $this->buildAttributes($attributes);
        return "<link rel=\"stylesheet\" href=\"$url\"$attrString>";
    }
    
    public function jsTag($path, $attributes = []) {
        $url = $this->shardAsset($path);
        $attrString = $this->buildAttributes($attributes);
        return "<script src=\"$url\"$attrString></script>";
    }
    
    public function imgTag($path, $attributes = []) {
        $url = $this->shardAsset($path);
        $attrString = $this->buildAttributes($attributes);
        return "<img src=\"$url\"$attrString>";
    }
    
    private function buildAttributes($attributes) {
        $attrs = '';
        foreach ($attributes as $key => $value) {
            $attrs .= " $key=\"" . htmlspecialchars($value) . "\"";
        }
        return $attrs;
    }
    
    /**
     * 配置示例
     */
    public static function getNginxConfig($domains) {
        $config = "# 域名分片配置\n";
        foreach ($domains as $domain) {
            $config .= "server {\n";
            $config .= "    listen 80;\n";
            $config .= "    server_name $domain;\n";
            $config .= "    root /var/www/static;\n";
            $config .= "    # 其他配置...\n";
            $config .= "}\n\n";
        }
        return $config;
    }
}

// 使用示例
// $sharding = new DomainSharding(['static1.example.com', 'static2.example.com', 'static3.example.com']);
// 
// echo $sharding->cssTag('/css/style.css');
// echo $sharding->jsTag('/js/app.js');
// echo $sharding->imgTag('/images/logo.png');
?>
```

### 预加载技术

预加载技术可以提前加载用户可能需要的资源，提升用户体验。

```php
<?php
/**
 * 预加载技术实现类
 */
class Preloader {
    
    /**
     * DNS预解析
     */
    public static function dnsPrefetch($domains) {
        $links = '';
        foreach ($domains as $domain) {
            $links .= "<link rel=\"dns-prefetch\" href=\"//$domain\">\n";
        }
        return $links;
    }
    
    /**
     * 预连接
     */
    public static function preconnect($urls) {
        $links = '';
        foreach ($urls as $url) {
            $links .= "<link rel=\"preconnect\" href=\"$url\">\n";
        }
        return $links;
    }
    
    /**
     * 预加载
     */
    public static function preload($resources) {
        $links = '';
        foreach ($resources as $resource) {
            $as = self::getResourceType($resource['url']);
            $type = $resource['type'] ?? '';
            $crossorigin = $resource['crossorigin'] ?? false;
            
            $link = "<link rel=\"preload\" href=\"{$resource['url']}\" as=\"$as\"";
            if ($type) {
                $link .= " type=\"$type\"";
            }
            if ($crossorigin) {
                $link .= " crossorigin";
            }
            $link .= ">\n";
            
            $links .= $link;
        }
        return $links;
    }
    
    /**
     * 预获取
     */
    public static function prefetch($urls) {
        $links = '';
        foreach ($urls as $url) {
            $links .= "<link rel=\"prefetch\" href=\"$url\">\n";
        }
        return $links;
    }
    
    /**
     * 预渲染
     */
    public static function prerender($urls) {
        $links = '';
        foreach ($urls as $url) {
            $links .= "<link rel=\"prerender\" href=\"$url\">\n";
        }
        return $links;
    }
    
    private static function getResourceType($url) {
        $extension = pathinfo($url, PATHINFO_EXTENSION);
        $typeMap = [
            'css' => 'style',
            'js' => 'script',
            'png' => 'image',
            'jpg' => 'image',
            'jpeg' => 'image',
            'gif' => 'image',
            'svg' => 'image',
            'webp' => 'image',
            'woff' => 'font',
            'woff2' => 'font',
            'ttf' => 'font',
            'eot' => 'font',
            'html' => 'document'
        ];
        return $typeMap[$extension] ?? 'fetch';
    }
    
    /**
     * 智能预加载
     */
    public static function smartPreload($currentPage, $navigationMap) {
        $preloadResources = [];
        
        if (isset($navigationMap[$currentPage])) {
            foreach ($navigationMap[$currentPage] as $nextPage => $resources) {
                $preloadResources = array_merge($preloadResources, $resources);
            }
        }
        
        return self::preload(array_unique($preloadResources));
    }
    
    /**
     * JavaScript预加载实现
     */
    public static function getPreloadScript() {
        return '
<script>
// 智能预加载
document.addEventListener("mouseover", function(e) {
    const link = e.target.closest("a[href]");
    if (link && link.href) {
        // 预加载链接指向的页面资源
        const preloadLink = document.createElement("link");
        preloadLink.rel = "prefetch";
        preloadLink.href = link.href;
        document.head.appendChild(preloadLink);
    }
});

// 滚动预加载
let preloadThreshold = 0.5;
const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.intersectionRatio >= preloadThreshold) {
            const element = entry.target;
            const preloadSrc = element.dataset.preload;
            if (preloadSrc) {
                // 预加载图片或其他资源
                const img = new Image();
                img.src = preloadSrc;
                element.removeAttribute("data-preload");
            }
        }
    });
}, { threshold: preloadThreshold });

// 观察需要预加载的元素
document.querySelectorAll("[data-preload]").forEach(el => {
    observer.observe(el);
});
</script>';
    }
}

// 使用示例
// echo Preloader::dnsPrefetch(['fonts.googleapis.com', 'ajax.googleapis.com']);
// echo Preloader::preconnect(['https://fonts.gstatic.com']);
// echo Preloader::preload([
//     ['url' => '/css/main.css', 'type' => 'text/css'],
//     ['url' => '/js/app.js', 'type' => 'application/javascript'],
//     ['url' => '/fonts/main.woff2', 'type' => 'font/woff2', 'crossorigin' => true]
// ]);
?>
```

### HTTP请求优化最佳实践

1. **资源合并**：
   - 合并CSS和JavaScript文件减少请求数量
   - 使用CSS Sprites合并小图片
   - 合理分组资源避免单个文件过大

2. **缓存策略**：
   - 为静态资源设置长期缓存
   - 使用版本号或内容哈希实现缓存刷新
   - 合理设置ETag和Last-Modified头

3. **延迟加载**：
   - 实现图片懒加载减少初始资源加载
   - 按需加载组件和功能模块
   - 使用Intersection Observer API提升性能

4. **内联关键资源**：
   - 内联首屏必需的CSS和JavaScript
   - 预加载非关键资源
   - 使用async/defer属性优化JavaScript加载

5. **域名分片**：
   - 合理使用2-4个分片域名
   - 避免过多分片增加DNS解析开销
   - 考虑HTTP/2的多路复用特性

6. **预加载技术**：
   - 使用DNS预解析加速域名解析
   - 预连接到重要第三方资源
   - 预加载关键资源提升用户体验

### 总结

减少HTTP请求次数是Web性能优化的核心策略，通过资源合并、缓存优化、延迟加载、内联关键资源、域名分片和预加载等技术手段，可以显著提升页面加载速度和用户体验。在实际应用中，需要根据具体场景选择合适的优化策略，并持续监控和改进性能表现。