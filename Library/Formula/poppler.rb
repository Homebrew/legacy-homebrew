require 'formula'

class PopplerData < Formula
  url 'http://poppler.freedesktop.org/poppler-data-0.4.5.tar.gz'
  sha256 '3190bc457bafe4b158f79a08e8a3f1824031ec12acefc359e68e0f04da0f70fd'
end

class Poppler < Formula
  homepage 'http://poppler.freedesktop.org'
  url 'http://poppler.freedesktop.org/poppler-0.20.2.tar.gz'
  sha256 '2debc5034e0e85402957d84fb2674737658a3dbe8a3c631e1792e3f8c88ce369'

  depends_on 'pkg-config' => :build
  depends_on 'qt' if build.include? 'with-qt4'
  depends_on 'glib' if build.include? 'with-glib'
  depends_on 'cairo' if build.include? 'with-glib' # Needs a newer Cairo build than OS X 10.6.7 provides
  depends_on :x11 # Fontconfig headers

  option 'with-qt4', 'Build Qt backend'
  option 'with-glib', 'Build Glib backend'

  def install
    if build.include? 'with-qt4'
      ENV['POPPLER_QT4_CFLAGS'] = `#{HOMEBREW_PREFIX}/bin/pkg-config QtCore QtGui --libs`.chomp
      ENV.append 'LDFLAGS', "-Wl,-F#{HOMEBREW_PREFIX}/lib"
    end

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--enable-xpdf-headers"]
    # Explicitly disable Qt if not requested because `POPPLER_QT4_CFLAGS` won't
    # be set and the build will fail.
    args << ( build.include? 'with-qt4' ? '--enable-poppler-qt4' : '--disable-poppler-qt4' )
    args << '--enable-poppler-glib' if build.include? 'with-glib'

    system "./configure", *args
    system "make install"

    # Install poppler font data.
    PopplerData.new.brew do
      system "make", "install", "prefix=#{prefix}"
    end
  end
end
