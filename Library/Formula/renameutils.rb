require 'formula'

class Renameutils < Formula
  homepage 'http://www.nongnu.org/renameutils/'
  url 'http://nongnu.uib.no/renameutils/renameutils-0.11.0.tar.gz'
  md5 'a3258f875d6077a06b6889de3a317dce'

  depends_on 'readline' # Use instead of system libedit
  depends_on 'coreutils'

  # Use the GNU versions of certain system utilities. See:
  # https://trac.macports.org/ticket/24525
  def patches
    { :p0 =>
      "https://trac.macports.org/export/91404/trunk/dports/sysutils/renameutils/files/patch-use_coreutils.diff"
    }
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-packager=Homebrew"
    system "make"
    ENV.deparallelize # parallel install fails
    system "make install"
  end
end
