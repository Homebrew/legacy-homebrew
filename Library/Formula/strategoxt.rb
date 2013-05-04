require 'formula'

class Strategoxt < Formula
  homepage 'http://strategoxt.org/Stratego/WebHome'
  url 'ftp://ftp.stratego-language.org/pub/stratego/StrategoXT/strategoxt-0.17/strategoxt-0.17.tar.gz'
  sha1 '65fbd0a394917747366ce5c7c83ba6e3883cbb5c'

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
