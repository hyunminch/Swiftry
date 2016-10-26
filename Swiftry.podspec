Pod::Spec.new do |spec|
  spec.name = "Swiftry"
  spec.version = "0.1.0"
  spec.summary = "A simple Swift Try framework."
  spec.homepage = "https://github.com/nitrogenice/Swiftry"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Hyun Min Choi" => 'hyunmin.personal@gmail.com' }
  spec.social_media_url = "http://twitter.com/thoughtbot"

  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/nitrogenice/Swiftry.git", tag: "#{spec.version}", submodules: true }
  spec.source_files = "Sources/*.{h,swift}"
end
