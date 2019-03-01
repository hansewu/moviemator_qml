var EN_CH_list = [
    {"English":"3 point color balance","Chinese":"3点色彩平衡"}
    ,{"English":"3dflippo","Chinese":"3d翻转"}
    ,{"English":"B","Chinese":"蓝色"}
    ,{"English":"Baltan","Chinese":"延迟alpha"}
    ,{"English":"BgSubtract0r","Chinese":"蓝屏静态视频背景"}
    ,{"English":"bluescreen0r","Chinese":"alpha深度"}
    ,{"English":"Brightness","Chinese":"亮度"}
    ,{"English":"bw0r","Chinese":"黑白图像"}
    ,{"English":"c0rners","Chinese":"四角几何引擎落"}
    ,{"English":"cairogradient","Chinese":"图像渐变"}
    ,{"English":"cairoimagegrid","Chinese":"图像网格"}
    ,{"English":"Cartoon","Chinese":"动画"}
    ,{"English":"Color Distance","Chinese":"色彩距离"}
    ,{"English":"coloradj_RGB","Chinese":"RGB颜色"}
    ,{"English":"colorhalftone","Chinese":"颜色半色调"}
    ,{"English":"colorize","Chinese":"上色"}
    ,{"English":"colortap","Chinese":"预调色彩"}
    ,{"English":"Contrast0r","Chinese":"对比度"}
    ,{"English":"Defish0r","Chinese":"凸透镜"}
    ,{"English":"delay0r","Chinese":"延迟"}
    ,{"English":"Delaygrab","Chinese":"映射延迟帧"}
    ,{"English":"Distort0r","Chinese":"扭曲"}
    ,{"English":"dither","Chinese":"抖动"}
    ,{"English":"Edgeglow","Chinese":"边缘发光"}
    ,{"English":"emboss","Chinese":"浮雕"}
    ,{"English":"Equaliz0r","Chinese":"均衡器"}
    ,{"English":"Flippo","Chinese":"翻转"}
    ,{"English":"G","Chinese":"绿色"}
    ,{"English":"Gamma","Chinese":"伽玛"}
    ,{"English":"Glitch0r","Chinese":"毛刺"}
    ,{"English":"Glow","Chinese":"辉光"}
    ,{"English":"hqdn3d","Chinese":"高品质3D降噪"}
    ,{"English":"Hueshift0r","Chinese":"移动色调"}
    ,{"English":"IIR blur","Chinese":"IIR模糊"}
    ,{"English":"Invert0r","Chinese":"色彩反转"}
    ,{"English":"K-Means Clustering","Chinese":"源图像簇"}
    ,{"English":"keyspillm0pup","Chinese":"消除关键色溢出"}
    ,{"English":"Lens Correction","Chinese":"镜头校正"}
    ,{"English":"LetterB0xed","Chinese":"上下黑边"}
    ,{"English":"Levels","Chinese":"通道强度"}
    ,{"English":"Light Graffiti","Chinese":"光涂鸦"}
    ,{"English":"Luminance","Chinese":"亮度映射"}
    ,{"English":"Mask0Mate","Chinese":"alpha通道蒙版"}
    ,{"English":"Medians","Chinese":"中值型过滤"}
    ,{"English":"NDVI filter","Chinese":"色彩过滤器"}
    ,{"English":"Nervous","Chinese":"及时冲洗帧"}
    ,{"English":"Nikon D90 Stairstepping fix","Chinese":"尼康D90阶梯修复"}
    ,{"English":"Normaliz0r","Chinese":"正常化"}
    ,{"English":"nosync0r","Chinese":"异步"}
    ,{"English":"pixeliz0r","Chinese":"像素化"}
    ,{"English":"posterize","Chinese":"色调分离"}
    ,{"English":"pr0be","Chinese":"测量视频值"}
    ,{"English":"pr0file","Chinese":"轮廓"}
    ,{"English":"Premultiply or Unpremultiply","Chinese":"预乘或预除"}
    ,{"English":"primaries","Chinese":"原色还原"}
    ,{"English":"R","Chinese":"红色"}
    ,{"English":"rgbnoise","Chinese":"rgb噪音"}
    ,{"English":"rgbsplit0r","Chinese":"rgb拆分"}
    ,{"English":"Saturat0r","Chinese":"饱和器"}
    ,{"English":"scanline0r","Chinese":"扫描线"}
    ,{"English":"select0r","Chinese":"选择"}
    ,{"English":"Sharpness","Chinese":"锐度"}
    ,{"English":"sigmoidaltransfer","Chinese":"影印"}
    ,{"English":"Sobel","Chinese":"索贝尔滤镜"}
    ,{"English":"softglow","Chinese":"柔光"}
    ,{"English":"SOP/Sat","Chinese":"颜色校正"}
    ,{"English":"spillsupress","Chinese":"移除溢出光"}
    ,{"English":"Squareblur","Chinese":"方形模糊"}
    ,{"English":"TehRoxx0r","Chinese":"小块闪现"}
    ,{"English":"threelay0r","Chinese":"动态3级阈值"}
    ,{"English":"Threshold0r","Chinese":"色彩阈值"}
    ,{"English":"Timeout indicator","Chinese":"超时指标"}
    ,{"English":"Tint0r","Chinese":"色调"}
    ,{"English":"Transparency","Chinese":"透明度"}
    ,{"English":"Twolay0r","Chinese":"动态阈值"}
    ,{"English":"Vertigo","Chinese":"混合光晕"}
    ,{"English":"Vignette","Chinese":"自然渐变光晕"}
    ,{"English":"White Balance","Chinese":"白平衡"}
    ,{"English":"White Balance (LMS space)","Chinese":"白平衡（LMS空间）"}
]

function transEn2Ch(strEn){
    for(var i=0;i<EN_CH_list.length;i++){
        if(strEn == EN_CH_list[i].English){
            strEn = EN_CH_list[i].Chinese
        }
    }
    return strEn
}