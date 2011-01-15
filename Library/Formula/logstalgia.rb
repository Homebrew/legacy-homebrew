require 'formula'

class Logstalgia <Formula
  url 'http://logstalgia.googlecode.com/files/logstalgia-1.0.0.tar.gz'
  homepage 'http://code.google.com/p/logstalgia/'
  md5 '606ba346d34a6cc6e4cdf716130df510'

  deps = %w(pcre jpeg libpng sdl ftgl sdl_image)
  deps.each { |d| depends_on d }

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"

    system "make install"
  end
end
