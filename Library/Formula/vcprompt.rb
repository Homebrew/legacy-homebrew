require 'formula'

class Vcprompt < Formula
  homepage 'https://bitbucket.org/gward/vcprompt'
  url 'https://bitbucket.org/gward/vcprompt/downloads/vcprompt-1.2.1.tar.gz'
  sha1 'fb623e6183b8e5ccbbe5cf7d135a04e727c9b402'

  bottle do
    cellar :any
    sha1 "609b05ec156a7b5b154150800dfefd1adcbef0df" => :mavericks
    sha1 "b20758412be3d8abc8d99a055f34da5c94861280" => :mountain_lion
    sha1 "f7618134adfd9bd57011eabd66278f8c8918fca0" => :lion
  end

  head do
    url 'hg://https://bitbucket.org/gward/vcprompt'
    depends_on :autoconf
  end

  depends_on 'sqlite'

  def install
    system "autoconf" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man1}",
                   "install"
  end

  test do
    system "#{bin}/vcprompt"
  end
end
