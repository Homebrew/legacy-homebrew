class Growly < Formula
  desc "Redirect command output to a growl notification"
  homepage "https://github.com/ryankee/growly"
  head "https://github.com/ryankee/growly.git"
  url "https://github.com/downloads/ryankee/growly/growly-v0.2.0.tar.gz"
  sha256 "3e803207aa15e3a1ee33fc388a073bd84230dce2c579295ce26b857987e78a79"

  def install
    bin.install "growly"
  end

  test do
    system "#{bin}/growly", "echo Hello, world!"
  end
end
