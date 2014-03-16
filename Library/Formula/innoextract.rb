require 'formula'

class Innoextract < Formula
  homepage 'http://constexpr.org/innoextract/'
  url 'https://github.com/dscharrer/innoextract/archive/1.4.tar.gz'
  sha1 '63f5c52eb1e558e7f5f4221769fd6991812f6ef8'
  head 'https://github.com/dscharrer/innoextract.git'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'xz'

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/innoextract", "--version"
  end
end
