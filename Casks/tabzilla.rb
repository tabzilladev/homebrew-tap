cask "tabzilla" do
  version "0.2.3"
  sha256 "3f0a466f00f32f823d9eaba5b366e14b7a798a55f12170178632db9c0dd8b782"

  url "https://github.com/tabzilladev/tabzilla/releases/download/v#{version}/Tabzilla-#{version}-macos.zip"
  name "Tabzilla"
  desc "URL routing daemon - routes links to browsers based on rules"
  homepage "https://github.com/tabzilladev/tabzilla"

  depends_on macos: :ventura

  app "Tabzilla.app"

  postflight do
    system_command "/System/Library/Frameworks/CoreServices.framework" \
                   "/Frameworks/LaunchServices.framework/Support/lsregister",
                   args: ["-f", "#{appdir}/Tabzilla.app"]
  end

  zap trash: [
    "~/.config/tabz",
    "~/.tabz.yaml",
  ]
end
