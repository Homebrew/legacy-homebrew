class Linklint < Formula
  desc "Link checker and web site maintenance tool"
  homepage "http://linklint.org"
  url "http://linklint.org/download/linklint-2.3.5.tar.gz"
  sha256 "ecaee456a3c2d6a3bd18a580d6b09b6b7b825df3e59f900270fe3f84ec3ac9c7"

  devel do
    url "http://linklint.org/download/linklint-2.4.beta.tar.gz"
    sha256 "e06ba7aef6c34a80a71bf3e463ca8b470384ebfb16cedfba30219f8a56762d55"
  end

  def install
    mv "READ_ME.txt", "README" unless build.devel?

    # fix version number reported by linklint -version in beta
    # note, upstream is abandoned, so inreplace instead of patch
    inreplace "linklint-#{version}", "2.3.1", version if build.devel?

    doc.install "README"
    bin.install "linklint-#{version}" => "linklint"
  end

  test do
    (testpath/"index.html").write('<a href="/">Home</a>')
    system "#{bin}/linklint", "/"
  end
end
