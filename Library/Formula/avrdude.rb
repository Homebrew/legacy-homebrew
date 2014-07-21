require 'formula'

class Avrdude < Formula
  homepage 'http://savannah.nongnu.org/projects/avrdude/'
  url 'http://download.savannah.gnu.org/releases/avrdude/avrdude-6.1.tar.gz'
  sha1 '15525cbff5918568ef3955d871dbb94feaf83c79'

  bottle do
    sha1 "2d759fea880b097754defe8016e026390dbcfb31" => :mavericks
    sha1 "83017c7fb34b0a2da5919b6b1dde9c05bf237f2a" => :mountain_lion
    sha1 "438562a4b84b4e868cdf01b81e7543053a89a7ff" => :lion
  end

  head do
    url 'svn://svn.savannah.nongnu.org/avrdude/trunk/avrdude/'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :macos => :snow_leopard # needs GCD/libdispatch
  depends_on 'libusb-compat'
  depends_on 'libftdi0'
  depends_on 'libelf'
  depends_on 'libhid' => :optional

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
