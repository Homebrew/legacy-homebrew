class Ioke < Formula
  desc "Dynamic language targeted at virtual machines"
  homepage "https://ioke.org/"
  url "https://ioke.org/dist/ioke-P-ikj-0.4.0.tar.gz"
  sha256 "701d24d8a8d0901cde64f11c79605c21d43cafbfb2bdd86765b664df13daec7c"

  bottle :unneeded

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Point IOKE_HOME to libexec
    inreplace libexec/"bin/ioke" do |s|
      s.change_make_var! "IOKE_HOME", libexec
    end

    bin.install_symlink libexec/"bin/ioke",
                        libexec/"bin/ispec",
                        libexec/"bin/dokgen"
  end

  test do
    system "#{bin}/ioke", "-e", '"test" println'
  end
end
