# 前端资源压缩和CDN加速的实现？

## 概要回答

前端资源压缩和CDN加速是提升Web应用性能的重要手段，实现方法包括：

1. **资源压缩**：
   - CSS/JS文件压缩(minify)
   - 图片优化和压缩
   - Gzip/Brotli压缩传输
   - 文件合并减少HTTP请求

2. **CDN加速**：
   - 静态资源托管到CDN节点
   - 智能DNS解析就近访问
   - 缓存策略配置
   - HTTPS支持和安全防护

3. **构建工具**：
   - 使用Webpack、Gulp等工具自动化压缩
   - 配置资源版本控制和缓存刷新

## 深度解析

### 资源压缩技术

#### CSS/JS文件压缩

CSS和JavaScript文件压缩是前端性能优化的基础，可以通过移除空白字符、注释和简化代码来减小文件大小。

```php
<?php
/**
 * CSS/JS压缩工具类
 */
class ResourceMinifier {
    
    /**
     * CSS压缩
     */
    public static function minifyCSS($css) {
        // 移除注释
        $css = preg_replace('!/\*[^*]*\*+([^/][^*]*\*+)*/!', '', $css);
        
        // 移除多余空白
        $css = preg_replace('/\s+/', ' ', $css);
        
        // 移除分号前的空白
        $css = preg_replace('/\s*([{}:;,])\s*/', '$1', $css);
        
        // 移除大括号前的空白
        $css = preg_replace('/\s*([{}])\s*/', '$1', $css);
        
        // 移除多余的分号
        $css = preg_replace('/;}/', '}', $css);
        
        return trim($css);
    }
    
    /**
     * JavaScript压缩
     */
    public static function minifyJS($js) {
        // 移除单行注释
        $js = preg_replace('!/\*[^*]*\*+([^/][^*]*\*+)*/!', '', $js);
        
        // 移除多行注释
        $js = preg_replace('!//.*!', '', $js);
        
        // 移除多余空白
        $js = preg_replace('/\s+/', ' ', $js);
        
        // 移除分号和逗号前后的空白
        $js = preg_replace('/\s*([{}();,:])\s*/', '$1', $js);
        
        return trim($js);
    }
    
    /**
     * 文件压缩
     */
    public static function minifyFile($inputFile, $outputFile = null) {
        if (!file_exists($inputFile)) {
            throw new Exception("文件不存在: $inputFile");
        }
        
        $content = file_get_contents($inputFile);
        $extension = pathinfo($inputFile, PATHINFO_EXTENSION);
        
        if ($extension === 'css') {
            $minified = self::minifyCSS($content);
        } elseif ($extension === 'js') {
            $minified = self::minifyJS($content);
        } else {
            throw new Exception("不支持的文件类型: $extension");
        }
        
        $outputFile = $outputFile ?: str_replace('.', '.min.', $inputFile);
        file_put_contents($outputFile, $minified);
        
        return $outputFile;
    }
    
    /**
     * 批量压缩目录中的文件
     */
    public static function minifyDirectory($sourceDir, $targetDir = null) {
        $targetDir = $targetDir ?: $sourceDir . '/minified';
        
        if (!is_dir($targetDir)) {
            mkdir($targetDir, 0755, true);
        }
        
        $files = glob($sourceDir . '/*.{css,js}', GLOB_BRACE);
        $results = [];
        
        foreach ($files as $file) {
            $filename = basename($file);
            $targetFile = $targetDir . '/' . str_replace('.', '.min.', $filename);
            
            try {
                self::minifyFile($file, $targetFile);
                $results[] = [
                    'source' => $file,
                    'target' => $targetFile,
                    'saved' => filesize($file) - filesize($targetFile)
                ];
            } catch (Exception $e) {
                $results[] = [
                    'source' => $file,
                    'error' => $e->getMessage()
                ];
            }
        }
        
        return $results;
    }
}

// 使用示例
// $results = ResourceMinifier::minifyDirectory('./assets/css');
// print_r($results);
?>
```

#### 图片优化和压缩

图片通常是网页中最大的资源，优化图片可以显著提升加载速度。

