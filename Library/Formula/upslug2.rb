require 'formula'

class Upslug2 < Formula
  homepage 'https://github.com/carlesso/upslug2'

  url 'https://github.com/carlesso/upslug2.git', :revision => 'e3d1163d130e588f91c863b2719018cab7470e38'

  head 'https://github.com/wspringer/upslug2.git', :using => :git
  version '2.11'

  depends_on :autoconf# => :build
  depends_on :automake
  depends_on :libtool

  def install
    system "autoreconf", "-iv"
    ENV['CPPFLAGS'] = "-I/opt/local/include"
    ENV['LDFLAGS'] = "-L/opt/local/lib"
    system "./configure", "--with-libpcap", "--prefix=#{prefix}"

    system "make"
    system "make install"
  end

  def test
    system "#{sbin}/upslug2"
  end
end
