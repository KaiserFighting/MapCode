
Pod::Spec.new do |spec|

  spec.name         = "MapCode"
  spec.version      = "0.0.1"
  spec.summary      = "Third party map in app."
  spec.description  = "There is no need to integrate the third party map, and then turn up the third party map."
  spec.homepage     = "https://github.com/KaiserFighting"
  spec.license      = "MIT"
  spec.author             = { "kaiserfighting" => "18192504529@163.com" }
  spec.source       = { :git => "https://github.com/KaiserFighting/MapCode.git", :tag => "0.01" }
  spec.source_files  = "Mapcode/Manager/MapManager.{h,m}"
  spec.requires_arc = true
  spec.ios.deployment_target = "9.0"
  
end
