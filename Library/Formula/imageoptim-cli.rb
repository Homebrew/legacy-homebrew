require 'formula'

class ImageoptimCli < Formula
  url 'https://github.com/JamieMason/ImageOptim-CLI/archive/1.6.18.tar.gz'
  homepage 'http://jamiemason.github.io/ImageOptim-CLI/'
  sha1 '9f78f543a51cf8bbbb864571625db824ff9a04dc'
  head 'https://github.com/JamieMason/ImageOptim-CLI.git'

  def install
    bin.install "bin/imageOptimAppleScriptLib", "bin/imageOptim"
  end

  def caveats
    "ImageOptim-CLI requires ImageOptim.app in /Applications and optionally ImageAlpha and JPEGmini"
  end

  test do
    system "#{bin}/imageOptim", "--version"
  end
end
