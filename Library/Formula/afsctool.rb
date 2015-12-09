class Afsctool < Formula
  desc "Utility for manipulating HFS+ compressed files"
  homepage "http://brkirch.wordpress.com/afsctool/"
  url "https://docs.google.com/uc?export=download&id=0BwQlnXqL939ZQjBQNEhRQUo0aUk"
  version "1.6.4"
  sha256 "bb6a84370526af6ec1cee2c1a7199134806e691d1093f4aef060df080cd3866d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f53e528302f21b5232f0cf0ba85107c9881059aab97dd6db0c8e3b4338dd6f13" => :el_capitan
    sha256 "b00e2da9028fbbd4fc1c1e5db0bcec7612f66ec7bd0799a3368efd2f6c9b6a60" => :yosemite
    sha256 "166e38496d45481d0031930b19c33b853f3a48816b12acafd66620d0e707412f" => :mavericks
  end

  def install
    cd "afsctool_34" do
      system ENV.cc, ENV.cflags, "-lz",
         "-framework", "CoreServices", "-o", "afsctool", "afsctool.c"
      bin.install "afsctool"
    end
  end

  test do
    path = testpath/"foo"
    path.write "some text here."
    system "#{bin}/afsctool", "-c", path
    system "#{bin}/afsctool", "-v", path
  end
end
