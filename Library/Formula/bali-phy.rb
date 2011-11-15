require 'formula'

class BaliPhy < Formula
  url 'http://www.biomath.ucla.edu/msuchard/bali-phy/bali-phy-2.1.1.tar.gz'
  homepage 'http://www.biomath.ucla.edu/msuchard/bali-phy/'
  sha1 'e72073a1c5b05c797668e476bfd8517594f074e6'

  depends_on 'gsl'

# fails_with_clang
#     io.H:25:31: error: use of undeclared identifier 'push_back'
#       void operator()(const T& t){push_back(t);}

  def install
    # docs say build oos
    mkdir 'macbuild'
    Dir.chdir 'macbuild' do
      system "../configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}", "--enable-cairo"
      system "make install"
    end
  end
end
