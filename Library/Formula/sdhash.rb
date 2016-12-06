require 'formula'

class Sdhash < Formula
  homepage 'http://roussev.net/sdhash/sdhash.html'
  url 'http://roussev.net/sdhash/releases/packages/sdhash-2.2.tar.gz'
  sha1 '2039bbc0c25c7ff6bd6e27a0844f10ec8a88dfec'

  depends_on "boost"

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "LDFLAGS", "#{ENV.ldflags} -lboost_regex-mt -lboost_system-mt -lboost_filesystem-mt -lboost_program_options-mt -lc -lm -lcrypto -lboost_thread-mt -lpthread"
    end
    system "make", "stream"
    system "make", "man"
    bin.install 'sdhash'
    man1.install Dir['man/*.1']
  end

  def test
    system "#{bin}/sdhash"
  end
end
