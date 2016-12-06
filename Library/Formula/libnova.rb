require 'formula'

class Libnova < Formula
  homepage 'http://libnova.sourceforge.net'
  url 'http://sourceforge.net/projects/libnova/files/libnova/v%200.15.0/libnova-0.15.0.tar.gz/download'
  sha1 '4b8d04cfca0be8d49c1ef7c3607d405a7a8b167d'
  head 'http://svn.code.sf.net/p/libnova/code/trunk/libnova/'

  option 'with-docs', "Build with documentation"

  depends_on :automake
  depends_on :libtool
  depends_on 'doxygen' if build.with? 'docs'


  def install
    # Compatibility with Automake 1.13 and newer. This is fixed
    # in HEAD after libnova 0.15.0, so this 'if block' can be removed
    # for versions after this.
    if not build.head?
      inreplace 'configure.in', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'
    end
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
    # Optionall, install html and man documentation
    if build.with? 'docs'
      cd "doc" do
        system "make doc"
        cd "html" do
          doc.install Dir['*']
        end
        man.mkpath
        cd "man/man3" do
          man3.install Dir['*']
        end
      end
    end
    
  end

  test do
    system "libnovaconfig --version"
  end
end
