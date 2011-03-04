require 'formula'

class Openttd <Formula
  url 'http://us.binaries.openttd.org/binaries/releases/1.0.5/openttd-1.0.5-source.tar.bz2'
  homepage 'http://www.openttd.org/'
  md5 'fc79f788e2be140948b972c32b0f1eec'

  depends_on 'libpng'
  depends_on 'lzo'

  def install
    system "./configure", "--without-application-bundle", "--prefix-dir=#{prefix}"
    system "make install"
    bin.install "bin/openttd"
  end

  def caveats; <<-EOS.undent
    Note: This does not install any art assets. You will be prompted
    on first run to download an asset set.
    Having an original TTD CD will help.
    EOS
  end
end
