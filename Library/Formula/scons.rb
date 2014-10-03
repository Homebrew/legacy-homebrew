require "formula"

class Scons < Formula
  homepage "http://www.scons.org"
  url "https://downloads.sourceforge.net/scons/scons-2.3.4.tar.gz"
  sha1 "8c55f8c15221c1b3536a041d46056ddd7fa2d23a"

  bottle do
    cellar :any
    sha1 "323530df6b6e23d170463632987ae590cefdc3d4" => :mavericks
    sha1 "400392e896baa82a5f5971ecc1840847db0b86cb" => :mountain_lion
    sha1 "10ab4cd7d39a16e44fb2575c174d8a4139077ec5" => :lion
  end

  def install
    bin.mkpath # Script won't create this if it doesn't already exist
    man1.install gzip("scons-time.1", "scons.1", "sconsign.1")
    system "/usr/bin/python", "setup.py", "install",
             "--prefix=#{prefix}",
             "--standalone-lib",
             # SCons gets handsy with sys.path---`scons-local` is one place it
             # will look when all is said and done.
             "--install-lib=#{libexec}/scons-local",
             "--install-scripts=#{bin}",
             "--install-data=#{libexec}",
             "--no-version-script", "--no-install-man"

    # Re-root scripts to libexec so they can import SCons and symlink back into
    # bin. Similar tactics are used in the duplicity formula.
    bin.children.each do |p|
      mv p, "#{libexec}/#{p.basename}.py"
      bin.install_symlink "#{libexec}/#{p.basename}.py" => p.basename
    end
  end
end
