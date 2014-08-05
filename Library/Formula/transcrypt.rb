require "formula"

class Transcrypt < Formula
  homepage "https://github.com/elasticdog/transcrypt#readme"
  url "https://github.com/elasticdog/transcrypt/archive/v0.9.4.tar.gz"
  sha1 "e791a1a32aabac7d92b01d0448fa2cf22eb965fc"
  head "https://github.com/elasticdog/transcrypt.git"

  def install
    bin.install "transcrypt"
    man.install "man/transcrypt.1"
    bash_completion.install "contrib/bash/transcrypt"
    zsh_completion.install "contrib/zsh/_transcrypt"
  end

  test do
    system "git", "init"
    system bin/"transcrypt",
               "--password", "guest", # arbitrary fixed password
               "--yes" # accept defaults for everything else

    # We use `atomic_write` to overwrite the `.gitattributes` file
    # that `transcrypt` creates as a template for the user.
    (testpath/".gitattributes").atomic_write <<-EOS.undent
      sensitive_file  filter=crypt diff=crypt
    EOS

    (testpath/"sensitive_file").write "secrets"
    system "git", "add", ".gitattributes", "sensitive_file"
    system "git", "commit", "--message", "Add encrypted version of a sensitive file"

    # According to the README: "you can validate that files are
    # encrypted as expected by viewing them in their raw form"
    assert_equal `git show HEAD:sensitive_file --no-textconv`.chomp,
                 "U2FsdGVkX1/BC5TmOtJ9kCgCq4EmYX0crGU7mAIhDEA="
  end
end
