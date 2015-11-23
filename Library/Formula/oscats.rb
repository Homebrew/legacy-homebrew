class Oscats < Formula
  desc "Computerized adaptive testing system"
  homepage "https://code.google.com/p/oscats/"
  url "https://oscats.googlecode.com/files/oscats-0.6.tar.gz"
  sha256 "2f7c88cdab6a2106085f7a3e5b1073c74f7d633728c76bd73efba5dc5657a604"

  depends_on "pkg-config" => :build
  depends_on :python => :optional
  depends_on "gsl"
  depends_on "glib"
  depends_on "pygobject" if build.with? "python"

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-python-bindings" if build.with? "python"
    system "./configure", *args
    system "make", "install"
  end
end
