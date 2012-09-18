require 'formula'

class Imapfilter < Formula
  homepage 'http://github.com/lefcha/imapfilter/'
  url 'https://github.com/lefcha/imapfilter/tarball/v2.5.2'
  sha1 '66985fc36b51c1d7b44fb083e5baf97accc61506'

  depends_on 'lua'
  depends_on 'pcre'

  def install
    inreplace 'src/Makefile' do |s|
      s.change_make_var! 'CFLAGS', "#{s.get_make_var 'CFLAGS'} #{ENV.cflags}"
    end

    # find Homebrew's libpcre and lua
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"
    ENV.append 'LDFLAGS', '-liconv'
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "LDFLAGS=#{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "install"

    prefix.install 'samples'
  end

  def caveats; <<-EOS.undent
    You will need to create a ~/.imapfilter/config.lua file.
    Samples can be found in:
      #{prefix}/samples
    EOS
  end

  def test
    system "#{bin}/imapfilter", "-V"
  end
end