```php
<?php
/**
 * 图片优化工具类
 */
class ImageOptimizer {
    
    /**
     * JPEG图片压缩
     */
    public static function compressJPEG($source, $target, $quality = 80) {
        if (!extension_loaded('gd')) {
            throw new Exception("GD扩展未安装");
        }
        
        $image = imagecreatefromjpeg($source);
        imagejpeg($image, $target, $quality);
        imagedestroy($image);
        
        return filesize($target);
    }
    
    /**
     * PNG图片压缩
     */
    public static function compressPNG($source, $target, $compression = 6) {
        if (!extension_loaded('gd')) {
            throw new Exception("GD扩展未安装");
        }
        
        $image = imagecreatefrompng($source);
        imagealphablending($image, false);
        imagesavealpha($image, true);
        imagepng($image, $target, $compression);
        imagedestroy($image);
        
        return filesize($target);
    }
    
    /**
     * WebP格式转换
     */
    public static function convertToWebP($source, $target, $quality = 80) {
        if (!extension_loaded('imagick') && !function_exists('imagecreatefromjpeg')) {
            throw new Exception("缺少图像处理扩展");
        }
        
        // 使用Imagick扩展
        if (extension_loaded('imagick')) {
            $imagick = new Imagick($source);
            $imagick->setImageFormat('webp');
            $imagick->setImageCompressionQuality($quality);
            $imagick->writeImage($target);
            $imagick->destroy();
        } 
        // 使用GD扩展
        elseif (function_exists('imagecreatefromjpeg')) {
            $image = imagecreatefromjpeg($source);
            imagewebp($image, $target, $quality);
            imagedestroy($image);
        }
        
        return filesize($target);
    }
    
    /**
     * 批量优化图片
     */
    public static function optimizeImages($sourceDir, $targetDir = null, $options = []) {
        $targetDir = $targetDir ?: $sourceDir . '/optimized';
        $options = array_merge([
            'jpeg_quality' => 80,
            'png_compression' => 6,
            'convert_to_webp' => false,
            'max_width' => 1920,
            'max_height' => 1080
        ], $options);
        
        if (!is_dir($targetDir)) {
            mkdir($targetDir, 0755, true);
        }
        
        $images = glob($sourceDir . '/*.{jpg,jpeg,png}', GLOB_BRACE);
        $results = [];
        
        foreach ($images as $image) {
            $filename = basename($image);
            $extension = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
            $targetFile = $targetDir . '/' . $filename;
            
            try {
                // 调整图片尺寸
                $resized = self::resizeImage($image, $targetDir . '/temp_' . $filename, 
                                           $options['max_width'], $options['max_height']);
                
                // 压缩图片
                if ($extension === 'jpg' || $extension === 'jpeg') {
                    self::compressJPEG($resized, $targetFile, $options['jpeg_quality']);
                } elseif ($extension === 'png') {
                    self::compressPNG($resized, $targetFile, $options['png_compression']);
                }
                
                // 转换为WebP格式
                if ($options['convert_to_webp']) {
                    $webpFile = str_replace('.' . $extension, '.webp', $targetFile);
                    self::convertToWebP($resized, $webpFile, $options['jpeg_quality']);
                }
                
                // 清理临时文件
                unlink($resized);
                
                $results[] = [
                    'source' => $image,
                    'target' => $targetFile,
                    'saved' => filesize($image) - filesize($targetFile),
                    'original_size' => filesize($image),
                    'compressed_size' => filesize($targetFile)
                ];
            } catch (Exception $e) {
                $results[] = [
                    'source' => $image,
                    'error' => $e->getMessage()
                ];
            }
        }
        
        return $results;
    }
    
    /**
     * 调整图片尺寸
     */
    private static function resizeImage($source, $target, $maxWidth, $maxHeight) {
        list($width, $height, $type) = getimagesize($source);
        
        // 计算新尺寸
        $ratio = min($maxWidth / $width, $maxHeight / $height);
        if ($ratio >= 1) {
            // 图片小于最大尺寸，直接复制
            copy($source, $target);
            return $target;
        }
        
        $newWidth = intval($width * $ratio);
        $newHeight = intval($height * $ratio);
        
        // 创建新图片
        $srcImage = imagecreatefromstring(file_get_contents($source));
        $dstImage = imagecreatetruecolor($newWidth, $newHeight);
        
        // 保持透明度
        if ($type === IMAGETYPE_PNG) {
            imagealphablending($dstImage, false);
            imagesavealpha($dstImage, true);
            $transparent = imagecolorallocatealpha($dstImage, 255, 255, 255, 127);
            imagefilledrectangle($dstImage, 0, 0, $newWidth, $newHeight, $transparent);
        }
        
        // 重采样
        imagecopyresampled($dstImage, $srcImage, 0, 0, 0, 0, $newWidth, $newHeight, $width, $height);
        
        // 保存图片
        switch ($type) {
            case IMAGETYPE_JPEG:
                imagejpeg($dstImage, $target, 90);
                break;
            case IMAGETYPE_PNG:
                imagepng($dstImage, $target, 6);
                break;
        }
        
        imagedestroy($srcImage);
        imagedestroy($dstImage);
        
        return $target;
    }
}

// 使用示例
// $results = ImageOptimizer::optimizeImages('./assets/images', './assets/images/optimized', [
//     'jpeg_quality' => 75,
//     'convert_to_webp' => true
// ]);
// print_r($results);
?>
```

