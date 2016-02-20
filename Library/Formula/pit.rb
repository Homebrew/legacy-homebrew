class Pit < Formula
  desc "Project manager from hell (integrates with Git)"
  homepage "https://github.com/michaeldv/pit"
  head "https://github.com/michaeldv/pit.git"

  # upstream commit to allow PREFIX-ed installs
  stable do
    url "https://github.com/michaeldv/pit/archive/0.1.0.tar.gz"
    sha256 "ddf78b2734c6dd3967ce215291c3f2e48030e0f3033b568eb080a22f041c7a0e"

    patch do
      url "https://github.com/michaeldv/pit/commit/f64978d6c2628e1d4897696997b551f6b186d4bc.diff"
      sha256 "3f5fdb043193d06b30c895e476d5a323aa1c5a28c50f9eef7b5f5b5200550f3b"
    end

    # upstream commit to fix a segfault when using absolute paths
    patch do
      url "https://github.com/michaeldv/pit/commit/e378582f4d04760d1195675ab034aac5d7908d8d.diff"
      sha256 "09a9c37c5c9d963f21fae26f9617bf6698d8cb8e70ea756f16c2e9a8f5e7a1cd"
    end

    # upstream commit to return 0 on success instead of 1
    patch do
      url "https://github.com/michaeldv/pit/commit/5d81148349cc442d81cc98779a4678f03f59df67.diff"
      sha256 "be059f88fe0759e451817b74919670be9fb5b193738c8574a6faa34baefada67"
    end
  end

  bottle do
    cellar :any
    sha256 "b019c645e6e75a2d62c5aa59deb1232f195da25ae620409c3eade912739f981b" => :yosemite
    sha256 "c6f76895ea5cb711a29223c034eb028af81321d33c6c184550134fd166143a79" => :mavericks
    sha256 "549ecc5ef0be59559d121fd558b02c0d42e149a205fed55b31e9d92b133a1dd2" => :mountain_lion
  end

  def install
    bin.mkpath

    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/pit", "init"
  end
end
