class Raccoontools < Formula
  desc "Spotlight-style launcher with built-in tools and a contextual AI writing assistant"
  homepage "https://github.com/Juleslassoeur/RaccoonTools"
  url "https://github.com/Juleslassoeur/RaccoonTools/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "57c2f7119f7bdc11e8238d3af6bcb5a838092935b6c08ef540e6cce0908951c5"
  license "MIT"
  head "https://github.com/Juleslassoeur/RaccoonTools.git", branch: "main"

  bottle do
    root_url "https://github.com/Juleslassoeur/RaccoonTools/releases/download/v1.0.2"
    rebuild 1
    sha256 arm64_tahoe:   "401ce95578b76eced3ccb25bf76e2585354984905849e34d5ae7f3218abc4259"
    sha256 arm64_sequoia: "6613efb63c0964cd666b7235b026006295780dd7a442d20ca3b806b6619b864c"
    sha256 arm64_sonoma:  "b1bb1e4d6bcf281e54dfa167d2d2700dc76f9dfa759da8bb757438444042d98c"
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
