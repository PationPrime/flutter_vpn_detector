Pod::Spec.new do |s|
  s.name             = 'vpn_checker'
  s.version          = '0.1.0'
  s.summary          = 'A Flutter plugin to detect VPN connections.'
  s.description      = <<-DESC
A Flutter plugin to detect if the device is using a VPN connection. Supports iOS, macOS, Android, Windows, and Linux.
                       DESC
  s.homepage         = 'https://github.com/tikoua/vpn_checker'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tikoua' => 'your.email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.platform = :osx, '10.14'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end

