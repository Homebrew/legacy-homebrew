class GnustepMake < Formula
  desc "Basic GNUstep Makefiles"
  homepage "http://gnustep.org"
  url "http://ftpmain.gnustep.org/pub/gnustep/core/gnustep-make-2.6.7.tar.gz"
  sha256 "112b57737c3dcc66c78a5c88925ae1d672673d256d9935598e98bcd687d051e4"

  bottle do
    sha256 "3aa2ecea4e62124aa7dc53c38825964f1b3761cff9aafcb23ae939a800418cf0" => :yosemite
    sha256 "e0b072606de1568a970101a520cf0e12bf803a85342dc9a96fffec425dea27eb" => :mavericks
    sha256 "7107f40a8092357edd6d5c5dc9892ee590aedd08267a707cbad390d1090c8ca4" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-config-file=#{prefix}/etc/GNUstep.conf",
                          "--enable-native-objc-exceptions"
    system "make", "install", "tooldir=#{libexec}"
  end

  test do
    assert_match shell_output("#{libexec}/gnustep-config --variable=CC").chomp, ENV.cc
  end
end
