class Crfxx < Formula
  desc "Conditional random fields for segmenting/labeling sequential data"
  homepage "https://taku910.github.io/crfpp/"
  url "https://drive.google.com/uc?id=0B4y35FiV1wh7QVR6VXJ5dWExSTQ&export=download"
  version "0.58"
  sha1 "979a686a6d73d14cdd0c96a310888fb6bffd2e91"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "CXXFLAGS=#{ENV.cflags}", "install"
  end
end
