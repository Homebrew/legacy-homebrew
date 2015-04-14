class Elementary < Formula
  homepage "https://www.enlightenment.org"
  url "http://download.enlightenment.org/rel/libs/elementary/elementary-1.14.0-beta1.tar.gz"
  sha1 "c955fb825cdd0ad70bb4a6bc24aedc74374e3be7"

  depends_on 'pkg-config' => :build
  depends_on 'efl'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
        system "#{bin}/elementary_codegen", "-V"
  end
end
