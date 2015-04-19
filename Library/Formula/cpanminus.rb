class Cpanminus < Formula
  homepage "https://github.com/miyagawa/cpanminus"
  url "https://github.com/miyagawa/cpanminus/archive/1.7029.tar.gz"
  sha256 "755e37c3ed21e0cea16ad39714e463ba9898083784c33361aec607f00523783d"

  head "https://github.com/miyagawa/cpanminus.git"

  def install
    bin.install "cpanm"
  end

  test do
    system "#{bin}/cpanm", "-V"
  end
end
