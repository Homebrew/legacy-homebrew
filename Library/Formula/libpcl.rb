class Libpcl < Formula
  desc "C library and API for coroutines"
  homepage "http://xmailserver.org/libpcl.html"
  url "http://xmailserver.org/pcl-1.12.tar.gz"
  sha256 "e7b30546765011575d54ae6b44f9d52f138f5809221270c815d2478273319e1a"

  bottle do
    cellar :any
    revision 1
    sha256 "1975baf018352fd1f1ca88bd39fc02db384e2f6be4017976184dda3365c60608" => :el_capitan
    sha256 "e9c6f7bc1efab583e44879426a5abb2ff5e7f3eb30261a81a7be723c3280c3a3" => :yosemite
    sha256 "8f8e6669f9a552618b5578ad649e0b2a5f0860922e756c79a609b2eb21b5d4b4" => :mavericks
    sha256 "791a1bcac65adcb6ad8a9b3d1ce3e4f74a34aebadd60a135083fad42d9b5965b" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
