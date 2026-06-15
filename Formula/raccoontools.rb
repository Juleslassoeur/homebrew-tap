class Raccoontools < Formula
  desc "Spotlight-style launcher with built-in tools and a contextual AI writing assistant"
  homepage "https://github.com/Juleslassoeur/RaccoonTools"
  url "https://github.com/Juleslassoeur/RaccoonTools/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "3676715467441352262d1f9441ad9b46664979126b55f49c40f5f9e5cf5d8a0f"
  license "MIT"
  head "https://github.com/Juleslassoeur/RaccoonTools.git", branch: "main"

  bottle do
    root_url "https://github.com/Juleslassoeur/RaccoonTools/releases/download/v1.3.0"
    rebuild 1
    sha256 arm64_tahoe:   "335522ed27799124af8fd8d79be3770eea0069230f6e15666d19883978ab814f"
    sha256 arm64_sequoia: "2a65ff427b4a8c8b8b7727c67bd5e0f8e13e25c405d43c79cacfa81fafb628be"
    sha256 arm64_sonoma:  "c3b17aea423ea84045e37377ce02d36bf18a4a7434f8096c760d5cac60d3718c"
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