#### Gzip/Brotli压缩

服务器端压缩可以显著减少传输数据量。

```php
<?php
/**
 * 服务器端压缩配置示例
 */
class ServerCompression {
    
    /**
     * 检查并启用Gzip压缩
     */
    public static function enableGzipCompression() {
        // 检查是否已启用
        if (ob_get_level() > 0 && ob_get_length() > 0) {
            return false;
        }
        
        // 检查客户端是否支持gzip
        if (!isset($_SERVER['HTTP_ACCEPT_ENCODING']) || 
            strpos($_SERVER['HTTP_ACCEPT_ENCODING'], 'gzip') === false) {
            return false;
        }
        
        // 启用gzip压缩
        if (function_exists('ob_gzhandler')) {
            ob_start('ob_gzhandler');
            return true;
        }
        
        return false;
    }
    
    /**
     * 手动gzip压缩输出
     */
    public static function manualGzipOutput($content) {
        if (isset($_SERVER['HTTP_ACCEPT_ENCODING']) && 
            strpos($_SERVER['HTTP_ACCEPT_ENCODING'], 'gzip') !== false) {
            
            $compressed = gzencode($content, 6);
            if ($compressed !== false) {
                header('Content-Encoding: gzip');
                header('Vary: Accept-Encoding');
                header('Content-Length: ' . strlen($compressed));
                return $compressed;
            }
        }
        
        return $content;
    }
    
    /**
     * Apache .htaccess配置示例
     */
    public static function getApacheConfig() {
        return '
# 启用gzip压缩
<IfModule mod_deflate.c>
    # 压缩HTML, CSS, JavaScript, XML等
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
    AddOutputFilterByType DEFLATE application/json
</IfModule>

# 启用Brotli压缩（如果支持）
<IfModule mod_brotli.c>
    AddOutputFilterByType BROTLI_COMPRESS text/plain
    AddOutputFilterByType BROTLI_COMPRESS text/html
    AddOutputFilterByType BROTLI_COMPRESS text/xml
    AddOutputFilterByType BROTLI_COMPRESS text/css
    AddOutputFilterByType BROTLI_COMPRESS application/xml
    AddOutputFilterByType BROTLI_COMPRESS application/xhtml+xml
    AddOutputFilterByType BROTLI_COMPRESS application/rss+xml
    AddOutputFilterByType BROTLI_COMPRESS application/javascript
    AddOutputFilterByType BROTLI_COMPRESS application/x-javascript
    AddOutputFilterByType BROTLI_COMPRESS application/json
</IfModule>

# 设置缓存头
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
    ExpiresByType image/webp "access plus 1 year"
</IfModule>';
    }
    
    /**
     * Nginx配置示例
     */
    public static function getNginxConfig() {
        return '
# 启用gzip压缩
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_comp_level 6;
gzip_types
    text/plain
    text/css
    text/xml
    text/javascript
    application/javascript
    application/json
    application/xml
    application/xhtml+xml;

# 启用Brotli压缩
brotli on;
brotli_comp_level 6;
brotli_types
    text/plain
    text/css
    text/xml
    text/javascript
    application/javascript
    application/json
    application/xml
    application/xhtml+xml;

# 设置静态资源缓存
location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|webp)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}';
    }
}

// 使用示例
// if (ServerCompression::enableGzipCompression()) {
//     echo "Gzip压缩已启用";
// }
?>
```

