class FseventWatch < Formula
  homepage "https://github.com/proger/fsevent_watch"
  url "https://github.com/proger/fsevent_watch/archive/v0.1.tar.gz"
  sha256 "260979f856a61230e03ca1f498c590dd739fd51aba9fa36b55e9cae776dcffe3"

  head "https://github.com/proger/fsevent_watch.git"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}", "CFLAGS=-DCLI_VERSION=\\\"#{version}\\\""
  end

  test do
    system "fsevent_watch", "--version"
  end
end
