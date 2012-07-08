require 'formula'

class RmlMmc < Formula
  homepage 'http://www.ida.liu.se/labs/pelab/rml'
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

