require 'formula'

class Wkhtmltoimage <Formula
  url 'http://wkhtmltopdf.googlecode.com/files/wkhtmltoimage-0.10.0_beta4-OS-X.i386'
  homepage 'http://code.google.com/p/wkhtmltopdf/'
  md5 'd8ec5d895efd22d4405803fefac36882'

  def install
    system "mv wkhtmltoimage-0.10.0_beta4-OS-X.i386 wkhtmltoimage"
    bin.install "wkhtmltoimage"
  end
end
