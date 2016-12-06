require 'formula'

class OpenarkKit <Formula
  url 'http://openarkkit.googlecode.com/files/openark-kit-170.tar.gz'
  homepage 'http://code.google.com/p/openarkkit/'
  md5 '7addca693569e9bc032448e7dd1cd79f'

  def install
    system "python", "setup.py", "install",
                          "--prefix=#{prefix}"
  end
end
