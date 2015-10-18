class CmuPocketsphinx < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "http://cmusphinx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cmusphinx/pocketsphinx/0.8/pocketsphinx-0.8.tar.gz"
  sha256 "874c4c083d91c8ff26a2aec250b689e537912ff728923c141c4dac48662cce7a"

  head do
    url "https://github.com/cmusphinx/pocketsphinx.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "swig" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cmu-sphinxbase"

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
