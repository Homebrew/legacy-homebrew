require 'formula'

class Growly < Formula
  homepage 'https://github.com/ryankee/growly'
  head 'https://github.com/ryankee/growly.git'
  url 'https://github.com/downloads/ryankee/growly/growly-v0.2.0.tar.gz'
  sha1 'f260315adbff902b14469cb755c2620868649cf1'

  def install
    bin.install 'growly'
  end

  test do
    system "#{bin}/growly", "echo Hello, world!"
  end
end
