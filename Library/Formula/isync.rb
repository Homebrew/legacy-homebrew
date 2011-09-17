require 'formula'

def build_recursivepatch?; ARGV.include? '--with-recursivepatch'; end

class Isync < Formula
  url 'http://downloads.sourceforge.net/project/isync/isync/1.0.4/isync-1.0.4.tar.gz'
  homepage 'http://isync.sourceforge.net/'
  md5 '8a836a6f4b43cd38a8b8153048417616'

  if build_recursivepatch?
    def patches
        # fixes doc install on OS X 10.6
      "http://www.chrisstreeter.com/wp-content/uploads/2009/04/recursive_imap_ubuntu.patch"
    end
  end

  def options
        [['--with-recursivepatch', 'Use recursive directories patch']]
  end

  depends_on 'berkeley-db'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
