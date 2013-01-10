require 'formula'

class Byobu < Formula
  homepage 'http://launchpad.net/byobu'
  url 'https://launchpad.net/byobu/trunk/5.24/+download/byobu_5.24.orig.tar.gz'
  sha1 'aa149862d70d8ad1b7b0507193669f24dc15ba99'

  depends_on 'coreutils'
  depends_on 'gnu-sed' # fails with BSD sed

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=$(brew --prefix)
    EOS
  end
end
