class Irods < Formula
  desc "Integrated data grid software solution"
  homepage "https://www.irods.org"
  url "https://github.com/irods/irods-legacy/archive/3.3.1.tar.gz"
  sha256 "e34e7be8646317d5be1c84e680d8f59d50a223ea25a3c9717b6bf7b57df5b9f6"

  conflicts_with "sleuthkit", :because => "both install `ils`"

  option "with-osxfuse", "Install iRODS FUSE client"

  depends_on :osxfuse => :optional

  def install
    chdir "iRODS"
    system "./scripts/configure"

    # include PAM authentication by default
    inreplace "config/config.mk", "# PAM_AUTH = 1", "PAM_AUTH = 1"
    inreplace "config/config.mk", "# USE_SSL = 1", "USE_SSL = 1"

    system "make"

    bin.install Dir["clients/icommands/bin/*"].select { |f| File.executable? f }

    # patch in order to use osxfuse
    if build.with? "osxfuse"
      inreplace "config/config.mk", "# IRODS_FS = 1", "IRODS_FS = 1"
      inreplace "config/config.mk", "fuseHomeDir=/home/mwan/adil/fuse-2.7.0", "fuseHomeDir=#{HOMEBREW_PREFIX}"
      chdir "clients/fuse" do
        inreplace "Makefile", "lfuse", "losxfuse"
        inreplace "Makefile", "-I$(fuseHomeDir)/include", "-I$(fuseHomeDir)/include/osxfuse"
        system "make"
      end
      bin.install Dir["clients/fuse/bin/*"].select { |f| File.executable? f }
    end
  end

  test do
    system "#{bin}/ipwd"
  end
end
