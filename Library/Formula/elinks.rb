require 'formula'

class Elinks < Formula
  homepage 'http://elinks.or.cz/'
  url 'http://elinks.or.cz/download/elinks-0.11.7.tar.bz2'
  head 'http://elinks.cz/elinks.git', :using => :git

  unless ARGV.build_head?
    md5 'fcd087a6d2415cd4c6fd1db53dceb646'
  end

  fails_with_llvm

  def caveats; <<-EOS.undent
    Though posting of stable versions of elinks seems to have stalled, there is
    development activity occuring in the git repository.  The git checkout can
    be slow.
      brew install --HEAD elinks
    EOS
  end

  def install
    ENV.deparallelize
    ENV.delete('LD')
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}", "--without-spidermonkey"
    system "make install"
  end
end
