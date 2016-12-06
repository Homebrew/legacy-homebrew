require 'formula'

class Mozjs < Formula
  homepage 'https://developer.mozilla.org/en/docs/SpiderMonkey'
  url 'http://ftp.mozilla.org/pub/mozilla.org/js/mozjs17.0.0.tar.gz'
  sha1 '7805174898c34e5d3c3b256117af9944ba825c89'

  option 'with-check', "Run the test suite during install ~10min"

  def install
    chdir "./js/src/"
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"
  end

  test do
    `#{bin}/js17 -e 'print(Math.PI)'`.chomp == '3.141592653589793'
  end
end
