cask "tabzilla" do
  version "1.0.0"
  sha256 "PLACEHOLDER"

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
