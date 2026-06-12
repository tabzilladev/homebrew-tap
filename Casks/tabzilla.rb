cask "tabzilla" do
  version "0.2.3"
  sha256 "fe02468851cc59b6512c949dc3f0f1d6cf6d586dc96539092502e627be8ac5d9"

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
