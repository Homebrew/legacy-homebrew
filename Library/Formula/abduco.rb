class Abduco < Formula
  homepage "http://www.brain-dump.org/projects/abduco"
  url "http://www.brain-dump.org/projects/abduco/abduco-0.3.tar.gz"
  sha1 "175b2c0eaf2a8b7fb044f1454d018dac4ec31293"
  head "git://repo.or.cz/abduco.git"

  bottle do
    cellar :any
    sha1 "dc3f05e32b87e67d3b9da26e199fb92de369794a" => :mavericks
    sha1 "1fe57b58b3cdac26a667f19ad25bf0c06dcbf1f0" => :mountain_lion
    sha1 "d7c559b7d1a696d8ca34934276f715461ee0ed33" => :lion
  end

  # upstream fix for create-session: Invalid argument
  # safe to remove in versions > 0.3
  patch do
    url "http://repo.or.cz/w/abduco.git/patch/91b733"
    sha1 "4370ceb4c304ecd916e69c6c7c876666807f6fb8"
  end

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    result = shell_output("#{bin}/abduco -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match /^abduco-#{version}/, result
  end
end
