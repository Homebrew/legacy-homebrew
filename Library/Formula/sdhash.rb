require 'formula'

class Sdhash < Formula
  homepage 'http://roussev.net/sdhash/sdhash.html'
  url 'http://roussev.net/sdhash/releases/packages/sdhash-2.2.tar.gz'
  sha1 'c3db3c875d0106d02feddef0436b60f72744dd54'

  depends_on "boost"

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "LDFLAGS", "#{ENV.ldflags} -lboost_regex-mt -lboost_system-mt -lboost_filesystem-mt -lboost_program_options-mt -lc -lm -lcrypto -lboost_thread-mt -lpthread"
    end
    system "make", "stream"
    system "make", "man"
    bin.install 'sdhash'
    man1.install 'man/sdhash.1'
    man1.install 'man/sdhash-cli.1'
    man1.install 'man/sdhash-srv.1'
  end

  def test
    system "#{bin}/sdhash"
  end
end
