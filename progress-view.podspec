Pod::Spec.new do |spec|
  spec.name          = 'progress-view'
  spec.module_name   = 'ProgressView'
  spec.version       = '1.0.0'
  spec.license       = 'MIT'
  spec.authors       = { 'incetro' => 'incetro@ya.ru' }
  spec.homepage      = "https://github.com/Incetro/progress-view.git"
  spec.summary       = 'Progress loading indicator'
  spec.platform      = :ios, "13.0"
  spec.swift_version = '5.0'
  spec.source        = { git: "https://github.com/Incetro/progress-view.git", tag: "#{spec.version}" }
  spec.source_files  = "Sources/ProgressView/**/*.{h,swift}"
end