### CDN加速实现

CDN通过在全球分布的节点缓存静态资源，让用户从最近的节点获取资源，从而提升访问速度。

```php
<?php
/**
 * CDN集成工具类
 */
class CDNManager {
    
    private $cdnUrl;
    private $staticDomain;
    private $version;
    
    public function __construct($cdnUrl, $staticDomain = null, $version = null) {
        $this->cdnUrl = rtrim($cdnUrl, '/');
        $this->staticDomain = $staticDomain ?: $_SERVER['HTTP_HOST'] ?? 'localhost';
        $this->version = $version ?: time();
    }
    
    /**
     * 生成CDN资源URL
     */
    public function asset($path, $versioned = true) {
        $path = ltrim($path, '/');
        
        // 如果是绝对URL，直接返回
        if (parse_url($path, PHP_URL_SCHEME)) {
            return $path;
        }
        
        // 添加版本号
        if ($versioned) {
            $path .= (strpos($path, '?') !== false ? '&' : '?') . 'v=' . $this->version;
        }
        
        return $this->cdnUrl . '/' . $path;
    }
    
    /**
     * 批量上传资源到CDN
     */
    public function uploadAssets($localDir, $remoteDir = '') {
        $files = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($localDir, RecursiveDirectoryIterator::SKIP_DOTS)
        );
        
        $uploaded = [];
        foreach ($files as $file) {
            if ($file->isFile()) {
                $relativePath = str_replace($localDir, '', $file->getPathname());
                $remotePath = $remoteDir . $relativePath;
                
                // 上传到CDN（这里使用模拟实现）
                $result = $this->uploadToCDN($file->getPathname(), $remotePath);
                if ($result) {
                    $uploaded[] = [
                        'local' => $file->getPathname(),
                        'remote' => $remotePath,
                        'url' => $this->asset($remotePath)
                    ];
                }
            }
        }
        
        return $uploaded;
    }
    
    /**
     * 模拟上传到CDN
     */
    private function uploadToCDN($localPath, $remotePath) {
        // 实际实现中这里会调用CDN提供商的API
        // 例如阿里云OSS、腾讯云COS、AWS S3等
        
        // 模拟上传成功
        echo "上传文件: $localPath -> $remotePath\n";
        return true;
    }
    
    /**
     * 生成资源标签
     */
    public function css($path, $attributes = []) {
        $url = $this->asset($path);
        $attrString = $this->buildAttributes($attributes);
        return "<link rel=\"stylesheet\" href=\"$url\"$attrString>";
    }
    
    public function js($path, $attributes = []) {
        $url = $this->asset($path);
        $attrString = $this->buildAttributes($attributes);
        return "<script src=\"$url\"$attrString></script>";
    }
    
    public function img($path, $attributes = []) {
        $url = $this->asset($path);
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
     * 清除CDN缓存
     */
    public function purgeCache($paths) {
        if (!is_array($paths)) {
            $paths = [$paths];
        }
        
        $purged = [];
        foreach ($paths as $path) {
            $fullUrl = $this->asset($path, false);
            // 调用CDN提供商的清除缓存API
            $result = $this->callCDNPurgeAPI($fullUrl);
            $purged[] = [
                'url' => $fullUrl,
                'success' => $result
            ];
        }
        
        return $purged;
    }
    
    private function callCDNPurgeAPI($url) {
        // 实际实现中这里会调用CDN提供商的API
        // 模拟清除缓存成功
        echo "清除缓存: $url\n";
        return true;
    }
}

// 使用示例
// $cdn = new CDNManager('https://cdn.example.com', 'static.example.com', '1.2.3');
// echo $cdn->css('/css/style.css');
// echo $cdn->js('/js/app.js');
// echo $cdn->img('/images/logo.png', ['alt' => 'Logo']);
?>
```

### 构建工具集成

现代化的前端构建工具可以自动化完成资源压缩和优化工作。

