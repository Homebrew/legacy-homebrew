class Envv < Formula
  homepage "https://github.com/jakewendt/envv#readme"
  url "https://github.com/jakewendt/envv/archive/v1.7.tar.gz"
  sha1 "ec92fc104f9cdaee7d53bf2d20489c4746cfaec3"

  def install
    system "make"

    bin.install "envv"
    man1.install "envv.1"
  end

  test do
    ENV["mylist"] = "A:B:C"
    assert_equal "mylist=A:C; export mylist", shell_output("#{bin}/envv del mylist B").strip
    assert_equal "mylist=B:C; export mylist", shell_output("#{bin}/envv del mylist A").strip
    assert_equal "mylist=A:B; export mylist", shell_output("#{bin}/envv del mylist C").strip

    assert_equal "", shell_output("#{bin}/envv add mylist B").strip
    assert_equal "mylist=B:A:C; export mylist", shell_output("#{bin}/envv add mylist B 1").strip
    assert_equal "mylist=A:C:B; export mylist", shell_output("#{bin}/envv add mylist B 99").strip

    assert_equal "mylist=A:B:C:D; export mylist", shell_output("#{bin}/envv add mylist D").strip
    assert_equal "mylist=D:A:B:C; export mylist", shell_output("#{bin}/envv add mylist D 1").strip
    assert_equal "mylist=A:B:D:C; export mylist", shell_output("#{bin}/envv add mylist D 3").strip
  end
end
