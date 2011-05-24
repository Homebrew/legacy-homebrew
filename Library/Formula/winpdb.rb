require 'formula'

class Winpdb < Formula
  url 'http://winpdb.googlecode.com/files/winpdb-1.4.8.zip'
  homepage 'http://winpdb.org/'
  md5 '0860b82ac9bf3975042aa13018d38b25'

  depends_on 'wxpython'

  def install
    # Find the arch for the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    ENV['ARCHFLAGS'] = archs.as_arch_flags

    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end
end
