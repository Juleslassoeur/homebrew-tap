class Raccoontools < Formula
  desc "Spotlight-style launcher with built-in tools and a contextual AI writing assistant"
  homepage "https://github.com/Juleslassoeur/RaccoonTools"
  url "https://github.com/Juleslassoeur/RaccoonTools/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "9ed14c697a8393281256b346992fe4a956c3b3e4a7dfe7b993281e6173b32809"
  license "MIT"
  head "https://github.com/Juleslassoeur/RaccoonTools.git", branch: "main"

  bottle do
    root_url "https://github.com/Juleslassoeur/RaccoonTools/releases/download/v1.1.0"
    rebuild 1
    sha256 arm64_tahoe:   "2e8786bebda2f2c98fdb619cd8d5a40354e36adc5b904562c9379b982ee29c09"
    sha256 arm64_sequoia: "86d84378171faf1dd63dfc2b64d1f3beec45d97085808aab633fbc0cfcb83173"
    sha256 arm64_sonoma:  "8f92ff4d125dc5ae2cba0a64b40e6122a6a5d5fdd3fe84b2794deb1918f713fb"
  end


  depends_on macos: :ventura

  def install
    # SwiftPM's own sandbox conflicts with Homebrew's build sandbox
    system "swift", "build", "-c", "release", "--disable-sandbox"

    app = buildpath/"RaccoonTools.app"
    (app/"Contents/MacOS").mkpath
    (app/"Contents/Resources").mkpath
    cp ".build/release/RaccoonTools", app/"Contents/MacOS/RaccoonTools"
    cp "Resources/Info.plist", app/"Contents/Info.plist"
    cp "Resources/AppIcon.icns", app/"Contents/Resources/AppIcon.icns" if File.exist?("Resources/AppIcon.icns")
    cp "Resources/raccoon.jpg", app/"Contents/Resources/raccoon.jpg" if File.exist?("Resources/raccoon.jpg")

    prefix.install app
  end

  def caveats
    <<~EOS
      RaccoonTools.app was built locally (no Gatekeeper warnings) and installed to:
        #{opt_prefix}/RaccoonTools.app

      Copy it into /Applications:
        cp -R "#{opt_prefix}/RaccoonTools.app" /Applications/

      On first launch, grant Accessibility permission in
      System Settings > Privacy & Security > Accessibility.

      Updating from a previous version? macOS may ask to allow Keychain
      access for your stored API keys — choose "Always Allow".
    EOS
  end

  test do
    assert_predicate prefix/"RaccoonTools.app/Contents/MacOS/RaccoonTools", :exist?
  end
end
