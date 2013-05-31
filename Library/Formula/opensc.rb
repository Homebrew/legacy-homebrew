require 'formula'

class Opensc < Formula
  homepage 'https://github.com/OpenSC/OpenSC/wiki'
  url 'http://sourceforge.net/projects/opensc/files/OpenSC/opensc-0.13.0/opensc-0.13.0.tar.gz'
  sha1 '9285ccbed7b49f63e488c8fb1b3e102994a28218'
  head 'https://github.com/OpenSC/OpenSC.git'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  option 'with-man-pages', 'Build manual pages'

  depends_on 'docbook' if build.include? 'with-man-pages'

  def install
    extra_args = []

    # If OpenSC's configure script detects docbook it will build manual
    # pages. This extends the spirit of that logic to support homebrew
    # installed docbook.
    docbook = Formula.factory 'docbook'
    if docbook.installed?
      # OpenSC looks in a set of common paths for docbook's xsl files,
      # but not in /usr/local, and certainly not in homebrew's
      # cellar. This specifies the correct homebrew path.

      # Avoid using information from the docbook formula here, as it
      # will always refer to the latest version which is not
      # necessarily the installed version.
      extra_args << "--with-xsl-stylesheetsdir=" +
        Dir[docbook.opt_prefix/'docbook/xsl/*'].first
    end

    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sm",
                          "--enable-openssl",
                          "--enable-pcsc",
                          *extra_args

    system "make install"
  end

  def caveats; <<-EOS.undent
    Manual pages will be installed if docbook is installed.
    EOS
  end
end
