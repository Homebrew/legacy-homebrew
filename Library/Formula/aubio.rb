require 'formula'

class Aubio < Formula
  homepage 'http://aubio.org/'
  url 'http://aubio.org/pub/aubio-0.4.1.tar.bz2'
  sha1 '338ec9f633e82c371a370b9727d6f0b86b0ba376'

  depends_on :macos => :lion
  depends_on :python

  depends_on 'pkg-config' => :build
  depends_on :libtool => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    cd 'python' do
      system "./setup.py", "build"
      system "./setup.py", "install", "--prefix", "#{prefix}"
    end
  end

  test do
    system "#{bin}/aubiocut", "--help"
  end
end
