require 'formula'

class GnuProlog <Formula
  url 'http://gprolog.univ-paris1.fr/unstable/gprolog-20091217.tgz'
  homepage 'http://www.gprolog.org/'
  md5 '3a0c9994927c8ff9e0a9c6edac0b2e69'

  def skip_clean? path; true; end

  def install
    # make won't run in parallel
    ENV.j1

    Dir.chdir 'src' do
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
      system "make"
      system "make install-strip"
    end
  end
end
