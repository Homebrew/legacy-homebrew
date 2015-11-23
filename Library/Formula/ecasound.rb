class Ecasound < Formula
  desc "Multitrack-capable audio recorder and effect processor"
  homepage "http://www.eca.cx/ecasound/"
  url "http://ecasound.seul.org/download/ecasound-2.9.1.tar.gz"
  sha256 "39fce8becd84d80620fa3de31fb5223b2b7d4648d36c9c337d3739c2fad0dcf3"

  option "with-ruby", "Compile with ruby support"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << ("--enable-rubyecasound=" + ((build.with? "ruby") ? "yes" : "no"))
    system "./configure", *args
    system "make", "install"
  end
end
