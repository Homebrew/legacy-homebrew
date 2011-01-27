require 'formula'

class Openttd <Formula
  url 'http://binaries.openttd.org/releases/1.0.3/openttd-1.0.3-source.tar.bz2'
  homepage 'http://www.openttd.org/'
  md5 'cff60c624913a491ed3c91474e845722'

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
