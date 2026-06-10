class Raccoontools < Formula
  desc "Spotlight-style launcher with built-in tools and a contextual AI writing assistant"
  homepage "https://github.com/Juleslassoeur/RaccoonTools"
  url "https://github.com/Juleslassoeur/RaccoonTools/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "321a6efb49d83c095abeb3cfd862fc216f8e6b06310149a690f28f0c62199010"
  license "MIT"
  head "https://github.com/Juleslassoeur/RaccoonTools.git", branch: "main"

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
    EOS
  end

  test do
    assert_predicate prefix/"RaccoonTools.app/Contents/MacOS/RaccoonTools", :exist?
  end
end
