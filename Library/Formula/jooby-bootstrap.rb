require "formula"

class JoobyBootstrap < Formula
  homepage "https://github.com/jooby-project/jooby-bootstrap"
  url "https://github.com/jooby-project/jooby-bootstrap/archive/0.2.2.tar.gz"
  sha1 "54802aa2a7bad6a07f25fc4d1dc35767c3525deb"

  depends_on :java => "1.8"
  depends_on "maven"

  def install
    bin.install "jooby"
  end

  test do
    system "#{bin}/jooby", "version"
  end
end
