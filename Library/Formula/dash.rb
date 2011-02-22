require 'formula'

class Dash <Formula
  url 'http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.6.1.tar.gz'
  homepage 'http://gondor.apana.org.au/~herbert/dash/'
  sha1 '06944456a1e3a2cbc325bffd0c898eff198b210a'
  head 'https://git.kernel.org/pub/scm/utils/dash/dash.git', :using => :git

  def install
    if ARGV.build_head?
      system "aclocal"
      system "autoreconf -f -i -Wall,no-obsolete"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit"
    system "make"
    system "make install"
  end
end
