
Pod::Spec.new do |spec|

  spec.name         = "MapCode"
  spec.version      = "0.0.2"
  spec.summary      = "Third party map in app."
  spec.description  = "There is no need to integrate the third party map, and then turn up the third party map."
  spec.homepage     = "https://github.com/KaiserFighting/MapCode"
  spec.license      = "MIT"
  spec.author             = { "kaiserfighting" => "18192504529@163.com" }
  spec.source       = { :git => "https://github.com/KaiserFighting/MapCode.git", :commit => "1db1587",:tag => spec.version }
  spec.source_files  = "MapCode/Manager/*.{h,m}"
  spec.requires_arc = true
  spec.ios.deployment_target = "9.0"
  
end
