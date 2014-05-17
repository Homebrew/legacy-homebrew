require 'formula'

class Augeas < Formula
  homepage 'http://augeas.net'
  url 'http://download.augeas.net/augeas-1.2.0.tar.gz'
  sha1 'ab63548ae5462d7b3dc90e74311b8e566ba22485'

  head do
    url 'https://github.com/hercules-team/augeas.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on 'bison' => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'libxml2'
  depends_on 'readline'

  def install
    if build.head?
      # The bootstrap script run by autogen needs to check the state of the
      # gnulib submodule.
      ln_s cached_download + '.git', '.git'
      ln_s cached_download + '.gnulib/.git', '.gnulib/.git'

      system './autogen.sh'
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # libfa example program doesn't compile cleanly on OSX, so skip it
    inreplace 'Makefile' do |s|
      s.change_make_var! "SUBDIRS", "gnulib/lib src gnulib/tests tests man doc"
    end

    system "make install"
  end

  def caveats; <<-EOS.undent
    Lenses have been installed to:
      #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end
end
