require 'formula'

# Official site is no longer responding; use
# this GitHub mirror for now.
class P0f <Formula
  url 'http://github.com/downloads/skord/p0f/p0f-2.0.8.tgz'
  homepage 'http://github.com/skord/p0f'
  md5 '1ccbcd8d4c95ef6dae841120d23c56a5'

  def install
    inreplace "config.h", "/etc/p0f", "#{etc}/p0f"
    system "make"
    sbin.install ["p0frep", "p0f"]
    (etc+"p0f").install Dir['*.fp']
    man1.install gzip("p0f.1")
  end
end
