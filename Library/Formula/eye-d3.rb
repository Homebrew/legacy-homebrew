require "formula"

class EyeD3 < Formula
  desc "Work with ID3 metadata in .mp3 files"
  homepage "http://eyed3.nicfit.net/"
  url "http://eyed3.nicfit.net/releases/eyeD3-0.7.5.tgz"
  sha1 "bcfd0fe14f5fa40f29ca7e7133138a5112f3c270"

  bottle do
    cellar :any
    sha1 "fddbdc445f3d6f89f1c57dd656cef69263b9335d" => :mavericks
    sha1 "fe13d924e6d1f85922930784f3b3490a730de708" => :mountain_lion
    sha1 "6609a6784c0087a9d5d5a93d0e25298e5d233365" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  # Looking for documentation? Please submit a PR to build some!
  # See https://github.com/Homebrew/homebrew/issues/32770 for previous attempt.

  def install
    # Install in our prefix, not the first-in-the-path python site-packages dir.
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}"
    share.install "docs/plugins", "docs/api", "docs/cli.rst"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    touch "temp.mp3"
    system "#{bin}/eyeD3", "-a", "HomebrewYo", "-n", "37", "temp.mp3"
  end
end
