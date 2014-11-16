require "formula"

class Unoconv < Formula
  homepage "http://dag.wiee.rs/home-made/unoconv/"
  url "http://dag.wieers.com/home-made/unoconv/unoconv-0.6.tar.gz"
  sha1 "d6c3574639b9ceedcb866b84f18ba7158f25db48"
  head "https://github.com/dagwieers/unoconv.git"

  bottle do
    cellar :any
    sha1 "4ae0238f6c54e8b6523e41ee3cfb14df806314ec" => :mavericks
    sha1 "35a5ef6df4295401ad8eec3f1c596a16c7fd5b9f" => :mountain_lion
    sha1 "efb91243d063ee7e45b5687ea71ea59e31e28c0e" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    In order to use unoconv LibreOffice 3.6.0.1 or later must be installed.
    EOS
  end
end
