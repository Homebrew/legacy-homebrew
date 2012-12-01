require 'formula'

class Libpipeline < Formula
  homepage 'http://libpipeline.nongnu.org/'
  url 'http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.2.2.tar.gz'
  sha1 '89ec6f9beccb9a18b3ed6c8f1296762c54aed0cd'

  # autoconf, automake and libtool are only needed because we
  # have to autoreconf due to changes in configure.ac
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  depends_on 'pkg-config' => :build

  # check is only needed for the tests
  depends_on 'check' => :build

  def patches
    # fixes missing cleanenv()and program_invocation_name()
    # see http://savannah.nongnu.org/bugs/index.php?36848
    [
      'https://savannah.nongnu.org/bugs/download.php?file_id=27020',
      'https://savannah.nongnu.org/bugs/download.php?file_id=27021'
    ]
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
