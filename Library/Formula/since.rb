class Since < Formula
  desc "Stateful tail: show changes to files since last check"
  homepage "http://welz.org.za/projects/since"
  url "http://welz.org.za/projects/since/since-1.1.tar.gz"
  sha256 "739b7f161f8a045c1dff184e0fc319417c5e2deb3c7339d323d4065f7a3d0f45"

  bottle do
    cellar :any
    sha256 "e92218f17ac1926f4651b3e70d3fe42d43b7024e1f10d0ab6f1c7c9dd6bad606" => :yosemite
    sha256 "bfd7889688facdf732cf0bf2bb8c7a917df71e80615a5f367468708437c0519e" => :mavericks
    sha256 "caf0a03558f329e8ae25927f2bfc5d6905c098ae73773edbbe2bec9d288d9235" => :mountain_lion
  end

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
