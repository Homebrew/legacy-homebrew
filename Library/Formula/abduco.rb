require "formula"

class Abduco < Formula
  homepage "http://www.brain-dump.org/projects/abduco"
  url "http://www.brain-dump.org/projects/abduco/abduco-0.2.tar.gz"
  sha1 "e3a706b782fcb18fd70076ff3550bfdb4829b2ec"
  head "git://repo.or.cz/abduco.git"

  bottle do
    cellar :any
    sha1 "dc3f05e32b87e67d3b9da26e199fb92de369794a" => :mavericks
    sha1 "1fe57b58b3cdac26a667f19ad25bf0c06dcbf1f0" => :mountain_lion
    sha1 "d7c559b7d1a696d8ca34934276f715461ee0ed33" => :lion
  end

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    result = shell_output("#{bin}/abduco -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match /^abduco-[0-9.]+ © 2013-\d{4} Marc André Tanner$/, result
  end
end
