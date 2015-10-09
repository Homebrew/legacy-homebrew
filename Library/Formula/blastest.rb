class Blastest < Formula
  desc "blas test"
  homepage "https://tds.xyz"
  url "https://gist.githubusercontent.com/tdsmith/345b08bb656ad54c1701/raw/c0d4e2b1362d43dad0760bcc1ec24e4b881683ef/blastest.c"
  sha256 "ea6a083d6bccbc94e503f00911e9abedb5e1b3a0ed80ad1e5077b80fd6f36b42"
  version "1.0"

  depends_on :blas

  def install
    ldflags    = BlasRequirement.ldflags(ENV["HOMEBREW_BLASLAPACK_LIB"],ENV["HOMEBREW_BLASLAPACK_NAMES"])
    ldflags   += " -pthread -lm"
    cflags     = BlasRequirement.cflags(ENV["HOMEBREW_BLASLAPACK_INC"])
    ohai "Full path: " + BlasRequirement.full_path(ENV["HOMEBREW_BLASLAPACK_LIB"],ENV["HOMEBREW_BLASLAPACK_NAMES"],";")
    system "#{ENV.cc} blastest.c #{cflags} -o blastest #{ldflags}"
    bin.install "blastest"
  end

  test do
    system bin/"blastest"
  end
end
