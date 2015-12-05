class Blazeblogger < Formula
  desc "CMS for the command-line"
  homepage "http://blaze.blackened.cz/"
  url "https://blazeblogger.googlecode.com/files/blazeblogger-1.2.0.tar.gz"
  sha256 "39024b70708be6073e8aeb3943eb3b73d441fbb7b8113e145c0cf7540c4921aa"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "0d6bf439fa6f880cb9457581da66082f49f514f8b0fd4b57ac81180948aaa5e1" => :el_capitan
    sha256 "bac92237da25ffb0b9b31bd78fea353bf717cfb6f1381fbb0df333f555fbab91" => :yosemite
    sha256 "d48ad0f2ce8de2cf98f111a491e47136debbd0e585ff20b9978eb00349e454b3" => :mavericks
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
    assert_match "Homebrew!", File.read(".blaze/config")
  end
end
