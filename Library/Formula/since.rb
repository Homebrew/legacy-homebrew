class Since < Formula
  homepage "http://welz.org.za/projects/since"
  url "http://welz.org.za/projects/since/since-1.1.tar.gz"
  sha256 "739b7f161f8a045c1dff184e0fc319417c5e2deb3c7339d323d4065f7a3d0f45"

  def install
    bin.mkpath
    man1.mkpath
    system "make", "install", "prefix=#{prefix}", "INSTALL=install"
  end

  test do
    (testpath/"test").write <<-EOS.undent
      foo
      bar
    EOS
    system "#{bin}/since", "-z", "test"
    assert File.exist? ".since"
  end
end
