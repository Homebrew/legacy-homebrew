class Modman < Formula
  desc "Module deployment script geared towards Magento development"
  homepage "https://github.com/colinmollenhour/modman"
  url "https://github.com/colinmollenhour/modman/archive/1.12.tar.gz"
  sha256 "437547bb54f62101215038a678506e87b1e9d5a8f04eed68e0c823198dd0b6ec"

  def install
    bin.install "modman"
    bash_completion.install "bash_completion" => "modman.bash"
  end

  test do
    system "#{bin}/modman"
  end
end
