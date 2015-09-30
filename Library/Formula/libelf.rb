class Libelf < Formula
  desc "ELF object file access library"
  homepage "http://www.mr511.de/software/"
  url "http://www.mr511.de/software/libelf-0.8.13.tar.gz"
  sha256 "591a9b4ec81c1f2042a97aa60564e0cb79d041c52faa7416acb38bc95bd2c76d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a06b058c7e401942f442f573b63aa2cdd548b45d38b02b7af92393c67093f56e" => :el_capitan
    sha256 "3b4ea9ab20228d9e912f80a330b6d6d093f9bb65a712208c83cd49bdcc4fc9ea" => :yosemite
    sha256 "eded3b774d412e533f37bc6d5dc133859141653ce953a0d4cbf4a950dda633f6" => :mavericks
    sha256 "d803c689354640948ae3699672d8172b770fdd8a63ba1d84e93131f394822bd5" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-compat"
    # Use separate steps; there is a race in the Makefile.
    system "make"
    system "make", "install"
  end
end
