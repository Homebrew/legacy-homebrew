require 'formula'

class Raopx <Formula
  url 'http://www.hersson.net/?download=RaopX_v0.0.4'
  homepage 'http://www.hersson.net/projects/raopx'
  version '0.0.4'
  md5 'f251fe50396e1db98dcc26230e656b48'

  depends_on 'libsamplerate'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Soundflower (http://cycling74.com/products/soundflower/) should be installed to make this
    really useful - Set 'Soundflower (2ch)' as default input and output device in
    System Preferences.
    EOS
  end
end
