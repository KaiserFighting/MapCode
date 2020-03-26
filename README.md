# MapCode
传入经纬度和目的地跳转到百度、高德或者Apple地图，使用的是百度，腾讯和高德的URL API

备注:

1.需要导入MapKit.framework,CoreLocation.framework,

2.info.plist中添加LSApplicationQueriesSchemes->type:Arrray,里面包含
item0 -> baidumap,item1 -> iosamap,item2 -> qqmap,

3.在需要使用的地方导入#import "MapManager.h"，初始化对象就可以使用


