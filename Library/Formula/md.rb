class Md < Formula
  desc "Process raw dependency files produced by cpp"
  homepage "https://opensource.apple.com/source/adv_cmds/adv_cmds-147/md/"
  url "https://opensource.apple.com/tarballs/adv_cmds/adv_cmds-147.tar.gz"
  sha256 "e74d93496dd031ffea1ad8995686c1e9369a92de70c4c95a7f6e3d6ce2e7e434"

  # OS X up to and including Lion 10.7 includes 'md'
  keg_only :provided_pre_mountain_lion

  def install
    cd "md" do
      system ENV.cc, ENV.cflags, "-o", "md", "md.c"
      bin.install "md"
      man1.install "md.1"
    end
  end

  test do
    (testpath/"foo.d").write "foo: foo.cpp\n"

    system "#{bin}/md", "-d", "-u", "Makefile", "foo.d"

    assert !File.exist?("foo.d")
    assert File.exist?("Makefile")
    assert_equal "# Dependencies for File: foo:\nfoo: foo.cpp\n",
      File.read("Makefile")
  end
end
