class Xmake < Formula
  desc "The Automatic Cross-platform Build Tool"
  homepage "https://github.com/waruqi/xmake"
  url "https://github.com/waruqi/xmake/archive/v1.0.4.tar.gz"
  mirror "http://tboox.net/release/xmake/xmake-v1.0.4.tar.gz"
  sha256 "36307effa4251413f26b5c7af454269f0a06c891e1a4918a3801760b78d1a365"
  head "https://github.com/waruqi/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43acc8707721039771c55da22ba3ca952a5455f5f2e429a5f77ed483a51eaf9d" => :el_capitan
    sha256 "b410d812545bed22448185426ddc8efd4d469d0921268279b48481de797288a0" => :yosemite
    sha256 "3226fee22117f1763b1167293311351c707740a9be7236c7f03fd867deab5b74" => :mavericks
  end

  def install
    system "./install", "output"
    pkgshare.install Dir["xmake/*"]
    bin.install "output/share/xmake/xmake"
    bin.env_script_all_files(libexec, :XMAKE_PROGRAM_DIR =>"#{pkgshare}")
  end

  test do
    touch testpath/"xmake.lua"
    system "#{bin}/xmake"
  end
end
