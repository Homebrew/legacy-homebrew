require 'formula'

class Augeas < Formula
  url 'http://augeas.net/download/augeas-0.8.1.tar.gz'
  homepage 'http://augeas.net'
  md5 '62d47bdc60e175f93aed3b81cb8e2785'

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
