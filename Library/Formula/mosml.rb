class Mosml < Formula
  homepage "http://mosml.org"
  url "https://github.com/kfl/mosml/archive/ver-2.10.1.tar.gz"
  sha1 "e53fa82074d1c60499dc4ca83521c229e0655ccc"

  depends_on "gmp"

  def install
    cd 'src' do
      system "make", "PREFIX=#{prefix}",
                     "CC=#{ENV.cc}",
                     "world"
      system "make", "PREFIX=#{prefix}",
                     "CC=#{ENV.cc}",
                     "install"
    end
  end

  test do
    system "#{bin}/mosml", "-P full"
  end
end