```php
<?php
/**
 * 前端构建工具集成示例
 */
class BuildToolsIntegration {
    
    /**
     * Webpack配置示例
     */
    public static function getWebpackConfig() {
        return 'const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const TerserPlugin = require("terser-webpack-plugin");

module.exports = {
    entry: "./src/index.js",
    output: {
        path: path.resolve(__dirname, "dist"),
        filename: "js/[name].[contenthash].js",
        clean: true
    },
    module: {
        rules: [
            {
                test: /\.css$/,
                use: [MiniCssExtractPlugin.loader, "css-loader"]
            },
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: "babel-loader",
                    options: {
                        presets: ["@babel/preset-env"]
                    }
                }
            }
        ]
    },
    plugins: [
        new MiniCssExtractPlugin({
            filename: "css/[name].[contenthash].css"
        })
    ],
    optimization: {
        minimizer: [
            new CssMinimizerPlugin(),
            new TerserPlugin({
                terserOptions: {
                    compress: {
                        drop_console: true,
                        drop_debugger: true
                    }
                }
            })
        ],
        splitChunks: {
            chunks: "all",
            cacheGroups: {
                vendor: {
                    test: /[\\/]node_modules[\\/]/,
                    name: "vendors",
                    chunks: "all"
                }
            }
        }
    }
};';
    }
    
    /**
     * Gulp配置示例
     */
    public static function getGulpConfig() {
        return 'const gulp = require("gulp");
const uglify = require("gulp-uglify");
const cleanCSS = require("gulp-clean-css");
const imagemin = require("gulp-imagemin");
const rename = require("gulp-rename");
const rev = require("gulp-rev");
const revReplace = require("gulp-rev-replace");

// 压缩JavaScript
gulp.task("js", function() {
    return gulp.src("src/js/**/*.js")
        .pipe(uglify())
        .pipe(rename({suffix: ".min"}))
        .pipe(gulp.dest("dist/js"));
});

// 压缩CSS
gulp.task("css", function() {
    return gulp.src("src/css/**/*.css")
        .pipe(cleanCSS())
        .pipe(rename({suffix: ".min"}))
        .pipe(gulp.dest("dist/css"));
});

// 压缩图片
gulp.task("images", function() {
    return gulp.src("src/images/**/*")
        .pipe(imagemin([
            imagemin.gifsicle({interlaced: true}),
            imagemin.mozjpeg({quality: 75, progressive: true}),
            imagemin.optipng({optimizationLevel: 5}),
            imagemin.svgo({
                plugins: [
                    {removeViewBox: true},
                    {cleanupIDs: false}
                ]
            })
        ]))
        .pipe(gulp.dest("dist/images"));
});

// 添加版本号
gulp.task("rev", function() {
    return gulp.src(["dist/**/*.css", "dist/**/*.js"])
        .pipe(rev())
        .pipe(gulp.dest("dist"))
        .pipe(rev.manifest())
        .pipe(gulp.dest("dist"));
});

// 替换引用
gulp.task("revreplace", function() {
    const manifest = gulp.src("dist/rev-manifest.json");
    return gulp.src("src/**/*.html")
        .pipe(revReplace({manifest: manifest}))
        .pipe(gulp.dest("dist"));
});

gulp.task("default", gulp.series("js", "css", "images", "rev", "revreplace"));';
    }
    
    /**
     * 版本控制和缓存刷新
     */
    public static function getVersionManifest() {
        $manifest = [
            'css/app.css' => 'css/app.a1b2c3d4.css',
            'js/app.js' => 'js/app.e5f6g7h8.js',
            'js/vendor.js' => 'js/vendor.i9j0k1l2.js',
            'images/logo.png' => 'images/logo.m3n4o5p6.png'
        ];
        
        return json_encode($manifest, JSON_PRETTY_PRINT);
    }
    
    /**
     * 资源版本化助手
     */
    public static function assetWithVersion($path, $manifestFile = 'rev-manifest.json') {
        static $manifest = null;
        
        if ($manifest === null && file_exists($manifestFile)) {
            $manifest = json_decode(file_get_contents($manifestFile), true);
        }
        
        $versionedPath = $manifest[$path] ?? $path;
        return '/assets/' . $versionedPath;
    }
}

// 使用示例
// echo '<link rel="stylesheet" href="' . BuildToolsIntegration::assetWithVersion('css/app.css') . '">';
// echo '<script src="' . BuildToolsIntegration::assetWithVersion('js/app.js') . '"></script>';
?>
```

