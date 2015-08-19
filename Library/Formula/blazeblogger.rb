class Blazeblogger < Formula
  desc "CMS for the command-line"
  homepage "http://blaze.blackened.cz/"
  url "https://blazeblogger.googlecode.com/files/blazeblogger-1.2.0.tar.gz"
  sha256 "39024b70708be6073e8aeb3943eb3b73d441fbb7b8113e145c0cf7540c4921aa"

  bottle do
    cellar :any
    sha1 "2576ceff864dd2059bcd73af26f735725dd7274c" => :yosemite
    sha1 "068b94d384d5820938c4561df7357ae116bf23c4" => :mavericks
    sha1 "da491de4ea179354dcb8345b244d36fec30c0c6a" => :mountain_lion
  end

  def install
    # https://code.google.com/p/blazeblogger/issues/detail?id=51
    ENV.deparallelize
    system "make", "prefix=#{prefix}", "compdir=#{prefix}", "install"
  end

  test do
    system bin/"blaze", "init"
    system bin/"blaze", "config", "blog.title", "Homebrew!"
    system bin/"blaze", "make"
    assert File.exist? "default.css"
    assert File.read(".blaze/config").include?("Homebrew!")
  end
end
