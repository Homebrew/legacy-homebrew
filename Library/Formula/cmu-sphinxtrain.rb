require "formula"

class CmuSphinxtrain < Formula
  homepage 'http://cmusphinx.sourceforge.net/'
  url "https://downloads.sourceforge.net/project/cmusphinx/sphinxtrain/1.0.8/sphinxtrain-1.0.8.tar.gz"
  sha1 "fccbb42203a388b353318d74a89fdf225aa7afe4"

  depends_on "cmake" => :build
  depends_on 'pkg-config' => :build
  depends_on 'cmu-sphinxbase'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
