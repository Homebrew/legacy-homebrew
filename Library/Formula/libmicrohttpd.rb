class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.47.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.47.tar.gz"
  sha256 "96bdab4352a09fd3952a346bc01898536992f50127d0adea1c3096a8ec9f658c"
  revision 1

  bottle do
    cellar :any
    sha256 "124b6fa52eac50c5e72b839dec9834e7b85993db417785010d45130e5876dd77" => :el_capitan
    sha256 "9db7600654f0ad7696af3f4dd6452414cb0ef93b96a415b13a150af04b4e5d64" => :yosemite
    sha256 "fa713ee51f66eee037ebda50eccdf2af9d6fa989dddb51bab8d96b0417dfc824" => :mavericks
    sha256 "9763e609a18dd5a02ffc3439c94acee2a8db0b602f2712fea428398517763c44" => :mountain_lion
  end

  option "with-ssl", "Enable SSL support"
  option :universal

  if build.with? "ssl"
    depends_on "libgcrypt"
    depends_on "gnutls"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
