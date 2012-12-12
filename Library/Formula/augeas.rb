require 'formula'

class Augeas < Formula
  homepage 'http://augeas.net'
  url 'http://augeas.net/download/augeas-0.10.0.tar.gz'
  sha1 '6d1d7b4572c05748d537f3ff12c5ac8ceb6b49bd'

  depends_on 'readline'

  def install
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
