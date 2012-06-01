require 'formula'

class SigrokCli < Formula
  homepage 'http://sigrok.org'
  url 'http://downloads.sourceforge.net/project/sigrok/source/sigrok-cli/sigrok-cli-0.3.1.tar.gz'
  md5 'eed06b1408a969b86b0f6e1aa29ae0cb'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libsigrok'
  depends_on 'libsigrokdecode'

  # Stripping breaks dynamic linking
  skip_clean :all

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
