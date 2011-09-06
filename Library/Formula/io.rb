require 'formula'

class Io < Formula
  url 'https://github.com/stevedekorte/io/tarball/2010.06.06'
  homepage 'http://iolanguage.com/'
  md5 '7968fbe5367aad7a630fc7094be1775b'
  head 'https://github.com/stevedekorte/io.git'

  depends_on 'libsgml'
  depends_on 'ossp-uuid'
  depends_on 'libevent'

  def install
    ENV.j1

    system "make vm"
    system "make install"
    system "make port"
    system "make install"

    rm_f Dir['docs/*.pdf']
    doc.install Dir['docs/*']

    prefix.install 'license/bsd_license.txt' => 'LICENSE'
  end
end
