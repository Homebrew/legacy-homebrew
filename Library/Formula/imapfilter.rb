require 'formula'

class Imapfilter < Formula
  homepage 'http://github.com/lefcha/imapfilter/'
  url 'https://github.com/downloads/lefcha/imapfilter/imapfilter-2.4.2.tar.gz'
  md5 'a4582e9081da749afb81448f30a50ef6'

  depends_on 'lua'
  depends_on 'pcre'

  def install
    inreplace 'src/Makefile' do |s|
      s.change_make_var! 'CFLAGS', "#{s.get_make_var 'CFLAGS'} #{ENV.cflags}"
    end

    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    ENV.append 'LDFLAGS', '-liconv'
    system "make", "LDFLAGS=#{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "install"
  end

  def test
    system "#{bin}/imapfilter", "-V"
  end
end
