# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Firebase' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'FirebaseAnalytics'
  pod 'FirebaseAuth'
  pod 'FirebaseCore'
  pod 'GoogleSignIn'

#  pod 'GoogleUtilities', '~> 7.0'

  pod 'FirebaseFirestore'
#  pod 'gRPC-Core'
#  pod 'BoringSSL-GRPC'
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name == 'BoringSSL-GRPC'
        target.source_build_phase.files.each do |file|
          if file.settings && file.settings['COMPILER_FLAGS']
            flags = file.settings['COMPILER_FLAGS'].split
            flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
            file.settings['COMPILER_FLAGS'] = flags.join(' ')
          end
        end
      end
    end
  end



end