### CDN提供商集成示例

```php
<?php
/**
 * 主流CDN提供商集成示例
 */
abstract class CDNProvider {
    abstract public function upload($localPath, $remotePath);
    abstract public function purge($urls);
    abstract public function getUrl($path);
}

/**
 * 阿里云CDN集成
 */
class AliyunCDN extends CDNProvider {
    private $accessKeyId;
    private $accessKeySecret;
    private $domain;
    
    public function __construct($accessKeyId, $accessKeySecret, $domain) {
        $this->accessKeyId = $accessKeyId;
        $this->accessKeySecret = $accessKeySecret;
        $this->domain = $domain;
    }
    
    public function upload($localPath, $remotePath) {
        // 实现阿里云OSS上传逻辑
        // 这里仅为示例
        echo "上传到阿里云OSS: $localPath -> $remotePath\n";
        return true;
    }
    
    public function purge($urls) {
        // 实现阿里云CDN缓存刷新
        echo "刷新阿里云CDN缓存: " . implode(', ', $urls) . "\n";
        return true;
    }
    
    public function getUrl($path) {
        return "https://{$this->domain}/{$path}";
    }
}

/**
 * 腾讯云CDN集成
 */
class TencentCDN extends CDNProvider {
    private $secretId;
    private $secretKey;
    private $domain;
    
    public function __construct($secretId, $secretKey, $domain) {
        $this->secretId = $secretId;
        $this->secretKey = $secretKey;
        $this->domain = $domain;
    }
    
    public function upload($localPath, $remotePath) {
        // 实现腾讯云COS上传逻辑
        echo "上传到腾讯云COS: $localPath -> $remotePath\n";
        return true;
    }
    
    public function purge($urls) {
        // 实现腾讯云CDN缓存刷新
        echo "刷新腾讯云CDN缓存: " . implode(', ', $urls) . "\n";
        return true;
    }
    
    public function getUrl($path) {
        return "https://{$this->domain}/{$path}";
    }
}

/**
 * Cloudflare CDN集成
 */
class CloudflareCDN extends CDNProvider {
    private $apiKey;
    private $email;
    private $zoneId;
    
    public function __construct($apiKey, $email, $zoneId) {
        $this->apiKey = $apiKey;
        $this->email = $email;
        $this->zoneId = $zoneId;
    }
    
    public function upload($localPath, $remotePath) {
        // Cloudflare主要用于CDN加速，通常与其他存储服务配合使用
        echo "Cloudflare通常不直接存储文件\n";
        return false;
    }
    
    public function purge($urls) {
        // 实现Cloudflare缓存刷新API调用
        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => "https://api.cloudflare.com/client/v4/zones/{$this->zoneId}/purge_cache",
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => json_encode(['files' => $urls]),
            CURLOPT_HTTPHEADER => [
                'X-Auth-Email: ' . $this->email,
                'X-Auth-Key: ' . $this->apiKey,
                'Content-Type: application/json'
            ],
            CURLOPT_RETURNTRANSFER => true
        ]);
        
        $response = curl_exec($ch);
        curl_close($ch);
        
        $result = json_decode($response, true);
        return $result['success'] ?? false;
    }
    
    public function getUrl($path) {
        return "https://your-domain.com/{$path}";
    }
}
?>
```

### 前端资源优化最佳实践

1. **资源压缩**：
   - 使用构建工具自动化压缩CSS、JavaScript和图片
   - 启用服务器端Gzip/Brotli压缩
   - 移除未使用的代码和资源

2. **CDN部署**：
   - 将静态资源部署到CDN节点
   - 配置智能DNS解析实现就近访问
   - 设置合适的缓存策略和版本控制

3. **性能监控**：
   - 使用工具监控页面加载性能
   - 定期分析资源加载时间和大小
   - 监控CDN命中率和性能指标

4. **移动端优化**：
   - 为移动设备提供适配的图片尺寸
   - 使用响应式图片和WebP格式
   - 减少移动端不必要的资源加载

### 总结

前端资源压缩和CDN加速是提升Web应用性能的重要手段。通过合理的资源压缩策略、CDN部署和构建工具集成，可以显著减少页面加载时间，提升用户体验。关键是要建立完善的优化流程，持续监控和改进前端性能。