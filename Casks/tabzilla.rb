cask "tabzilla" do
  version "0.1.0"
  sha256 "f03b5060e868569c61a97626819057dc8a9c508c0fad37c8b606b01b7851caa4"

  url "https://github.com/tabzilladev/tabzilla/releases/download/v#{version}/Tabzilla-#{version}-macos.zip"
  name "Tabzilla"
  desc "URL routing daemon for macOS - routes links to browsers based on rules"
  homepage "https://github.com/tabzilladev/tabzilla"

  depends_on macos: ">= :ventura"
  app "Tabzilla.app"

  postflight do
    system_command "/System/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister",
                   args: ["-f", "#{appdir}/Tabzilla.app"]
  end

  zap trash: [
    "~/.config/tabz",
    "~/.tabz.yaml",
  ]
end
