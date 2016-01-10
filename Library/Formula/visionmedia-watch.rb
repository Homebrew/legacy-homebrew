class VisionmediaWatch < Formula
  desc "Periodically executes the given command"
  homepage "https://github.com/visionmedia/watch"
  url "https://github.com/visionmedia/watch/archive/0.3.1.tar.gz"
  sha256 "769196a9f33d069b1d6c9c89e982e5fdae9cfccd1fd4000d8da85e9620faf5a6"

  head "https://github.com/visionmedia/watch.git"

  bottle do
    cellar :any
    sha256 "c3472ef163e074176e2bccfc957848ae128c3718d43aba0762ae763da2e56e14" => :mavericks
    sha256 "771e32db925b2816db407938680c72c55b30ff173cb85f9e722f5e40c06a4dfe" => :mountain_lion
    sha256 "4abb0beee91c8ead466949d830c0d4de466007aac4646144d9a52f6cc8e1e046" => :lion
  end

  conflicts_with "watch"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end
