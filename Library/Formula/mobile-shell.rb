require 'formula'

class MobileShell < Formula
  homepage 'http://mosh.mit.edu/'
  url 'https://github.com/downloads/keithw/mosh/mosh-1.0.tar.gz'
  md5 'c53723f8579789adf535215dfd5e562a'

  head 'https://github.com/keithw/mosh.git'

  depends_on 'pkg-config' => :build
  depends_on 'protobuf'
  depends_on 'boost'

  def install
    system "./autogen.sh" if ARGV.build_head?

    # Upstream prefers O2:
    # https://github.com/keithw/mosh/blob/master/README.md
    ENV.O2
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
