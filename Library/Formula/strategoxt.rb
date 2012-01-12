require 'formula'

class Strategoxt < Formula
  url 'ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.17/strategoxt-0.17.tar.gz'
  homepage 'http://strategoxt.org/Stratego/WebHome'
  md5 '6a1523ec105c5091a8174b276aceea1b'

  depends_on 'aterm'
  depends_on 'sdf'

  def install
    system "./configure", "--prefix=#{prefix}"
    # The build fails mysteriously with -j4
    ENV.j1
    system "make install"
  end

  def caveats
    <<-EOS.undent
    Auxiliary programs have been installed to:
      #{libexec}
    EOS
  end
end
