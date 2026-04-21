import sys
import os
from PIL import Image, ImageDraw

def create_squircle_mask(size, power=4.4):
    """创建一个指定尺寸的 squircle 遮罩。"""
    mask = Image.new('L', (size, size), 0)
    pixels = mask.load()
    half = size / 2.0
    for y in range(size):
        for x in range(size):
            nx = (x - half) / half
            ny = (y - half) / half
            # 使用超级椭圆公式
            if abs(nx)**power + abs(ny)**power <= 1.0:
                pixels[x, y] = 255
    return mask

def process_icon(path):
    if not os.path.exists(path):
        print(f"错误: 找不到文件 {path}")
        return

    print(f"🎯 正在执行动态内容感知裁剪: {path}...")
    img = Image.open(path).convert("RGBA")
    width, height = img.size
    
    # 获取当前内容的实际边界
    bbox = img.getbbox()
    if not bbox:
        print("错误: 图像似乎是全透明的。")
        return

    content_w = bbox[2] - bbox[0]
    content_h = bbox[3] - bbox[1]
    center_x = (bbox[0] + bbox[2]) / 2.0
    center_y = (bbox[1] + bbox[3]) / 2.0
    
    print(f"  检测到内容区域: {content_w}x{content_h}, 中心点: ({center_x}, {center_y})")

    # 关键步骤：为了彻底去除白边，我们将遮罩设置得比内容区域更小一些（强制修剪边缘）
    # 额外修剪比例：3%
    trim_ratio = 0.03
    mask_size = int(max(content_w, content_h) * (1.0 - trim_ratio))
    
    print(f"  应用强制修剪，最终遮罩尺寸: {mask_size}x{mask_size}")

    # 创建一个全尺寸的透明背景
    final_output = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    
    # 创建正方形 Squircle 遮罩
    squircle_mask = create_squircle_mask(mask_size)
    
    # 将遮罩放在一个全尺寸的透明层上，对齐到检测到的内容中心
    mask_canvas = Image.new('L', (width, height), 0)
    paste_x = int(center_x - mask_size / 2)
    paste_y = int(center_y - mask_size / 2)
    mask_canvas.paste(squircle_mask, (paste_x, paste_y))
    
    # 应用遮罩
    final_output.paste(img, (0, 0), mask=mask_canvas)
    
    final_output.save(path, "PNG")
    print(f"✅ 动态去白边处理完成。")

if __name__ == "__main__":
    process_icon(sys.argv[1])
