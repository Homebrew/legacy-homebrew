require 'formula'

class Megatools < Formula
  homepage 'http://megatools.megous.com'
  url 'http://megatools.megous.com/builds/megatools-1.9.91.tar.gz'
  sha1 '8e3ecab2020ec31444ed75ca4e92ea75ad4c9354'
  head 'https://github.com/megous/megatools.git'

  depends_on 'pkg-config' => :build
  depends_on 'curl'
  depends_on 'glib-networking' => 'with-curl-ca-bundle'
  depends_on 'osxfuse'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "megals", "--version"
  end
end
