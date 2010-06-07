require 'formula'

class PopplerData <Formula
  url 'http://poppler.freedesktop.org/poppler-data-0.4.2.tar.gz'
  md5 '4b7598072bb95686f58bdadc4f09715c'
end

class Poppler <Formula
  url 'http://poppler.freedesktop.org/poppler-0.12.4.tar.gz'
  homepage 'http://poppler.freedesktop.org/'
  md5 '4155346f9369b192569ce9184ff73e43'

  depends_on 'pkg-config'
  depends_on "qt" if ARGV.include? "--with-qt4"

  def install
    if ARGV.include? "--with-qt4"
      qt4Flags = `pkg-config QtCore --libs` + `pkg-config QtGui --libs`
      qt4Flags.gsub!("\n","")
      ENV['POPPLER_QT4_CFLAGS'] = qt4Flags
    end

    configureArgs = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking"
    ]

    configureArgs << "--disable-poppler-qt4" unless ARGV.include? "--with-qt4"

    system "./configure", *configureArgs
    system "make install"

    # Install poppler font data.
    PopplerData.new.brew do
      system "make install prefix=#{prefix}"
    end
  end
end
