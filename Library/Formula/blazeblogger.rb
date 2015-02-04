class Blazeblogger < Formula
  homepage "http://blaze.blackened.cz/"
  url "https://blazeblogger.googlecode.com/files/blazeblogger-1.2.0.tar.gz"
  sha1 "280894fca6594d0c0df925aa0a16b9116ee19f17"

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
