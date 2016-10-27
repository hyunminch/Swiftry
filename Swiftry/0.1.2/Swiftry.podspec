Pod::Spec.new do |spec|
  spec.name = "Swiftry"
  spec.version = "0.1.2"
  spec.summary = "A simple Swift Try framework."
  spec.homepage = "https://github.com/nitrogenice/Swiftry"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Hyun Min Choi" => 'hyunmin.personal@gmail.com' }

  spec.requires_arc = true
  spec.source = { git: "https://github.com/nitrogenice/Swiftry.git", tag: "#{spec.version}", submodules: true }
  spec.source_files = "Sources/*.{h,swift}"

  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.9"
  spec.tvos.deployment_target = "9.0"
end
