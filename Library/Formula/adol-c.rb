require 'formula'

# Are sparse derivatives requested?
def enable_sparse?; ARGV.include? '--enable-sparse'; end

class AdolC < Formula
  url 'http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.3.0.tgz'
  homepage 'http://www.coin-or.org/projects/ADOL-C.xml'
  md5 'c06013e6023ac9c7066738a84b9dafa5'

  def options
    [
        ['--enable-sparse', "build sparse drivers"]
    ]
  end

  if enable_sparse?
    # As of version 2.3.0, Colpack no longer has to be downloaded to a subfolder
    # of Adol-C. But we need recent versions of automake and autoconf.
    depends_on 'colpack'  => :build
    depends_on 'automake' => :build
    depends_on 'autoconf' => :build
    depends_on 'libtool'  => :build
  end

  def install

    system "autoreconf -fi"

    # Don't install libs to lib64/
    inreplace 'configure', 'lib64', 'lib'

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
