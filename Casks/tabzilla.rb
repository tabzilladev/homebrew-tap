cask "tabzilla" do
  version "0.2.4"
  sha256 "1040390bfcb3f5432742094a936f28e157ba4828f4b87762886bd2808c6cb00a"

  url "https://github.com/tabzilladev/tabzilla/releases/download/v#{version}/Tabzilla-#{version}-macos.zip"
  name "Tabzilla"
  desc "URL routing daemon - routes links to browsers based on rules"
  homepage "https://github.com/tabzilladev/tabzilla"

  depends_on macos: :ventura

  app "Tabzilla.app"
  binary "#{appdir}/Tabzilla.app/Contents/MacOS/Tabzilla", target: "tabz"

  postflight do
    system_command "/System/Library/Frameworks/CoreServices.framework" \
                   "/Frameworks/LaunchServices.framework/Support/lsregister",
                   args: ["-f", "#{appdir}/Tabzilla.app"]
  end

  # macOS keeps state outside the app bundle, keyed by bundle id, that a plain
  # uninstall leaves behind (and that silently "reappears" on reinstall):
  #   - LaunchServices: the default http/https handler ("default browser") choice.
  #     Homebrew removes the app bundle before this script runs, so a full
  #     `lsregister -kill -r` rebuild drops the stale Tabzilla binding and macOS
  #     self-heals the default back to another installed browser. (A plain
  #     `lsregister -u` does NOT clear the persisted choice — the rebuild does.)
  #   - TCC: Accessibility + Automation (AppleEvents) grants.
  # Each command is best-effort (`|| true`) so a missing entry doesn't fail zap.
  # TCC caveat: while not code-signed, grants aren't reliably keyed to the bundle
  # id, so `tccutil reset` may match nothing and the grant survives — users can
  # remove Tabzilla manually in System Settings › Privacy & Security if needed.
  # Gatekeeper's "Open Anyway" approval is keyed to code identity and is not
  # resettable here; a fresh install re-quarantines and re-triggers it.
  zap script: {
        executable: "/bin/sh",
        args:       [
          "-c",
          "/System/Library/Frameworks/CoreServices.framework/Versions/Current" \
          "/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister " \
          "-kill -r -domain local -domain user -domain system >/dev/null 2>&1 || true; " \
          "/usr/bin/tccutil reset Accessibility dev.tabzilla.Tabzilla >/dev/null 2>&1 || true; " \
          "/usr/bin/tccutil reset AppleEvents dev.tabzilla.Tabzilla >/dev/null 2>&1 || true",
        ],
      },
      trash:  [
        "~/.config/tabz",
        "~/.tabz.yaml",
      ]

  caveats <<~EOS
    Tabzilla is not yet code-signed. On first launch macOS will block it:
      System Settings → Privacy & Security → scroll to Security → "Open Anyway"
      (you may need to try launching twice).

    Then finish setup — this checks permissions and sets Tabzilla as your
    default browser:
      tabz setup

    Re-check anytime with:
      tabz doctor
  EOS
end
