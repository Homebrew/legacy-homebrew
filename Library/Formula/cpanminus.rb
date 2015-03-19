class Cpanminus < Formula
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7027.tar.gz"
  sha256 "cf65b0d316d027484f0c610863b7e8a85bbe275a2939bdefb40b9176dfe9a489"

  head "https://github.com/miyagawa/cpanminus.git"

  def install
    bin.install "cpanm"
  end

  test do
    system "#{bin}/cpanm", "-V"
  end
end
