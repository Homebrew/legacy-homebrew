require 'formula'

# Are sparse derivatives requested?
def enable_sparse?; ARGV.include? '--enable-sparse'; end

class AdolC < Formula
  url 'http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.3.0.tgz'
  homepage 'http://www.coin-or.org/projects/ADOL-C.xml'
  md5 'c06013e6023ac9c7066738a84b9dafa5'

  if enable_sparse?
    # As of version 2.3.0, Colpack no longer has to be downloaded to a subfolder
    # of Adol-C. But we need recent versions of automake and autoconf.
    depends_on 'colpack'
    depends_on 'automake'
    depends_on 'autoconf'
  end

  def install

    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]

    if enable_sparse?
      args = args + ["--enable-sparse"]
    end

    system "./configure", *args
    system "make install"
  end

end
