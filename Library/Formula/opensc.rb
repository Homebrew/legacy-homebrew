require 'formula'

class Opensc < Formula
  homepage 'https://github.com/OpenSC/OpenSC/wiki'
  url 'https://downloads.sourceforge.net/project/opensc/OpenSC/opensc-0.13.0/opensc-0.13.0.tar.gz'
  sha1 '9285ccbed7b49f63e488c8fb1b3e102994a28218'

  head do
    url 'https://github.com/OpenSC/OpenSC.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option 'with-man-pages', 'Build manual pages'

  depends_on 'docbook-xsl' if build.with? "man-pages"

  def install
    extra_args = []

    if build.with? "man-pages"
      # If OpenSC's configure script detects docbook it will build manual
      # pages. This extends the spirit of that logic to support homebrew
      # installed docbook.
      docbook_xsl = Formula["docbook-xsl"]
      # OpenSC looks in a set of common paths for docbook's xsl files,
      # but not in /usr/local, and certainly not in homebrew's
      # cellar. This specifies the correct homebrew path.

      # Avoid using information from the docbook formula here, as it
      # will always refer to the latest version which is not
      # necessarily the installed version.
      extra_args << "--with-xsl-stylesheetsdir=" +
        "#{docbook_xsl.opt_prefix}/docbook-xsl/"
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
end
