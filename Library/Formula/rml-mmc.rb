require 'formula'

class RmlMmc < Formula
  homepage 'http://www.ida.liu.se/labs/pelab/rml'
  url 'https://build.openmodelica.org/apt/pool/contrib/rml-mmc_229.orig.tar.gz'
  sha1 '5fd2cda54fafcfeeb68ebfa4ddb9865622d09c5b'

  head 'https://openmodelica.org/svn/MetaModelica/trunk', :using => :svn

  depends_on 'smlnj'

  def install
    ENV.j1

    smlnj_prefix = `brew --prefix smlnj`.strip

    ENV['SMLNJ_HOME'] = "#{smlnj_prefix}/libexec/"

    system "./configure --prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/rml", "-v"
  end

 def caveats; <<-EOS.undent
    Installing form SVN you may need to provide the username and password.
    brew install --HEAD mmc
    <enter>
    Username: anonymoys
    Password: none
    EOS
  end
end

