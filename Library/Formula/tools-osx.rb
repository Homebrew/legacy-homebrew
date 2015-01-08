class ToolsOsx < Formula
  homepage "https://github.com/morgant/tools-osx"
  url "https://github.com/morgant/tools-osx/archive/trash-0.5.2.tar.gz"
  sha1 "b2afec002c0f4c56e188ff8a020e7241b5919fb3"

  conflicts_with "osxutils", :because => "both install a trash binary"
  conflicts_with "trash", :because => "both install a trash binary"

  depends_on MaximumMacOSRequirement => :lion

  def install
    rake
    prefix.install_metafiles
    libexec.install "bin"
    # Remove `dict` script, which depends on the now-defunct MacRuby
    rm libexec/"bin"/"dict" if (libexec/"bin"/"dict").exist?
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    touch "testfile"
    system "#{bin}/trash", "testfile"
    assert_equal "", `/usr/bin/find . -name testfile`
  end
end
