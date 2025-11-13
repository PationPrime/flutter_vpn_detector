Pod::Spec.new do |s|
  s.name             = 'flutter_vpn_detector'
  s.version          = '0.1.0'
  s.summary          = 'A Flutter plugin to detect VPN connections.'
  s.description      = <<-DESC
A Flutter plugin to detect if the device is using a VPN connection. Supports iOS, macOS, Android, Windows, and Linux.
                       DESC
  s.homepage         = 'https://github.com/tikoua/flutter_vpn_detector'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tikoua' => 'your.email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end

