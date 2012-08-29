require 'formula'

class Abyss < Formula
  homepage 'http://www.bcgsc.ca/platform/bioinfo/software/abyss'
  url 'http://www.bcgsc.ca/downloads/abyss/abyss-1.3.4.tar.gz'
  md5 '5a79f33f828db3c626627c5facd0f712'
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
