class Bashmarks < Formula
  homepage "http://www.huyng.com/projects/bashmarks/"
  url "https://github.com/huyng/bashmarks.git"
  sha1 "52a23777261df39cfca9723331c578b41cb38cf9"
  version "1.0"

  depends_on "zsh" => :optional
  depends_on "bash" => :optional

  def install
    libexec.install "bashmarks.sh"
    chmod 0600, "#{libexec}/bashmarks.sh"
  end

  def caveats
    <<-EOS.undent
      Please add 'source #{libexec}/bashmarks.sh' to your .bashrc file
    EOS
  end

  test do
    output = %x(
      source #{libexec}/bashmarks.sh
      cd #{libexec}
      s libexec_bashmarks
      l
    ).strip
    assert_match /libexec\_bashmarks\s+.*\s+#{libexec}/, output
  end
end
