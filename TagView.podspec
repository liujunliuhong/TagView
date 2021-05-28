
Pod::Spec.new do |s|
  s.name             = 'TagView'
  s.version          = '2.0.0'
  s.summary          = '轻量级标签选择控件'
  s.description      = '轻量级标签选择控件，扩展性强'
  s.module_name      = 'TagView'
  s.homepage         = 'https://github.com/liujunliuhong/TagView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liujunliuhong' => '1035841713@qq.com' }
  s.source           = { :git => 'https://github.com/liujunliuhong/TagView.git', :tag => s.version.to_s }
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = 'Sources/*.swift'
end
