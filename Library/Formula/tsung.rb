class Tsung < Formula
  desc "Load testing for HTTP, PostgreSQL, Jabber, and others"
  homepage "http://tsung.erlang-projects.org/"
  url "http://tsung.erlang-projects.org/dist/tsung-1.6.0.tar.gz"
  sha256 "56846c3a90fd7037d9a76330cb8f3052238344491e2fe6ef1ebdb0b620eb3d84"

  head "https://github.com/processone/tsung.git"

  bottle do
    sha256 "a4d0f870f04ae0683f4647123c5c3e94e39fd0bcf97edaa98dd2a4a4aa4dca33" => :yosemite
    sha256 "bea0124e4ec1626cd6f49a1cee650dedcd11602ca820a1764f2862e7b7341288" => :mavericks
    sha256 "1fe31187fd7662216c1a879bb62302a638834220e84becf8a1ab182df45c3d14" => :mountain_lion
  end

  depends_on "erlang"
  depends_on "gnuplot"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system bin/"tsung", "status"
  end
end
