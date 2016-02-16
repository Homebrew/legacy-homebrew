class AardvarkShellUtils < Formula
  desc "Utilities to aid shell scripts or command-line users"
  homepage "http://www.laffeycomputer.com/shellutils.html"
  url "http://downloads.laffeycomputer.com/current_builds/shellutils/aardvark_shell_utils-1.0.tar.gz"
  sha256 "aa2b83d9eea416aa31dd1ce9b04054be1a504e60e46426225543476c0ebc3f67"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fc19fca9729b408c5a77f362fff72a8c74c324d4a81cc0cf3e4c91b41bf2d6f" => :el_capitan
    sha256 "ca1cb774102a7e5128f964c2c9d48b45877f1fd3347288edb2adef5981fdd0f4" => :yosemite
    sha256 "e8e8b6fd4ee85d8a6ae267fbd20160c1aeddeb6c8e302793b12a807131ef4b27" => :mavericks
  end

  conflicts_with "coreutils", :because => "both install `realpath` binaries"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "movcpm", shell_output("#{bin}/filebase movcpm.com").strip
    assert_equal "com", shell_output("#{bin}/fileext movcpm.com").strip
    assert_equal testpath.to_s, shell_output("#{bin}/realpath .").strip
  end
end
