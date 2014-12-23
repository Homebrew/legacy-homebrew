require 'formula'

class YleDl < Formula
  homepage 'http://aajanki.github.io/yle-dl/'
  url 'https://github.com/aajanki/yle-dl/archive/2.3.1.tar.gz'
  sha1 '5ec3516db2a5ecd793223636e27ed0c23657b575'

  head 'https://github.com/aajanki/yle-dl.git'

  depends_on 'rtmpdump'
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pycrypto" => [:python, "Crypto"]

  def install
    system "make", "install", "SYS=darwin", "prefix=#{prefix}", "mandir=#{man}"

    # yle-dl installed AdobeHDS.php in $PREFIX/bin before 2014-12-26,
    # so only install it for more recent versions.
    # https://github.com/aajanki/yle-dl/commit/ad9ef7fa40b39ec315bb51fc509af7416278966c
    if build.head? then
      # TODO: when 2.3.2 is released, remove the surrounding if
      system "make", "install-adobehds", "SYS=darwin", "prefix=#{prefix}", "mandir=#{man}"
    end
  end

  test do
    assert_equal "3 minuuttia-2012-05-30T10:51:00\n",
                 shell_output("#{bin}/yle-dl --showtitle http://areena.yle.fi/tv/1570236")
  end
end
