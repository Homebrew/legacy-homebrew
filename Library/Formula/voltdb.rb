require 'formula'

class Voltdb < Formula
  homepage 'https://github.com/VoltDB/voltdb'
  head 'https://github.com/VoltDB/voltdb.git'
  url 'https://github.com/VoltDB/voltdb/archive/voltdb-3.5.tar.gz'
  sha1 'fb765f087e2faf95b8187182a88d4058f8bfa5e2'

  def install
    system 'ant'

    Dir['lib/*'].each do |f| libexec.install f end
    lib.install_symlink Dir["#{libexec}/*"]
    prefix.install 'bin', 'tools', 'voltdb', 'version.txt', 'doc'
  end

  test do
    assert_equal "3.5\n", File.read("#{prefix}/version.txt")
  end
end
