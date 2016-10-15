require "formula"

class Ry < Formula
  homepage "https://github.com/jayferd/ry"
  url "https://github.com/jayferd/ry/archive/v0.5.2.tar.gz"
  sha1 "1c44fa222911b5b3fdb806fa97752b16404aae0f"

  head "https://github.com/jayferd/ry.git"

  depends_on "ruby-build" => :recommended
  depends_on "bash-completion" => :recommended

  def install
    ENV["PREFIX"] = prefix
    ENV["BASH_COMPLETIONS_DIR"] = etc/"bash_completion.d"
    ENV["ZSH_COMPLETIONS_DIR"] = share/"zsh/site-functions"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Please add to your profile:
      which ry &>/dev/null && eval "$(ry setup)"
    EOS
  end

  test do
    system bin/"ry", "ls"
  end
end
