require 'formula'

class Abyss < Formula
  homepage 'http://www.bcgsc.ca/platform/bioinfo/software/abyss'
  url 'http://www.bcgsc.ca/downloads/abyss/abyss-1.3.3.tar.gz'
  md5 '15953363d4ef5795d3a82d129e4ca240'
  head 'https://github.com/sjackman/abyss.git'

  # Only header files are used from these packages, so :build is appropriate
  depends_on 'boost' => :build
  depends_on 'google-sparsehash' => :build

  # Snow Leopard comes with mpi but Lion does not
  depends_on 'open-mpi' if MacOS.lion?

  # strip breaks the ability to read compressed files.
  skip_clean 'bin'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/ABYSS", "--version"
  end
end
