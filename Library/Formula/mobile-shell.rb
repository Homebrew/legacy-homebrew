require 'formula'

class MobileShell < Formula
  homepage 'http://mosh.mit.edu/'
  url 'http://mosh.mit.edu/mosh-1.2.4.tar.gz'
  sha1 'b1dffe8562d7b2f4956699849fbe5d18bfd7749e'

  head do
    url 'https://github.com/keithw/mosh.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'protobuf'

  def install
    system "./autogen.sh" if build.head?

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh", "'mosh-client", "\'#{bin}/mosh-client"

    # Upstream prefers O2:
    # https://github.com/keithw/mosh/blob/master/README.md
    ENV.O2
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make install"
  end
end
