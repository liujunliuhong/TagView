
Pod::Spec.new do |s|
  s.name             = 'GLTagView'
  s.version          = '1.0.1'
  s.summary          = '轻量级标签选择控件'
  s.description      = '轻量级标签选择控件，扩展性强。采用Swift编写，兼容OC。'
  s.homepage         = 'https://github.com/liujunliuhong/TagView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liujunliuhong' => '1035841713@qq.com' }
  s.source           = { :git => 'https://github.com/liujunliuhong/TagView.git', :tag => s.version.to_s }

  s.module_name = 'GLTagView'
  s.swift_version = '5.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'Sources/*.swift'
end
