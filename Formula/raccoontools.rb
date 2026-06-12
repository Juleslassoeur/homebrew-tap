class Raccoontools < Formula
  desc "Spotlight-style launcher with built-in tools and a contextual AI writing assistant"
  homepage "https://github.com/Juleslassoeur/RaccoonTools"
  url "https://github.com/Juleslassoeur/RaccoonTools/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "de09cb9351fcaff5e1f8591b5ba5a61665780505303578780aaea741bdbbd8c8"
  license "MIT"
  head "https://github.com/Juleslassoeur/RaccoonTools.git", branch: "main"

  bottle do
    root_url "https://github.com/Juleslassoeur/RaccoonTools/releases/download/v1.2.0"
    rebuild 1
    sha256 arm64_tahoe:   "f7f00eecae65a6c29c022d98727ab19d588d96195bd60618f9acde9df403b359"
    sha256 arm64_sequoia: "05043e2492dcbc1ad9374922220038d85edbe47a0b145c29a1fac544e2e73ee0"
    sha256 arm64_sonoma:  "4c0e88e281734834676649342d7d837b97409840d49831a8d8fdc679114453c6"
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
