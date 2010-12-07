require 'formula'

class Labrea <Formula
  url 'http://github.com/dustin/labrea/tarball/0.1'
  head 'git://github.com/dustin/labrea.git'
  homepage 'https://github.com/dustin/labrea/wiki'
  md5 '293356f2ab69496cffd8989e8b8de856'

  def caveats
    return <<EOF
This package isn't well documented internally.
For the latest usage info, check the web site:
    https://github.com/dustin/labrea/wiki
EOF
  end

  def install
    system "./configure"
    system "make install PREFIX=#{prefix}"
  end
end
